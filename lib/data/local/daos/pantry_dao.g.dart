// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_dao.dart';

// ignore_for_file: type=lint
mixin _$PantryDaoMixin on DatabaseAccessor<AppDatabase> {
  $PantryItemsTable get pantryItems => attachedDatabase.pantryItems;
  $UsageLogsTable get usageLogs => attachedDatabase.usageLogs;
  PantryDaoManager get managers => PantryDaoManager(this);
}

class PantryDaoManager {
  final _$PantryDaoMixin _db;
  PantryDaoManager(this._db);
  $$PantryItemsTableTableManager get pantryItems =>
      $$PantryItemsTableTableManager(_db.attachedDatabase, _db.pantryItems);
  $$UsageLogsTableTableManager get usageLogs =>
      $$UsageLogsTableTableManager(_db.attachedDatabase, _db.usageLogs);
}
