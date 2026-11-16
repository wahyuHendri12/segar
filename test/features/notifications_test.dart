import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:segar/app.dart';
import 'package:segar/core/notifications/notification_providers.dart';
import 'package:segar/core/providers/app_providers.dart';
import 'package:segar/core/utils/expiry_utils.dart';
import 'package:segar/data/local/database.dart';
import 'package:segar/data/local/database_provider.dart';
import 'package:segar/data/local/enums.dart';

import '../helpers/fake_notification_service.dart';
import '../helpers/test_database.dart';

class _Harness {
  const _Harness({
    required this.database,
    required this.preferences,
    required this.service,
  });

  final AppDatabase database;
  final SharedPreferences preferences;
  final FakeNotificationService service;
}

Future<_Harness> _pumpApp(
  WidgetTester tester, {
  Map<String, Object> preferences = const <String, Object>{},
  bool permissionGranted = true,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues(preferences);
  final prefs = await SharedPreferences.getInstance();
  final database = openTestDatabase();
  addTearDown(database.close);
  final service = FakeNotificationService(permissionGranted: permissionGranted);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
        notificationServiceProvider.overrideWithValue(service),
      ],
      child: const SegarApp(),
    ),
  );
  await tester.pumpAndSettle();
  return _Harness(database: database, preferences: prefs, service: service);
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.text('Profil'));
  await tester.pumpAndSettle();
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _insertItem(AppDatabase db, String id, String name) {
  final today = dateOnly(DateTime.now());
  return db
      .into(db.pantryItems)
      .insert(
        PantryItemsCompanion.insert(
          id: id,
          name: name,
          category: IngredientCategory.sayur,
          quantity: 1,
          unit: Unit.ikat,
          storageLocation: StorageLocation.kulkas,
          purchaseDate: today.subtract(const Duration(days: 1)),
          expiryDate: today.add(const Duration(days: 5)),
          expirySource: ExpirySource.estimasi,
          createdAt: today,
          updatedAt: today,
        ),
      );
}

void main() {
  testWidgets('notification settings can be disabled and persist', (
    tester,
  ) async {
    final app = await _pumpApp(
      tester,
      preferences: <String, Object>{'onboardingDone': true},
    );
    await _openSettings(tester);

    await _scrollTo(tester, find.text('Aktifkan pengingat'));
    expect(find.text('Jam pengingat'), findsOneWidget);
    expect(find.text('Jam tenang'), findsOneWidget);

    await tester.tap(find.text('Aktifkan pengingat'));
    await tester.pumpAndSettle();

    expect(find.text('Jam pengingat'), findsNothing);
    expect(find.text('Jam tenang'), findsNothing);
    expect(app.preferences.getBool('notificationsEnabled'), isFalse);

    await _dispose(tester);
  });

  testWidgets('denied permission keeps reminders disabled', (tester) async {
    final app = await _pumpApp(
      tester,
      preferences: <String, Object>{
        'onboardingDone': true,
        'notificationsEnabled': false,
      },
      permissionGranted: false,
    );
    await _openSettings(tester);

    await _scrollTo(tester, find.text('Aktifkan pengingat'));
    await tester.tap(find.text('Aktifkan pengingat'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Izin notifikasi belum diberikan. Aktifkan lewat pengaturan HP.',
      ),
      findsOneWidget,
    );
    expect(app.service.permissionRequests, 1);
    expect(app.preferences.getBool('notificationsEnabled'), isFalse);

    await _dispose(tester);
  });

  testWidgets('test notification action reports success', (tester) async {
    final app = await _pumpApp(
      tester,
      preferences: <String, Object>{'onboardingDone': true},
    );
    await _openSettings(tester);

    await _scrollTo(tester, find.text('Coba notifikasi'));
    await tester.tap(find.text('Coba notifikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Notifikasi percobaan dikirim.'), findsOneWidget);
    expect(app.service.testNotifications, 1);

    await _dispose(tester);
  });

  testWidgets('notification help screen explains the permission flow', (
    tester,
  ) async {
    final app = await _pumpApp(
      tester,
      preferences: <String, Object>{'onboardingDone': true},
    );
    await _openSettings(tester);

    await _scrollTo(tester, find.text('Panduan pengingat'));
    await tester.tap(find.text('Panduan pengingat'));
    await tester.pumpAndSettle();

    expect(find.text('Langkah cepat'), findsOneWidget);
    expect(find.text('Panduan merek HP'), findsOneWidget);
    expect(find.text('Izin notifikasi aktif.'), findsOneWidget);

    await _scrollTo(tester, find.text('Kirim notifikasi percobaan'));
    await tester.tap(find.text('Kirim notifikasi percobaan'));
    await tester.pumpAndSettle();

    expect(
      find.text('Notifikasi percobaan dikirim. Cek laci notifikasi.'),
      findsOneWidget,
    );
    expect(app.service.testNotifications, 1);

    await _dispose(tester);
  });

  testWidgets('tapping a notification opens the item detail', (tester) async {
    final app = await _pumpApp(
      tester,
      preferences: <String, Object>{'onboardingDone': true},
    );
    await _insertItem(app.database, 'item-1', 'Bayam');
    await tester.pumpAndSettle();

    app.service.emitTap('item-1');
    await tester.pumpAndSettle();

    expect(find.text('Detail Bahan'), findsOneWidget);
    expect(find.text('Bayam'), findsWidgets);

    await _dispose(tester);
  });

  testWidgets('pantry changes schedule reminders', (tester) async {
    final app = await _pumpApp(
      tester,
      preferences: <String, Object>{'onboardingDone': true},
    );

    await _insertItem(app.database, 'item-2', 'Wortel');
    await tester.pumpAndSettle();

    expect(app.service.cancelCount, greaterThan(0));
    expect(
      app.service.scheduled.any((call) => call.itemId == 'item-2'),
      isTrue,
    );

    await _dispose(tester);
  });
}
