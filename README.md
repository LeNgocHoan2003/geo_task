# Geo-Task

Location-based reminder app (geofencing + local notifications). Set reminders for a place and get notified when you enter or leave the area.

## Repository layout

- **`geo_task/`** – Flutter app (run and build from here)
- **`LICENSE`** – License terms

## How to run the app

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable)

### Steps

1. **Clone and go into the app folder**

   ```bash
   git clone <repository-url>
   cd geo_task/geo_task
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code (MobX, Hive)**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run**

   ```bash
   flutter run
   ```

   Use a connected device or emulator, or run on a specific platform:

   - Web: `flutter run -d chrome`
   - Windows: `flutter run -d windows`

   On Android, allow location (including “Allow all the time” for background) and notifications when prompted.

For more detail (build release AAB/APK, project structure), see **[geo_task/README.md](geo_task/README.md)**.
