import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/value_utils.dart';

void main() {
  group('processedValue', () {
    test('uses the user-entered price and marks it as exact', () {
      final result = processedValue(
        priceIdr: 20000,
        typicalPriceIdr: 15000,
        processedQuantity: 1,
        initialQuantity: 2,
      );

      expect(result.valueIdr, 10000);
      expect(result.isEstimate, isFalse);
    });

    test('falls back to the catalog price and marks it as an estimate', () {
      final result = processedValue(
        typicalPriceIdr: 15000,
        processedQuantity: 2,
        initialQuantity: 3,
      );

      expect(result.valueIdr, 10000);
      expect(result.isEstimate, isTrue);
    });

    test('returns zero when no price is known', () {
      final result = processedValue(processedQuantity: 1, initialQuantity: 1);

      expect(result.valueIdr, 0);
      expect(result.isEstimate, isFalse);
    });

    test('returns zero for invalid quantities', () {
      expect(
        processedValue(
          priceIdr: 10000,
          processedQuantity: 0,
          initialQuantity: 1,
        ).valueIdr,
        0,
      );
      expect(
        processedValue(
          priceIdr: 10000,
          processedQuantity: 1,
          initialQuantity: 0,
        ).valueIdr,
        0,
      );
    });

    test('never exceeds the total price', () {
      final result = processedValue(
        priceIdr: 10000,
        processedQuantity: 5,
        initialQuantity: 2,
      );

      expect(result.valueIdr, 10000);
    });
  });

  group('totalWeightGrams', () {
    test('prefers the explicit total weight', () {
      expect(
        totalWeightGrams(
          weightGrams: 500,
          quantity: 2,
          avgWeightPerUnitGrams: 300,
        ),
        500,
      );
    });

    test('multiplies quantity by the average unit weight', () {
      expect(totalWeightGrams(quantity: 2.5, avgWeightPerUnitGrams: 200), 500);
    });

    test('returns null without a weight source', () {
      expect(totalWeightGrams(quantity: 2), isNull);
    });

    test('returns zero when the quantity is zero', () {
      expect(totalWeightGrams(quantity: 0, avgWeightPerUnitGrams: 200), 0);
    });
  });

  group('processedWeightGrams', () {
    test('scales the item weight by the processed ratio', () {
      expect(
        processedWeightGrams(
          itemWeightGrams: 1000,
          processedQuantity: 1,
          initialQuantity: 4,
        ),
        250,
      );
    });

    test('uses the average unit weight as a fallback', () {
      expect(
        processedWeightGrams(
          processedQuantity: 2,
          initialQuantity: 2,
          avgWeightPerUnitGrams: 120,
        ),
        240,
      );
    });

    test('returns null without a weight source', () {
      expect(
        processedWeightGrams(processedQuantity: 1, initialQuantity: 1),
        isNull,
      );
    });

    test('returns zero for invalid quantities', () {
      expect(
        processedWeightGrams(
          itemWeightGrams: 100,
          processedQuantity: 0,
          initialQuantity: 1,
        ),
        0,
      );
    });
  });
}
