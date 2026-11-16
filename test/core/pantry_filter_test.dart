import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/pantry_filter.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/pantry_item_view.dart';

PantryItemView _item({
  required String id,
  required String name,
  StorageLocation location = StorageLocation.kulkas,
  ExpiryStatus status = ExpiryStatus.aman,
  int daysLeft = 10,
  DateTime? expiryDate,
  DateTime? createdAt,
}) {
  final created = createdAt ?? DateTime(2026, 11, 1);
  return PantryItemView(
    id: id,
    name: name,
    emoji: '🥗',
    category: IngredientCategory.sayur,
    quantity: 1,
    unit: Unit.pcs,
    storageLocation: location,
    purchaseDate: DateTime(2026, 11, 1),
    expiryDate: expiryDate ?? DateTime(2026, 11, 20),
    expirySource: ExpirySource.estimasi,
    notifyEnabled: true,
    status: PantryStatus.aktif,
    createdAt: created,
    updatedAt: created,
    expiryStatus: status,
    daysLeft: daysLeft,
  );
}

void main() {
  final items = <PantryItemView>[
    _item(
      id: 'a',
      name: 'Bayam',
      location: StorageLocation.kulkas,
      status: ExpiryStatus.hampirBasi,
      daysLeft: 2,
      expiryDate: DateTime(2026, 11, 12),
      createdAt: DateTime(2026, 11, 3),
    ),
    _item(
      id: 'b',
      name: 'Tempe',
      location: StorageLocation.kulkas,
      status: ExpiryStatus.basiHariIni,
      daysLeft: 0,
      expiryDate: DateTime(2026, 11, 10),
      createdAt: DateTime(2026, 11, 2),
    ),
    _item(
      id: 'c',
      name: 'Ayam',
      location: StorageLocation.freezer,
      status: ExpiryStatus.sudahBasi,
      daysLeft: -2,
      expiryDate: DateTime(2026, 11, 8),
      createdAt: DateTime(2026, 11, 5),
    ),
    _item(
      id: 'd',
      name: 'Beras',
      location: StorageLocation.lemari,
      status: ExpiryStatus.aman,
      daysLeft: 30,
      expiryDate: DateTime(2026, 12, 10),
      createdAt: DateTime(2026, 11, 4),
    ),
  ];

  group('filterPantryItems', () {
    test('filters by storage location', () {
      final result = filterPantryItems(
        items,
        const PantryFilterState(location: StorageLocation.kulkas),
      );
      expect(result.map((item) => item.id), <String>['b', 'a']);
    });

    test('search is case-insensitive and trims the query', () {
      final result = filterPantryItems(
        items,
        const PantryFilterState(query: '  TEM '),
      );
      expect(result.map((item) => item.id), <String>['b']);
    });

    test('sorts by expiry ascending then name', () {
      final result = filterPantryItems(items, const PantryFilterState());
      expect(result.map((item) => item.id), <String>['c', 'b', 'a', 'd']);
    });

    test('sorts by name ascending', () {
      final result = filterPantryItems(
        items,
        const PantryFilterState(sort: PantrySort.nameAsc),
      );
      expect(result.map((item) => item.name), <String>[
        'Ayam',
        'Bayam',
        'Beras',
        'Tempe',
      ]);
    });

    test('sorts newest first', () {
      final result = filterPantryItems(
        items,
        const PantryFilterState(sort: PantrySort.newest),
      );
      expect(result.map((item) => item.id), <String>['c', 'd', 'a', 'b']);
    });

    test('combines location and search filters', () {
      final result = filterPantryItems(
        items,
        const PantryFilterState(location: StorageLocation.kulkas, query: 'bay'),
      );
      expect(result.map((item) => item.id), <String>['a']);
    });
  });

  group('PantryFilterState', () {
    test('hasFilters reflects non-default state', () {
      expect(const PantryFilterState().hasFilters, isFalse);
      expect(
        const PantryFilterState(location: StorageLocation.kulkas).hasFilters,
        isTrue,
      );
      expect(const PantryFilterState(query: 'x').hasFilters, isTrue);
      expect(
        const PantryFilterState(sort: PantrySort.newest).hasFilters,
        isTrue,
      );
    });

    test('copyWith can clear the location', () {
      const state = PantryFilterState(location: StorageLocation.kulkas);
      expect(state.copyWith(clearLocation: true).location, isNull);
      expect(state.copyWith().location, StorageLocation.kulkas);
    });
  });

  group('summarizePantry', () {
    test('counts statuses and locations', () {
      final summary = summarizePantry(items);
      expect(summary.total, 4);
      expect(summary.soon, 2);
      expect(summary.safe, 1);
      expect(summary.expired, 1);
      expect(summary.countFor(null), 4);
      expect(summary.countFor(StorageLocation.kulkas), 2);
      expect(summary.countFor(StorageLocation.freezer), 1);
      expect(summary.countFor(StorageLocation.suhuRuang), 0);
    });
  });

  group('groupPantryItems', () {
    test('splits items into urgent, expired and safe groups', () {
      final groups = groupPantryItems(items);
      expect(groups.urgent.map((item) => item.id), <String>['a', 'b']);
      expect(groups.expired.map((item) => item.id), <String>['c']);
      expect(groups.safe.map((item) => item.id), <String>['d']);
      expect(groups.isEmpty, isFalse);
    });

    test('empty list produces an empty grouping', () {
      expect(groupPantryItems(const <PantryItemView>[]).isEmpty, isTrue);
    });
  });
}
