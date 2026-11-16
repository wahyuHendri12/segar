import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/images/logo.jpg',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class SegarHeader extends StatelessWidget {
  const SegarHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.onBack,
    this.actions = const [],
    this.avatarAsset = 'assets/images/avatar_profile.jpg',
    this.onAvatarTap,
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final String avatarAsset;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBack) ...[
            _CircleIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: onBack ?? () => Navigator.maybePop(context),
              tooltip: 'Kembali',
            ),
            const SizedBox(width: 8),
            const BrandMark(size: 30),
            const SizedBox(width: 10),
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
          ] else ...[
            const BrandMark(size: 30),
            const SizedBox(width: 8),
            Text(
              'Segar',
              style: AppText.headlineSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppText.labelLarge.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              const Spacer(),
          ],
          ...actions,
          if (actions.isNotEmpty) const SizedBox(width: 4),
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: ClipOval(
                child: Image.asset(
                  avatarAsset,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 24, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}
