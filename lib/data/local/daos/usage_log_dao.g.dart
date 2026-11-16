// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_log_dao.dart';

// ignore_for_file: type=lint
mixin _$UsageLogDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsageLogsTable get usageLogs => attachedDatabase.usageLogs;
  UsageLogDaoManager get managers => UsageLogDaoManager(this);
}

class UsageLogDaoManager {
  final _$UsageLogDaoMixin _db;
  UsageLogDaoManager(this._db);
  $$UsageLogsTableTableManager get usageLogs =>
      $$UsageLogsTableTableManager(_db.attachedDatabase, _db.usageLogs);
}
