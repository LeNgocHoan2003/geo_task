import 'dart:async';

import 'package:flutter_background_geofencing/flutter_background_geofencing.dart';

import '../../features/reminder/domain/entities/geo_reminder.dart';
import '../contracts/geofence_service_interface.dart';
import '../contracts/geofence_event_handler_interface.dart';
import '../contracts/location_service_interface.dart';
import '../contracts/notification_service_interface.dart';
import '../models/geofence_reminder_mapping.dart';
import '../models/location_point.dart';
import '../utils/logger.dart';
import 'geofence/geofence_position_checker.dart';
import 'geofence/geofence_region_mapper.dart';
import 'geofence/notification_geofence_event_handler.dart';

/// Uses native platform geofencing (Android GeofencingClient / iOS CLLocationManager)
/// so triggers work when the app is in background or killed.
/// When native does not fire events, a manual check using [LocationServiceInterface]
/// position stream triggers enter/exit so notifications still show (e.g. foreground).
class GeofenceService implements GeofenceServiceInterface {
  GeofenceService(this._notificationService, this._locationService) {
    _service = GeofencingService();
    _regionMapper = GeofenceRegionMapper(minRadiusMeters: _minRadiusMeters);
    _eventHandler = NotificationGeofenceEventHandler(_notificationService);
    _positionChecker = GeofencePositionChecker(
      _mapping,
      _eventHandler,
      minRadiusMeters: _minRadiusMeters,
    );
  }

  final NotificationServiceInterface _notificationService;
  final LocationServiceInterface _locationService;
  late final GeofencingService _service;
  late final GeofenceRegionMapper _regionMapper;
  late final GeofencePositionChecker _positionChecker;
  late final GeofenceEventHandlerInterface _eventHandler;
  final _mapping = GeofenceReminderMapping();
  final _registeredIds = <String>[];
  StreamSubscription<GeofenceEvent>? _eventSubscription;
  StreamSubscription<LocationPoint>? _positionSubscription;
  bool _started = false;

  /// Minimum radius for native APIs (Android recommends 100m).
  static const double _minRadiusMeters = 100;

  @override
  bool get isRunning => _started;

  @override
  Future<void> start(List<GeoReminder> activeReminders) async {
    logInfo('[GeofenceService] start() called with ${activeReminders.length} reminders');
    if (_started) {
      logInfo('[GeofenceService] already started, syncing regions');
      await _syncRegions(activeReminders);
      return;
    }

    try {
      logInfo('[GeofenceService] initializing...');
      await _service.initialize();
      await _service.requestPermissions();
      logInfo('[GeofenceService] permissions granted');

      logInfo('[GeofenceService] setting up native geofence event listener');
      _eventSubscription = _service.onGeofenceEvent.listen(_onGeofenceEvent);

      logInfo('[GeofenceService] setting up position stream for manual check');
      _positionSubscription = _locationService.getPositionStream().listen(
        _positionChecker.onPositionUpdate,
        onError: (e) => logError('[GeofenceService] position stream error', e),
      );

      await _service.startService(
        notificationTitle: 'Geo-Task',
        notificationText: 'Monitoring reminder locations',
        enableFallbackNotifications: false,
      );
      logInfo('[GeofenceService] background service started');

      _started = true;
      logInfo('[GeofenceService] started (native + manual position check)');

      await _syncRegions(activeReminders);
    } catch (e, st) {
      logError('[GeofenceService] start failed', e, st);
      _started = false;
      // Do not rethrow: app should still open (e.g. after being killed)
    }
  }

  Future<void> _syncRegions(List<GeoReminder> reminders) async {
    logInfo('[GeofenceService] _syncRegions() called with ${reminders.length} reminders');
    await _service.removeAllGeofences();
    _registeredIds.clear();
    _mapping.clear();
    _positionChecker.clearState();
    logInfo('[GeofenceService] cleared all existing geofences');

    final activeCount = reminders.where((r) => r.isActive).length;
    for (final r in reminders) {
      if (r.isActive) {
        _mapping.add(r);
        await _service.addGeofence(_regionMapper.toRegion(r));
        _registeredIds.add(r.id);
        logInfo('[GeofenceService] added geofence: ${r.id} "${r.title}" (${r.triggerType.name})');
      }
    }
    logInfo('[GeofenceService] synced $activeCount geofence regions (total: ${_registeredIds.length})');
  }

  void _onGeofenceEvent(GeofenceEvent event) {
    logInfo('[GeofenceService] native geofence event: regionId=${event.regionId} type=${event.type}');
    final reminder = _mapping.get(event.regionId);
    if (reminder == null) {
      logInfo('[GeofenceService] no reminder found for regionId=${event.regionId}, ignoring');
      return;
    }

    final wantEnter = reminder.triggerType == GeoTriggerType.enter;
    final isEnter = event.type == GeofenceEventType.enter;
    if (wantEnter != isEnter) {
      logInfo('[GeofenceService] trigger mismatch: want ${reminder.triggerType.name} but got ${event.type}, ignoring');
      return;
    }

    final title = reminder.title;
    final defaultMessage =
        isEnter ? 'You entered the area.' : 'You left the area.';
    final body = reminder.description.isNotEmpty
        ? reminder.description
        : '$title — $defaultMessage';
    final id = reminder.id.hashCode.abs() % 0x7FFFFFFF;

    logInfo('[GeofenceService] showing notification: "$title" (id=$id)');
    _notificationService.showReminder(id: id, title: title, body: body);
  }

  @override
  Future<void> addReminder(GeoReminder reminder) async {
    logInfo('[GeofenceService] addReminder() called: ${reminder.id} "${reminder.title}" active=${reminder.isActive}');
    if (!reminder.isActive) {
      logInfo('[GeofenceService] reminder is inactive, skipping');
      return;
    }
    _mapping.add(reminder);
    await _service.addGeofence(_regionMapper.toRegion(reminder));
    _registeredIds.add(reminder.id);
    logInfo('[GeofenceService] geofence added for reminder ${reminder.id}');
  }

  @override
  Future<void> removeReminder(String id) async {
    logInfo('[GeofenceService] removeReminder() called: $id');
    _mapping.remove(id);
    _registeredIds.remove(id);
    await _service.removeGeofence(id);
    logInfo('[GeofenceService] geofence removed for $id');
  }

  @override
  Future<void> syncReminders(List<GeoReminder> reminders) async {
    logInfo('[GeofenceService] syncReminders() called with ${reminders.length} reminders');
    await _syncRegions(reminders);
  }

  @override
  Future<void> stop() async {
    logInfo('[GeofenceService] stop() called');
    if (!_started) {
      logInfo('[GeofenceService] not started, nothing to stop');
      return;
    }
    await _eventSubscription?.cancel();
    _eventSubscription = null;
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    logInfo('[GeofenceService] cancelled event and position subscriptions');
    await _service.stopService();
    _registeredIds.clear();
    _mapping.clear();
    _started = false;
    logInfo('[GeofenceService] stopped');
  }
}
