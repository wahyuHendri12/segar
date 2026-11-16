import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/constants/app_constants.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/local/seed_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDown(() async {
    await db.close();
  });

  String assetJson() => File(SeedLoader.seedAssetPath).readAsStringSync();
  String recipeJson() =>
      File(SeedLoader.recipeSeedAssetPath).readAsStringSync();

  SeedLoader loaderFor(SharedPreferences prefs) {
    return SeedLoader(
      db: db,
      prefs: prefs,
      loadJson: () async => assetJson(),
      loadRecipeJson: () async => recipeJson(),
    );
  }

  group('parseIngredientCatalogSeed', () {
    test('parses the shipped v1 seed', () {
      final items = parseIngredientCatalogSeed(assetJson());

      expect(items, hasLength(60));
      expect(items.map((item) => item.id).toSet(), hasLength(60));
      expect(items.any((item) => item.id == 'bayam'), isTrue);
      expect(items.any((item) => item.id == 'tempe'), isTrue);
    });

    test('maps every field of a catalog entry', () {
      final item = parseIngredientCatalogSeed(assetJson())
          .firstWhere((entry) => entry.id == 'bayam');

      expect(item.nameId, 'Bayam');
      expect(item.nameEn, 'spinach');
      expect(item.category, IngredientCategory.sayur);
      expect(item.defaultUnit, Unit.ikat);
      expect(item.shelfLifeKulkas, 3);
      expect(item.shelfLifeFreezer, 30);
      expect(item.shelfLifeLemari, isNull);
      expect(item.shelfLifeSuhuRuang, 1);
      expect(item.aliases, contains('bayam hijau'));
      expect(item.tips, isNotEmpty);
      expect(item.quickTags, contains('Tumis'));
      expect(item.avgWeightPerUnitGrams, 200);
      expect(item.typicalPriceIdr, 5000);
      expect(item.quickIdeaRecipeIds, contains('tumis-bayam'));
      expect(item.shelfLifeFor(StorageLocation.kulkas), 3);
    });

    test('rejects a payload without items', () {
      expect(
        () => parseIngredientCatalogSeed('{"version": 1}'),
        throwsFormatException,
      );
    });

    test('rejects an item with missing required fields', () {
      expect(
        () => parseIngredientCatalogSeed(
          '{"items":[{"id":"rusak","nameId":"Rusak"}]}',
        ),
        throwsFormatException,
      );
    });

    test('rejects unknown enum values', () {
      expect(
        () => parseIngredientCatalogSeed(
          '{"items":[{"id":"x","nameId":"X","nameEn":"x",'
          '"category":"tidakAda","defaultUnit":"pcs"}]}',
        ),
        throwsFormatException,
      );
    });
  });

  group('parseRecipeSeed', () {
    test('parses the shipped recipe seed', () {
      final recipes = parseRecipeSeed(recipeJson());

      expect(recipes, hasLength(12));
      expect(recipes.map((recipe) => recipe.id).toSet(), hasLength(12));
      expect(
        recipes.any((recipe) => recipe.id == 'sayur-bening-bayam-jagung'),
        isTrue,
      );
      expect(recipes.any((recipe) => recipe.id == 'salad-buah-yogurt'), isTrue);
    });

    test('maps every field of a recipe', () {
      final recipe = parseRecipeSeed(recipeJson())
          .firstWhere((entry) => entry.id == 'sayur-bening-bayam-jagung');

      expect(recipe.title, 'Sayur Bening Bayam Jagung Manis');
      expect(recipe.emoji, '🥬');
      expect(recipe.imageAsset, 'assets/images/recipe_sayur_bening.jpg');
      expect(recipe.cookTimeMin, 15);
      expect(recipe.difficulty, RecipeDifficulty.mudah);
      expect(recipe.servings, 2);
      expect(recipe.estimatedCostIdr, 8000);
      expect(recipe.tags, contains('cepat'));
      expect(recipe.steps, hasLength(4));
      expect(recipe.ingredients, hasLength(7));
      expect(recipe.isQuick, isFalse);

      final bayam = recipe.ingredients.first;
      expect(bayam.catalogId, 'bayam');
      expect(bayam.name, 'Bayam');
      expect(bayam.amount, 1);
      expect(bayam.unit, Unit.ikat);
      expect(bayam.isOptional, isFalse);
      expect(bayam.isStaple, isFalse);
      expect(recipe.ingredients.last.isStaple, isTrue);
    });

    test('marks recipes under 15 minutes as quick', () {
      final smoothie = parseRecipeSeed(recipeJson())
          .firstWhere((entry) => entry.id == 'smoothie-bayam-pisang');

      expect(smoothie.cookTimeMin, 5);
      expect(smoothie.isQuick, isTrue);
    });

    test('rejects a payload without recipes', () {
      expect(() => parseRecipeSeed('{"version": 1}'), throwsFormatException);
    });

    test('rejects duplicate recipe ids', () {
      final recipe = recipeJson();
      final broken = recipe.replaceFirst(
        '"id": "sup-telur-tomat"',
        '"id": "sayur-bening-bayam-jagung"',
      );

      expect(() => parseRecipeSeed(broken), throwsFormatException);
    });

    test('rejects an ingredient without a positive amount', () {
      expect(
        () => parseRecipeSeed(
          '{"recipes":[{"id":"x","title":"X","cookTimeMin":10,'
          '"difficulty":"mudah","servings":2,'
          '"ingredients":[{"name":"X","amount":0,"unit":"pcs"}]}]}',
        ),
        throwsFormatException,
      );
    });

    test('rejects an unknown unit', () {
      expect(
        () => parseRecipeSeed(
          '{"recipes":[{"id":"x","title":"X","cookTimeMin":10,'
          '"difficulty":"mudah","servings":2,'
          '"ingredients":[{"name":"X","amount":1,"unit":"tidakAda"}]}]}',
        ),
        throwsFormatException,
      );
    });
  });

  group('SeedLoader', () {
    test('seeds the catalog, recipes and stores the seed version', () async {
      final prefs = await SharedPreferences.getInstance();

      await loaderFor(prefs).ensureSeeded();

      expect(await db.catalogDao.count(), 60);
      expect(await db.recipeDao.count(), 12);
      expect(
        await db.recipeDao.getIngredients('sayur-bening-bayam-jagung'),
        hasLength(7),
      );
      expect(prefs.getInt(PrefKeys.seedVersion), SeedLoader.currentSeedVersion);
      expect(SeedLoader.currentSeedVersion, 2);
    });

    test('does not read the assets again when already seeded', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(PrefKeys.seedVersion, SeedLoader.currentSeedVersion);
      var catalogLoads = 0;
      var recipeLoads = 0;

      final loader = SeedLoader(
        db: db,
        prefs: prefs,
        loadJson: () async {
          catalogLoads++;
          return assetJson();
        },
        loadRecipeJson: () async {
          recipeLoads++;
          return recipeJson();
        },
      );

      await loader.ensureSeeded();

      expect(catalogLoads, 0);
      expect(recipeLoads, 0);
      expect(await db.catalogDao.count(), 0);
      expect(await db.recipeDao.count(), 0);
    });

    test('re-seeds an install that only has seed version 1', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(PrefKeys.seedVersion, 1);

      await loaderFor(prefs).ensureSeeded();

      expect(await db.catalogDao.count(), 60);
      expect(await db.recipeDao.count(), 12);
      expect(prefs.getInt(PrefKeys.seedVersion), 2);
    });

    test('never touches pantry items or usage logs', () async {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime(2026, 11, 9);
      await db
          .into(db.pantryItems)
          .insert(
            PantryItemsCompanion.insert(
              id: 'pantry-1',
              name: 'Bayam',
              category: IngredientCategory.sayur,
              quantity: 1,
              unit: Unit.ikat,
              storageLocation: StorageLocation.kulkas,
              purchaseDate: now,
              expiryDate: DateTime(2026, 11, 12),
              expirySource: ExpirySource.estimasi,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await loaderFor(prefs).ensureSeeded();

      final items = await db.pantryDao.getActive();
      expect(items, hasLength(1));
      expect(items.single.id, 'pantry-1');
      expect(await db.usageLogDao.getAll(), isEmpty);
    });

    test('re-seeding updates rows without duplicates', () async {
      final prefs = await SharedPreferences.getInstance();
      final loader = loaderFor(prefs);

      await loader.ensureSeeded();
      await prefs.setInt(PrefKeys.seedVersion, 1);
      await loader.ensureSeeded();

      expect(await db.catalogDao.count(), 60);
      expect(await db.recipeDao.count(), 12);
      expect(
        await db.recipeDao.getIngredients('sayur-bening-bayam-jagung'),
        hasLength(7),
      );
    });
  });
}
