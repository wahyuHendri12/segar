import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/expiry_utils.dart';
import 'package:segar/data/local/enums.dart';

void main() {
  final now = DateTime(2026, 11, 9, 15, 30);

  group('dateOnly', () {
    test('drops the time component', () {
      expect(dateOnly(DateTime(2026, 11, 9, 23, 59)), DateTime(2026, 11, 9));
    });
  });

  group('daysUntilExpiry', () {
    test('uses calendar days, not hours', () {
      expect(daysUntilExpiry(DateTime(2026, 11, 10, 1), now: now), 1);
      expect(daysUntilExpiry(DateTime(2026, 11, 8, 23), now: now), -1);
    });
  });

  group('statusFor', () {
    test('marks past dates as sudahBasi', () {
      expect(
        statusFor(DateTime(2026, 11, 8), now: now),
        ExpiryStatus.sudahBasi,
      );
    });

    test('marks today as basiHariIni', () {
      expect(
        statusFor(DateTime(2026, 11, 9), now: now),
        ExpiryStatus.basiHariIni,
      );
    });

    test('marks the warning window as hampirBasi', () {
      expect(
        statusFor(DateTime(2026, 11, 12), now: now),
        ExpiryStatus.hampirBasi,
      );
      expect(
        statusFor(DateTime(2026, 11, 12), now: now, warnDays: 5),
        ExpiryStatus.hampirBasi,
      );
    });

    test('marks dates beyond the warning window as aman', () {
      expect(statusFor(DateTime(2026, 11, 13), now: now), ExpiryStatus.aman);
    });
  });

  group('expiryLabel', () {
    test('describes every status in Indonesian', () {
      expect(expiryLabel(DateTime(2026, 11, 8), now: now), 'Basi 1 hari lalu');
      expect(expiryLabel(DateTime(2026, 11, 5), now: now), 'Basi 4 hari lalu');
      expect(expiryLabel(DateTime(2026, 11, 9), now: now), 'Basi hari ini');
      expect(expiryLabel(DateTime(2026, 11, 10), now: now), 'Basi 1 hari lagi');
      expect(expiryLabel(DateTime(2026, 11, 12), now: now), 'Basi 3 hari lagi');
      expect(expiryLabel(DateTime(2026, 11, 20), now: now), '11 hari lagi');
    });
  });

  group('estimateExpiryDate', () {
    test('adds the shelf life to the purchase date', () {
      expect(
        estimateExpiryDate(
          purchaseDate: DateTime(2026, 11, 9, 20),
          shelfLifeDays: 3,
        ),
        DateTime(2026, 11, 12),
      );
    });

    test('falls back to seven days when the location is not recommended', () {
      expect(
        estimateExpiryDate(
          purchaseDate: DateTime(2026, 11, 9),
          shelfLifeDays: null,
        ),
        DateTime(2026, 11, 16),
      );
    });
  });

  group('shelfLifeForLocation', () {
    test('maps every storage location', () {
      const shelfLife = IngredientCatalogShelfLife(
        kulkas: 3,
        freezer: 30,
        lemari: 7,
        suhuRuang: 1,
      );

      expect(shelfLifeForLocation(shelfLife, StorageLocation.kulkas), 3);
      expect(shelfLifeForLocation(shelfLife, StorageLocation.freezer), 30);
      expect(shelfLifeForLocation(shelfLife, StorageLocation.lemari), 7);
      expect(shelfLifeForLocation(shelfLife, StorageLocation.suhuRuang), 1);
    });

    test('returns null for an unsupported location', () {
      const shelfLife = IngredientCatalogShelfLife(kulkas: 3);
      expect(shelfLifeForLocation(shelfLife, StorageLocation.freezer), isNull);
    });
  });
}
