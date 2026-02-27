import 'package:flutter/material.dart';

/// Supported app languages.
enum AppLanguage {
  english,
  vietnamese,
}

extension AppLanguageX on AppLanguage {
  Locale get locale {
    switch (this) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.vietnamese:
        return const Locale('vi');
    }
  }
}

/// Global app settings (theme mode, language).
class AppSettingsController extends ChangeNotifier {
  AppSettingsController({
    ThemeMode initialThemeMode = ThemeMode.light,
    AppLanguage initialLanguage = AppLanguage.english,
  })  : _themeMode = initialThemeMode,
        _language = initialLanguage;

  ThemeMode _themeMode;
  AppLanguage _language;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;

  void updateThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleDarkMode(bool isDark) {
    updateThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void updateLanguage(AppLanguage language) {
    if (language == _language) return;
    _language = language;
    notifyListeners();
  }
}

/// Inherited notifier to expose [AppSettingsController] down the tree.
class AppSettingsScope extends InheritedNotifier<AppSettingsController> {
  const AppSettingsScope({
    super.key,
    required AppSettingsController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static AppSettingsController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in widget tree');
    return scope!.notifier!;
  }
}

