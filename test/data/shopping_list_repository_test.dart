import 'package:flutter_test/flutter_test.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/shopping_list_entry.dart';
import 'package:segar/data/repositories/shopping_list_repository.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ShoppingListRepository repository;
  final now = DateTime(2026, 11, 10, 8);

  setUp(() {
    db = openTestDatabase();
    repository = ShoppingListRepository(
      dao: db.shoppingListDao,
      clock: () => now,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('adds manual items and lists unchecked first', () async {
    await repository.addItem(name: ' Bayam ', quantity: 2, unit: Unit.ikat);
    final checkedId = await repository.addItem(
      name: 'Tomat',
      source: ShoppingSource.habis,
    );
    await repository.setChecked(checkedId, true);

    final items = await repository.getAll();

    expect(items.map((item) => item.name), <String>['Bayam', 'Tomat']);
    expect(items.first.quantity, 2);
    expect(items.first.unit, Unit.ikat);
    expect(items.last.isChecked, isTrue);
    expect(items.last.source, ShoppingSource.habis);
  });

  test('addDrafts skips duplicates and trims names', () async {
    await repository.addItem(name: 'Bayam');

    final added = await repository.addDrafts(<ShoppingListDraft>[
      const ShoppingListDraft(name: 'bayam'),
      const ShoppingListDraft(
        name: 'Tomat',
        quantity: 3,
        unit: Unit.butir,
        source: ShoppingSource.dariResep,
      ),
      const ShoppingListDraft(name: '   '),
    ]);

    final items = await repository.getAll();
    expect(added, 1);
    expect(items.map((item) => item.name), <String>['Bayam', 'Tomat']);
    expect(items.last.source, ShoppingSource.dariResep);
  });

  test('updates name, quantity and unit', () async {
    final id = await repository.addItem(name: 'Bayam');

    await repository.updateItem(
      id,
      name: 'Bayam merah',
      quantity: 4,
      unit: Unit.kg,
    );

    final item = (await repository.getAll()).single;
    expect(item.name, 'Bayam merah');
    expect(item.quantity, 4);
    expect(item.unit, Unit.kg);
  });

  test('clears checked rows only', () async {
    final first = await repository.addItem(name: 'Bayam');
    await repository.addItem(name: 'Tomat');
    await repository.setChecked(first, true);

    await repository.clearChecked();

    final items = await repository.getAll();
    expect(items.map((item) => item.name), <String>['Tomat']);
  });
}
