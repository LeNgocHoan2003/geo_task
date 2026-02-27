import 'package:geolocator/geolocator.dart';

import '../contracts/location_service_interface.dart';
import '../models/location_point.dart';
import '../utils/logger.dart';

/// Handles device location: permissions and current position.
/// Implements [LocationServiceInterface] for dependency inversion (SOLID).
class LocationService implements LocationServiceInterface {
  @override
  Future<bool> isLocationServiceEnabled() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    logInfo('[LocationService] isLocationServiceEnabled: $enabled');
    return enabled;
  }

  Future<LocationPermission> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    logInfo('[LocationService] checkPermission: $permission');
    return permission;
  }

  Future<bool> requestPermission() async {
    logInfo('[LocationService] requestPermission() called');
    final status = await Geolocator.requestPermission();
    final granted = status == LocationPermission.whileInUse ||
        status == LocationPermission.always;
    if (!granted) {
      logInfo('[LocationService] permission denied: $status');
    } else {
      logInfo('[LocationService] permission granted: $status');
    }
    return granted;
  }

  @override
  Future<bool> ensurePermission() async {
    logInfo('[LocationService] ensurePermission() called');
    var permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission()
          ? LocationPermission.whileInUse
          : LocationPermission.denied;
    }
    final ok = permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    logInfo('[LocationService] ensurePermission result: $ok ($permission)');
    return ok;
  }

  @override
  Future<LocationPoint> getCurrentPosition() async {
    logInfo('[LocationService] getCurrentPosition() called');
    final enabled = await isLocationServiceEnabled();
    if (!enabled) {
      logInfo('[LocationService] location services disabled, throwing');
      throw LocationServiceException('Location services are disabled.');
    }
    final ok = await ensurePermission();
    if (!ok) {
      logInfo('[LocationService] permission denied, throwing');
      throw LocationServiceException('Location permission denied.');
    }
    logInfo('[LocationService] fetching current position (high accuracy)...');
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    logInfo('[LocationService] position: ${position.latitude}, ${position.longitude}');
    return LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Stream<LocationPoint> getPositionStream() {
    logInfo('[LocationService] getPositionStream() called (accuracy: medium, distanceFilter: 50m)');
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 50,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (Position position) {
        logInfo('[LocationService] position update: ${position.latitude}, ${position.longitude}');
        return LocationPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      },
    );
  }
}

class LocationServiceException implements Exception {
  LocationServiceException(this.message);
  final String message;
  @override
  String toString() => 'LocationServiceException: $message';
}
