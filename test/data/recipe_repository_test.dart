import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/repositories/pantry_repository.dart';
import 'package:segar/data/repositories/recipe_repository.dart';

import '../helpers/recipe_seed.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PantryRepository pantryRepository;
  late RecipeRepository recipeRepository;
  final now = DateTime(2026, 11, 10, 10);

  setUp(() async {
    db = openTestDatabase();
    pantryRepository = PantryRepository(
      pantryDao: db.pantryDao,
      catalogDao: db.catalogDao,
      clock: () => now,
    );
    recipeRepository = RecipeRepository(
      recipeDao: db.recipeDao,
      pantryRepository: pantryRepository,
      clock: () => now,
    );
    await seedCatalogAndRecipes(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addBayam({
    String id = 'p-bayam',
    double quantity = 3,
    Unit unit = Unit.ikat,
    DateTime? expiryDate,
  }) {
    return insertPantryItem(
      db,
      id: id,
      catalogId: 'bayam',
      name: 'Bayam',
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate ?? now.add(const Duration(days: 5)),
      purchaseDate: now.subtract(const Duration(days: 1)),
    );
  }

  group('watchSuggestions', () {
    test('enriches recipes with pantry matches and scores', () async {
      await addBayam();

      final recipes = await recipeRepository.watchSuggestions().first;
      final sayur = recipes.firstWhere(
        (recipe) => recipe.id == 'sayur-bening-bayam-jagung',
      );
      final bayam = sayur.ingredients.firstWhere(
        (ingredient) => ingredient.name == 'Bayam',
      );

      expect(recipes, hasLength(12));
      expect(bayam.isAvailable, isTrue);
      expect(bayam.matchedItem?.id, 'p-bayam');
      expect(sayur.requiredCount, 4);
      expect(sayur.ownedRequiredCount, 1);
      expect(sayur.matchScore, greaterThan(0));
      expect(sayur.isComplete, isFalse);
      expect(sayur.missingRequired, hasLength(3));
    });

    test('excludes expired pantry items from matching', () async {
      await addBayam(expiryDate: now.subtract(const Duration(days: 1)));

      final recipes = await recipeRepository.watchSuggestions().first;
      final sayur = recipes.firstWhere(
        (recipe) => recipe.id == 'sayur-bening-bayam-jagung',
      );
      final bayam = sayur.ingredients.firstWhere(
        (ingredient) => ingredient.name == 'Bayam',
      );

      expect(bayam.isAvailable, isFalse);
      expect(sayur.ownedRequiredCount, 0);
    });

    test('matches aliases from the catalog', () async {
      await insertPantryItem(
        db,
        id: 'p-bayam',
        catalogId: 'bayam',
        name: 'Bayam Hijau',
        quantity: 1,
        unit: Unit.ikat,
        expiryDate: now.add(const Duration(days: 5)),
      );

      final recipes = await recipeRepository.watchSuggestions().first;
      final sayur = recipes.firstWhere(
        (recipe) => recipe.id == 'sayur-bening-bayam-jagung',
      );

      expect(
        sayur.ingredients
            .firstWhere((item) => item.name == 'Bayam')
            .isAvailable,
        isTrue,
      );
    });

    test('returns null for an unknown recipe', () async {
      expect(await recipeRepository.watchRecipe('tidak-ada').first, isNull);
      expect(await recipeRepository.getRecipe('tidak-ada'), isNull);
    });
  });

  group('cook', () {
    const bayamLineId = 'sayur-bening-bayam-jagung-i0';

    Future<void> cookBayam({required double servings}) async {
      final recipe = (await recipeRepository
          .watchRecipe('sayur-bening-bayam-jagung')
          .first)!;
      await recipeRepository.cook(
        recipe: recipe,
        servings: servings.round(),
        ingredientIds: const <String>{bayamLineId},
      );
    }

    test('deducts only the used amount when the unit matches', () async {
      await addBayam(quantity: 3);

      await cookBayam(servings: 2);

      final item = await pantryRepository.getItem('p-bayam');
      expect(item, isNotNull);
      expect(item!.quantity, 2);
      expect(item.status, PantryStatus.aktif);
      expect(await db.usageLogDao.getAll(), hasLength(1));
      expect(
        (await db.usageLogDao.getAll()).single.action,
        UsageAction.dikurangi,
      );
    });

    test('scales the used amount with the servings', () async {
      await addBayam(quantity: 3);

      await cookBayam(servings: 4);

      final item = await pantryRepository.getItem('p-bayam');
      expect(item!.quantity, 1);
    });

    test(
      'marks the whole item used when the amount covers the stock',
      () async {
        await addBayam(quantity: 1);

        await cookBayam(servings: 2);

        final item = await pantryRepository.getItem('p-bayam');
        expect(item!.status, PantryStatus.terpakai);
        expect(
          (await db.usageLogDao.getAll()).single.action,
          UsageAction.dipakai,
        );
      },
    );

    test('marks the whole item used when the units differ', () async {
      await addBayam(quantity: 500, unit: Unit.gram);

      await cookBayam(servings: 2);

      final item = await pantryRepository.getItem('p-bayam');
      expect(item!.status, PantryStatus.terpakai);
    });

    test('consumes a duplicate matched item only once', () async {
      await db.recipeDao.upsertRecipes(
        recipeRows: <RecipesCompanion>[
          RecipesCompanion.insert(
            id: 'double-bayam',
            title: 'Double Bayam',
            cookTimeMin: 10,
            difficulty: RecipeDifficulty.mudah,
          ),
        ],
        ingredientRows: <RecipeIngredientsCompanion>[
          RecipeIngredientsCompanion.insert(
            id: 'double-bayam-i0',
            recipeId: 'double-bayam',
            catalogId: const Value('bayam'),
            name: 'Bayam',
            amount: 1,
            unit: Unit.ikat,
          ),
          RecipeIngredientsCompanion.insert(
            id: 'double-bayam-i1',
            recipeId: 'double-bayam',
            catalogId: const Value('bayam'),
            name: 'Bayam Hijau',
            amount: 1,
            unit: Unit.ikat,
          ),
        ],
      );
      await addBayam(quantity: 5);

      final recipe = (await recipeRepository
          .watchRecipe('double-bayam')
          .first)!;
      final outcomes = await recipeRepository.cook(
        recipe: recipe,
        servings: recipe.servings,
        ingredientIds: const <String>{'double-bayam-i0', 'double-bayam-i1'},
      );

      expect(outcomes, hasLength(1));
      final item = await pantryRepository.getItem('p-bayam');
      expect(item!.quantity, 4);
    });

    test('ignores ingredients that are not in the pantry', () async {
      final recipe = (await recipeRepository
          .watchRecipe('sayur-bening-bayam-jagung')
          .first)!;

      final outcomes = await recipeRepository.cook(
        recipe: recipe,
        servings: 2,
        ingredientIds: const <String>{bayamLineId},
      );

      expect(outcomes, isEmpty);
    });

    test('undo restores the deducted amount', () async {
      await addBayam(quantity: 3);
      final recipe = (await recipeRepository
          .watchRecipe('sayur-bening-bayam-jagung')
          .first)!;
      final outcomes = await recipeRepository.cook(
        recipe: recipe,
        servings: 2,
        ingredientIds: const <String>{bayamLineId},
      );

      await recipeRepository.undoUsage(
        usageLogId: outcomes.single.usageLogId,
        itemId: outcomes.single.itemId,
      );

      final item = await pantryRepository.getItem('p-bayam');
      expect(item!.quantity, 3);
      expect(item.status, PantryStatus.aktif);
      expect(await db.usageLogDao.getAll(), isEmpty);
    });
  });
}
