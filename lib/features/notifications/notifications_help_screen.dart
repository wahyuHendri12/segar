import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_header.dart';
import '../../l10n/app_localizations.dart';

class NotificationsHelpScreen extends ConsumerStatefulWidget {
  const NotificationsHelpScreen({super.key});

  @override
  ConsumerState<NotificationsHelpScreen> createState() =>
      _NotificationsHelpScreenState();
}

class _NotificationsHelpScreenState
    extends ConsumerState<NotificationsHelpScreen> {
  bool _busy = false;

  Future<void> _requestPermission() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);

    final granted = await ref
        .read(notificationServiceProvider)
        .requestPermission();
    ref.invalidate(notificationPermissionProvider);
    if (!mounted) return;
    setState(() => _busy = false);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          granted ? l10n.notifPermissionGranted : l10n.notifPermissionDenied,
        ),
      ),
    );
  }

  Future<void> _sendTest() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(notificationServiceProvider);
    setState(() => _busy = true);

    var granted = await service.hasPermission();
    if (!granted) granted = await service.requestPermission();
    if (!mounted) return;

    if (!granted) {
      setState(() => _busy = false);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.notifPermissionDenied)),
      );
      return;
    }

    final sent = await service.showTestNotification(
      title: l10n.notifTestNotificationTitle,
      body: l10n.notifTestNotificationBody,
    );
    if (!mounted) return;
    setState(() => _busy = false);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          sent
              ? l10n.notificationsHelpTestSent
              : l10n.notificationsHelpTestFailed,
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    await ref.read(notificationServiceProvider).openSystemSettings();
    if (!mounted) return;
    ref.invalidate(notificationPermissionProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final permission = ref.watch(notificationPermissionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsHelpTitle)),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: <Widget>[
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.notifications_active_outlined,
                    color: colors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.notificationsHelpIntro,
                      style: context.texts.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.notificationsHelpPermissionTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              child: permission.when(
                loading: () => const LinearProgressIndicator(minHeight: 3),
                error: (error, stackTrace) => _PermissionOff(
                  message: l10n.notificationsHelpPermissionOff,
                  busy: _busy,
                  onRequest: _requestPermission,
                ),
                data: (granted) {
                  if (granted) {
                    return _PermissionOn(
                      message: l10n.notificationsHelpPermissionOn,
                    );
                  }
                  return _PermissionOff(
                    message: l10n.notificationsHelpPermissionOff,
                    busy: _busy,
                    onRequest: _requestPermission,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.notificationsHelpStepsTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              child: Column(
                children: <Widget>[
                  _Step(number: 1, text: l10n.notificationsHelpStepPermission),
                  const SizedBox(height: AppSpacing.sm),
                  _Step(number: 2, text: l10n.notificationsHelpStepBattery),
                  const SizedBox(height: AppSpacing.sm),
                  _Step(number: 3, text: l10n.notificationsHelpStepAutostart),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.notificationsHelpBrandsTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              child: Text(
                l10n.notificationsHelpBrandsBody,
                style: context.texts.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: l10n.notificationsHelpTest,
              icon: Icons.send_rounded,
              expand: true,
              isLoading: _busy,
              onPressed: _sendTest,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: l10n.notificationsHelpOpenSettings,
              icon: Icons.settings_outlined,
              variant: AppButtonVariant.outline,
              expand: true,
              onPressed: _openSettings,
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionOn extends StatelessWidget {
  const _PermissionOn({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final segar = context.segarColors;
    return Row(
      children: <Widget>[
        Icon(Icons.check_circle_rounded, color: segar.success),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: context.texts.bodyMedium?.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _PermissionOff extends StatelessWidget {
  const _PermissionOff({
    required this.message,
    required this.busy,
    required this.onRequest,
  });

  final String message;
  final bool busy;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final segar = context.segarColors;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.warning_amber_rounded, color: segar.warning),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: context.texts.bodyMedium?.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.notificationsHelpEnablePermission,
          icon: Icons.notifications_none_rounded,
          variant: AppButtonVariant.tonal,
          isLoading: busy,
          onPressed: onRequest,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: context.texts.labelMedium?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: context.texts.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
