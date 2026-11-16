import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/online_recipe.dart';
import '../../data/models/online_result.dart';
import '../../data/repositories/repository_providers.dart';

/// State of the online recipe search screen.
class OnlineRecipeSearchState {
  const OnlineRecipeSearchState({
    this.query = '',
    this.isLoading = false,
    this.result,
  });

  final String query;
  final bool isLoading;
  final OnlineResult<List<OnlineRecipe>>? result;
}

class OnlineRecipeSearchController extends Notifier<OnlineRecipeSearchState> {
  @override
  OnlineRecipeSearchState build() => const OnlineRecipeSearchState();

  Future<void> search(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      state = const OnlineRecipeSearchState();
      return;
    }

    state = OnlineRecipeSearchState(query: query, isLoading: true);
    final result = await ref.read(onlineRecipeRepositoryProvider).search(query);
    state = OnlineRecipeSearchState(query: query, result: result);
  }

  void clear() => state = const OnlineRecipeSearchState();
}

final onlineRecipeSearchProvider =
    NotifierProvider<OnlineRecipeSearchController, OnlineRecipeSearchState>(
      OnlineRecipeSearchController.new,
    );

final onlineRecipeDetailProvider = FutureProvider.autoDispose
    .family<OnlineResult<OnlineRecipe>, String>(
      (ref, id) => ref.watch(onlineRecipeRepositoryProvider).detail(id),
    );
