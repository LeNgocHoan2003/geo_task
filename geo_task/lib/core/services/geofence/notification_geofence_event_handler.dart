import '../../contracts/geofence_event_handler_interface.dart';
import '../../contracts/notification_service_interface.dart';
import '../../../features/reminder/domain/entities/geo_reminder.dart';

/// Shows a notification when a geofence transition matches the reminder's trigger type.
class NotificationGeofenceEventHandler implements GeofenceEventHandlerInterface {
  NotificationGeofenceEventHandler(this._notificationService);

  final NotificationServiceInterface _notificationService;

  @override
  void handleTransition(GeoReminder reminder, bool isEnter) {
    final wantEnter = reminder.triggerType == GeoTriggerType.enter;
    if (wantEnter != isEnter) return;

    final title = reminder.title;
    final defaultMessage =
        isEnter ? 'You entered the area.' : 'You left the area.';
    final body = reminder.description.isNotEmpty
        ? reminder.description
        : '$title — $defaultMessage';
    final id = reminder.id.hashCode.abs() % 0x7FFFFFFF;
    _notificationService.showReminder(id: id, title: title, body: body);
  }
}
