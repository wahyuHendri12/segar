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

  RecipesCompanion recipe(String id) {
    return RecipesCompanion.insert(
      id: id,
      title: 'Resep $id',
      cookTimeMin: 10,
      difficulty: RecipeDifficulty.mudah,
      tags: const Value(<String>['cepat']),
      steps: const Value(<String>['Potong', 'Masak']),
      isQuick: const Value(true),
    );
  }

  RecipeIngredientsCompanion ingredient({
    required String id,
    required String recipeId,
    required String name,
    int sortOrder = 0,
  }) {
    return RecipeIngredientsCompanion.insert(
      id: id,
      recipeId: recipeId,
      name: name,
      amount: 1,
      unit: Unit.pcs,
      sortOrder: Value(sortOrder),
    );
  }

  group('RecipeDao', () {
    test('stores recipes and their ordered ingredients', () async {
      await db.recipeDao.upsertRecipes(
        recipeRows: <RecipesCompanion>[recipe('r1')],
        ingredientRows: <RecipeIngredientsCompanion>[
          ingredient(id: 'i2', recipeId: 'r1', name: 'Tomat', sortOrder: 2),
          ingredient(id: 'i1', recipeId: 'r1', name: 'Bayam', sortOrder: 1),
        ],
      );

      expect(await db.recipeDao.count(), 1);

      final loaded = (await db.recipeDao.getWithIngredients('r1'))!;
      expect(loaded.recipe.title, 'Resep r1');
      expect(loaded.recipe.isQuick, isTrue);
      expect(loaded.recipe.tags, <String>['cepat']);
      expect(loaded.ingredients.map((item) => item.name), <String>[
        'Bayam',
        'Tomat',
      ]);
    });

    test('returns every recipe with its ingredients grouped', () async {
      await db.recipeDao.upsertRecipes(
        recipeRows: <RecipesCompanion>[recipe('r1'), recipe('r2')],
        ingredientRows: <RecipeIngredientsCompanion>[
          ingredient(id: 'i1', recipeId: 'r1', name: 'Bayam'),
          ingredient(id: 'i2', recipeId: 'r2', name: 'Tomat'),
        ],
      );

      final loaded = await db.recipeDao.getAllWithIngredients();

      expect(loaded, hasLength(2));
      expect(loaded.map((entry) => entry.recipe.id).toSet(), <String>{
        'r1',
        'r2',
      });
      expect(loaded.every((entry) => entry.ingredients.length == 1), isTrue);
    });

    test('re-upserting a recipe replaces its ingredient lines', () async {
      await db.recipeDao.upsertRecipes(
        recipeRows: <RecipesCompanion>[recipe('r1')],
        ingredientRows: <RecipeIngredientsCompanion>[
          ingredient(id: 'i1', recipeId: 'r1', name: 'Bayam'),
          ingredient(id: 'i2', recipeId: 'r1', name: 'Tomat'),
        ],
      );

      await db.recipeDao.upsertRecipes(
        recipeRows: <RecipesCompanion>[recipe('r1')],
        ingredientRows: <RecipeIngredientsCompanion>[
          ingredient(id: 'i3', recipeId: 'r1', name: 'Wortel'),
        ],
      );

      final ingredients = await db.recipeDao.getIngredients('r1');
      expect(ingredients.map((item) => item.name), <String>['Wortel']);
    });

    test('returns null for an unknown recipe', () async {
      expect(await db.recipeDao.getById('tidak-ada'), isNull);
      expect(await db.recipeDao.getWithIngredients('tidak-ada'), isNull);
    });

    test('does nothing when there are no recipes to upsert', () async {
      await db.recipeDao.upsertRecipes(
        recipeRows: const <RecipesCompanion>[],
        ingredientRows: <RecipeIngredientsCompanion>[
          ingredient(id: 'i1', recipeId: 'r1', name: 'Bayam'),
        ],
      );

      expect(await db.recipeDao.count(), 0);
      expect(await db.recipeDao.getIngredients('r1'), isEmpty);
    });
  });
}
