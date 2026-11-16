import '../../data/models/recipe_view.dart';

/// Recipe list filter: free-text search plus one tag chip.
class RecipeFilterState {
  const RecipeFilterState({this.query = '', this.tag});

  final String query;

  /// Null means "Semua Resep". Values map to recipe tags such as `cepat`,
  /// `kos`, `kuah` and `tumis`.
  final String? tag;

  RecipeFilterState copyWith({
    String? query,
    String? tag,
    bool clearTag = false,
  }) {
    return RecipeFilterState(
      query: query ?? this.query,
      tag: clearTag ? null : (tag ?? this.tag),
    );
  }
}

String _normalize(String value) => value.trim().toLowerCase();

bool _matchesTag(RecipeView recipe, String tag) {
  if (tag == 'cepat') return recipe.isQuick || recipe.tags.contains('cepat');
  return recipe.tags.contains(tag);
}

bool _matchesQuery(RecipeView recipe, String query) {
  if (query.isEmpty) return true;
  if (_normalize(recipe.title).contains(query)) return true;
  return recipe.ingredients.any(
    (ingredient) => _normalize(ingredient.name).contains(query),
  );
}

/// Filters by tag and query, then orders the best match first.
List<RecipeView> filterRecipes(
  List<RecipeView> recipes,
  RecipeFilterState filter,
) {
  final query = _normalize(filter.query);
  final tag = filter.tag;

  final filtered = recipes
      .where((recipe) => tag == null || _matchesTag(recipe, tag))
      .where((recipe) => _matchesQuery(recipe, query))
      .toList(growable: false);

  final sorted = <RecipeView>[...filtered]
    ..sort((a, b) {
      final score = b.matchScore.compareTo(a.matchScore);
      if (score != 0) return score;
      final time = a.cookTimeMin.compareTo(b.cookTimeMin);
      if (time != 0) return time;
      return a.title.compareTo(b.title);
    });

  return sorted;
}

/// Number of recipes that match a tag chip.
int recipeTagCount(List<RecipeView> recipes, String? tag) {
  if (tag == null) return recipes.length;
  return recipes.where((recipe) => _matchesTag(recipe, tag)).length;
}
