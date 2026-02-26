/// Domain model for a geographic position (avoids coupling to Geolocator).
class LocationPoint {
  const LocationPoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}
