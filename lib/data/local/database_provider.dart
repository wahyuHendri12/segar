import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'daos/barcode_cache_dao.dart';
import 'daos/catalog_dao.dart';
import 'daos/online_recipe_dao.dart';
import 'daos/pantry_dao.dart';
import 'daos/recipe_dao.dart';
import 'daos/shopping_list_dao.dart';
import 'daos/usage_log_dao.dart';
import 'database.dart';

/// Single database instance for the whole app.
///
/// Overridden in `main()` with the opened [AppDatabase]. Tests override this
/// with an in-memory database (`NativeDatabase.memory()`).
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final pantryDaoProvider = Provider<PantryDao>(
  (ref) => ref.watch(databaseProvider).pantryDao,
);

final usageLogDaoProvider = Provider<UsageLogDao>(
  (ref) => ref.watch(databaseProvider).usageLogDao,
);

final catalogDaoProvider = Provider<CatalogDao>(
  (ref) => ref.watch(databaseProvider).catalogDao,
);

final recipeDaoProvider = Provider<RecipeDao>(
  (ref) => ref.watch(databaseProvider).recipeDao,
);

final shoppingListDaoProvider = Provider<ShoppingListDao>(
  (ref) => ref.watch(databaseProvider).shoppingListDao,
);

final barcodeCacheDaoProvider = Provider<BarcodeCacheDao>(
  (ref) => ref.watch(databaseProvider).barcodeCacheDao,
);

final onlineRecipeDaoProvider = Provider<OnlineRecipeDao>(
  (ref) => ref.watch(databaseProvider).onlineRecipeDao,
);
