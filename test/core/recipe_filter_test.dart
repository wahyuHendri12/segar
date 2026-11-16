import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/recipe_filter.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/recipe_view.dart';

void main() {
  RecipeIngredientView ingredient(String name) {
    return RecipeIngredientView(
      id: name,
      name: name,
      amount: 1,
      unit: Unit.pcs,
      isOptional: false,
      isStaple: false,
    );
  }

  RecipeView recipe({
    required String id,
    required String title,
    double score = 50,
    int cookTimeMin = 10,
    bool isQuick = false,
    List<String> tags = const <String>[],
    List<String> ingredients = const <String>[],
  }) {
    return RecipeView(
      id: id,
      title: title,
      emoji: '🍲',
      cookTimeMin: cookTimeMin,
      difficulty: RecipeDifficulty.mudah,
      servings: 2,
      estimatedCostIdr: 10000,
      isQuick: isQuick,
      tags: tags,
      steps: const <String>['Masak'],
      ingredients: ingredients.map(ingredient).toList(growable: false),
      matchScore: score,
      ownedRequiredCount: 1,
      requiredCount: 1,
    );
  }

  group('filterRecipes', () {
    test('returns every recipe sorted by score when no filter is active', () {
      final recipes = <RecipeView>[
        recipe(id: 'a', title: 'Sup Ayam', score: 30),
        recipe(id: 'b', title: 'Tumis Kangkung', score: 80),
        recipe(id: 'c', title: 'Smoothie', score: 50),
      ];

      final result = filterRecipes(recipes, const RecipeFilterState());

      expect(result.map((item) => item.id), <String>['b', 'c', 'a']);
    });

    test('matches the quick chip using isQuick or the cepat tag', () {
      final recipes = <RecipeView>[
        recipe(id: 'a', title: 'A', isQuick: true),
        recipe(id: 'b', title: 'B', tags: <String>['cepat']),
        recipe(id: 'c', title: 'C', cookTimeMin: 40),
      ];

      final result = filterRecipes(
        recipes,
        const RecipeFilterState(tag: 'cepat'),
      );

      expect(result.map((item) => item.id).toSet(), <String>{'a', 'b'});
    });

    test('matches category tags', () {
      final recipes = <RecipeView>[
        recipe(id: 'a', title: 'Sup', tags: <String>['kuah']),
        recipe(id: 'b', title: 'Tumis', tags: <String>['tumis']),
      ];

      final result = filterRecipes(
        recipes,
        const RecipeFilterState(tag: 'tumis'),
      );

      expect(result.map((item) => item.id), <String>['b']);
    });

    test('searches titles case-insensitively', () {
      final recipes = <RecipeView>[
        recipe(id: 'a', title: 'Sup Telur Tomat'),
        recipe(id: 'b', title: 'Tumis Kangkung'),
      ];

      final result = filterRecipes(
        recipes,
        const RecipeFilterState(query: '  TOMAT '),
      );

      expect(result.map((item) => item.id), <String>['a']);
    });

    test('searches ingredient names', () {
      final recipes = <RecipeView>[
        recipe(id: 'a', title: 'Sup', ingredients: <String>['Tomat']),
        recipe(id: 'b', title: 'Tumis', ingredients: <String>['Kangkung']),
      ];

      final result = filterRecipes(
        recipes,
        const RecipeFilterState(query: 'tomat'),
      );

      expect(result.map((item) => item.id), <String>['a']);
    });

    test('combines the active tag and query', () {
      final recipes = <RecipeView>[
        recipe(id: 'a', title: 'Sup Tomat', tags: <String>['kuah']),
        recipe(id: 'b', title: 'Tumis Tomat', tags: <String>['tumis']),
      ];

      final result = filterRecipes(
        recipes,
        const RecipeFilterState(tag: 'kuah', query: 'tomat'),
      );

      expect(result.map((item) => item.id), <String>['a']);
    });

    test('orders equal scores by cook time then title', () {
      final recipes = <RecipeView>[
        recipe(id: 'a', title: 'B Resep', score: 50, cookTimeMin: 20),
        recipe(id: 'b', title: 'A Resep', score: 50, cookTimeMin: 20),
        recipe(id: 'c', title: 'Cepat', score: 50, cookTimeMin: 10),
      ];

      final result = filterRecipes(recipes, const RecipeFilterState());

      expect(result.map((item) => item.id), <String>['c', 'b', 'a']);
    });
  });

  group('recipeTagCount', () {
    final recipes = <RecipeView>[
      recipe(id: 'a', title: 'A', isQuick: true, tags: <String>['kos']),
      recipe(id: 'b', title: 'B', tags: <String>['cepat', 'kuah']),
      recipe(id: 'c', title: 'C', tags: <String>['tumis']),
    ];

    test('counts every recipe for the all chip', () {
      expect(recipeTagCount(recipes, null), 3);
    });

    test('counts quick recipes through isQuick and the tag', () {
      expect(recipeTagCount(recipes, 'cepat'), 2);
    });

    test('counts matching tags', () {
      expect(recipeTagCount(recipes, 'kuah'), 1);
      expect(recipeTagCount(recipes, 'tidakAda'), 0);
    });
  });
}
