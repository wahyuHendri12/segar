/// One ingredient line returned by TheMealDB.
class OnlineRecipeIngredient {
  const OnlineRecipeIngredient({required this.name, this.measure});

  final String name;

  /// Free-form measure such as `200g` or `1 cup`.
  final String? measure;

  String get label {
    final trimmed = measure?.trim();
    if (trimmed == null || trimmed.isEmpty) return name;
    return '$trimmed $name';
  }
}

/// A TheMealDB recipe, kept independent from the local recipe tables.
class OnlineRecipe {
  const OnlineRecipe({
    required this.id,
    required this.title,
    required this.ingredients,
    this.imageUrl,
    this.area,
    this.category,
    this.instructions,
    this.youtubeUrl,
    this.sourceUrl,
  });

  final String id;
  final String title;
  final String? imageUrl;
  final String? area;
  final String? category;
  final String? instructions;
  final String? youtubeUrl;
  final String? sourceUrl;
  final List<OnlineRecipeIngredient> ingredients;

  /// Converts back to the TheMealDB response shape so the raw payload can be
  /// cached without keeping a second parser around.
  Map<String, dynamic> toMealDbJson() {
    final json = <String, dynamic>{
      'idMeal': id,
      'strMeal': title,
      'strMealThumb': imageUrl,
      'strArea': area,
      'strCategory': category,
      'strInstructions': instructions,
      'strYoutube': youtubeUrl,
      'strSource': sourceUrl,
    };
    for (var index = 0; index < ingredients.length; index++) {
      final ingredient = ingredients[index];
      json['strIngredient${index + 1}'] = ingredient.name;
      json['strMeasure${index + 1}'] = ingredient.measure;
    }
    return json;
  }
}
