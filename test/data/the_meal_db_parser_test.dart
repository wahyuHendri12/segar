import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/remote/the_meal_db_service.dart';

void main() {
  group('parseMealDbSearch', () {
    test('parses meals and skips empty ingredient slots', () {
      final recipes = parseMealDbSearch(<String, dynamic>{
        'meals': <Map<String, dynamic>>[
          <String, dynamic>{
            'idMeal': '1',
            'strMeal': 'Nasi Goreng',
            'strArea': 'Indonesian',
            'strCategory': 'Chicken',
            'strInstructions': 'Masak nasi.',
            'strIngredient1': 'Rice',
            'strMeasure1': '2 cups',
            'strIngredient2': ' ',
            'strMeasure2': '1 tbsp',
            'strIngredient3': 'Garlic',
            'strMeasure3': '2 cloves',
          },
          <String, dynamic>{'idMeal': '2'},
        ],
      });

      expect(recipes, hasLength(1));
      expect(recipes.single.id, '1');
      expect(recipes.single.title, 'Nasi Goreng');
      expect(recipes.single.area, 'Indonesian');
      expect(recipes.single.category, 'Chicken');
      expect(recipes.single.ingredients, hasLength(2));
      expect(recipes.single.ingredients.first.label, '2 cups Rice');
      expect(recipes.single.ingredients.last.name, 'Garlic');
    });

    test('returns an empty list for no results', () {
      expect(parseMealDbSearch(<String, dynamic>{'meals': null}), isEmpty);
      expect(parseMealDbSearch(<String, dynamic>{}), isEmpty);
    });
  });

  group('parseMealDbLookup', () {
    test('returns the first meal', () {
      final recipe = parseMealDbLookup(<String, dynamic>{
        'meals': <Map<String, dynamic>>[
          <String, dynamic>{'idMeal': '9', 'strMeal': 'Sate Ayam'},
        ],
      });

      expect(recipe, isNotNull);
      expect(recipe!.id, '9');
      expect(recipe.title, 'Sate Ayam');
      expect(recipe.ingredients, isEmpty);
    });

    test('returns null when the recipe is gone', () {
      expect(parseMealDbLookup(<String, dynamic>{'meals': null}), isNull);
      expect(parseMealDbLookup(<String, dynamic>{'meals': <Object>[]}), isNull);
    });
  });

  test('toMealDbJson round-trips through the parser', () {
    final recipe = parseMealDbLookup(<String, dynamic>{
      'meals': <Map<String, dynamic>>[
        <String, dynamic>{
          'idMeal': '42',
          'strMeal': 'Sup Ayam',
          'strMealThumb': 'https://example.com/soup.jpg',
          'strArea': 'Indonesian',
          'strCategory': 'Soup',
          'strInstructions': 'Rebus ayam.\r\nTambahkan sayur.',
          'strIngredient1': 'Chicken',
          'strMeasure1': '500g',
          'strIngredient2': 'Carrot',
          'strMeasure2': '2',
        },
      ],
    });

    expect(recipe, isNotNull);
    final restored = parseMealDbRecipe(recipe!.toMealDbJson());

    expect(restored, isNotNull);
    expect(restored!.id, recipe.id);
    expect(restored.title, recipe.title);
    expect(restored.imageUrl, recipe.imageUrl);
    expect(restored.instructions, recipe.instructions);
    expect(restored.ingredients, hasLength(2));
    expect(restored.ingredients.last.label, '2 Carrot');
  });
}
