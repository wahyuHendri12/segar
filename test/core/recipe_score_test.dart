import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/recipe_score.dart';

void main() {
  final now = DateTime(2026, 11, 9);

  PantryStockInput stock(
    String name, {
    String? catalogId,
    DateTime? expiry,
    List<String> aliases = const <String>[],
  }) {
    return PantryStockInput(
      name: name,
      catalogId: catalogId,
      expiryDate: expiry ?? DateTime(2026, 11, 30),
      aliases: aliases,
    );
  }

  group('ingredientMatches', () {
    test('matches by catalog id', () {
      const ingredient = RecipeIngredientInput(
        name: 'Bayam',
        catalogId: 'bayam',
      );

      expect(
        ingredientMatches(ingredient, stock('Bayam', catalogId: 'bayam')),
        isTrue,
      );
    });

    test('matches by normalized name', () {
      const ingredient = RecipeIngredientInput(name: '  BAYAM ');
      expect(ingredientMatches(ingredient, stock('bayam')), isTrue);
    });

    test('matches by pantry alias', () {
      const ingredient = RecipeIngredientInput(name: 'bayam hijau');
      expect(
        ingredientMatches(
          ingredient,
          stock('Bayam', aliases: <String>['bayam hijau', 'spinach']),
        ),
        isTrue,
      );
    });

    test('rejects unrelated ingredients', () {
      const ingredient = RecipeIngredientInput(name: 'bayam');
      expect(ingredientMatches(ingredient, stock('kangkung')), isFalse);
    });
  });

  group('recipeScore', () {
    test('returns zero when the recipe has no required ingredients', () {
      expect(
        recipeScore(
          ingredients: const <RecipeIngredientInput>[
            RecipeIngredientInput(name: 'garam', isStaple: true),
          ],
          stock: <PantryStockInput>[stock('garam')],
          now: now,
        ),
        0,
      );
    });

    test('rewards owned and urgent ingredients', () {
      const ingredients = <RecipeIngredientInput>[
        RecipeIngredientInput(name: 'bayam'),
        RecipeIngredientInput(name: 'tomat'),
        RecipeIngredientInput(name: 'bawang merah'),
        RecipeIngredientInput(name: 'garam', isStaple: true),
      ];

      final score = recipeScore(
        ingredients: ingredients,
        stock: <PantryStockInput>[
          stock('bayam', expiry: DateTime(2026, 11, 10)),
          stock('tomat', expiry: DateTime(2026, 11, 11)),
          stock('bawang merah', expiry: DateTime(2026, 11, 12)),
        ],
        now: now,
      );

      // 60 (all owned) + 30 (three urgent) + 10 (complete) = 100.
      expect(score, 100);
    });

    test('only counts the ingredients that are actually owned', () {
      final score = recipeScore(
        ingredients: const <RecipeIngredientInput>[
          RecipeIngredientInput(name: 'bayam'),
          RecipeIngredientInput(name: 'tomat'),
        ],
        stock: <PantryStockInput>[stock('bayam')],
        now: now,
      );

      // 30 (one of two owned) + 0 (not urgent) + 0 (incomplete) = 30.
      expect(score, 30);
    });

    test('ignores optional ingredients', () {
      final score = recipeScore(
        ingredients: const <RecipeIngredientInput>[
          RecipeIngredientInput(name: 'bayam'),
          RecipeIngredientInput(name: 'keju', isOptional: true),
        ],
        stock: <PantryStockInput>[stock('bayam')],
        now: now,
      );

      // 60 (all required owned) + 0 urgent + 10 complete = 70.
      expect(score, 70);
    });

    test('caps the urgency bonus at 30', () {
      final ingredients = List<RecipeIngredientInput>.generate(
        5,
        (index) => RecipeIngredientInput(name: 'bahan $index'),
      );
      final stockItems = List<PantryStockInput>.generate(
        5,
        (index) => stock('bahan $index', expiry: DateTime(2026, 11, 10)),
      );

      final score = recipeScore(
        ingredients: ingredients,
        stock: stockItems,
        now: now,
      );

      expect(score, 100);
    });
  });
}
