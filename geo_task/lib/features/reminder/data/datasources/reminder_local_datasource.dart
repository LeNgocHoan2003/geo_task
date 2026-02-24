import '../../domain/entities/geo_reminder.dart';

/// Local persistence for reminders (e.g. Hive, Isar).
abstract class ReminderLocalDatasource {
  Future<List<GeoReminder>> getReminders();
  Future<GeoReminder?> getReminderById(String id);
  Future<void> saveReminder(GeoReminder reminder);
  Future<void> deleteReminder(String id);
}
