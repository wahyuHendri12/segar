import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/local/seed_loader.dart';

/// Loads the shipped catalog and recipe seeds into an in-memory test database.
Future<void> seedCatalogAndRecipes(AppDatabase db) async {
  final catalog = parseIngredientCatalogSeed(
    File(SeedLoader.seedAssetPath).readAsStringSync(),
  );
  await db.catalogDao.upsertAll(
    catalog.map((item) => item.toCompanion()).toList(growable: false),
  );

  final recipes = parseRecipeSeed(
    File(SeedLoader.recipeSeedAssetPath).readAsStringSync(),
  );
  await db.recipeDao.upsertRecipes(
    recipeRows: recipes
        .map((recipe) => recipe.toRecipeCompanion())
        .toList(growable: false),
    ingredientRows: <RecipeIngredientsCompanion>[
      for (final recipe in recipes) ...recipe.toIngredientCompanions(),
    ],
  );
}

/// Inserts one active pantry item for recipe tests.
Future<void> insertPantryItem(
  AppDatabase db, {
  required String id,
  required String name,
  String? catalogId,
  required double quantity,
  required Unit unit,
  required DateTime expiryDate,
  DateTime? purchaseDate,
}) {
  final created = purchaseDate ?? expiryDate.subtract(const Duration(days: 3));
  return db
      .into(db.pantryItems)
      .insert(
        PantryItemsCompanion.insert(
          id: id,
          catalogId: Value(catalogId),
          name: name,
          category: IngredientCategory.sayur,
          quantity: quantity,
          unit: unit,
          storageLocation: StorageLocation.kulkas,
          purchaseDate: created,
          expiryDate: expiryDate,
          expirySource: ExpirySource.estimasi,
          createdAt: created,
          updatedAt: created,
        ),
      );
}
