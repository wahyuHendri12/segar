import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SegarBottomNavBar extends StatelessWidget {
  const SegarBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAdd,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  static const _items = <_NavItem>[
    _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded),
    _NavItem('Resep', Icons.menu_book_outlined, Icons.menu_book_rounded),
    _NavItem('', Icons.add_rounded, Icons.add_rounded),
    _NavItem('Statistik', Icons.bar_chart_rounded, Icons.bar_chart_rounded),
    _NavItem('Profil', Icons.account_circle_outlined, Icons.account_circle_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: 98 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80 + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder),
                ),
                boxShadow: AppShadows.bottomBar,
              ),
              child: Row(
                children: List.generate(_items.length, (index) {
                  if (index == 2) {
                    return const Expanded(child: SizedBox());
                  }
                  final item = _items[index];
                  final active = currentIndex == index;
                  return Expanded(
                    child: _NavButton(
                      item: item,
                      active: active,
                      onTap: () => onTap(index),
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
              child: Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                elevation: 0,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.primary,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onAdd,
                      customBorder: const CircleBorder(),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.onPrimary,
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
    final color = active ? AppColors.primary : AppColors.onSurfaceVariant;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(active ? item.activeIcon : item.icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: AppText.labelSmall.copyWith(
                  color: color,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
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
