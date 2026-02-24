import '../entities/geo_reminder.dart';
import '../repositories/reminder_repository.dart';

/// Use case: update an existing reminder (single responsibility).
class UpdateReminder {
  UpdateReminder(this._repository);

  final ReminderRepository _repository;

  Future<void> call(GeoReminder reminder) =>
      _repository.saveReminder(reminder);
}
