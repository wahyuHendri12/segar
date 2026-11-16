import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/data/backup/backup_payload.dart';
import 'package:segar/data/backup/backup_repository.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  final now = DateTime(2026, 11, 10, 9, 30);

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'userName': 'Dina',
      'themeMode': 'dark',
      'notificationsEnabled': false,
      'warnDays': 5,
      'onlineBarcodeEnabled': false,
    });
    prefs = await SharedPreferences.getInstance();
    db = openTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedData() async {
    await db
        .into(db.pantryItems)
        .insert(
          PantryItemsCompanion.insert(
            id: 'item-1',
            name: 'Bayam',
            category: IngredientCategory.sayur,
            quantity: 2,
            unit: Unit.ikat,
            storageLocation: StorageLocation.kulkas,
            purchaseDate: now.subtract(const Duration(days: 1)),
            expiryDate: now.add(const Duration(days: 3)),
            expirySource: ExpirySource.estimasi,
            priceIdr: const Value(5000),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db
        .into(db.usageLogs)
        .insert(
          UsageLogsCompanion.insert(
            id: 'log-1',
            pantryItemId: 'item-1',
            action: UsageAction.dipakai,
            quantityChanged: 2,
            category: IngredientCategory.sayur,
            valueIdr: const Value(5000),
            weightGrams: const Value(200),
            loggedAt: now,
          ),
        );
    await db.shoppingListDao.addItem(
      name: 'Tomat',
      quantity: 3,
      unit: Unit.butir,
      source: ShoppingSource.dariResep,
      at: now,
    );
  }

  test('exports and restores a complete snapshot', () async {
    await seedData();
    final repository = BackupRepository(
      database: db,
      preferences: prefs,
      clock: () => now,
    );

    final json = await repository.exportJson();
    expect(json, contains('segar-backup'));
    expect(json, contains('Bayam'));

    final payload = repository.parse(json);
    expect(payload.exportedAt, now);
    expect(payload.pantryItems, hasLength(1));
    expect(payload.usageLogs, hasLength(1));
    expect(payload.shoppingList, hasLength(1));
    expect(payload.settings.userName, 'Dina');
    expect(payload.settings.themeMode, 'dark');

    await repository.clearAllData();
    expect(await db.pantryDao.getAll(), isEmpty);
    expect(await db.usageLogDao.getAll(), isEmpty);
    expect(await db.shoppingListDao.getAll(), isEmpty);

    await repository.restore(payload);

    final items = await db.pantryDao.getAll();
    expect(items, hasLength(1));
    expect(items.single.name, 'Bayam');
    expect(items.single.priceIdr, 5000);

    final logs = await db.usageLogDao.getAll();
    expect(logs, hasLength(1));
    expect(logs.single.action, UsageAction.dipakai);

    final shopping = await db.shoppingListDao.getAll();
    expect(shopping, hasLength(1));
    expect(shopping.single.name, 'Tomat');
    expect(shopping.single.source, ShoppingSource.dariResep);
  });

  test('restore applies saved settings', () async {
    await seedData();
    final repository = BackupRepository(
      database: db,
      preferences: prefs,
      clock: () => now,
    );
    final payload = repository.parse(await repository.exportJson());

    await prefs.setString('userName', 'Rani');
    await prefs.setString('themeMode', 'light');
    await prefs.setBool('notificationsEnabled', true);

    await repository.restore(payload);

    expect(prefs.getString('userName'), 'Dina');
    expect(prefs.getString('themeMode'), 'dark');
    expect(prefs.getBool('notificationsEnabled'), isFalse);
    expect(prefs.getInt('warnDays'), 5);
    expect(prefs.getBool('onlineBarcodeEnabled'), isFalse);
  });

  test('rejects files that are not Segar backups', () {
    final repository = BackupRepository(database: db, preferences: prefs);

    expect(
      () => repository.parse('{"format":"lain","version":1}'),
      throwsA(isA<BackupFormatException>()),
    );
    expect(
      () => repository.parse('bukan json'),
      throwsA(isA<BackupFormatException>()),
    );
    expect(
      () => repository.parse('{"format":"segar-backup","version":99}'),
      throwsA(isA<BackupFormatException>()),
    );
  });

  test('clearAllData also empties optional online caches', () async {
    await db.barcodeCacheDao.upsert(
      BarcodeCacheCompanion.insert(
        barcode: '899123',
        name: 'Produk',
        category: IngredientCategory.lainnya,
        source: BarcodeSource.off,
        fetchedAt: now,
      ),
    );
    final repository = BackupRepository(database: db, preferences: prefs);

    await repository.clearAllData();

    expect(await db.barcodeCacheDao.getByBarcode('899123'), isNull);
  });
}
