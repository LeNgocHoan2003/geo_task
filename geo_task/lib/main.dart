import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/geofence_service.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'features/reminder/data/datasources/reminder_local_datasource_impl.dart';
import 'features/reminder/data/repositories/reminder_repository_impl.dart';
import 'features/reminder/domain/usecases/reminder_use_cases.dart';
import 'features/reminder/presentation/stores/reminder_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await ReminderLocalDatasourceImpl.openBox();

  // Infrastructure
  final notificationService = NotificationService();
  await notificationService.initialize();

  final locationService = LocationService();
  final geofenceService = GeofenceService(notificationService);

  // Data + domain
  final repository = ReminderRepositoryImpl(
    ReminderLocalDatasourceImpl(Hive.box(AppConstants.remindersBoxName)),
  );
  final useCases = ReminderUseCases(repository);

  // ViewModel
  final store = ReminderStore(
    useCases: useCases,
    geofenceService: geofenceService,
    locationService: locationService,
    notificationService: notificationService,
  );

  // Bootstrap: load reminders and start geofence monitoring
  await store.loadReminders();
  await geofenceService.start(store.reminders.toList());

  final router = createAppRouter(store);
  runApp(GeoTaskApp(router: router));
}

class GeoTaskApp extends StatelessWidget {
  const GeoTaskApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Geo-Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
