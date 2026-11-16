// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_dao.dart';

// ignore_for_file: type=lint
mixin _$ShoppingListDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShoppingListItemsTable get shoppingListItems =>
      attachedDatabase.shoppingListItems;
  ShoppingListDaoManager get managers => ShoppingListDaoManager(this);
}

class ShoppingListDaoManager {
  final _$ShoppingListDaoMixin _db;
  ShoppingListDaoManager(this._db);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(
        _db.attachedDatabase,
        _db.shoppingListItems,
      );
}
