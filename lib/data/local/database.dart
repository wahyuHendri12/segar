import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/barcode_cache_dao.dart';
import 'daos/catalog_dao.dart';
import 'daos/online_recipe_dao.dart';
import 'daos/pantry_dao.dart';
import 'daos/recipe_dao.dart';
import 'daos/shopping_list_dao.dart';
import 'daos/usage_log_dao.dart';
import 'enums.dart';
import 'tables/barcode_cache.dart';
import 'tables/cached_online_recipes.dart';
import 'tables/converters.dart';
import 'tables/ingredient_catalogs.dart';
import 'tables/pantry_items.dart';
import 'tables/recipes.dart';
import 'tables/shopping_list_items.dart';
import 'tables/usage_logs.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: <Type>[
    PantryItems,
    UsageLogs,
    IngredientCatalogs,
    Recipes,
    RecipeIngredients,
    BarcodeCache,
    ShoppingListItems,
    CachedOnlineRecipes,
  ],
  daos: <Type>[
    PantryDao,
    UsageLogDao,
    CatalogDao,
    RecipeDao,
    ShoppingListDao,
    BarcodeCacheDao,
    OnlineRecipeDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // Add one `if (from < N)` block per schema version when the schema
      // changes. Never edit an already released block.
      //
      // if (from < 2) {
      //   await migrator.addColumn(pantryItems, pantryItems.newColumn);
      // }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'segar');
  }
}
