import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/services/location_service.dart';
import '../../domain/entities/geo_reminder.dart';
import '../stores/reminder_store.dart';
import 'add_reminder_page.dart';

/// Home screen: list of reminders and FAB to add new.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.store,
    required this.locationService,
  });

  final ReminderStore store;
  final LocationService locationService;

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
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddReminderPage(
          store: widget.store,
          locationService: widget.locationService,
        ),
      ),
    );
    if (added == true && mounted) {
      widget.store.loadReminders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo-Task'),
      ),
      body: Observer(
        builder: (context) {
          if (widget.store.isLoading && widget.store.reminders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (widget.store.reminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No reminders yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a location-based reminder.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.store.reminders.length,
            itemBuilder: (context, index) {
              final r = widget.store.reminders[index];
              return _ReminderTile(
                reminder: r,
                onToggle: (value) =>
                    widget.store.toggleReminder(r.id, value),
                onDelete: () => widget.store.deleteReminder(r.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  final GeoReminder reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SwitchListTile(
        value: reminder.isActive,
        onChanged: onToggle,
        title: Text(
          reminder.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: reminder.isActive ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.description.isNotEmpty)
              Text(
                reminder.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            Text(
              '${reminder.radius.toInt()} m · ${reminder.triggerType == GeoTriggerType.enter ? "Enter" : "Exit"}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        secondary: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete reminder?'),
                content: Text(
                  'Remove "${reminder.title}"? This cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDelete();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
