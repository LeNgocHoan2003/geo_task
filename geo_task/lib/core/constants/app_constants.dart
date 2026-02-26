/// App-wide constants for Geo-Task.
class AppConstants {
  AppConstants._();

  /// Geofence radius limits (meters).
  static const double radiusMinMeters = 50;
  static const double radiusMaxMeters = 1000;
  static const double radiusDefaultMeters = 200;

  /// Hive box name for reminders.
  static const String remindersBoxName = 'geo_reminders';

  /// Notification channel (Android).
  static const String notificationChannelId = 'geo_task_reminders';
  static const String notificationChannelName = 'Geo-Task Reminders';
}
