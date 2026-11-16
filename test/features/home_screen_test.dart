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

import '../helpers/test_database.dart';

Future<AppDatabase> _pumpHome(WidgetTester tester) async {
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

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

Future<void> _insertItem(
  AppDatabase db, {
  required String id,
  required String name,
  required int daysFromToday,
  StorageLocation location = StorageLocation.kulkas,
}) {
  final today = dateOnly(DateTime.now());
  return db
      .into(db.pantryItems)
      .insert(
        PantryItemsCompanion.insert(
          id: id,
          name: name,
          category: IngredientCategory.sayur,
          quantity: 1,
          unit: Unit.ikat,
          storageLocation: location,
          purchaseDate: today.subtract(const Duration(days: 1)),
          expiryDate: today.add(Duration(days: daysFromToday)),
          expirySource: ExpirySource.estimasi,
          createdAt: today,
          updatedAt: today,
        ),
      );
}

void main() {
  testWidgets('empty pantry shows the empty state', (tester) async {
    await _pumpHome(tester);

    expect(find.text('Halo, Dina! 👋'), findsOneWidget);
    expect(find.text('Pantry masih kosong'), findsOneWidget);
    expect(find.text('Tambah bahan pertama'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('groups items by freshness and shows filter counts', (
    tester,
  ) async {
    final db = await _pumpHome(tester);
    await _insertItem(db, id: 'a', name: 'Bayam', daysFromToday: 2);
    await _insertItem(
      db,
      id: 'b',
      name: 'Beras',
      daysFromToday: 30,
      location: StorageLocation.lemari,
    );
    await _insertItem(db, id: 'c', name: 'Ayam', daysFromToday: -2);
    await tester.pumpAndSettle();

    expect(find.text('Bayam'), findsOneWidget);
    expect(find.text('Beras'), findsOneWidget);
    expect(find.text('Ayam'), findsOneWidget);
    expect(find.text('Segera dipakai'), findsOneWidget);
    expect(find.text('Sudah basi'), findsWidgets);
    expect(find.text('Kondisi aman'), findsOneWidget);
    expect(find.text('Semua (3)'), findsOneWidget);
    expect(find.text('Kulkas (2)'), findsOneWidget);
    expect(find.text('Lemari (1)'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('search filters the list and can be cleared', (tester) async {
    final db = await _pumpHome(tester);
    await _insertItem(db, id: 'a', name: 'Bayam', daysFromToday: 2);
    await _insertItem(db, id: 'b', name: 'Beras', daysFromToday: 30);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'ber');
    await tester.pumpAndSettle();

    expect(find.text('Beras'), findsOneWidget);
    expect(find.text('Bayam'), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Bahan tidak ditemukan'), findsOneWidget);

    await tester.ensureVisible(find.text('Hapus filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus filter'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();
    expect(find.text('Bayam'), findsOneWidget);
    expect(find.text('Beras'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('tapping an item opens its detail screen', (tester) async {
    final db = await _pumpHome(tester);
    await _insertItem(db, id: 'a', name: 'Bayam', daysFromToday: 2);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bayam'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Bahan'), findsOneWidget);
    expect(find.text('Status kesegaran'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Tandai terpakai'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Tandai terpakai'), findsOneWidget);

    await _dispose(tester);
  });
}
