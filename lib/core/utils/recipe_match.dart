import '../../data/models/pantry_item_view.dart';
import '../../data/models/recipe_view.dart';

/// Urgent pantry items that at least one recipe can rescue.
class RecipeSmartMatch {
  const RecipeSmartMatch({
    required this.urgentTotal,
    required this.rescuedItems,
  });

  final int urgentTotal;
  final List<PantryItemView> rescuedItems;

  int get rescuedCount => rescuedItems.length;

  bool get hasUrgent => urgentTotal > 0;

  /// "2 dari 3" style counts used by the smart-match card.
  int get missingCount => urgentTotal - rescuedCount;
}

/// Cross-references urgent pantry items with every recipe's matched items.
///
/// Items that are already expired are excluded because they should be thrown
/// away, not cooked.
RecipeSmartMatch smartMatchFor({
  required List<RecipeView> recipes,
  required List<PantryItemView> pantry,
}) {
  final urgentItems = pantry
      .where((item) => item.isUrgent)
      .toList(growable: false);
  if (urgentItems.isEmpty) {
    return const RecipeSmartMatch(
      urgentTotal: 0,
      rescuedItems: <PantryItemView>[],
    );
  }

  final matchedIds = <String>{};
  for (final recipe in recipes) {
    for (final ingredient in recipe.matchedIngredients) {
      final id = ingredient.matchedItem?.id;
      if (id != null) matchedIds.add(id);
    }
  }

  final rescued = urgentItems
      .where((item) => matchedIds.contains(item.id))
      .toList(growable: false);

  return RecipeSmartMatch(
    urgentTotal: urgentItems.length,
    rescuedItems: rescued,
  );
}
