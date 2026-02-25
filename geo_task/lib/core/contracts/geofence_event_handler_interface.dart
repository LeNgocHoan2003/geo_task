import '../../features/reminder/domain/entities/geo_reminder.dart';

/// Single responsibility: handle a geofence transition (enter/exit) for a reminder.
/// Implementations may show a notification when the reminder's trigger type matches.
abstract class GeofenceEventHandlerInterface {
  /// Handles enter (true) or exit (false) transition for [reminder].
  /// May show notification only when [reminder.triggerType] matches the transition.
  void handleTransition(GeoReminder reminder, bool isEnter);
}
