import 'package:drift/drift.dart';

import '../enums.dart';
import 'converters.dart';

/// Seed catalog of common Indonesian ingredients (60 entries in v1).
@DataClassName('IngredientCatalog')
@TableIndex(name: 'catalog_name_idx', columns: {#nameId})
class IngredientCatalogs extends Table {
  TextColumn get id => text()();

  TextColumn get nameId => text()();

  /// Alternate Indonesian names, e.g. "bayam hijau".
  TextColumn get aliases => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  /// English name used for TheMealDB lookups.
  TextColumn get nameEn => text()();

  TextColumn get category => textEnum<IngredientCategory>()();

  TextColumn get emoji => text()();

  TextColumn get photoAsset => text().nullable()();

  TextColumn get defaultUnit => textEnum<Unit>()();

  /// Shelf life in days. Null means "not recommended for this location".
  IntColumn get shelfLifeKulkas => integer().nullable()();

  IntColumn get shelfLifeFreezer => integer().nullable()();

  IntColumn get shelfLifeLemari => integer().nullable()();

  IntColumn get shelfLifeSuhuRuang => integer().nullable()();

  TextColumn get shelfLifeNote => text()();

  TextColumn get tips => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  TextColumn get quickTags => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  /// Average weight of one [defaultUnit] in grams.
  RealColumn get avgWeightPerUnitGrams => real().nullable()();

  IntColumn get typicalPriceIdr => integer().nullable()();

  TextColumn get quickIdeaRecipeIds => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
