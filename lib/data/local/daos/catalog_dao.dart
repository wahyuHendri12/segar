import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/ingredient_catalogs.dart';

part 'catalog_dao.g.dart';

@DriftAccessor(tables: [IngredientCatalogs])
class CatalogDao extends DatabaseAccessor<AppDatabase> with _$CatalogDaoMixin {
  CatalogDao(super.db);

  Stream<List<IngredientCatalog>> watchAll() {
    return (select(ingredientCatalogs)
          ..orderBy(<OrderClauseGenerator<$IngredientCatalogsTable>>[
            (t) => OrderingTerm.asc(t.nameId),
          ]))
        .watch();
  }

  Future<List<IngredientCatalog>> getAll() {
    return (select(ingredientCatalogs)
          ..orderBy(<OrderClauseGenerator<$IngredientCatalogsTable>>[
            (t) => OrderingTerm.asc(t.nameId),
          ]))
        .get();
  }

  Future<IngredientCatalog?> getById(String id) {
    return (select(
      ingredientCatalogs,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<IngredientCatalog>> getByIds(Iterable<String> ids) {
    final values = ids.toSet().toList(growable: false);
    if (values.isEmpty) return Future.value(const <IngredientCatalog>[]);
    return (select(ingredientCatalogs)..where((t) => t.id.isIn(values))).get();
  }

  /// Search by Indonesian name, English name or alias.
  ///
  /// The catalog only has 60 rows, so filtering in Dart keeps alias search
  /// simple and avoids JSON querying in SQLite.
  Future<List<IngredientCatalog>> search(String query, {int limit = 20}) async {
    final all = await getAll();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return all.take(limit).toList(growable: false);
    }

    final matches = all.where((item) {
      if (item.nameId.toLowerCase().contains(normalized)) return true;
      if (item.nameEn.toLowerCase().contains(normalized)) return true;
      return item.aliases.any(
        (alias) => alias.toLowerCase().contains(normalized),
      );
    });

    return matches.take(limit).toList(growable: false);
  }

  Future<int> count() async {
    final countExpression = ingredientCatalogs.id.count();
    final query = selectOnly(ingredientCatalogs)
      ..addColumns(<Expression<Object>>[countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  /// Inserts or updates seed rows without touching pantry or usage data.
  Future<void> upsertAll(List<IngredientCatalogsCompanion> items) async {
    if (items.isEmpty) return;
    await batch((batch) {
      batch.insertAll(
        ingredientCatalogs,
        items,
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
