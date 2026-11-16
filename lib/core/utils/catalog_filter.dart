import '../../data/models/ingredient_catalog_view.dart';

/// Filters the small local catalog by Indonesian name, English name or alias.
List<IngredientCatalogView> filterCatalogItems(
  List<IngredientCatalogView> items,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return items;

  return items
      .where((item) {
        if (item.nameId.toLowerCase().contains(normalized)) return true;
        if (item.nameEn.toLowerCase().contains(normalized)) return true;
        return item.aliases.any(
          (alias) => alias.toLowerCase().contains(normalized),
        );
      })
      .toList(growable: false);
}
