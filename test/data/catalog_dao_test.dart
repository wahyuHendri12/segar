import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  IngredientCatalogsCompanion catalog({
    required String id,
    required String nameId,
    String nameEn = 'ingredient',
    List<String> aliases = const <String>[],
    IngredientCategory category = IngredientCategory.sayur,
  }) {
    return IngredientCatalogsCompanion.insert(
      id: id,
      nameId: nameId,
      nameEn: nameEn,
      aliases: Value(aliases),
      category: category,
      emoji: '🥬',
      defaultUnit: Unit.ikat,
      shelfLifeNote: '$nameId segar.',
    );
  }

  group('CatalogDao', () {
    test('upserts and counts catalog rows', () async {
      await db.catalogDao.upsertAll(<IngredientCatalogsCompanion>[
        catalog(id: 'bayam', nameId: 'Bayam'),
        catalog(id: 'tomat', nameId: 'Tomat'),
      ]);

      expect(await db.catalogDao.count(), 2);
      expect(await db.catalogDao.getAll(), hasLength(2));
    });

    test('finds rows by id and id list', () async {
      await db.catalogDao.upsertAll(<IngredientCatalogsCompanion>[
        catalog(id: 'bayam', nameId: 'Bayam'),
        catalog(id: 'tomat', nameId: 'Tomat'),
      ]);

      expect((await db.catalogDao.getById('bayam'))?.nameId, 'Bayam');
      expect(await db.catalogDao.getById('tidak-ada'), isNull);
      expect(
        await db.catalogDao.getByIds(<String>['bayam', 'tomat']),
        hasLength(2),
      );
      expect(await db.catalogDao.getByIds(const <String>[]), isEmpty);
    });

    test('searches Indonesian names, English names and aliases', () async {
      await db.catalogDao.upsertAll(<IngredientCatalogsCompanion>[
        catalog(
          id: 'bayam',
          nameId: 'Bayam',
          nameEn: 'spinach',
          aliases: <String>['bayam hijau'],
        ),
        catalog(id: 'tomat', nameId: 'Tomat', nameEn: 'tomato'),
      ]);

      expect((await db.catalogDao.search('bayam')).single.id, 'bayam');
      expect((await db.catalogDao.search('SPINACH')).single.id, 'bayam');
      expect((await db.catalogDao.search('hijau')).single.id, 'bayam');
      expect((await db.catalogDao.search('tomat')).single.id, 'tomat');
      expect(await db.catalogDao.search('tidak-ada'), isEmpty);
      expect(await db.catalogDao.search(''), hasLength(2));
    });

    test('replaces an existing row instead of duplicating it', () async {
      await db.catalogDao.upsertAll(<IngredientCatalogsCompanion>[
        catalog(id: 'bayam', nameId: 'Bayam'),
      ]);
      await db.catalogDao.upsertAll(<IngredientCatalogsCompanion>[
        catalog(id: 'bayam', nameId: 'Bayam Baru'),
      ]);

      expect(await db.catalogDao.count(), 1);
      expect((await db.catalogDao.getById('bayam'))?.nameId, 'Bayam Baru');
    });
  });
}
