import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/expiry_utils.dart';
import '../database.dart';
import '../enums.dart';
import '../tables/pantry_items.dart';
import '../tables/usage_logs.dart';

part 'pantry_dao.g.dart';

/// Aggregated counts shown on the home screen.
class PantryStatusCounts {
  const PantryStatusCounts({
    required this.soon,
    required this.safe,
    required this.expired,
  });

  final int soon;
  final int safe;
  final int expired;

  int get total => soon + safe + expired;
}

@DriftAccessor(tables: [PantryItems, UsageLogs])
class PantryDao extends DatabaseAccessor<AppDatabase> with _$PantryDaoMixin {
  PantryDao(super.db);

  static const _uuid = Uuid();

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  Stream<List<PantryItem>> watchActive({
    StorageLocation? location,
    String? query,
    PantrySort sort = PantrySort.expiryAsc,
  }) {
    final statement = select(pantryItems)
      ..where(
        (t) => t.status.equalsValue(PantryStatus.aktif) & t.deletedAt.isNull(),
      );

    if (location != null) {
      statement.where((t) => t.storageLocation.equalsValue(location));
    }

    final trimmed = query?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      final pattern = '%${trimmed.toLowerCase()}%';
      statement.where((t) => t.name.lower().like(pattern));
    }

    switch (sort) {
      case PantrySort.expiryAsc:
        statement.orderBy(<OrderClauseGenerator<$PantryItemsTable>>[
          (t) => OrderingTerm.asc(t.expiryDate),
          (t) => OrderingTerm.asc(t.name),
        ]);
      case PantrySort.nameAsc:
        statement.orderBy(<OrderClauseGenerator<$PantryItemsTable>>[
          (t) => OrderingTerm.asc(t.name),
        ]);
      case PantrySort.newest:
        statement.orderBy(<OrderClauseGenerator<$PantryItemsTable>>[
          (t) => OrderingTerm.desc(t.createdAt),
        ]);
    }

    return statement.watch();
  }

  /// Every row, including soft-deleted items. Used by local backups.
  Future<List<PantryItem>> getAll() {
    return (select(pantryItems)
          ..orderBy(<OrderClauseGenerator<$PantryItemsTable>>[
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
  }

  Future<List<PantryItem>> getActive() {
    return (select(pantryItems)
          ..where(
            (t) =>
                t.status.equalsValue(PantryStatus.aktif) & t.deletedAt.isNull(),
          )
          ..orderBy(<OrderClauseGenerator<$PantryItemsTable>>[
            (t) => OrderingTerm.asc(t.expiryDate),
          ]))
        .get();
  }

  Future<PantryItem?> findById(String id) {
    return (select(
      pantryItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// First time the user added anything, used as a fallback for streaks when
  /// there are no usage logs yet.
  Future<DateTime?> earliestCreatedAt() async {
    final row =
        await (select(pantryItems)
              ..orderBy(<OrderClauseGenerator<$PantryItemsTable>>[
                (t) => OrderingTerm.asc(t.createdAt),
              ])
              ..limit(1))
            .getSingleOrNull();
    return row?.createdAt;
  }

  Future<PantryItem?> findActiveById(String id) {
    return (select(pantryItems)..where(
          (t) =>
              t.id.equals(id) &
              t.status.equalsValue(PantryStatus.aktif) &
              t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  /// Live single-row stream used by the detail screen.
  Stream<PantryItem?> watchById(String id) {
    return (select(
      pantryItems,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Stream<PantryStatusCounts> watchStatusCounts({
    DateTime? now,
    int warnDays = 3,
  }) {
    return watchActive().map(
      (items) => _countStatuses(items, now: now, warnDays: warnDays),
    );
  }

  PantryStatusCounts _countStatuses(
    List<PantryItem> items, {
    DateTime? now,
    int warnDays = 3,
  }) {
    var soon = 0;
    var safe = 0;
    var expired = 0;

    for (final item in items) {
      switch (statusFor(item.expiryDate, now: now, warnDays: warnDays)) {
        case ExpiryStatus.aman:
          safe++;
        case ExpiryStatus.hampirBasi:
        case ExpiryStatus.basiHariIni:
          soon++;
        case ExpiryStatus.sudahBasi:
          expired++;
      }
    }

    return PantryStatusCounts(soon: soon, safe: safe, expired: expired);
  }

  /// Active items that are almost expired, used by the recipe matcher.
  Stream<List<PantryItem>> watchUrgent({DateTime? now, int warnDays = 3}) {
    return watchActive().map((items) {
      final urgent = items.where(
        (item) =>
            statusFor(item.expiryDate, now: now, warnDays: warnDays) !=
            ExpiryStatus.aman,
      );
      return urgent.toList(growable: false);
    });
  }

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  Future<void> insertItem(PantryItemsCompanion item) {
    return into(pantryItems).insert(item);
  }

  Future<bool> replaceItem(PantryItem item) {
    return update(pantryItems).replace(item);
  }

  Future<void> updateFields(String id, PantryItemsCompanion changes) {
    return (update(pantryItems)..where((t) => t.id.equals(id))).write(changes);
  }

  Future<void> softDelete(String id, {DateTime? at}) {
    final now = at ?? DateTime.now();
    return updateFields(
      id,
      PantryItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> restore(String id, {DateTime? at}) {
    final now = at ?? DateTime.now();
    return updateFields(
      id,
      PantryItemsCompanion(deletedAt: const Value(null), updatedAt: Value(now)),
    );
  }

  Future<void> extendExpiry(String id, DateTime newExpiry, {DateTime? at}) {
    final now = at ?? DateTime.now();
    return updateFields(
      id,
      PantryItemsCompanion(
        expiryDate: Value(newExpiry),
        expirySource: const Value(ExpirySource.manual),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> moveLocation(
    String id,
    StorageLocation location, {
    DateTime? newExpiry,
    DateTime? at,
  }) {
    final now = at ?? DateTime.now();
    return updateFields(
      id,
      PantryItemsCompanion(
        storageLocation: Value(location),
        expiryDate: newExpiry == null ? const Value.absent() : Value(newExpiry),
        updatedAt: Value(now),
      ),
    );
  }

  /// Marks the whole item as used and records a usage log in one transaction.
  Future<String> markUsed(
    PantryItem item, {
    required int valueIdr,
    required bool isEstimate,
    required int weightGrams,
    DateTime? at,
  }) {
    return _recordConsumption(
      item,
      action: UsageAction.dipakai,
      quantityChanged: item.quantity,
      newStatus: PantryStatus.terpakai,
      valueIdr: valueIdr,
      isEstimate: isEstimate,
      weightGrams: weightGrams,
      at: at,
    );
  }

  /// Marks the whole item as wasted and records a usage log in one transaction.
  Future<String> markWasted(
    PantryItem item, {
    required int valueIdr,
    required bool isEstimate,
    required int weightGrams,
    WasteReason? reason,
    DateTime? at,
  }) {
    return _recordConsumption(
      item,
      action: UsageAction.dibuang,
      quantityChanged: item.quantity,
      newStatus: PantryStatus.terbuang,
      valueIdr: valueIdr,
      isEstimate: isEstimate,
      weightGrams: weightGrams,
      reason: reason,
      at: at,
    );
  }

  /// Reduces the quantity. If nothing remains the item becomes `terpakai`.
  Future<String> markPartiallyUsed(
    PantryItem item, {
    required double usedQuantity,
    required int valueIdr,
    required bool isEstimate,
    required int weightGrams,
    DateTime? at,
  }) {
    if (usedQuantity <= 0) {
      throw ArgumentError.value(
        usedQuantity,
        'usedQuantity',
        'Harus lebih besar dari 0',
      );
    }

    final now = at ?? DateTime.now();
    final remaining = item.quantity - usedQuantity;
    final becomesEmpty = remaining <= 0;

    return transaction(() async {
      final logId = _uuid.v4();

      if (becomesEmpty) {
        await (update(pantryItems)..where((t) => t.id.equals(item.id))).write(
          PantryItemsCompanion(
            quantity: const Value(0),
            status: const Value(PantryStatus.terpakai),
            statusChangedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      } else {
        final updatedWeight = item.weightGrams == null
            ? const Value<int?>(null)
            : Value<int?>(
                (item.weightGrams! * (remaining / item.quantity)).round(),
              );

        await (update(pantryItems)..where((t) => t.id.equals(item.id))).write(
          PantryItemsCompanion(
            quantity: Value(remaining),
            weightGrams: updatedWeight,
            updatedAt: Value(now),
          ),
        );
      }

      await into(usageLogs).insert(
        UsageLogsCompanion.insert(
          id: logId,
          pantryItemId: item.id,
          action: becomesEmpty ? UsageAction.dipakai : UsageAction.dikurangi,
          quantityChanged: becomesEmpty ? item.quantity : usedQuantity,
          valueIdr: Value(valueIdr),
          isEstimate: Value(isEstimate),
          weightGrams: Value(weightGrams),
          category: item.category,
          loggedAt: now,
        ),
      );

      return logId;
    });
  }

  /// Restores the item and removes the log created by the action being undone.
  ///
  /// Partial usage also restores the quantity (and the proportional weight) so
  /// the undo action truly returns the item to its previous state.
  Future<void> undoUsage({
    required String usageLogId,
    required String pantryItemId,
    DateTime? at,
  }) {
    final now = at ?? DateTime.now();
    return transaction(() async {
      final log = await (select(
        usageLogs,
      )..where((t) => t.id.equals(usageLogId))).getSingleOrNull();
      final item = await (select(
        pantryItems,
      )..where((t) => t.id.equals(pantryItemId))).getSingleOrNull();

      var quantity = item?.quantity;
      var weightGrams = item?.weightGrams;

      if (log != null && item != null) {
        final restorePartial = log.action == UsageAction.dikurangi;
        final restoreFinishedPartial =
            log.action == UsageAction.dipakai && item.quantity <= 0;

        if (restorePartial || restoreFinishedPartial) {
          quantity = item.quantity + log.quantityChanged;
        }
        if (restorePartial && item.weightGrams != null) {
          weightGrams = item.weightGrams! + log.weightGrams;
        }
      }

      await (delete(usageLogs)..where((t) => t.id.equals(usageLogId))).go();
      await (update(
        pantryItems,
      )..where((t) => t.id.equals(pantryItemId))).write(
        PantryItemsCompanion(
          status: const Value(PantryStatus.aktif),
          statusChangedAt: const Value(null),
          quantity: quantity == null ? const Value.absent() : Value(quantity),
          weightGrams: weightGrams == null
              ? const Value.absent()
              : Value<int?>(weightGrams),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<String> _recordConsumption(
    PantryItem item, {
    required UsageAction action,
    required double quantityChanged,
    required PantryStatus newStatus,
    required int valueIdr,
    required bool isEstimate,
    required int weightGrams,
    WasteReason? reason,
    DateTime? at,
  }) {
    final now = at ?? DateTime.now();

    return transaction(() async {
      final logId = _uuid.v4();

      await (update(pantryItems)..where((t) => t.id.equals(item.id))).write(
        PantryItemsCompanion(
          status: Value(newStatus),
          statusChangedAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await into(usageLogs).insert(
        UsageLogsCompanion.insert(
          id: logId,
          pantryItemId: item.id,
          action: action,
          quantityChanged: quantityChanged,
          valueIdr: Value(valueIdr),
          isEstimate: Value(isEstimate),
          weightGrams: Value(weightGrams),
          category: item.category,
          reasonWasted: Value(reason),
          loggedAt: now,
        ),
      );

      return logId;
    });
  }
}
