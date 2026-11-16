import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/notifications/notification_scheduler.dart';
import 'package:segar/core/notifications/notification_settings.dart';
import 'package:segar/core/utils/expiry_utils.dart';
import 'package:segar/data/local/enums.dart';
import 'package:segar/data/models/pantry_item_view.dart';

import '../helpers/fake_notification_service.dart';

PantryItemView _item({
  required String id,
  required String name,
  required DateTime expiryDate,
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
    notifyEnabled: true,
    status: PantryStatus.aktif,
    createdAt: now,
    updatedAt: now,
    expiryStatus: statusFor(expiryDate, now: now),
    daysLeft: daysUntilExpiry(expiryDate, now: now),
  );
}

void main() {
  final now = DateTime(2026, 11, 10, 10);

  test('cancels pending reminders and schedules the pantry', () async {
    final service = FakeNotificationService();
    final scheduler = NotificationScheduler(service: service, clock: () => now);

    await scheduler.sync(
      items: <PantryItemView>[
        _item(id: 'a', name: 'Bayam', expiryDate: DateTime(2026, 11, 20)),
        _item(id: 'b', name: 'Tempe', expiryDate: DateTime(2026, 11, 10)),
      ],
      settings: const NotificationSettings(),
    );

    expect(service.cancelCount, 1);
    expect(service.scheduled, hasLength(2));

    final bayam = service.scheduled.first;
    expect(bayam.itemId, 'a');
    expect(bayam.title, 'Bayam segera basi');
    expect(bayam.body, 'Tinggal 10 hari. Yuk pakai sebelum terbuang.');
    expect(bayam.scheduledAt, DateTime(2026, 11, 17, 8));

    final tempe = service.scheduled.last;
    expect(tempe.title, 'Tempe basi hari ini');
    expect(tempe.body, 'Segera pakai atau olah bahan ini hari ini.');
  });

  test('only cancels pending reminders when disabled', () async {
    final service = FakeNotificationService();
    final scheduler = NotificationScheduler(service: service, clock: () => now);

    await scheduler.sync(
      items: <PantryItemView>[
        _item(id: 'a', name: 'Bayam', expiryDate: DateTime(2026, 11, 20)),
      ],
      settings: const NotificationSettings(enabled: false),
    );

    expect(service.cancelCount, 1);
    expect(service.scheduled, isEmpty);
  });

  test('serializes overlapping syncs', () async {
    final service = FakeNotificationService();
    final scheduler = NotificationScheduler(service: service, clock: () => now);

    await Future.wait(<Future<void>>[
      scheduler.sync(
        items: <PantryItemView>[
          _item(id: 'a', name: 'Bayam', expiryDate: DateTime(2026, 11, 20)),
        ],
        settings: const NotificationSettings(),
      ),
      scheduler.sync(
        items: const <PantryItemView>[],
        settings: const NotificationSettings(),
      ),
    ]);

    expect(service.cancelCount, 2);
    expect(service.scheduled, hasLength(1));
  });
}
