import 'package:drift/drift.dart' show Value;

import '../../core/network/connectivity_checker.dart';
import '../../core/utils/barcode_utils.dart';
import '../local/daos/barcode_cache_dao.dart';
import '../local/database.dart';
import '../local/enums.dart';
import '../models/barcode_lookup.dart';
import '../models/online_result.dart';
import '../remote/open_food_facts_service.dart';

/// Cache-first barcode lookup.
///
/// A fresh cache entry is used immediately. When the online feature is
/// disabled or the device is offline, an older cache entry is still returned so
/// the add-item flow keeps working.
class BarcodeRepository {
  BarcodeRepository({
    required this.dao,
    required this.remote,
    required this.connectivity,
    required this.isEnabled,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const cacheMaxAge = Duration(days: 30);

  final BarcodeCacheDao dao;
  final BarcodeRemoteSource remote;
  final ConnectivityChecker connectivity;
  final bool Function() isEnabled;
  final DateTime Function() _clock;

  Future<OnlineResult<BarcodeLookup>> lookup(String rawBarcode) async {
    final barcode = normalizeBarcode(rawBarcode);
    if (!isValidBarcode(barcode)) {
      return const OnlineResult<BarcodeLookup>.failure(
        OnlineFetchStatus.notFound,
      );
    }

    final cached = await dao.getByBarcode(barcode);
    if (cached != null && _isFresh(cached)) {
      return OnlineResult<BarcodeLookup>.success(
        _fromCache(cached),
        fromCache: true,
      );
    }

    if (!isEnabled()) {
      return _cachedFallback(cached, OnlineFetchStatus.disabled);
    }

    if (!await connectivity.isOnline) {
      return _cachedFallback(cached, OnlineFetchStatus.offline);
    }

    try {
      final lookup = await remote.fetch(barcode);
      if (lookup == null) {
        return const OnlineResult<BarcodeLookup>.failure(
          OnlineFetchStatus.notFound,
        );
      }
      await _cache(lookup, source: BarcodeSource.off);
      return OnlineResult<BarcodeLookup>.success(lookup);
    } on Object {
      return _cachedFallback(cached, OnlineFetchStatus.error);
    }
  }

  /// Stores a barcode the user typed or confirmed, so future scans resolve
  /// without internet.
  Future<void> rememberLocal(BarcodeLookup lookup) {
    return _cache(lookup, source: BarcodeSource.lokal);
  }

  Future<void> clearCache() => dao.clear();

  Future<void> _cache(BarcodeLookup lookup, {required BarcodeSource source}) {
    return dao.upsert(
      BarcodeCacheCompanion.insert(
        barcode: lookup.barcode,
        name: lookup.name,
        brand: Value(lookup.brand),
        category: lookup.category,
        quantityText: Value(lookup.quantityText),
        source: source,
        fetchedAt: _clock(),
      ),
    );
  }

  OnlineResult<BarcodeLookup> _cachedFallback(
    BarcodeCacheEntry? cached,
    OnlineFetchStatus failure,
  ) {
    if (cached != null) {
      return OnlineResult<BarcodeLookup>.success(
        _fromCache(cached),
        fromCache: true,
      );
    }
    return OnlineResult<BarcodeLookup>.failure(failure);
  }

  bool _isFresh(BarcodeCacheEntry entry) {
    return _clock().difference(entry.fetchedAt) <= cacheMaxAge;
  }

  BarcodeLookup _fromCache(BarcodeCacheEntry entry) {
    final pack = parsePackQuantity(entry.quantityText);
    return BarcodeLookup(
      barcode: entry.barcode,
      name: entry.name,
      brand: entry.brand,
      category: entry.category,
      quantityText: entry.quantityText,
      quantity: pack?.quantity,
      unit: pack?.unit,
      source: entry.source,
    );
  }
}
