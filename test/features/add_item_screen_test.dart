import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:drift/drift.dart' show Value;
import 'package:segar/app.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/data/local/enums.dart';

import '../helpers/test_database.dart';

Future<AppDatabase> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboardingDone': true,
    'userName': 'Dina',
  });
  final prefs = await SharedPreferences.getInstance();
  final database = openTestDatabase();
  addTearDown(database.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
      ],
      child: const SegarApp(),
    ),
  );
  await tester.pumpAndSettle();
  return database;
}

Future<void> _openAddForm(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add_rounded).last);
  await tester.pumpAndSettle();
}

Future<void> _tapSave(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.text('Simpan bahan'),
    400,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Simpan bahan'));
  await tester.pumpAndSettle();
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  testWidgets('saving a valid form stores the item', (tester) async {
    final db = await _pumpApp(tester);
    await _openAddForm(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Tempe');
    await tester.pump();
    await _tapSave(tester);

    final items = await db.pantryDao.getActive();
    expect(items, hasLength(1));
    expect(items.single.name, 'Tempe');
    expect(items.single.quantity, 1);
    expect(items.single.storageLocation.name, 'kulkas');

    expect(find.text('Tempe'), findsOneWidget);
    expect(find.text('Bahan berhasil disimpan.'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('empty name shows a validation error', (tester) async {
    await _pumpApp(tester);
    await _openAddForm(tester);

    await _tapSave(tester);

    expect(find.text('Nama bahan wajib diisi.'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('choosing a catalog chip fills the form', (tester) async {
    final db = await _pumpApp(tester);
    await db
        .into(db.ingredientCatalogs)
        .insert(
          IngredientCatalogsCompanion.insert(
            id: 'bayam',
            nameId: 'Bayam',
            nameEn: 'Spinach',
            category: IngredientCategory.sayur,
            emoji: '🥬',
            defaultUnit: Unit.ikat,
            shelfLifeKulkas: const Value(4),
            shelfLifeNote: 'Simpan di kulkas.',
          ),
        );
    await tester.pumpAndSettle();
    await _openAddForm(tester);

    await tester.tap(find.text('🥬 Bayam'));
    await tester.pumpAndSettle();

    final nameField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(nameField.controller?.text, 'Bayam');
    await tester.scrollUntilVisible(
      find.textContaining('Umur simpan di Kulkas: 4 hari'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Umur simpan di Kulkas: 4 hari'),
      findsOneWidget,
    );

    await _dispose(tester);
  });
}
