import 'package:dio/dio.dart';

import '../models/online_recipe.dart';

/// Network boundary for TheMealDB searches and detail lookups.
abstract class RecipeRemoteSource {
  Future<List<OnlineRecipe>> search(String query);

  /// Returns `null` when the recipe id no longer exists.
  Future<OnlineRecipe?> lookup(String id);
}

/// Thin TheMealDB client using the public test API key.
class TheMealDbSource implements RecipeRemoteSource {
  TheMealDbSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ),
          );

  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  final Dio _dio;

  @override
  Future<List<OnlineRecipe>> search(String query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_base/search.php',
      queryParameters: <String, String>{'s': query},
    );
    final data = response.data;
    if (data == null) return const <OnlineRecipe>[];
    return parseMealDbSearch(data);
  }

  @override
  Future<OnlineRecipe?> lookup(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_base/lookup.php',
      queryParameters: <String, String>{'i': id},
    );
    final data = response.data;
    if (data == null) return null;
    return parseMealDbLookup(data);
  }
}

/// Pure parser for `/search.php`.
List<OnlineRecipe> parseMealDbSearch(Map<String, dynamic> json) {
  final meals = json['meals'];
  if (meals is! List) return const <OnlineRecipe>[];

  return meals
      .whereType<Map>()
      .map((meal) => parseMealDbRecipe(Map<String, dynamic>.from(meal)))
      .whereType<OnlineRecipe>()
      .toList(growable: false);
}

/// Pure parser for `/lookup.php`.
OnlineRecipe? parseMealDbLookup(Map<String, dynamic> json) {
  final meals = json['meals'];
  if (meals is! List || meals.isEmpty) return null;
  final first = meals.first;
  if (first is! Map) return null;
  return parseMealDbRecipe(Map<String, dynamic>.from(first));
}

/// Pure parser for a single TheMealDB meal object.
OnlineRecipe? parseMealDbRecipe(Map<String, dynamic> json) {
  final id = _text(json['idMeal']);
  final title = _text(json['strMeal']);
  if (id == null || title == null) return null;

  final ingredients = <OnlineRecipeIngredient>[];
  for (var index = 1; index <= 20; index++) {
    final name = _text(json['strIngredient$index']);
    if (name == null) continue;
    ingredients.add(
      OnlineRecipeIngredient(
        name: name,
        measure: _text(json['strMeasure$index']),
      ),
    );
  }

  return OnlineRecipe(
    id: id,
    title: title,
    imageUrl: _text(json['strMealThumb']),
    area: _text(json['strArea']),
    category: _text(json['strCategory']),
    instructions: _text(json['strInstructions']),
    youtubeUrl: _text(json['strYoutube']),
    sourceUrl: _text(json['strSource']),
    ingredients: ingredients,
  );
}

String? _text(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
