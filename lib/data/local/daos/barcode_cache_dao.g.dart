// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$BarcodeCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $BarcodeCacheTable get barcodeCache => attachedDatabase.barcodeCache;
  BarcodeCacheDaoManager get managers => BarcodeCacheDaoManager(this);
}

class BarcodeCacheDaoManager {
  final _$BarcodeCacheDaoMixin _db;
  BarcodeCacheDaoManager(this._db);
  $$BarcodeCacheTableTableManager get barcodeCache =>
      $$BarcodeCacheTableTableManager(_db.attachedDatabase, _db.barcodeCache);
}
