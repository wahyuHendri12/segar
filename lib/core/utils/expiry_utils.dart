import '../../data/local/enums.dart';

/// Returns a date-only value in the device's local timezone.
DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Whole-day difference between [expiry] and [now], using local calendar days.
int daysUntilExpiry(DateTime expiry, {DateTime? now}) {
  final today = dateOnly(now ?? DateTime.now());
  return dateOnly(expiry).difference(today).inDays;
}

/// The core freshness rule from the Segar specification.
ExpiryStatus statusFor(DateTime expiry, {DateTime? now, int warnDays = 3}) {
  final days = daysUntilExpiry(expiry, now: now);
  if (days < 0) return ExpiryStatus.sudahBasi;
  if (days == 0) return ExpiryStatus.basiHariIni;
  if (days <= warnDays) return ExpiryStatus.hampirBasi;
  return ExpiryStatus.aman;
}

/// Human-readable Indonesian label.
///
/// UI screens should prefer ARB strings; this helper is used by tests,
/// notifications and other non-widget code.
String expiryLabel(DateTime expiry, {DateTime? now, int warnDays = 3}) {
  final days = daysUntilExpiry(expiry, now: now);
  if (days < 0) {
    final past = days.abs();
    return past == 1 ? 'Basi 1 hari lalu' : 'Basi $past hari lalu';
  }
  if (days == 0) return 'Basi hari ini';
  if (days <= warnDays) {
    return days == 1 ? 'Basi 1 hari lagi' : 'Basi $days hari lagi';
  }
  return '$days hari lagi';
}

/// Estimated expiry date from the purchase date and the shelf life for the
/// selected storage location.
///
/// When [shelfLifeDays] is null (not recommended for that location) the
/// specification's 7-day fallback is used.
DateTime estimateExpiryDate({
  required DateTime purchaseDate,
  required int? shelfLifeDays,
  int fallbackDays = 7,
}) {
  final days = shelfLifeDays ?? fallbackDays;
  return dateOnly(purchaseDate).add(Duration(days: days));
}

/// The catalog shelf-life lookup, expressed as a pure helper so repositories
/// and tests share exactly the same mapping.
int? shelfLifeForLocation(
  IngredientCatalogShelfLife shelfLife,
  StorageLocation location,
) {
  return switch (location) {
    StorageLocation.kulkas => shelfLife.kulkas,
    StorageLocation.freezer => shelfLife.freezer,
    StorageLocation.lemari => shelfLife.lemari,
    StorageLocation.suhuRuang => shelfLife.suhuRuang,
  };
}

/// Small value object used by [shelfLifeForLocation] without depending on the
/// Drift row class.
class IngredientCatalogShelfLife {
  const IngredientCatalogShelfLife({
    this.kulkas,
    this.freezer,
    this.lemari,
    this.suhuRuang,
  });

  final int? kulkas;
  final int? freezer;
  final int? lemari;
  final int? suhuRuang;
}
