import 'package:flutter_background_geofencing/flutter_background_geofencing.dart';

import '../../../features/reminder/domain/entities/geo_reminder.dart';

/// Single responsibility: map [GeoReminder] to [GeofenceRegion].
/// Enforces minimum radius for native APIs (e.g. Android recommends 100m).
class GeofenceRegionMapper {
  GeofenceRegionMapper({this.minRadiusMeters = 100.0});

  /// Minimum radius for native geofence APIs.
  final double minRadiusMeters;

  GeofenceRegion toRegion(GeoReminder reminder) {
    final radius = reminder.radius < minRadiusMeters
        ? minRadiusMeters
        : reminder.radius;
    return GeofenceRegion(
      id: reminder.id,
      latitude: reminder.latitude,
      longitude: reminder.longitude,
      radius: radius,
      data: {
        'title': reminder.title,
        'description': reminder.description,
        'triggerType': reminder.triggerType.name,
      },
    );
  }
}
