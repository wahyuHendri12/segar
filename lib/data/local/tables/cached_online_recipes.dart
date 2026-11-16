import 'package:drift/drift.dart';

/// Cached TheMealDB detail responses, kept for 14 days.
@DataClassName('CachedOnlineRecipe')
class CachedOnlineRecipes extends Table {
  /// TheMealDB `idMeal`.
  TextColumn get idMeal => text()();

  /// Raw JSON returned by `/lookup.php`.
  TextColumn get json => text()();

  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{idMeal};
}
