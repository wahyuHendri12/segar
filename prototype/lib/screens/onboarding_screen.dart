import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const _slides = <_OnboardingSlide>[
    _OnboardingSlide(
      badge: 'Kulkas & Rak Aman',
      badgeIcon: Icons.kitchen_rounded,
      badgeColor: AppColors.primary,
      badgeBackground: Color(0x26018646),
      secondaryBadge: 'Live Tracking',
      secondaryBadgeColor: AppColors.onSurfaceVariant,
      secondaryBadgeIcon: Icons.circle,
      imageAsset: 'assets/images/onboarding_stock.jpg',
      title: 'Catat Stok Dapurmu,',
      titleHighlight: 'Tanpa Ribet.',
      highlightColor: AppColors.primary,
      description:
          'Cukup foto struk belanja, scan barcode, atau ketik santai nama bahan. Stok kos maupun dapur rumah tersusun rapi otomatis.',
      infoIcon: Icons.check_circle_rounded,
      infoColor: AppColors.primary,
      infoText: 'Dukung bahan lokal & sayur pasar',
      infoTrailing: 'Auto Sortir',
      infoTrailingColor: AppColors.primary,
      blobs: [Alignment.topRight, Alignment.bottomLeft],
    ),
    _OnboardingSlide(
      badge: 'Pengingat Humanis',
      badgeIcon: Icons.notifications_active_rounded,
      badgeColor: AppColors.secondary,
      badgeBackground: Color(0x80FFDDB8),
      secondaryBadge: 'Bukan Alarm Bising',
      secondaryBadgeColor: AppColors.onSurfaceVariant,
      imageAsset: 'assets/images/onboarding_reminder.jpg',
      title: 'Dapat Pengingat Cerdas',
      titleHighlight: 'Sebelum Layu.',
      highlightColor: AppColors.secondary,
      description:
          'Notifikasi ramah dan santai menyapa tepat waktu. Selamatkan bahan makanan favoritmu tanpa perlu cemas basi tiba-tiba.',
      infoIcon: Icons.sentiment_satisfied_rounded,
      infoColor: AppColors.secondary,
      infoText: 'Bebas rasa bersalah membuang sayur',
      infoTrailing: 'H-2 Hari',
      infoTrailingColor: AppColors.secondary,
      blobs: [Alignment.bottomRight],
    ),
    _OnboardingSlide(
      badge: 'Solusi Masak Kilat',
      badgeIcon: Icons.soup_kitchen_rounded,
      badgeColor: AppColors.primary,
      badgeBackground: Color(0x26018646),
      secondaryBadge: 'Hemat Kost',
      secondaryBadgeColor: AppColors.onSurfaceVariant,
      imageAsset: 'assets/images/onboarding_cook.jpg',
      title: 'Masak Lezat & Hemat',
      titleHighlight: 'Dari Stok Tersisa.',
      highlightColor: AppColors.primary,
      description:
          'Dapatkan rekomendasi resep nusantara yang langsung mencocokkan isi kulkasmu. Dompet aman, perut kenyang gembira!',
      infoIcon: Icons.savings_rounded,
      infoColor: AppColors.primary,
      infoText: 'Modal Rp10.000 rasa restoran',
      infoTrailing: '15 Menit Jadi',
      infoTrailingColor: AppColors.primary,
      blobs: [Alignment.topLeft],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  void _goToSlide(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _handlePrimaryAction() {
    if (_currentPage == _slides.length - 1) {
      _finish();
    } else {
      _goToSlide(_currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: _SlideContent(slide: _slides[index]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildPagination(),
              const SizedBox(height: 14),
              const _FeatureHighlights(),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handlePrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.card,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            isLast ? 'Mulai Menjaga Kulkas' : 'Lanjut',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.labelLarge.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _finish,
                child: Text.rich(
                  TextSpan(
                    text: 'Sudah punya akun Segar? ',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text: 'Masuk di sini',
                        style: AppText.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.card,
            ),
            child: const Icon(Icons.eco_rounded, color: AppColors.onPrimary, size: 20),
          ),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              text: 'Segar',
              style: AppText.headlineSmall.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
              children: const [
                TextSpan(
                  text: '.',
                  style: TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const Spacer(),
          Material(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              onTap: () => _goToSlide(_slides.length - 1),
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'Lewati',
                  style: AppText.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final active = index == _currentPage;
        return GestureDetector(
          onTap: () => _goToSlide(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: active ? 32 : 8,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVisualCard(),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${slide.title}\n',
                style: AppText.headlineLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: slide.titleHighlight,
                style: AppText.headlineLarge.copyWith(
                  color: slide.highlightColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          slide.description,
          style: AppText.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildVisualCard() {
    return Container(
      height: 288,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          ...slide.blobs.map(
            (alignment) => Align(
              alignment: alignment,
              child: _Blob(
                color: alignment == Alignment.bottomLeft ||
                        alignment == Alignment.bottomRight
                    ? AppColors.secondaryFixed
                    : AppColors.primaryFixed,
                size: alignment == Alignment.bottomLeft ? 130 : 150,
                alignment: alignment,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AppPill(
                          label: slide.badge,
                          background: slide.badgeBackground,
                          foreground: slide.badgeColor,
                          icon: slide.badgeIcon,
                          iconSize: 15,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (slide.secondaryBadge != null) ...[
                    const SizedBox(width: 6),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: AppPill(
                            label: slide.secondaryBadge!,
                            background: AppColors.surfaceContainerHigh,
                            foreground: slide.secondaryBadgeColor ??
                                AppColors.onSurfaceVariant,
                            dotColor: slide.secondaryBadgeIcon == null
                                ? null
                                : AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(slide.imageAsset, fit: BoxFit.cover),
                      if (slide.infoText.startsWith('Dapat Pengingat'))
                        _buildNotificationOverlay(),
                      if (slide.infoText.startsWith('Catat Stok'))
                        _buildStockOverlays(),
                      if (slide.infoText.startsWith('Modal Rp10.000'))
                        _buildRecipeOverlay(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(slide.infoIcon, size: 15, color: slide.infoColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      slide.infoText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    slide.infoTrailing,
                    style: AppText.labelSmall.copyWith(
                      color: slide.infoTrailingColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockOverlays() {
    return Stack(
      children: [
        Positioned(
          left: 10,
          bottom: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    size: 15,
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Scan Struk Kilat',
                      style: AppText.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '1 Detik terdata rapi',
                      style: AppText.bodySmall.copyWith(
                        fontSize: 9,
                        height: 1.2,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 15,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '100% Anti Lupa',
                  style: AppText.labelSmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationOverlay() {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 10,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.alarm_on_rounded,
                size: 17,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toge & Bayam: Segera dimasak!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.labelSmall.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Bagusnya ditumis malam ini yuk biar tetap renyah',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 9,
                      height: 1.2,
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

  Widget _buildRecipeOverlay() {
    return Positioned(
      left: 10,
      bottom: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Ide Resep: Tumis Tempe Pedas Gurih',
              style: AppText.labelSmall.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureHighlights extends StatelessWidget {
  const _FeatureHighlights();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Bebas Guilt', 'Bahan tak mubazir', Icons.sentiment_very_satisfied_rounded, AppColors.primary),
      ('Hemat 350rb', 'Rata-rata/bulan', Icons.payments_rounded, AppColors.secondary),
      ('Resep Kilat', 'Sesuai bahan kos', Icons.menu_book_rounded, AppColors.primary),
    ];

    return Row(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 6),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(item.$3, size: 20, color: item.$4),
                  const SizedBox(height: 4),
                  Text(
                    item.$1,
                    textAlign: TextAlign.center,
                    style: AppText.labelSmall.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.$2,
                    textAlign: TextAlign.center,
                    style: AppText.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 9,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.color,
    required this.size,
    required this.alignment,
  });

  final Color color;
  final double size;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.45),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.badge,
    required this.badgeIcon,
    required this.badgeColor,
    required this.badgeBackground,
    required this.secondaryBadgeColor,
    required this.imageAsset,
    required this.title,
    required this.titleHighlight,
    required this.highlightColor,
    required this.description,
    required this.infoIcon,
    required this.infoColor,
    required this.infoText,
    required this.infoTrailing,
    required this.infoTrailingColor,
    required this.blobs,
    this.secondaryBadge,
    this.secondaryBadgeIcon,
  });

  final String badge;
  final IconData badgeIcon;
  final Color badgeColor;
  final Color badgeBackground;
  final String? secondaryBadge;
  final Color? secondaryBadgeColor;
  final IconData? secondaryBadgeIcon;
  final String imageAsset;
  final String title;
  final String titleHighlight;
  final Color highlightColor;
  final String description;
  final IconData infoIcon;
  final Color infoColor;
  final String infoText;
  final String infoTrailing;
  final Color infoTrailingColor;
  final List<Alignment> blobs;
}
