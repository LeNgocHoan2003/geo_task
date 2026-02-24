import 'package:geolocator/geolocator.dart';

import '../contracts/location_service_interface.dart';
import '../models/location_point.dart';
import '../utils/logger.dart';

/// Handles device location: permissions and current position.
/// Implements [LocationServiceInterface] for dependency inversion (SOLID).
class LocationService implements LocationServiceInterface {
  @override
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  Future<bool> requestPermission() async {
    final status = await Geolocator.requestPermission();
    final granted = status == LocationPermission.whileInUse ||
        status == LocationPermission.always;
    if (!granted) {
      logInfo('Location permission denied: $status');
    }
    return granted;
  }

  @override
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

  @override
  Future<LocationPoint> getCurrentPosition() async {
    final enabled = await isLocationServiceEnabled();
    if (!enabled) {
      throw LocationServiceException('Location services are disabled.');
    }
    final ok = await ensurePermission();
    if (!ok) {
      throw LocationServiceException('Location permission denied.');
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    return LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

class LocationServiceException implements Exception {
  LocationServiceException(this.message);
  final String message;
  @override
  String toString() => 'LocationServiceException: $message';
}
