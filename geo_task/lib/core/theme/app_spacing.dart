/// Geo-Task spacing system (in logical pixels).
/// Use multiples of 4 for consistency; 16–20px for card padding.
abstract class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Card border radius (16–20px per spec)
  static const double cardRadius = 18;
  static const double cardRadiusSmall = 14;
  static const double inputRadius = 12;
  static const double buttonRadius = 14;
  static const double fabRadius = 16;

  /// Screen horizontal padding
  static const double screenPaddingH = 20;
  static const double screenPaddingV = 16;

  /// List item spacing
  static const double listItemGap = 10;
}
