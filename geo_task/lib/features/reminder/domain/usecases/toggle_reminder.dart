import '../repositories/reminder_repository.dart';

/// Use case: toggle active state of a reminder (single responsibility).
class ToggleReminder {
  ToggleReminder(this._repository);

  final ReminderRepository _repository;

  Future<void> call(String id, bool isActive) =>
      _repository.toggleReminder(id, isActive);
}
