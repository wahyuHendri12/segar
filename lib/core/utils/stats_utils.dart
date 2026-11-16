import '../../data/local/enums.dart';
import 'expiry_utils.dart';

/// Aggregated statistics for a selected period.
class StatsSummary {
  const StatsSummary({
    required this.savedIdr,
    required this.wastedIdr,
    required this.savedWeightGrams,
    required this.wastedWeightGrams,
    this.hasEstimate = false,
  });

  const StatsSummary.empty()
    : savedIdr = 0,
      wastedIdr = 0,
      savedWeightGrams = 0,
      wastedWeightGrams = 0,
      hasEstimate = false;

  final int savedIdr;
  final int wastedIdr;
  final int savedWeightGrams;
  final int wastedWeightGrams;

  /// True when at least one value came from the catalog's typical price.
  final bool hasEstimate;

  bool get isEmpty => savedIdr == 0 && wastedIdr == 0;

  int get totalManagedIdr => savedIdr + wastedIdr;

  double get managedPercentage => managedPercent(savedIdr, wastedIdr);

  double get kgWasteReduced => savedWeightGrams / 1000;

  double get ricePortions => ricePortionsForKg(kgWasteReduced);
}

/// Percentage of managed value that was saved instead of wasted.
double managedPercent(int savedIdr, int wastedIdr) {
  final total = savedIdr + wastedIdr;
  if (total <= 0) return 0;
  return savedIdr / total * 100;
}

/// Kilograms of food waste avoided from saved weight in grams.
double kgWasteReduced(int savedWeightGrams) => savedWeightGrams / 1000;

/// One portion of nasi rames is estimated at 0.3 kg.
const double ricePortionKg = 0.3;

double ricePortionsForKg(double kg) => kg / ricePortionKg;

/// Efficiency (0..100) for one category. Returns 0 when there is no data.
double categoryEfficiencyPercent(int usedIdr, int wastedIdr) {
  final total = usedIdr + wastedIdr;
  if (total <= 0) return 0;
  return usedIdr / total * 100;
}

/// Start of the selected period, or null for "semua" (no lower bound).
DateTime? periodStart(StatsPeriod period, {DateTime? now}) {
  final today = dateOnly(now ?? DateTime.now());
  return switch (period) {
    StatsPeriod.mingguIni => today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    ),
    StatsPeriod.bulanIni => DateTime(today.year, today.month),
    StatsPeriod.tigaBulan => DateTime(today.year, today.month - 2),
    StatsPeriod.semua => null,
  };
}

/// Consecutive days without a waste action.
///
/// If nothing has been wasted yet, falls back to the first tracked day when
/// available.
int wasteFreeStreakDays({
  DateTime? lastWastedAt,
  DateTime? trackingSince,
  DateTime? now,
}) {
  final today = dateOnly(now ?? DateTime.now());
  final start = lastWastedAt ?? trackingSince;
  if (start == null) return 0;
  final days = today.difference(dateOnly(start)).inDays;
  return days < 0 ? 0 : days;
}

/// Most frequent waste reason, or null when there is no waste data.
WasteReason? mostFrequentWasteReason(Map<WasteReason, int> counts) {
  WasteReason? best;
  var bestCount = 0;
  for (final entry in counts.entries) {
    if (entry.value > bestCount) {
      best = entry.key;
      bestCount = entry.value;
    }
  }
  return best;
}

/// Minimal usage-log shape needed to build statistics.
///
/// Keeping this as a DTO lets the aggregation stay pure and testable without
/// importing Drift into the UI or utility layer.
class StatsLogInput {
  const StatsLogInput({
    required this.itemId,
    required this.action,
    required this.valueIdr,
    required this.weightGrams,
    required this.category,
    required this.loggedAt,
    this.isEstimate = false,
    this.reasonWasted,
  });

  final String itemId;
  final UsageAction action;
  final int valueIdr;
  final bool isEstimate;
  final int weightGrams;
  final IngredientCategory category;
  final WasteReason? reasonWasted;
  final DateTime loggedAt;

  bool get isWaste => action == UsageAction.dibuang;

  bool get isUsed => !isWaste;
}

/// Value and item counts for one ingredient category.
class StatsCategoryStat {
  const StatsCategoryStat({
    required this.category,
    required this.usedIdr,
    required this.wastedIdr,
    required this.usedCount,
    required this.wastedCount,
  });

  final IngredientCategory category;
  final int usedIdr;
  final int wastedIdr;
  final int usedCount;
  final int wastedCount;

  int get totalCount => usedCount + wastedCount;

  bool get hasWaste => wastedCount > 0;

  /// Value-based efficiency, falling back to item counts when prices are
  /// missing so categories without prices are not reported as 0%.
  double get efficiencyPercent {
    if (usedIdr + wastedIdr > 0) {
      return categoryEfficiencyPercent(usedIdr, wastedIdr);
    }
    if (totalCount == 0) return 0;
    return usedCount / totalCount * 100;
  }
}

enum StatsTrendGranularity { daily, weekly, monthly }

/// One bucket of the usage-vs-waste trend chart.
class StatsTrendPoint {
  const StatsTrendPoint({
    required this.start,
    required this.end,
    this.savedIdr = 0,
    this.wastedIdr = 0,
    this.savedCount = 0,
    this.wastedCount = 0,
  });

  /// Inclusive lower bound.
  final DateTime start;

  /// Exclusive upper bound.
  final DateTime end;

  final int savedIdr;
  final int wastedIdr;
  final int savedCount;
  final int wastedCount;

  bool get hasData =>
      savedIdr > 0 || wastedIdr > 0 || savedCount > 0 || wastedCount > 0;

  int get totalIdr => savedIdr + wastedIdr;

  int get totalCount => savedCount + wastedCount;
}

class StatsTrend {
  const StatsTrend({required this.granularity, required this.points});

  final StatsTrendGranularity granularity;
  final List<StatsTrendPoint> points;

  bool get hasData => points.any((point) => point.hasData);
}

/// Everything the statistics screen needs for one period.
class StatsReport {
  const StatsReport({
    required this.period,
    required this.summary,
    required this.usedCount,
    required this.wastedCount,
    required this.categories,
    required this.trend,
    required this.wasteReasons,
    required this.streakDays,
    this.trackingSince,
    this.lastWastedAt,
  });

  final StatsPeriod period;
  final StatsSummary summary;

  /// Distinct pantry items that were used at least once in the period.
  final int usedCount;

  /// Distinct pantry items that were wasted at least once in the period.
  final int wastedCount;

  /// Categories with data, best efficiency first.
  final List<StatsCategoryStat> categories;

  final StatsTrend trend;

  /// Waste reasons, most frequent first.
  final List<({WasteReason reason, int count})> wasteReasons;

  final int streakDays;
  final DateTime? trackingSince;
  final DateTime? lastWastedAt;

  bool get isEmpty => usedCount == 0 && wastedCount == 0;

  int get totalCount => usedCount + wastedCount;

  double get usedSharePercent =>
      totalCount == 0 ? 0 : usedCount / totalCount * 100;

  WasteReason? get topWasteReason =>
      wasteReasons.isEmpty ? null : wasteReasons.first.reason;

  int get wasteLogCount =>
      wasteReasons.fold(0, (total, entry) => total + entry.count);
}

/// Builds the complete report for [period] from every usage log.
///
/// Period filtering happens here (instead of in the DAO) so the streak can
/// still look at logs older than the selected period.
StatsReport buildStatsReport({
  required List<StatsLogInput> logs,
  required StatsPeriod period,
  required DateTime now,
  DateTime? pantryTrackingSince,
}) {
  final start = periodStart(period, now: now);
  final filtered = <StatsLogInput>[
    for (final log in logs)
      if (start == null || !log.loggedAt.isBefore(start)) log,
  ];

  var savedIdr = 0;
  var wastedIdr = 0;
  var savedWeightGrams = 0;
  var wastedWeightGrams = 0;
  var hasEstimate = false;
  final usedItems = <String>{};
  final wastedItems = <String>{};
  final categoryMap = <IngredientCategory, _CategoryAccumulator>{};
  final reasonCounts = <WasteReason, int>{};

  for (final log in filtered) {
    final category = categoryMap.putIfAbsent(
      log.category,
      _CategoryAccumulator.new,
    );
    hasEstimate = hasEstimate || log.isEstimate;

    if (log.isWaste) {
      wastedIdr += log.valueIdr;
      wastedWeightGrams += log.weightGrams;
      wastedItems.add(log.itemId);
      category.wastedIdr += log.valueIdr;
      category.wastedItems.add(log.itemId);
      final reason = log.reasonWasted ?? WasteReason.lainnya;
      reasonCounts[reason] = (reasonCounts[reason] ?? 0) + 1;
    } else {
      savedIdr += log.valueIdr;
      savedWeightGrams += log.weightGrams;
      usedItems.add(log.itemId);
      category.usedIdr += log.valueIdr;
      category.usedItems.add(log.itemId);
    }
  }

  final categories =
      categoryMap.entries
          .map(
            (entry) => StatsCategoryStat(
              category: entry.key,
              usedIdr: entry.value.usedIdr,
              wastedIdr: entry.value.wastedIdr,
              usedCount: entry.value.usedItems.length,
              wastedCount: entry.value.wastedItems.length,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) {
          final byEfficiency = b.efficiencyPercent.compareTo(
            a.efficiencyPercent,
          );
          if (byEfficiency != 0) return byEfficiency;
          return b.totalCount.compareTo(a.totalCount);
        });

  final reasons = reasonCounts.entries.toList()
    ..sort((a, b) {
      final byCount = b.value.compareTo(a.value);
      if (byCount != 0) return byCount;
      return a.key.index.compareTo(b.key.index);
    });

  final firstLogAt = logs.isEmpty
      ? null
      : logs.map((log) => log.loggedAt).reduce((a, b) => a.isBefore(b) ? a : b);
  final lastWastedAt = _latestWasteAt(logs);
  final trackingSince = firstLogAt ?? pantryTrackingSince;

  return StatsReport(
    period: period,
    summary: StatsSummary(
      savedIdr: savedIdr,
      wastedIdr: wastedIdr,
      savedWeightGrams: savedWeightGrams,
      wastedWeightGrams: wastedWeightGrams,
      hasEstimate: hasEstimate,
    ),
    usedCount: usedItems.length,
    wastedCount: wastedItems.length,
    categories: categories,
    trend: buildTrend(
      logs: filtered,
      period: period,
      now: now,
      firstLogAt: firstLogAt,
    ),
    wasteReasons: <({WasteReason reason, int count})>[
      for (final entry in reasons) (reason: entry.key, count: entry.value),
    ],
    streakDays: wasteFreeStreakDays(
      lastWastedAt: lastWastedAt,
      trackingSince: trackingSince,
      now: now,
    ),
    trackingSince: trackingSince,
    lastWastedAt: lastWastedAt,
  );
}

/// Builds the usage-vs-waste trend for the selected period.
///
/// - `mingguIni`: one bucket per day (Monday–Sunday).
/// - `bulanIni`: four weekly buckets.
/// - `tigaBulan`: one bucket per month.
/// - `semua`: monthly buckets, capped to the last six months.
StatsTrend buildTrend({
  required List<StatsLogInput> logs,
  required StatsPeriod period,
  required DateTime now,
  DateTime? firstLogAt,
}) {
  final today = dateOnly(now);

  switch (period) {
    case StatsPeriod.mingguIni:
      final monday = today.subtract(
        Duration(days: today.weekday - DateTime.monday),
      );
      final points = <StatsTrendPoint>[
        for (var index = 0; index < 7; index++)
          StatsTrendPoint(
            start: monday.add(Duration(days: index)),
            end: monday.add(Duration(days: index + 1)),
          ),
      ];
      return _fillTrend(StatsTrendGranularity.daily, points, logs);

    case StatsPeriod.bulanIni:
      final first = DateTime(today.year, today.month);
      final next = DateTime(today.year, today.month + 1);
      final starts = <DateTime>[first];
      for (var day = 8; day <= 28; day += 7) {
        starts.add(DateTime(today.year, today.month, day));
      }
      final points = <StatsTrendPoint>[
        for (var index = 0; index < starts.length; index++)
          StatsTrendPoint(
            start: starts[index],
            end: index + 1 < starts.length ? starts[index + 1] : next,
          ),
      ];
      return _fillTrend(StatsTrendGranularity.weekly, points, logs);

    case StatsPeriod.tigaBulan:
      final months = <DateTime>[
        for (var offset = 2; offset >= 0; offset--)
          DateTime(today.year, today.month - offset),
      ];
      return _fillTrend(
        StatsTrendGranularity.monthly,
        _monthPoints(months, nextMonth: DateTime(today.year, today.month + 1)),
        logs,
      );

    case StatsPeriod.semua:
      if (logs.isEmpty) {
        return const StatsTrend(
          granularity: StatsTrendGranularity.monthly,
          points: <StatsTrendPoint>[],
        );
      }
      final earliest = dateOnly(
        firstLogAt ??
            logs
                .map((log) => log.loggedAt)
                .reduce((a, b) => a.isBefore(b) ? a : b),
      );
      final currentMonth = DateTime(today.year, today.month);
      final cap = DateTime(currentMonth.year, currentMonth.month - 5);
      var startMonth = DateTime(earliest.year, earliest.month);
      if (startMonth.isBefore(cap)) startMonth = cap;

      final months = <DateTime>[];
      var cursor = startMonth;
      while (!cursor.isAfter(currentMonth)) {
        months.add(cursor);
        cursor = DateTime(cursor.year, cursor.month + 1);
      }

      return _fillTrend(
        StatsTrendGranularity.monthly,
        _monthPoints(
          months,
          nextMonth: DateTime(currentMonth.year, currentMonth.month + 1),
        ),
        logs,
      );
  }
}

/// Tier used by the impact card so the UI can pick a localized message.
enum MotivationLevel { empty, excellent, good, lowWaste, learning }

MotivationLevel motivationLevelFor(StatsReport report) {
  if (report.isEmpty) return MotivationLevel.empty;
  final percent = report.summary.managedPercentage.round();
  if (percent >= 80) return MotivationLevel.excellent;
  if (percent >= 50) return MotivationLevel.good;
  if (report.usedCount > 0 || report.summary.savedIdr > 0) {
    return MotivationLevel.lowWaste;
  }
  return MotivationLevel.learning;
}

/// Worst-performing category below the healthy threshold, or null when every
/// category is healthy or there is no data.
IngredientCategory? worstCategory(
  Map<IngredientCategory, double> efficiencyPercent,
) {
  if (efficiencyPercent.isEmpty) return null;
  final worst = efficiencyPercent.entries.reduce(
    (a, b) => a.value <= b.value ? a : b,
  );
  if (worst.value >= 80) return null;
  return worst.key;
}

class _CategoryAccumulator {
  int usedIdr = 0;
  int wastedIdr = 0;
  final Set<String> usedItems = <String>{};
  final Set<String> wastedItems = <String>{};
}

DateTime? _latestWasteAt(List<StatsLogInput> logs) {
  DateTime? latest;
  for (final log in logs) {
    if (!log.isWaste) continue;
    if (latest == null || log.loggedAt.isAfter(latest)) {
      latest = log.loggedAt;
    }
  }
  return latest;
}

List<StatsTrendPoint> _monthPoints(
  List<DateTime> months, {
  required DateTime nextMonth,
}) {
  return <StatsTrendPoint>[
    for (var index = 0; index < months.length; index++)
      StatsTrendPoint(
        start: months[index],
        end: index + 1 < months.length ? months[index + 1] : nextMonth,
      ),
  ];
}

StatsTrend _fillTrend(
  StatsTrendGranularity granularity,
  List<StatsTrendPoint> points,
  List<StatsLogInput> logs,
) {
  final saved = List<int>.filled(points.length, 0);
  final wasted = List<int>.filled(points.length, 0);
  final savedLogs = List<int>.filled(points.length, 0);
  final wastedLogs = List<int>.filled(points.length, 0);

  for (final log in logs) {
    final index = points.indexWhere(
      (point) =>
          !log.loggedAt.isBefore(point.start) &&
          log.loggedAt.isBefore(point.end),
    );
    if (index < 0) continue;
    if (log.isWaste) {
      wasted[index] += log.valueIdr;
      wastedLogs[index] += 1;
    } else {
      saved[index] += log.valueIdr;
      savedLogs[index] += 1;
    }
  }

  return StatsTrend(
    granularity: granularity,
    points: <StatsTrendPoint>[
      for (var index = 0; index < points.length; index++)
        StatsTrendPoint(
          start: points[index].start,
          end: points[index].end,
          savedIdr: saved[index],
          wastedIdr: wasted[index],
          savedCount: savedLogs[index],
          wastedCount: wastedLogs[index],
        ),
    ],
  );
}
