import '../../core/utils/expiry_utils.dart';
import '../local/database.dart';
import '../local/enums.dart';

/// Read-only catalog model exposed to the presentation layer.
///
/// Keeping a small view object here means widgets never import Drift rows or
/// SQL-specific types.
class IngredientCatalogView {
  const IngredientCatalogView({
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
  });

  final String id;
  final String nameId;
  final String nameEn;
  final IngredientCategory category;
  final String emoji;
  final String? photoAsset;
  final Unit defaultUnit;
  final String shelfLifeNote;
  final List<String> aliases;
  final List<String> tips;
  final List<String> quickTags;
  final int? shelfLifeKulkas;
  final int? shelfLifeFreezer;
  final int? shelfLifeLemari;
  final int? shelfLifeSuhuRuang;
  final double? avgWeightPerUnitGrams;
  final int? typicalPriceIdr;

  factory IngredientCatalogView.fromRow(IngredientCatalog row) {
    return IngredientCatalogView(
      id: row.id,
      nameId: row.nameId,
      nameEn: row.nameEn,
      category: row.category,
      emoji: row.emoji,
      photoAsset: row.photoAsset,
      defaultUnit: row.defaultUnit,
      shelfLifeNote: row.shelfLifeNote,
      aliases: row.aliases,
      tips: row.tips,
      quickTags: row.quickTags,
      shelfLifeKulkas: row.shelfLifeKulkas,
      shelfLifeFreezer: row.shelfLifeFreezer,
      shelfLifeLemari: row.shelfLifeLemari,
      shelfLifeSuhuRuang: row.shelfLifeSuhuRuang,
      avgWeightPerUnitGrams: row.avgWeightPerUnitGrams,
      typicalPriceIdr: row.typicalPriceIdr,
    );
  }

  IngredientCatalogShelfLife get shelfLife => IngredientCatalogShelfLife(
    kulkas: shelfLifeKulkas,
    freezer: shelfLifeFreezer,
    lemari: shelfLifeLemari,
    suhuRuang: shelfLifeSuhuRuang,
  );

  int? shelfLifeFor(StorageLocation location) {
    return shelfLifeForLocation(shelfLife, location);
  }
}
