import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class SegarBottomNavBar extends StatelessWidget {
  const SegarBottomNavBar({
    super.key,
    required this.currentBranchIndex,
    required this.onBranchTap,
    required this.onAdd,
  });

  /// Index of the active [StatefulShellBranch] (0..3).
  final int currentBranchIndex;
  final ValueChanged<int> onBranchTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final segar = context.segarColors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final items = <_NavItem>[
      _NavItem(l10n.navHome, Icons.home_outlined, Icons.home_rounded),
      _NavItem(
        l10n.navRecipes,
        Icons.menu_book_outlined,
        Icons.menu_book_rounded,
      ),
      const _NavItem('', Icons.add_rounded, Icons.add_rounded),
      _NavItem(l10n.navStats, Icons.bar_chart_rounded, Icons.bar_chart_rounded),
      _NavItem(
        l10n.navProfile,
        Icons.account_circle_outlined,
        Icons.account_circle_rounded,
      ),
    ];

    // Branch index 0/1 maps to slots 0/1, branches 2/3 map to slots 3/4.
    return SizedBox(
      height: 96 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 76 + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                border: Border(top: BorderSide(color: segar.cardBorder)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: List<Widget>.generate(items.length, (slot) {
                  if (slot == 2) {
                    return const Expanded(child: SizedBox());
                  }
                  final item = items[slot];
                  final branch = slot < 2 ? slot : slot - 1;
                  return Expanded(
                    child: _NavButton(
                      item: item,
                      active: currentBranchIndex == branch,
                      onTap: () => onBranchTap(branch),
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Semantics(
                button: true,
                label: l10n.navAdd,
                child: Material(
                  color: colors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onAdd,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.32),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: colors.onPrimary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final _NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = active ? colors.primary : colors.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 76,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                active ? item.activeIcon : item.icon,
                size: 24,
                color: color,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.labelSmall?.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.activeIcon);

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
