import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/stats_utils.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/repositories/stats_repository.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late StatsRepository repository;
  final now = DateTime(2026, 11, 11, 12);

  setUp(() {
    db = openTestDatabase();
    repository = StatsRepository(
      usageLogDao: db.usageLogDao,
      pantryDao: db.pantryDao,
      clock: () => now,
    );
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertLog({
    required String id,
    required String itemId,
    UsageAction action = UsageAction.dipakai,
    int valueIdr = 10000,
    int weightGrams = 500,
    IngredientCategory category = IngredientCategory.sayur,
    WasteReason? reason,
    bool isEstimate = false,
    DateTime? loggedAt,
  }) {
    return db.usageLogDao.insertLog(
      UsageLogsCompanion.insert(
        id: id,
        pantryItemId: itemId,
        action: action,
        quantityChanged: 1,
        valueIdr: Value(valueIdr),
        isEstimate: Value(isEstimate),
        weightGrams: Value(weightGrams),
        category: category,
        reasonWasted: Value(reason),
        loggedAt: loggedAt ?? DateTime(2026, 11, 10, 9),
      ),
    );
  }

  Future<void> insertPantryItem({
    required String id,
    required DateTime createdAt,
  }) {
    return db
        .into(db.pantryItems)
        .insert(
          PantryItemsCompanion.insert(
            id: id,
            name: 'Bayam',
            category: IngredientCategory.sayur,
            quantity: 1,
            unit: Unit.ikat,
            storageLocation: StorageLocation.kulkas,
            purchaseDate: createdAt,
            expiryDate: createdAt.add(const Duration(days: 4)),
            expirySource: ExpirySource.estimasi,
            createdAt: createdAt,
            updatedAt: createdAt,
          ),
        );
  }

  group('getReport', () {
    test('returns an empty report when there are no logs', () async {
      final report = await repository.getReport(StatsPeriod.semua);

      expect(report.isEmpty, isTrue);
      expect(report.summary.isEmpty, isTrue);
      expect(report.usedCount, 0);
      expect(report.wastedCount, 0);
      expect(report.categories, isEmpty);
      expect(report.wasteReasons, isEmpty);
      expect(report.trend.points, isEmpty);
      expect(report.streakDays, 0);
    });

    test('aggregates values, weights and distinct items', () async {
      await insertLog(id: 'l1', itemId: 'p1', valueIdr: 20000);
      await insertLog(
        id: 'l2',
        itemId: 'p1',
        valueIdr: 5000,
        loggedAt: DateTime(2026, 11, 11, 8),
      );
      await insertLog(
        id: 'l3',
        itemId: 'p2',
        action: UsageAction.dibuang,
        valueIdr: 7000,
        weightGrams: 300,
        reason: WasteReason.basi,
      );

      final report = await repository.getReport(StatsPeriod.mingguIni);

      expect(report.summary.savedIdr, 25000);
      expect(report.summary.wastedIdr, 7000);
      expect(report.summary.savedWeightGrams, 1000);
      expect(report.summary.wastedWeightGrams, 300);
      expect(report.usedCount, 1);
      expect(report.wastedCount, 1);
      expect(report.totalCount, 2);
      expect(report.topWasteReason, WasteReason.basi);
    });

    test('filters logs outside the selected period', () async {
      await insertLog(
        id: 'old',
        itemId: 'p1',
        loggedAt: DateTime(2026, 10, 1, 9),
      );
      await insertLog(
        id: 'new',
        itemId: 'p2',
        loggedAt: DateTime(2026, 11, 10, 9),
      );

      final week = await repository.getReport(StatsPeriod.mingguIni);
      final all = await repository.getReport(StatsPeriod.semua);

      expect(week.usedCount, 1);
      expect(week.summary.savedIdr, 10000);
      expect(all.usedCount, 2);
      expect(all.summary.savedIdr, 20000);
    });

    test('keeps the streak based on waste outside the period', () async {
      await insertLog(
        id: 'waste',
        itemId: 'p1',
        action: UsageAction.dibuang,
        reason: WasteReason.lupa,
        loggedAt: DateTime(2026, 11, 1, 9),
      );
      await insertLog(
        id: 'use',
        itemId: 'p2',
        loggedAt: DateTime(2026, 11, 10, 9),
      );

      final report = await repository.getReport(StatsPeriod.mingguIni);

      expect(report.wastedCount, 0);
      expect(report.lastWastedAt, DateTime(2026, 11, 1, 9));
      expect(report.streakDays, 10);
    });

    test('uses the first pantry item as a streak fallback', () async {
      await insertPantryItem(id: 'p1', createdAt: DateTime(2026, 11, 6));

      final report = await repository.getReport(StatsPeriod.mingguIni);

      expect(report.isEmpty, isTrue);
      expect(report.trackingSince, DateTime(2026, 11, 6));
      expect(report.streakDays, 5);
    });

    test('groups categories best-first and sorts waste reasons', () async {
      await insertLog(
        id: 'l1',
        itemId: 'p1',
        category: IngredientCategory.sayur,
      );
      await insertLog(
        id: 'l2',
        itemId: 'p2',
        action: UsageAction.dibuang,
        category: IngredientCategory.sayur,
        valueIdr: 10000,
        reason: WasteReason.basi,
      );
      await insertLog(
        id: 'l3',
        itemId: 'p3',
        category: IngredientCategory.buah,
      );
      await insertLog(
        id: 'l4',
        itemId: 'p4',
        action: UsageAction.dibuang,
        category: IngredientCategory.buah,
        valueIdr: 2000,
        reason: WasteReason.basi,
      );
      await insertLog(
        id: 'l5',
        itemId: 'p5',
        action: UsageAction.dibuang,
        category: IngredientCategory.buah,
        valueIdr: 1000,
        reason: WasteReason.lupa,
      );

      final report = await repository.getReport(StatsPeriod.mingguIni);

      expect(report.categories, hasLength(2));
      expect(report.categories.first.category, IngredientCategory.buah);
      expect(report.categories.first.efficiencyPercent, closeTo(76.92, 0.01));
      expect(report.categories.last.category, IngredientCategory.sayur);
      expect(report.categories.last.efficiencyPercent, 50);
      expect(report.wasteReasons.first.reason, WasteReason.basi);
      expect(report.wasteReasons.first.count, 2);
      expect(report.wasteLogCount, 3);
    });

    test('flags estimated values and falls back to log counts', () async {
      await insertLog(
        id: 'l1',
        itemId: 'p1',
        valueIdr: 0,
        isEstimate: true,
        loggedAt: DateTime(2026, 11, 10, 9),
      );

      final report = await repository.getReport(StatsPeriod.mingguIni);

      expect(report.summary.hasEstimate, isTrue);
      expect(report.summary.savedIdr, 0);
      expect(report.trend.hasData, isTrue);
      expect(report.trend.points[1].savedCount, 1);
    });
  });

  group('watchReport', () {
    test('re-emits after a new log is inserted', () async {
      final reports = <StatsReport>[];
      final subscription = repository
          .watchReport(StatsPeriod.mingguIni)
          .listen(reports.add);

      await pumpEventQueue();
      await insertLog(id: 'l1', itemId: 'p1');
      await pumpEventQueue();

      expect(reports, isNotEmpty);
      expect(reports.last.usedCount, 1);
      expect(reports.last.summary.savedIdr, 10000);

      await subscription.cancel();
    });
  });
}
