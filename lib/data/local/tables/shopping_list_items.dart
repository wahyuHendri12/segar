import 'package:drift/drift.dart';

import '../enums.dart';

/// Lightweight shopping list used by the recipe screen and profile menu.
@DataClassName('ShoppingListItem')
@TableIndex(name: 'shopping_checked_idx', columns: {#isChecked})
class ShoppingListItems extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  RealColumn get quantity => real().withDefault(const Constant(1))();

  TextColumn get unit => textEnum<Unit>()();

  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();

  TextColumn get source => textEnum<ShoppingSource>()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
