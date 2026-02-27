import '../../../../core/contracts/geofence_service_interface.dart';
import '../../../../core/contracts/notification_service_interface.dart';
import '../entities/geo_reminder.dart';

/// Domain-level orchestration for reminder side effects.
/// Keeps geofence and notification behavior out of the ViewModel.
class ReminderDomainService {
  ReminderDomainService({
    required GeofenceServiceInterface geofenceService,
    required NotificationServiceInterface notificationService,
  })  : _geofenceService = geofenceService,
        _notificationService = notificationService;

  final GeofenceServiceInterface _geofenceService;
  final NotificationServiceInterface _notificationService;

  /// Called after reminders are initially loaded.
  Future<void> onRemindersLoaded(List<GeoReminder> reminders) async {
    await _geofenceService.syncReminders(reminders);
  }

  /// Called after a reminder is created and added to the in-memory list.
  Future<void> onReminderAdded(
    List<GeoReminder> allReminders,
    GeoReminder added,
  ) async {
    if (!added.isActive) return;
    // Full sync so native geofence client picks up first region
    // (fixes cold start with 0 reminders).
    await _geofenceService.syncReminders(allReminders);
  }

  /// Called after a reminder is updated in the in-memory list.
  Future<void> onReminderUpdated(List<GeoReminder> allReminders) async {
    await _geofenceService.syncReminders(allReminders);
  }

  /// Called after a reminder is toggled in the in-memory list.
  Future<void> onReminderToggled(List<GeoReminder> allReminders) async {
    await _geofenceService.syncReminders(allReminders);
  }

  /// Called after a reminder is deleted from persistence and in-memory list.
  Future<void> onReminderDeleted(String id) async {
    await _geofenceService.removeReminder(id);
  }

  /// Shows a test notification for the given reminder.
  Future<void> showTestNotification(GeoReminder reminder) async {
    final body = reminder.description.isNotEmpty
        ? reminder.description
        : 'Test: You entered the area.';
    await _notificationService.showReminder(
      id: reminder.id.hashCode.abs() % 0x7FFFFFFF,
      title: reminder.title,
      body: body,
    );
  }
}

