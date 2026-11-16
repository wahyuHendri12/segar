import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/app.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/data/local/database_provider.dart';

import '../helpers/test_database.dart';

Future<SharedPreferences> _pumpSettings(WidgetTester tester) async {
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

  await tester.tap(find.text('Profil'));
  await tester.pumpAndSettle();
  return prefs;
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('online feature toggles persist and cache can be cleared', (
    tester,
  ) async {
    final prefs = await _pumpSettings(tester);

    await _scrollTo(tester, find.text('Fitur Online'));
    expect(find.text('Cari produk lewat barcode'), findsOneWidget);
    expect(find.text('Cari resep online'), findsOneWidget);
    expect(find.text('Hapus cache online'), findsOneWidget);

    await tester.tap(find.text('Cari resep online'));
    await tester.pumpAndSettle();
    expect(prefs.getBool('onlineRecipeEnabled'), isFalse);

    await tester.tap(find.text('Cari produk lewat barcode'));
    await tester.pumpAndSettle();
    expect(prefs.getBool('onlineBarcodeEnabled'), isFalse);

    await tester.tap(find.text('Hapus cache online'));
    await tester.pumpAndSettle();
    expect(find.text('Cache online dihapus.'), findsOneWidget);

    await _dispose(tester);
  });
}
