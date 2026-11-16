import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/stats_utils.dart';
import 'package:segar/data/local/enums.dart';

void main() {
  final now = DateTime(2026, 11, 11, 12);

  StatsLogInput log({
    String itemId = 'p1',
    UsageAction action = UsageAction.dipakai,
    int valueIdr = 10000,
    int weightGrams = 500,
    IngredientCategory category = IngredientCategory.sayur,
    DateTime? loggedAt,
    bool isEstimate = false,
    WasteReason? reason,
  }) {
    return StatsLogInput(
      itemId: itemId,
      action: action,
      valueIdr: valueIdr,
      weightGrams: weightGrams,
      category: category,
      loggedAt: loggedAt ?? DateTime(2026, 11, 10, 9),
      isEstimate: isEstimate,
      reasonWasted: reason,
    );
  }

  StatsReport report({
    int savedIdr = 0,
    int wastedIdr = 0,
    int usedCount = 0,
    int wastedCount = 0,
  }) {
    return StatsReport(
      period: StatsPeriod.semua,
      summary: StatsSummary(
        savedIdr: savedIdr,
        wastedIdr: wastedIdr,
        savedWeightGrams: 0,
        wastedWeightGrams: 0,
      ),
      usedCount: usedCount,
      wastedCount: wastedCount,
      categories: const <StatsCategoryStat>[],
      trend: const StatsTrend(
        granularity: StatsTrendGranularity.monthly,
        points: <StatsTrendPoint>[],
      ),
      wasteReasons: const <({WasteReason reason, int count})>[],
      streakDays: 0,
    );
  }

  group('managedPercent', () {
    test('returns the saved share of the managed value', () {
      expect(managedPercent(75000, 25000), 75);
    });

    test('returns zero without data', () {
      expect(managedPercent(0, 0), 0);
    });
  });

  group('categoryEfficiencyPercent', () {
    test('returns the used share of a category', () {
      expect(categoryEfficiencyPercent(30000, 10000), 75);
    });

    test('returns zero when nothing was tracked', () {
      expect(categoryEfficiencyPercent(0, 0), 0);
    });
  });

  group('weight conversions', () {
    test('converts saved grams to kilograms', () {
      expect(kgWasteReduced(1500), 1.5);
    });

    test('converts kilograms to rice portions', () {
      expect(ricePortionsForKg(0.9), closeTo(3, 0.0001));
    });
  });

  group('periodStart', () {
    test('starts the week on Monday', () {
      expect(
        periodStart(StatsPeriod.mingguIni, now: now),
        DateTime(2026, 11, 9),
      );
    });

    test('starts the month on the first day', () {
      expect(
        periodStart(StatsPeriod.bulanIni, now: now),
        DateTime(2026, 11, 1),
      );
    });

    test('starts three months back on the first day', () {
      expect(
        periodStart(StatsPeriod.tigaBulan, now: now),
        DateTime(2026, 9, 1),
      );
    });

    test('has no lower bound for semua', () {
      expect(periodStart(StatsPeriod.semua, now: now), isNull);
    });

    test('handles the start of a month for tigaBulan', () {
      expect(
        periodStart(StatsPeriod.tigaBulan, now: DateTime(2026, 1, 15)),
        DateTime(2025, 11, 1),
      );
    });
  });

  group('wasteFreeStreakDays', () {
    test('counts days since the last waste', () {
      expect(
        wasteFreeStreakDays(lastWastedAt: DateTime(2026, 11, 8), now: now),
        3,
      );
    });

    test('falls back to the first tracked day', () {
      expect(
        wasteFreeStreakDays(trackingSince: DateTime(2026, 11, 1), now: now),
        10,
      );
    });

    test('returns zero without any reference date', () {
      expect(wasteFreeStreakDays(now: now), 0);
    });

    test('never returns a negative streak', () {
      expect(
        wasteFreeStreakDays(lastWastedAt: DateTime(2026, 11, 12), now: now),
        0,
      );
    });
  });

  group('mostFrequentWasteReason', () {
    test('picks the highest count', () {
      expect(
        mostFrequentWasteReason(<WasteReason, int>{
          WasteReason.basi: 2,
          WasteReason.lupa: 5,
          WasteReason.terlaluBanyak: 1,
        }),
        WasteReason.lupa,
      );
    });

    test('returns null without data', () {
      expect(mostFrequentWasteReason(const <WasteReason, int>{}), isNull);
    });
  });

  group('StatsSummary', () {
    test('exposes totals and derived impact values', () {
      const summary = StatsSummary(
        savedIdr: 80000,
        wastedIdr: 20000,
        savedWeightGrams: 900,
        wastedWeightGrams: 100,
      );

      expect(summary.totalManagedIdr, 100000);
      expect(summary.managedPercentage, 80);
      expect(summary.kgWasteReduced, 0.9);
      expect(summary.ricePortions, closeTo(3, 0.0001));
      expect(summary.isEmpty, isFalse);
    });

    test('empty summary is empty', () {
      const summary = StatsSummary.empty();
      expect(summary.isEmpty, isTrue);
      expect(summary.totalManagedIdr, 0);
      expect(summary.managedPercentage, 0);
    });
  });

  group('motivationLevelFor', () {
    test('asks for data when the report is empty', () {
      expect(motivationLevelFor(report()), MotivationLevel.empty);
    });

    test('celebrates a high saved percentage', () {
      expect(
        motivationLevelFor(
          report(
            savedIdr: 90000,
            wastedIdr: 10000,
            usedCount: 9,
            wastedCount: 1,
          ),
        ),
        MotivationLevel.excellent,
      );
    });

    test('encourages a moderate percentage', () {
      expect(
        motivationLevelFor(
          report(
            savedIdr: 60000,
            wastedIdr: 40000,
            usedCount: 6,
            wastedCount: 4,
          ),
        ),
        MotivationLevel.good,
      );
    });

    test('acknowledges small savings', () {
      expect(
        motivationLevelFor(report(wastedIdr: 20000, usedCount: 1)),
        MotivationLevel.lowWaste,
      );
    });

    test('stays non-blaming without any savings', () {
      expect(
        motivationLevelFor(report(wastedIdr: 20000, wastedCount: 1)),
        MotivationLevel.learning,
      );
    });
  });

  group('worstCategory', () {
    test('returns null without data', () {
      expect(worstCategory(const <IngredientCategory, double>{}), isNull);
    });

    test('returns null when every category is healthy', () {
      expect(
        worstCategory(<IngredientCategory, double>{
          IngredientCategory.sayur: 90,
          IngredientCategory.buah: 85,
        }),
        isNull,
      );
    });

    test('points at the least efficient category', () {
      expect(
        worstCategory(<IngredientCategory, double>{
          IngredientCategory.sayur: 40,
          IngredientCategory.buah: 80,
        }),
        IngredientCategory.sayur,
      );
    });
  });

  group('buildStatsReport', () {
    test('aggregates values, weights and distinct item counts', () {
      final result = buildStatsReport(
        logs: <StatsLogInput>[
          log(itemId: 'p1', valueIdr: 20000, weightGrams: 500),
          log(
            itemId: 'p1',
            valueIdr: 10000,
            weightGrams: 200,
            loggedAt: DateTime(2026, 11, 11, 8),
          ),
          log(
            itemId: 'p2',
            action: UsageAction.dibuang,
            valueIdr: 5000,
            weightGrams: 300,
            reason: WasteReason.basi,
            loggedAt: DateTime(2026, 11, 11, 9),
          ),
          log(
            itemId: 'p3',
            valueIdr: 15000,
            weightGrams: 400,
            category: IngredientCategory.buah,
            loggedAt: DateTime(2026, 11, 9, 10),
          ),
        ],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(result.summary.savedIdr, 45000);
      expect(result.summary.wastedIdr, 5000);
      expect(result.summary.savedWeightGrams, 1100);
      expect(result.summary.wastedWeightGrams, 300);
      expect(result.usedCount, 2);
      expect(result.wastedCount, 1);
      expect(result.totalCount, 3);
      expect(result.usedSharePercent, closeTo(66.67, 0.01));
      expect(result.topWasteReason, WasteReason.basi);
    });

    test('filters the period but keeps the streak from older logs', () {
      final result = buildStatsReport(
        logs: <StatsLogInput>[
          log(itemId: 'old', loggedAt: DateTime(2026, 10, 1, 9)),
          log(
            itemId: 'old-waste',
            action: UsageAction.dibuang,
            loggedAt: DateTime(2026, 10, 1, 10),
          ),
          log(itemId: 'new', loggedAt: DateTime(2026, 11, 10, 9)),
        ],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(result.usedCount, 1);
      expect(result.wastedCount, 0);
      expect(result.summary.savedIdr, 10000);
      expect(result.lastWastedAt, DateTime(2026, 10, 1, 10));
      expect(result.streakDays, 41);
    });

    test('groups categories by efficiency, best first', () {
      final result = buildStatsReport(
        logs: <StatsLogInput>[
          log(itemId: 'p1', category: IngredientCategory.sayur),
          log(
            itemId: 'p2',
            action: UsageAction.dibuang,
            category: IngredientCategory.sayur,
            valueIdr: 5000,
          ),
          log(itemId: 'p3', category: IngredientCategory.buah),
        ],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(result.categories, hasLength(2));
      expect(result.categories.first.category, IngredientCategory.buah);
      expect(result.categories.first.efficiencyPercent, 100);
      expect(result.categories.last.category, IngredientCategory.sayur);
      expect(result.categories.last.efficiencyPercent, closeTo(66.67, 0.01));
      expect(result.categories.last.usedCount, 1);
      expect(result.categories.last.wastedCount, 1);
    });

    test('sorts waste reasons by frequency', () {
      final result = buildStatsReport(
        logs: <StatsLogInput>[
          log(
            itemId: 'p1',
            action: UsageAction.dibuang,
            reason: WasteReason.lupa,
          ),
          log(
            itemId: 'p2',
            action: UsageAction.dibuang,
            reason: WasteReason.basi,
          ),
          log(
            itemId: 'p3',
            action: UsageAction.dibuang,
            reason: WasteReason.basi,
          ),
        ],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(result.wasteReasons.first.reason, WasteReason.basi);
      expect(result.wasteReasons.first.count, 2);
      expect(result.wasteReasons.last.reason, WasteReason.lupa);
      expect(result.wasteLogCount, 3);
    });

    test('falls back to item counts when prices are missing', () {
      final result = buildStatsReport(
        logs: <StatsLogInput>[
          log(itemId: 'p1', valueIdr: 0, category: IngredientCategory.sayur),
          log(
            itemId: 'p2',
            action: UsageAction.dibuang,
            valueIdr: 0,
            category: IngredientCategory.sayur,
          ),
        ],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(result.categories.single.efficiencyPercent, 50);
    });

    test('falls back to the first pantry date for the streak', () {
      final result = buildStatsReport(
        logs: const <StatsLogInput>[],
        period: StatsPeriod.semua,
        now: now,
        pantryTrackingSince: DateTime(2026, 11, 1),
      );

      expect(result.isEmpty, isTrue);
      expect(result.trackingSince, DateTime(2026, 11, 1));
      expect(result.streakDays, 10);
    });

    test('flags estimated values', () {
      final result = buildStatsReport(
        logs: <StatsLogInput>[log(isEstimate: true)],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(result.summary.hasEstimate, isTrue);
    });
  });

  group('buildTrend', () {
    test('creates seven daily buckets for the current week', () {
      final trend = buildTrend(
        logs: <StatsLogInput>[
          log(itemId: 'a', loggedAt: DateTime(2026, 11, 9, 10)),
          log(
            itemId: 'b',
            action: UsageAction.dibuang,
            valueIdr: 500,
            loggedAt: DateTime(2026, 11, 15, 23),
          ),
        ],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(trend.granularity, StatsTrendGranularity.daily);
      expect(trend.points, hasLength(7));
      expect(trend.points.first.start, DateTime(2026, 11, 9));
      expect(trend.points.first.savedIdr, 10000);
      expect(trend.points.last.start, DateTime(2026, 11, 15));
      expect(trend.points.last.wastedIdr, 500);
      expect(trend.hasData, isTrue);
    });

    test('creates four weekly buckets for the current month', () {
      final trend = buildTrend(
        logs: <StatsLogInput>[
          log(itemId: 'a', loggedAt: DateTime(2026, 11, 1, 10)),
          log(itemId: 'b', loggedAt: DateTime(2026, 11, 20, 10)),
        ],
        period: StatsPeriod.bulanIni,
        now: now,
      );

      expect(trend.granularity, StatsTrendGranularity.weekly);
      expect(trend.points, hasLength(4));
      expect(trend.points.first.start, DateTime(2026, 11, 1));
      expect(trend.points.first.end, DateTime(2026, 11, 8));
      expect(trend.points.first.savedIdr, 10000);
      expect(trend.points[2].start, DateTime(2026, 11, 15));
      expect(trend.points[2].end, DateTime(2026, 11, 22));
      expect(trend.points[2].savedIdr, 10000);
    });

    test('creates one bucket per month for three months', () {
      final trend = buildTrend(
        logs: <StatsLogInput>[
          log(itemId: 'a', loggedAt: DateTime(2025, 11, 5, 10)),
          log(itemId: 'b', loggedAt: DateTime(2026, 1, 10, 10)),
        ],
        period: StatsPeriod.tigaBulan,
        now: DateTime(2026, 1, 15),
      );

      expect(trend.granularity, StatsTrendGranularity.monthly);
      expect(trend.points, hasLength(3));
      expect(trend.points.first.start, DateTime(2025, 11, 1));
      expect(trend.points.first.savedIdr, 10000);
      expect(trend.points.last.start, DateTime(2026, 1, 1));
      expect(trend.points.last.savedIdr, 10000);
    });

    test('caps the all-time trend to the last six months', () {
      final trend = buildTrend(
        logs: <StatsLogInput>[
          log(itemId: 'a', loggedAt: DateTime(2026, 1, 10, 10)),
          log(itemId: 'b', loggedAt: DateTime(2026, 11, 10, 10)),
        ],
        period: StatsPeriod.semua,
        now: now,
        firstLogAt: DateTime(2026, 1, 10),
      );

      expect(trend.points, hasLength(6));
      expect(trend.points.first.start, DateTime(2026, 6, 1));
      expect(trend.points.last.start, DateTime(2026, 11, 1));
      expect(trend.points.last.savedIdr, 10000);
    });

    test('falls back to log counts when prices are missing', () {
      final trend = buildTrend(
        logs: <StatsLogInput>[
          log(itemId: 'a', valueIdr: 0, loggedAt: DateTime(2026, 11, 10, 10)),
        ],
        period: StatsPeriod.mingguIni,
        now: now,
      );

      expect(trend.hasData, isTrue);
      expect(trend.points[1].savedCount, 1);
      expect(trend.points[1].savedIdr, 0);
    });

    test('returns no points for all-time without logs', () {
      final trend = buildTrend(
        logs: const <StatsLogInput>[],
        period: StatsPeriod.semua,
        now: now,
      );

      expect(trend.points, isEmpty);
      expect(trend.hasData, isFalse);
    });
  });
}
