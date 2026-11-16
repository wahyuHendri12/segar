import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/common.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _monthIndex = 1;
  int _selectedSlice = 0;
  bool _cheered = false;

  static const _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static const _slices = [
    (
      percent: '89%',
      label: 'Diselamatkan',
      detail: '31 Diolah',
      color: AppColors.primary,
      fraction: 0.89,
    ),
    (
      percent: '8%',
      label: 'Tersedia',
      detail: '1 Masih Ada',
      color: AppColors.secondaryContainer,
      fraction: 0.08,
    ),
    (
      percent: '3%',
      label: 'Terbuang',
      detail: '3 Terbuang',
      color: AppColors.tertiaryContainer,
      fraction: 0.03,
    ),
  ];

  String get _monthLabel {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month + _monthIndex - 1);
    return '${_shortMonths[date.month - 1]} ${date.year}';
  }

  void _cycleMonth() {
    setState(() => _monthIndex = (_monthIndex + 1) % 3);
  }

  Future<void> _celebrate() async {
    setState(() => _cheered = true);
    await Future<void>.delayed(const Duration(milliseconds: 2400));
    if (mounted) {
      setState(() => _cheered = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SegarHeader(title: 'Statistik'),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  children: [
                    _buildTitleRow(),
                    const SizedBox(height: 16),
                    _buildHeroMetric(),
                    const SizedBox(height: 16),
                    _buildComparisonCards(),
                    const SizedBox(height: 16),
                    _buildDonutCard(),
                    const SizedBox(height: 16),
                    _buildEmpathyCard(),
                    const SizedBox(height: 16),
                    _buildCategoryCard(),
                    const SizedBox(height: 16),
                    _buildInsightCard(),
                    const SizedBox(height: 16),
                    _buildCheerButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Statistik & Jejak Dapurmu',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('📊', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                onTap: _cycleMonth,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: AppShadows.card,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _monthLabel,
                        style: AppText.labelMedium.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.expand_more_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'Pantau dampak positif kebiasaan belanja & memasakmu',
          style: AppText.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroMetric() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: AppShadows.card,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -16,
              bottom: -16,
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL UANG MAKANAN DISELAMATKAN',
                            style: AppText.labelSmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Rp 284.500',
                              style: AppText.displayLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.savings_rounded,
                        size: 22,
                        color: AppColors.onPrimaryFixed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 17)),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '89% dari total bahan berhasil dimasak tepat waktu!',
                          style: AppText.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCards() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildComparisonCard(isCooked: true)),
          const SizedBox(width: 12),
          Expanded(child: _buildComparisonCard(isCooked: false)),
        ],
      ),
    );
  }

  Widget _buildComparisonCard({required bool isCooked}) {
    final color = isCooked ? AppColors.primary : AppColors.tertiary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCooked
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.tertiaryFixed.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCooked ? Icons.soup_kitchen_rounded : Icons.delete_sweep_rounded,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  isCooked ? 'Dimasak' : 'Terbuang',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isCooked ? '31 Bahan' : '3 Bahan',
            style: AppText.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            isCooked ? '~Rp 284.500' : '~Rp 28.000',
            style: AppText.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isCooked ? Icons.check_circle_rounded : Icons.psychology_rounded,
                size: 13,
                color: isCooked ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  isCooked ? 'Nilai gizi terjaga' : 'Bahan evaluasi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelSmall.copyWith(
                    color: isCooked
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonutCard() {
    final selected = _slices[_selectedSlice];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Distribusi Bahan Makanan',
                  style: AppText.headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              AppPill(
                label: '35 Total',
                background: AppColors.surfaceContainerHigh,
                foreground: AppColors.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 176,
            height: 176,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(176),
                  painter: _DonutPainter(
                    slices: _slices
                        .map((slice) => (slice.fraction, slice.color))
                        .toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        selected.percent,
                        key: ValueKey(selected.percent),
                        style: AppText.displayLarge.copyWith(
                          color: selected.color,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected.label,
                      style: AppText.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: List.generate(_slices.length, (index) {
                final slice = _slices[index];
                final selected = index == _selectedSlice;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSlice = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.surfaceContainerHighest
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: slice.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                slice.percent,
                                style: AppText.labelSmall.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            slice.detail,
                            textAlign: TextAlign.center,
                            style: AppText.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 9,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpathyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🌱', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dampak Nyata Kebiasaanmu',
                  style: AppText.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: 'Luar biasa, Dina! Bulan ini kamu mengurangi ',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                      height: 1.45,
                    ),
                    children: [
                      TextSpan(
                        text: '4.2 kg',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' jejak sampah makanan. Uang yang kamu hemat setara dengan ',
                      ),
                      TextSpan(
                        text: '14 porsi nasi rames kosan',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: '! Terus pertahankan ya ✨'),
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

  Widget _buildCategoryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Efisiensi per Kategori',
                  style: AppText.headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.category_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCategoryRow(
            emoji: '🍗',
            label: 'Daging & Protein',
            percent: '96%',
            fraction: 0.96,
            color: AppColors.primary,
            percentColor: AppColors.primary,
            note: '11 dari 12 porsi dihabiskan',
          ),
          const SizedBox(height: 12),
          _buildCategoryRow(
            emoji: '🥛',
            label: 'Susu & Olahan',
            percent: '90%',
            fraction: 0.90,
            color: AppColors.primary,
            percentColor: AppColors.primary,
            note: '9 dari 10 produk digunakan',
          ),
          const SizedBox(height: 12),
          _buildCategoryRow(
            emoji: '🥬',
            label: 'Sayuran & Buah',
            percent: '85%',
            fraction: 0.85,
            color: AppColors.secondaryContainer,
            percentColor: AppColors.secondary,
            note: '11 dari 13 ikat terselamatkan',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow({
    required String emoji,
    required String label,
    required String percent,
    required double fraction,
    required Color color,
    required Color percentColor,
    required String note,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 11)),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                style: AppText.labelLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              percent,
              style: AppText.labelMedium.copyWith(
                color: percentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ThinProgressBar(value: fraction, color: color, height: 12),
        const SizedBox(height: 3),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            note,
            style: AppText.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.secondaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              size: 20,
              color: AppColors.onSecondaryFixed,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insight Belanja Minggu Depan',
                  style: AppText.labelMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    text:
                        'Kamu cenderung menyisakan sayuran hijau di hari ke-4. Coba beli porsi ',
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.45,
                    ),
                    children: [
                      TextSpan(
                        text: 'setengah ikat',
                        style: AppText.bodySmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' saat belanja berikutnya agar selalu dinikmati saat segar!',
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

  Widget _buildCheerButton() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: _cheered
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            onTap: _celebrate,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _cheered ? Icons.verified_rounded : Icons.celebration_rounded,
                    size: 18,
                    color: _cheered ? AppColors.onPrimary : AppColors.primary,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      _cheered ? 'Hebat Banget! ✨' : 'Rayakan Pencapaian Dapur',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.labelMedium.copyWith(
                        color: _cheered
                            ? AppColors.onPrimary
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.slices});

  final List<(double, Color)> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 22.0;
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = AppColors.surfaceContainerHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    var startAngle = -math.pi / 2;
    for (final slice in slices) {
      final sweep = 2 * math.pi * slice.$1;
      final paint = Paint()
        ..color = slice.$2
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.slices != slices;
  }
}
