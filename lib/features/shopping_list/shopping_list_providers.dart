import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/shopping_list_entry.dart';
import '../../data/repositories/repository_providers.dart';

final shoppingListProvider =
    StreamProvider.autoDispose<List<ShoppingListEntry>>((ref) {
      return ref.watch(shoppingListRepositoryProvider).watchAll();
    });
