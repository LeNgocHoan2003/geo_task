# Geo-Task

A Flutter location-based reminder app using geofencing and local notifications. Set reminders tied to a place; get notified when you enter or leave the area.

## Prerequisites

- **Flutter SDK** (stable channel), see [flutter.dev/docs/get-started/install](https://docs.flutter.dev/get-started/install)
- **Android**: Android Studio or Android SDK (for device/emulator)
- **iOS/macOS**: Xcode (mac only)
- **Web/Windows/Linux**: no extra tools beyond Flutter

## Steps to Run

### 1. Clone and open the project

```bash
git clone <repository-url>
cd geo_task
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate code (MobX, Hive)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the app

**On a connected device or running emulator:**

```bash
# Default (first available device)
flutter run

# Or specify a device
flutter run -d chrome          # Web
flutter run -d windows         # Windows
flutter run -d <device-id>     # List devices: flutter devices
```

**First run on Android:** grant location (including “Allow all the time” for background geofencing) and notification permissions when prompted.

## Build release (optional)

**Android (AAB for Play Store):**

```bash
flutter build aab --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

To sign the bundle with your own key, create `android/key.properties` and add a release keystore (see [Flutter docs](https://docs.flutter.dev/deployment/android#signing-the-app)). Without `key.properties`, the project falls back to debug signing.

**APK:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive/upload.

## Project structure

- `lib/` – Dart app code
  - `core/` – theme, services (location, geofence, notifications), DI, router
  - `features/reminder/` – reminder CRUD, map picker, MobX stores
- `android/`, `ios/`, `macos/`, `windows/`, `linux/`, `web/` – platform projects

## License

See repository license file.
