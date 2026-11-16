import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/barcode_utils.dart';
import 'package:segar/data/local/enums.dart';

void main() {
  group('normalizeBarcode', () {
    test('keeps digits only', () {
      expect(normalizeBarcode('899-1002 101234'), '8991002101234');
      expect(normalizeBarcode('  0012345678905  '), '0012345678905');
      expect(normalizeBarcode('abc'), '');
    });
  });

  group('isValidBarcode', () {
    test('accepts EAN-8 through ITF-14', () {
      expect(isValidBarcode('12345678'), isTrue);
      expect(isValidBarcode('8991002101234'), isTrue);
      expect(isValidBarcode('12345678901234'), isTrue);
    });

    test('rejects too short, too long and non numeric values', () {
      expect(isValidBarcode('1234567'), isFalse);
      expect(isValidBarcode('123456789012345'), isFalse);
      expect(isValidBarcode('1234abcd'), isFalse);
    });
  });

  group('guessCategory', () {
    test('matches Indonesian and English keywords', () {
      expect(
        guessCategory(name: 'Susu UHT Cokelat'),
        IngredientCategory.telurSusu,
      );
      expect(
        guessCategory(categories: 'en:seafoods', name: 'Tuna Kaleng'),
        IngredientCategory.ikanSeafood,
      );
      expect(
        guessCategory(categories: 'en:fresh-vegetables', name: 'Bayam'),
        IngredientCategory.sayur,
      );
      expect(
        guessCategory(name: 'Keripik Singkong'),
        IngredientCategory.makananOlahan,
      );
    });

    test('falls back to lainnya for unknown products', () {
      expect(
        guessCategory(name: 'Produk Misterius'),
        IngredientCategory.lainnya,
      );
      expect(guessCategory(), IngredientCategory.lainnya);
    });
  });

  group('parsePackQuantity', () {
    test('parses common Indonesian and metric pack sizes', () {
      expect(parsePackQuantity('500 g'), (quantity: 500.0, unit: Unit.gram));
      expect(parsePackQuantity('1,5 L'), (quantity: 1.5, unit: Unit.liter));
      expect(parsePackQuantity('250ml'), (quantity: 250.0, unit: Unit.ml));
      expect(parsePackQuantity('1 kg'), (quantity: 1.0, unit: Unit.kg));
      expect(parsePackQuantity('6 butir'), (quantity: 6.0, unit: Unit.butir));
      expect(parsePackQuantity('2 bungkus'), (
        quantity: 2.0,
        unit: Unit.bungkus,
      ));
    });

    test('reads the per-piece size from multipacks', () {
      expect(parsePackQuantity('2 x 250 ml'), (quantity: 250.0, unit: Unit.ml));
    });

    test('returns null when there is no recognised unit', () {
      expect(parsePackQuantity(null), isNull);
      expect(parsePackQuantity('ukuran keluarga'), isNull);
      expect(parsePackQuantity('0 g'), isNull);
    });
  });
}
