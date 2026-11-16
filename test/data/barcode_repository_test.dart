import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/barcode_lookup.dart';
import 'package:segar/data/models/online_result.dart';
import 'package:segar/data/repositories/barcode_repository.dart';

import '../helpers/fake_online_sources.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeBarcodeRemoteSource remote;
  late FakeConnectivityChecker connectivity;
  late bool enabled;
  late DateTime now;

  const barcode = '8991002101234';
  const lookup = BarcodeLookup(
    barcode: barcode,
    name: 'Susu UHT Cokelat',
    brand: 'Segar Dairy',
    category: IngredientCategory.telurSusu,
    quantityText: '1 L',
    quantity: 1,
    unit: Unit.liter,
  );

  BarcodeRepository buildRepository() {
    return BarcodeRepository(
      dao: db.barcodeCacheDao,
      remote: remote,
      connectivity: connectivity,
      isEnabled: () => enabled,
      clock: () => now,
    );
  }

  setUp(() {
    db = openTestDatabase();
    remote = FakeBarcodeRemoteSource(result: lookup);
    connectivity = FakeConnectivityChecker();
    enabled = true;
    now = DateTime(2026, 11, 10, 10);
  });

  tearDown(() async {
    await db.close();
  });

  test('caches a successful lookup and serves it offline', () async {
    final repository = buildRepository();

    final fresh = await repository.lookup('899-1002-101234');
    expect(fresh.isSuccess, isTrue);
    expect(fresh.fromCache, isFalse);
    expect(fresh.data!.name, lookup.name);
    expect(remote.calls, 1);

    final row = await db.barcodeCacheDao.getByBarcode(barcode);
    expect(row, isNotNull);
    expect(row!.source, BarcodeSource.off);
    expect(row.name, lookup.name);

    connectivity.online = false;
    remote.result = null;

    final cached = await repository.lookup(barcode);
    expect(cached.isSuccess, isTrue);
    expect(cached.fromCache, isTrue);
    expect(cached.data!.quantityText, '1 L');
    expect(cached.data!.quantity, 1);
    expect(remote.calls, 1);
  });

  test('uses a fresh cache without touching the network', () async {
    final repository = buildRepository();
    await repository.lookup(barcode);
    remote.calls = 0;

    final cached = await repository.lookup(barcode);

    expect(cached.fromCache, isTrue);
    expect(remote.calls, 0);
  });

  test('returns disabled when there is no cache', () async {
    enabled = false;
    final repository = buildRepository();

    final result = await repository.lookup(barcode);

    expect(result.status, OnlineFetchStatus.disabled);
    expect(remote.calls, 0);
  });

  test('returns offline when there is no cache', () async {
    connectivity.online = false;
    final repository = buildRepository();

    final result = await repository.lookup(barcode);

    expect(result.status, OnlineFetchStatus.offline);
    expect(remote.calls, 0);
  });

  test('rejects invalid barcodes before any request', () async {
    final repository = buildRepository();

    final result = await repository.lookup('123');

    expect(result.status, OnlineFetchStatus.notFound);
    expect(remote.calls, 0);
  });

  test('maps unknown products to notFound', () async {
    remote.result = null;
    final repository = buildRepository();

    final result = await repository.lookup(barcode);

    expect(result.status, OnlineFetchStatus.notFound);
  });

  test('returns error when the request fails and nothing is cached', () async {
    remote.error = Exception('network down');
    final repository = buildRepository();

    final result = await repository.lookup(barcode);

    expect(result.status, OnlineFetchStatus.error);
  });

  test('falls back to a stale cache when the request fails', () async {
    final repository = buildRepository();
    await repository.lookup(barcode);

    now = now.add(const Duration(days: 31));
    remote.error = Exception('network down');

    final result = await repository.lookup(barcode);

    expect(result.isSuccess, isTrue);
    expect(result.fromCache, isTrue);
    expect(result.data!.name, lookup.name);
  });

  test('rememberLocal makes a barcode resolvable offline', () async {
    connectivity.online = false;
    remote.result = null;
    final repository = buildRepository();

    await repository.rememberLocal(lookup);
    final result = await repository.lookup(barcode);

    expect(result.isSuccess, isTrue);
    expect(result.fromCache, isTrue);
    expect(result.data!.source, BarcodeSource.lokal);
    expect(remote.calls, 0);
  });

  test('clearCache removes remembered barcodes', () async {
    final repository = buildRepository();
    await repository.rememberLocal(lookup);

    await repository.clearCache();

    expect(await db.barcodeCacheDao.getByBarcode(barcode), isNull);
  });
}
