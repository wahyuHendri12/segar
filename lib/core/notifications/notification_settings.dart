import '../constants/app_constants.dart';

/// User preferences for local expiry reminders.
///
/// Kept as plain integers instead of [TimeOfDay] so the scheduling logic can be
/// unit tested without a Flutter binding.
class NotificationSettings {
  const NotificationSettings({
    this.enabled = true,
    this.hour = AppConstants.defaultNotifyHour,
    this.minute = AppConstants.defaultNotifyMinute,
    this.warnDays = AppConstants.defaultWarnDays,
    this.quietStartHour = AppConstants.defaultQuietStartHour,
    this.quietEndHour = AppConstants.defaultQuietEndHour,
  });

  final bool enabled;
  final int hour;
  final int minute;
  final int warnDays;
  final int quietStartHour;
  final int quietEndHour;

  /// Quiet hours are disabled when the start and end hour are the same.
  bool get quietHoursEnabled => quietStartHour != quietEndHour;

  NotificationSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    int? warnDays,
    int? quietStartHour,
    int? quietEndHour,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      warnDays: warnDays ?? this.warnDays,
      quietStartHour: quietStartHour ?? this.quietStartHour,
      quietEndHour: quietEndHour ?? this.quietEndHour,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NotificationSettings &&
        other.enabled == enabled &&
        other.hour == hour &&
        other.minute == minute &&
        other.warnDays == warnDays &&
        other.quietStartHour == quietStartHour &&
        other.quietEndHour == quietEndHour;
  }

  @override
  int get hashCode => Object.hash(
    enabled,
    hour,
    minute,
    warnDays,
    quietStartHour,
    quietEndHour,
  );
}
