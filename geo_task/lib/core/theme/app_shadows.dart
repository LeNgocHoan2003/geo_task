import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Soft elevation shadows for cards and FAB (premium feel).
abstract class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.shadowColor,
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.shadowColor,
          offset: const Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: AppColors.shadowColorStrong,
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.shadowColor,
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get fab => [
        BoxShadow(
          color: AppColors.shadowColorStrong,
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.25),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];
}
