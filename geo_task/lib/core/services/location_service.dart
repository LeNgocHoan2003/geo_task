import 'package:geolocator/geolocator.dart';

import '../utils/logger.dart';

/// Handles device location: permissions and current position.
class LocationService {
  /// Check if location services are enabled.
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Check current permission status.
  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  /// Request location permission. Returns true if granted (always or whileInUse).
  Future<bool> requestPermission() async {
    final status = await Geolocator.requestPermission();
    final granted = status == LocationPermission.whileInUse ||
        status == LocationPermission.always;
    if (!granted) {
      logInfo('Location permission denied: $status');
    }
    return granted;
  }

  /// Ensure we have permission; request if not. Returns true if we can use location.
  Future<bool> ensurePermission() async {
    var permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission()
          ? LocationPermission.whileInUse
          : LocationPermission.denied;
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Get current position. Throws if permission or service unavailable.
  Future<Position> getCurrentPosition() async {
    final enabled = await isLocationServiceEnabled();
    if (!enabled) {
      throw LocationServiceException('Location services are disabled.');
    }
    final ok = await ensurePermission();
    if (!ok) {
      throw LocationServiceException('Location permission denied.');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}

class LocationServiceException implements Exception {
  LocationServiceException(this.message);
  final String message;
  @override
  String toString() => 'LocationServiceException: $message';
}
