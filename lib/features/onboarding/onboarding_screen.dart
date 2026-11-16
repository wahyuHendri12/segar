import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/brand_mark.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pageCount = 4;

  final _controller = PageController();
  final _nameController = TextEditingController();
  int _index = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finish({bool saveName = true}) async {
    if (_finishing) return;
    setState(() => _finishing = true);

    final name = _nameController.text.trim();
    if (saveName && name.isNotEmpty) {
      await ref.read(userNameProvider.notifier).setName(name);
    }
    await ref.read(onboardingDoneProvider.notifier).complete();
  }

  Future<void> _next() async {
    if (_index >= _pageCount - 1) {
      await _finish();
      return;
    }
    await _controller.nextPage(
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _back() async {
    if (_index == 0) return;
    await _controller.previousPage(
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const BrandMark(size: 34),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      l10n.appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.titleLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _finishing
                        ? null
                        : () => _finish(saveName: false),
                    child: Text(l10n.onboardingSkip),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) => setState(() => _index = index),
                  children: <Widget>[
                    _OnboardingSlide(
                      imageAsset: 'assets/images/onboarding_stock.jpg',
                      title: l10n.onboardingSlide1Title,
                      body: l10n.onboardingSlide1Body,
                    ),
                    _OnboardingSlide(
                      imageAsset: 'assets/images/onboarding_reminder.jpg',
                      title: l10n.onboardingSlide2Title,
                      body: l10n.onboardingSlide2Body,
                    ),
                    _OnboardingSlide(
                      imageAsset: 'assets/images/onboarding_cook.jpg',
                      title: l10n.onboardingSlide3Title,
                      body: l10n.onboardingSlide3Body,
                    ),
                    _NameSlide(
                      title: l10n.onboardingNameTitle,
                      body: l10n.onboardingNameBody,
                      label: l10n.onboardingNameLabel,
                      hint: l10n.onboardingNameHint,
                      privacy: l10n.onboardingPrivacy,
                      controller: _nameController,
                      onSubmitted: (_) => _next(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Semantics(
                label: l10n.onboardingPageLabel(_index + 1, _pageCount),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (var page = 0; page < _pageCount; page++)
                      AnimatedContainer(
                        duration: AppDurations.fast,
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxs / 2,
                        ),
                        width: page == _index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: page == _index
                              ? colors.primary
                              : colors.outlineVariant,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  final textScale = MediaQuery.textScalerOf(context).scale(1);
                  final stackButtons = _index > 0 && textScale > 1.6;
                  final nextButton = AppButton(
                    label: _index == _pageCount - 1
                        ? l10n.onboardingStart
                        : l10n.onboardingNext,
                    icon: Icons.arrow_forward_rounded,
                    expand: true,
                    isLoading: _finishing,
                    onPressed: _finishing ? null : _next,
                  );
                  if (stackButtons) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AppButton(
                          label: l10n.genericBack,
                          variant: AppButtonVariant.text,
                          expand: true,
                          onPressed: _finishing ? null : _back,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        nextButton,
                      ],
                    );
                  }
                  return Row(
                    children: <Widget>[
                      if (_index > 0) ...<Widget>[
                        AppButton(
                          label: l10n.genericBack,
                          variant: AppButtonVariant.text,
                          onPressed: _finishing ? null : _back,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      Expanded(child: nextButton),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.imageAsset,
    required this.title,
    required this.body,
  });

  final String imageAsset;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final segar = context.segarColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sheet),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: ColoredBox(
                color: segar.successContainer,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.eco_rounded,
                      size: 72,
                      color: segar.onSuccessContainer,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: context.texts.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: context.texts.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NameSlide extends StatelessWidget {
  const _NameSlide({
    required this.title,
    required this.body,
    required this.label,
    required this.hint,
    required this.privacy,
    required this.controller,
    required this.onSubmitted,
  });

  final String title;
  final String body;
  final String label;
  final String hint;
  final String privacy;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final segar = context.segarColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                color: segar.successContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.waving_hand_rounded,
                size: 60,
                color: segar.onSuccessContainer,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: context.texts.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: context.texts.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            maxLength: 24,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(labelText: label, hintText: hint),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  privacy,
                  style: context.texts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
