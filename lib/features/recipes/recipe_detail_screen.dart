import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/section_header.dart';
import '../../data/local/enums.dart';
import '../../data/models/recipe_view.dart';
import '../../data/models/shopping_list_entry.dart';
import '../../data/repositories/repository_providers.dart';
import '../../l10n/app_labels.dart';
import '../../l10n/app_localizations.dart';
import 'recipe_providers.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  int? _servings;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncRecipe = ref.watch(recipeDetailProvider(widget.recipeId));
    final recipe = asyncRecipe.value;
    final servings = _servings ?? recipe?.servings ?? 2;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recipeDetailTitle)),
      body: SafeArea(
        bottom: false,
        child: asyncRecipe.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: LoadingSkeleton(items: 5),
          ),
          error: (error, stackTrace) => EmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.recipeDetailLoadError,
            message: l10n.actionFailed,
            action: AppButton(
              label: l10n.genericRetry,
              variant: AppButtonVariant.outline,
              onPressed: () =>
                  ref.invalidate(recipeDetailProvider(widget.recipeId)),
            ),
          ),
          data: (recipe) {
            if (recipe == null) {
              return EmptyState(
                icon: Icons.search_off_rounded,
                title: l10n.recipeDetailNotFoundTitle,
                message: l10n.recipeDetailNotFoundBody,
              );
            }
            return _buildContent(context, l10n, recipe, servings);
          },
        ),
      ),
      bottomNavigationBar: recipe == null
          ? null
          : _CookBar(
              recipe: recipe,
              busy: _busy,
              onCook: recipe.matchedIngredients.isEmpty
                  ? null
                  : () => _openCookSheet(recipe, servings),
            ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    RecipeView recipe,
    int servings,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: <Widget>[
        _RecipeHero(recipe: recipe),
        const SizedBox(height: AppSpacing.md),
        _MetaCard(recipe: recipe),
        const SizedBox(height: AppSpacing.lg),
        _ServingsCard(
          servings: servings,
          baseServings: recipe.servings,
          onDecrease: servings <= 1
              ? null
              : () => setState(() => _servings = servings - 1),
          onIncrease: servings >= 12
              ? null
              : () => setState(() => _servings = servings + 1),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(
          title: l10n.recipeDetailIngredientsTitle,
          subtitle: l10n.recipeDetailIngredientsCount(
            recipe.ownedRequiredCount,
            recipe.requiredCount,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            children: <Widget>[
              for (
                var index = 0;
                index < recipe.ingredients.length;
                index++
              ) ...<Widget>[
                _IngredientRow(
                  ingredient: recipe.ingredients[index],
                  servings: servings,
                  baseServings: recipe.servings,
                ),
                if (index != recipe.ingredients.length - 1)
                  const Divider(height: AppSpacing.md),
              ],
            ],
          ),
        ),
        if (recipe.missingRequired.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          _MissingNote(
            count: recipe.missingRequired.length,
            title: l10n.recipeDetailMissingTitle,
            body: l10n.recipeDetailMissingBody(recipe.missingRequired.length),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.shoppingListAddFromRecipe,
            icon: Icons.add_shopping_cart_rounded,
            variant: AppButtonVariant.outline,
            expand: true,
            onPressed: () => _addMissingToShoppingList(recipe, servings),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.recipeDetailStepsTitle),
        const SizedBox(height: AppSpacing.sm),
        for (var index = 0; index < recipe.steps.length; index++) ...<Widget>[
          _StepCard(index: index + 1, text: recipe.steps[index]),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }

  Future<void> _addMissingToShoppingList(
    RecipeView recipe,
    int servings,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(shoppingListRepositoryProvider);

    final drafts = recipe.missingRequired
        .map(
          (ingredient) => ShoppingListDraft(
            name: ingredient.name,
            quantity: ingredient.scaledAmount(servings, recipe.servings),
            unit: ingredient.unit,
            source: ShoppingSource.dariResep,
          ),
        )
        .toList(growable: false);

    final added = await repository.addDrafts(drafts);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          added == 0
              ? l10n.shoppingListNoNewItems
              : l10n.shoppingListAddedFromRecipe(added),
        ),
      ),
    );
  }

  Future<void> _openCookSheet(RecipeView recipe, int servings) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(recipeRepositoryProvider);

    final selected = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _CookSheet(recipe: recipe, servings: servings),
    );
    if (selected == null || selected.isEmpty || !mounted) return;

    setState(() => _busy = true);
    try {
      final outcomes = await repository.cook(
        recipe: recipe,
        servings: servings,
        ingredientIds: selected,
      );
      if (!mounted) return;
      setState(() => _busy = false);

      if (outcomes.isEmpty) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.recipeDetailCookNothing)),
        );
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.recipeDetailCookSuccess),
          action: SnackBarAction(
            label: l10n.actionUndo,
            onPressed: () {
              for (final outcome in outcomes) {
                repository.undoUsage(
                  usageLogId: outcome.usageLogId,
                  itemId: outcome.itemId,
                );
              }
            },
          ),
        ),
      );
    } on Object {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
    }
  }
}

class _CookBar extends StatelessWidget {
  const _CookBar({
    required this.recipe,
    required this.busy,
    required this.onCook,
  });

  final RecipeView recipe;
  final bool busy;
  final VoidCallback? onCook;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: context.segarColors.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (busy) ...<Widget>[
                const LinearProgressIndicator(minHeight: 3),
                const SizedBox(height: AppSpacing.xs),
              ],
              AppButton(
                label: recipe.isComplete
                    ? l10n.recipeDetailCook
                    : l10n.recipeDetailCookPartial,
                icon: Icons.restaurant_rounded,
                expand: true,
                isLoading: busy,
                onPressed: onCook,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeHero extends StatelessWidget {
  const _RecipeHero({required this.recipe});

  final RecipeView recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sheet),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _HeroImage(recipe: recipe),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0x00000000), Color(0xCC000000)],
                  stops: <double>[0.45, 1],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          l10n.recipeDetailMatchLabel(
                            recipe.matchScore.round(),
                          ),
                          style: context.texts.labelSmall?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.headlineSmall?.copyWith(
                      color: const Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xxs,
                    children: <Widget>[
                      _HeroMeta(
                        icon: Icons.schedule_rounded,
                        label: l10n.recipeCookTimeValue(recipe.cookTimeMin),
                      ),
                      _HeroMeta(
                        icon: Icons.local_fire_department_outlined,
                        label: l10n.difficultyLabel(recipe.difficulty),
                      ),
                      _HeroMeta(
                        icon: Icons.people_alt_outlined,
                        label: l10n.recipeServingsValue(recipe.servings),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.recipe});

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
            Color.lerp(colors.primary, Colors.black, 0.45)!,
          ],
        ),
      ),
      child: Center(
        child: Text(
          recipe.emoji.isEmpty ? '🍲' : recipe.emoji,
          style: const TextStyle(fontSize: 84),
        ),
      ),
    );
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: const Color(0xFFFFFFFF)),
        const SizedBox(width: 3),
        Text(
          label,
          style: context.texts.labelSmall?.copyWith(
            color: const Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.recipe});

  final RecipeView recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final items = <({IconData icon, String label, String value, Color color})>[
      (
        icon: Icons.schedule_rounded,
        label: l10n.recipeDetailTimeLabel,
        value: l10n.recipeCookTimeValue(recipe.cookTimeMin),
        color: colors.primary,
      ),
      (
        icon: Icons.local_fire_department_outlined,
        label: l10n.recipeDetailDifficultyLabel,
        value: l10n.difficultyLabel(recipe.difficulty),
        color: colors.primary,
      ),
      (
        icon: Icons.payments_outlined,
        label: l10n.recipeDetailCostLabel,
        value: formatRupiah(recipe.estimatedCostIdr),
        color: segar.success,
      ),
    ];

    return AppCard(
      child: Row(
        children: <Widget>[
          for (var index = 0; index < items.length; index++) ...<Widget>[
            if (index > 0)
              Container(
                width: 1,
                height: 38,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                color: colors.surfaceContainerHigh,
              ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Icon(items[index].icon, size: 20, color: items[index].color),
                  const SizedBox(height: 4),
                  Text(
                    items[index].value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    items[index].label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.texts.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ServingsCard extends StatelessWidget {
  const _ServingsCard({
    required this.servings,
    required this.baseServings,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int servings;
  final int baseServings;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return AppCard(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.recipeDetailServingsTitle,
                  style: context.texts.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.recipeDetailServingsHint,
                  style: context.texts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _StepperButton(
            icon: Icons.remove_rounded,
            tooltip: l10n.recipeDetailDecreaseServings,
            onPressed: onDecrease,
          ),
          SizedBox(
            width: 58,
            child: Column(
              children: <Widget>[
                Text(
                  '$servings',
                  style: context.texts.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
                Text(
                  l10n.recipeServingsValue(baseServings),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            tooltip: l10n.recipeDetailIncreaseServings,
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.ingredient,
    required this.servings,
    required this.baseServings,
  });

  final RecipeIngredientView ingredient;
  final int servings;
  final int baseServings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final available = ingredient.isAvailable;
    final urgent = ingredient.isUrgent;
    final amount = formatQuantity(
      ingredient.scaledAmount(servings, baseServings),
    );

    final iconColor = available
        ? segar.success
        : ingredient.isRequired
        ? colors.onSurfaceVariant
        : colors.outline;
    final statusLabel = available
        ? l10n.recipeDetailAvailable
        : ingredient.isOptional
        ? l10n.recipeDetailOptional
        : ingredient.isStaple
        ? l10n.recipeDetailStaple
        : l10n.recipeDetailMissing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          available
              ? Icons.check_circle_rounded
              : ingredient.isRequired
              ? Icons.radio_button_unchecked_rounded
              : Icons.remove_circle_outline_rounded,
          size: 20,
          color: iconColor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ingredient.name,
                style: context.texts.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Wrap(
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                children: <Widget>[
                  _StatusPill(
                    label: statusLabel,
                    background: available
                        ? segar.successContainer
                        : colors.surfaceContainerHigh,
                    foreground: available
                        ? segar.onSuccessContainer
                        : colors.onSurfaceVariant,
                  ),
                  if (urgent)
                    _StatusPill(
                      label: l10n.recipeDetailUrgent,
                      background: segar.warningContainer,
                      foreground: segar.onWarningContainer,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$amount ${l10n.unitLabel(ingredient.unit)}',
          style: context.texts.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: available ? colors.onSurface : colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: context.texts.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MissingNote extends StatelessWidget {
  const _MissingNote({
    required this.count,
    required this.title,
    required this.body,
  });

  final int count;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final segar = context.segarColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: segar.warningContainer,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: segar.onWarningContainer,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: context.texts.labelMedium?.copyWith(
                    color: segar.onWarningContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: context.texts.bodySmall?.copyWith(
                    color: segar.onWarningContainer,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$count',
            style: context.texts.titleMedium?.copyWith(
              color: segar.onWarningContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: context.texts.labelMedium?.copyWith(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.recipeDetailStepLabel(index),
                  style: context.texts.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: context.texts.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CookSheet extends StatefulWidget {
  const _CookSheet({required this.recipe, required this.servings});

  final RecipeView recipe;
  final int servings;

  @override
  State<_CookSheet> createState() => _CookSheetState();
}

class _CookSheetState extends State<_CookSheet> {
  late Set<String> _selected = widget.recipe.matchedIngredients
      .map((ingredient) => ingredient.id)
      .toSet();

  void _toggle(String id, bool selected) {
    setState(() {
      if (selected) {
        _selected.add(id);
      } else {
        _selected.remove(id);
      }
    });
  }

  void _toggleAll() {
    final allIds = widget.recipe.matchedIngredients
        .map((ingredient) => ingredient.id)
        .toSet();
    setState(() {
      _selected = _selected.length == allIds.length ? <String>{} : allIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final matched = widget.recipe.matchedIngredients;
    final allSelected =
        matched.isNotEmpty && _selected.length == matched.length;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.recipeDetailCookSheetTitle,
                    style: context.texts.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.recipeDetailCookSheetBody,
                    style: context.texts.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (matched.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.recipeDetailCookSheetEmpty,
                  style: context.texts.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              )
            else ...<Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.recipeDetailSelectedCount(_selected.length),
                        style: context.texts.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _toggleAll,
                      child: Text(
                        allSelected
                            ? l10n.genericCancel
                            : l10n.recipeDetailSelectAll,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  children: <Widget>[
                    for (final ingredient in matched)
                      CheckboxListTile(
                        value: _selected.contains(ingredient.id),
                        onChanged: (value) =>
                            _toggle(ingredient.id, value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(ingredient.name),
                        subtitle: Text(
                          '${formatQuantity(ingredient.scaledAmount(widget.servings, widget.recipe.servings))} '
                          '${l10n.unitLabel(ingredient.unit)}',
                        ),
                        secondary: Text(
                          ingredient.matchedItem?.emoji.isNotEmpty ?? false
                              ? ingredient.matchedItem!.emoji
                              : '🥗',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppButton(
                  label: l10n.recipeDetailCookConfirm,
                  icon: Icons.restaurant_rounded,
                  expand: true,
                  onPressed: _selected.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_selected),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
