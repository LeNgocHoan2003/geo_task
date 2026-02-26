import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/segmented_control.dart';
import '../../domain/entities/geo_reminder.dart';
import '../stores/reminder_store.dart';

/// Screen to create or edit a location-based reminder (View in MVVM).
/// Uses OpenStreetMap via flutter_map (no API key required).
class AddReminderPage extends StatefulWidget {
  const AddReminderPage({
    super.key,
    required this.store,
    this.existingReminder,
  });

  final ReminderStore store;
  /// When non-null, the form is in edit mode (pre-filled, update on save).
  final GeoReminder? existingReminder;

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _mapController = MapController();
  final _scrollController = ScrollController();

  double _latitude = 21.0285;
  double _longitude = 105.8542;
  double _radius = AppConstants.radiusDefaultMeters;
  GeoTriggerType _triggerType = GeoTriggerType.enter;
  bool _saving = false;

  bool get _isEditing => widget.existingReminder != null;
  LatLng get _selectedPoint => LatLng(_latitude, _longitude);

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReminder;
    if (existing != null) {
      _titleController.text = existing.title;
      _descriptionController.text = existing.description;
      _searchController.text = existing.locationName;
      _latitude = existing.latitude;
      _longitude = existing.longitude;
      _radius = existing.radius;
      _triggerType = existing.triggerType;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _mapController.move(_selectedPoint, 15);
      });
    } else {
      _initLocation();
    }
  }

  Future<void> _initLocation() async {
    try {
      final point = await widget.store.getCurrentPosition();
      if (mounted) {
        setState(() {
          _latitude = point.latitude;
          _longitude = point.longitude;
        });
        _mapController.move(_selectedPoint, 15);
      }
    } catch (_) {
      // Keep default coordinates if permission/location fails
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final existing = widget.existingReminder;
      final reminder = existing != null
          ? existing.copyWith(
              title: title,
              description: _descriptionController.text.trim(),
              locationName: _searchController.text.trim(),
              latitude: _latitude,
              longitude: _longitude,
              radius: _radius,
              triggerType: _triggerType,
            )
          : GeoReminder(
              id: const Uuid().v4(),
              title: title,
              description: _descriptionController.text.trim(),
              locationName: _searchController.text.trim(),
              latitude: _latitude,
              longitude: _longitude,
              radius: _radius,
              triggerType: _triggerType,
              isActive: true,
              createdAt: DateTime.now(),
            );
      if (_isEditing) {
        await widget.store.updateReminder(reminder);
      } else {
        await widget.store.addReminder(reminder);
      }
      if (!mounted) return;
      if (context.mounted) context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _onDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: const Text('Delete reminder?'),
        content: Text(
          'Remove "${_titleController.text.trim()}"? This cannot be undone.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    final existing = widget.existingReminder;
    if (existing == null) return;
    setState(() => _saving = true);
    try {
      await widget.store.deleteReminder(existing.id);
      if (!mounted) return;
      if (context.mounted) context.pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Reminder' : 'Add Reminder',
          style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
      ),
      body: Observer(
        builder: (_) {
          final error = widget.store.errorMessage;
          if (error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: AppColors.error,
                ),
            );
            });
          }
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.screenPaddingV,
              AppSpacing.screenPaddingH,
              AppSpacing.xxl + 80,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search bar (place autocomplete)
                  _SearchBar(
                    controller: _searchController,
                    hint: 'Search for a place',
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Map with pin and radius circle
                  _MapPreview(
                    mapController: _mapController,
                    center: _selectedPoint,
                    radiusMeters: _radius,
                    onTap: (point) {
                      setState(() {
                        _latitude = point.latitude;
                        _longitude = point.longitude;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Tap on the map to set the reminder location.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g. Buy milk',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      hintText: 'e.g. Don\'t forget!',
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Radius slider with label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Radius',
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm + 2,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.cardRadiusSmall),
                        ),
                        child: Text(
                          '${_radius.toInt()} m',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.primary,
                    ),
                    child: Slider(
                      value: _radius,
                      min: AppConstants.radiusMinMeters,
                      max: AppConstants.radiusMaxMeters,
                      divisions: 19,
                      onChanged: (v) => setState(() => _radius = v),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Trigger type – segmented control
                  Text(
                    'Notify when',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedControl<GeoTriggerType>(
                    value: _triggerType,
                    onChanged: (v) => setState(() => _triggerType = v),
                    segments: const [
                      SegmentItem(
                        value: GeoTriggerType.enter,
                        label: 'Enter',
                        icon: Icons.login_rounded,
                      ),
                      SegmentItem(
                        value: GeoTriggerType.exit,
                        label: 'Exit',
                        icon: Icons.logout_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Fixed bottom save button
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: AppSpacing.screenPaddingH,
            right: AppSpacing.screenPaddingH,
            top: AppSpacing.lg,
            bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                offset: const Offset(0, -2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isEditing) ...[
                TextButton.icon(
                  onPressed: _saving ? null : _onDelete,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text('Delete reminder'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              FilledButton(
                onPressed: _saving ? null : _onSave,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.lg,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEditing ? 'Update Reminder' : 'Save Reminder',
                        style: AppTypography.titleSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textTertiary,
          size: 22,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({
    required this.mapController,
    required this.center,
    required this.radiusMeters,
    required this.onTap,
  });

  final MapController mapController;
  final LatLng center;
  final double radiusMeters;
  final void Function(LatLng point) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15,
                onTap: (event, point) => onTap(point),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'app.geo_task',
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: center,
                      radius: radiusMeters,
                      useRadiusInMeter: true,
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderColor: AppColors.primary.withValues(alpha: 0.6),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 44,
                      height: 44,
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
