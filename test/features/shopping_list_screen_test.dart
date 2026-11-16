import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/core/widgets/app_button.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/features/shopping_list/shopping_list_screen.dart';
import 'package:segar/l10n/app_localizations.dart';

import '../helpers/test_database.dart';

Future<AppDatabase> _pumpShoppingList(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboardingDone': true,
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
      child: const MaterialApp(
        locale: Locale('id'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ShoppingListScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return database;
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  testWidgets('shows the empty state', (tester) async {
    await _pumpShoppingList(tester);

    expect(find.text('Daftar belanja masih kosong'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('adds an item and toggles it as bought', (tester) async {
    final db = await _pumpShoppingList(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Bayam');
    await tester.tap(
      find.descendant(
        of: find.byType(Form),
        matching: find.widgetWithText(AppButton, 'Tambah'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bayam'), findsOneWidget);
    expect(find.text('0 dari 1 sudah dibeli'), findsOneWidget);

    final stored = await db.shoppingListDao.getAll();
    expect(stored, hasLength(1));
    expect(stored.single.name, 'Bayam');

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(find.text('1 dari 1 sudah dibeli'), findsOneWidget);
    expect((await db.shoppingListDao.getAll()).single.isChecked, isTrue);

    await _dispose(tester);
  });
}
