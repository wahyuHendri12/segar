import 'package:drift/drift.dart';

import '../database.dart';
import '../enums.dart';
import '../tables/usage_logs.dart';

part 'usage_log_dao.g.dart';

@DriftAccessor(tables: [UsageLogs])
class UsageLogDao extends DatabaseAccessor<AppDatabase>
    with _$UsageLogDaoMixin {
  UsageLogDao(super.db);

  Stream<List<UsageLog>> watchAll({DateTime? from, DateTime? to}) {
    final statement = _filteredQuery(from: from, to: to)
      ..orderBy(<OrderClauseGenerator<$UsageLogsTable>>[
        (t) => OrderingTerm.desc(t.loggedAt),
      ]);
    return statement.watch();
  }

  Future<List<UsageLog>> getAll({DateTime? from, DateTime? to}) {
    final statement = _filteredQuery(from: from, to: to)
      ..orderBy(<OrderClauseGenerator<$UsageLogsTable>>[
        (t) => OrderingTerm.desc(t.loggedAt),
      ]);
    return statement.get();
  }

  Stream<List<UsageLog>> watchForItem(String pantryItemId) {
    return (select(usageLogs)
          ..where((t) => t.pantryItemId.equals(pantryItemId))
          ..orderBy(<OrderClauseGenerator<$UsageLogsTable>>[
            (t) => OrderingTerm.desc(t.loggedAt),
          ]))
        .watch();
  }

  Future<List<UsageLog>> getForItem(String pantryItemId) {
    return (select(usageLogs)
          ..where((t) => t.pantryItemId.equals(pantryItemId))
          ..orderBy(<OrderClauseGenerator<$UsageLogsTable>>[
            (t) => OrderingTerm.desc(t.loggedAt),
          ]))
        .get();
  }

  Future<void> insertLog(UsageLogsCompanion log) {
    return into(usageLogs).insert(log);
  }

  Future<int> deleteById(String id) {
    return (delete(usageLogs)..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteForItem(String pantryItemId) {
    return (delete(
      usageLogs,
    )..where((t) => t.pantryItemId.equals(pantryItemId))).go();
  }

  /// Most recent waste timestamp, used to compute the waste-free streak.
  Future<DateTime?> lastWastedAt() async {
    final row =
        await (select(usageLogs)
              ..where((t) => t.action.equalsValue(UsageAction.dibuang))
              ..orderBy(<OrderClauseGenerator<$UsageLogsTable>>[
                (t) => OrderingTerm.desc(t.loggedAt),
              ])
              ..limit(1))
            .getSingleOrNull();
    return row?.loggedAt;
  }

  /// Waste reasons ordered from most to least frequent.
  Future<List<({WasteReason reason, int count})>> wasteReasonCounts({
    DateTime? from,
    DateTime? to,
  }) async {
    final rows = await getAll(from: from, to: to);
    final counts = <WasteReason, int>{};
    for (final row in rows) {
      if (row.action != UsageAction.dibuang) continue;
      final reason = row.reasonWasted ?? WasteReason.lainnya;
      counts[reason] = (counts[reason] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries
        .map((entry) => (reason: entry.key, count: entry.value))
        .toList(growable: false);
  }

  SimpleSelectStatement<$UsageLogsTable, UsageLog> _filteredQuery({
    DateTime? from,
    DateTime? to,
  }) {
    final statement = select(usageLogs);
    if (from != null) {
      statement.where((t) => t.loggedAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      statement.where((t) => t.loggedAt.isSmallerOrEqualValue(to));
    }
    return statement;
  }
}
