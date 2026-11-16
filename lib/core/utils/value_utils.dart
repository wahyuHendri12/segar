/// Value of the quantity that was processed (used or wasted).
///
/// Uses the user-entered price first, then the catalog's typical price. The
/// returned `isEstimate` flag is true only when the catalog price was used.
({int valueIdr, bool isEstimate}) processedValue({
  int? priceIdr,
  int? typicalPriceIdr,
  required double processedQuantity,
  required double initialQuantity,
}) {
  if (initialQuantity <= 0 || processedQuantity <= 0) {
    return (valueIdr: 0, isEstimate: false);
  }

  final ratio = (processedQuantity / initialQuantity).clamp(0.0, 1.0);
  final hasManualPrice = priceIdr != null && priceIdr > 0;
  final basePrice = hasManualPrice ? priceIdr : typicalPriceIdr;

  if (basePrice == null || basePrice <= 0) {
    return (valueIdr: 0, isEstimate: false);
  }

  return (valueIdr: (basePrice * ratio).round(), isEstimate: !hasManualPrice);
}

/// Total weight in grams.
///
/// Prefers the explicit total weight, otherwise quantity × average weight per
/// unit. Returns null when neither source is available.
int? totalWeightGrams({
  int? weightGrams,
  required double quantity,
  double? avgWeightPerUnitGrams,
}) {
  if (weightGrams != null && weightGrams > 0) return weightGrams;
  if (avgWeightPerUnitGrams == null || avgWeightPerUnitGrams <= 0) return null;
  if (quantity <= 0) return 0;
  return (quantity * avgWeightPerUnitGrams).round();
}

/// Weight of a processed quantity, proportional to the item's total weight.
int? processedWeightGrams({
  int? itemWeightGrams,
  required double processedQuantity,
  required double initialQuantity,
  double? avgWeightPerUnitGrams,
}) {
  if (initialQuantity <= 0 || processedQuantity <= 0) return 0;

  final ratio = (processedQuantity / initialQuantity).clamp(0.0, 1.0);
  if (itemWeightGrams != null && itemWeightGrams > 0) {
    return (itemWeightGrams * ratio).round();
  }
  if (avgWeightPerUnitGrams != null && avgWeightPerUnitGrams > 0) {
    return (processedQuantity * avgWeightPerUnitGrams).round();
  }
  return null;
}
