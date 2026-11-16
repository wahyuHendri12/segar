import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/ingredient.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/common.dart';
import '../widgets/ingredient_card.dart';
import 'ingredient_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onOpenRecipes,
    required this.onOpenProfile,
  });

  final VoidCallback onOpenRecipes;
  final VoidCallback onOpenProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showReminder = true;
  int _selectedFilter = 0;

  static const _filters = [
    ('Semua (17)', null),
    ('Kulkas (8)', StorageLocation.fridge),
    ('Freezer (4)', StorageLocation.freezer),
    ('Lemari / Pantry (5)', StorageLocation.pantry),
  ];

  List<Ingredient> _applyFilter(List<Ingredient> source) {
    final location = _filters[_selectedFilter].$2;
    if (location == null) return source;
    return source.where((item) => item.storage == location).toList();
  }

  Future<void> _openDetail(Ingredient ingredient) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => IngredientDetailScreen(ingredient: ingredient),
      ),
    );
    if (message != null && mounted) {
      showSegarSnack(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgent = _applyFilter(AppData.urgentIngredients);
    final safe = _applyFilter(AppData.safeIngredients);
    final history = _applyFilter(AppData.historyIngredients);

    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SegarHeader(
              title: 'Beranda',
              onAvatarTap: widget.onOpenProfile,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  children: [
                    _buildGreeting(),
                    if (_showReminder) ...[
                      const SizedBox(height: 20),
                      _buildReminderBanner(),
                    ],
                    const SizedBox(height: 20),
                    _buildRescueHero(),
                    const SizedBox(height: 20),
                    _buildStatusCard(),
                    const SizedBox(height: 20),
                    _buildFilters(),
                    const SizedBox(height: 20),
                    if (urgent.isEmpty && safe.isEmpty && history.isEmpty)
                      _buildEmptyState()
                    else ...[
                      if (urgent.isNotEmpty) ...[
                        _buildIngredientGroup(
                          title: 'Segera Dipakai (${urgent.length} Bahan)',
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.secondary,
                          trailing: Text(
                            'Prioritas',
                            style: AppText.labelSmall.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          items: urgent,
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (safe.isNotEmpty) ...[
                        _buildIngredientGroup(
                          title: 'Kondisi Aman',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.primary,
                          trailing: Text(
                            '${safe.length} Bahan',
                            style: AppText.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          items: safe,
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (history.isNotEmpty)
                        _buildIngredientGroup(
                          title: 'Riwayat Baru Saja',
                          icon: Icons.history_edu_rounded,
                          color: AppColors.onSurfaceVariant,
                          trailing: Text(
                            'Kemarin',
                            style: AppText.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          items: history,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/avatar_dina.jpg',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: -3,
              bottom: -3,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  size: 10,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Halo, Dina!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Ada bahan yang perlu dimasak hari ini nih!',
                style: AppText.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _NotificationButton(
          onTap: () => showSegarSnack(
            context,
            'Belum ada notifikasi baru. Dapurmu aman hari ini!',
          ),
        ),
      ],
    );
  }

  Widget _buildReminderBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryFixed.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_rounded,
              size: 18,
              color: AppColors.onSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PENGINGAT PAGI',
                  style: AppText.labelSmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    text: 'Tomat & Bayammu tersisa ',
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.onSurface,
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(
                        text: '2 hari lagi',
                        style: AppText.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const TextSpan(text: '! Yuk olah biar tetap segar.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => setState(() => _showReminder = false),
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 17,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRescueHero() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        child: InkWell(
          onTap: widget.onOpenRecipes,
          child: Column(
            children: [
              SizedBox(
                height: 176,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/home_recipe_hero.jpg',
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x00000000),
                            Color(0x2760645C),
                            Color(0xD92A2C28),
                          ],
                          stops: [0, 0.45, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: AppPill(
                        label: 'Selamatkan 2 Bahan!',
                        background: AppColors.secondaryContainer,
                        foreground: AppColors.onSecondary,
                        icon: Icons.bolt_rounded,
                        iconSize: 14,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 5,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REKOMENDASI MENU SIANG',
                            style: AppText.labelSmall.copyWith(
                              color: AppColors.primaryFixed,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tumis Bayam Bawang Putih & Sup Tomat Telur',
                            style: AppText.headlineSmall.copyWith(
                              color: AppColors.inverseOnSurface,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.soup_kitchen_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Siap dlm 15 mnt • Mudah',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: widget.onOpenRecipes,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Lihat Resep',
                                style: AppText.labelMedium.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 15,
                                color: AppColors.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return SoftCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Status Dapur',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              AppPill(
                label: 'Update Hari Ini',
                background: AppColors.primaryFixed,
                foreground: AppColors.onPrimaryFixed,
                dotColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: '3',
                  label: 'Segera Pakai',
                  background: AppColors.secondaryFixed.withValues(alpha: 0.5),
                  valueColor: AppColors.secondary,
                  labelColor: AppColors.onSecondaryFixedVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  value: '14',
                  label: 'Aman',
                  background: AppColors.surfaceContainerHigh,
                  valueColor: AppColors.primary,
                  labelColor: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  value: '0',
                  label: 'Basi',
                  background: AppColors.surfaceContainerHigh,
                  valueColor: AppColors.outline,
                  labelColor: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Keren! Minggu ini belum ada makanan terbuang 🌱',
                    style: AppText.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
                boxShadow: selected ? AppShadows.card : null,
              ),
              child: Text(
                _filters[index].$1,
                style: AppText.labelSmall.copyWith(
                  color: selected
                      ? AppColors.onPrimary
                      : AppColors.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIngredientGroup({
    required String title,
    required IconData icon,
    required Color color,
    required Widget trailing,
    required List<Ingredient> items,
  }) {
    return Column(
      children: [
        SectionTitleRow(
          icon: icon,
          title: title,
          iconColor: color,
          trailing: trailing,
        ),
        const SizedBox(height: 12),
        ...List.generate(items.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12),
            child: IngredientCard(
              ingredient: items[index],
              onTap: () => _openDetail(items[index]),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        children: [
          const Icon(Icons.kitchen_rounded, size: 36, color: AppColors.outline),
          const SizedBox(height: 10),
          Text(
            'Belum ada bahan di lokasi ini',
            style: AppText.labelLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Tambahkan bahan baru lewat tombol + di bawah.',
            textAlign: TextAlign.center,
            style: AppText.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.background,
    required this.valueColor,
    required this.labelColor,
  });

  final String value;
  final String label;
  final Color background;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppText.headlineLarge.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppText.labelSmall.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: AppColors.surfaceContainerLowest,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: AppShadows.card,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 22,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
