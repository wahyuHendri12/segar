import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/notifications/notification_schedule.dart';
import 'package:segar/core/notifications/notification_settings.dart';
import 'package:segar/core/utils/expiry_utils.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/pantry_item_view.dart';

PantryItemView _item({
  required String id,
  required String name,
  required DateTime expiryDate,
  bool notifyEnabled = true,
}) {
  final now = DateTime(2026, 11, 10);
  return PantryItemView(
    id: id,
    name: name,
    emoji: '🥬',
    category: IngredientCategory.sayur,
    quantity: 1,
    unit: Unit.ikat,
    storageLocation: StorageLocation.kulkas,
    purchaseDate: DateTime(2026, 11, 1),
    expiryDate: expiryDate,
    expirySource: ExpirySource.estimasi,
    notifyEnabled: notifyEnabled,
    status: PantryStatus.aktif,
    createdAt: now,
    updatedAt: now,
    expiryStatus: statusFor(expiryDate, now: now),
    daysLeft: daysUntilExpiry(expiryDate, now: now),
  );
}

void main() {
  final now = DateTime(2026, 11, 10, 10);
  const settings = NotificationSettings();

  group('notificationIdFor', () {
    test('is stable and positive', () {
      final first = notificationIdFor('item-123');
      final second = notificationIdFor('item-123');
      expect(first, second);
      expect(first, greaterThan(0));
    });

    test('differs between item ids', () {
      expect(notificationIdFor('a'), isNot(notificationIdFor('b')));
    });
  });

  group('quiet hours', () {
    test('detects a window that wraps midnight', () {
      expect(
        isWithinQuietHours(
          DateTime(2026, 11, 10, 22),
          startHour: 21,
          endHour: 7,
        ),
        isTrue,
      );
      expect(
        isWithinQuietHours(
          DateTime(2026, 11, 10, 6),
          startHour: 21,
          endHour: 7,
        ),
        isTrue,
      );
      expect(
        isWithinQuietHours(
          DateTime(2026, 11, 10, 8),
          startHour: 21,
          endHour: 7,
        ),
        isFalse,
      );
    });

    test('is disabled when start and end are equal', () {
      expect(
        isWithinQuietHours(
          DateTime(2026, 11, 10, 22),
          startHour: 0,
          endHour: 0,
        ),
        isFalse,
      );
    });

    test('moves an evening reminder to the next morning', () {
      final adjusted = adjustForQuietHours(
        DateTime(2026, 11, 17, 22, 30),
        startHour: 21,
        endHour: 7,
      );
      expect(adjusted, DateTime(2026, 11, 18, 7, 30));
    });

    test('moves an early reminder to the same morning', () {
      final adjusted = adjustForQuietHours(
        DateTime(2026, 11, 17, 5),
        startHour: 21,
        endHour: 7,
      );
      expect(adjusted, DateTime(2026, 11, 17, 7));
    });
  });

  group('reminderTimeFor', () {
    test('schedules on the warn-days boundary at the configured hour', () {
      final result = reminderTimeFor(
        expiryDate: DateTime(2026, 11, 20),
        settings: settings,
        now: now,
      );
      expect(result, DateTime(2026, 11, 17, 8));
    });

    test('uses the next daily slot when already inside the warning window', () {
      final result = reminderTimeFor(
        expiryDate: DateTime(2026, 11, 12),
        settings: settings,
        now: now,
      );
      expect(result, DateTime(2026, 11, 11, 8));
    });

    test('reminds shortly from now when the item expires today', () {
      final result = reminderTimeFor(
        expiryDate: DateTime(2026, 11, 10),
        settings: settings,
        now: now,
      );
      expect(result, DateTime(2026, 11, 10, 10, 1));
    });

    test('skips items that already expired', () {
      expect(
        reminderTimeFor(
          expiryDate: DateTime(2026, 11, 9),
          settings: settings,
          now: now,
        ),
        isNull,
      );
    });

    test('skips everything when notifications are disabled', () {
      expect(
        reminderTimeFor(
          expiryDate: DateTime(2026, 11, 20),
          settings: settings.copyWith(enabled: false),
          now: now,
        ),
        isNull,
      );
    });

    test('moves a reminder that lands in quiet hours', () {
      final result = reminderTimeFor(
        expiryDate: DateTime(2026, 11, 20),
        settings: settings.copyWith(hour: 22),
        now: now,
      );
      expect(result, DateTime(2026, 11, 18, 7));
    });

    test('never schedules after the expiry day', () {
      final result = reminderTimeFor(
        expiryDate: DateTime(2026, 11, 10),
        settings: settings.copyWith(hour: 22),
        now: DateTime(2026, 11, 10, 22),
      );
      expect(result, isNull);
    });
  });

  group('buildReminders', () {
    test('keeps only notify-enabled items', () {
      final reminders = buildReminders(
        items: <PantryItemView>[
          _item(id: 'a', name: 'Bayam', expiryDate: DateTime(2026, 11, 20)),
          _item(
            id: 'b',
            name: 'Tempe',
            expiryDate: DateTime(2026, 11, 20),
            notifyEnabled: false,
          ),
          _item(id: 'c', name: 'Ayam', expiryDate: DateTime(2026, 11, 8)),
        ],
        settings: settings,
        now: now,
      );

      expect(reminders, hasLength(1));
      expect(reminders.single.itemId, 'a');
      expect(reminders.single.itemName, 'Bayam');
      expect(reminders.single.notificationId, notificationIdFor('a'));
      expect(reminders.single.daysLeft, 10);
    });

    test('returns nothing when notifications are disabled', () {
      final reminders = buildReminders(
        items: <PantryItemView>[
          _item(id: 'a', name: 'Bayam', expiryDate: DateTime(2026, 11, 20)),
        ],
        settings: settings.copyWith(enabled: false),
        now: now,
      );
      expect(reminders, isEmpty);
    });
  });
}
