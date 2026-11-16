import 'dart:async';

import 'package:segar/core/notifications/notification_service.dart';

class ScheduledCall {
  const ScheduledCall({
    required this.id,
    required this.itemId,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  final int id;
  final String itemId;
  final String title;
  final String body;
  final DateTime scheduledAt;
}

/// Test double that records scheduling calls without touching the platform.
class FakeNotificationService extends NotificationService {
  FakeNotificationService({this.permissionGranted = true});

  bool permissionGranted;
  bool testNotificationResult = true;
  int cancelCount = 0;
  int permissionRequests = 0;
  int testNotifications = 0;
  int openSettingsCount = 0;
  final List<ScheduledCall> scheduled = <ScheduledCall>[];
  final StreamController<String> _tapController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get taps => _tapController.stream;

  void emitTap(String itemId) => _tapController.add(itemId);

  @override
  Future<void> dispose() async {
    await _tapController.close();
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<void> openSystemSettings() async {
    openSettingsCount++;
  }

  @override
  Future<void> cancelPending() async {
    cancelCount++;
  }

  @override
  Future<void> scheduleReminder({
    required int id,
    required String itemId,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    scheduled.add(
      ScheduledCall(
        id: id,
        itemId: itemId,
        title: title,
        body: body,
        scheduledAt: scheduledAt,
      ),
    );
  }

  @override
  Future<bool> showTestNotification({
    required String title,
    required String body,
  }) async {
    testNotifications++;
    return testNotificationResult;
  }
}
