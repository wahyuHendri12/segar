import '../local/enums.dart';
import 'pantry_item_view.dart';

/// One recipe line enriched with pantry availability.
class RecipeIngredientView {
  const RecipeIngredientView({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.isOptional,
    required this.isStaple,
    this.catalogId,
    this.matchedItem,
  });

  final String id;
  final String? catalogId;
  final String name;
  final double amount;
  final Unit unit;
  final bool isOptional;
  final bool isStaple;

  /// The pantry item that satisfies this line, when the user owns it.
  final PantryItemView? matchedItem;

  bool get isAvailable => matchedItem != null;

  /// Optional lines and pantry staples never block a recipe.
  bool get isRequired => !isOptional && !isStaple;

  /// The matched item is close to expiring and should be rescued.
  bool get isUrgent => matchedItem?.isUrgent ?? false;

  /// Amount scaled from the recipe base servings to [servings].
  double scaledAmount(int servings, int baseServings) {
    if (baseServings <= 0 || servings == baseServings) return amount;
    return amount * servings / baseServings;
  }
}

/// Presentation-friendly recipe with its match score for the current pantry.
class RecipeView {
  const RecipeView({
    required this.id,
    required this.title,
    required this.emoji,
    required this.cookTimeMin,
    required this.difficulty,
    required this.servings,
    required this.estimatedCostIdr,
    required this.isQuick,
    required this.tags,
    required this.steps,
    required this.ingredients,
    required this.matchScore,
    required this.ownedRequiredCount,
    required this.requiredCount,
    this.imageAsset,
  });

  final String id;
  final String title;
  final String emoji;
  final String? imageAsset;
  final int cookTimeMin;
  final RecipeDifficulty difficulty;
  final int servings;
  final int estimatedCostIdr;
  final bool isQuick;
  final List<String> tags;
  final List<String> steps;
  final List<RecipeIngredientView> ingredients;

  /// 0..100 score from [recipeScore].
  final double matchScore;
  final int ownedRequiredCount;
  final int requiredCount;

  bool get isComplete =>
      requiredCount > 0 && ownedRequiredCount == requiredCount;

  List<RecipeIngredientView> get requiredIngredients => ingredients
      .where((ingredient) => ingredient.isRequired)
      .toList(growable: false);

  List<RecipeIngredientView> get missingRequired => ingredients
      .where((ingredient) => ingredient.isRequired && !ingredient.isAvailable)
      .toList(growable: false);

  List<RecipeIngredientView> get availableIngredients => ingredients
      .where((ingredient) => ingredient.isAvailable)
      .toList(growable: false);

  List<RecipeIngredientView> get urgentIngredients => ingredients
      .where((ingredient) => ingredient.isUrgent)
      .toList(growable: false);

  List<RecipeIngredientView> get matchedIngredients => ingredients
      .where((ingredient) => ingredient.isAvailable)
      .toList(growable: false);
}
