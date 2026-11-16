import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 9, 10);

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('ShoppingListDao', () {
    test('adds items and keeps unchecked items first', () async {
      await db.shoppingListDao.addItem(
        name: 'Bayam',
        quantity: 2,
        unit: Unit.ikat,
        at: now,
      );
      final checkedId = await db.shoppingListDao.addItem(
        name: 'Tomat',
        source: ShoppingSource.habis,
        at: now,
      );
      await db.shoppingListDao.setChecked(checkedId, true);

      final items = await db.shoppingListDao.watchAll().first;

      expect(items.map((item) => item.name), <String>['Bayam', 'Tomat']);
      expect(items.last.isChecked, isTrue);
    });

    test('updates quantity, unit and checked state', () async {
      final id = await db.shoppingListDao.addItem(name: 'Bayam', at: now);

      await db.shoppingListDao.updateQuantity(id, 3, Unit.kg);
      await db.shoppingListDao.setChecked(id, true);

      final item = (await db.shoppingListDao.getAll()).single;
      expect(item.quantity, 3);
      expect(item.unit, Unit.kg);
      expect(item.isChecked, isTrue);
    });

    test('clears checked items only', () async {
      final first = await db.shoppingListDao.addItem(name: 'Bayam', at: now);
      await db.shoppingListDao.addItem(name: 'Tomat', at: now);
      await db.shoppingListDao.setChecked(first, true);

      await db.shoppingListDao.clearChecked();

      final items = await db.shoppingListDao.getAll();
      expect(items.map((item) => item.name), <String>['Tomat']);
    });

    test('deletes one item and clears everything', () async {
      final first = await db.shoppingListDao.addItem(name: 'Bayam', at: now);
      await db.shoppingListDao.addItem(name: 'Tomat', at: now);

      await db.shoppingListDao.deleteItem(first);
      expect(await db.shoppingListDao.getAll(), hasLength(1));

      await db.shoppingListDao.clearAll();
      expect(await db.shoppingListDao.getAll(), isEmpty);
    });
  });

  group('BarcodeCacheDao', () {
    test('stores, reads and purges cached barcodes', () async {
      await db.barcodeCacheDao.upsert(
        BarcodeCacheCompanion.insert(
          barcode: '899123',
          name: 'Susu',
          category: IngredientCategory.telurSusu,
          source: BarcodeSource.off,
          fetchedAt: now,
        ),
      );

      final entry = await db.barcodeCacheDao.getByBarcode('899123');
      expect(entry?.name, 'Susu');
      expect(entry?.category, IngredientCategory.telurSusu);

      expect(
        await db.barcodeCacheDao.purgeOlderThan(
          const Duration(days: 30),
          now: now.add(const Duration(days: 1)),
        ),
        0,
      );
      expect(
        await db.barcodeCacheDao.purgeOlderThan(
          const Duration(days: 30),
          now: now.add(const Duration(days: 31)),
        ),
        1,
      );
      expect(await db.barcodeCacheDao.getByBarcode('899123'), isNull);
    });
  });

  group('OnlineRecipeDao', () {
    test('stores and purges cached online recipes', () async {
      await db.onlineRecipeDao.upsert(
        CachedOnlineRecipesCompanion.insert(
          idMeal: '52772',
          json: '{"idMeal":"52772"}',
          fetchedAt: now,
        ),
      );

      expect(
        (await db.onlineRecipeDao.getByIdMeal('52772'))?.json,
        contains('52772'),
      );
      expect(
        await db.onlineRecipeDao.purgeOlderThan(
          const Duration(days: 14),
          now: now.add(const Duration(days: 15)),
        ),
        1,
      );
      expect(await db.onlineRecipeDao.getByIdMeal('52772'), isNull);
    });
  });

  group('UsageLogDao', () {
    test('reports the last waste and the most frequent reason', () async {
      await db.usageLogDao.insertLog(
        UsageLogsCompanion.insert(
          id: 'l1',
          pantryItemId: 'p1',
          action: UsageAction.dibuang,
          quantityChanged: 1,
          category: IngredientCategory.sayur,
          reasonWasted: const Value(WasteReason.basi),
          loggedAt: now,
        ),
      );
      await db.usageLogDao.insertLog(
        UsageLogsCompanion.insert(
          id: 'l2',
          pantryItemId: 'p2',
          action: UsageAction.dibuang,
          quantityChanged: 1,
          category: IngredientCategory.buah,
          reasonWasted: const Value(WasteReason.basi),
          loggedAt: now.add(const Duration(days: 1)),
        ),
      );
      await db.usageLogDao.insertLog(
        UsageLogsCompanion.insert(
          id: 'l3',
          pantryItemId: 'p3',
          action: UsageAction.dipakai,
          quantityChanged: 1,
          category: IngredientCategory.sayur,
          loggedAt: now.add(const Duration(days: 2)),
        ),
      );

      expect(
        await db.usageLogDao.lastWastedAt(),
        now.add(const Duration(days: 1)),
      );

      final reasons = await db.usageLogDao.wasteReasonCounts();
      expect(reasons.first.reason, WasteReason.basi);
      expect(reasons.first.count, 2);
    });

    test('filters usage logs by date range', () async {
      await db.usageLogDao.insertLog(
        UsageLogsCompanion.insert(
          id: 'l1',
          pantryItemId: 'p1',
          action: UsageAction.dipakai,
          quantityChanged: 1,
          category: IngredientCategory.sayur,
          loggedAt: now,
        ),
      );
      await db.usageLogDao.insertLog(
        UsageLogsCompanion.insert(
          id: 'l2',
          pantryItemId: 'p2',
          action: UsageAction.dipakai,
          quantityChanged: 1,
          category: IngredientCategory.sayur,
          loggedAt: now.add(const Duration(days: 10)),
        ),
      );

      final logs = await db.usageLogDao.getAll(
        from: now.add(const Duration(days: 5)),
      );
      expect(logs.map((log) => log.id), <String>['l2']);
    });
  });
}
