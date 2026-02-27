import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/reminder/domain/entities/geo_reminder.dart';
import '../../features/reminder/presentation/pages/add_reminder_page.dart';
import '../../features/reminder/presentation/pages/home_page.dart';
import '../../features/reminder/presentation/pages/settings_page.dart';
import '../../features/reminder/presentation/stores/reminder_store.dart';
import '../../features/reminder/presentation/pages/location_permission_page.dart';

/// Route path constants (single responsibility).
abstract class AppRoutes {
  static const String home = '/';
  static const String add = '/add';
  static const String edit = '/edit';
  static const String settings = '/settings';
  static const String locationPermission = '/location-permission';

  static String editWithId(String id) => '/edit/$id';
}

/// Builds [GoRouter]. Depends only on [ReminderStore] (ViewModel); Views receive store only (MVVM).
GoRouter createAppRouter(ReminderStore store) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => HomePage(store: store),
      ),
      GoRoute(
        path: '${AppRoutes.edit}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final reminder = _findReminderById(store, id);
          if (reminder == null) {
            return _buildNotFoundScreen(context);
          }
          return AddReminderPage(
            store: store,
            existingReminder: reminder,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.add,
        builder: (context, state) => AddReminderPage(store: store),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.locationPermission,
        builder: (context, state) => const LocationPermissionPage(),
      ),
    ],
  );
}

GeoReminder? _findReminderById(ReminderStore store, String id) {
  try {
    return store.reminders.firstWhere((r) => r.id == id);
  } catch (_) {
    return null;
  }
}

Widget _buildNotFoundScreen(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Reminder not found'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text('Back'),
          ),
        ],
      ),
    ),
  );
}
