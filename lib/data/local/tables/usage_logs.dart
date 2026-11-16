import 'package:drift/drift.dart';

import '../enums.dart';

/// Immutable history of what happened to pantry items.
///
/// Category, value and weight are copied from the item so statistics stay
/// correct after an item is edited or soft-deleted.
@DataClassName('UsageLog')
@TableIndex(name: 'usage_item_idx', columns: {#pantryItemId})
@TableIndex(name: 'usage_logged_idx', columns: {#loggedAt})
class UsageLogs extends Table {
  TextColumn get id => text()();

  TextColumn get pantryItemId => text()();

  TextColumn get action => textEnum<UsageAction>()();

  RealColumn get quantityChanged => real()();

  IntColumn get valueIdr => integer().withDefault(const Constant(0))();

  BoolColumn get isEstimate => boolean().withDefault(const Constant(false))();

  IntColumn get weightGrams => integer().withDefault(const Constant(0))();

  TextColumn get category => textEnum<IngredientCategory>()();

  TextColumn get reasonWasted => textEnum<WasteReason>().nullable()();

  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
