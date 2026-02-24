import 'package:mobx/mobx.dart';

import '../../domain/entities/geo_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../../../core/services/geofence_service.dart';

part 'reminder_store.g.dart';

/// MobX store for reminder list and actions.
class ReminderStore = ReminderStoreBase with _$ReminderStore;

abstract class ReminderStoreBase with Store {
  ReminderStoreBase(this._repository, this._geofenceService);

  final ReminderRepository _repository;
  final GeofenceService _geofenceService;

  @observable
  ObservableList<GeoReminder> reminders = ObservableList<GeoReminder>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadReminders() async {
    isLoading = true;
    errorMessage = null;
    try {
      final list = await _repository.getReminders();
      reminders = ObservableList.of(list);
      _geofenceService.syncReminders(list);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addReminder(GeoReminder reminder) async {
    errorMessage = null;
    try {
      await _repository.saveReminder(reminder);
      reminders.insert(0, reminder);
      if (reminder.isActive) {
        _geofenceService.addReminder(reminder);
      }
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<void> toggleReminder(String id, bool isActive) async {
    errorMessage = null;
    try {
      await _repository.toggleReminder(id, isActive);
      final index = reminders.indexWhere((r) => r.id == id);
      if (index >= 0) {
        final updated = reminders[index].copyWith(isActive: isActive);
        reminders[index] = updated;
        _geofenceService.syncReminders(reminders.toList());
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> deleteReminder(String id) async {
    errorMessage = null;
    try {
      await _repository.deleteReminder(id);
      reminders.removeWhere((r) => r.id == id);
      _geofenceService.removeReminder(id);
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
