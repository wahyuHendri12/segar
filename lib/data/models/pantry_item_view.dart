import '../../core/utils/expiry_utils.dart';
import '../../core/utils/value_utils.dart';
import '../local/database.dart';
import '../local/enums.dart';
import 'ingredient_catalog_view.dart';

/// Presentation-friendly view of one pantry row plus its catalog metadata.
class PantryItemView {
  const PantryItemView({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.storageLocation,
    required this.purchaseDate,
    required this.expiryDate,
    required this.expirySource,
    required this.notifyEnabled,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.expiryStatus,
    required this.daysLeft,
    this.catalogId,
    this.photoAsset,
    this.weightGrams,
    this.priceIdr,
    this.note,
    this.barcode,
    this.catalog,
  });

  final String id;
  final String? catalogId;
  final String name;
  final String emoji;
  final String? photoAsset;
  final IngredientCategory category;
  final double quantity;
  final Unit unit;
  final int? weightGrams;
  final StorageLocation storageLocation;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final ExpirySource expirySource;
  final int? priceIdr;
  final String? note;

  /// EAN/UPC digits remembered from a scan or manual lookup.
  final String? barcode;
  final bool notifyEnabled;
  final PantryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final IngredientCatalogView? catalog;

  /// Computed against "today" when the repository mapped the row.
  final ExpiryStatus expiryStatus;
  final int daysLeft;

  factory PantryItemView.fromRow(
    PantryItem row, {
    IngredientCatalogView? catalog,
    DateTime? now,
  }) {
    return PantryItemView(
      id: row.id,
      catalogId: row.catalogId,
      name: row.name,
      emoji: row.emoji,
      photoAsset: row.photoAsset,
      category: row.category,
      quantity: row.quantity,
      unit: row.unit,
      weightGrams: row.weightGrams,
      storageLocation: row.storageLocation,
      purchaseDate: row.purchaseDate,
      expiryDate: row.expiryDate,
      expirySource: row.expirySource,
      priceIdr: row.priceIdr,
      note: row.note,
      barcode: row.barcode,
      notifyEnabled: row.notifyEnabled,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      catalog: catalog,
      expiryStatus: statusFor(row.expiryDate, now: now),
      daysLeft: daysUntilExpiry(row.expiryDate, now: now),
    );
  }

  int? get estimatedWeightGrams => totalWeightGrams(
    weightGrams: weightGrams,
    quantity: quantity,
    avgWeightPerUnitGrams: catalog?.avgWeightPerUnitGrams,
  );

  int? get typicalPriceIdr => catalog?.typicalPriceIdr;

  /// Total shelf life in days, used by the countdown ring.
  int get shelfLifeDays {
    final total = dateOnly(expiryDate)
        .difference(dateOnly(purchaseDate))
        .inDays;
    return total <= 0 ? 1 : total;
  }

  /// 0..1 fraction of shelf life remaining.
  double get shelfLifeProgress {
    if (daysLeft <= 0) return 0;
    return (daysLeft / shelfLifeDays).clamp(0.0, 1.0);
  }

  bool get isExpired => expiryStatus == ExpiryStatus.sudahBasi;
  bool get isUrgent =>
      expiryStatus == ExpiryStatus.hampirBasi ||
      expiryStatus == ExpiryStatus.basiHariIni;
}

/// Input used by both the add and edit forms.
class NewPantryItemInput {
  const NewPantryItemInput({
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.storageLocation,
    required this.purchaseDate,
    required this.expiryDate,
    required this.expirySource,
    this.catalogId,
    this.emoji,
    this.weightGrams,
    this.priceIdr,
    this.note,
    this.barcode,
    this.notifyEnabled = true,
  });

  final String? catalogId;
  final String name;
  final String? emoji;
  final IngredientCategory category;
  final double quantity;
  final Unit unit;
  final int? weightGrams;
  final StorageLocation storageLocation;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final ExpirySource expirySource;
  final int? priceIdr;
  final String? note;

  /// Digits remembered from a barcode scan. Null keeps the existing value on
  /// update only when the form did not have one either.
  final String? barcode;
  final bool notifyEnabled;
}

/// Result of a mark-used / mark-wasted / partial-use action.
class PantryActionOutcome {
  const PantryActionOutcome({
    required this.usageLogId,
    required this.itemId,
    required this.action,
    required this.valueIdr,
    required this.isEstimate,
    required this.weightGrams,
  });

  final String usageLogId;
  final String itemId;
  final UsageAction action;
  final int valueIdr;
  final bool isEstimate;
  final int weightGrams;
}
