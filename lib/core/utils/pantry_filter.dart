import '../../data/local/enums.dart';
import '../../data/models/pantry_item_view.dart';

/// Active filter, search and sort state for the home list.
class PantryFilterState {
  const PantryFilterState({
    this.location,
    this.query = '',
    this.sort = PantrySort.expiryAsc,
  });

  final StorageLocation? location;
  final String query;
  final PantrySort sort;

  bool get hasFilters =>
      location != null ||
      query.trim().isNotEmpty ||
      sort != PantrySort.expiryAsc;

  PantryFilterState copyWith({
    StorageLocation? location,
    bool clearLocation = false,
    String? query,
    PantrySort? sort,
  }) {
    return PantryFilterState(
      location: clearLocation ? null : (location ?? this.location),
      query: query ?? this.query,
      sort: sort ?? this.sort,
    );
  }
}

/// Applies the home filter, search and sort rules in one testable place.
List<PantryItemView> filterPantryItems(
  List<PantryItemView> items,
  PantryFilterState filter,
) {
  final normalizedQuery = filter.query.trim().toLowerCase();

  final filtered = items.where((item) {
    if (filter.location != null && item.storageLocation != filter.location) {
      return false;
    }
    if (normalizedQuery.isEmpty) return true;
    return item.name.toLowerCase().contains(normalizedQuery);
  }).toList();

  filtered.sort((a, b) {
    switch (filter.sort) {
      case PantrySort.expiryAsc:
        final byExpiry = a.expiryDate.compareTo(b.expiryDate);
        return byExpiry != 0 ? byExpiry : a.name.compareTo(b.name);
      case PantrySort.nameAsc:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case PantrySort.newest:
        return b.createdAt.compareTo(a.createdAt);
    }
  });

  return filtered;
}

/// Counts used by the status tiles and location filter chips.
class PantrySummary {
  const PantrySummary({
    required this.total,
    required this.soon,
    required this.safe,
    required this.expired,
    required this.byLocation,
  });

  final int total;
  final int soon;
  final int safe;
  final int expired;
  final Map<StorageLocation, int> byLocation;

  int countFor(StorageLocation? location) {
    return location == null ? total : (byLocation[location] ?? 0);
  }
}

PantrySummary summarizePantry(List<PantryItemView> items) {
  var soon = 0;
  var safe = 0;
  var expired = 0;
  final byLocation = <StorageLocation, int>{};

  for (final item in items) {
    byLocation.update(
      item.storageLocation,
      (value) => value + 1,
      ifAbsent: () => 1,
    );

    switch (item.expiryStatus) {
      case ExpiryStatus.aman:
        safe++;
      case ExpiryStatus.hampirBasi:
      case ExpiryStatus.basiHariIni:
        soon++;
      case ExpiryStatus.sudahBasi:
        expired++;
    }
  }

  return PantrySummary(
    total: items.length,
    soon: soon,
    safe: safe,
    expired: expired,
    byLocation: byLocation,
  );
}

/// Items grouped into the three sections shown on the home screen.
class PantryGroups {
  const PantryGroups({
    required this.urgent,
    required this.expired,
    required this.safe,
  });

  final List<PantryItemView> urgent;
  final List<PantryItemView> expired;
  final List<PantryItemView> safe;

  bool get isEmpty => urgent.isEmpty && expired.isEmpty && safe.isEmpty;
}

PantryGroups groupPantryItems(List<PantryItemView> items) {
  final urgent = <PantryItemView>[];
  final expired = <PantryItemView>[];
  final safe = <PantryItemView>[];

  for (final item in items) {
    switch (item.expiryStatus) {
      case ExpiryStatus.hampirBasi:
      case ExpiryStatus.basiHariIni:
        urgent.add(item);
      case ExpiryStatus.sudahBasi:
        expired.add(item);
      case ExpiryStatus.aman:
        safe.add(item);
    }
  }

  return PantryGroups(urgent: urgent, expired: expired, safe: safe);
}
