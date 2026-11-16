class AppConstants {
  AppConstants._();

  static const appVersion = '1.0.0';
  static const defaultUserName = 'Teman Segar';
  static const backupReminderDays = 30;
  static const defaultWarnDays = 3;
  static const defaultNotifyHour = 8;
  static const defaultNotifyMinute = 0;
  static const defaultQuietStartHour = 21;
  static const defaultQuietEndHour = 7;
}

class PrefKeys {
  PrefKeys._();

  static const userName = 'userName';
  static const onboardingDone = 'onboardingDone';
  static const morningBannerDismissedDate = 'morningBannerDismissedDate';
  static const notificationsEnabled = 'notificationsEnabled';
  static const notifyHour = 'notifyHour';
  static const notifyMinute = 'notifyMinute';
  static const warnDays = 'warnDays';
  static const quietStart = 'quietStart';
  static const quietEnd = 'quietEnd';
  static const themeMode = 'themeMode';
  static const onlineBarcodeEnabled = 'onlineBarcodeEnabled';
  static const onlineRecipeEnabled = 'onlineRecipeEnabled';
  static const seedVersion = 'seedVersion';
  static const lastBackupAt = 'lastBackupAt';
}
