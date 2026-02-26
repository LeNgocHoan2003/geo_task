/// Contract for showing local notifications (e.g. when a geofence triggers).
abstract class NotificationServiceInterface {
  /// Initializes the notification plugin and channel. Call before showing notifications.
  Future<void> initialize();

  /// Shows a reminder notification with [title] and [body].
  Future<void> showReminder({
    required int id,
    required String title,
    String body = '',
  });
}
