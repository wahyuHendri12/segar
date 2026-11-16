import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/notifications/notification_providers.dart';
import '../../core/notifications/notification_settings.dart';
import '../../core/providers/app_providers.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/section_header.dart';
import '../../data/repositories/repository_providers.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _themeLabel(AppLocalizations l10n, ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    };
  }

  Future<void> _toggleNotifications(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(notificationServiceProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    if (enabled) {
      final granted = await service.requestPermission();
      if (!context.mounted) return;
      if (!granted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.notifPermissionDenied),
            action: SnackBarAction(
              label: l10n.notifOpenSettingsAction,
              onPressed: service.openSystemSettings,
            ),
          ),
        );
        return;
      }
    }

    await notifier.setEnabled(enabled);
    if (!context.mounted || !enabled) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.notifPermissionGranted)),
    );
  }

  Future<void> _pickNotifyTime(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings settings,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
      helpText: AppLocalizations.of(context).notifTimeLabel,
    );
    if (picked == null) return;
    await ref
        .read(notificationSettingsProvider.notifier)
        .setTime(hour: picked.hour, minute: picked.minute);
  }

  Future<void> _pickQuietHour(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings settings, {
    required bool start,
  }) async {
    final initial = start ? settings.quietStartHour : settings.quietEndHour;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial, minute: 0),
      helpText: start
          ? AppLocalizations.of(context).notifQuietStart
          : AppLocalizations.of(context).notifQuietEnd,
    );
    if (picked == null) return;
    await ref
        .read(notificationSettingsProvider.notifier)
        .setQuietHours(
          startHour: start ? picked.hour : settings.quietStartHour,
          endHour: start ? settings.quietEndHour : picked.hour,
        );
  }

  Future<void> _sendTestNotification(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(notificationServiceProvider);

    var granted = await service.hasPermission();
    if (!granted) {
      granted = await service.requestPermission();
    }
    if (!context.mounted) return;

    if (!granted) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.notifPermissionDenied),
          action: SnackBarAction(
            label: l10n.notifOpenSettingsAction,
            onPressed: service.openSystemSettings,
          ),
        ),
      );
      return;
    }

    final sent = await service.showTestNotification(
      title: l10n.notifTestNotificationTitle,
      body: l10n.notifTestNotificationBody,
    );
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(sent ? l10n.notifTestSent : l10n.notifTestFailed)),
    );
  }

  String _timeLabel(int hour, int minute) => formatClock(hour, minute);

  Future<void> _clearOnlineCache(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(barcodeRepositoryProvider).clearCache();
    await ref.read(onlineRecipeRepositoryProvider).clearCache();
    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(l10n.onlineCacheCleared)));
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _NameDialog(initialName: currentName),
    );
    if (result == null || result.trim().isEmpty) return;

    await ref.read(userNameProvider.notifier).setName(result);
    if (!context.mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(l10n.profileEditSaved)));
  }

  Future<void> _resetData(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.settingsResetConfirmTitle,
      message: l10n.settingsResetConfirmBody,
      confirmLabel: l10n.settingsResetAction,
      destructive: true,
    );
    if (!confirmed) return;

    try {
      await ref.read(backupRepositoryProvider).clearAllData();
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsResetSuccess)),
      );
    } on Object {
      if (!context.mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.settingsResetFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userName = ref.watch(userNameProvider);
    final themeMode = ref.watch(themeModeProvider);
    final notifSettings = ref.watch(notificationSettingsProvider);
    final onlineBarcodeEnabled = ref.watch(onlineBarcodeEnabledProvider);
    final onlineRecipeEnabled = ref.watch(onlineRecipeEnabledProvider);
    final lastBackupAt = ref.watch(lastBackupAtProvider);
    final colors = context.colors;

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: <Widget>[
            Text(
              l10n.settingsTitle,
              style: context.texts.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.settingsSubtitle,
              style: context.texts.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              onTap: () => _editName(context, ref, userName),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primaryContainer,
                    child: Text(
                      userName.characters.first.toUpperCase(),
                      style: context.texts.titleLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userName,
                          style: context.texts.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.appTagline,
                          style: context.texts.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.themeTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.contrast_rounded),
                title: Text(l10n.themeTitle),
                subtitle: Text(_themeLabel(l10n, themeMode)),
                trailing: PopupMenuButton<ThemeMode>(
                  tooltip: l10n.themeTitle,
                  initialValue: themeMode,
                  onSelected: (mode) {
                    ref.read(themeModeProvider.notifier).setMode(mode);
                  },
                  itemBuilder: (context) {
                    return <PopupMenuEntry<ThemeMode>>[
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.system,
                        child: Text(l10n.themeSystem),
                      ),
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.light,
                        child: Text(l10n.themeLight),
                      ),
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.dark,
                        child: Text(l10n.themeDark),
                      ),
                    ];
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.onlineSectionTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  SwitchListTile.adaptive(
                    value: onlineBarcodeEnabled,
                    onChanged: (value) => ref
                        .read(onlineBarcodeEnabledProvider.notifier)
                        .setEnabled(value),
                    secondary: const Icon(Icons.qr_code_scanner_rounded),
                    title: Text(l10n.onlineBarcodeLabel),
                    subtitle: Text(l10n.onlineBarcodeBody),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs,
                    ),
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    value: onlineRecipeEnabled,
                    onChanged: (value) => ref
                        .read(onlineRecipeEnabledProvider.notifier)
                        .setEnabled(value),
                    secondary: const Icon(Icons.travel_explore_rounded),
                    title: Text(l10n.onlineRecipeLabel),
                    subtitle: Text(l10n.onlineRecipeBody),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_sweep_outlined),
                    title: Text(l10n.onlineClearCache),
                    subtitle: Text(l10n.onlineClearCacheBody),
                    onTap: () => _clearOnlineCache(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.notifSettingsTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  SwitchListTile.adaptive(
                    value: notifSettings.enabled,
                    onChanged: (value) =>
                        _toggleNotifications(context, ref, value),
                    secondary: const Icon(Icons.notifications_active_outlined),
                    title: Text(l10n.notifEnableLabel),
                    subtitle: Text(l10n.notifEnableBody),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs,
                    ),
                  ),
                  if (notifSettings.enabled) ...<Widget>[
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.schedule_rounded),
                      title: Text(l10n.notifTimeLabel),
                      subtitle: Text(l10n.notifTimeBody),
                      trailing: Text(
                        _timeLabel(notifSettings.hour, notifSettings.minute),
                        style: context.texts.titleMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () => _pickNotifyTime(context, ref, notifSettings),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.timelapse_rounded),
                      title: Text(l10n.notifWarnLabel),
                      subtitle: Text(l10n.notifWarnBody),
                      trailing: DropdownButton<int>(
                        value: notifSettings.warnDays,
                        underline: const SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        items:
                            (<int>{
                                  1,
                                  2,
                                  3,
                                  5,
                                  7,
                                  notifSettings.warnDays,
                                }.toList()..sort())
                                .map(
                                  (days) => DropdownMenuItem<int>(
                                    value: days,
                                    child: Text(l10n.notifWarnDays(days)),
                                  ),
                                )
                                .toList(growable: false),
                        onChanged: (days) {
                          if (days == null) return;
                          ref
                              .read(notificationSettingsProvider.notifier)
                              .setWarnDays(days);
                        },
                      ),
                    ),
                    const Divider(),
                    SwitchListTile.adaptive(
                      value: notifSettings.quietHoursEnabled,
                      onChanged: (value) => ref
                          .read(notificationSettingsProvider.notifier)
                          .setQuietHoursEnabled(value),
                      secondary: const Icon(Icons.nightlight_round),
                      title: Text(l10n.notifQuietTitle),
                      subtitle: Text(l10n.notifQuietBody),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xxs,
                      ),
                    ),
                    if (notifSettings.quietHoursEnabled) ...<Widget>[
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.bedtime_outlined),
                        title: Text(l10n.notifQuietStart),
                        trailing: Text(
                          _timeLabel(notifSettings.quietStartHour, 0),
                        ),
                        onTap: () => _pickQuietHour(
                          context,
                          ref,
                          notifSettings,
                          start: true,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.wb_sunny_outlined),
                        title: Text(l10n.notifQuietEnd),
                        trailing: Text(
                          _timeLabel(notifSettings.quietEndHour, 0),
                        ),
                        onTap: () => _pickQuietHour(
                          context,
                          ref,
                          notifSettings,
                          start: false,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded),
                    title: Text(l10n.notifHelpEntry),
                    subtitle: Text(l10n.notificationsHelpTitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.notificationsHelp),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.send_rounded),
                    title: Text(l10n.notifTestTitle),
                    subtitle: Text(l10n.notifTestBody),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _sendTestNotification(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.settingsDataTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.shopping_basket_outlined),
                    title: Text(l10n.shoppingListTitle),
                    subtitle: Text(l10n.settingsShoppingSubtitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.shoppingList),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.cloud_upload_outlined),
                    title: Text(l10n.backupTitle),
                    subtitle: Text(
                      lastBackupAt == null
                          ? l10n.backupNever
                          : l10n.backupLastAt(formatDateId(lastBackupAt)),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.backup),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: Text(l10n.aboutTitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(Routes.about),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.delete_forever_outlined,
                      color: colors.error,
                    ),
                    title: Text(
                      l10n.settingsResetTitle,
                      style: TextStyle(color: colors.error),
                    ),
                    subtitle: Text(l10n.settingsResetBody),
                    onTap: () => _resetData(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(title: l10n.dataPrivacyTitle),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.lock_outline_rounded, color: colors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.dataPrivacyBody,
                      style: context.texts.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: <Widget>[
                const BrandMark(size: 22),
                Text(
                  l10n.aboutVersion(AppConstants.appVersion),
                  textAlign: TextAlign.center,
                  style: context.texts.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
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

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initialName});

  final String initialName;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).profileEditRequired);
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.profileEditTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        maxLength: 24,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: l10n.profileEditLabel,
          hintText: l10n.profileEditHint,
          errorText: _error,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.genericCancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.genericSave)),
      ],
    );
  }
}
