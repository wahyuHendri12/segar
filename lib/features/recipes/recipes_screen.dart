import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/utils/recipe_match.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../data/models/recipe_view.dart';
import '../../l10n/app_labels.dart';
import '../../l10n/app_localizations.dart';
import 'recipe_providers.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(recipeSuggestionsProvider);
    ref.invalidate(recipePantryProvider);
    await ref.read(recipeSuggestionsProvider.future);
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(recipeFilterProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final recipesAsync = ref.watch(recipeSuggestionsProvider);
    final pantryAsync = ref.watch(recipePantryProvider);
    final smartMatch = ref.watch(recipeSmartMatchProvider);
    final filter = ref.watch(recipeFilterProvider);
    final filtered = ref.watch(filteredRecipesProvider);

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: <Widget>[
              Text(
                l10n.recipesTitle,
                style: context.texts.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.recipesSubtitle,
                style: context.texts.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SmartMatchCard(match: smartMatch),
              const SizedBox(height: AppSpacing.sm),
              const _OnlineRecipeEntryCard(),
              const SizedBox(height: AppSpacing.lg),
              _SearchCard(
                controller: _searchController,
                query: filter.query,
                onChanged: ref.read(recipeFilterProvider.notifier).setQuery,
                onClear: () {
                  _searchController.clear();
                  ref.read(recipeFilterProvider.notifier).setQuery('');
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _FilterChips(
                recipes: recipesAsync.value ?? const <RecipeView>[],
                selectedTag: filter.tag,
                onSelected: ref.read(recipeFilterProvider.notifier).setTag,
              ),
              const SizedBox(height: AppSpacing.lg),
              recipesAsync.when(
                loading: () => const LoadingSkeleton(items: 3),
                error: (error, stackTrace) => EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: l10n.recipesLoadError,
                  message: l10n.actionFailed,
                  action: AppButton(
                    label: l10n.genericRetry,
                    variant: AppButtonVariant.outline,
                    onPressed: _refresh,
                  ),
                ),
                data: (recipes) {
                  if (pantryAsync.value?.isEmpty ?? false) {
                    return EmptyState(
                      icon: Icons.kitchen_outlined,
                      title: l10n.recipesNoPantryTitle,
                      message: l10n.recipesNoPantryBody,
                      action: AppButton(
                        label: l10n.recipesAddItemAction,
                        icon: Icons.add_rounded,
                        onPressed: () => context.push(Routes.addItem),
                      ),
                    );
                  }
                  if (recipes.isEmpty) {
                    return EmptyState(
                      icon: Icons.restaurant_menu_rounded,
                      title: l10n.recipesEmptyTitle,
                      message: l10n.recipesEmptyBody,
                    );
                  }
                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.search_off_rounded,
                      title: l10n.recipesSearchEmptyTitle,
                      message: l10n.recipesSearchEmptyBody,
                      action: AppButton(
                        label: l10n.homeClearFilters,
                        variant: AppButtonVariant.outline,
                        onPressed: _clearFilters,
                      ),
                    );
                  }
                  return Column(
                    children: <Widget>[
                      for (final recipe in filtered) ...<Widget>[
                        _RecipeCard(
                          recipe: recipe,
                          onTap: () => context.push(Routes.recipe(recipe.id)),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartMatchCard extends StatelessWidget {
  const _SmartMatchCard({required this.match});

  final RecipeSmartMatch match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.primaryContainer,
            Color.lerp(colors.primaryContainer, colors.surface, 0.35)!,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(context).scale(1);
          final stackBadge = textScale > 1.3;
          final badge = Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.sync_rounded, size: 13, color: segar.success),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    l10n.recipesSmartMatchAuto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.labelSmall?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
          final titleBlock = Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.recipesSmartMatchLabel,
                      style: context.texts.labelSmall?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      match.hasUrgent
                          ? l10n.recipesSmartMatchBody(
                              match.rescuedCount,
                              match.urgentTotal,
                            )
                          : l10n.recipesSmartMatchEmpty,
                      style: context.texts.bodyMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!stackBadge) ...<Widget>[
                const SizedBox(width: AppSpacing.xs),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.5,
                  ),
                  child: badge,
                ),
              ],
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (stackBadge) ...<Widget>[
                titleBlock,
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: badge,
                  ),
                ),
              ] else
                titleBlock,
              if (match.rescuedItems.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xxs,
                  runSpacing: AppSpacing.xxs,
                  children: <Widget>[
                    for (final item in match.rescuedItems)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.82),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              item.emoji.isEmpty ? '🥗' : item.emoji,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.texts.labelSmall?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _OnlineRecipeEntryCard extends ConsumerWidget {
  const _OnlineRecipeEntryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final enabled = ref.watch(onlineRecipeEnabledProvider);

    return AppCard(
      onTap: enabled ? () => context.push(Routes.onlineRecipes) : null,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: enabled
                ? colors.primaryContainer
                : colors.surfaceContainerHigh,
            child: Icon(
              enabled ? Icons.travel_explore_rounded : Icons.cloud_off_rounded,
              color: enabled
                  ? colors.onPrimaryContainer
                  : colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.onlineRecipeEntryTitle,
                  style: context.texts.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  enabled
                      ? l10n.onlineRecipeEntryBody
                      : l10n.onlineRecipeEntryDisabled,
                  style: context.texts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          if (enabled)
            Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant)
          else
            TextButton(
              onPressed: () => context.go(Routes.settings),
              child: Text(l10n.onlineOpenSettings),
            ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.travel_explore_rounded,
                size: 20,
                color: colors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.recipesSearchTitle,
                      style: context.texts.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l10n.recipesSearchBody,
                      style: context.texts.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.recipesSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              suffixIcon: query.trim().isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.genericCancel,
                      onPressed: onClear,
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.recipes,
    required this.selectedTag,
    required this.onSelected,
  });

  final List<RecipeView> recipes;
  final String? selectedTag;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = <({String? tag, String label})>[
      (tag: null, label: l10n.recipesFilterAll(recipes.length)),
      (tag: 'cepat', label: l10n.recipesFilterQuick),
      (tag: 'kos', label: l10n.recipesFilterKos),
      (tag: 'kuah', label: l10n.recipesFilterSoup),
      (tag: 'tumis', label: l10n.recipesFilterStirFry),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.xxs),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter.tag == selectedTag;
          return ChoiceChip(
            label: Text(filter.label),
            selected: selected,
            onSelected: (_) => onSelected(filter.tag),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe, required this.onTap});

  final RecipeView recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final urgentCount = recipe.urgentIngredients.length;
    final progress = recipe.requiredCount == 0
        ? 0.0
        : recipe.ownedRequiredCount / recipe.requiredCount;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _RecipeImage(recipe: recipe),
                Positioned(
                  top: AppSpacing.xs,
                  left: AppSpacing.xs,
                  child: _ImageBadge(
                    icon: recipe.isComplete
                        ? Icons.verified_rounded
                        : Icons.auto_awesome_rounded,
                    label: recipe.isComplete
                        ? l10n.recipesCompleteBadge
                        : l10n.recipesMatchPercent(recipe.matchScore.round()),
                  ),
                ),
                if (urgentCount > 0)
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: _ImageBadge(
                      icon: Icons.schedule_rounded,
                      label: l10n.recipesUrgentRescue(urgentCount),
                      background: segar.warningContainer,
                      foreground: segar.onWarningContainer,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  recipe.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xxs,
                  children: <Widget>[
                    _Meta(
                      icon: Icons.schedule_rounded,
                      label: l10n.recipeCookTimeValue(recipe.cookTimeMin),
                    ),
                    _Meta(
                      icon: Icons.local_fire_department_outlined,
                      label: l10n.difficultyLabel(recipe.difficulty),
                    ),
                    _Meta(
                      icon: Icons.people_alt_outlined,
                      label: l10n.recipeServingsValue(recipe.servings),
                    ),
                    _Meta(
                      icon: Icons.payments_outlined,
                      label: formatRupiah(recipe.estimatedCostIdr),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: colors.surfaceContainerHigh,
                    color: recipe.isComplete ? segar.success : colors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.recipesAvailableCount(
                          recipe.ownedRequiredCount,
                          recipe.requiredCount,
                        ),
                        style: context.texts.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (!recipe.isComplete && recipe.missingRequired.isNotEmpty)
                      Flexible(
                        child: Text(
                          l10n.recipesMissingCount(
                            recipe.missingRequired.length,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: context.texts.labelSmall?.copyWith(
                            color: segar.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.recipe});

  final RecipeView recipe;

  @override
  Widget build(BuildContext context) {
    final imageAsset = recipe.imageAsset;
    if (imageAsset != null) {
      return Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _emojiHero(context),
      );
    }
    return _emojiHero(context);
  }

  Widget _emojiHero(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.primary,
            Color.lerp(colors.primary, Colors.black, 0.35)!,
          ],
        ),
      ),
      child: Center(
        child: Text(
          recipe.emoji.isEmpty ? '🍲' : recipe.emoji,
          style: const TextStyle(fontSize: 64),
        ),
      ),
    );
  }
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({
    required this.icon,
    required this.label,
    this.background,
    this.foreground,
  });

  final IconData icon;
  final String label;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bg = background ?? colors.surface.withValues(alpha: 0.92);
    final fg = foreground ?? colors.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.texts.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: colors.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          label,
          style: context.texts.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
