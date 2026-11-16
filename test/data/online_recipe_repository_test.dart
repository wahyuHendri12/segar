import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/models/online_recipe.dart';
import 'package:segar/data/models/online_result.dart';
import 'package:segar/data/repositories/online_recipe_repository.dart';

import '../helpers/fake_online_sources.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeRecipeRemoteSource remote;
  late FakeConnectivityChecker connectivity;
  late bool enabled;
  late DateTime now;

  final recipe = sampleOnlineRecipe();

  OnlineRecipeRepository buildRepository() {
    return OnlineRecipeRepository(
      dao: db.onlineRecipeDao,
      remote: remote,
      connectivity: connectivity,
      isEnabled: () => enabled,
      clock: () => now,
    );
  }

  setUp(() {
    db = openTestDatabase();
    remote = FakeRecipeRemoteSource(
      searchResults: <OnlineRecipe>[recipe],
      details: <String, OnlineRecipe>{recipe.id: recipe},
    );
    connectivity = FakeConnectivityChecker();
    enabled = true;
    now = DateTime(2026, 11, 10, 10);
  });

  tearDown(() async {
    await db.close();
  });

  test('search caches results so detail works offline', () async {
    final repository = buildRepository();

    final search = await repository.search('nasi');
    expect(search.isSuccess, isTrue);
    expect(search.data, hasLength(1));
    expect(remote.searchCalls, 1);

    final row = await db.onlineRecipeDao.getByIdMeal(recipe.id);
    expect(row, isNotNull);

    connectivity.online = false;

    final detail = await repository.detail(recipe.id);
    expect(detail.isSuccess, isTrue);
    expect(detail.fromCache, isTrue);
    expect(detail.data!.title, recipe.title);
    expect(detail.data!.ingredients, hasLength(3));
    expect(remote.lookupCalls, 0);
  });

  test('fresh detail cache skips the network', () async {
    final repository = buildRepository();
    await repository.search('nasi');

    final detail = await repository.detail(recipe.id);

    expect(detail.fromCache, isTrue);
    expect(remote.lookupCalls, 0);
  });

  test('empty queries return an empty success without a request', () async {
    final repository = buildRepository();

    final result = await repository.search('   ');

    expect(result.isSuccess, isTrue);
    expect(result.data, isEmpty);
    expect(remote.searchCalls, 0);
  });

  test('search returns disabled when the feature is off', () async {
    enabled = false;
    final repository = buildRepository();

    final result = await repository.search('nasi');

    expect(result.status, OnlineFetchStatus.disabled);
    expect(remote.searchCalls, 0);
  });

  test('search returns offline without a connection', () async {
    connectivity.online = false;
    final repository = buildRepository();

    final result = await repository.search('nasi');

    expect(result.status, OnlineFetchStatus.offline);
    expect(remote.searchCalls, 0);
  });

  test('search maps failures to error', () async {
    remote.error = Exception('network down');
    final repository = buildRepository();

    final result = await repository.search('nasi');

    expect(result.status, OnlineFetchStatus.error);
  });

  test('detail maps a missing recipe to notFound', () async {
    remote.details = const <String, OnlineRecipe>{};
    final repository = buildRepository();

    final result = await repository.detail('missing');

    expect(result.status, OnlineFetchStatus.notFound);
  });

  test('detail falls back to a stale cache on network errors', () async {
    final repository = buildRepository();
    await repository.search('nasi');

    now = now.add(const Duration(days: 15));
    remote.error = Exception('network down');

    final detail = await repository.detail(recipe.id);

    expect(detail.isSuccess, isTrue);
    expect(detail.fromCache, isTrue);
    expect(detail.data!.title, recipe.title);
  });

  test('clearCache empties the recipe cache', () async {
    final repository = buildRepository();
    await repository.search('nasi');

    await repository.clearCache();

    expect(await db.onlineRecipeDao.getByIdMeal(recipe.id), isNull);
  });
}
