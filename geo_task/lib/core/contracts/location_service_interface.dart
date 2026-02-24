import '../models/location_point.dart';

/// Contract for device location (permissions and current position).
/// Implementations can use Geolocator or other providers.
abstract class LocationServiceInterface {
  /// Returns whether location services are enabled on the device.
  Future<bool> isLocationServiceEnabled();

  /// Ensures permission is granted; requests if needed. Returns true if location can be used.
  Future<bool> ensurePermission();

  /// Gets current position. Throws if services disabled or permission denied.
  Future<LocationPoint> getCurrentPosition();
}
