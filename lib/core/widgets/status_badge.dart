import 'package:flutter/material.dart';

import '../../data/local/enums.dart';
import '../theme/app_theme.dart';

enum ItemStatus { safe, soon, today, expired }

ItemStatus itemStatusFromExpiry(ExpiryStatus status) {
  return switch (status) {
    ExpiryStatus.aman => ItemStatus.safe,
    ExpiryStatus.hampirBasi => ItemStatus.soon,
    ExpiryStatus.basiHariIni => ItemStatus.today,
    ExpiryStatus.sudahBasi => ItemStatus.expired,
  };
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.status,
    this.compact = false,
  });

  final String label;
  final ItemStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final segar = context.segarColors;

    final (background, foreground, icon) = switch (status) {
      ItemStatus.safe => (
        segar.successContainer,
        segar.onSuccessContainer,
        Icons.check_circle_rounded,
      ),
      ItemStatus.soon => (
        segar.warningContainer,
        segar.onWarningContainer,
        Icons.schedule_rounded,
      ),
      ItemStatus.today => (
        segar.warningContainer,
        segar.onWarningContainer,
        Icons.alarm_rounded,
      ),
      ItemStatus.expired => (
        segar.expiredContainer,
        segar.onExpiredContainer,
        Icons.error_rounded,
      ),
    };

    return Semantics(
      label: label,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.xs : 10,
          vertical: compact ? 3 : 5,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: compact ? 12 : 14, color: foreground),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (compact
                            ? context.texts.labelSmall
                            : context.texts.labelMedium)
                        ?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w600,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
