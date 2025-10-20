import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';

extension _L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Smart reminder configuration bottom sheet
class SmartReminderConfigSheet extends StatefulWidget {
  const SmartReminderConfigSheet({super.key, this.initialConfigs});

  final List<SmartReminderConfig>? initialConfigs;

  static Future<List<SmartReminderConfig>?> show(
    BuildContext context, {
    List<SmartReminderConfig>? initialConfigs,
  }) {
    return showModalBottomSheet<List<SmartReminderConfig>>(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          SmartReminderConfigSheet(initialConfigs: initialConfigs),
    );
  }

  @override
  State<SmartReminderConfigSheet> createState() =>
      _SmartReminderConfigSheetState();
}

class _SmartReminderConfigSheetState extends State<SmartReminderConfigSheet> {
  late List<SmartReminderConfig> _configs;

  @override
  void initState() {
    super.initState();
    _configs = widget.initialConfigs != null
        ? List.from(widget.initialConfigs!)
        : [];
  }

  Future<void> _addTimeReminder() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
    );

    if (selectedTime == null || !mounted) return;

    final scheduledAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      _configs.add(SmartReminderConfig.time(scheduledAt: scheduledAt));
    });
  }

  Future<void> _addRepeatingReminder() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
    );

    if (selectedTime == null || !mounted) return;

    final scheduledAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Show dialog to configure repeat settings
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => _RepeatConfigDialog(),
    );

    if (result == null || !mounted) return;

    setState(() {
      _configs.add(
        SmartReminderConfig.repeating(
          scheduledAt: scheduledAt,
          intervalMinutes: result['interval']!,
          maxRepeats: result['maxRepeats']!,
        ),
      );
    });
  }

  void _removeReminder(int index) {
    setState(() {
      _configs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  l10n.smartReminderSheetTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context, _configs),
                  child: Text(l10n.smartReminderSheetDone),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Reminder list
          if (_configs.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _configs.length,
              itemBuilder: (context, index) {
                final config = _configs[index];
                return ListTile(
                  leading: Icon(
                    config.type == 'repeating' ? Icons.repeat : Icons.alarm,
                  ),
                  title: Text(_formatDateTime(context, config.scheduledAt)),
                  subtitle: config.type == 'repeating'
                      ? Text(
                          l10n.smartReminderEveryMinutes(
                            config.repeatIntervalMinutes ?? 0,
                            config.repeatMaxCount ?? 0,
                          ),
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeReminder(index),
                  ),
                );
              },
            ),

          // Add buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _addTimeReminder,
                  icon: const Icon(Icons.alarm_add),
                  label: Text(l10n.smartReminderAddTime),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _addRepeatingReminder,
                  icon: const Icon(Icons.repeat),
                  label: Text(l10n.smartReminderAddRepeating),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(BuildContext context, DateTime dt) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(dt.year, dt.month, dt.day);

    String dateStr;
    if (dateOnly == today) {
      dateStr = l10n.smartReminderToday;
    } else if (dateOnly == tomorrow) {
      dateStr = l10n.smartReminderTomorrow;
    } else {
      dateStr = DateFormat('yyyy/MM/dd').format(dt);
    }

    final timeStr = DateFormat('HH:mm').format(dt);
    return l10n.smartReminderAt(dateStr, timeStr);
  }
}

class _RepeatConfigDialog extends StatefulWidget {
  @override
  State<_RepeatConfigDialog> createState() => _RepeatConfigDialogState();
}

class _RepeatConfigDialogState extends State<_RepeatConfigDialog> {
  int _intervalMinutes = 30;
  int _maxRepeats = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.smartReminderRepeatTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Interval selector
          Row(
            children: [
              Text(l10n.smartReminderRepeatInterval),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: _intervalMinutes,
                items: [
                  DropdownMenuItem(
                    value: 5,
                    child: Text(
                      '${l10n.smartReminderRepeatEvery} 5 ${l10n.smartReminderRepeatMinutes}',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text(
                      '${l10n.smartReminderRepeatEvery} 10 ${l10n.smartReminderRepeatMinutes}',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 15,
                    child: Text(
                      '${l10n.smartReminderRepeatEvery} 15 ${l10n.smartReminderRepeatMinutes}',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 30,
                    child: Text(
                      '${l10n.smartReminderRepeatEvery} 30 ${l10n.smartReminderRepeatMinutes}',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 60,
                    child: Text(
                      '${l10n.smartReminderRepeatEvery} 1 ${l10n.smartReminderRepeatHours}',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 120,
                    child: Text(
                      '${l10n.smartReminderRepeatEvery} 2 ${l10n.smartReminderRepeatHours}',
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _intervalMinutes = value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Max repeats selector
          Row(
            children: [
              Text(l10n.smartReminderRepeatTimes),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: _maxRepeats,
                items: [
                  DropdownMenuItem(
                    value: 3,
                    child: Text('3 ${l10n.smartReminderTimes}'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('5 ${l10n.smartReminderTimes}'),
                  ),
                  DropdownMenuItem(
                    value: 10,
                    child: Text('10 ${l10n.smartReminderTimes}'),
                  ),
                  DropdownMenuItem(
                    value: 15,
                    child: Text('15 ${l10n.smartReminderTimes}'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _maxRepeats = value);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, {
            'interval': _intervalMinutes,
            'maxRepeats': _maxRepeats,
          }),
          child: Text(context.l10n.smartReminderRepeatConfirm),
        ),
      ],
    );
  }
}
