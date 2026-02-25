import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Segmented control for two options (e.g. Enter / Exit).
/// Modern iOS + Android hybrid look with smooth tap feedback.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
    required this.segments,
  });

  final T value;
  final ValueChanged<T> onChanged;
  final List<SegmentItem<T>> segments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: segments.map((segment) {
          final isSelected = value == segment.value;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onChanged(segment.value);
                },
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm + 2,
                    horizontal: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (segment.icon != null) ...[
                        Icon(
                          segment.icon,
                          size: 18,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        segment.label,
                        style: (isSelected
                                ? AppTypography.labelLarge
                                : AppTypography.bodyMedium)
                            .copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SegmentItem<T> {
  const SegmentItem({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}
