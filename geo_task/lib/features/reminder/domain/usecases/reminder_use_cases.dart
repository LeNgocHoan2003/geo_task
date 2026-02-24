import '../repositories/reminder_repository.dart';
import 'create_reminder.dart';
import 'delete_reminder.dart';
import 'get_reminders.dart';
import 'toggle_reminder.dart';
import 'update_reminder.dart';

/// Container for all reminder use cases. Built once from [ReminderRepository].
class ReminderUseCases {
  ReminderUseCases(ReminderRepository repository)
      : getReminders = GetReminders(repository),
        createReminder = CreateReminder(repository),
        updateReminder = UpdateReminder(repository),
        deleteReminder = DeleteReminder(repository),
        toggleReminder = ToggleReminder(repository);

  final GetReminders getReminders;
  final CreateReminder createReminder;
  final UpdateReminder updateReminder;
  final DeleteReminder deleteReminder;
  final ToggleReminder toggleReminder;
}
