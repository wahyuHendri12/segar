import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_providers.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/section_header.dart';
import '../../data/backup/backup_payload.dart';
import '../../data/repositories/repository_providers.dart';
import '../../l10n/app_localizations.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  Future<void> _exportBackup() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(backupRepositoryProvider);
    final fileService = ref.read(backupFileServiceProvider);

    setState(() => _busy = true);
    try {
      final json = await repository.exportJson();
      final now = DateTime.now();
      await fileService.shareBackup(
        json: json,
        fileName: 'segar-backup-${dateKey(now)}.json',
        subject: l10n.backupFileSubject,
      );
      await ref.read(lastBackupAtProvider.notifier).markNow();
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupExportSuccess)));
    } on Object {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupExportFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restoreBackup() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(backupRepositoryProvider);
    final fileService = ref.read(backupFileServiceProvider);

    final String? source;
    try {
      source = await fileService.pickBackupJson();
    } on Object {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupRestoreFailed)));
      return;
    }
    if (source == null) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.backupRestoreCancelled)),
      );
      return;
    }

    final BackupPayload payload;
    try {
      payload = repository.parse(source);
    } on Object {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.backupRestoreInvalid)),
      );
      return;
    }

    if (!mounted) return;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.backupRestoreConfirmTitle,
      message: l10n.backupRestoreConfirmBody(
        payload.pantryItems.length,
        payload.usageLogs.length,
        payload.shoppingList.length,
      ),
      confirmLabel: l10n.backupRestoreAction,
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    try {
      await repository.restore(payload);
      _refreshSettings();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.backupRestoreSuccess)),
      );
    } on Object {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupRestoreFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _refreshSettings() {
    ref.invalidate(userNameProvider);
    ref.invalidate(themeModeProvider);
    ref.invalidate(onlineBarcodeEnabledProvider);
    ref.invalidate(onlineRecipeEnabledProvider);
    ref.invalidate(notificationSettingsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final lastBackupAt = ref.watch(lastBackupAtProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: <Widget>[
            Text(
              l10n.backupSubtitle,
              style: context.texts.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Row(
                children: <Widget>[
                  Icon(Icons.shield_outlined, color: colors.primary, size: 28),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          lastBackupAt == null
                              ? l10n.backupNever
                              : l10n.backupLastAt(formatDateId(lastBackupAt)),
                          style: context.texts.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.dataPrivacyBody,
                          style: context.texts.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.backupExportTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.backupExportBody,
                    style: context.texts.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: l10n.backupExportAction,
                    icon: Icons.ios_share_rounded,
                    expand: true,
                    isLoading: _busy,
                    onPressed: _busy ? null : _exportBackup,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.backupRestoreTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.backupRestoreBody,
                    style: context.texts.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: l10n.backupRestoreAction,
                    icon: Icons.file_open_outlined,
                    variant: AppButtonVariant.outline,
                    expand: true,
                    isLoading: _busy,
                    onPressed: _busy ? null : _restoreBackup,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Text(
                    l10n.onboardingPrivacy,
                    style: context.texts.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
