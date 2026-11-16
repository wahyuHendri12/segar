import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/remote/open_food_facts_service.dart';

void main() {
  group('parseOpenFoodFacts', () {
    test('maps a found product and parses the pack size', () {
      final lookup = parseOpenFoodFacts(<String, dynamic>{
        'status': 1,
        'product': <String, dynamic>{
          'product_name_id': 'Susu UHT Cokelat',
          'brands': 'Segar Dairy',
          'categories': 'Minuman, Susu',
          'categories_tags': <String>['en:dairies', 'en:milks'],
          'quantity': '1 L',
        },
      }, barcode: '899-1002-101234');

      expect(lookup, isNotNull);
      expect(lookup!.name, 'Susu UHT Cokelat');
      expect(lookup.brand, 'Segar Dairy');
      expect(lookup.category, IngredientCategory.telurSusu);
      expect(lookup.quantityText, '1 L');
      expect(lookup.quantity, 1);
      expect(lookup.unit, Unit.liter);
      expect(lookup.barcode, '8991002101234');
      expect(lookup.source, BarcodeSource.off);
    });

    test('falls back to the English name and numeric quantity', () {
      final lookup = parseOpenFoodFacts(<String, dynamic>{
        'status': 1,
        'product': <String, dynamic>{
          'product_name': '',
          'product_name_en': 'Rice Noodles',
          'product_quantity': 85,
          'product_quantity_unit': 'g',
        },
      }, barcode: '12345678');

      expect(lookup, isNotNull);
      expect(lookup!.name, 'Rice Noodles');
      expect(lookup.category, IngredientCategory.bahanKering);
      expect(lookup.quantityText, '85 g');
      expect(lookup.quantity, 85);
      expect(lookup.unit, Unit.gram);
    });

    test('returns null when the product is missing or has no name', () {
      expect(
        parseOpenFoodFacts(<String, dynamic>{'status': 0}, barcode: '12345678'),
        isNull,
      );
      expect(
        parseOpenFoodFacts(<String, dynamic>{
          'status': 1,
          'product': <String, dynamic>{'brands': 'Tanpa Nama'},
        }, barcode: '12345678'),
        isNull,
      );
      expect(
        parseOpenFoodFacts(<String, dynamic>{'status': 1}, barcode: '12345678'),
        isNull,
      );
    });
  });
}
