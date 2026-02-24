import '../entities/geo_reminder.dart';
import '../repositories/reminder_repository.dart';

class CreateReminder {
  CreateReminder(this._repository);

  final ReminderRepository _repository;

  Future<void> call(GeoReminder reminder) =>
      _repository.saveReminder(reminder);
}
