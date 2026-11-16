import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/recipes.dart';

part 'recipe_dao.g.dart';

class RecipeWithIngredients {
  const RecipeWithIngredients({
    required this.recipe,
    required this.ingredients,
  });

  final Recipe recipe;
  final List<RecipeIngredient> ingredients;
}

@DriftAccessor(tables: [Recipes, RecipeIngredients])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  Stream<List<Recipe>> watchAll() {
    return (select(recipes)..orderBy(<OrderClauseGenerator<$RecipesTable>>[
          (t) => OrderingTerm.asc(t.title),
        ]))
        .watch();
  }

  Future<List<Recipe>> getAll() {
    return (select(recipes)..orderBy(<OrderClauseGenerator<$RecipesTable>>[
          (t) => OrderingTerm.asc(t.title),
        ]))
        .get();
  }

  Future<Recipe?> getById(String id) {
    return (select(recipes)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<RecipeIngredient>> getIngredients(String recipeId) {
    return (select(recipeIngredients)
          ..where((t) => t.recipeId.equals(recipeId))
          ..orderBy(<OrderClauseGenerator<$RecipeIngredientsTable>>[
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
  }

  Future<List<RecipeWithIngredients>> getAllWithIngredients() async {
    final recipeRows = await getAll();
    if (recipeRows.isEmpty) {
      return const <RecipeWithIngredients>[];
    }

    final ingredientRows =
        await (select(recipeIngredients)
              ..orderBy(<OrderClauseGenerator<$RecipeIngredientsTable>>[
                (t) => OrderingTerm.asc(t.sortOrder),
                (t) => OrderingTerm.asc(t.name),
              ]))
            .get();

    final grouped = <String, List<RecipeIngredient>>{};
    for (final ingredient in ingredientRows) {
      grouped
          .putIfAbsent(ingredient.recipeId, () => <RecipeIngredient>[])
          .add(ingredient);
    }

    return recipeRows
        .map(
          (recipe) => RecipeWithIngredients(
            recipe: recipe,
            ingredients: grouped[recipe.id] ?? const <RecipeIngredient>[],
          ),
        )
        .toList(growable: false);
  }

  Future<RecipeWithIngredients?> getWithIngredients(String id) async {
    final recipe = await getById(id);
    if (recipe == null) return null;
    final ingredients = await getIngredients(id);
    return RecipeWithIngredients(recipe: recipe, ingredients: ingredients);
  }

  Future<int> count() async {
    final countExpression = recipes.id.count();
    final query = selectOnly(recipes)
      ..addColumns(<Expression<Object>>[countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  /// Upserts seed recipes and replaces their ingredient lines in one
  /// transaction. Pantry and usage data are never touched.
  Future<void> upsertRecipes({
    required List<RecipesCompanion> recipeRows,
    required List<RecipeIngredientsCompanion> ingredientRows,
  }) {
    if (recipeRows.isEmpty) return Future<void>.value();

    return transaction(() async {
      await batch((batch) {
        batch.insertAll(recipes, recipeRows, mode: InsertMode.insertOrReplace);
      });

      final recipeIds = recipeRows
          .map((row) => row.id.value)
          .toList(growable: false);

      await (delete(
        recipeIngredients,
      )..where((t) => t.recipeId.isIn(recipeIds))).go();

      if (ingredientRows.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(recipeIngredients, ingredientRows);
        });
      }
    });
  }
}
