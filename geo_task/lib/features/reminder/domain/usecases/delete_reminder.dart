import '../repositories/reminder_repository.dart';

/// Use case: delete a reminder by id (single responsibility).
class DeleteReminder {
  DeleteReminder(this._repository);

  final ReminderRepository _repository;

  Future<void> call(String id) => _repository.deleteReminder(id);
}
