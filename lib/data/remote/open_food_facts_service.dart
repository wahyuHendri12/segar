import 'package:dio/dio.dart';

import '../../core/utils/barcode_utils.dart';
import '../local/enums.dart';
import '../models/barcode_lookup.dart';

/// Network boundary for barcode lookups.
abstract class BarcodeRemoteSource {
  /// Returns `null` when the barcode is unknown to the provider.
  Future<BarcodeLookup?> fetch(String barcode);
}

/// Thin Open Food Facts client.
///
/// Only the barcode is sent, and only when the user explicitly asks for a
/// lookup.
class OpenFoodFactsSource implements BarcodeRemoteSource {
  OpenFoodFactsSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              headers: const <String, String>{
                'User-Agent': 'Segar/1.0 (Flutter; pantry companion app)',
              },
            ),
          );

  static const _fields =
      'product_name,product_name_id,product_name_en,generic_name,brands,'
      'categories,categories_tags,quantity,product_quantity,'
      'product_quantity_unit';

  final Dio _dio;

  @override
  Future<BarcodeLookup?> fetch(String barcode) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://world.openfoodfacts.org/api/v2/product/$barcode.json',
        queryParameters: <String, String>{'fields': _fields},
      );
      final data = response.data;
      if (data == null) return null;
      return parseOpenFoodFacts(data, barcode: barcode);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}

/// Pure parser for the Open Food Facts v2 product response.
BarcodeLookup? parseOpenFoodFacts(
  Map<String, dynamic> json, {
  required String barcode,
}) {
  final status = json['status'];
  if (status is num && status == 0) return null;

  final rawProduct = json['product'];
  if (rawProduct is! Map) return null;
  final product = Map<String, dynamic>.from(rawProduct);

  final name = _firstText(<Object?>[
    product['product_name_id'],
    product['product_name'],
    product['generic_name'],
    product['product_name_en'],
  ]);
  if (name == null) return null;

  final brand = _firstText(<Object?>[product['brands']]);
  final categories = _categoryText(product);
  final quantityText = _packText(product);
  final pack = parsePackQuantity(quantityText);

  return BarcodeLookup(
    barcode: normalizeBarcode(barcode),
    name: name,
    brand: brand,
    category: guessCategory(categories: categories, name: name),
    quantityText: quantityText,
    quantity: pack?.quantity,
    unit: pack?.unit,
    source: BarcodeSource.off,
  );
}

String? _packText(Map<String, dynamic> product) {
  final quantity = _firstText(<Object?>[product['quantity']]);
  if (quantity != null) return quantity;

  final amount = product['product_quantity'];
  if (amount is num) {
    final unit = _firstText(<Object?>[product['product_quantity_unit']]);
    return unit == null ? '$amount' : '$amount $unit';
  }
  return null;
}

String _categoryText(Map<String, dynamic> product) {
  final parts = <String>[];
  final categories = _firstText(<Object?>[product['categories']]);
  if (categories != null) parts.add(categories);

  final tags = product['categories_tags'];
  if (tags is List) {
    for (final tag in tags) {
      final text = _firstText(<Object?>[tag]);
      if (text != null) parts.add(text);
    }
  }
  return parts.join(' ');
}

String? _firstText(List<Object?> values) {
  for (final value in values) {
    final text = value?.toString().trim();
    if (text != null && text.isNotEmpty) return text;
  }
  return null;
}
