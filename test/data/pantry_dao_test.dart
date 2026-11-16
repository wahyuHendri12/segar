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

  Future<PantryItem> insertItem({
    required String id,
    String name = 'Bayam',
    double quantity = 1,
    int? weightGrams,
    DateTime? expiryDate,
    StorageLocation location = StorageLocation.kulkas,
    PantryStatus status = PantryStatus.aktif,
    DateTime? deletedAt,
  }) async {
    await db
        .into(db.pantryItems)
        .insert(
          PantryItemsCompanion.insert(
            id: id,
            name: name,
            category: IngredientCategory.sayur,
            quantity: quantity,
            unit: Unit.ikat,
            weightGrams: Value(weightGrams),
            storageLocation: location,
            purchaseDate: now,
            expiryDate: expiryDate ?? DateTime(2026, 11, 20),
            expirySource: ExpirySource.estimasi,
            status: Value(status),
            createdAt: now,
            updatedAt: now,
            deletedAt: Value(deletedAt),
          ),
        );
    return (await db.pantryDao.findById(id))!;
  }

  group('reads', () {
    test(
      'watchActive hides deleted and finished items and sorts by expiry',
      () async {
        await insertItem(id: 'later', expiryDate: DateTime(2026, 11, 15));
        await insertItem(id: 'sooner', expiryDate: DateTime(2026, 11, 11));
        await insertItem(id: 'deleted', deletedAt: DateTime(2026, 11, 8));
        await insertItem(id: 'used', status: PantryStatus.terpakai);
        await insertItem(id: 'wasted', status: PantryStatus.terbuang);

        final items = await db.pantryDao.watchActive().first;

        expect(items.map((item) => item.id), <String>['sooner', 'later']);
      },
    );

    test('filters by storage location', () async {
      await insertItem(id: 'fridge', location: StorageLocation.kulkas);
      await insertItem(id: 'freezer', location: StorageLocation.freezer);

      final items = await db.pantryDao
          .watchActive(location: StorageLocation.freezer)
          .first;

      expect(items.map((item) => item.id), <String>['freezer']);
    });

    test('searches names case-insensitively', () async {
      await insertItem(id: 'bayam', name: 'Bayam Hijau');
      await insertItem(id: 'tomat', name: 'Tomat Merah');

      final items = await db.pantryDao.watchActive(query: 'HIJAU').first;

      expect(items.map((item) => item.id), <String>['bayam']);
    });

    test('counts safe, soon and expired items', () async {
      await insertItem(id: 'safe', expiryDate: DateTime(2026, 11, 20));
      await insertItem(id: 'soon', expiryDate: DateTime(2026, 11, 11));
      await insertItem(id: 'today', expiryDate: DateTime(2026, 11, 9));
      await insertItem(id: 'expired', expiryDate: DateTime(2026, 11, 8));

      final counts = await db.pantryDao.watchStatusCounts(now: now).first;

      expect(counts.safe, 1);
      expect(counts.soon, 2);
      expect(counts.expired, 1);
      expect(counts.total, 4);
    });

    test('watchUrgent returns only items that are not safe', () async {
      await insertItem(id: 'safe', expiryDate: DateTime(2026, 11, 20));
      await insertItem(id: 'soon', expiryDate: DateTime(2026, 11, 11));
      await insertItem(id: 'expired', expiryDate: DateTime(2026, 11, 8));

      final items = await db.pantryDao.watchUrgent(now: now).first;

      expect(items.map((item) => item.id).toSet(), <String>{'soon', 'expired'});
    });
  });

  group('markUsed', () {
    test('updates the item and writes one usage log', () async {
      final item = await insertItem(id: 'a', quantity: 2, weightGrams: 400);

      final logId = await db.pantryDao.markUsed(
        item,
        valueIdr: 5000,
        isEstimate: false,
        weightGrams: 400,
        at: now,
      );

      final updated = (await db.pantryDao.findById('a'))!;
      expect(updated.status, PantryStatus.terpakai);
      expect(updated.statusChangedAt, now);
      expect(updated.updatedAt, now);

      final logs = await db.usageLogDao.getForItem('a');
      expect(logs, hasLength(1));
      expect(logs.single.id, logId);
      expect(logs.single.action, UsageAction.dipakai);
      expect(logs.single.quantityChanged, 2);
      expect(logs.single.valueIdr, 5000);
      expect(logs.single.isEstimate, isFalse);
      expect(logs.single.weightGrams, 400);
      expect(logs.single.category, IngredientCategory.sayur);
    });
  });

  group('markWasted', () {
    test('stores the waste reason', () async {
      final item = await insertItem(id: 'a');

      await db.pantryDao.markWasted(
        item,
        valueIdr: 3000,
        isEstimate: true,
        weightGrams: 200,
        reason: WasteReason.basi,
        at: now,
      );

      final updated = (await db.pantryDao.findById('a'))!;
      expect(updated.status, PantryStatus.terbuang);

      final logs = await db.usageLogDao.getForItem('a');
      expect(logs.single.action, UsageAction.dibuang);
      expect(logs.single.reasonWasted, WasteReason.basi);
      expect(logs.single.isEstimate, isTrue);
    });
  });

  group('markPartiallyUsed', () {
    test('reduces quantity and weight and keeps the item active', () async {
      final item = await insertItem(id: 'a', quantity: 4, weightGrams: 400);

      final logId = await db.pantryDao.markPartiallyUsed(
        item,
        usedQuantity: 1,
        valueIdr: 2500,
        isEstimate: false,
        weightGrams: 100,
        at: now,
      );

      final updated = (await db.pantryDao.findById('a'))!;
      expect(updated.quantity, 3);
      expect(updated.weightGrams, 300);
      expect(updated.status, PantryStatus.aktif);

      final logs = await db.usageLogDao.getForItem('a');
      expect(logs.single.id, logId);
      expect(logs.single.action, UsageAction.dikurangi);
      expect(logs.single.quantityChanged, 1);
    });

    test('finishes the item when nothing remains', () async {
      final item = await insertItem(id: 'a', quantity: 1, weightGrams: 100);

      await db.pantryDao.markPartiallyUsed(
        item,
        usedQuantity: 1,
        valueIdr: 5000,
        isEstimate: false,
        weightGrams: 100,
        at: now,
      );

      final updated = (await db.pantryDao.findById('a'))!;
      expect(updated.quantity, 0);
      expect(updated.status, PantryStatus.terpakai);

      final logs = await db.usageLogDao.getForItem('a');
      expect(logs.single.action, UsageAction.dipakai);
      expect(logs.single.quantityChanged, 1);
    });

    test('rejects a non-positive quantity without changing anything', () async {
      final item = await insertItem(id: 'a', quantity: 2);

      expect(
        () => db.pantryDao.markPartiallyUsed(
          item,
          usedQuantity: 0,
          valueIdr: 0,
          isEstimate: false,
          weightGrams: 0,
        ),
        throwsArgumentError,
      );

      final unchanged = (await db.pantryDao.findById('a'))!;
      expect(unchanged.quantity, 2);
      expect(unchanged.status, PantryStatus.aktif);
      expect(await db.usageLogDao.getForItem('a'), isEmpty);
    });
  });

  group('undoUsage', () {
    test('restores the item and removes the log', () async {
      final item = await insertItem(id: 'a');
      final logId = await db.pantryDao.markUsed(
        item,
        valueIdr: 5000,
        isEstimate: false,
        weightGrams: 200,
        at: now,
      );

      await db.pantryDao.undoUsage(
        usageLogId: logId,
        pantryItemId: 'a',
        at: now.add(const Duration(minutes: 1)),
      );

      final restored = (await db.pantryDao.findById('a'))!;
      expect(restored.status, PantryStatus.aktif);
      expect(restored.statusChangedAt, isNull);
      expect(await db.usageLogDao.getForItem('a'), isEmpty);
    });
  });

  group('edits', () {
    test('soft delete hides the item and restore brings it back', () async {
      await insertItem(id: 'a');

      await db.pantryDao.softDelete('a', at: now);
      expect(await db.pantryDao.watchActive().first, isEmpty);

      await db.pantryDao.restore('a', at: now);
      expect(
        (await db.pantryDao.watchActive().first).map((item) => item.id),
        <String>['a'],
      );
    });

    test('extendExpiry switches the source to manual', () async {
      await insertItem(id: 'a');

      await db.pantryDao.extendExpiry('a', DateTime(2026, 11, 25), at: now);

      final updated = (await db.pantryDao.findById('a'))!;
      expect(updated.expiryDate, DateTime(2026, 11, 25));
      expect(updated.expirySource, ExpirySource.manual);
    });

    test('moveLocation can also replace the expiry date', () async {
      await insertItem(id: 'a');

      await db.pantryDao.moveLocation(
        'a',
        StorageLocation.freezer,
        newExpiry: DateTime(2027, 2, 1),
        at: now,
      );

      final updated = (await db.pantryDao.findById('a'))!;
      expect(updated.storageLocation, StorageLocation.freezer);
      expect(updated.expiryDate, DateTime(2027, 2, 1));
    });

    test('moveLocation keeps the expiry date when none is given', () async {
      await insertItem(id: 'a', expiryDate: DateTime(2026, 11, 20));

      await db.pantryDao.moveLocation('a', StorageLocation.lemari, at: now);

      final updated = (await db.pantryDao.findById('a'))!;
      expect(updated.storageLocation, StorageLocation.lemari);
      expect(updated.expiryDate, DateTime(2026, 11, 20));
    });
  });
}
