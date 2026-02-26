import '../entities/geo_reminder.dart';

/// Abstract repository for geo reminders (persistence + geofence registration).
abstract class ReminderRepository {
  Future<List<GeoReminder>> getReminders();
  Future<GeoReminder?> getReminderById(String id);
  Future<void> saveReminder(GeoReminder reminder);
  Future<void> deleteReminder(String id);
  Future<void> toggleReminder(String id, bool isActive);
}
