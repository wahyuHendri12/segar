import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/app.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/data/models/online_recipe.dart';
import 'package:segar/data/repositories/repository_providers.dart';

import '../helpers/fake_online_sources.dart';
import '../helpers/test_database.dart';

Future<AppDatabase> _pumpApp(
  WidgetTester tester, {
  required FakeRecipeRemoteSource remote,
  bool online = true,
  Map<String, Object> preferences = const <String, Object>{},
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues(<String, Object>{
    'onboardingDone': true,
    'userName': 'Dina',
    ...preferences,
  });
  final prefs = await SharedPreferences.getInstance();
  final database = openTestDatabase();
  addTearDown(database.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
        recipeRemoteSourceProvider.overrideWithValue(remote),
        connectivityCheckerProvider.overrideWithValue(
          FakeConnectivityChecker(online: online),
        ),
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

Future<void> _openRecipes(WidgetTester tester) async {
  await tester.tap(find.text('Resep'));
  await tester.pumpAndSettle();
}

Future<void> _openOnlineRecipes(WidgetTester tester) async {
  await _openRecipes(tester);
  await tester.tap(find.text('Cari resep online'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('searches online recipes and opens the cached detail', (
    tester,
  ) async {
    final recipe = sampleOnlineRecipe();
    final remote = FakeRecipeRemoteSource(
      searchResults: <OnlineRecipe>[recipe],
      details: <String, OnlineRecipe>{recipe.id: recipe},
    );
    await _pumpApp(tester, remote: remote);

    await _openOnlineRecipes(tester);

    expect(find.text('Resep Online'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'nasi');
    await tester.tap(find.text('Cari'));
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
    expect(find.text('Indonesian · Chicken · 3 bahan'), findsOneWidget);
    expect(remote.searchCalls, 1);

    await tester.tap(find.text('Nasi Goreng Spesial'));
    await tester.pumpAndSettle();

    expect(find.text('Bahan'), findsOneWidget);
    expect(find.text('2 cups Rice'), findsOneWidget);
    expect(find.text('200g Chicken'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Cara membuat'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Cara membuat'), findsOneWidget);
    expect(find.text('Tumis bumbu sampai harum.'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('shows the offline state without a connection', (tester) async {
    final remote = FakeRecipeRemoteSource();
    await _pumpApp(tester, remote: remote, online: false);

    await _openOnlineRecipes(tester);
    await tester.enterText(find.byType(TextField), 'nasi');
    await tester.tap(find.text('Cari'));
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada koneksi'), findsOneWidget);
    expect(remote.searchCalls, 0);

    await _dispose(tester);
  });

  testWidgets('the recipe entry card explains when online is disabled', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      remote: FakeRecipeRemoteSource(),
      preferences: <String, Object>{'onlineRecipeEnabled': false},
    );

    await _openRecipes(tester);

    expect(
      find.text(
        'Fitur online dimatikan. Aktifkan untuk mencari resep dari internet.',
      ),
      findsOneWidget,
    );
    expect(find.text('Buka Pengaturan'), findsOneWidget);

    await _dispose(tester);
  });
}
