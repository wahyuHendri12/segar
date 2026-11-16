import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../data/models/online_recipe.dart';
import '../../data/models/online_result.dart';
import '../../l10n/app_localizations.dart';
import 'online_recipe_providers.dart';

class OnlineRecipesScreen extends ConsumerStatefulWidget {
  const OnlineRecipesScreen({super.key});

  @override
  ConsumerState<OnlineRecipesScreen> createState() =>
      _OnlineRecipesScreenState();
}

class _OnlineRecipesScreenState extends ConsumerState<OnlineRecipesScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    ref.read(onlineRecipeSearchProvider.notifier).search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final state = ref.watch(onlineRecipeSearchProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onlineRecipesTitle)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: <Widget>[
            Text(
              l10n.onlineRecipesSubtitle,
              style: context.texts.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      labelText: l10n.onlineRecipesSearchLabel,
                      hintText: l10n.onlineRecipesSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: l10n.onlineRecipesSearchAction,
                    icon: Icons.travel_explore_rounded,
                    isLoading: state.isLoading,
                    expand: true,
                    onPressed: _search,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (state.isLoading)
              const LoadingSkeleton(items: 3)
            else if (state.result == null)
              EmptyState(
                icon: Icons.travel_explore_rounded,
                title: l10n.onlineRecipesIdleTitle,
                message: l10n.onlineRecipesIdleBody,
              )
            else
              _buildResult(context, l10n, state.result!),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(
    BuildContext context,
    AppLocalizations l10n,
    OnlineResult<List<OnlineRecipe>> result,
  ) {
    if (!result.isSuccess) {
      final (title, body, action) = switch (result.status) {
        OnlineFetchStatus.disabled => (
          l10n.onlineRecipesDisabledTitle,
          l10n.onlineRecipesDisabledBody,
          AppButton(
            label: l10n.onlineOpenSettings,
            variant: AppButtonVariant.outline,
            onPressed: () => context.go(Routes.settings),
          ),
        ),
        OnlineFetchStatus.offline => (
          l10n.onlineRecipesOfflineTitle,
          l10n.onlineRecipesOfflineBody,
          AppButton(
            label: l10n.genericRetry,
            variant: AppButtonVariant.outline,
            onPressed: _search,
          ),
        ),
        _ => (
          l10n.onlineRecipesErrorTitle,
          l10n.onlineRecipesErrorBody,
          AppButton(
            label: l10n.genericRetry,
            variant: AppButtonVariant.outline,
            onPressed: _search,
          ),
        ),
      };
      return EmptyState(
        icon: result.status == OnlineFetchStatus.offline
            ? Icons.wifi_off_rounded
            : Icons.cloud_off_rounded,
        title: title,
        message: body,
        action: action,
      );
    }

    final recipes = result.data ?? const <OnlineRecipe>[];
    if (recipes.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: l10n.onlineRecipesEmptyTitle,
        message: l10n.onlineRecipesEmptyBody,
      );
    }

    return Column(
      children: <Widget>[
        for (final recipe in recipes) ...<Widget>[
          _OnlineRecipeCard(
            recipe: recipe,
            onTap: () => context.push(Routes.onlineRecipe(recipe.id)),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _OnlineRecipeCard extends StatelessWidget {
  const _OnlineRecipeCard({required this.recipe, required this.onTap});

  final OnlineRecipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final meta = <String>[
      if (recipe.area != null) recipe.area!,
      if (recipe.category != null) recipe.category!,
      l10n.onlineRecipeIngredientCount(recipe.ingredients.length),
    ];

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(AppRadius.card),
            ),
            child: SizedBox(
              width: 104,
              height: 112,
              child: _RecipeThumbnail(recipe: recipe),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    meta.join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.onlineRecipeOpenAction,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.texts.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeThumbnail extends StatelessWidget {
  const _RecipeThumbnail({required this.recipe});

  final OnlineRecipe recipe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final imageUrl = recipe.imageUrl;
    if (imageUrl == null) {
      return ColoredBox(
        color: colors.primaryContainer,
        child: Center(child: Text('🍲', style: context.texts.headlineMedium)),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => ColoredBox(
        color: colors.surfaceContainerHigh,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => ColoredBox(
        color: colors.primaryContainer,
        child: Center(child: Text('🍲', style: context.texts.headlineMedium)),
      ),
    );
  }
}
