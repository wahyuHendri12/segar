import '../local/enums.dart';

/// Product information resolved from a barcode.
///
/// Used both for fresh Open Food Facts lookups and for locally remembered
/// mappings, so the add-item form can prefill itself the same way.
class BarcodeLookup {
  const BarcodeLookup({
    required this.barcode,
    required this.name,
    required this.category,
    this.brand,
    this.quantityText,
    this.quantity,
    this.unit,
    this.source = BarcodeSource.off,
  });

  final String barcode;
  final String name;
  final String? brand;
  final IngredientCategory category;

  /// Raw pack size text such as `500 g`.
  final String? quantityText;

  /// Parsed pack size, when the text contained a recognised unit.
  final double? quantity;
  final Unit? unit;
  final BarcodeSource source;

  String get displayName {
    final trimmedBrand = brand?.trim();
    if (trimmedBrand == null || trimmedBrand.isEmpty) return name;
    return '$name · $trimmedBrand';
  }
}
