import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/app.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/data/local/database_provider.dart';

import 'helpers/test_database.dart';

Future<void> _pumpSegar(
  WidgetTester tester, {
  Map<String, Object> preferences = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(preferences);
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
}

/// Drift schedules a zero-duration timer when a query stream is cancelled.
/// Disposing the tree inside the test body lets that timer run before the
/// framework checks for pending timers at the end of the test.
Future<void> _disposeSegar(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  testWidgets('Onboarding leads to home and all tabs render', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpSegar(tester);

    expect(find.text('Catat stok dapurmu'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Pengingat sebelum basi'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Masak sebelum terbuang'), findsOneWidget);

    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Siapa nama panggilanmu?'), findsOneWidget);
    expect(find.text('Datamu tersimpan di HP ini saja.'), findsOneWidget);

    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Teman Segar! 👋'), findsOneWidget);
    expect(find.text('Status dapur'), findsOneWidget);

    await tester.tap(find.text('Resep'));
    await tester.pumpAndSettle();
    expect(find.text('Olah Sebelum Basi'), findsOneWidget);

    await tester.tap(find.text('Statistik'));
    await tester.pumpAndSettle();
    expect(find.text('Penghematan & Jejak Dapur'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profil & Pengaturan'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Teman Segar! 👋'), findsOneWidget);

    await _disposeSegar(tester);
  });

  testWidgets('Onboarding saves the entered name', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpSegar(tester);

    for (var page = 0; page < 3; page++) {
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Siapa nama panggilanmu?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Dina');
    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Dina! 👋'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('userName'), 'Dina');
    expect(prefs.getBool('onboardingDone'), isTrue);

    await _disposeSegar(tester);
  });

  testWidgets('Skipping onboarding keeps the default name', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpSegar(tester);

    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Teman Segar! 👋'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('userName'), isNull);
    expect(prefs.getBool('onboardingDone'), isTrue);

    await _disposeSegar(tester);
  });

  testWidgets('Center action opens add item and can go back', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpSegar(
      tester,
      preferences: <String, Object>{'onboardingDone': true, 'userName': 'Dina'},
    );

    expect(find.text('Halo, Dina! 👋'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded).last);
    await tester.pumpAndSettle();
    expect(find.text('Tambah Bahan'), findsWidgets);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Halo, Dina! 👋'), findsOneWidget);

    await _disposeSegar(tester);
  });

  testWidgets('Theme mode can be switched to dark from settings', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpSegar(
      tester,
      preferences: <String, Object>{'onboardingDone': true},
    );

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<ThemeMode>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gelap'));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.text('Profil & Pengaturan'))).brightness,
      Brightness.dark,
    );

    await _disposeSegar(tester);
  });

  testWidgets('Home and settings stay usable with large text', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _pumpSegar(
      tester,
      preferences: <String, Object>{'onboardingDone': true, 'userName': 'Dina'},
    );

    expect(find.text('Halo, Dina! 👋'), findsOneWidget);
    expect(find.text('Status dapur'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profil & Pengaturan'), findsOneWidget);

    expect(tester.takeException(), isNull);
    await _disposeSegar(tester);
  });

  testWidgets('Completed onboarding restores saved user name', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpSegar(
      tester,
      preferences: <String, Object>{'onboardingDone': true, 'userName': 'Rani'},
    );

    expect(find.text('Halo, Rani! 👋'), findsOneWidget);

    await _disposeSegar(tester);
  });
}
