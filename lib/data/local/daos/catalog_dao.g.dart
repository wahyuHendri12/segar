// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogDaoMixin on DatabaseAccessor<AppDatabase> {
  $IngredientCatalogsTable get ingredientCatalogs =>
      attachedDatabase.ingredientCatalogs;
  CatalogDaoManager get managers => CatalogDaoManager(this);
}

class CatalogDaoManager {
  final _$CatalogDaoMixin _db;
  CatalogDaoManager(this._db);
  $$IngredientCatalogsTableTableManager get ingredientCatalogs =>
      $$IngredientCatalogsTableTableManager(
        _db.attachedDatabase,
        _db.ingredientCatalogs,
      );
}
