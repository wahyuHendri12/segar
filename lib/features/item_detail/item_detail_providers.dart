import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/pantry_item_view.dart';
import '../../data/repositories/repository_providers.dart';

final itemDetailProvider = StreamProvider.autoDispose
    .family<PantryItemView?, String>((ref, id) {
      return ref.watch(pantryRepositoryProvider).watchItem(id);
    });
