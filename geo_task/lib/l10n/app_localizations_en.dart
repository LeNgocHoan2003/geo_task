// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Geo-Task';

  @override
  String get homeHintBanner => 'Keep the app running to receive location-based reminders.';

  @override
  String get homeEmptyTitle => 'No reminders yet';

  @override
  String get homeEmptySubtitle => 'Tap + to add a location-based reminder.';

  @override
  String get homeEmptyAddButton => 'Add reminder';

  @override
  String get deleteReminderTitle => 'Delete reminder?';

  @override
  String deleteReminderMessage(String title) {
    return 'Remove \"$title\"? This cannot be undone.';
  }

  @override
  String get deleteReminderCancel => 'Cancel';

  @override
  String get deleteReminderConfirm => 'Delete';

  @override
  String get testNotificationSent => 'Test notification sent';

  @override
  String get editTooltip => 'Edit';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get testNotificationTooltip => 'Test notification (debug)';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get addReminderTitle => 'Add Reminder';

  @override
  String get editReminderTitle => 'Edit Reminder';

  @override
  String get addReminderSearchHint => 'Search for a place';

  @override
  String get addReminderMapHint => 'Tap on the map to set the reminder location.';

  @override
  String get addReminderTitleLabel => 'Title';

  @override
  String get addReminderTitleHint => 'e.g. Buy milk';

  @override
  String get addReminderDescriptionLabel => 'Description (optional)';

  @override
  String get addReminderDescriptionHint => 'e.g. Don\'t forget!';

  @override
  String get addReminderRadiusLabel => 'Radius';

  @override
  String get addReminderNotifyWhenLabel => 'Notify when';

  @override
  String get addReminderEnterLabel => 'Enter';

  @override
  String get addReminderExitLabel => 'Exit';

  @override
  String get addReminderSaveButton => 'Save Reminder';

  @override
  String get addReminderUpdateButton => 'Update Reminder';

  @override
  String get addReminderDeleteButton => 'Delete reminder';

  @override
  String get addReminderTitleRequired => 'Please enter a title';

  @override
  String get addReminderFieldRequired => 'Required';

  @override
  String addReminderSaveFailed(String error) {
    return 'Failed to save: \"$error\"';
  }
}
