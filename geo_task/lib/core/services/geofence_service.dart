import 'package:geofence_service/geofence_service.dart' as gf;

import '../../features/reminder/domain/entities/geo_reminder.dart';
import '../models/geofence_reminder_mapping.dart';
import '../utils/logger.dart';
import 'notification_service.dart';

/// Wraps geofence_service: registers GeoReminders and shows notifications on enter/exit.
class GeofenceService {
  GeofenceService(this._notificationService) {
    _service = gf.GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: false,
      printDevLog: false,
      geofenceRadiusSortType: gf.GeofenceRadiusSortType.DESC,
    );
  }

  final NotificationService _notificationService;
  late final gf.GeofenceService _service;
  final _mapping = GeofenceReminderMapping();
  bool _started = false;

  bool get isRunning => _service.isRunningService;

  /// Convert [GeoReminder] to package [Geofence] (one radius per reminder).
  gf.Geofence toGeofence(GeoReminder r) {
    return gf.Geofence(
      id: r.id,
      latitude: r.latitude,
      longitude: r.longitude,
      radius: [
        gf.GeofenceRadius(id: '${r.id}_radius', length: r.radius),
      ],
    );
  }

  /// Register listener and start the service. Call once at app startup.
  Future<void> start(List<GeoReminder> activeReminders) async {
    if (_started) {
      logInfo('GeofenceService already started, updating geofences');
      _service.clearGeofenceList();
      for (final r in activeReminders) {
        if (r.isActive) {
          _service.addGeofence(toGeofence(r));
          _mapping.add(r);
        }
      }
      return;
    }

    _service.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);

    _service.addStreamErrorListener((e) {
      logError('Geofence stream error', e);
    });

    final geofenceList = activeReminders
        .where((r) => r.isActive)
        .map(toGeofence)
        .toList();
    for (final r in activeReminders) {
      if (r.isActive) _mapping.add(r);
    }

    try {
      await _service.start(geofenceList);
      _started = true;
      logInfo('GeofenceService started with ${geofenceList.length} geofences');
    } catch (e, st) {
      logError('GeofenceService start failed', e, st);
      rethrow;
    }
  }

  Future<void> _onGeofenceStatusChanged(
    gf.Geofence geofence,
    gf.GeofenceRadius geofenceRadius,
    gf.GeofenceStatus geofenceStatus,
    gf.Location location,
  ) async {
    final reminder = _mapping.get(geofence.id);
    if (reminder == null) return;

    final wantEnter = reminder.triggerType == GeoTriggerType.enter;
    final isEnter = geofenceStatus == gf.GeofenceStatus.ENTER;
    if (wantEnter != isEnter) return;

    final title = reminder.title;
    final body = reminder.description.isNotEmpty
        ? reminder.description
        : (isEnter ? 'You entered the area.' : 'You left the area.');
    final id = reminder.id.hashCode.abs() % 0x7FFFFFFF;

    await _notificationService.showReminder(id: id, title: title, body: body);
  }

  /// Add one reminder and its geofence (service must already be started).
  void addReminder(GeoReminder reminder) {
    if (!reminder.isActive) return;
    _mapping.add(reminder);
    _service.addGeofence(toGeofence(reminder));
    logInfo('Geofence added for reminder ${reminder.id}');
  }

  /// Remove geofence for reminder [id].
  void removeReminder(String id) {
    _mapping.remove(id);
    _service.removeGeofenceById(id);
    logInfo('Geofence removed for $id');
  }

  /// Refresh geofences from a full list of reminders (e.g. after toggle or load).
  void syncReminders(List<GeoReminder> reminders) {
    _mapping.clear();
    _service.clearGeofenceList();
    for (final r in reminders) {
      if (r.isActive) {
        _mapping.add(r);
        _service.addGeofence(toGeofence(r));
      }
    }
  }

  /// Stop the service and remove listener.
  Future<void> stop() async {
    if (!_started) return;
    _service.removeGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _service.clearAllListeners();
    await _service.stop();
    _mapping.clear();
    _started = false;
    logInfo('GeofenceService stopped');
  }
}
