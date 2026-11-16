import 'package:drift/drift.dart';

import '../enums.dart';

/// One item currently tracked in the user's pantry.
@DataClassName('PantryItem')
@TableIndex(name: 'pantry_expiry_idx', columns: {#expiryDate})
@TableIndex(name: 'pantry_status_idx', columns: {#status})
@TableIndex(name: 'pantry_location_idx', columns: {#storageLocation})
class PantryItems extends Table {
  TextColumn get id => text()();

  /// Null for custom ingredients that are not in the catalog.
  TextColumn get catalogId => text().nullable()();

  TextColumn get name => text().withLength(min: 1, max: 80)();

  TextColumn get emoji => text().withDefault(const Constant(''))();

  TextColumn get photoAsset => text().nullable()();

  TextColumn get category => textEnum<IngredientCategory>()();

  RealColumn get quantity => real()();

  TextColumn get unit => textEnum<Unit>()();

  /// Total weight in grams. Derived from catalog weight per unit when null.
  IntColumn get weightGrams => integer().nullable()();

  TextColumn get storageLocation => textEnum<StorageLocation>()();

  DateTimeColumn get purchaseDate => dateTime()();

  DateTimeColumn get expiryDate => dateTime()();

  TextColumn get expirySource => textEnum<ExpirySource>()();

  IntColumn get priceIdr => integer().nullable()();

  TextColumn get barcode => text().nullable()();

  TextColumn get note => text().nullable()();

  BoolColumn get notifyEnabled => boolean().withDefault(const Constant(true))();

  TextColumn get status =>
      textEnum<PantryStatus>().withDefault(const Constant('aktif'))();

  DateTimeColumn get statusChangedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete. Rows with a value here are excluded from lists and stats.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
