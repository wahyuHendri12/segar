import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format_utils.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/pantry_item_view.dart';
import '../../../l10n/app_labels.dart';
import '../../../l10n/app_localizations.dart';

class PantryItemCard extends StatelessWidget {
  const PantryItemCard({super.key, required this.item, this.onTap});

  final PantryItemView item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // The badge label grows with the text scale, so cap its width to keep
          // the item name readable on narrow screens.
          final maxBadgeWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth * 0.42
              : double.infinity;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Text(
                  item.emoji.isEmpty ? '🥗' : item.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatQuantity(item.quantity)} ${l10n.unitLabel(item.unit)}'
                      ' • ${l10n.storageLabel(item.storageLocation)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      l10n.categoryLabel(item.category),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxBadgeWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    StatusBadge(
                      compact: true,
                      status: itemStatusFromExpiry(item.expiryStatus),
                      label: l10n.expiryBadgeLabel(
                        item.expiryStatus,
                        item.daysLeft,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
