import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/utils/format_utils.dart';
import '../../core/utils/pantry_filter.dart';
import '../../data/local/enums.dart';
import '../../data/models/pantry_item_view.dart';
import '../../data/repositories/repository_providers.dart';

/// All active items. The list is small enough to filter and group locally,
/// which also keeps the location chip counts in sync with one subscription.
final allPantryItemsProvider = StreamProvider.autoDispose<List<PantryItemView>>(
  (ref) => ref.watch(pantryRepositoryProvider).watchActive(),
);

class PantryFilterNotifier extends Notifier<PantryFilterState> {
  @override
  PantryFilterState build() => const PantryFilterState();

  void setLocation(StorageLocation? location) {
    state = state.copyWith(location: location, clearLocation: location == null);
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setSort(PantrySort sort) {
    state = state.copyWith(sort: sort);
  }

  void clear() {
    state = const PantryFilterState();
  }
}

final pantryFilterProvider =
    NotifierProvider<PantryFilterNotifier, PantryFilterState>(
      PantryFilterNotifier.new,
    );

final pantryListProvider =
    Provider.autoDispose<AsyncValue<List<PantryItemView>>>((ref) {
      final filter = ref.watch(pantryFilterProvider);
      return ref
          .watch(allPantryItemsProvider)
          .whenData((items) => filterPantryItems(items, filter));
    });

final pantrySummaryProvider = Provider.autoDispose<AsyncValue<PantrySummary>>((
  ref,
) {
  return ref.watch(allPantryItemsProvider).whenData(summarizePantry);
});

final pantryGroupsProvider = Provider.autoDispose<AsyncValue<PantryGroups>>((
  ref,
) {
  return ref.watch(pantryListProvider).whenData(groupPantryItems);
});

/// Once-per-day dismissal for the morning reminder banner.
class HomeReminderDismissedNotifier extends Notifier<bool> {
  @override
  bool build() {
    final stored = ref
        .watch(sharedPreferencesProvider)
        .getString(PrefKeys.morningBannerDismissedDate);
    return stored == dateKey(DateTime.now());
  }

  Future<void> dismiss() async {
    state = true;
    await ref
        .read(sharedPreferencesProvider)
        .setString(
          PrefKeys.morningBannerDismissedDate,
          dateKey(DateTime.now()),
        );
  }
}

final homeReminderDismissedProvider =
    NotifierProvider<HomeReminderDismissedNotifier, bool>(
      HomeReminderDismissedNotifier.new,
    );
