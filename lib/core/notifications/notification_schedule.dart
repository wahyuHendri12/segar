import '../../data/models/pantry_item_view.dart';
import '../utils/expiry_utils.dart';
import 'notification_settings.dart';

/// One reminder that should be registered with the OS.
class ScheduledReminder {
  const ScheduledReminder({
    required this.itemId,
    required this.itemName,
    required this.notificationId,
    required this.scheduledAt,
    required this.daysLeft,
  });

  final String itemId;
  final String itemName;
  final int notificationId;
  final DateTime scheduledAt;

  /// Calendar days between the reminder day and the expiry date.
  final int daysLeft;
}

/// Stable 31-bit notification id derived from a pantry item id.
///
/// FNV-1a keeps the id stable across app launches, so rescheduling replaces the
/// previous notification instead of duplicating it.
int notificationIdFor(String itemId) {
  var hash = 0x811c9dc5;
  for (final codeUnit in itemId.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  final id = hash & 0x7fffffff;
  return id == 0 ? 1 : id;
}

/// Whether [time] falls inside the quiet window.
///
/// A window such as 21:00–07:00 wraps around midnight. When start and end are
/// equal the quiet window is disabled.
bool isWithinQuietHours(
  DateTime time, {
  required int startHour,
  required int endHour,
}) {
  if (startHour == endHour) return false;
  final hour = time.hour;
  if (startHour < endHour) {
    return hour >= startHour && hour < endHour;
  }
  return hour >= startHour || hour < endHour;
}

/// Moves a reminder out of the quiet window to the first allowed hour.
DateTime adjustForQuietHours(
  DateTime time, {
  required int startHour,
  required int endHour,
}) {
  if (!isWithinQuietHours(time, startHour: startHour, endHour: endHour)) {
    return time;
  }

  final sameDayEnd = DateTime(
    time.year,
    time.month,
    time.day,
    endHour,
    time.minute,
  );
  if (startHour < endHour) return sameDayEnd;
  if (time.hour >= startHour) {
    return sameDayEnd.add(const Duration(days: 1));
  }
  return sameDayEnd;
}

/// Computes the next time a reminder should fire for one expiry date.
///
/// Rules:
/// * reminders start [NotificationSettings.warnDays] days before expiry at the
///   configured hour;
/// * an item already inside the warning window is reminded at the next daily
///   slot, or shortly from now when it expires today;
/// * expired items are skipped;
/// * reminders that land in quiet hours move to the end of the window;
/// * reminders never fire after the expiry day.
DateTime? reminderTimeFor({
  required DateTime expiryDate,
  required NotificationSettings settings,
  required DateTime now,
}) {
  if (!settings.enabled) return null;

  final expiry = dateOnly(expiryDate);
  final today = dateOnly(now);
  if (expiry.isBefore(today)) return null;

  final targetDay = expiry.subtract(Duration(days: settings.warnDays));
  final preferredDay = targetDay.isAfter(today) ? targetDay : today;
  var candidate = DateTime(
    preferredDay.year,
    preferredDay.month,
    preferredDay.day,
    settings.hour,
    settings.minute,
  );

  if (!candidate.isAfter(now)) {
    if (expiry == today) {
      // The last daily slot already passed, so remind the user right away.
      candidate = now.add(const Duration(minutes: 1));
    } else {
      candidate = candidate.add(const Duration(days: 1));
    }
  }

  candidate = adjustForQuietHours(
    candidate,
    startHour: settings.quietStartHour,
    endHour: settings.quietEndHour,
  );

  final expiryEnd = expiry.add(const Duration(days: 1));
  if (!candidate.isBefore(expiryEnd)) return null;
  if (candidate.isBefore(now)) return null;
  return candidate;
}

/// Builds the reminders for the current pantry snapshot.
List<ScheduledReminder> buildReminders({
  required Iterable<PantryItemView> items,
  required NotificationSettings settings,
  required DateTime now,
}) {
  if (!settings.enabled) return const <ScheduledReminder>[];

  final reminders = <ScheduledReminder>[];
  for (final item in items) {
    if (!item.notifyEnabled) continue;
    final scheduledAt = reminderTimeFor(
      expiryDate: item.expiryDate,
      settings: settings,
      now: now,
    );
    if (scheduledAt == null) continue;
    reminders.add(
      ScheduledReminder(
        itemId: item.id,
        itemName: item.name,
        notificationId: notificationIdFor(item.id),
        scheduledAt: scheduledAt,
        daysLeft: daysUntilExpiry(item.expiryDate, now: now),
      ),
    );
  }
  return reminders;
}
