import 'dart:ui' show Locale;

import '../../data/models/pantry_item_view.dart';
import '../../l10n/app_localizations.dart';
import 'notification_schedule.dart';
import 'notification_service.dart';
import 'notification_settings.dart';

/// Turns pantry items into OS-level reminders and keeps them in sync.
class NotificationScheduler {
  NotificationScheduler({
    required this.service,
    AppLocalizations? localizations,
    DateTime Function()? clock,
  }) : _l10n = localizations ?? lookupAppLocalizations(const Locale('id')),
       _clock = clock ?? DateTime.now;

  final NotificationService service;
  final AppLocalizations _l10n;
  final DateTime Function() _clock;

  Future<void>? _queue;

  /// Serializes syncs so two quick pantry writes cannot interleave their
  /// cancel/reschedule calls.
  Future<void> sync({
    required List<PantryItemView> items,
    required NotificationSettings settings,
  }) {
    final next = (_queue ?? Future<void>.value()).then(
      (_) => _sync(items, settings),
    );
    _queue = next.catchError((Object _) {});
    return next;
  }

  Future<void> _sync(
    List<PantryItemView> items,
    NotificationSettings settings,
  ) async {
    await service.cancelPending();
    if (!settings.enabled) return;

    final reminders = buildReminders(
      items: items,
      settings: settings,
      now: _clock(),
    );
    for (final reminder in reminders) {
      final content = _contentFor(reminder);
      await service.scheduleReminder(
        id: reminder.notificationId,
        itemId: reminder.itemId,
        title: content.title,
        body: content.body,
        scheduledAt: reminder.scheduledAt,
      );
    }
  }

  _NotificationContent _contentFor(ScheduledReminder reminder) {
    if (reminder.daysLeft <= 0) {
      return _NotificationContent(
        title: _l10n.notifTitleToday(reminder.itemName),
        body: _l10n.notifBodyToday,
      );
    }
    return _NotificationContent(
      title: _l10n.notifTitleSoon(reminder.itemName),
      body: _l10n.notifBodySoon(reminder.daysLeft),
    );
  }
}

class _NotificationContent {
  const _NotificationContent({required this.title, required this.body});

  final String title;
  final String body;
}
