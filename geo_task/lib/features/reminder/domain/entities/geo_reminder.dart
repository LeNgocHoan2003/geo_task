/// Trigger type for geofence: notify when user enters or exits the area.
enum GeoTriggerType {
  enter,
  exit,
}

/// Domain entity for a location-based reminder.
class GeoReminder {
  const GeoReminder({
    required this.id,
    required this.title,
    this.description = '',
    this.locationName = '',
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.triggerType,
    this.isActive = true,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  /// Optional display name for the place (e.g. from place autocomplete).
  final String locationName;
  final double latitude;
  final double longitude;
  final double radius;
  final GeoTriggerType triggerType;
  final bool isActive;
  final DateTime createdAt;

  GeoReminder copyWith({
    String? id,
    String? title,
    String? description,
    String? locationName,
    double? latitude,
    double? longitude,
    double? radius,
    GeoTriggerType? triggerType,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return GeoReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      triggerType: triggerType ?? this.triggerType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
