import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/ingredient.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/common.dart';

class IngredientDetailScreen extends StatelessWidget {
  const IngredientDetailScreen({super.key, required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SegarHeader(
              title: 'Detail Bahan',
              showBack: true,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  children: [
                    _buildHero(),
                    const SizedBox(height: 16),
                    _buildCountdownCard(),
                    const SizedBox(height: 16),
                    _buildTipsCard(),
                    const SizedBox(height: 16),
                    _buildRecipeIdeas(context),
                    const SizedBox(height: 20),
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: AppColors.surfaceContainerLowest,
        child: Stack(
          children: [
            Positioned(
              top: -54,
              right: -54,
              child: _GlowBlob(
                size: 150,
                color: AppColors.primaryFixed.withValues(alpha: 0.45),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: _GlowBlob(
                size: 120,
                color: AppColors.secondaryFixed.withValues(alpha: 0.45),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: 112,
                    height: 112,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ingredient.imageAsset != null
                              ? Image.asset(
                                  ingredient.imageAsset!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Text(
                                    ingredient.emoji,
                                    style: const TextStyle(fontSize: 48),
                                  ),
                                ),
                        ),
                        if (ingredient.imageAsset != null)
                          Positioned(
                            right: -6,
                            bottom: -6,
                            child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.card,
                              ),
                              child: Text(
                                ingredient.emoji,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    ingredient.imageAsset != null
                        ? 'Bayam Hijau Cabut'
                        : ingredient.name,
                    textAlign: TextAlign.center,
                    style: AppText.headlineLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      AppPill(
                        label: '${ingredient.category} • ${ingredient.storageDetail}',
                        background: AppColors.surfaceContainer,
                        foreground: AppColors.onSurfaceVariant,
                        icon: Icons.kitchen_rounded,
                        iconSize: 14,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                      AppPill(
                        label: ingredient.addedLabel,
                        background: AppColors.surfaceContainerLow,
                        foreground: AppColors.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.scale_rounded,
                          size: 15,
                          color: AppColors.onPrimaryFixedVariant,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            '${ingredient.quantity} (~250 gram)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.labelMedium.copyWith(
                              color: AppColors.onPrimaryFixedVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownCard() {
    final isExpired = ingredient.status == FreshnessStatus.expired;
    final progress = isExpired ? 0.94 : (ingredient.status == FreshnessStatus.soon ? 0.6 : 0.35);
    final ringColor = isExpired
        ? AppColors.tertiaryContainer
        : AppColors.secondaryContainer;
    final days = isExpired ? 'BESIUK' : '2 HARI';

    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: 176,
            height: 176,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 148,
                  height: 148,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ringColor.withValues(alpha: 0.16),
                        ringColor.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                CustomPaint(
                  size: const Size.square(176),
                  painter: _FreshnessRingPainter(
                    progress: progress,
                    color: ringColor,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MASA SEGAR',
                      style: AppText.labelSmall.copyWith(
                        color: isExpired ? AppColors.tertiary : AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      days,
                      style: AppText.displayLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1,
                        color: isExpired
                            ? AppColors.tertiary
                            : AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isExpired ? 'Segera keluarkan' : 'Tersisa sebelum layu',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isExpired
                  ? AppColors.tertiaryFixed.withValues(alpha: 0.5)
                  : AppColors.secondaryFixed.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isExpired
                        ? AppColors.tertiaryContainer
                        : AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpired
                        ? Icons.priority_high_rounded
                        : Icons.priority_high_rounded,
                    size: 18,
                    color: isExpired
                        ? AppColors.onTertiaryContainer
                        : AppColors.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isExpired
                            ? 'Status: Sudah Basi'
                            : 'Status: Segera Dipakai',
                        style: AppText.labelMedium.copyWith(
                          color: isExpired
                              ? AppColors.onTertiaryFixed
                              : AppColors.onSecondaryFixed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isExpired
                            ? 'Catat sebagai terbuang agar Segar bisa menyesuaikan porsi belanjamu berikutnya.'
                            : 'Olah dalam 48 jam ke depan agar vitamin C dan zat besi tetap maksimal.',
                        style: AppText.bodySmall.copyWith(
                          color: isExpired
                              ? AppColors.onTertiaryFixedVariant
                              : AppColors.onSecondaryFixedVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return SoftCard(
      color: AppColors.surfaceContainerLow,
      shadows: const [],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              size: 22,
              color: AppColors.onPrimaryFixed,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Tips Cerdas Segar',
                      style: AppText.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      'Bebas Lembek',
                      style: AppText.labelSmall.copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    text:
                        'Simpan bayam dalam wadah kedap beralas tisu dapur ',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                      height: 1.55,
                    ),
                    children: [
                      TextSpan(
                        text: 'tanpa dicuci terlebih dahulu',
                        style: AppText.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const TextSpan(
                        text:
                            '. Kelembapan air cuci adalah penyebab utama daun cepat menguning dan berlendir!',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeIdeas(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🍳', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3 Ide Masak Cepat',
                      style: AppText.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Langsung pakai sebelum layu',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => showSegarSnack(
                  context,
                  'Semua ide resep untuk bahan ini segera hadir.',
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Semua',
                      style: AppText.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.arrow_forward_rounded, size: 15),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(AppData.recipes.length, (index) {
            final recipe = AppData.recipes[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == AppData.recipes.length - 1 ? 0 : 8,
              ),
              child: Material(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => showSegarSnack(
                    context,
                    'Resep ${recipe.title} siap diikuti.',
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            recipe.imageAsset,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.labelLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '⏱ ${recipe.time} • ${recipe.difficulty}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: AppColors.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 7,
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(
                    'Hebat! ${ingredient.name} berhasil diolah.',
                  ),
                  icon: const Icon(Icons.check_circle_rounded, size: 20),
                  label: const Text('Sudah Dipakai'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    textStyle: AppText.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(
                    'Makanan terbuang tercatat dengan rapi. Terima kasih sudah jujur!',
                  ),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: AppColors.tertiary,
                  ),
                  label: const Text('Terbuang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiaryFixed,
                    foregroundColor: AppColors.onTertiaryFixed,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: AppText.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Mencatat makanan terbuang membantu Segar menyesuaikan porsi belanja terbaikmu di bulan depan!',
            textAlign: TextAlign.center,
            style: AppText.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _FreshnessRingPainter extends CustomPainter {
  const _FreshnessRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    final backgroundPaint = Paint()
      ..color = AppColors.surfaceContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0, 1),
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FreshnessRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
