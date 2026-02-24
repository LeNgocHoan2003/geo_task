import '../entities/geo_reminder.dart';
import '../repositories/reminder_repository.dart';

class GetReminders {
  GetReminders(this._repository);

  final ReminderRepository _repository;

  Future<List<GeoReminder>> call() => _repository.getReminders();
}
