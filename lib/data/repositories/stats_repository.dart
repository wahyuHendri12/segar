import '../../core/utils/stats_utils.dart';
import '../local/daos/pantry_dao.dart';
import '../local/daos/usage_log_dao.dart';
import '../local/database.dart';
import '../local/enums.dart';

/// Single gateway for the statistics screen.
///
/// Usage logs are aggregated in memory because a personal pantry produces a
/// small number of rows; keeping the aggregation pure also lets the streak
/// look at logs older than the selected period.
class StatsRepository {
  StatsRepository({
    required this.usageLogDao,
    required this.pantryDao,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final UsageLogDao usageLogDao;
  final PantryDao pantryDao;
  final DateTime Function() _clock;

  Stream<StatsReport> watchReport(StatsPeriod period) {
    return usageLogDao.watchAll().asyncMap((rows) async {
      final pantryTrackingSince = await pantryDao.earliestCreatedAt();
      return _build(rows, period, pantryTrackingSince);
    });
  }

  Future<StatsReport> getReport(StatsPeriod period) async {
    final rows = await usageLogDao.getAll();
    final pantryTrackingSince = await pantryDao.earliestCreatedAt();
    return _build(rows, period, pantryTrackingSince);
  }

  StatsReport _build(
    List<UsageLog> rows,
    StatsPeriod period,
    DateTime? pantryTrackingSince,
  ) {
    return buildStatsReport(
      logs: rows.map(_toInput).toList(growable: false),
      period: period,
      now: _clock(),
      pantryTrackingSince: pantryTrackingSince,
    );
  }

  StatsLogInput _toInput(UsageLog row) {
    return StatsLogInput(
      itemId: row.pantryItemId,
      action: row.action,
      valueIdr: row.valueIdr,
      isEstimate: row.isEstimate,
      weightGrams: row.weightGrams,
      category: row.category,
      reasonWasted: row.reasonWasted,
      loggedAt: row.loggedAt,
    );
  }
}
