import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/recipe_filter.dart';
import '../../core/utils/recipe_match.dart';
import '../../data/models/pantry_item_view.dart';
import '../../data/models/recipe_view.dart';
import '../../data/repositories/repository_providers.dart';

/// Recipes enriched with pantry availability and match scores.
final recipeSuggestionsProvider = StreamProvider.autoDispose<List<RecipeView>>(
  (ref) => ref.watch(recipeRepositoryProvider).watchSuggestions(),
);

/// One recipe that re-scores whenever the pantry changes.
final recipeDetailProvider = StreamProvider.autoDispose
    .family<RecipeView?, String>(
      (ref, id) => ref.watch(recipeRepositoryProvider).watchRecipe(id),
    );

/// Active pantry used by the smart-match card.
final recipePantryProvider = StreamProvider.autoDispose<List<PantryItemView>>(
  (ref) => ref.watch(pantryRepositoryProvider).watchActive(),
);

/// Urgent pantry items that at least one recipe can rescue.
final recipeSmartMatchProvider = Provider.autoDispose<RecipeSmartMatch>((ref) {
  final recipes =
      ref.watch(recipeSuggestionsProvider).value ?? const <RecipeView>[];
  final pantry =
      ref.watch(recipePantryProvider).value ?? const <PantryItemView>[];
  return smartMatchFor(recipes: recipes, pantry: pantry);
});

class RecipeFilterNotifier extends Notifier<RecipeFilterState> {
  @override
  RecipeFilterState build() => const RecipeFilterState();

  void setTag(String? tag) {
    state = state.copyWith(tag: tag, clearTag: tag == null);
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void clear() {
    state = const RecipeFilterState();
  }
}

final recipeFilterProvider =
    NotifierProvider<RecipeFilterNotifier, RecipeFilterState>(
      RecipeFilterNotifier.new,
    );

/// Recipes matching the active tag and search query, best match first.
final filteredRecipesProvider = Provider.autoDispose<List<RecipeView>>((ref) {
  final recipes =
      ref.watch(recipeSuggestionsProvider).value ?? const <RecipeView>[];
  return filterRecipes(recipes, ref.watch(recipeFilterProvider));
});
