import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/geo_reminder.dart';
import '../models/geo_reminder_model.dart';
import 'reminder_local_datasource.dart';

/// Hive-based implementation of [ReminderLocalDatasource].
/// Uses a plain Box to store JSON maps (no TypeAdapter required).
class ReminderLocalDatasourceImpl implements ReminderLocalDatasource {
  ReminderLocalDatasourceImpl(this._box);

  final Box _box;

  static Future<Box> openBox() async {
    if (!Hive.isBoxOpen(AppConstants.remindersBoxName)) {
      return Hive.openBox(AppConstants.remindersBoxName);
    }
    return Hive.box(AppConstants.remindersBoxName);
  }

  @override
  Future<List<GeoReminder>> getReminders() async {
    final list = <GeoReminder>[];
    for (final key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map is Map) {
        final json = Map<String, dynamic>.from(map);
        list.add(GeoReminderModel.fromJson(json));
      }
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<GeoReminder?> getReminderById(String id) async {
    final map = _box.get(id);
    if (map == null) return null;
    return GeoReminderModel.fromJson(Map<String, dynamic>.from(map as Map));
  }

  @override
  Future<void> saveReminder(GeoReminder reminder) async {
    final model = GeoReminderModel.fromEntity(reminder);
    await _box.put(reminder.id, model.toJson());
  }

  @override
  Future<void> deleteReminder(String id) async {
    await _box.delete(id);
  }
}
