import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/online_recipe.dart';
import '../../data/models/online_result.dart';
import '../../l10n/app_localizations.dart';
import 'online_recipe_providers.dart';

class OnlineRecipeDetailScreen extends ConsumerWidget {
  const OnlineRecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncRecipe = ref.watch(onlineRecipeDetailProvider(recipeId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onlineRecipeDetailTitle)),
      body: asyncRecipe.when(
        loading: () => const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: LoadingSkeleton(items: 5),
          ),
        ),
        error: (error, stackTrace) => _Failure(
          status: OnlineFetchStatus.error,
          onRetry: () => ref.invalidate(onlineRecipeDetailProvider(recipeId)),
        ),
        data: (result) {
          final recipe = result.data;
          if (!result.isSuccess || recipe == null) {
            return _Failure(
              status: result.status,
              onRetry: () =>
                  ref.invalidate(onlineRecipeDetailProvider(recipeId)),
            );
          }
          return _RecipeBody(recipe: recipe, fromCache: result.fromCache);
        },
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.status, required this.onRetry});

  final OnlineFetchStatus status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, body) = switch (status) {
      OnlineFetchStatus.disabled => (
        l10n.onlineRecipesDisabledTitle,
        l10n.onlineRecipesDisabledBody,
      ),
      OnlineFetchStatus.offline => (
        l10n.onlineRecipesOfflineTitle,
        l10n.onlineRecipesOfflineBody,
      ),
      OnlineFetchStatus.notFound => (
        l10n.onlineRecipeNotFoundTitle,
        l10n.onlineRecipeNotFoundBody,
      ),
      _ => (l10n.onlineRecipesErrorTitle, l10n.onlineRecipesErrorBody),
    };

    return EmptyState(
      icon: status == OnlineFetchStatus.offline
          ? Icons.wifi_off_rounded
          : Icons.cloud_off_rounded,
      title: title,
      message: body,
      action: AppButton(
        label: l10n.genericRetry,
        variant: AppButtonVariant.outline,
        onPressed: onRetry,
      ),
    );
  }
}

class _RecipeBody extends StatelessWidget {
  const _RecipeBody({required this.recipe, required this.fromCache});

  final OnlineRecipe recipe;
  final bool fromCache;

  List<String> get _steps {
    final raw = recipe.instructions;
    if (raw == null) return const <String>[];
    return raw
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final steps = _steps;
    final meta = <String>[
      if (recipe.area != null) recipe.area!,
      if (recipe.category != null) recipe.category!,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: _HeroImage(recipe: recipe),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          recipe.title,
          style: context.texts.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (meta.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            meta.join(' · '),
            style: context.texts.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xxs,
          runSpacing: AppSpacing.xxs,
          children: <Widget>[
            _Badge(
              icon: Icons.restaurant_menu_rounded,
              label: l10n.onlineRecipeIngredientCount(
                recipe.ingredients.length,
              ),
            ),
            if (fromCache)
              _Badge(
                icon: Icons.cloud_off_rounded,
                label: l10n.barcodeCacheBadge,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.onlineRecipeIngredients),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          child: Column(
            children: <Widget>[
              for (var index = 0; index < recipe.ingredients.length; index++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: index == recipe.ingredients.length - 1
                        ? 0
                        : AppSpacing.xs,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                        color: colors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          recipe.ingredients[index].label,
                          style: context.texts.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.onlineRecipeSteps),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          child: steps.isEmpty
              ? Text(
                  l10n.onlineRecipeNoSteps,
                  style: context.texts.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                )
              : Column(
                  children: <Widget>[
                    for (var index = 0; index < steps.length; index++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: index == steps.length - 1 ? 0 : AppSpacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: context.texts.labelSmall?.copyWith(
                                  color: colors.onPrimaryContainer,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                steps[index],
                                style: context.texts.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.recipe});

  final OnlineRecipe recipe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final imageUrl = recipe.imageUrl;
    if (imageUrl == null) {
      return _fallback(context);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => ColoredBox(
        color: colors.surfaceContainerHigh,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.primaryContainer,
      child: Center(child: Text('🍲', style: context.texts.displayMedium)),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: colors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.texts.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
