import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
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
  Uint8List? _logoBytes;

  Future<Uint8List?> _loadLogoBytes() async {
    if (_logoBytes != null) {
      logInfo('[NotificationService] logo already cached');
      return _logoBytes;
    }
    try {
      logInfo('[NotificationService] loading app logo from assets...');
      final data = await rootBundle.load('assets/app_logo.png');
      _logoBytes = data.buffer
          .asUint8List(data.offsetInBytes, data.lengthInBytes);
      logInfo('[NotificationService] logo loaded (${_logoBytes!.length} bytes)');
      return _logoBytes;
    } catch (e) {
      logInfo('[NotificationService] failed to load logo: $e');
      return null;
    }
  }

  /// Request notification permission (required on Android 13+).
  /// Call this before showing notifications; [initialize] calls it on Android.
  static Future<bool> requestPermission() async {
    if (!Platform.isAndroid) {
      logInfo('[NotificationService] not Android, skipping permission');
      return true;
    }
    logInfo('[NotificationService] requestPermission() called');
    final status = await Permission.notification.request();
    final granted = status.isGranted;
    if (!granted) {
      logInfo('[NotificationService] permission not granted: $status');
    } else {
      logInfo('[NotificationService] permission granted');
    }
    return granted;
  }

  @override
  Future<void> initialize() async {
    logInfo('[NotificationService] initialize() called');
    if (_initialized) {
      logInfo('[NotificationService] already initialized');
      return;
    }

    logInfo('[NotificationService] initializing plugin...');
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification_map');
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
    logInfo('[NotificationService] plugin initialized');

    logInfo('[NotificationService] creating notification channel...');
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
    logInfo('[NotificationService] notification channel created');

    // Android 13+ (API 33+): must request POST_NOTIFICATIONS at runtime or notifications won't show
    await requestPermission();

    _initialized = true;
    logInfo('[NotificationService] initialized');
  }

  void _onNotificationTapped(NotificationResponse response) {
    logInfo('[NotificationService] notification tapped: id=${response.id} payload=${response.payload}');
    // TODO: optionally navigate to reminder detail when app opens from notification
  }

  @override
  Future<void> showReminder({
    required int id,
    required String title,
    String body = '',
  }) async {
    logInfo('[NotificationService] showReminder() called: id=$id title="$title"');
    if (!_initialized) await initialize();
    if (Platform.isAndroid) await requestPermission();

    final largeIcon = Platform.isAndroid
        ? (await _loadLogoBytes()) != null
            ? ByteArrayAndroidBitmap(_logoBytes!)
            : null
        : null;

    final androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription:
          'Notifications when you enter or leave a reminder location.',
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
      playSound: true,
      enableVibration: true,
      icon: '@drawable/ic_notification_map',
      largeIcon: largeIcon,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use reminder title for both title and fallback body so the title is always visible
    final content = body.isNotEmpty ? body : title;
    await _plugin.show(id, title, content, details);
    logInfo('[NotificationService] notification shown: id=$id title="$title"');
  }
}
