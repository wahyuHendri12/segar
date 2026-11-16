import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/connectivity_checker.dart';
import '../../core/providers/app_providers.dart';
import '../backup/backup_file_service.dart';
import '../backup/backup_repository.dart';
import '../local/database_provider.dart';
import '../remote/open_food_facts_service.dart';
import '../remote/the_meal_db_service.dart';
import 'barcode_repository.dart';
import 'catalog_repository.dart';
import 'online_recipe_repository.dart';
import 'pantry_repository.dart';
import 'recipe_repository.dart';
import 'shopping_list_repository.dart';
import 'stats_repository.dart';

final pantryRepositoryProvider = Provider<PantryRepository>((ref) {
  return PantryRepository(
    pantryDao: ref.watch(pantryDaoProvider),
    catalogDao: ref.watch(catalogDaoProvider),
  );
});

final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  return ShoppingListRepository(dao: ref.watch(shoppingListDaoProvider));
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(catalogDao: ref.watch(catalogDaoProvider));
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(
    recipeDao: ref.watch(recipeDaoProvider),
    pantryRepository: ref.watch(pantryRepositoryProvider),
  );
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(
    usageLogDao: ref.watch(usageLogDaoProvider),
    pantryDao: ref.watch(pantryDaoProvider),
  );
});

// -----------------------------------------------------------------------------
// Optional online features
// -----------------------------------------------------------------------------

final connectivityCheckerProvider = Provider<ConnectivityChecker>((ref) {
  return ConnectivityPlusChecker();
});

final barcodeRemoteSourceProvider = Provider<BarcodeRemoteSource>((ref) {
  return OpenFoodFactsSource();
});

final recipeRemoteSourceProvider = Provider<RecipeRemoteSource>((ref) {
  return TheMealDbSource();
});

final barcodeRepositoryProvider = Provider<BarcodeRepository>((ref) {
  return BarcodeRepository(
    dao: ref.watch(barcodeCacheDaoProvider),
    remote: ref.watch(barcodeRemoteSourceProvider),
    connectivity: ref.watch(connectivityCheckerProvider),
    isEnabled: () => ref.read(onlineBarcodeEnabledProvider),
  );
});

final onlineRecipeRepositoryProvider = Provider<OnlineRecipeRepository>((ref) {
  return OnlineRecipeRepository(
    dao: ref.watch(onlineRecipeDaoProvider),
    remote: ref.watch(recipeRemoteSourceProvider),
    connectivity: ref.watch(connectivityCheckerProvider),
    isEnabled: () => ref.read(onlineRecipeEnabledProvider),
  );
});

// -----------------------------------------------------------------------------
// Local backup
// -----------------------------------------------------------------------------

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(
    database: ref.watch(databaseProvider),
    preferences: ref.watch(sharedPreferencesProvider),
  );
});

final backupFileServiceProvider = Provider<BackupFileService>((ref) {
  return PlatformBackupFileService();
});
