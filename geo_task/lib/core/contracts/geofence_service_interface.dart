import '../../features/reminder/domain/entities/geo_reminder.dart';

/// Contract for native geofencing (monitor enter/exit of regions).
abstract class GeofenceServiceInterface {
  /// Whether the service is currently running.
  bool get isRunning;

  /// Starts the service and registers [activeReminders] as geofence regions.
  Future<void> start(List<GeoReminder> activeReminders);

  /// Adds one reminder's geofence (service must already be started).
  Future<void> addReminder(GeoReminder reminder);

  /// Removes the geofence for reminder [id].
  Future<void> removeReminder(String id);

  /// Syncs geofences to match the given [reminders] list.
  Future<void> syncReminders(List<GeoReminder> reminders);

  /// Stops the service and clears all regions.
  Future<void> stop();
}
