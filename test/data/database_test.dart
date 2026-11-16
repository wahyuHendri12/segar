import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = openTestDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  test('schema version starts at 1', () {
    expect(db.schemaVersion, 1);
  });

  test('onCreate creates every table', () async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    final names = rows.map((row) => row.read<String>('name')).toSet();

    expect(
      names,
      containsAll(<String>[
        'pantry_items',
        'usage_logs',
        'ingredient_catalogs',
        'recipes',
        'recipe_ingredients',
        'barcode_cache',
        'shopping_list_items',
        'cached_online_recipes',
      ]),
    );
  });

  test('onCreate creates the indexes used by the DAOs', () async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
        .get();
    final names = rows.map((row) => row.read<String>('name')).toSet();

    expect(
      names,
      containsAll(<String>[
        'pantry_expiry_idx',
        'pantry_status_idx',
        'pantry_location_idx',
        'usage_item_idx',
        'usage_logged_idx',
        'catalog_name_idx',
        'recipe_quick_idx',
        'recipe_ingredient_recipe_idx',
        'shopping_checked_idx',
      ]),
    );
  });

  test('beforeOpen enables foreign keys', () async {
    final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(row.read<int>('foreign_keys'), 1);
  });
}
