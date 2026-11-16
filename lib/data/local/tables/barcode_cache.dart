import 'package:drift/drift.dart';

import '../enums.dart';

/// Successful Open Food Facts lookups (and locally learned barcodes).
@DataClassName('BarcodeCacheEntry')
class BarcodeCache extends Table {
  TextColumn get barcode => text()();

  TextColumn get name => text()();

  TextColumn get brand => text().nullable()();

  TextColumn get category => textEnum<IngredientCategory>()();

  TextColumn get quantityText => text().nullable()();

  TextColumn get source => textEnum<BarcodeSource>()();

  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{barcode};
}
