import 'package:mobx/mobx.dart';

import '../../../../core/contracts/location_service_interface.dart';
import '../../../../core/models/location_point.dart';
import '../../domain/entities/geo_reminder.dart';
import '../../domain/services/reminder_domain_service.dart';
import '../../domain/usecases/reminder_use_cases.dart';

part 'reminder_store.g.dart';

/// ViewModel for reminder list and actions (MVVM).
/// Depends on use cases and a domain service for side effects (SOLID).
class ReminderStore = ReminderStoreBase with _$ReminderStore;

abstract class ReminderStoreBase with Store {
  ReminderStoreBase({
    required GetReminders getReminders,
    required CreateReminder createReminder,
    required UpdateReminder updateReminder,
    required DeleteReminder deleteReminder,
    required ToggleReminder toggleReminder,
    required ReminderDomainService reminderDomainService,
    required LocationServiceInterface locationService,
  })  : _getReminders = getReminders,
        _createReminder = createReminder,
        _updateReminder = updateReminder,
        _deleteReminder = deleteReminder,
        _toggleReminder = toggleReminder,
        _reminderDomainService = reminderDomainService,
        _locationService = locationService;

  final GetReminders _getReminders;
  final CreateReminder _createReminder;
  final UpdateReminder _updateReminder;
  final DeleteReminder _deleteReminder;
  final ToggleReminder _toggleReminder;
  final ReminderDomainService _reminderDomainService;
  final LocationServiceInterface _locationService;

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
      await _reminderDomainService.onRemindersLoaded(list);
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
      await _reminderDomainService.onReminderAdded(
        reminders.toList(),
        reminder,
      );
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
        await _reminderDomainService.onReminderToggled(reminders.toList());
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
      await _reminderDomainService.onReminderUpdated(reminders.toList());
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
      await _reminderDomainService.onReminderDeleted(id);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  /// Returns current device position for map/location UI (delegates to [LocationServiceInterface]).
  Future<LocationPoint> getCurrentPosition() =>
      _locationService.getCurrentPosition();

  /// Shows a test notification for the given reminder (e.g. debug only).
  Future<void> showTestNotification(GeoReminder reminder) =>
      _reminderDomainService.showTestNotification(reminder);

  @action
  void _setLoading(bool value) => isLoading = value;

  @action
  void _clearError() => errorMessage = null;
}

