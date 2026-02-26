import 'package:flutter/material.dart';

/// Geo-Task color palette: premium, minimal, light background with accent.
/// Use for consistent theming across the app.
abstract class AppColors {
  AppColors._();

  // Primary accent – soft teal/cyan (premium, calm)
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryLight = Color(0xFF5EEAD4);
  static const Color primaryDark = Color(0xFF0F766E);

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Borders & dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Trigger type chips
  static const Color enterChipBg = Color(0xFFECFDF5);
  static const Color enterChipFg = Color(0xFF059669);
  static const Color exitChipBg = Color(0xFFFEF3C7);
  static const Color exitChipFg = Color(0xFFD97706);

  // Gradients (subtle)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
  );

  // Shadow colors (soft)
  static const Color shadowColor = Color(0x0D000000);
  static const Color shadowColorStrong = Color(0x1A000000);
}
