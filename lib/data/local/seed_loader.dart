import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import 'database.dart';
import 'enums.dart';

/// One ingredient parsed from the versioned seed asset.
class IngredientCatalogSeed {
  const IngredientCatalogSeed({
    required this.id,
    required this.nameId,
    required this.nameEn,
    required this.category,
    required this.emoji,
    required this.defaultUnit,
    required this.shelfLifeNote,
    this.aliases = const <String>[],
    this.photoAsset,
    this.shelfLifeKulkas,
    this.shelfLifeFreezer,
    this.shelfLifeLemari,
    this.shelfLifeSuhuRuang,
    this.tips = const <String>[],
    this.quickTags = const <String>[],
    this.avgWeightPerUnitGrams,
    this.typicalPriceIdr,
    this.quickIdeaRecipeIds = const <String>[],
  });

  final String id;
  final String nameId;
  final String nameEn;
  final IngredientCategory category;
  final String emoji;
  final String? photoAsset;
  final Unit defaultUnit;
  final int? shelfLifeKulkas;
  final int? shelfLifeFreezer;
  final int? shelfLifeLemari;
  final int? shelfLifeSuhuRuang;
  final String shelfLifeNote;
  final List<String> aliases;
  final List<String> tips;
  final List<String> quickTags;
  final double? avgWeightPerUnitGrams;
  final int? typicalPriceIdr;
  final List<String> quickIdeaRecipeIds;

  factory IngredientCatalogSeed.fromJson(Map<String, dynamic> json) {
    final shelfLife = json['shelfLifeDays'];
    final shelfMap = shelfLife is Map<String, dynamic>
        ? shelfLife
        : const <String, dynamic>{};

    int? days(String key) {
      final value = shelfMap[key];
      return value is num ? value.toInt() : null;
    }

    final nameId = _requiredString(json, 'nameId');
    final shelfLifeNote = (json['shelfLifeNote'] as String?)?.trim();

    return IngredientCatalogSeed(
      id: _requiredString(json, 'id'),
      nameId: nameId,
      nameEn: _requiredString(json, 'nameEn'),
      category: _enumByName(
        IngredientCategory.values,
        _requiredString(json, 'category'),
      ),
      emoji: (json['emoji'] as String?) ?? '🥗',
      photoAsset: json['photoAsset'] as String?,
      defaultUnit: _enumByName(
        Unit.values,
        _requiredString(json, 'defaultUnit'),
      ),
      shelfLifeKulkas: days('kulkas'),
      shelfLifeFreezer: days('freezer'),
      shelfLifeLemari: days('lemari'),
      shelfLifeSuhuRuang: days('suhuRuang'),
      shelfLifeNote: (shelfLifeNote == null || shelfLifeNote.isEmpty)
          ? _fallbackNote(
              nameId: nameId,
              kulkas: days('kulkas'),
              freezer: days('freezer'),
              lemari: days('lemari'),
              suhuRuang: days('suhuRuang'),
            )
          : shelfLifeNote,
      aliases: _stringList(json['aliases']),
      tips: _stringList(json['tips']),
      quickTags: _stringList(json['quickTags']),
      avgWeightPerUnitGrams: (json['avgWeightPerUnitGrams'] as num?)
          ?.toDouble(),
      typicalPriceIdr: (json['typicalPriceIdr'] as num?)?.toInt(),
      quickIdeaRecipeIds: _stringList(json['quickIdeaRecipeIds']),
    );
  }

  IngredientCatalogsCompanion toCompanion() {
    return IngredientCatalogsCompanion.insert(
      id: id,
      nameId: nameId,
      aliases: Value(aliases),
      nameEn: nameEn,
      category: category,
      emoji: emoji,
      photoAsset: Value(photoAsset),
      defaultUnit: defaultUnit,
      shelfLifeKulkas: Value(shelfLifeKulkas),
      shelfLifeFreezer: Value(shelfLifeFreezer),
      shelfLifeLemari: Value(shelfLifeLemari),
      shelfLifeSuhuRuang: Value(shelfLifeSuhuRuang),
      shelfLifeNote: shelfLifeNote,
      tips: Value(tips),
      quickTags: Value(quickTags),
      avgWeightPerUnitGrams: Value(avgWeightPerUnitGrams),
      typicalPriceIdr: Value(typicalPriceIdr),
      quickIdeaRecipeIds: Value(quickIdeaRecipeIds),
    );
  }

  int? shelfLifeFor(StorageLocation location) {
    return switch (location) {
      StorageLocation.kulkas => shelfLifeKulkas,
      StorageLocation.freezer => shelfLifeFreezer,
      StorageLocation.lemari => shelfLifeLemari,
      StorageLocation.suhuRuang => shelfLifeSuhuRuang,
    };
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Seed field "$key" wajib berupa teks.');
    }
    return value.trim();
  }

  static T _enumByName<T extends Enum>(List<T> values, String name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    throw FormatException('Nilai enum "$name" tidak dikenal.');
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) return const <String>[];
    return value
        .whereType<String>()
        .map((e) => e.trim())
        .toList(growable: false);
  }

  static String _fallbackNote({
    required String nameId,
    int? kulkas,
    int? freezer,
    int? lemari,
    int? suhuRuang,
  }) {
    final parts = <String>[
      if (kulkas != null) '$kulkas hari di kulkas',
      if (freezer != null) '$freezer hari di freezer',
      if (lemari != null) '$lemari hari di lemari',
      if (suhuRuang != null) '$suhuRuang hari di suhu ruang',
    ];
    if (parts.isEmpty) {
      return '$nameId sebaiknya segera diolah setelah dibeli.';
    }
    return '$nameId bertahan ${parts.join(', ')}.';
  }
}

/// Parses the JSON payload stored in `assets/seed/ingredient_catalogs_v1.json`.
List<IngredientCatalogSeed> parseIngredientCatalogSeed(String jsonString) {
  final decoded = jsonDecode(jsonString);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Seed katalog harus berupa objek JSON.');
  }

  final items = decoded['items'];
  if (items is! List) {
    throw const FormatException('Seed katalog tidak memiliki daftar "items".');
  }

  return items
      .whereType<Map<String, dynamic>>()
      .map(IngredientCatalogSeed.fromJson)
      .toList(growable: false);
}

/// One ingredient line parsed from the recipe seed asset.
class RecipeIngredientSeed {
  const RecipeIngredientSeed({
    required this.name,
    required this.amount,
    required this.unit,
    this.catalogId,
    this.isOptional = false,
    this.isStaple = false,
  });

  final String? catalogId;
  final String name;
  final double amount;
  final Unit unit;
  final bool isOptional;
  final bool isStaple;

  factory RecipeIngredientSeed.fromJson(Map<String, dynamic> json) {
    final amount = json['amount'];
    if (amount is! num || amount <= 0) {
      throw const FormatException('Jumlah bahan resep harus lebih dari 0.');
    }

    return RecipeIngredientSeed(
      catalogId: (json['catalogId'] as String?)?.trim(),
      name: IngredientCatalogSeed._requiredString(json, 'name'),
      amount: amount.toDouble(),
      unit: IngredientCatalogSeed._enumByName(
        Unit.values,
        IngredientCatalogSeed._requiredString(json, 'unit'),
      ),
      isOptional: json['isOptional'] == true,
      isStaple: json['isStaple'] == true,
    );
  }

  RecipeIngredientsCompanion toCompanion({
    required String id,
    required String recipeId,
    required int sortOrder,
  }) {
    return RecipeIngredientsCompanion.insert(
      id: id,
      recipeId: recipeId,
      catalogId: Value(catalogId),
      name: name,
      amount: amount,
      unit: unit,
      isOptional: Value(isOptional),
      isStaple: Value(isStaple),
      sortOrder: Value(sortOrder),
    );
  }
}

/// One recipe parsed from the versioned recipe seed asset.
class RecipeSeed {
  const RecipeSeed({
    required this.id,
    required this.title,
    required this.emoji,
    required this.cookTimeMin,
    required this.difficulty,
    required this.servings,
    required this.estimatedCostIdr,
    required this.tags,
    required this.steps,
    required this.ingredients,
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
  final List<String> tags;
  final List<String> steps;
  final List<RecipeIngredientSeed> ingredients;

  bool get isQuick => cookTimeMin < 15;

  factory RecipeSeed.fromJson(Map<String, dynamic> json) {
    final cookTimeMin = _requiredInt(json, 'cookTimeMin');
    final servings = _requiredInt(json, 'servings');
    if (cookTimeMin <= 0) {
      throw const FormatException('Waktu masak resep harus lebih dari 0.');
    }
    if (servings <= 0) {
      throw const FormatException('Jumlah porsi resep harus lebih dari 0.');
    }

    final ingredientsJson = json['ingredients'];
    if (ingredientsJson is! List || ingredientsJson.isEmpty) {
      throw const FormatException('Resep harus memiliki minimal satu bahan.');
    }

    final id = IngredientCatalogSeed._requiredString(json, 'id');
    return RecipeSeed(
      id: id,
      title: IngredientCatalogSeed._requiredString(json, 'title'),
      emoji: (json['emoji'] as String?)?.trim().isNotEmpty == true
          ? (json['emoji'] as String).trim()
          : '🍲',
      imageAsset: _optionalString(json['imageAsset']),
      cookTimeMin: cookTimeMin,
      difficulty: IngredientCatalogSeed._enumByName(
        RecipeDifficulty.values,
        IngredientCatalogSeed._requiredString(json, 'difficulty'),
      ),
      servings: servings,
      estimatedCostIdr: (json['estimatedCostIdr'] as num?)?.toInt() ?? 0,
      tags: IngredientCatalogSeed._stringList(json['tags']),
      steps: IngredientCatalogSeed._stringList(json['steps']),
      ingredients: ingredientsJson
          .whereType<Map<String, dynamic>>()
          .map(RecipeIngredientSeed.fromJson)
          .toList(growable: false),
    );
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! num) {
      throw FormatException('Seed field "$key" wajib berupa angka.');
    }
    return value.toInt();
  }

  static String? _optionalString(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  RecipesCompanion toRecipeCompanion() {
    return RecipesCompanion.insert(
      id: id,
      title: title,
      emoji: Value(emoji),
      imageAsset: Value(imageAsset),
      cookTimeMin: cookTimeMin,
      difficulty: difficulty,
      servings: Value(servings),
      estimatedCostIdr: Value(estimatedCostIdr),
      isQuick: Value(isQuick),
      tags: Value(tags),
      steps: Value(steps),
    );
  }

  List<RecipeIngredientsCompanion> toIngredientCompanions() {
    return <RecipeIngredientsCompanion>[
      for (var index = 0; index < ingredients.length; index++)
        ingredients[index].toCompanion(
          id: '$id-i$index',
          recipeId: id,
          sortOrder: index,
        ),
    ];
  }
}

/// Parses the JSON payload stored in `assets/seed/recipes_v1.json`.
List<RecipeSeed> parseRecipeSeed(String jsonString) {
  final decoded = jsonDecode(jsonString);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Seed resep harus berupa objek JSON.');
  }

  final items = decoded['recipes'];
  if (items is! List) {
    throw const FormatException('Seed resep tidak memiliki daftar "recipes".');
  }

  final recipes = items
      .whereType<Map<String, dynamic>>()
      .map(RecipeSeed.fromJson)
      .toList(growable: false);

  final ids = <String>{};
  for (final recipe in recipes) {
    if (!ids.add(recipe.id)) {
      throw FormatException('ID resep ganda: ${recipe.id}');
    }
  }
  return recipes;
}

/// Loads the catalog and recipe seeds once per seed version.
///
/// Catalog and recipe rows are upserted; pantry, usage logs and user settings
/// are never touched, so an app update cannot overwrite user data.
class SeedLoader {
  SeedLoader({
    required this.db,
    required this.prefs,
    Future<String> Function()? loadJson,
    Future<String> Function()? loadRecipeJson,
  }) : _loadJson = loadJson ?? (() => rootBundle.loadString(seedAssetPath)),
       _loadRecipeJson =
           loadRecipeJson ?? (() => rootBundle.loadString(recipeSeedAssetPath));

  static const currentSeedVersion = 2;
  static const seedAssetPath = 'assets/seed/ingredient_catalogs_v1.json';
  static const recipeSeedAssetPath = 'assets/seed/recipes_v1.json';

  final AppDatabase db;
  final SharedPreferences prefs;
  final Future<String> Function() _loadJson;
  final Future<String> Function() _loadRecipeJson;

  Future<void> ensureSeeded() async {
    final storedVersion = prefs.getInt(PrefKeys.seedVersion) ?? 0;
    if (storedVersion >= currentSeedVersion) return;

    final jsonString = await _loadJson();
    final items = parseIngredientCatalogSeed(jsonString);
    await db.catalogDao.upsertAll(
      items.map((item) => item.toCompanion()).toList(growable: false),
    );

    final recipeJson = await _loadRecipeJson();
    final recipes = parseRecipeSeed(recipeJson);
    await db.recipeDao.upsertRecipes(
      recipeRows: recipes
          .map((recipe) => recipe.toRecipeCompanion())
          .toList(growable: false),
      ingredientRows: <RecipeIngredientsCompanion>[
        for (final recipe in recipes) ...recipe.toIngredientCompanions(),
      ],
    );

    await prefs.setInt(PrefKeys.seedVersion, currentSeedVersion);
  }
}
