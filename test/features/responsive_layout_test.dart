import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/app.dart';
import 'package:segar/core/notifications/notification_providers.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/core/utils/expiry_utils.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/online_recipe.dart';
import 'package:segar/data/repositories/repository_providers.dart';

import '../helpers/fake_notification_service.dart';
import '../helpers/fake_online_sources.dart';
import '../helpers/recipe_seed.dart';
import '../helpers/test_database.dart';

/// Logical sizes that cover small Android phones, iPhones, and a tablet.
const _devices = <String, Size>{
  'Android 320x568': Size(320, 568),
  'iPhone 12 mini 360x780': Size(360, 780),
  'iPhone SE 375x667': Size(375, 667),
  'Android 412x915': Size(412, 915),
  'iPhone 14 Pro Max 430x932': Size(430, 932),
  'Tablet 768x1024': Size(768, 1024),
};

const _textScales = <double>[1.0, 1.3, 1.6, 2.0, 3.0];

Future<AppDatabase> _pumpApp(
  WidgetTester tester,
  Size size,
  double textScale,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  final database = openTestDatabase();
  addTearDown(database.close);

  await seedCatalogAndRecipes(database);
  final today = dateOnly(DateTime.now());
  await insertPantryItem(
    database,
    id: 'p-bayam',
    catalogId: 'bayam',
    name: 'Bayam',
    quantity: 3,
    unit: Unit.ikat,
    expiryDate: today.add(const Duration(days: 2)),
    purchaseDate: today.subtract(const Duration(days: 1)),
  );
  await insertPantryItem(
    database,
    id: 'p-tomat',
    catalogId: 'tomat',
    name: 'Tomat',
    quantity: 5,
    unit: Unit.butir,
    expiryDate: today.add(const Duration(days: 30)),
    purchaseDate: today.subtract(const Duration(days: 2)),
  );
  await database.shoppingListDao.addItem(
    name: 'Bawang merah',
    quantity: 2,
    unit: Unit.siung,
    at: DateTime.now(),
  );
  await database.usageLogDao.insertLog(
    UsageLogsCompanion.insert(
      id: 'log-1',
      pantryItemId: 'p-bayam',
      action: UsageAction.dipakai,
      quantityChanged: 1,
      valueIdr: const Value(5000),
      weightGrams: const Value(200),
      category: IngredientCategory.sayur,
      loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
        notificationServiceProvider.overrideWithValue(
          FakeNotificationService(permissionGranted: false),
        ),
        recipeRemoteSourceProvider.overrideWithValue(
          FakeRecipeRemoteSource(
            searchResults: <OnlineRecipe>[sampleOnlineRecipe()],
            details: <String, OnlineRecipe>{'52772': sampleOnlineRecipe()},
          ),
        ),
        connectivityCheckerProvider.overrideWithValue(
          FakeConnectivityChecker(),
        ),
      ],
      child: const SegarApp(),
    ),
  );
  await tester.pumpAndSettle();
  return database;
}

void _expectNoOverflow(WidgetTester tester, String where) {
  expect(tester.takeException(), isNull, reason: 'Layout gagal di $where');
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    250,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _scrollToBottom(WidgetTester tester) async {
  final scrollable = find.byType(Scrollable).first;
  await tester.fling(scrollable, const Offset(0, -1800), 4000);
  await tester.pumpAndSettle();
}

Future<void> _scrollToTop(WidgetTester tester) async {
  final scrollable = find.byType(Scrollable).first;
  await tester.fling(scrollable, const Offset(0, 1800), 4000);
  await tester.pumpAndSettle();
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

Future<void> _openItemDetail(WidgetTester tester) async {
  await _scrollToTop(tester);
  await _scrollTo(tester, find.text('Bayam'));
  await tester.tap(find.text('Bayam').first);
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'detail bahan');
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'detail bahan (bawah)');

  await tester.tap(find.byIcon(Icons.edit_outlined));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'ubah bahan');
  await _scrollTo(tester, find.text('Simpan perubahan'));
  _expectNoOverflow(tester, 'ubah bahan (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.delete_outline_rounded));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'dialog hapus bahan');
  await tester.tap(find.text('Batal'));
  await tester.pumpAndSettle();

  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}

Future<void> _openAddItem(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add_rounded).last);
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'tambah bahan');
  await _scrollTo(tester, find.text('Pindai / ketik barcode'));
  _expectNoOverflow(tester, 'tambah bahan (barcode)');
  await tester.tap(find.text('Pindai / ketik barcode'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'sheet barcode');
  await tester.tap(find.byTooltip('Tutup'));
  await tester.pumpAndSettle();
  await _scrollTo(tester, find.text('Simpan bahan'));
  _expectNoOverflow(tester, 'tambah bahan (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}

Future<void> _openOnlineRecipeDetail(WidgetTester tester) async {
  await _scrollTo(tester, find.text('Cari resep online'));
  await tester.tap(find.text('Cari resep online'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'resep online');
  await tester.enterText(find.byType(TextField), 'nasi');
  await _scrollTo(tester, find.text('Cari'));
  await tester.tap(find.text('Cari'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'hasil resep online');
  await _scrollTo(tester, find.text('Nasi Goreng Spesial'));
  await tester.tap(find.text('Nasi Goreng Spesial'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'detail resep online');
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'detail resep online (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}

Future<void> _openRecipeDetail(WidgetTester tester) async {
  await _scrollTo(tester, find.text('Sayur Bening Bayam Jagung Manis'));
  await tester.tap(find.text('Sayur Bening Bayam Jagung Manis').first);
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'detail resep');
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'detail resep (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}

Future<void> _openShoppingAndBackup(WidgetTester tester) async {
  await _scrollTo(tester, find.text('Panduan pengingat'));
  await tester.tap(find.text('Panduan pengingat'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'panduan pengingat');
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'panduan pengingat (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  await _scrollTo(tester, find.text('Daftar Belanja'));
  _expectNoOverflow(tester, 'pengaturan (bawah)');
  await tester.tap(find.text('Daftar Belanja'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'daftar belanja');
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'daftar belanja (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  await _scrollTo(tester, find.text('Cadangan & pemulihan'));
  await tester.tap(find.text('Cadangan & pemulihan'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'cadangan');
  await _scrollTo(tester, find.text('Bagikan file cadangan'));
  _expectNoOverflow(tester, 'cadangan (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  await _scrollTo(tester, find.text('Tentang Segar'));
  await tester.tap(find.text('Tentang Segar'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'tentang');
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'tentang (bawah)');
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  await _scrollTo(tester, find.text('Hapus semua data'));
  await tester.tap(find.text('Hapus semua data'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'dialog hapus data');
  await tester.tap(find.text('Tutup'));
  await tester.pumpAndSettle();
}

Future<void> _walkEveryScreen(WidgetTester tester) async {
  // Onboarding: four pages, then save a name.
  expect(find.text('Catat stok dapurmu'), findsOneWidget);
  _expectNoOverflow(tester, 'onboarding 1');
  for (var page = 0; page < 3; page++) {
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    _expectNoOverflow(tester, 'onboarding ${page + 2}');
  }
  await tester.enterText(find.byType(TextField), 'Dina');
  await tester.tap(find.text('Mulai Sekarang'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'beranda');
  expect(find.text('Halo, Dina! 👋'), findsOneWidget);

  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'beranda (bawah)');

  await _openItemDetail(tester);
  await _openAddItem(tester);

  await tester.tap(find.text('Resep'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'resep');
  await _openOnlineRecipeDetail(tester);
  await _openRecipeDetail(tester);
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'resep (bawah)');

  await tester.tap(find.text('Statistik'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'statistik');
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'statistik (bawah)');

  await tester.tap(find.text('Profil'));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, 'pengaturan');
  await _openShoppingAndBackup(tester);
  await _scrollToBottom(tester);
  _expectNoOverflow(tester, 'pengaturan (akhir)');
}

void main() {
  for (final device in _devices.entries) {
    for (final scale in _textScales) {
      testWidgets('tidak overflow: ${device.key} @ ${scale}x', (tester) async {
        await _pumpApp(tester, device.value, scale);
        await _walkEveryScreen(tester);
        await _dispose(tester);
      });
    }
  }
}
