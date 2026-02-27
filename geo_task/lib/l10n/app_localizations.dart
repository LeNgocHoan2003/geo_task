import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Geo-Task'**
  String get appTitle;

  /// No description provided for @homeHintBanner.
  ///
  /// In en, this message translates to:
  /// **'Keep the app running to receive location-based reminders.'**
  String get homeHintBanner;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a location-based reminder.'**
  String get homeEmptySubtitle;

  /// No description provided for @homeEmptyAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get homeEmptyAddButton;

  /// No description provided for @deleteReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete reminder?'**
  String get deleteReminderTitle;

  /// No description provided for @deleteReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{title}\"? This cannot be undone.'**
  String deleteReminderMessage(String title);

  /// No description provided for @deleteReminderCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteReminderCancel;

  /// No description provided for @deleteReminderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteReminderConfirm;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get testNotificationSent;

  /// No description provided for @editTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTooltip;

  /// No description provided for @deleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTooltip;

  /// No description provided for @testNotificationTooltip.
  ///
  /// In en, this message translates to:
  /// **'Test notification (debug)'**
  String get testNotificationTooltip;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @addReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminderTitle;

  /// No description provided for @editReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get editReminderTitle;

  /// No description provided for @addReminderSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a place'**
  String get addReminderSearchHint;

  /// No description provided for @addReminderMapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to set the reminder location.'**
  String get addReminderMapHint;

  /// No description provided for @addReminderTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get addReminderTitleLabel;

  /// No description provided for @addReminderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Buy milk'**
  String get addReminderTitleHint;

  /// No description provided for @addReminderDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get addReminderDescriptionLabel;

  /// No description provided for @addReminderDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Don\'t forget!'**
  String get addReminderDescriptionHint;

  /// No description provided for @addReminderRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get addReminderRadiusLabel;

  /// No description provided for @addReminderNotifyWhenLabel.
  ///
  /// In en, this message translates to:
  /// **'Notify when'**
  String get addReminderNotifyWhenLabel;

  /// No description provided for @addReminderEnterLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get addReminderEnterLabel;

  /// No description provided for @addReminderExitLabel.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get addReminderExitLabel;

  /// No description provided for @addReminderSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get addReminderSaveButton;

  /// No description provided for @addReminderUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Reminder'**
  String get addReminderUpdateButton;

  /// No description provided for @addReminderDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete reminder'**
  String get addReminderDeleteButton;

  /// No description provided for @addReminderTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get addReminderTitleRequired;

  /// No description provided for @addReminderFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get addReminderFieldRequired;

  /// No description provided for @addReminderSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: \"{error}\"'**
  String addReminderSaveFailed(String error);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
