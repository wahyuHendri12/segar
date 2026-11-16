import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_item/add_item_screen.dart';
import '../../features/backup/backup_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/item_detail/item_detail_screen.dart';
import '../../features/notifications/notifications_help_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/online_recipes/online_recipe_detail_screen.dart';
import '../../features/online_recipes/online_recipes_screen.dart';
import '../../features/recipes/recipe_detail_screen.dart';
import '../../features/recipes/recipes_screen.dart';
import '../../features/settings/about_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shopping_list/shopping_list_screen.dart';
import '../../features/stats/stats_screen.dart';
import '../providers/app_providers.dart';
import '../widgets/main_shell.dart';

class Routes {
  Routes._();

  static const onboarding = '/onboarding';
  static const home = '/home';
  static const recipes = '/recipes';
  static const stats = '/stats';
  static const settings = '/settings';
  static const addItem = '/add';
  static const itemDetail = '/item/:id';
  static const editItem = '/item/:id/edit';
  static const recipeDetail = '/recipe/:id';
  static const onlineRecipes = '/online-recipes';
  static const onlineRecipeDetail = '/online-recipes/:id';
  static const shoppingList = '/shopping-list';
  static const backup = '/backup';
  static const notificationsHelp = '/notifications-help';
  static const about = '/about';

  static String item(String id) => '/item/$id';
  static String edit(String id) => '/item/$id/edit';
  static String recipe(String id) => '/recipe/$id';
  static String onlineRecipe(String id) => '/online-recipes/$id';
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingDone = ref.watch(onboardingDoneProvider);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: onboardingDone ? Routes.home : Routes.onboarding,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == Routes.onboarding;
      if (!onboardingDone && !atOnboarding) return Routes.onboarding;
      if (onboardingDone && atOnboarding) return Routes.home;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.recipes,
                builder: (context, state) => const RecipesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.stats,
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.addItem,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddItemScreen(),
      ),
      GoRoute(
        path: Routes.itemDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return ItemDetailScreen(itemId: state.pathParameters['id'] ?? '');
        },
      ),
      GoRoute(
        path: Routes.editItem,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return AddItemScreen(itemId: state.pathParameters['id']);
        },
      ),
      GoRoute(
        path: Routes.recipeDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return RecipeDetailScreen(recipeId: state.pathParameters['id'] ?? '');
        },
      ),
      GoRoute(
        path: Routes.onlineRecipes,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OnlineRecipesScreen(),
      ),
      GoRoute(
        path: Routes.onlineRecipeDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return OnlineRecipeDetailScreen(
            recipeId: state.pathParameters['id'] ?? '',
          );
        },
      ),
      GoRoute(
        path: Routes.shoppingList,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ShoppingListScreen(),
      ),
      GoRoute(
        path: Routes.backup,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: Routes.notificationsHelp,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationsHelpScreen(),
      ),
      GoRoute(
        path: Routes.about,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
