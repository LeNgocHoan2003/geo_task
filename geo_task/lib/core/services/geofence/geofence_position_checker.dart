import 'package:geolocator/geolocator.dart';

import '../../contracts/geofence_event_handler_interface.dart';
import '../../models/geofence_reminder_mapping.dart';
import '../../models/location_point.dart';

/// Single responsibility: detect enter/exit transitions from position updates
/// and notify via [GeofenceEventHandlerInterface].
/// Used as fallback when native geofence events do not fire (e.g. foreground).
class GeofencePositionChecker {
  GeofencePositionChecker(
    this._mapping,
    this._eventHandler, {
    this.minRadiusMeters = 100.0,
  });

  final GeofenceReminderMapping _mapping;
  final GeofenceEventHandlerInterface _eventHandler;

  /// Minimum radius to use for distance checks (should match native API minimum).
  final double minRadiusMeters;

  final _wasInside = <String, bool>{};

  /// Call when the mapping has been reset (e.g. after sync) so state is cleared.
  void clearState() {
    _wasInside.clear();
  }

  /// Process one position update: compute inside/outside per reminder,
  /// detect transitions, and call [GeofenceEventHandlerInterface.handleTransition].
  void onPositionUpdate(LocationPoint point) {
    final lat = point.latitude;
    final lng = point.longitude;

    for (final id in _mapping.ids) {
      final reminder = _mapping.get(id);
      if (reminder == null) continue;

      final radius = reminder.radius < minRadiusMeters
          ? minRadiusMeters
          : reminder.radius;
      final distanceMeters = Geolocator.distanceBetween(
        reminder.latitude,
        reminder.longitude,
        lat,
        lng,
      );
      final inside = distanceMeters <= radius;
      final wasInside = _wasInside[id];
      _wasInside[id] = inside;

      if (wasInside == null) continue;
      final didTransition = wasInside != inside;
      if (!didTransition) continue;

      final isEnter = inside;
      _eventHandler.handleTransition(reminder, isEnter);
    }
  }
}
