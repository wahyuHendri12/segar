import 'package:drift/drift.dart';

import '../enums.dart';
import 'converters.dart';

/// A simple Indonesian home-cooking recipe.
@DataClassName('Recipe')
@TableIndex(name: 'recipe_quick_idx', columns: {#isQuick})
class Recipes extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get emoji => text().withDefault(const Constant('🍲'))();

  TextColumn get imageAsset => text().nullable()();

  IntColumn get cookTimeMin => integer()();

  TextColumn get difficulty => textEnum<RecipeDifficulty>()();

  IntColumn get servings => integer().withDefault(const Constant(2))();

  IntColumn get estimatedCostIdr => integer().withDefault(const Constant(0))();

  /// Automatically true when [cookTimeMin] is below 15 minutes.
  BoolColumn get isQuick => boolean().withDefault(const Constant(false))();

  TextColumn get tags => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  TextColumn get steps => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}

/// Ingredient lines belonging to a [Recipes] row.
@DataClassName('RecipeIngredient')
@TableIndex(name: 'recipe_ingredient_recipe_idx', columns: {#recipeId})
class RecipeIngredients extends Table {
  TextColumn get id => text()();

  TextColumn get recipeId => text()();

  TextColumn get catalogId => text().nullable()();

  TextColumn get name => text()();

  RealColumn get amount => real()();

  TextColumn get unit => textEnum<Unit>()();

  BoolColumn get isOptional => boolean().withDefault(const Constant(false))();

  /// Salt, sugar, oil and water are assumed to always be available.
  BoolColumn get isStaple => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
