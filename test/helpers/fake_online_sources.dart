import 'package:segar/core/network/connectivity_checker.dart';
import 'package:segar/data/models/barcode_lookup.dart';
import 'package:segar/data/models/online_recipe.dart';
import 'package:segar/data/remote/open_food_facts_service.dart';
import 'package:segar/data/remote/the_meal_db_service.dart';

class FakeBarcodeRemoteSource implements BarcodeRemoteSource {
  FakeBarcodeRemoteSource({this.result, this.error});

  BarcodeLookup? result;
  Object? error;
  int calls = 0;

  @override
  Future<BarcodeLookup?> fetch(String barcode) async {
    calls++;
    if (error != null) throw error!;
    return result;
  }
}

class FakeRecipeRemoteSource implements RecipeRemoteSource {
  FakeRecipeRemoteSource({
    this.searchResults = const <OnlineRecipe>[],
    this.details = const <String, OnlineRecipe>{},
    this.error,
  });

  List<OnlineRecipe> searchResults;
  Map<String, OnlineRecipe> details;
  Object? error;
  int searchCalls = 0;
  int lookupCalls = 0;

  @override
  Future<List<OnlineRecipe>> search(String query) async {
    searchCalls++;
    if (error != null) throw error!;
    return searchResults;
  }

  @override
  Future<OnlineRecipe?> lookup(String id) async {
    lookupCalls++;
    if (error != null) throw error!;
    return details[id];
  }
}

class FakeConnectivityChecker implements ConnectivityChecker {
  FakeConnectivityChecker({this.online = true});

  bool online;

  @override
  Future<bool> get isOnline async => online;
}

OnlineRecipe sampleOnlineRecipe({
  String id = '52772',
  String title = 'Nasi Goreng Spesial',
}) {
  return OnlineRecipe(
    id: id,
    title: title,
    area: 'Indonesian',
    category: 'Chicken',
    instructions:
        'Panaskan minyak.\r\nTumis bumbu sampai harum.\r\n'
        'Masukkan nasi dan aduk rata.',
    ingredients: const <OnlineRecipeIngredient>[
      OnlineRecipeIngredient(name: 'Rice', measure: '2 cups'),
      OnlineRecipeIngredient(name: 'Chicken', measure: '200g'),
      OnlineRecipeIngredient(name: 'Garlic', measure: '2 cloves'),
    ],
  );
}
