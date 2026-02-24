import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_constants.dart';
import '../contracts/notification_service_interface.dart';
import '../utils/logger.dart';

/// Shows local notifications when a geofence is triggered.
/// Implements [NotificationServiceInterface] for dependency inversion (SOLID).
class NotificationService implements NotificationServiceInterface {
  NotificationService() {
    _plugin = FlutterLocalNotificationsPlugin();
  }

  late final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  /// Request notification permission (required on Android 13+).
  /// Call this before showing notifications; [initialize] calls it on Android.
  static Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.notification.request();
    final granted = status.isGranted;
    if (!granted) {
      logInfo('Notification permission not granted: $status');
    }
    return granted;
  }

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    const androidChannel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: 'Notifications when you enter or leave a reminder location.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Android 13+ (API 33+): must request POST_NOTIFICATIONS at runtime or notifications won't show
    await requestPermission();

    _initialized = true;
    logInfo('NotificationService initialized');
  }

  void _onNotificationTapped(NotificationResponse response) {
    logInfo('Notification tapped', response.payload);
    // TODO: optionally navigate to reminder detail when app opens from notification
  }

  @override
  Future<void> showReminder({
    required int id,
    required String title,
    String body = '',
  }) async {
    if (!_initialized) await initialize();
    if (Platform.isAndroid) await requestPermission();

    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription:
          'Notifications when you enter or leave a reminder location.',
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use reminder title for both title and fallback body so the title is always visible
    final content = body.isNotEmpty ? body : title;
    await _plugin.show(id, title, content, details);
    logInfo('Notification shown: $title');
  }
}
