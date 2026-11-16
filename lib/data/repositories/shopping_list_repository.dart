import '../local/daos/shopping_list_dao.dart';
import '../local/enums.dart';
import '../models/shopping_list_entry.dart';

/// Gateway for the lightweight shopping list.
class ShoppingListRepository {
  ShoppingListRepository({required this.dao, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final ShoppingListDao dao;
  final DateTime Function() _clock;

  Stream<List<ShoppingListEntry>> watchAll() {
    return dao.watchAll().map(
      (rows) => rows.map(ShoppingListEntry.fromRow).toList(growable: false),
    );
  }

  Future<List<ShoppingListEntry>> getAll() async {
    final rows = await dao.getAll();
    return rows.map(ShoppingListEntry.fromRow).toList(growable: false);
  }

  Future<String> addItem({
    required String name,
    double quantity = 1,
    Unit unit = Unit.pcs,
    ShoppingSource source = ShoppingSource.manual,
  }) {
    return dao.addItem(
      name: name,
      quantity: quantity,
      unit: unit,
      source: source,
      at: _clock(),
    );
  }

  /// Adds drafts, skipping names that are already on the list.
  ///
  /// Returns the number of rows that were actually inserted.
  Future<int> addDrafts(List<ShoppingListDraft> drafts) async {
    if (drafts.isEmpty) return 0;

    final existing = (await dao.getAll())
        .map((row) => row.name.trim().toLowerCase())
        .toSet();

    var added = 0;
    for (final draft in drafts) {
      final name = draft.name.trim();
      final key = name.toLowerCase();
      if (name.isEmpty || !existing.add(key)) continue;
      await dao.addItem(
        name: name,
        quantity: draft.quantity,
        unit: draft.unit,
        source: draft.source,
        at: _clock(),
      );
      added++;
    }
    return added;
  }

  Future<void> setChecked(String id, bool checked) {
    return dao.setChecked(id, checked);
  }

  Future<void> updateItem(
    String id, {
    required String name,
    required double quantity,
    required Unit unit,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final existing = await dao.getAll();
    var found = false;
    for (final item in existing) {
      if (item.id == id) {
        found = true;
        break;
      }
    }
    if (!found) return;

    await dao.updateItem(id, name: trimmed, quantity: quantity, unit: unit);
  }

  Future<void> deleteItem(String id) => dao.deleteItem(id);

  Future<void> clearChecked() => dao.clearChecked();

  Future<void> clearAll() => dao.clearAll();
}
