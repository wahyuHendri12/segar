import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/app.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/data/local/enums.dart';

import '../helpers/test_database.dart';

Future<AppDatabase> _pumpStats(WidgetTester tester) async {
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

  await tester.tap(find.text('Statistik'));
  await tester.pumpAndSettle();
  return database;
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

Future<void> _insertLog(
  AppDatabase db, {
  required String id,
  required String itemId,
  UsageAction action = UsageAction.dipakai,
  int valueIdr = 10000,
  int weightGrams = 500,
  IngredientCategory category = IngredientCategory.sayur,
  WasteReason? reason,
  Duration ago = const Duration(hours: 1),
}) {
  return db.usageLogDao.insertLog(
    UsageLogsCompanion.insert(
      id: id,
      pantryItemId: itemId,
      action: action,
      quantityChanged: 1,
      valueIdr: Value(valueIdr),
      weightGrams: Value(weightGrams),
      category: category,
      reasonWasted: Value(reason),
      loggedAt: DateTime.now().subtract(ago),
    ),
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

void main() {
  testWidgets('shows the empty state without usage logs', (tester) async {
    await _pumpStats(tester);

    expect(find.text('Penghematan & Jejak Dapur'), findsOneWidget);
    expect(find.text('Belum ada statistik'), findsOneWidget);
    expect(
      find.text(
        'Statistik akan muncul setelah kamu menandai bahan terpakai atau terbuang.',
      ),
      findsOneWidget,
    );

    await _dispose(tester);
  });

  testWidgets('shows the savings summary and charts', (tester) async {
    final db = await _pumpStats(tester);
    await _insertLog(db, id: 'l1', itemId: 'p1', valueIdr: 20000);
    await _insertLog(db, id: 'l2', itemId: 'p2', valueIdr: 10000);
    await _insertLog(
      db,
      id: 'l3',
      itemId: 'p3',
      action: UsageAction.dibuang,
      valueIdr: 5000,
      weightGrams: 300,
      reason: WasteReason.basi,
    );
    await tester.pumpAndSettle();

    expect(find.text('Total uang makanan diselamatkan'), findsOneWidget);
    expect(find.text('Rp30.000'), findsWidgets);
    expect(find.text('67% bahan berhasil dimasak tepat waktu'), findsOneWidget);
    expect(find.text('Dimasak'), findsWidgets);
    expect(find.text('Terbuang'), findsWidgets);
    expect(find.byKey(const Key('stats-distribution-chart')), findsOneWidget);
    expect(find.byKey(const Key('stats-trend-chart')), findsOneWidget);

    await _scrollTo(tester, find.text('Dampak Nyata Kebiasaanmu'));
    expect(find.text('Efisiensi per Kategori'), findsOneWidget);
    expect(find.text('Alasan Terbuang'), findsOneWidget);

    await _scrollTo(tester, find.text('Streak Tanpa Buang'));
    expect(find.text('Insight Belanja Minggu Depan'), findsOneWidget);

    await _dispose(tester);
  });

  testWidgets('switches period and offers all-time data', (tester) async {
    final db = await _pumpStats(tester);
    await _insertLog(
      db,
      id: 'old',
      itemId: 'p1',
      valueIdr: 15000,
      ago: const Duration(days: 200),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada catatan di periode ini'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Semua'),
      find.byType(ListView).last,
      const Offset(-100, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Semua'));
    await tester.pumpAndSettle();

    expect(find.text('Rp15.000'), findsWidgets);
    expect(find.text('Belum ada catatan di periode ini'), findsNothing);

    await _dispose(tester);
  });

  testWidgets('shows waste reasons and category insight', (tester) async {
    final db = await _pumpStats(tester);
    await _insertLog(db, id: 'l1', itemId: 'p1', valueIdr: 2000);
    await _insertLog(
      db,
      id: 'l2',
      itemId: 'p2',
      action: UsageAction.dibuang,
      valueIdr: 8000,
      reason: WasteReason.basi,
    );
    await _insertLog(
      db,
      id: 'l3',
      itemId: 'p3',
      action: UsageAction.dibuang,
      valueIdr: 2000,
      reason: WasteReason.lupa,
    );
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text('Efisiensi per Kategori'));
    expect(find.text('17%'), findsOneWidget);
    expect(find.text('Sayur'), findsWidgets);

    await _scrollTo(tester, find.text('Alasan Terbuang'));
    expect(find.text('Paling sering: Basi'), findsOneWidget);
    expect(find.text('Basi'), findsWidgets);
    expect(find.text('Lupa'), findsWidgets);
    expect(find.text('2 kali'), findsOneWidget);

    await _scrollTo(tester, find.text('Insight Belanja Minggu Depan'));
    expect(
      find.text(
        'Sayur paling sering terbuang. Coba beli lebih sedikit tapi lebih sering.',
      ),
      findsOneWidget,
    );

    await _dispose(tester);
  });

  testWidgets('pull to refresh keeps the report visible', (tester) async {
    final db = await _pumpStats(tester);
    await _insertLog(db, id: 'l1', itemId: 'p1', valueIdr: 20000);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).first, const Offset(0, 320));
    await tester.pumpAndSettle();

    expect(find.text('Rp20.000'), findsWidgets);
    expect(find.text('Belum ada statistik'), findsNothing);

    await _dispose(tester);
  });
}
