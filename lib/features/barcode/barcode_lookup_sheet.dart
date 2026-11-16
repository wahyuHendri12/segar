import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/barcode_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/barcode_lookup.dart';
import '../../data/models/online_result.dart';
import '../../data/repositories/repository_providers.dart';
import '../../l10n/app_labels.dart';
import '../../l10n/app_localizations.dart';
import 'barcode_scan_screen.dart';

Future<BarcodeLookup?> showBarcodeLookupSheet(BuildContext context) {
  return showModalBottomSheet<BarcodeLookup>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const BarcodeLookupSheet(),
  );
}

/// Manual barcode entry plus a shortcut to the camera scanner.
///
/// The sheet owns its own loading/result state so the add-item form only has to
/// react to the final [BarcodeLookup].
class BarcodeLookupSheet extends ConsumerStatefulWidget {
  const BarcodeLookupSheet({super.key});

  @override
  ConsumerState<BarcodeLookupSheet> createState() => _BarcodeLookupSheetState();
}

class _BarcodeLookupSheetState extends ConsumerState<BarcodeLookupSheet> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _validation;
  OnlineResult<BarcodeLookup>? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final l10n = AppLocalizations.of(context);
    final normalized = normalizeBarcode(_controller.text);
    if (!isValidBarcode(normalized)) {
      setState(() {
        _validation = l10n.barcodeInvalid;
        _result = null;
      });
      return;
    }

    setState(() {
      _validation = null;
      _isLoading = true;
      _result = null;
    });

    final result = await ref.read(barcodeRepositoryProvider).lookup(normalized);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _result = result;
    });
  }

  Future<void> _scan() async {
    final scanned = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => const BarcodeScanScreen(),
      ),
    );
    if (scanned == null || !mounted) return;
    _controller.text = scanned;
    await _search();
  }

  String _failureMessage(AppLocalizations l10n, OnlineFetchStatus status) {
    return switch (status) {
      OnlineFetchStatus.disabled => l10n.barcodeDisabled,
      OnlineFetchStatus.offline => l10n.barcodeOffline,
      OnlineFetchStatus.notFound => l10n.barcodeNotFound,
      OnlineFetchStatus.error => l10n.barcodeError,
      OnlineFetchStatus.success => l10n.barcodeError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.barcodeSheetTitle,
                        style: context.texts.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.barcodeSheetBody,
                        style: context.texts.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.genericClose,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 14,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: l10n.barcodeFieldLabel,
                hintText: l10n.barcodeFieldHint,
                prefixIcon: const Icon(Icons.numbers_rounded),
                counterText: '',
                errorText: _validation,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                final stackButtons =
                    constraints.maxWidth < 360 || textScale > 1.3;
                final lookupButton = AppButton(
                  label: l10n.barcodeLookupAction,
                  icon: Icons.search_rounded,
                  isLoading: _isLoading,
                  expand: stackButtons,
                  onPressed: _search,
                );
                final scanButton = AppButton(
                  label: l10n.barcodeScanAction,
                  icon: Icons.qr_code_scanner_rounded,
                  variant: AppButtonVariant.outline,
                  expand: stackButtons,
                  onPressed: _scan,
                );
                if (stackButtons) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      lookupButton,
                      const SizedBox(height: AppSpacing.xs),
                      scanButton,
                    ],
                  );
                }
                return Row(
                  children: <Widget>[
                    Expanded(child: lookupButton),
                    const SizedBox(width: AppSpacing.sm),
                    scanButton,
                  ],
                );
              },
            ),
            if (_isLoading) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              const LinearProgressIndicator(minHeight: 3),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.barcodeLookingUp,
                style: context.texts.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
            if (_result != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              _buildResult(context, l10n, _result!),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.barcodeManualHint,
              style: context.texts.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(
    BuildContext context,
    AppLocalizations l10n,
    OnlineResult<BarcodeLookup> result,
  ) {
    final lookup = result.data;
    if (!result.isSuccess || lookup == null) {
      final colors = context.colors;
      return AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.info_outline_rounded, color: colors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                _failureMessage(l10n, result.status),
                style: context.texts.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final colors = context.colors;
    final quantity = lookup.quantityText;

    return AppCard(
      color: colors.primaryContainer.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: colors.primary,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      lookup.name,
                      style: context.texts.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (lookup.brand != null && lookup.brand!.trim().isNotEmpty)
                      Text(
                        l10n.barcodeBrand(lookup.brand!),
                        style: context.texts.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xxs),
                    Wrap(
                      spacing: AppSpacing.xxs,
                      runSpacing: AppSpacing.xxs,
                      children: <Widget>[
                        _Badge(label: l10n.categoryLabel(lookup.category)),
                        if (quantity != null)
                          _Badge(label: l10n.barcodeQuantity(quantity)),
                        if (result.fromCache)
                          _Badge(
                            label: l10n.barcodeCacheBadge,
                            icon: Icons.cloud_off_rounded,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: l10n.barcodeUseAction,
            icon: Icons.check_rounded,
            expand: true,
            onPressed: () => Navigator.of(context).pop(lookup),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 13, color: colors.onSurfaceVariant),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: context.texts.labelSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
