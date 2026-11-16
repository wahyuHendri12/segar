import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/catalog_filter.dart';
import '../../data/models/ingredient_catalog_view.dart';
import '../../data/repositories/repository_providers.dart';

final catalogListProvider =
    StreamProvider.autoDispose<List<IngredientCatalogView>>(
      (ref) => ref.watch(catalogRepositoryProvider).watchAll(),
    );

class CatalogQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;

  void clear() => state = '';
}

final catalogQueryProvider = NotifierProvider<CatalogQueryNotifier, String>(
  CatalogQueryNotifier.new,
);

final catalogResultsProvider =
    Provider.autoDispose<AsyncValue<List<IngredientCatalogView>>>((ref) {
      final query = ref.watch(catalogQueryProvider);
      return ref
          .watch(catalogListProvider)
          .whenData((items) => filterCatalogItems(items, query));
    });

/// Eight popular ingredients shown as quick chips on the add form.
final popularCatalogProvider =
    Provider.autoDispose<AsyncValue<List<IngredientCatalogView>>>((ref) {
      return ref
          .watch(catalogListProvider)
          .whenData((items) => items.take(8).toList(growable: false));
    });
