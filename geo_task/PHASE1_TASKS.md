# Phase 1 – MVP Task List (Geo-Task)

**Goal:** Android-first MVP with core location-based reminders and background geofencing.

---

## 1. Project setup & architecture

- [x] Scaffold Flutter project with Clean Architecture folders
- [x] Add dependencies: geolocator, geofence_service, flutter_local_notifications, google_maps_flutter, permission_handler, hive, mobx, flutter_mobx
- [x] Define `GeoReminder` entity and `GeoTriggerType` enum
- [ ] Configure Android permissions (location, background location, notifications)
- [ ] Configure iOS permissions and background modes (when ready for iOS)

---

## 2. Core services

- [x] **LocationService** – get current position, check permission, request permission
- [x] **GeofenceService** – register/unregister geofences, handle enter/exit callbacks
- [x] **NotificationService** – init, show local notification on geofence trigger
- [ ] Integrate GeofenceService with NotificationService (show notification on trigger)
- [ ] Test background behavior (app in background / killed)

---

## 3. Data layer

- [x] GeoReminder model (entity + data model with JSON/Hive)
- [x] ReminderRepository interface (domain)
- [x] ReminderLocalDatasource (Hive or in-memory for Phase 1)
- [x] ReminderRepositoryImpl
- [ ] Persist reminders with Hive and restore on app start
- [ ] Register/unregister geofences when reminders are added/removed/toggled

---

## 4. Domain layer

- [x] CreateReminder use case
- [x] GetReminders use case
- [ ] ToggleReminder use case
- [ ] DeleteReminder use case

---

## 5. Presentation – Home screen

- [ ] Home page: list of reminders with toggle (enable/disable)
- [ ] FAB to navigate to Add Reminder
- [ ] Use MobX store for reminder list and toggle state
- [ ] Empty state when no reminders

---

## 6. Presentation – Add Reminder screen

- [x] Add Reminder page with Google Map and tap-to-select location
- [x] Slider for radius (50–1000 m)
- [x] Text fields for title and description
- [x] Dropdown for trigger type (Enter / Exit)
- [ ] Save button: persist reminder and register geofence
- [ ] Permission request flow before opening map
- [ ] Validation and error handling

---

## 7. Presentation – Reminder detail (optional for Phase 1)

- [ ] Reminder detail page with map preview
- [ ] Edit reminder (reuse Add form with pre-filled data)
- [ ] Delete reminder (remove from storage and geofence)

---

## 8. Integration & edge cases

- [ ] Handle “user denied location” and “user denied background”
- [ ] Handle “GPS off” with a simple message or retry
- [ ] Limit active geofences (e.g. Android ~100) and show warning if needed
- [ ] Logging for geofence triggers and errors

---

## 9. Testing (manual for Phase 1)

- [ ] Enter geofence → notification appears
- [ ] Exit geofence → notification appears (when trigger is Exit)
- [ ] Toggle reminder off → no notification
- [ ] Restart app → reminders and geofences still work
- [ ] App killed → geofence still triggers notification

---

## Done when

- User can add a reminder (location, radius, trigger, title/description).
- User sees reminders on home screen and can enable/disable.
- Enter/Exit geofence triggers a local notification.
- App works in background (Android); permissions and errors are handled.
