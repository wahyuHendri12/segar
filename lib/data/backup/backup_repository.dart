import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../local/database.dart';
import 'backup_payload.dart';

/// Reads and writes the local database snapshot used by backup/restore.
class BackupRepository {
  BackupRepository({
    required this.database,
    required this.preferences,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase database;
  final SharedPreferences preferences;
  final DateTime Function() _clock;

  Future<BackupPayload> exportData() async {
    return BackupPayload(
      exportedAt: _clock(),
      appVersion: AppConstants.appVersion,
      pantryItems: await database.pantryDao.getAll(),
      usageLogs: await database.usageLogDao.getAll(),
      shoppingList: await database.shoppingListDao.getAll(),
      settings: _readSettings(),
    );
  }

  Future<String> exportJson() async => (await exportData()).encode();

  BackupPayload parse(String source) => BackupPayload.decode(source);

  Future<void> restore(BackupPayload payload) async {
    await database.transaction(() async {
      await database.delete(database.usageLogs).go();
      await database.delete(database.shoppingListItems).go();
      await database.delete(database.pantryItems).go();

      await database.batch((batch) {
        batch.insertAll(database.pantryItems, payload.pantryItems);
        batch.insertAll(database.usageLogs, payload.usageLogs);
        batch.insertAll(database.shoppingListItems, payload.shoppingList);
      });
    });

    await _applySettings(payload.settings);
  }

  /// Removes all user-created rows and optional online caches.
  ///
  /// Preferences are intentionally kept so the app does not forget the theme
  /// or reminder configuration.
  Future<void> clearAllData() async {
    await database.transaction(() async {
      await database.delete(database.usageLogs).go();
      await database.delete(database.shoppingListItems).go();
      await database.delete(database.pantryItems).go();
    });
    await database.barcodeCacheDao.clear();
    await database.onlineRecipeDao.clear();
  }

  BackupSettings _readSettings() {
    return BackupSettings(
      userName: preferences.getString(PrefKeys.userName),
      themeMode: preferences.getString(PrefKeys.themeMode),
      notificationsEnabled: preferences.getBool(PrefKeys.notificationsEnabled),
      notifyHour: preferences.getInt(PrefKeys.notifyHour),
      notifyMinute: preferences.getInt(PrefKeys.notifyMinute),
      warnDays: preferences.getInt(PrefKeys.warnDays),
      quietStartHour: preferences.getInt(PrefKeys.quietStart),
      quietEndHour: preferences.getInt(PrefKeys.quietEnd),
      onlineBarcodeEnabled: preferences.getBool(PrefKeys.onlineBarcodeEnabled),
      onlineRecipeEnabled: preferences.getBool(PrefKeys.onlineRecipeEnabled),
    );
  }

  Future<void> _applySettings(BackupSettings settings) async {
    final userName = settings.userName?.trim();
    if (userName != null && userName.isNotEmpty) {
      await preferences.setString(PrefKeys.userName, userName);
    }
    if (settings.themeMode != null) {
      await preferences.setString(PrefKeys.themeMode, settings.themeMode!);
    }
    if (settings.notificationsEnabled != null) {
      await preferences.setBool(
        PrefKeys.notificationsEnabled,
        settings.notificationsEnabled!,
      );
    }
    if (settings.notifyHour != null) {
      await preferences.setInt(PrefKeys.notifyHour, settings.notifyHour!);
    }
    if (settings.notifyMinute != null) {
      await preferences.setInt(PrefKeys.notifyMinute, settings.notifyMinute!);
    }
    if (settings.warnDays != null) {
      await preferences.setInt(PrefKeys.warnDays, settings.warnDays!);
    }
    if (settings.quietStartHour != null) {
      await preferences.setInt(PrefKeys.quietStart, settings.quietStartHour!);
    }
    if (settings.quietEndHour != null) {
      await preferences.setInt(PrefKeys.quietEnd, settings.quietEndHour!);
    }
    if (settings.onlineBarcodeEnabled != null) {
      await preferences.setBool(
        PrefKeys.onlineBarcodeEnabled,
        settings.onlineBarcodeEnabled!,
      );
    }
    if (settings.onlineRecipeEnabled != null) {
      await preferences.setBool(
        PrefKeys.onlineRecipeEnabled,
        settings.onlineRecipeEnabled!,
      );
    }
  }
}
