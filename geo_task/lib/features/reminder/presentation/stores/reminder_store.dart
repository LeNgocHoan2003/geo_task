import 'package:mobx/mobx.dart';

import '../../../../core/contracts/geofence_service_interface.dart';
import '../../../../core/contracts/location_service_interface.dart';
import '../../../../core/contracts/notification_service_interface.dart';
import '../../../../core/models/location_point.dart';
import '../../domain/entities/geo_reminder.dart';
import '../../domain/usecases/reminder_use_cases.dart';

part 'reminder_store.g.dart';

/// ViewModel for reminder list and actions (MVVM).
/// Depends on use cases and service interfaces (SOLID).
class ReminderStore = ReminderStoreBase with _$ReminderStore;

abstract class ReminderStoreBase with Store {
  ReminderStoreBase({
    required GetReminders getReminders,
    required CreateReminder createReminder,
    required UpdateReminder updateReminder,
    required DeleteReminder deleteReminder,
    required ToggleReminder toggleReminder,
    required GeofenceServiceInterface geofenceService,
    required LocationServiceInterface locationService,
    required NotificationServiceInterface notificationService,
  })  : _getReminders = getReminders,
        _createReminder = createReminder,
        _updateReminder = updateReminder,
        _deleteReminder = deleteReminder,
        _toggleReminder = toggleReminder,
        _geofenceService = geofenceService,
        _locationService = locationService,
        _notificationService = notificationService;

  final GetReminders _getReminders;
  final CreateReminder _createReminder;
  final UpdateReminder _updateReminder;
  final DeleteReminder _deleteReminder;
  final ToggleReminder _toggleReminder;
  final GeofenceServiceInterface _geofenceService;
  final LocationServiceInterface _locationService;
  final NotificationServiceInterface _notificationService;

  @observable
  ObservableList<GeoReminder> reminders = ObservableList<GeoReminder>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadReminders() async {
    _setLoading(true);
    _clearError();
    try {
      final list = await _getReminders.call();
      reminders = ObservableList.of(list);
      await _geofenceService.syncReminders(list);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  @action
  Future<void> addReminder(GeoReminder reminder) async {
    _clearError();
    try {
      await _createReminder.call(reminder);
      reminders.insert(0, reminder);
      if (reminder.isActive) {
        // Full sync so native geofence client picks up first region (fixes cold start with 0 reminders).
        await _geofenceService.syncReminders(reminders.toList());
      }
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<void> toggleReminder(String id, bool isActive) async {
    _clearError();
    try {
      await _toggleReminder.call(id, isActive);
      final index = reminders.indexWhere((r) => r.id == id);
      if (index >= 0) {
        final updated = reminders[index].copyWith(isActive: isActive);
        reminders[index] = updated;
        await _geofenceService.syncReminders(reminders.toList());
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> updateReminder(GeoReminder reminder) async {
    _clearError();
    try {
      await _updateReminder.call(reminder);
      final index = reminders.indexWhere((r) => r.id == reminder.id);
      if (index >= 0) {
        reminders[index] = reminder;
      }
      await _geofenceService.syncReminders(reminders.toList());
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<void> deleteReminder(String id) async {
    _clearError();
    try {
      await _deleteReminder.call(id);
      reminders.removeWhere((r) => r.id == id);
      await _geofenceService.removeReminder(id);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  /// Returns current device position for map/location UI (delegates to [LocationServiceInterface]).
  Future<LocationPoint> getCurrentPosition() => _locationService.getCurrentPosition();

  /// Shows a test notification for the given reminder (e.g. debug only).
  Future<void> showTestNotification(GeoReminder reminder) async {
    final body = reminder.description.isNotEmpty
        ? reminder.description
        : 'Test: You entered the area.';
    await _notificationService.showReminder(
      id: reminder.id.hashCode.abs() % 0x7FFFFFFF,
      title: reminder.title,
      body: body,
    );
  }

  @action
  void _setLoading(bool value) => isLoading = value;

  @action
  void _clearError() => errorMessage = null;
}
