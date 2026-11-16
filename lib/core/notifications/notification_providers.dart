import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/pantry_item_view.dart';
import '../../features/home/home_providers.dart';
import '../constants/app_constants.dart';
import '../providers/app_providers.dart';
import 'notification_scheduler.dart';
import 'notification_service.dart';
import 'notification_settings.dart';

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  NotificationSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return NotificationSettings(
      enabled: prefs.getBool(PrefKeys.notificationsEnabled) ?? true,
      hour: prefs.getInt(PrefKeys.notifyHour) ?? AppConstants.defaultNotifyHour,
      minute:
          prefs.getInt(PrefKeys.notifyMinute) ??
          AppConstants.defaultNotifyMinute,
      warnDays: prefs.getInt(PrefKeys.warnDays) ?? AppConstants.defaultWarnDays,
      quietStartHour:
          prefs.getInt(PrefKeys.quietStart) ??
          AppConstants.defaultQuietStartHour,
      quietEndHour:
          prefs.getInt(PrefKeys.quietEnd) ?? AppConstants.defaultQuietEndHour,
    );
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await _prefs.setBool(PrefKeys.notificationsEnabled, enabled);
  }

  Future<void> setTime({required int hour, required int minute}) async {
    state = state.copyWith(hour: hour, minute: minute);
    await _prefs.setInt(PrefKeys.notifyHour, hour);
    await _prefs.setInt(PrefKeys.notifyMinute, minute);
  }

  Future<void> setWarnDays(int days) async {
    state = state.copyWith(warnDays: days);
    await _prefs.setInt(PrefKeys.warnDays, days);
  }

  Future<void> setQuietHours({
    required int startHour,
    required int endHour,
  }) async {
    state = state.copyWith(quietStartHour: startHour, quietEndHour: endHour);
    await _prefs.setInt(PrefKeys.quietStart, startHour);
    await _prefs.setInt(PrefKeys.quietEnd, endHour);
  }

  Future<void> setQuietHoursEnabled(bool enabled) {
    if (enabled) {
      return setQuietHours(
        startHour: AppConstants.defaultQuietStartHour,
        endHour: AppConstants.defaultQuietEndHour,
      );
    }
    return setQuietHours(startHour: 0, endHour: 0);
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
      NotificationSettingsNotifier.new,
    );

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
});

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NotificationScheduler(service: ref.watch(notificationServiceProvider));
});

final notificationPermissionProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(notificationServiceProvider).hasPermission();
});

/// Side-effect provider that mirrors the pantry and notification settings into
/// the OS scheduler. Watch it once from the app root so it stays alive.
final notificationSyncProvider = Provider<void>((ref) {
  void syncWith(List<PantryItemView> items) {
    final settings = ref.read(notificationSettingsProvider);
    unawaited(
      ref
          .read(notificationSchedulerProvider)
          .sync(items: items, settings: settings),
    );
  }

  ref.listen<AsyncValue<List<PantryItemView>>>(allPantryItemsProvider, (
    previous,
    next,
  ) {
    final items = next.value;
    if (items != null) syncWith(items);
  }, fireImmediately: true);

  ref.listen<NotificationSettings>(notificationSettingsProvider, (
    previous,
    next,
  ) {
    final items = ref.read(allPantryItemsProvider).value;
    if (items != null) syncWith(items);
  }, fireImmediately: true);
});
