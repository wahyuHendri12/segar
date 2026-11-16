import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/cached_online_recipes.dart';

part 'online_recipe_dao.g.dart';

@DriftAccessor(tables: [CachedOnlineRecipes])
class OnlineRecipeDao extends DatabaseAccessor<AppDatabase>
    with _$OnlineRecipeDaoMixin {
  OnlineRecipeDao(super.db);

  Future<CachedOnlineRecipe?> getByIdMeal(String idMeal) {
    return (select(
      cachedOnlineRecipes,
    )..where((t) => t.idMeal.equals(idMeal))).getSingleOrNull();
  }

  Future<void> upsert(CachedOnlineRecipesCompanion entry) {
    return into(cachedOnlineRecipes)
        .insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<int> purgeOlderThan(Duration maxAge, {DateTime? now}) {
    final cutoff = (now ?? DateTime.now()).subtract(maxAge);
    return (delete(
      cachedOnlineRecipes,
    )..where((t) => t.fetchedAt.isSmallerThanValue(cutoff))).go();
  }

  Future<int> clear() => delete(cachedOnlineRecipes).go();
}
