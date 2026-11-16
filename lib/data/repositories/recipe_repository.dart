import '../../core/utils/recipe_score.dart';
import '../local/daos/recipe_dao.dart';
import '../models/pantry_item_view.dart';
import '../models/recipe_view.dart';
import 'pantry_repository.dart';

/// Reads recipes and enriches them with the current pantry.
///
/// The presentation layer never touches Drift rows or the recipe DAO.
class RecipeRepository {
  RecipeRepository({
    required this.recipeDao,
    required this.pantryRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final RecipeDao recipeDao;
  final PantryRepository pantryRepository;
  final DateTime Function() _clock;

  /// Recipes ordered by the DAO (title) and enriched with match information.
  ///
  /// The stream re-emits whenever the pantry changes, so scores and
  /// availability stay in sync after adding, editing or cooking an item.
  Stream<List<RecipeView>> watchSuggestions() {
    return pantryRepository.watchActive().asyncMap((pantry) async {
      final rows = await recipeDao.getAllWithIngredients();
      return rows.map((row) => _toView(row, pantry)).toList(growable: false);
    });
  }

  Stream<RecipeView?> watchRecipe(String id) {
    return pantryRepository.watchActive().asyncMap((pantry) async {
      final row = await recipeDao.getWithIngredients(id);
      if (row == null) return null;
      return _toView(row, pantry);
    });
  }

  Future<RecipeView?> getRecipe(String id) async {
    final row = await recipeDao.getWithIngredients(id);
    if (row == null) return null;
    final pantry = await pantryRepository.watchActive().first;
    return _toView(row, pantry);
  }

  /// Marks the selected recipe lines as used in the pantry.
  ///
  /// When the recipe amount uses the same unit as the pantry item and is
  /// smaller than the stock, only that amount is deducted. Otherwise the item
  /// is marked fully used. Duplicate matches are only consumed once.
  Future<List<PantryActionOutcome>> cook({
    required RecipeView recipe,
    required int servings,
    required Set<String> ingredientIds,
  }) async {
    final outcomes = <PantryActionOutcome>[];
    final consumedItems = <String>{};

    for (final ingredient in recipe.ingredients) {
      if (!ingredientIds.contains(ingredient.id)) continue;
      final item = ingredient.matchedItem;
      if (item == null) continue;
      if (!consumedItems.add(item.id)) continue;

      final amount = ingredient.scaledAmount(servings, recipe.servings);
      final canUsePartially =
          ingredient.unit == item.unit && amount > 0 && amount < item.quantity;

      outcomes.add(
        canUsePartially
            ? await pantryRepository.markPartiallyUsed(item, amount)
            : await pantryRepository.markUsed(item),
      );
    }

    return outcomes;
  }

  Future<void> undoUsage({required String usageLogId, required String itemId}) {
    return pantryRepository.undoUsage(usageLogId: usageLogId, itemId: itemId);
  }

  RecipeView _toView(RecipeWithIngredients data, List<PantryItemView> pantry) {
    // Expired stock must not be suggested for cooking.
    final usablePantry = pantry
        .where((item) => !item.isExpired)
        .toList(growable: false);
    final stock = usablePantry
        .map(
          (item) => PantryStockInput(
            id: item.id,
            name: item.name,
            catalogId: item.catalogId,
            expiryDate: item.expiryDate,
            aliases: item.catalog?.aliases ?? const <String>[],
          ),
        )
        .toList(growable: false);
    final pantryById = <String, PantryItemView>{
      for (final item in usablePantry) item.id: item,
    };

    final inputs = <RecipeIngredientInput>[];
    final ingredients = <RecipeIngredientView>[];
    for (final row in data.ingredients) {
      final input = RecipeIngredientInput(
        name: row.name,
        catalogId: row.catalogId,
        isOptional: row.isOptional,
        isStaple: row.isStaple,
      );
      inputs.add(input);

      final match = findStockFor(input, stock);
      final matchedId = match?.id;
      ingredients.add(
        RecipeIngredientView(
          id: row.id,
          catalogId: row.catalogId,
          name: row.name,
          amount: row.amount,
          unit: row.unit,
          isOptional: row.isOptional,
          isStaple: row.isStaple,
          matchedItem: matchedId == null ? null : pantryById[matchedId],
        ),
      );
    }

    final required = ingredients
        .where((ingredient) => ingredient.isRequired)
        .toList(growable: false);
    final owned = required.where((ingredient) => ingredient.isAvailable).length;

    final recipe = data.recipe;
    return RecipeView(
      id: recipe.id,
      title: recipe.title,
      emoji: recipe.emoji,
      imageAsset: recipe.imageAsset,
      cookTimeMin: recipe.cookTimeMin,
      difficulty: recipe.difficulty,
      servings: recipe.servings,
      estimatedCostIdr: recipe.estimatedCostIdr,
      isQuick: recipe.isQuick,
      tags: recipe.tags,
      steps: recipe.steps,
      ingredients: ingredients,
      matchScore: recipeScore(ingredients: inputs, stock: stock, now: _clock()),
      ownedRequiredCount: owned,
      requiredCount: required.length,
    );
  }
}
