import '../../data/local/enums.dart';
import 'expiry_utils.dart';

/// Minimal ingredient shape needed to score a recipe.
class RecipeIngredientInput {
  const RecipeIngredientInput({
    required this.name,
    this.catalogId,
    this.isOptional = false,
    this.isStaple = false,
  });

  final String name;
  final String? catalogId;
  final bool isOptional;
  final bool isStaple;
}

/// Minimal pantry stock shape needed to score a recipe.
class PantryStockInput {
  const PantryStockInput({
    required this.name,
    required this.expiryDate,
    this.id,
    this.catalogId,
    this.aliases = const <String>[],
  });

  final String name;
  final String? catalogId;
  final DateTime expiryDate;
  final List<String> aliases;

  /// Pantry row id, used by the recipe screen to link back to the item.
  final String? id;
}

String _normalize(String value) => value.trim().toLowerCase();

/// Matches a recipe line to a pantry item by catalog id, normalized name, or
/// one of the pantry item's catalog aliases.
bool ingredientMatches(
  RecipeIngredientInput ingredient,
  PantryStockInput stock,
) {
  final ingredientCatalogId = ingredient.catalogId;
  final stockCatalogId = stock.catalogId;
  if (ingredientCatalogId != null &&
      stockCatalogId != null &&
      ingredientCatalogId == stockCatalogId) {
    return true;
  }

  final ingredientName = _normalize(ingredient.name);
  if (ingredientName.isEmpty) return false;
  if (_normalize(stock.name) == ingredientName) return true;
  return stock.aliases.any((alias) => _normalize(alias) == ingredientName);
}

/// First pantry stock that satisfies [ingredient], or null when missing.
PantryStockInput? findStockFor(
  RecipeIngredientInput ingredient,
  Iterable<PantryStockInput> stock,
) {
  for (final item in stock) {
    if (ingredientMatches(ingredient, item)) return item;
  }
  return null;
}

/// Scores how well the pantry can support a recipe (0..100).
double recipeScore({
  required List<RecipeIngredientInput> ingredients,
  required List<PantryStockInput> stock,
  int urgentDays = 3,
  DateTime? now,
}) {
  final requiredIngredients = ingredients
      .where((ingredient) => !ingredient.isOptional && !ingredient.isStaple)
      .toList(growable: false);

  if (requiredIngredients.isEmpty) return 0;

  final owned = requiredIngredients
      .where(
        (ingredient) =>
            stock.any((item) => ingredientMatches(ingredient, item)),
      )
      .length;

  final urgent = requiredIngredients.where((ingredient) {
    return stock.any(
      (item) =>
          ingredientMatches(ingredient, item) &&
          statusFor(item.expiryDate, now: now, warnDays: urgentDays) !=
              ExpiryStatus.aman,
    );
  }).length;

  var score =
      owned / requiredIngredients.length * 60 + (urgent * 10).clamp(0, 30);

  if (owned == requiredIngredients.length) score += 10;

  return score.toDouble();
}
