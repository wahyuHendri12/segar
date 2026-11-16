import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Thin wrapper around `flutter_local_notifications`.
///
/// The service is defensive on purpose: widget tests and unsupported platforms
/// do not have the native plugin, so every platform call is guarded and simply
/// becomes a no-op when notifications are unavailable.
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const channelId = 'segar_expiry_reminders';
  static const _testNotificationId = 999999;

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String> _tapController =
      StreamController<String>.broadcast();

  Future<void>? _initializeFuture;
  bool _ready = false;
  String? _initialPayload;

  /// Payload from a notification that launched the app from a terminated state.
  String? get initialPayload => _initialPayload;

  /// Item ids carried by notifications the user taps while the app is running.
  Stream<String> get taps => _tapController.stream;

  bool get isAvailable => _ready;

  void clearInitialPayload() => _initialPayload = null;

  Future<void> initialize() => _initializeFuture ??= _initialize();

  Future<void> _initialize() async {
    try {
      tz_data.initializeTimeZones();
      try {
        final local = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(local.identifier));
      } on Object {
        // Keep the default timezone when the platform channel is unavailable.
      }

      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          channelId,
          'Pengingat kesegaran',
          description: 'Pengingat bahan yang mendekati basi.',
          importance: Importance.high,
        ),
      );

      final initialized = await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: _onNotificationTap,
      );
      _ready = initialized ?? false;

      final launch = await _plugin.getNotificationAppLaunchDetails();
      final payload = launch?.notificationResponse?.payload;
      if ((launch?.didNotificationLaunchApp ?? false) &&
          payload != null &&
          payload.isNotEmpty) {
        _initialPayload = payload;
      }
    } on Object catch (error) {
      _ready = false;
      debugPrint('Notifikasi lokal tidak tersedia: $error');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty || _tapController.isClosed) return;
    _tapController.add(payload);
  }

  /// Asks the OS for notification permission.
  ///
  /// Returns `true` when notifications are allowed afterwards.
  Future<bool> requestPermission() async {
    await initialize();
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        final granted = await android.requestNotificationsPermission();
        return granted ?? true;
      }

      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        final granted = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> hasPermission() async {
    await initialize();
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        return await android.areNotificationsEnabled() ?? false;
      }

      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        final options = await ios.checkPermissions();
        if (options == null) return true;
        return options.isEnabled || options.isProvisionalEnabled;
      }
      return true;
    } on Object {
      return false;
    }
  }

  /// Opens the OS page where the user can grant notification permission.
  Future<void> openSystemSettings() async {
    try {
      await openAppSettings();
    } on Object catch (error) {
      debugPrint('Gagal membuka pengaturan aplikasi: $error');
    }
  }

  Future<void> scheduleReminder({
    required int id,
    required String itemId,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    await initialize();
    if (!_ready) return;

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: itemId,
      );
    } on Object catch (error) {
      debugPrint('Gagal menjadwalkan notifikasi: $error');
    }
  }

  Future<void> cancelPending() async {
    await initialize();
    if (!_ready) return;
    try {
      await _plugin.cancelAllPendingNotifications();
    } on Object catch (error) {
      debugPrint('Gagal membatalkan notifikasi: $error');
    }
  }

  Future<bool> showTestNotification({
    required String title,
    required String body,
  }) async {
    await initialize();
    if (!_ready) return false;
    try {
      await _plugin.show(
        id: _testNotificationId,
        title: title,
        body: body,
        notificationDetails: _details,
      );
      return true;
    } on Object catch (error) {
      debugPrint('Gagal menampilkan notifikasi percobaan: $error');
      return false;
    }
  }

  Future<void> dispose() async {
    await _tapController.close();
  }

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      'Pengingat kesegaran',
      channelDescription: 'Pengingat bahan yang mendekati basi.',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );
}
