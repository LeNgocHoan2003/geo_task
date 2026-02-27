import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geo_task/l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../domain/entities/geo_reminder.dart';
import '../stores/reminder_store.dart';
import '../widgets/trigger_type_chip.dart';

/// Home screen: list of reminders and FAB to add new (View in MVVM).
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.store});

  final ReminderStore store;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.store.loadReminders();
  }

  Future<void> _openAddReminder() async {
    final result = await context.push<bool>(AppRoutes.add);
    if (result == true && mounted) {
      widget.store.loadReminders();
    }
  }

  Future<void> _openEditReminder(GeoReminder reminder) async {
    final result = await context.push<bool>(AppRoutes.editWithId(reminder.id));
    if (result == true && mounted) {
      widget.store.loadReminders();
    }
  }

  /// Debug only: show the same notification as when geofence triggers (no movement needed).
  Future<void> _testTriggerNotification(GeoReminder reminder) async {
    await widget.store.showTestNotification(reminder);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.testNotificationSent,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          t.appTitle,
          style: AppTypography.headlineMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: t.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingH,
              vertical: AppSpacing.screenPaddingV,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSmall),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                      color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      t.homeHintBanner,
                      style: AppTypography.bodyMedium.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Observer(
              builder: (context) {
                if (widget.store.isLoading &&
                    widget.store.reminders.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (widget.store.reminders.isEmpty) {
                  return _EmptyState(onAddTap: _openAddReminder);
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                    vertical: AppSpacing.screenPaddingV,
                  ),
                  itemCount: widget.store.reminders.length,
                  itemBuilder: (context, index) {
                    final r = widget.store.reminders[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppSpacing.listItemGap),
                      child: _ReminderCard(
                        reminder: r,
                        onToggle: (value) =>
                            widget.store.toggleReminder(r.id, value),
                        onTap: () => _openEditReminder(r),
                        onDelete: () => _confirmDelete(context, r),
                        onTestTrigger: kDebugMode
                            ? () => _testTriggerNotification(r)
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _PremiumFab(onPressed: _openAddReminder),
    );
  }

  void _confirmDelete(BuildContext context, GeoReminder reminder) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Text(t.deleteReminderTitle),
        content: Text(
          t.deleteReminderMessage(reminder.title),
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.deleteReminderCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.store.deleteReminder(reminder.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(t.deleteReminderConfirm),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 56,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              t.homeEmptyTitle,
              style: AppTypography.headlineMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.homeEmptySubtitle,
              style: AppTypography.bodyMedium.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(t.homeEmptyAddButton),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
    this.onTestTrigger,
  });

  final GeoReminder reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onTestTrigger;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final locationDisplay = reminder.locationName.isNotEmpty
        ? reminder.locationName
        : '${reminder.latitude.toStringAsFixed(4)}, ${reminder.longitude.toStringAsFixed(4)}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withOpacity(0.25),
            ),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: AppTypography.titleMedium.copyWith(
                            decoration: reminder.isActive
                                ? null
                                : TextDecoration.lineThrough,
                            color: reminder.isActive
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 14,
                              color:
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                locationDisplay,
                                style: AppTypography.bodySmall.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            TriggerTypeChip(triggerType: reminder.triggerType),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '${reminder.radius.toInt()} m',
                              style: AppTypography.labelMedium.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Switch.adaptive(
                    value: reminder.isActive,
                    onChanged: onToggle,
                  ),
                ],
              ),
              if (reminder.description.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  reminder.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onTestTrigger != null)
                    IconButton(
                      icon: const Icon(Icons.notifications_active_outlined),
                      onPressed: onTestTrigger,
                      tooltip: t.testNotificationTooltip,
                      style: IconButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: onTap,
                    tooltip: t.editTooltip,
                    style: IconButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    tooltip: t.deleteTooltip,
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumFab extends StatelessWidget {
  const _PremiumFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.fabRadius + 20),
        boxShadow: AppShadows.fab,
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
