import 'dart:convert';

import '../../core/network/connectivity_checker.dart';
import '../local/daos/online_recipe_dao.dart';
import '../local/database.dart';
import '../models/online_recipe.dart';
import '../models/online_result.dart';
import '../remote/the_meal_db_service.dart';

/// Cache-first TheMealDB client used by the online recipe screens.
///
/// Search results are cached by recipe id so a recipe opened from the result
/// list is still available after the user goes offline.
class OnlineRecipeRepository {
  OnlineRecipeRepository({
    required this.dao,
    required this.remote,
    required this.connectivity,
    required this.isEnabled,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const cacheMaxAge = Duration(days: 14);

  final OnlineRecipeDao dao;
  final RecipeRemoteSource remote;
  final ConnectivityChecker connectivity;
  final bool Function() isEnabled;
  final DateTime Function() _clock;

  Future<OnlineResult<List<OnlineRecipe>>> search(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      return const OnlineResult<List<OnlineRecipe>>.success(<OnlineRecipe>[]);
    }

    if (!isEnabled()) {
      return const OnlineResult<List<OnlineRecipe>>.failure(
        OnlineFetchStatus.disabled,
      );
    }
    if (!await connectivity.isOnline) {
      return const OnlineResult<List<OnlineRecipe>>.failure(
        OnlineFetchStatus.offline,
      );
    }

    try {
      final results = await remote.search(query);
      await _cacheAll(results);
      return OnlineResult<List<OnlineRecipe>>.success(results);
    } on Object {
      return const OnlineResult<List<OnlineRecipe>>.failure(
        OnlineFetchStatus.error,
      );
    }
  }

  Future<OnlineResult<OnlineRecipe>> detail(String id) async {
    final cached = await _readCache(id);
    if (cached != null && _isFresh(cached)) {
      return OnlineResult<OnlineRecipe>.success(cached.recipe, fromCache: true);
    }

    if (!isEnabled()) {
      return _cachedFallback(cached?.recipe, OnlineFetchStatus.disabled);
    }
    if (!await connectivity.isOnline) {
      return _cachedFallback(cached?.recipe, OnlineFetchStatus.offline);
    }

    try {
      final recipe = await remote.lookup(id);
      if (recipe == null) {
        return const OnlineResult<OnlineRecipe>.failure(
          OnlineFetchStatus.notFound,
        );
      }
      await _cache(recipe);
      return OnlineResult<OnlineRecipe>.success(recipe);
    } on Object {
      return _cachedFallback(cached?.recipe, OnlineFetchStatus.error);
    }
  }

  Future<void> clearCache() => dao.clear();

  Future<void> _cacheAll(List<OnlineRecipe> recipes) async {
    for (final recipe in recipes) {
      await _cache(recipe);
    }
  }

  Future<void> _cache(OnlineRecipe recipe) {
    return dao.upsert(
      CachedOnlineRecipesCompanion.insert(
        idMeal: recipe.id,
        json: jsonEncode(recipe.toMealDbJson()),
        fetchedAt: _clock(),
      ),
    );
  }

  OnlineResult<OnlineRecipe> _cachedFallback(
    OnlineRecipe? cached,
    OnlineFetchStatus failure,
  ) {
    if (cached != null) {
      return OnlineResult<OnlineRecipe>.success(cached, fromCache: true);
    }
    return OnlineResult<OnlineRecipe>.failure(failure);
  }

  Future<_CachedRecipe?> _readCache(String id) async {
    final row = await dao.getByIdMeal(id);
    if (row == null) return null;
    try {
      final decoded = jsonDecode(row.json);
      if (decoded is! Map) return null;
      final recipe = parseMealDbRecipe(Map<String, dynamic>.from(decoded));
      if (recipe == null) return null;
      return _CachedRecipe(recipe: recipe, fetchedAt: row.fetchedAt);
    } on Object {
      return null;
    }
  }

  bool _isFresh(_CachedRecipe cached) {
    return _clock().difference(cached.fetchedAt) <= cacheMaxAge;
  }
}

class _CachedRecipe {
  const _CachedRecipe({required this.recipe, required this.fetchedAt});

  final OnlineRecipe recipe;
  final DateTime fetchedAt;
}
