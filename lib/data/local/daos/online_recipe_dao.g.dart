// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_recipe_dao.dart';

// ignore_for_file: type=lint
mixin _$OnlineRecipeDaoMixin on DatabaseAccessor<AppDatabase> {
  $CachedOnlineRecipesTable get cachedOnlineRecipes =>
      attachedDatabase.cachedOnlineRecipes;
  OnlineRecipeDaoManager get managers => OnlineRecipeDaoManager(this);
}

class OnlineRecipeDaoManager {
  final _$OnlineRecipeDaoMixin _db;
  OnlineRecipeDaoManager(this._db);
  $$CachedOnlineRecipesTableTableManager get cachedOnlineRecipes =>
      $$CachedOnlineRecipesTableTableManager(
        _db.attachedDatabase,
        _db.cachedOnlineRecipes,
      );
}
