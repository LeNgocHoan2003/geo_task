# Testing Geo-Task Without Moving

## Notifications not showing on Android?

1. **Allow when prompted** – On first run (Android 13+), the app requests notification permission. Tap **Allow** so reminders can show.
2. **If you denied or skipped** – Go to **Settings → Apps → Geo-Task → Notifications** and turn notifications **On**.
3. **Channel** – Ensure “Geo-Task Reminders” (or the app’s notification channel) is not muted and is allowed to show on lock screen / override Do Not Disturb if you use those.

---

## 1. Test notification (no movement, no emulator)

In **debug builds** only, each reminder on the home screen has a **bell icon** (Test notification).

- Tap the **bell** on a reminder row.
- The same notification that would appear on geofence enter is shown immediately.
- Use this to check notification content, sound, and channel without moving.

This button is **not** included in release builds (`kDebugMode` is false).

---

## 2. Emulator / simulator mock location

To test real geofence enter/exit without moving physically:

### Android Emulator

1. Run the app on the Android emulator.
2. Create a reminder and set its location (e.g. tap on map).
3. Open emulator **Extended controls** (⋯ or three dots).
4. Go to **Location**.
5. Enter latitude/longitude **outside** the reminder’s circle, then set.
6. Change the location to a point **inside** the circle (e.g. reminder’s center).
7. After a short delay, the app should trigger the geofence and show the notification.

You can also use **Routes** or **GPX/KML** to simulate movement.

### iOS Simulator

1. Run the app on the iOS simulator.
2. In the simulator menu: **Features → Location**.
3. Choose **Custom Location…** and enter coordinates outside the geofence, then later inside it.
4. Or use **Freeway Drive** / **City Run** to simulate movement.

---

## 3. Tips

- Use a **larger radius** (e.g. 200–500 m) so the “inside” and “outside” points are clearly different.
- Geofence triggers could be delayed (e.g. 10–30 seconds) depending on platform and power saving.
- On a **real device**, you can use apps that set a mock location (e.g. “Fake GPS”) if you need to test without moving.
