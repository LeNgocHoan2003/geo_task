import 'dart:async';

import 'package:flutter_background_geofencing/flutter_background_geofencing.dart';

import '../../features/reminder/domain/entities/geo_reminder.dart';
import '../models/geofence_reminder_mapping.dart';
import '../utils/logger.dart';
import 'notification_service.dart';

/// Uses native platform geofencing (Android GeofencingClient / iOS CLLocationManager)
/// so triggers work when the app is in background or killed.
class GeofenceService {
  GeofenceService(this._notificationService) {
    _service = GeofencingService();
  }

  final NotificationService _notificationService;
  late final GeofencingService _service;
  final _mapping = GeofenceReminderMapping();
  final _registeredIds = <String>[];
  StreamSubscription<GeofenceEvent>? _eventSubscription;
  bool _started = false;

  /// Minimum radius for native APIs (Android recommends 100m).
  static const double _minRadiusMeters = 100;

  bool get isRunning => _started;

  GeofenceRegion _toRegion(GeoReminder r) {
    final radius = r.radius < _minRadiusMeters ? _minRadiusMeters : r.radius;
    return GeofenceRegion(
      id: r.id,
      latitude: r.latitude,
      longitude: r.longitude,
      radius: radius,
      data: {
        'title': r.title,
        'description': r.description,
        'triggerType': r.triggerType.name,
      },
    );
  }

  /// Start the native geofencing service and register active reminders.
  Future<void> start(List<GeoReminder> activeReminders) async {
    if (_started) {
      logInfo('GeofenceService already started, syncing regions');
      await _syncRegions(activeReminders);
      return;
    }

    try {
      await _service.initialize();
      await _service.requestPermissions();

      _eventSubscription = _service.onGeofenceEvent.listen(_onGeofenceEvent);

      await _service.startService(
        notificationTitle: 'Geo-Task',
        notificationText: 'Monitoring reminder locations',
        enableFallbackNotifications: true,
        fallbackNotificationTitle: 'Geo-Task',
        fallbackNotificationBody: 'You have a location reminder',
      );

      _started = true;
      logInfo('GeofenceService started (native background geofencing)');

      await _syncRegions(activeReminders);
    } catch (e, st) {
      logError('GeofenceService start failed', e, st);
      rethrow;
    }
  }

  Future<void> _syncRegions(List<GeoReminder> reminders) async {
    await _service.removeAllGeofences();
    _registeredIds.clear();
    _mapping.clear();

    for (final r in reminders) {
      if (r.isActive) {
        _mapping.add(r);
        await _service.addGeofence(_toRegion(r));
        _registeredIds.add(r.id);
      }
    }
    logInfo('Synced ${_registeredIds.length} geofence regions');
  }

  void _onGeofenceEvent(GeofenceEvent event) {
    final reminder = _mapping.get(event.regionId);
    if (reminder == null) return;

    final wantEnter = reminder.triggerType == GeoTriggerType.enter;
    final isEnter = event.type == GeofenceEventType.enter;
    if (wantEnter != isEnter) return;

    final title = reminder.title;
    final body = reminder.description.isNotEmpty
        ? reminder.description
        : (isEnter ? 'You entered the area.' : 'You left the area.');
    final id = reminder.id.hashCode.abs() % 0x7FFFFFFF;

    _notificationService.showReminder(id: id, title: title, body: body);
  }

  /// Add one reminder and its geofence (service must already be started).
  Future<void> addReminder(GeoReminder reminder) async {
    if (!reminder.isActive) return;
    _mapping.add(reminder);
    await _service.addGeofence(_toRegion(reminder));
    _registeredIds.add(reminder.id);
    logInfo('Geofence added for reminder ${reminder.id}');
  }

  /// Remove geofence for reminder [id].
  Future<void> removeReminder(String id) async {
    _mapping.remove(id);
    _registeredIds.remove(id);
    await _service.removeGeofence(id);
    logInfo('Geofence removed for $id');
  }

  /// Refresh geofences from a full list of reminders (e.g. after toggle or load).
  Future<void> syncReminders(List<GeoReminder> reminders) async {
    await _syncRegions(reminders);
  }

  /// Stop the service and remove listener.
  Future<void> stop() async {
    if (!_started) return;
    await _eventSubscription?.cancel();
    _eventSubscription = null;
    await _service.stopService();
    _registeredIds.clear();
    _mapping.clear();
    _started = false;
    logInfo('GeofenceService stopped');
  }
}
