import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/countdown_ring.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/local/enums.dart';
import '../../data/models/pantry_item_view.dart';
import '../../data/repositories/repository_providers.dart';
import '../../l10n/app_labels.dart';
import '../../l10n/app_localizations.dart';
import 'item_detail_providers.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncItem = ref.watch(itemDetailProvider(widget.itemId));
    final item = asyncItem.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.itemDetailTitle),
        actions: item == null
            ? null
            : <Widget>[
                IconButton(
                  tooltip: l10n.detailEdit,
                  onPressed: _busy
                      ? null
                      : () => context.push(Routes.edit(item.id)),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: l10n.detailDelete,
                  onPressed: _busy ? null : () => _delete(item),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
      ),
      body: SafeArea(
        bottom: false,
        child: asyncItem.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: LoadingSkeleton(items: 5),
          ),
          error: (error, stackTrace) => EmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.detailLoadError,
            message: l10n.actionFailed,
          ),
          data: (item) {
            if (item == null) {
              return EmptyState(
                icon: Icons.search_off_rounded,
                title: l10n.detailNotFoundTitle,
                message: l10n.detailNotFoundBody,
              );
            }
            return _buildContent(context, l10n, item);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    PantryItemView item,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: <Widget>[
        _HeroCard(item: item),
        const SizedBox(height: AppSpacing.md),
        SectionHeader(title: l10n.detailFreshness),
        const SizedBox(height: AppSpacing.sm),
        _CountdownCard(item: item),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.detailInfoTitle),
        const SizedBox(height: AppSpacing.sm),
        _InfoCard(item: item),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.detailTipsTitle),
        const SizedBox(height: AppSpacing.sm),
        _TipsCard(item: item),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.detailActionsTitle),
        const SizedBox(height: AppSpacing.sm),
        if (_busy) ...<Widget>[
          const LinearProgressIndicator(minHeight: 3),
          const SizedBox(height: AppSpacing.sm),
        ],
        AppButton(
          label: l10n.detailMarkUsed,
          icon: Icons.check_circle_outline_rounded,
          expand: true,
          onPressed: _busy ? null : () => _markUsed(item),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppButton(
          label: l10n.detailPartial,
          icon: Icons.remove_circle_outline_rounded,
          variant: AppButtonVariant.tonal,
          expand: true,
          onPressed: _busy ? null : () => _markPartiallyUsed(item),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppButton(
          label: l10n.detailMarkWasted,
          icon: Icons.delete_sweep_outlined,
          variant: AppButtonVariant.outline,
          expand: true,
          onPressed: _busy ? null : () => _markWasted(item),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.detailValueHint,
          textAlign: TextAlign.center,
          style: context.texts.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Future<void> _markUsed(PantryItemView item) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final outcome = await ref.read(pantryRepositoryProvider).markUsed(item);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        _actionSnackBar(
          message: l10n.actionUsedSuccess,
          outcome: outcome,
          l10n: l10n,
          wasted: false,
        ),
      );
    } on Object {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(l10n.actionFailed);
    }
  }

  Future<void> _markWasted(PantryItemView item) async {
    final l10n = AppLocalizations.of(context);
    final reason = await showModalBottomSheet<WasteReason>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _WasteReasonSheet(),
    );
    if (reason == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final outcome = await ref
          .read(pantryRepositoryProvider)
          .markWasted(item, reason: reason);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        _actionSnackBar(
          message: l10n.actionWastedSuccess,
          outcome: outcome,
          l10n: l10n,
          wasted: true,
        ),
      );
    } on Object {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(l10n.actionFailed);
    }
  }

  Future<void> _markPartiallyUsed(PantryItemView item) async {
    final l10n = AppLocalizations.of(context);
    final used = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _PartialUseSheet(item: item),
    );
    if (used == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final outcome = await ref
          .read(pantryRepositoryProvider)
          .markPartiallyUsed(item, used);
      if (!mounted) return;
      if (outcome.action == UsageAction.dipakai) {
        Navigator.of(context).pop();
      } else {
        setState(() => _busy = false);
      }
      messenger.showSnackBar(
        _actionSnackBar(
          message: l10n.actionPartialSuccess,
          outcome: outcome,
          l10n: l10n,
          wasted: false,
        ),
      );
    } on Object {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(l10n.actionFailed);
    }
  }

  Future<void> _delete(PantryItemView item) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteConfirmTitle,
      message: l10n.deleteConfirmBody,
      confirmLabel: l10n.deleteConfirmAction,
      cancelLabel: l10n.genericCancel,
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(pantryRepositoryProvider);
    setState(() => _busy = true);
    try {
      await repository.deleteItem(item.id);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.actionDeleted),
          action: SnackBarAction(
            label: l10n.actionUndo,
            onPressed: () => repository.restoreItem(item.id),
          ),
        ),
      );
    } on Object {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(l10n.actionFailed);
    }
  }

  SnackBar _actionSnackBar({
    required String message,
    required PantryActionOutcome outcome,
    required AppLocalizations l10n,
    required bool wasted,
  }) {
    final value = outcome.valueIdr > 0
        ? '\n${wasted ? l10n.valueWasted(formatRupiah(outcome.valueIdr)) : l10n.valueSaved(formatRupiah(outcome.valueIdr))}'
              '${outcome.isEstimate ? l10n.valueEstimateSuffix : ''}'
        : '';

    return SnackBar(
      content: Text('$message$value'),
      action: SnackBarAction(
        label: l10n.actionUndo,
        onPressed: () {
          ref
              .read(pantryRepositoryProvider)
              .undoUsage(
                usageLogId: outcome.usageLogId,
                itemId: outcome.itemId,
              );
        },
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.item});

  final PantryItemView item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return AppCard(
      child: Column(
        children: <Widget>[
          Container(
            width: 96,
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.sheet),
            ),
            child: Text(
              item.emoji.isEmpty ? '🥗' : item.emoji,
              style: const TextStyle(fontSize: 48),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: context.texts.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.xxs,
            runSpacing: AppSpacing.xxs,
            children: <Widget>[
              _Pill(
                icon: Icons.category_outlined,
                label: l10n.categoryLabel(item.category),
              ),
              _Pill(
                icon: Icons.kitchen_outlined,
                label: l10n.storageLabel(item.storageLocation),
              ),
              _Pill(
                icon: Icons.scale_outlined,
                label:
                    '${formatQuantity(item.quantity)} ${l10n.unitLabel(item.unit)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

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
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: colors.onSurfaceVariant),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.texts.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({required this.item});

  final PantryItemView item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final segar = context.segarColors;
    final color = switch (item.expiryStatus) {
      ExpiryStatus.aman => segar.success,
      ExpiryStatus.hampirBasi || ExpiryStatus.basiHariIni => segar.warning,
      ExpiryStatus.sudahBasi => segar.expired,
    };

    return AppCard(
      child: Column(
        children: <Widget>[
          CountdownRing(
            progress: item.shelfLifeProgress,
            headline: l10n.expiryHeadline(item.expiryStatus, item.daysLeft),
            caption: formatDateId(item.expiryDate),
            color: color,
            size: 156,
          ),
          const SizedBox(height: AppSpacing.sm),
          StatusBadge(
            status: itemStatusFromExpiry(item.expiryStatus),
            label: l10n.expiryBadgeLabel(item.expiryStatus, item.daysLeft),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.expirySourceLabel(item.expirySource),
            style: context.texts.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.item});

  final PantryItemView item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final weight = item.estimatedWeightGrams;
    final manualPrice = item.priceIdr;
    final estimatedPrice = item.typicalPriceIdr;
    final priceValue = manualPrice != null && manualPrice > 0
        ? formatRupiah(manualPrice)
        : estimatedPrice != null && estimatedPrice > 0
        ? '${formatRupiah(estimatedPrice)}${l10n.valueEstimateSuffix}'
        : '-';

    final rows = <({String label, String value})>[
      (
        label: l10n.detailQuantity,
        value:
            '${formatQuantity(item.quantity)} ${l10n.unitLabel(item.unit)}'
            '${weight == null ? '' : ' (~$weight g)'}',
      ),
      (label: l10n.detailCategory, value: l10n.categoryLabel(item.category)),
      (
        label: l10n.detailStorage,
        value: l10n.storageLabel(item.storageLocation),
      ),
      (label: l10n.detailPurchasedOn, value: formatDateId(item.purchaseDate)),
      (label: l10n.detailExpiresOn, value: formatDateId(item.expiryDate)),
      (label: l10n.detailPrice, value: priceValue),
      (
        label: l10n.detailShelfLife,
        value: l10n.formShelfLifeInfo(
          l10n.storageLabel(item.storageLocation),
          item.shelfLifeDays,
        ),
      ),
      (
        label: l10n.formNotifyLabel,
        value: item.notifyEnabled ? l10n.detailNotifOn : l10n.detailNotifOff,
      ),
    ];
    final note = item.note?.trim();

    return AppCard(
      child: Column(
        children: <Widget>[
          for (var index = 0; index < rows.length; index++) ...<Widget>[
            _InfoRow(label: rows[index].label, value: rows[index].value),
            if (index != rows.length - 1 || (note != null && note.isNotEmpty))
              const Divider(height: AppSpacing.md),
          ],
          if (note != null && note.isNotEmpty)
            _InfoRow(label: l10n.detailNote, value: note),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: context.texts.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: context.texts.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.item});

  final PantryItemView item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tips = item.catalog?.tips ?? const <String>[];

    return AppCard(
      child: tips.isEmpty
          ? Text(
              l10n.detailNoTips,
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var index = 0; index < tips.length; index++) ...<Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.spa_outlined,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          tips[index],
                          style: context.texts.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  if (index != tips.length - 1)
                    const SizedBox(height: AppSpacing.xs),
                ],
              ],
            ),
    );
  }
}

class _PartialUseSheet extends StatefulWidget {
  const _PartialUseSheet({required this.item});

  final PantryItemView item;

  @override
  State<_PartialUseSheet> createState() => _PartialUseSheetState();
}

class _PartialUseSheetState extends State<_PartialUseSheet> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: formatQuantity(widget.item.quantity / 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuantity(double value) {
    setState(() {
      _controller.text = formatQuantity(value);
      _error = null;
    });
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    final parsed = double.tryParse(
      _controller.text.trim().replaceAll(',', '.'),
    );
    if (parsed == null || parsed <= 0 || parsed > widget.item.quantity) {
      setState(() => _error = l10n.partialInvalid);
      return;
    }
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = widget.item;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg + viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.partialSheetTitle,
              style: context.texts.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.partialSheetBody(item.name),
              style: context.texts.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: l10n.partialUsedLabel,
                suffixText: l10n.unitLabel(item.unit),
                errorText: _error,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: <Widget>[
                ActionChip(
                  label: Text(l10n.partialQuickQuarter),
                  onPressed: () => _setQuantity(item.quantity / 4),
                ),
                ActionChip(
                  label: Text(l10n.partialQuickHalf),
                  onPressed: () => _setQuantity(item.quantity / 2),
                ),
                ActionChip(
                  label: Text(l10n.partialQuickAll),
                  onPressed: () => _setQuantity(item.quantity),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.partialRemaining(
                formatQuantity(item.quantity),
                l10n.unitLabel(item.unit),
              ),
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.partialSave,
              icon: Icons.check_rounded,
              expand: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _WasteReasonSheet extends StatefulWidget {
  const _WasteReasonSheet();

  @override
  State<_WasteReasonSheet> createState() => _WasteReasonSheetState();
}

class _WasteReasonSheetState extends State<_WasteReasonSheet> {
  WasteReason _selected = WasteReason.basi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reasons = <({WasteReason value, String label})>[
      (value: WasteReason.basi, label: l10n.wasteReasonBasi),
      (value: WasteReason.lupa, label: l10n.wasteReasonLupa),
      (value: WasteReason.terlaluBanyak, label: l10n.wasteReasonTerlaluBanyak),
      (value: WasteReason.rasaBerubah, label: l10n.wasteReasonRasaBerubah),
      (value: WasteReason.lainnya, label: l10n.wasteReasonLainnya),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.wasteSheetTitle,
            style: context.texts.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.wasteSheetBody,
            style: context.texts.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          RadioGroup<WasteReason>(
            groupValue: _selected,
            onChanged: (value) {
              if (value != null) setState(() => _selected = value);
            },
            child: Column(
              children: <Widget>[
                for (final reason in reasons)
                  RadioListTile<WasteReason>(
                    value: reason.value,
                    title: Text(reason.label),
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.wasteSave,
            icon: Icons.delete_sweep_outlined,
            variant: AppButtonVariant.danger,
            expand: true,
            onPressed: () => Navigator.of(context).pop(_selected),
          ),
        ],
      ),
    );
  }
}
