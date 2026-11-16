import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/pantry_item_view.dart';
import 'package:segar/data/repositories/pantry_repository.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PantryRepository repository;
  final now = DateTime(2026, 11, 10, 10);

  setUp(() async {
    db = openTestDatabase();
    repository = PantryRepository(
      pantryDao: db.pantryDao,
      catalogDao: db.catalogDao,
      clock: () => now,
    );
    await db
        .into(db.ingredientCatalogs)
        .insert(
          IngredientCatalogsCompanion.insert(
            id: 'bayam',
            nameId: 'Bayam',
            nameEn: 'Spinach',
            category: IngredientCategory.sayur,
            emoji: '🥬',
            defaultUnit: Unit.ikat,
            shelfLifeKulkas: const Value(4),
            shelfLifeFreezer: const Value(30),
            shelfLifeNote: 'Simpan di kulkas.',
            tips: const Value(<String>['Cuci sebelum dimasak.']),
            avgWeightPerUnitGrams: const Value(100),
            typicalPriceIdr: const Value(2000),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  NewPantryItemInput input({
    double quantity = 2,
    int? priceIdr,
    bool notifyEnabled = true,
  }) {
    return NewPantryItemInput(
      catalogId: 'bayam',
      name: 'Bayam',
      category: IngredientCategory.sayur,
      quantity: quantity,
      unit: Unit.ikat,
      storageLocation: StorageLocation.kulkas,
      purchaseDate: DateTime(2026, 11, 9),
      expiryDate: DateTime(2026, 11, 13),
      expirySource: ExpirySource.estimasi,
      priceIdr: priceIdr,
      note: '  ',
      notifyEnabled: notifyEnabled,
    );
  }

  group('addItem', () {
    test('maps catalog metadata and derives the total weight', () async {
      final id = await repository.addItem(input());

      final view = await repository.getItem(id);
      expect(view, isNotNull);
      expect(view!.name, 'Bayam');
      expect(view.emoji, '🥬');
      expect(view.category, IngredientCategory.sayur);
      expect(view.unit, Unit.ikat);
      expect(view.quantity, 2);
      expect(view.weightGrams, 200);
      expect(view.note, isNull);
      expect(view.notifyEnabled, isTrue);
      expect(view.expirySource, ExpirySource.estimasi);
      expect(view.catalog?.nameId, 'Bayam');
      expect(view.expiryStatus, ExpiryStatus.hampirBasi);
      expect(view.daysLeft, 3);
    });

    test('keeps a manual price and normalizes a blank note', () async {
      final id = await repository.addItem(input(priceIdr: 5000));

      final view = await repository.getItem(id);
      expect(view!.priceIdr, 5000);
      expect(view.note, isNull);
    });

    test('supports custom ingredients without a catalog row', () async {
      final id = await repository.addItem(
        NewPantryItemInput(
          name: 'Bumbu rahasia',
          category: IngredientCategory.bumbu,
          quantity: 1,
          unit: Unit.bungkus,
          storageLocation: StorageLocation.lemari,
          purchaseDate: DateTime(2026, 11, 1),
          expiryDate: DateTime(2026, 12, 1),
          expirySource: ExpirySource.manual,
        ),
      );

      final view = await repository.getItem(id);
      expect(view!.catalogId, isNull);
      expect(view.catalog, isNull);
      expect(view.emoji, '🥗');
      expect(view.weightGrams, isNull);
    });
  });

  group('updateItem', () {
    test('updates fields and keeps the same id', () async {
      final id = await repository.addItem(input());

      await repository.updateItem(
        id,
        NewPantryItemInput(
          catalogId: 'bayam',
          name: 'Bayam segar',
          category: IngredientCategory.sayur,
          quantity: 3,
          unit: Unit.ikat,
          storageLocation: StorageLocation.freezer,
          purchaseDate: DateTime(2026, 11, 10),
          expiryDate: DateTime(2026, 12, 10),
          expirySource: ExpirySource.manual,
          priceIdr: 7500,
          note: 'Untuk sup',
          notifyEnabled: false,
        ),
      );

      final view = await repository.getItem(id);
      expect(view!.name, 'Bayam segar');
      expect(view.quantity, 3);
      expect(view.storageLocation, StorageLocation.freezer);
      expect(view.expirySource, ExpirySource.manual);
      expect(view.priceIdr, 7500);
      expect(view.note, 'Untuk sup');
      expect(view.notifyEnabled, isFalse);
    });
  });

  group('markUsed', () {
    test('uses the manual price and writes a usage log', () async {
      final id = await repository.addItem(input(priceIdr: 10000));
      final view = (await repository.getItem(id))!;

      final outcome = await repository.markUsed(view);

      expect(outcome.action, UsageAction.dipakai);
      expect(outcome.valueIdr, 10000);
      expect(outcome.isEstimate, isFalse);
      expect(outcome.weightGrams, 200);

      final updated = (await repository.getItem(id))!;
      expect(updated.status, PantryStatus.terpakai);

      final logs = await db.usageLogDao.getForItem(id);
      expect(logs, hasLength(1));
      expect(logs.single.valueIdr, 10000);
      expect(logs.single.quantityChanged, 2);
    });

    test(
      'falls back to the catalog price and marks it as an estimate',
      () async {
        final id = await repository.addItem(input());
        final view = (await repository.getItem(id))!;

        final outcome = await repository.markUsed(view);

        expect(outcome.valueIdr, 2000);
        expect(outcome.isEstimate, isTrue);
      },
    );
  });

  group('markWasted', () {
    test('stores the waste reason and value', () async {
      final id = await repository.addItem(input(priceIdr: 6000));
      final view = (await repository.getItem(id))!;

      final outcome = await repository.markWasted(
        view,
        reason: WasteReason.lupa,
      );

      expect(outcome.action, UsageAction.dibuang);
      expect(outcome.valueIdr, 6000);

      final logs = await db.usageLogDao.getForItem(id);
      expect(logs.single.action, UsageAction.dibuang);
      expect(logs.single.reasonWasted, WasteReason.lupa);
    });
  });

  group('markPartiallyUsed', () {
    test('reduces quantity and value proportionally', () async {
      final id = await repository.addItem(input(quantity: 4, priceIdr: 10000));
      final view = (await repository.getItem(id))!;

      final outcome = await repository.markPartiallyUsed(view, 1);

      expect(outcome.action, UsageAction.dikurangi);
      expect(outcome.valueIdr, 2500);
      expect(outcome.weightGrams, 100);

      final updated = (await repository.getItem(id))!;
      expect(updated.quantity, 3);
      expect(updated.weightGrams, 300);
      expect(updated.status, PantryStatus.aktif);
    });

    test('finishing the stock marks the item as used', () async {
      final id = await repository.addItem(input(quantity: 2));
      final view = (await repository.getItem(id))!;

      final outcome = await repository.markPartiallyUsed(view, 2);

      expect(outcome.action, UsageAction.dipakai);
      final updated = (await repository.getItem(id))!;
      expect(updated.quantity, 0);
      expect(updated.status, PantryStatus.terpakai);
    });

    test('rejects invalid quantities', () async {
      final id = await repository.addItem(input(quantity: 2));
      final view = (await repository.getItem(id))!;

      expect(() => repository.markPartiallyUsed(view, 0), throwsArgumentError);
      expect(() => repository.markPartiallyUsed(view, 3), throwsArgumentError);
    });

    test('undo restores quantity and weight', () async {
      final id = await repository.addItem(input(quantity: 4, priceIdr: 10000));
      final view = (await repository.getItem(id))!;

      final outcome = await repository.markPartiallyUsed(view, 1);
      await repository.undoUsage(
        usageLogId: outcome.usageLogId,
        itemId: outcome.itemId,
      );

      final restored = (await repository.getItem(id))!;
      expect(restored.quantity, 4);
      expect(restored.weightGrams, 400);
      expect(restored.status, PantryStatus.aktif);
      expect(await db.usageLogDao.getForItem(id), isEmpty);
    });

    test('undo after finishing the stock restores the full quantity', () async {
      final id = await repository.addItem(input(quantity: 2));
      final view = (await repository.getItem(id))!;

      final outcome = await repository.markPartiallyUsed(view, 2);
      await repository.undoUsage(
        usageLogId: outcome.usageLogId,
        itemId: outcome.itemId,
      );

      final restored = (await repository.getItem(id))!;
      expect(restored.quantity, 2);
      expect(restored.status, PantryStatus.aktif);
    });
  });

  group('deleteItem', () {
    test('soft deletes and can be restored', () async {
      final id = await repository.addItem(input());

      await repository.deleteItem(id);
      final deleted = (await db.pantryDao.findById(id))!;
      expect(deleted.deletedAt, isNotNull);
      expect(await db.pantryDao.getActive(), isEmpty);

      await repository.restoreItem(id);
      final restored = (await db.pantryDao.findById(id))!;
      expect(restored.deletedAt, isNull);
      expect(await db.pantryDao.getActive(), hasLength(1));
    });
  });
}
