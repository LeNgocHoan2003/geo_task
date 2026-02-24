import '../../features/reminder/domain/entities/geo_reminder.dart';

/// Keeps mapping from geofence id to [GeoReminder] for notification content.
class GeofenceReminderMapping {
  final _map = <String, GeoReminder>{};

  void add(GeoReminder r) {
    _map[r.id] = r;
  }

  void remove(String id) {
    _map.remove(id);
  }

  GeoReminder? get(String id) => _map[id];

  void clear() => _map.clear();
}
