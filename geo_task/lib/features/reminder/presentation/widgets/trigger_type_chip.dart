import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/geo_reminder.dart';

/// Chip showing trigger type: Enter or Exit.
class TriggerTypeChip extends StatelessWidget {
  const TriggerTypeChip({super.key, required this.triggerType});

  final GeoTriggerType triggerType;

  @override
  Widget build(BuildContext context) {
    final isEnter = triggerType == GeoTriggerType.enter;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isEnter ? AppColors.enterChipBg : AppColors.exitChipBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
      ),
      child: Text(
        isEnter ? 'Enter' : 'Exit',
        style: AppTypography.labelMedium.copyWith(
          color: isEnter ? AppColors.enterChipFg : AppColors.exitChipFg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
