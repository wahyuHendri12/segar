import '../local/daos/catalog_dao.dart';
import '../models/ingredient_catalog_view.dart';

/// Catalog reads used by the add-item form.
class CatalogRepository {
  const CatalogRepository({required this.catalogDao});

  final CatalogDao catalogDao;

  Stream<List<IngredientCatalogView>> watchAll() {
    return catalogDao.watchAll().map(
      (rows) => rows.map(IngredientCatalogView.fromRow).toList(growable: false),
    );
  }

  Future<List<IngredientCatalogView>> search(
    String query, {
    int limit = 30,
  }) async {
    final rows = await catalogDao.search(query, limit: limit);
    return rows.map(IngredientCatalogView.fromRow).toList(growable: false);
  }
}
