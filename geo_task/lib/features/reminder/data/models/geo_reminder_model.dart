import '../../domain/entities/geo_reminder.dart';

/// Data model for [GeoReminder] with JSON and Hive serialization.
class GeoReminderModel extends GeoReminder {
  const GeoReminderModel({
    required super.id,
    required super.title,
    super.description = '',
    required super.latitude,
    required super.longitude,
    required super.radius,
    required super.triggerType,
    super.isActive = true,
    required super.createdAt,
  });

  factory GeoReminderModel.fromEntity(GeoReminder entity) {
    return GeoReminderModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      latitude: entity.latitude,
      longitude: entity.longitude,
      radius: entity.radius,
      triggerType: entity.triggerType,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }

  factory GeoReminderModel.fromJson(Map<String, dynamic> json) {
    return GeoReminderModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
      triggerType: json['triggerType'] == 'exit'
          ? GeoTriggerType.exit
          : GeoTriggerType.enter,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'triggerType': triggerType == GeoTriggerType.exit ? 'exit' : 'enter',
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
