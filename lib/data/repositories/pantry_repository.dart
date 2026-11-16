import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../core/utils/barcode_utils.dart';
import '../../core/utils/expiry_utils.dart';
import '../../core/utils/value_utils.dart';
import '../local/daos/catalog_dao.dart';
import '../local/daos/pantry_dao.dart';
import '../local/database.dart';
import '../local/enums.dart';
import '../models/ingredient_catalog_view.dart';
import '../models/pantry_item_view.dart';

/// Single gateway for pantry reads and writes.
///
/// The presentation layer only sees [PantryItemView] and never imports Drift.
class PantryRepository {
  PantryRepository({
    required this.pantryDao,
    required this.catalogDao,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final PantryDao pantryDao;
  final CatalogDao catalogDao;
  final DateTime Function() _clock;

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  Stream<List<PantryItemView>> watchActive() {
    return pantryDao.watchActive().asyncMap(_mapRows);
  }

  Stream<PantryItemView?> watchItem(String id) {
    return pantryDao.watchById(id).asyncMap((row) async {
      if (row == null) return null;
      return _mapRow(row);
    });
  }

  Future<PantryItemView?> getItem(String id) async {
    final row = await pantryDao.findById(id);
    if (row == null) return null;
    return _mapRow(row);
  }

  Future<List<PantryItemView>> _mapRows(List<PantryItem> rows) async {
    if (rows.isEmpty) return const <PantryItemView>[];

    final catalogIds = rows
        .map((row) => row.catalogId)
        .whereType<String>()
        .toSet();
    final catalogRows = await catalogDao.getByIds(catalogIds);
    final catalogs = <String, IngredientCatalogView>{
      for (final row in catalogRows) row.id: IngredientCatalogView.fromRow(row),
    };
    final now = _clock();

    return rows
        .map(
          (row) => PantryItemView.fromRow(
            row,
            catalog: row.catalogId == null ? null : catalogs[row.catalogId],
            now: now,
          ),
        )
        .toList(growable: false);
  }

  Future<PantryItemView> _mapRow(PantryItem row) async {
    final catalog = row.catalogId == null
        ? null
        : await catalogDao.getById(row.catalogId!);
    return PantryItemView.fromRow(
      row,
      catalog: catalog == null ? null : IngredientCatalogView.fromRow(catalog),
      now: _clock(),
    );
  }

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  Future<String> addItem(NewPantryItemInput input) async {
    final catalog = input.catalogId == null
        ? null
        : await catalogDao.getById(input.catalogId!);
    final now = _clock();
    final id = _uuid.v4();

    await pantryDao.insertItem(
      PantryItemsCompanion.insert(
        id: id,
        catalogId: Value(input.catalogId),
        name: input.name.trim(),
        emoji: Value(input.emoji ?? catalog?.emoji ?? '🥗'),
        photoAsset: Value(catalog?.photoAsset),
        category: input.category,
        quantity: input.quantity,
        unit: input.unit,
        weightGrams: Value(_weightFor(input, catalog)),
        storageLocation: input.storageLocation,
        purchaseDate: dateOnly(input.purchaseDate),
        expiryDate: dateOnly(input.expiryDate),
        expirySource: input.expirySource,
        priceIdr: Value(input.priceIdr),
        note: Value(_normalizedNote(input.note)),
        barcode: Value(_normalizedBarcode(input.barcode)),
        notifyEnabled: Value(input.notifyEnabled),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return id;
  }

  Future<void> updateItem(String id, NewPantryItemInput input) async {
    final catalog = input.catalogId == null
        ? null
        : await catalogDao.getById(input.catalogId!);
    final now = _clock();

    await pantryDao.updateFields(
      id,
      PantryItemsCompanion(
        catalogId: Value(input.catalogId),
        name: Value(input.name.trim()),
        emoji: Value(input.emoji ?? catalog?.emoji ?? '🥗'),
        photoAsset: Value(catalog?.photoAsset),
        category: Value(input.category),
        quantity: Value(input.quantity),
        unit: Value(input.unit),
        weightGrams: Value(_weightFor(input, catalog)),
        storageLocation: Value(input.storageLocation),
        purchaseDate: Value(dateOnly(input.purchaseDate)),
        expiryDate: Value(dateOnly(input.expiryDate)),
        expirySource: Value(input.expirySource),
        priceIdr: Value(input.priceIdr),
        note: Value(_normalizedNote(input.note)),
        barcode: Value(_normalizedBarcode(input.barcode)),
        notifyEnabled: Value(input.notifyEnabled),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> deleteItem(String id) => pantryDao.softDelete(id);

  Future<void> restoreItem(String id) => pantryDao.restore(id);

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<PantryActionOutcome> markUsed(PantryItemView item) async {
    final row = await _requireRow(item.id);
    final catalog = await _catalogFor(row);
    final value = processedValue(
      priceIdr: row.priceIdr,
      typicalPriceIdr: catalog?.typicalPriceIdr,
      processedQuantity: row.quantity,
      initialQuantity: row.quantity,
    );
    final weight =
        processedWeightGrams(
          itemWeightGrams: row.weightGrams,
          processedQuantity: row.quantity,
          initialQuantity: row.quantity,
          avgWeightPerUnitGrams: catalog?.avgWeightPerUnitGrams,
        ) ??
        0;

    final logId = await pantryDao.markUsed(
      row,
      valueIdr: value.valueIdr,
      isEstimate: value.isEstimate,
      weightGrams: weight,
      at: _clock(),
    );

    return PantryActionOutcome(
      usageLogId: logId,
      itemId: row.id,
      action: UsageAction.dipakai,
      valueIdr: value.valueIdr,
      isEstimate: value.isEstimate,
      weightGrams: weight,
    );
  }

  Future<PantryActionOutcome> markWasted(
    PantryItemView item, {
    WasteReason? reason,
  }) async {
    final row = await _requireRow(item.id);
    final catalog = await _catalogFor(row);
    final value = processedValue(
      priceIdr: row.priceIdr,
      typicalPriceIdr: catalog?.typicalPriceIdr,
      processedQuantity: row.quantity,
      initialQuantity: row.quantity,
    );
    final weight =
        processedWeightGrams(
          itemWeightGrams: row.weightGrams,
          processedQuantity: row.quantity,
          initialQuantity: row.quantity,
          avgWeightPerUnitGrams: catalog?.avgWeightPerUnitGrams,
        ) ??
        0;

    final logId = await pantryDao.markWasted(
      row,
      valueIdr: value.valueIdr,
      isEstimate: value.isEstimate,
      weightGrams: weight,
      reason: reason,
      at: _clock(),
    );

    return PantryActionOutcome(
      usageLogId: logId,
      itemId: row.id,
      action: UsageAction.dibuang,
      valueIdr: value.valueIdr,
      isEstimate: value.isEstimate,
      weightGrams: weight,
    );
  }

  Future<PantryActionOutcome> markPartiallyUsed(
    PantryItemView item,
    double usedQuantity,
  ) async {
    if (usedQuantity <= 0 || usedQuantity > item.quantity) {
      throw ArgumentError.value(
        usedQuantity,
        'usedQuantity',
        'Harus lebih besar dari 0 dan tidak melebihi jumlah bahan',
      );
    }

    final row = await _requireRow(item.id);
    final catalog = await _catalogFor(row);
    final value = processedValue(
      priceIdr: row.priceIdr,
      typicalPriceIdr: catalog?.typicalPriceIdr,
      processedQuantity: usedQuantity,
      initialQuantity: row.quantity,
    );
    final weight =
        processedWeightGrams(
          itemWeightGrams: row.weightGrams,
          processedQuantity: usedQuantity,
          initialQuantity: row.quantity,
          avgWeightPerUnitGrams: catalog?.avgWeightPerUnitGrams,
        ) ??
        0;
    final becomesEmpty = usedQuantity >= row.quantity;

    final logId = await pantryDao.markPartiallyUsed(
      row,
      usedQuantity: usedQuantity,
      valueIdr: value.valueIdr,
      isEstimate: value.isEstimate,
      weightGrams: weight,
      at: _clock(),
    );

    return PantryActionOutcome(
      usageLogId: logId,
      itemId: row.id,
      action: becomesEmpty ? UsageAction.dipakai : UsageAction.dikurangi,
      valueIdr: value.valueIdr,
      isEstimate: value.isEstimate,
      weightGrams: weight,
    );
  }

  Future<void> undoUsage({required String usageLogId, required String itemId}) {
    return pantryDao.undoUsage(
      usageLogId: usageLogId,
      pantryItemId: itemId,
      at: _clock(),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  int? _weightFor(NewPantryItemInput input, IngredientCatalog? catalog) {
    return totalWeightGrams(
      weightGrams: input.weightGrams,
      quantity: input.quantity,
      avgWeightPerUnitGrams: catalog?.avgWeightPerUnitGrams,
    );
  }

  String? _normalizedNote(String? note) {
    final trimmed = note?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  String? _normalizedBarcode(String? barcode) {
    if (barcode == null) return null;
    final normalized = normalizeBarcode(barcode);
    return normalized.isEmpty ? null : normalized;
  }

  Future<PantryItem> _requireRow(String id) async {
    final row = await pantryDao.findById(id);
    if (row == null) {
      throw StateError('Bahan tidak ditemukan: $id');
    }
    return row;
  }

  Future<IngredientCatalogView?> _catalogFor(PantryItem row) async {
    if (row.catalogId == null) return null;
    final catalog = await catalogDao.getById(row.catalogId!);
    return catalog == null ? null : IngredientCatalogView.fromRow(catalog);
  }
}
