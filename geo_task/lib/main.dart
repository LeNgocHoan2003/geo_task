import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/services/geofence_service.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'features/reminder/data/datasources/reminder_local_datasource_impl.dart';
import 'features/reminder/data/repositories/reminder_repository_impl.dart';
import 'features/reminder/domain/repositories/reminder_repository.dart';
import 'features/reminder/presentation/pages/home_page.dart';
import 'features/reminder/presentation/stores/reminder_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await ReminderLocalDatasourceImpl.openBox();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final locationService = LocationService();
  final geofenceService = GeofenceService(notificationService);

  final box = Hive.box(AppConstants.remindersBoxName);
  final localDs = ReminderLocalDatasourceImpl(box);
  ReminderRepository repository = ReminderRepositoryImpl(localDs);
  final store = ReminderStore(repository, geofenceService);

  await store.loadReminders();
  await geofenceService.start(store.reminders.toList());

  runApp(GeoTaskApp(
    store: store,
    locationService: locationService,
  ));
}

class GeoTaskApp extends StatelessWidget {
  const GeoTaskApp({
    super.key,
    required this.store,
    required this.locationService,
  });

  final ReminderStore store;
  final LocationService locationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo-Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomePage(
        store: store,
        locationService: locationService,
      ),
    );
  }
}
