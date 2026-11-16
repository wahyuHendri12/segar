import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/app.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/core/utils/expiry_utils.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/data/local/enums.dart';

import '../helpers/recipe_seed.dart';
import '../helpers/test_database.dart';

Future<AppDatabase> _pumpRecipes(WidgetTester tester) async {
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

  await seedCatalogAndRecipes(database);

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

  await tester.tap(find.text('Resep'));
  await tester.pumpAndSettle();
  return database;
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

Future<void> _addBayam(
  AppDatabase db, {
  double quantity = 3,
  int daysFromToday = 5,
}) {
  final today = dateOnly(DateTime.now());
  return insertPantryItem(
    db,
    id: 'p-bayam',
    catalogId: 'bayam',
    name: 'Bayam',
    quantity: quantity,
    unit: Unit.ikat,
    expiryDate: today.add(Duration(days: daysFromToday)),
    purchaseDate: today.subtract(const Duration(days: 1)),
  );
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _openRecipe(
  WidgetTester tester, {
  String title = 'Sayur Bening Bayam Jagung Manis',
}) async {
  final titleFinder = find.text(title);
  await _scrollTo(tester, titleFinder);
  await tester.tap(titleFinder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the pantry empty state when there are no items', (
    tester,
  ) async {
    await _pumpRecipes(tester);

    expect(
      find.text('Belum ada bahan yang mendesak. Tetap masak dari stokmu!'),
      findsOneWidget,
    );

    await _scrollTo(tester, find.text('Pantry masih kosong'));
    expect(find.text('Pantry masih kosong'), findsOneWidget);
    expect(find.text('Tambah bahan'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('shows recipes and the smart match summary', (tester) async {
    final db = await _pumpRecipes(tester);
    await _addBayam(db, daysFromToday: 2);
    await tester.pumpAndSettle();

    expect(
      find.text('1 dari 1 bahan hampir basi bisa diselamatkan'),
      findsOneWidget,
    );
    expect(find.text('Bayam'), findsOneWidget);

    await _scrollTo(tester, find.text('Sayur Bening Bayam Jagung Manis'));
    expect(find.text('Sayur Bening Bayam Jagung Manis'), findsOneWidget);
    expect(find.text('1 dari 4 bahan tersedia'), findsWidgets);

    await _dispose(tester);
  });

  testWidgets('filters recipes with the category chips', (tester) async {
    final db = await _pumpRecipes(tester);
    await _addBayam(db);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Semua Resep (12)'));
    await tester.pumpAndSettle();
    await tester.drag(find.text('Semua Resep (12)'), const Offset(-260, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu Kosan'));
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text('Sup Telur Tomat Gurih Ala Rumahan'));
    expect(find.text('Sup Telur Tomat Gurih Ala Rumahan'), findsOneWidget);
    expect(find.text('Ikan Tongkol Bumbu Kuning'), findsNothing);

    await _dispose(tester);
  });

  testWidgets('searches recipes by title or ingredient', (tester) async {
    final db = await _pumpRecipes(tester);
    await _addBayam(db);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'tomat');
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text('Sup Telur Tomat Gurih Ala Rumahan'));
    expect(find.text('Sup Telur Tomat Gurih Ala Rumahan'), findsOneWidget);
    expect(find.text('Sayur Bening Bayam Jagung Manis'), findsNothing);

    await _dispose(tester);
  });

  testWidgets('opens the detail screen with ingredients and steps', (
    tester,
  ) async {
    final db = await _pumpRecipes(tester);
    await _addBayam(db);
    await tester.pumpAndSettle();

    await _openRecipe(tester);

    expect(find.text('Detail Resep'), findsOneWidget);
    expect(find.text('Bahan-bahan'), findsOneWidget);
    expect(find.text('Masak dengan bahan tersedia'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Cara membuat'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(find.text('Cara membuat'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('adjusts servings and scales ingredient amounts', (tester) async {
    final db = await _pumpRecipes(tester);
    await _addBayam(db);
    await tester.pumpAndSettle();

    await _openRecipe(tester);
    expect(find.text('1 ikat'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('1,5 ikat'));
    await tester.pumpAndSettle();
    expect(find.text('1,5 ikat'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('cooks a recipe, reduces stock and can undo', (tester) async {
    final db = await _pumpRecipes(tester);
    await _addBayam(db, quantity: 3);
    await tester.pumpAndSettle();

    await _openRecipe(tester);
    await tester.tap(find.text('Masak dengan bahan tersedia'));
    await tester.pumpAndSettle();

    expect(find.text('Masak resep ini?'), findsOneWidget);
    await tester.tap(find.text('Masak & kurangi stok'));
    await tester.pumpAndSettle();

    expect(find.text('Resep dimasak. Stok pantry diperbarui.'), findsOneWidget);
    var item = await db.pantryDao.findById('p-bayam');
    expect(item!.quantity, 2);
    expect(item.status, PantryStatus.aktif);

    await tester.tap(find.text('Urungkan'));
    await tester.pumpAndSettle();

    item = await db.pantryDao.findById('p-bayam');
    expect(item!.quantity, 3);
    expect(item.status, PantryStatus.aktif);

    await _dispose(tester);
  });
}
