import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/barcode_cache.dart';

part 'barcode_cache_dao.g.dart';

@DriftAccessor(tables: [BarcodeCache])
class BarcodeCacheDao extends DatabaseAccessor<AppDatabase>
    with _$BarcodeCacheDaoMixin {
  BarcodeCacheDao(super.db);

  Future<BarcodeCacheEntry?> getByBarcode(String barcode) {
    return (select(
      barcodeCache,
    )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
  }

  Future<void> upsert(BarcodeCacheCompanion entry) {
    return into(barcodeCache).insert(entry, mode: InsertMode.insertOrReplace);
  }

  Future<int> deleteByBarcode(String barcode) {
    return (delete(barcodeCache)..where((t) => t.barcode.equals(barcode))).go();
  }

  /// Removes cache entries older than [maxAge].
  Future<int> purgeOlderThan(Duration maxAge, {DateTime? now}) {
    final cutoff = (now ?? DateTime.now()).subtract(maxAge);
    return (delete(
      barcodeCache,
    )..where((t) => t.fetchedAt.isSmallerThanValue(cutoff))).go();
  }

  Future<int> clear() => delete(barcodeCache).go();
}
