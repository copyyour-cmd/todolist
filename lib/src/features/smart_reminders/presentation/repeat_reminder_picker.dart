import 'package:flutter/material.dart';
import 'package:todolist/src/core/utils/clock.dart';

/// Configuration for repeating reminders
class RepeatReminderConfig {
  RepeatReminderConfig({
    required this.frequency,
    required this.interval,
    this.endAfter,
    this.nextTime,
  });

  final RepeatFrequency frequency;
  final int interval;
  final int? endAfter; // Number of times to repeat
  final DateTime? nextTime; // Next scheduled time

  RepeatReminderConfig copyWith({
    RepeatFrequency? frequency,
    int? interval,
    int? endAfter,
    DateTime? nextTime,
  }) {
    return RepeatReminderConfig(
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      endAfter: endAfter ?? this.endAfter,
      nextTime: nextTime ?? this.nextTime,
    );
  }

  /// Calculate next occurrence from current time
  DateTime calculateNextOccurrence(DateTime from) {
    switch (frequency) {
      case RepeatFrequency.everyHour:
        return from.add(Duration(hours: interval));
      case RepeatFrequency.everyDay:
        return from.add(Duration(days: interval));
      case RepeatFrequency.everyWeek:
        return from.add(Duration(days: 7 * interval));
      case RepeatFrequency.everyMonth:
        return DateTime(
          from.year,
          from.month + interval,
          from.day,
          from.hour,
          from.minute,
        );
    }
  }

  /// Format the repeat configuration as human-readable string
  String format() {
    final buffer = StringBuffer();

    switch (frequency) {
      case RepeatFrequency.everyHour:
        if (interval == 1) {
          buffer.write('每小时');
        } else {
          buffer.write('每 $interval 小时');
        }
      case RepeatFrequency.everyDay:
        if (interval == 1) {
          buffer.write('每天');
        } else {
          buffer.write('每 $interval 天');
        }
      case RepeatFrequency.everyWeek:
        if (interval == 1) {
          buffer.write('每周');
        } else {
          buffer.write('每 $interval 周');
        }
      case RepeatFrequency.everyMonth:
        if (interval == 1) {
          buffer.write('每月');
        } else {
          buffer.write('每 $interval 月');
        }
    }

    if (endAfter != null) {
      buffer.write('，重复 $endAfter 次');
    } else {
      buffer.write('，永久');
    }

    return buffer.toString();
  }

  /// Format next reminder time
  String formatNextTime() {
    if (nextTime == null) return '';
    
    final now = const SystemClock().now();
    final diff = nextTime!.difference(now);

    if (diff.inDays > 0) {
      return '下次提醒: ${nextTime!.month}月${nextTime!.day}日 ${_formatTime(nextTime!)}';
    } else if (diff.inHours > 0) {
      return '下次提醒: ${diff.inHours}小时后';
    } else if (diff.inMinutes > 0) {
      return '下次提醒: ${diff.inMinutes}分钟后';
    } else {
      return '下次提醒: 即将到来';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

enum RepeatFrequency {
  everyHour,
  everyDay,
  everyWeek,
  everyMonth,
}

/// Repeat reminder picker widget
class RepeatReminderPicker extends StatefulWidget {
  const RepeatReminderPicker({
    required this.onSelect,
    this.initialConfig,
    this.initialTime,
    super.key,
  });

  final void Function(RepeatReminderConfig?) onSelect;
  final RepeatReminderConfig? initialConfig;
  final DateTime? initialTime;

  @override
  State<RepeatReminderPicker> createState() => _RepeatReminderPickerState();

  static Future<void> show(
    BuildContext context, {
    required void Function(RepeatReminderConfig?) onSelect,
    RepeatReminderConfig? initialConfig,
    DateTime? initialTime,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => RepeatReminderPicker(
        onSelect: onSelect,
        initialConfig: initialConfig,
        initialTime: initialTime,
      ),
    );
  }
}

class _RepeatReminderPickerState extends State<RepeatReminderPicker> {
  late RepeatFrequency _frequency;
  late int _interval;
  int? _endAfter;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _frequency = widget.initialConfig?.frequency ?? RepeatFrequency.everyDay;
    _interval = widget.initialConfig?.interval ?? 1;
    _endAfter = widget.initialConfig?.endAfter;
    _startTime = widget.initialTime ?? 
        widget.initialConfig?.nextTime ?? 
        const SystemClock().now().add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '重复提醒设置',
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // First reminder time
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('首次提醒时间'),
              subtitle: Text(_formatDateTime(_startTime)),
              onTap: _selectStartTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor),
              ),
            ),
            const SizedBox(height: 16),

            // Frequency
            Text(
              '重复频率',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FrequencyChip(
                  label: '每小时',
                  frequency: RepeatFrequency.everyHour,
                  selected: _frequency == RepeatFrequency.everyHour,
                  onSelected: (freq) => setState(() => _frequency = freq),
                ),
                _FrequencyChip(
                  label: '每天',
                  frequency: RepeatFrequency.everyDay,
                  selected: _frequency == RepeatFrequency.everyDay,
                  onSelected: (freq) => setState(() => _frequency = freq),
                ),
                _FrequencyChip(
                  label: '每周',
                  frequency: RepeatFrequency.everyWeek,
                  selected: _frequency == RepeatFrequency.everyWeek,
                  onSelected: (freq) => setState(() => _frequency = freq),
                ),
                _FrequencyChip(
                  label: '每月',
                  frequency: RepeatFrequency.everyMonth,
                  selected: _frequency == RepeatFrequency.everyMonth,
                  onSelected: (freq) => setState(() => _frequency = freq),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Interval
            Row(
              children: [
                Text(
                  _getIntervalLabel(),
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: _interval,
                    underline: const SizedBox(),
                    items: _getIntervalOptions()
                        .map((i) => DropdownMenuItem(
                              value: i,
                              child: Text('$i'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _interval = value ?? 1;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // End after
            SwitchListTile(
              title: const Text('设置重复次数'),
              subtitle: _endAfter != null ? Text('重复 $_endAfter 次') : null,
              value: _endAfter != null,
              onChanged: (value) {
                setState(() {
                  _endAfter = value ? 10 : null;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor),
              ),
            ),
            if (_endAfter != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('重复次数:'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Slider(
                        value: _endAfter!.toDouble(),
                        min: 1,
                        max: 100,
                        divisions: 99,
                        label: '$_endAfter 次',
                        onChanged: (value) {
                          setState(() {
                            _endAfter = value.toInt();
                          });
                        },
                      ),
                    ),
                    Text('$_endAfter'),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '预览',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _buildConfig().format(),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildConfig().formatNextTime(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onSelect(null);
                      Navigator.pop(context);
                    },
                    child: const Text('清除重复'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {
                      widget.onSelect(_buildConfig());
                      Navigator.pop(context);
                    },
                    child: const Text('确认'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  RepeatReminderConfig _buildConfig() {
    return RepeatReminderConfig(
      frequency: _frequency,
      interval: _interval,
      endAfter: _endAfter,
      nextTime: _startTime,
    );
  }

  String _getIntervalLabel() {
    switch (_frequency) {
      case RepeatFrequency.everyHour:
        return '每隔几小时';
      case RepeatFrequency.everyDay:
        return '每隔几天';
      case RepeatFrequency.everyWeek:
        return '每隔几周';
      case RepeatFrequency.everyMonth:
        return '每隔几月';
    }
  }

  List<int> _getIntervalOptions() {
    switch (_frequency) {
      case RepeatFrequency.everyHour:
        return List.generate(24, (i) => i + 1); // 1-24 hours
      case RepeatFrequency.everyDay:
        return List.generate(30, (i) => i + 1); // 1-30 days
      case RepeatFrequency.everyWeek:
        return List.generate(12, (i) => i + 1); // 1-12 weeks
      case RepeatFrequency.everyMonth:
        return List.generate(12, (i) => i + 1); // 1-12 months
    }
  }

  String _formatDateTime(DateTime time) {
    return '${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectStartTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: const SystemClock().now(),
      lastDate: const SystemClock().now().add(const Duration(days: 365)),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );

    if (time == null || !mounted) return;

    setState(() {
      _startTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }
}

class _FrequencyChip extends StatelessWidget {
  const _FrequencyChip({
    required this.label,
    required this.frequency,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final RepeatFrequency frequency;
  final bool selected;
  final void Function(RepeatFrequency) onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(frequency),
      showCheckmark: false,
    );
  }
}


