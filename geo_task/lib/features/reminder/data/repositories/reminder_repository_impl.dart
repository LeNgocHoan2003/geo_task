import '../../domain/entities/geo_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_local_datasource.dart';

/// Implementation of [ReminderRepository].
/// Geofence registration is handled by [GeofenceService]; this layer only persists data.
class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._local);

  final ReminderLocalDatasource _local;

  @override
  Future<List<GeoReminder>> getReminders() => _local.getReminders();

  @override
  Future<GeoReminder?> getReminderById(String id) => _local.getReminderById(id);

  @override
  Future<void> saveReminder(GeoReminder reminder) =>
      _local.saveReminder(reminder);

  @override
  Future<void> deleteReminder(String id) => _local.deleteReminder(id);

  @override
  Future<void> toggleReminder(String id, bool isActive) async {
    final reminder = await _local.getReminderById(id);
    if (reminder == null) return;
    await _local.saveReminder(reminder.copyWith(isActive: isActive));
  }
}
