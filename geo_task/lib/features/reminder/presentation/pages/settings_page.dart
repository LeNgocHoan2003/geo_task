import 'package:flutter/material.dart';
import 'package:geo_task/l10n/app_localizations.dart';

import '../../../../core/settings/app_settings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final settings = AppSettingsScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.settingsTitle,
          style: AppTypography.headlineMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
          vertical: AppSpacing.screenPaddingV,
        ),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              t.settingsDarkMode,
              style: AppTypography.titleMedium,
            ),
            value: settings.themeMode == ThemeMode.dark,
            onChanged: settings.toggleDarkMode,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            t.settingsLanguage,
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Column(
            children: [
              RadioListTile<AppLanguage>(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  t.languageEnglish,
                  style: AppTypography.bodyMedium,
                ),
                value: AppLanguage.english,
                groupValue: settings.language,
                onChanged: (value) {
                  if (value != null) {
                    settings.updateLanguage(value);
                  }
                },
              ),
              RadioListTile<AppLanguage>(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  t.languageVietnamese,
                  style: AppTypography.bodyMedium,
                ),
                value: AppLanguage.vietnamese,
                groupValue: settings.language,
                onChanged: (value) {
                  if (value != null) {
                    settings.updateLanguage(value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

