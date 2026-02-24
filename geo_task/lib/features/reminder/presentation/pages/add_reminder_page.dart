import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/geo_reminder.dart';
import '../stores/reminder_store.dart';

/// Screen to create a new location-based reminder.
/// Uses OpenStreetMap via flutter_map (no API key required).
class AddReminderPage extends StatefulWidget {
  const AddReminderPage({
    super.key,
    required this.store,
    required this.locationService,
  });

  final ReminderStore store;
  final LocationService locationService;

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _mapController = MapController();

  double _latitude = 21.0285;
  double _longitude = 105.8542;
  double _radius = AppConstants.radiusDefaultMeters;
  GeoTriggerType _triggerType = GeoTriggerType.enter;
  bool _saving = false;

  LatLng get _selectedPoint => LatLng(_latitude, _longitude);

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final position = await widget.locationService.getCurrentPosition();
      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
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
      final reminder = GeoReminder(
        id: const Uuid().v4(),
        title: title,
        description: _descriptionController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        radius: _radius,
        triggerType: _triggerType,
        isActive: true,
        createdAt: DateTime.now(),
      );
      await widget.store.addReminder(reminder);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: Observer(
        builder: (_) {
          final error = widget.store.errorMessage;
          if (error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error)),
              );
            });
          }
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map (OpenStreetMap)
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedPoint,
                    initialZoom: 15,
                    onTap: (event, point) {
                      setState(() {
                        _latitude = point.latitude;
                        _longitude = point.longitude;
                      });
                    },
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.geo_task',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedPoint,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap on the map to set the reminder location.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Buy milk',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'e.g. Don\'t forget!',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),

            // Radius
            Text(
              'Radius: ${_radius.toInt()} m',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              value: _radius,
              min: AppConstants.radiusMinMeters,
              max: AppConstants.radiusMaxMeters,
              divisions: 19,
              label: '${_radius.toInt()} m',
              onChanged: (v) => setState(() => _radius = v),
            ),
            const SizedBox(height: 16),

            // Trigger type
            DropdownButtonFormField<GeoTriggerType>(
              // ignore: deprecated_member_use
              value: _triggerType,
              decoration: const InputDecoration(
                labelText: 'Notify when',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: GeoTriggerType.enter,
                  child: Text('Entering the area'),
                ),
                DropdownMenuItem(
                  value: GeoTriggerType.exit,
                  child: Text('Leaving the area'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _triggerType = v);
              },
            ),
            const SizedBox(height: 32),

            FilledButton(
              onPressed: _saving ? null : _onSave,
              child: _saving
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
