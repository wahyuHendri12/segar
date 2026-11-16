import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database.dart';
import '../enums.dart';
import '../tables/shopping_list_items.dart';

part 'shopping_list_dao.g.dart';

@DriftAccessor(tables: [ShoppingListItems])
class ShoppingListDao extends DatabaseAccessor<AppDatabase>
    with _$ShoppingListDaoMixin {
  ShoppingListDao(super.db);

  static const _uuid = Uuid();

  Stream<List<ShoppingListItem>> watchAll() {
    return (select(shoppingListItems)
          ..orderBy(<OrderClauseGenerator<$ShoppingListItemsTable>>[
            (t) => OrderingTerm.asc(t.isChecked),
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  Future<List<ShoppingListItem>> getAll() {
    return (select(shoppingListItems)
          ..orderBy(<OrderClauseGenerator<$ShoppingListItemsTable>>[
            (t) => OrderingTerm.asc(t.isChecked),
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
  }

  Future<String> addItem({
    required String name,
    double quantity = 1,
    Unit unit = Unit.pcs,
    ShoppingSource source = ShoppingSource.manual,
    DateTime? at,
  }) {
    final id = _uuid.v4();
    return into(shoppingListItems)
        .insert(
          ShoppingListItemsCompanion.insert(
            id: id,
            name: name.trim(),
            quantity: Value(quantity),
            unit: unit,
            source: source,
            createdAt: at ?? DateTime.now(),
          ),
        )
        .then((_) => id);
  }

  Future<void> addItems(List<ShoppingListItemsCompanion> items) {
    if (items.isEmpty) return Future<void>.value();
    return batch((batch) {
      batch.insertAll(shoppingListItems, items);
    });
  }

  Future<void> setChecked(String id, bool checked) {
    return (update(shoppingListItems)..where((t) => t.id.equals(id))).write(
      ShoppingListItemsCompanion(isChecked: Value(checked)),
    );
  }

  Future<void> updateQuantity(String id, double quantity, Unit unit) {
    return (update(shoppingListItems)..where((t) => t.id.equals(id))).write(
      ShoppingListItemsCompanion(quantity: Value(quantity), unit: Value(unit)),
    );
  }

  Future<void> updateItem(
    String id, {
    required String name,
    required double quantity,
    required Unit unit,
  }) {
    return (update(shoppingListItems)..where((t) => t.id.equals(id))).write(
      ShoppingListItemsCompanion(
        name: Value(name.trim()),
        quantity: Value(quantity),
        unit: Value(unit),
      ),
    );
  }

  Future<int> deleteItem(String id) {
    return (delete(shoppingListItems)..where((t) => t.id.equals(id))).go();
  }

  Future<int> clearChecked() {
    return (delete(
      shoppingListItems,
    )..where((t) => t.isChecked.equals(true))).go();
  }

  Future<int> clearAll() {
    return delete(shoppingListItems).go();
  }
}
