import '../local/database.dart';
import '../local/enums.dart';

/// Presentation model for one shopping list row.
class ShoppingListEntry {
  const ShoppingListEntry({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.isChecked,
    required this.source,
    required this.sortOrder,
    required this.createdAt,
  });

  final String id;
  final String name;
  final double quantity;
  final Unit unit;
  final bool isChecked;
  final ShoppingSource source;
  final int sortOrder;
  final DateTime createdAt;

  factory ShoppingListEntry.fromRow(ShoppingListItem row) {
    return ShoppingListEntry(
      id: row.id,
      name: row.name,
      quantity: row.quantity,
      unit: row.unit,
      isChecked: row.isChecked,
      source: row.source,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
    );
  }
}

/// Values needed to add an item without exposing Drift companions to the UI.
class ShoppingListDraft {
  const ShoppingListDraft({
    required this.name,
    this.quantity = 1,
    this.unit = Unit.pcs,
    this.source = ShoppingSource.manual,
  });

  final String name;
  final double quantity;
  final Unit unit;
  final ShoppingSource source;
}
