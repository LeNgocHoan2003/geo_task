// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReminderStore on ReminderStoreBase, Store {
  late final _$remindersAtom =
      Atom(name: 'ReminderStoreBase.reminders', context: context);

  @override
  ObservableList<GeoReminder> get reminders {
    _$remindersAtom.reportRead();
    return super.reminders;
  }

  @override
  set reminders(ObservableList<GeoReminder> value) {
    _$remindersAtom.reportWrite(value, super.reminders, () {
      super.reminders = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'ReminderStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'ReminderStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadRemindersAsyncAction =
      AsyncAction('ReminderStoreBase.loadReminders', context: context);

  @override
  Future<void> loadReminders() {
    return _$loadRemindersAsyncAction.run(() => super.loadReminders());
  }

  late final _$addReminderAsyncAction =
      AsyncAction('ReminderStoreBase.addReminder', context: context);

  @override
  Future<void> addReminder(GeoReminder reminder) {
    return _$addReminderAsyncAction.run(() => super.addReminder(reminder));
  }

  late final _$toggleReminderAsyncAction =
      AsyncAction('ReminderStoreBase.toggleReminder', context: context);

  @override
  Future<void> toggleReminder(String id, bool isActive) {
    return _$toggleReminderAsyncAction
        .run(() => super.toggleReminder(id, isActive));
  }

  late final _$updateReminderAsyncAction =
      AsyncAction('ReminderStoreBase.updateReminder', context: context);

  @override
  Future<void> updateReminder(GeoReminder reminder) {
    return _$updateReminderAsyncAction
        .run(() => super.updateReminder(reminder));
  }

  late final _$deleteReminderAsyncAction =
      AsyncAction('ReminderStoreBase.deleteReminder', context: context);

  @override
  Future<void> deleteReminder(String id) {
    return _$deleteReminderAsyncAction.run(() => super.deleteReminder(id));
  }

  late final _$ReminderStoreBaseActionController =
      ActionController(name: 'ReminderStoreBase', context: context);

  @override
  void _setLoading(bool value) {
    final _$actionInfo = _$ReminderStoreBaseActionController.startAction(
        name: 'ReminderStoreBase._setLoading');
    try {
      return super._setLoading(value);
    } finally {
      _$ReminderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$ReminderStoreBaseActionController.startAction(
        name: 'ReminderStoreBase._clearError');
    try {
      return super._clearError();
    } finally {
      _$ReminderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
reminders: ${reminders},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
