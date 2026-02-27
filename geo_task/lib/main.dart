import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geo_task/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/settings/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GeoTaskApp(bootstrap: _bootstrapApp));
}

/// Initializes get_it (Hive, services, store, bootstrap) and returns the router.
Future<GoRouter> _bootstrapApp() async {
  await setupGetIt();
  return getIt<GoRouter>();
}

class GeoTaskApp extends StatefulWidget {
  const GeoTaskApp({super.key, required this.bootstrap});

  final Future<GoRouter> Function() bootstrap;

  @override
  State<GeoTaskApp> createState() => _GeoTaskAppState();
}

class _GeoTaskAppState extends State<GeoTaskApp> {
  GoRouter? _router;
  late final AppSettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    final deviceLocale =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final initialLanguage = switch (deviceLocale) {
      'vi' => AppLanguage.vietnamese,
      _ => AppLanguage.english,
    };
    _settingsController = AppSettingsController(
      initialLanguage: initialLanguage,
    );
    widget.bootstrap().then((router) {
      if (mounted) setState(() => _router = router);
    }).catchError((e, st) {
      logError('Bootstrap failed', e, st);
      if (mounted) setState(() => _router = _buildErrorRouter(e));
    });
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  GoRouter _buildErrorRouter(Object error) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to start: $error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_router == null) {
      return MaterialApp(
        title: 'Geo-Task',
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return AnimatedBuilder(
      animation: _settingsController,
      builder: (context, _) {
        return AppSettingsScope(
          controller: _settingsController,
          child: MaterialApp.router(
            title: 'Geo-Task',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _settingsController.themeMode,
            locale: _settingsController.language.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: _router,
          ),
        );
      },
    );
  }
}
