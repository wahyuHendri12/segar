import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/pantry_filter.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/local/enums.dart';
import '../../data/models/pantry_item_view.dart';
import '../../l10n/app_localizations.dart';
import 'home_providers.dart';
import 'widgets/pantry_item_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(allPantryItemsProvider);
    await ref.read(allPantryItemsProvider.future);
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(pantryFilterProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final userName = ref.watch(userNameProvider);
    final filter = ref.watch(pantryFilterProvider);
    final reminderDismissed = ref.watch(homeReminderDismissedProvider);
    final summaryAsync = ref.watch(pantrySummaryProvider);
    final groupsAsync = ref.watch(pantryGroupsProvider);
    final summary = summaryAsync.value;

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
              _buildHeader(context, l10n, userName),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.homeGreeting(userName),
                style: context.texts.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.homeSubtitle,
                style: context.texts.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              if (!reminderDismissed && (summary?.soon ?? 0) > 0) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                _ReminderBanner(
                  count: summary!.soon,
                  onDismiss: () => ref
                      .read(homeReminderDismissedProvider.notifier)
                      .dismiss(),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: l10n.homeSectionStatus,
                subtitle: l10n.homeStatusUpdate,
                trailing: Text(
                  l10n.homeItemsCount(summary?.total ?? 0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _StatusRow(summary: summary),
              const SizedBox(height: AppSpacing.lg),
              _buildSearchAndSort(context, l10n, filter),
              const SizedBox(height: AppSpacing.sm),
              _FilterRow(
                summary: summary,
                selected: filter.location,
                onSelected: (location) => ref
                    .read(pantryFilterProvider.notifier)
                    .setLocation(location),
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(
                title: l10n.homeItemsTitle,
                trailing: Text(
                  l10n.homeItemsCount(
                    groupsAsync.value == null
                        ? 0
                        : _countGroups(groupsAsync.value!),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              groupsAsync.when(
                loading: () => const LoadingSkeleton(items: 3),
                error: (error, stackTrace) => _ErrorCard(
                  message: l10n.homeLoadError,
                  retryLabel: l10n.genericRetry,
                  onRetry: _refresh,
                ),
                data: (groups) => _buildContent(
                  context,
                  l10n,
                  groups,
                  filter: filter,
                  pantryIsEmpty: summary?.total == 0,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 15,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      l10n.onboardingPrivacy,
                      style: context.texts.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    String userName,
  ) {
    final colors = context.colors;
    return Row(
      children: <Widget>[
        const BrandMark(),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            l10n.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.titleLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.push(Routes.shoppingList),
          tooltip: l10n.shoppingListTitle,
          icon: const Icon(Icons.shopping_basket_outlined),
        ),
        IconButton(
          onPressed: () => context.go(Routes.settings),
          tooltip: l10n.navProfile,
          icon: CircleAvatar(
            radius: 20,
            backgroundColor: colors.primaryContainer,
            child: Text(
              userName.trim().isEmpty
                  ? '?'
                  : userName.trim().characters.first.toUpperCase(),
              style: context.texts.titleSmall?.copyWith(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndSort(
    BuildContext context,
    AppLocalizations l10n,
    PantryFilterState filter,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: ref.read(pantryFilterProvider.notifier).setQuery,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.homeSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              suffixIcon: filter.query.trim().isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.genericCancel,
                      onPressed: () {
                        _searchController.clear();
                        ref.read(pantryFilterProvider.notifier).setQuery('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        PopupMenuButton<PantrySort>(
          tooltip: l10n.homeSortTooltip,
          initialValue: filter.sort,
          onSelected: ref.read(pantryFilterProvider.notifier).setSort,
          itemBuilder: (context) => <PopupMenuEntry<PantrySort>>[
            PopupMenuItem(
              value: PantrySort.expiryAsc,
              child: Text(l10n.homeSortExpiry),
            ),
            PopupMenuItem(
              value: PantrySort.nameAsc,
              child: Text(l10n.homeSortName),
            ),
            PopupMenuItem(
              value: PantrySort.newest,
              child: Text(l10n.homeSortNewest),
            ),
          ],
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: context.segarColors.cardBorder),
            ),
            child: Icon(
              Icons.sort_rounded,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    PantryGroups groups, {
    required PantryFilterState filter,
    required bool pantryIsEmpty,
  }) {
    if (groups.isEmpty) {
      if (pantryIsEmpty) {
        return AppCard(
          padding: EdgeInsets.zero,
          child: EmptyState(
            icon: Icons.eco_outlined,
            title: l10n.emptyPantryTitle,
            message: l10n.emptyPantryBody,
            action: AppButton(
              label: l10n.addFirstItem,
              icon: Icons.add_rounded,
              onPressed: () => context.push(Routes.addItem),
            ),
          ),
        );
      }

      return AppCard(
        padding: EdgeInsets.zero,
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.homeNoResultsTitle,
          message: l10n.homeNoResultsBody,
          action: filter.hasFilters
              ? AppButton(
                  label: l10n.homeClearFilters,
                  icon: Icons.filter_alt_off_rounded,
                  variant: AppButtonVariant.outline,
                  onPressed: _clearFilters,
                )
              : null,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (groups.urgent.isNotEmpty) ...<Widget>[
          _GroupHeader(
            title: l10n.homeUrgentTitle,
            count: groups.urgent.length,
            icon: Icons.warning_amber_rounded,
            color: context.segarColors.warning,
          ),
          const SizedBox(height: AppSpacing.xs),
          ..._itemCards(groups.urgent),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (groups.expired.isNotEmpty) ...<Widget>[
          _GroupHeader(
            title: l10n.homeExpiredTitle,
            count: groups.expired.length,
            icon: Icons.error_rounded,
            color: context.segarColors.expired,
          ),
          const SizedBox(height: AppSpacing.xs),
          ..._itemCards(groups.expired),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (groups.safe.isNotEmpty) ...<Widget>[
          _GroupHeader(
            title: l10n.homeSafeTitle,
            count: groups.safe.length,
            icon: Icons.check_circle_rounded,
            color: context.segarColors.success,
          ),
          const SizedBox(height: AppSpacing.xs),
          ..._itemCards(groups.safe),
        ],
      ],
    );
  }

  List<Widget> _itemCards(List<PantryItemView> items) {
    return <Widget>[
      for (var index = 0; index < items.length; index++) ...<Widget>[
        PantryItemCard(
          item: items[index],
          onTap: () => context.push(Routes.item(items[index].id)),
        ),
        if (index != items.length - 1) const SizedBox(height: AppSpacing.xs),
      ],
    ];
  }

  int _countGroups(PantryGroups groups) {
    return groups.urgent.length + groups.expired.length + groups.safe.length;
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.summary});

  final PantrySummary? summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _StatusTile(
            value: '${summary?.soon ?? 0}',
            label: l10n.statusSoon,
            status: ItemStatus.soon,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _StatusTile(
            value: '${summary?.safe ?? 0}',
            label: l10n.statusSafe,
            status: ItemStatus.safe,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _StatusTile(
            value: '${summary?.expired ?? 0}',
            label: l10n.statusExpired,
            status: ItemStatus.expired,
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.value,
    required this.label,
    required this.status,
  });

  final String value;
  final String label;
  final ItemStatus status;

  @override
  Widget build(BuildContext context) {
    final segar = context.segarColors;
    final color = switch (status) {
      ItemStatus.safe => segar.success,
      ItemStatus.soon || ItemStatus.today => segar.warning,
      ItemStatus.expired => segar.expired,
    };
    final icon = switch (status) {
      ItemStatus.safe => Icons.check_circle_rounded,
      ItemStatus.soon || ItemStatus.today => Icons.schedule_rounded,
      ItemStatus.expired => Icons.error_rounded,
    };

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: context.texts.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.texts.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.summary,
    required this.selected,
    required this.onSelected,
  });

  final PantrySummary? summary;
  final StorageLocation? selected;
  final ValueChanged<StorageLocation?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = <({String label, StorageLocation? value})>[
      (label: l10n.genericAll, value: null),
      (label: l10n.locationKulkas, value: StorageLocation.kulkas),
      (label: l10n.locationFreezer, value: StorageLocation.freezer),
      (label: l10n.locationLemari, value: StorageLocation.lemari),
      (label: l10n.locationSuhuRuang, value: StorageLocation.suhuRuang),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (var index = 0; index < filters.length; index++) ...<Widget>[
            ChoiceChip(
              label: Text(
                '${filters[index].label} '
                '(${summary?.countFor(filters[index].value) ?? 0})',
              ),
              selected: selected == filters[index].value,
              onSelected: (_) => onSelected(filters[index].value),
            ),
            if (index != filters.length - 1)
              const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          l10n.homeItemsCount(count),
          style: context.texts.labelMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ReminderBanner extends StatelessWidget {
  const _ReminderBanner({required this.count, required this.onDismiss});

  final int count;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return AppCard(
      color: colors.secondaryContainer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.timer_rounded, color: colors.onSecondaryContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.homeReminderTitle,
                  style: context.texts.labelSmall?.copyWith(
                    color: colors.onSecondaryContainer,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.homeReminderBody(count),
                  style: context.texts.bodySmall?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            tooltip: l10n.genericClose,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: colors.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: retryLabel,
            variant: AppButtonVariant.outline,
            icon: Icons.refresh_rounded,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
