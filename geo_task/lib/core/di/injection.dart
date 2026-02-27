import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../contracts/geofence_service_interface.dart';
import '../contracts/location_service_interface.dart';
import '../contracts/notification_service_interface.dart';
import '../utils/logger.dart';
import '../../features/reminder/data/datasources/reminder_local_datasource.dart';
import '../../features/reminder/data/datasources/reminder_local_datasource_impl.dart';
import '../../features/reminder/data/repositories/reminder_repository_impl.dart';
import '../../features/reminder/domain/repositories/reminder_repository.dart';
import '../../features/reminder/domain/services/reminder_domain_service.dart';
import '../../features/reminder/domain/usecases/reminder_use_cases.dart';
import '../../features/reminder/presentation/stores/reminder_store.dart';

import '../services/geofence_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../router/app_router.dart';

final getIt = GetIt.instance;

/// Registers all dependencies with get_it and runs bootstrap.
/// Call this before accessing [GoRouter] or [ReminderStore].
Future<void> setupGetIt() async {
  await Hive.initFlutter();
  final box = await ReminderLocalDatasourceImpl.openBox();
  getIt.registerSingleton<Box>(box);

  final notificationService = NotificationService();
  await notificationService.initialize();
  getIt.registerSingleton<NotificationServiceInterface>(notificationService);

  getIt.registerSingleton<LocationServiceInterface>(LocationService());

  getIt.registerSingleton<GeofenceServiceInterface>(
    GeofenceService(
      getIt<NotificationServiceInterface>(),
      getIt<LocationServiceInterface>(),
    ),
  );

  getIt.registerSingleton<ReminderLocalDatasource>(
    ReminderLocalDatasourceImpl(getIt<Box>()),
  );

  getIt.registerSingleton<ReminderRepository>(
    ReminderRepositoryImpl(getIt<ReminderLocalDatasource>()),
  );

  final repo = getIt<ReminderRepository>();
  getIt.registerSingleton<GetReminders>(GetReminders(repo));
  getIt.registerSingleton<CreateReminder>(CreateReminder(repo));
  getIt.registerSingleton<UpdateReminder>(UpdateReminder(repo));
  getIt.registerSingleton<DeleteReminder>(DeleteReminder(repo));
  getIt.registerSingleton<ToggleReminder>(ToggleReminder(repo));

  getIt.registerSingleton<ReminderDomainService>(
    ReminderDomainService(
      geofenceService: getIt<GeofenceServiceInterface>(),
      notificationService: getIt<NotificationServiceInterface>(),
    ),
  );

  getIt.registerSingleton<ReminderStore>(
    ReminderStore(
      getReminders: getIt<GetReminders>(),
      createReminder: getIt<CreateReminder>(),
      updateReminder: getIt<UpdateReminder>(),
      deleteReminder: getIt<DeleteReminder>(),
      toggleReminder: getIt<ToggleReminder>(),
      reminderDomainService: getIt<ReminderDomainService>(),
      locationService: getIt<LocationServiceInterface>(),
    ),
  );

  await _bootstrap(
    getIt<ReminderStore>(),
    getIt<GeofenceServiceInterface>(),
  );

  getIt.registerSingleton<GoRouter>(
    createAppRouter(getIt<ReminderStore>()),
  );
}

/// Loads reminders and starts geofence monitoring. Catches errors so app still opens after kill.
Future<void> _bootstrap(
  ReminderStore store,
  GeofenceServiceInterface geofenceService,
) async {
  try {
    await store.loadReminders();
    await geofenceService.start(store.reminders.toList());
  } catch (e, st) {
    logError('Bootstrap failed (app will still run)', e, st);
  }
}
