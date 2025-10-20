import 'package:flutter/material.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';

class RecurrencePicker extends StatefulWidget {
  const RecurrencePicker({
    required this.onChanged, super.key,
    this.initialRule,
  });

  final RecurrenceRule? initialRule;
  final ValueChanged<RecurrenceRule?> onChanged;

  @override
  State<RecurrencePicker> createState() => _RecurrencePickerState();
}

class _RecurrencePickerState extends State<RecurrencePicker> {
  RecurrenceRule? _rule;

  @override
  void initState() {
    super.initState();
    _rule = widget.initialRule;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ListTile(
      leading: const Icon(Icons.repeat),
      title: Text(l10n.taskFormRecurrence),
      subtitle: _rule != null
          ? Text(_formatRecurrence(_rule!, l10n))
          : Text(l10n.taskFormRecurrenceNone),
      onTap: () => _showRecurrencePicker(context),
      trailing: _rule != null
          ? IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                setState(() {
                  _rule = null;
                });
                widget.onChanged(null);
              },
            )
          : const Icon(Icons.chevron_right),
    );
  }

  String _formatRecurrence(RecurrenceRule rule, AppLocalizations l10n) {
    final buffer = StringBuffer();

    switch (rule.frequency) {
      case RecurrenceFrequency.daily:
        if (rule.interval == 1) {
          buffer.write(l10n.recurrenceDaily);
        } else {
          buffer.write(l10n.recurrenceEveryNDays(rule.interval));
        }
      case RecurrenceFrequency.weekly:
        if (rule.interval == 1) {
          buffer.write(l10n.recurrenceWeekly);
        } else {
          buffer.write(l10n.recurrenceEveryNWeeks(rule.interval));
        }
        if (rule.daysOfWeek.isNotEmpty) {
          final days = rule.daysOfWeek.map((d) => _dayName(d, l10n)).join(', ');
          buffer.write(' ($days)');
        }
      case RecurrenceFrequency.monthly:
        if (rule.interval == 1) {
          buffer.write(l10n.recurrenceMonthly);
        } else {
          buffer.write(l10n.recurrenceEveryNMonths(rule.interval));
        }
        if (rule.dayOfMonth != null) {
          buffer.write(' (${l10n.recurrenceDayOfMonth(rule.dayOfMonth!)})');
        }
      case RecurrenceFrequency.yearly:
        if (rule.interval == 1) {
          buffer.write(l10n.recurrenceYearly);
        } else {
          buffer.write(l10n.recurrenceEveryNYears(rule.interval));
        }
      case RecurrenceFrequency.custom:
        buffer.write(l10n.recurrenceCustom);
    }

    if (rule.endDate != null) {
      buffer.write(' ${l10n.recurrenceUntil(rule.endDate!)}');
    } else if (rule.count != null) {
      buffer.write(' (${l10n.recurrenceCount(rule.count!)})');
    }

    return buffer.toString();
  }

  String _dayName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case DateTime.monday:
        return l10n.weekdayMonday;
      case DateTime.tuesday:
        return l10n.weekdayTuesday;
      case DateTime.wednesday:
        return l10n.weekdayWednesday;
      case DateTime.thursday:
        return l10n.weekdayThursday;
      case DateTime.friday:
        return l10n.weekdayFriday;
      case DateTime.saturday:
        return l10n.weekdaySaturday;
      case DateTime.sunday:
        return l10n.weekdaySunday;
      default:
        return '';
    }
  }

  Future<void> _showRecurrencePicker(BuildContext context) async {
    final l10n = context.l10n;

    final frequency = await showDialog<RecurrenceFrequency>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.taskFormRecurrence),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, RecurrenceFrequency.daily),
            child: Text(l10n.recurrenceDaily),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, RecurrenceFrequency.weekly),
            child: Text(l10n.recurrenceWeekly),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, RecurrenceFrequency.monthly),
            child: Text(l10n.recurrenceMonthly),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, RecurrenceFrequency.yearly),
            child: Text(l10n.recurrenceYearly),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, RecurrenceFrequency.custom),
            child: Text(l10n.recurrenceCustom),
          ),
        ],
      ),
    );

    if (frequency == null || !context.mounted) return;

    // Show configuration dialog based on frequency
    final rule = await _showConfigDialog(context, frequency);
    if (rule != null) {
      setState(() {
        _rule = rule;
      });
      widget.onChanged(rule);
    }
  }

  Future<RecurrenceRule?> _showConfigDialog(
    BuildContext context,
    RecurrenceFrequency frequency,
  ) async {
    final l10n = context.l10n;

    return showDialog<RecurrenceRule>(
      context: context,
      builder: (context) => _RecurrenceConfigDialog(
        frequency: frequency,
        initialRule: _rule,
      ),
    );
  }
}

class _RecurrenceConfigDialog extends StatefulWidget {
  const _RecurrenceConfigDialog({
    required this.frequency,
    this.initialRule,
  });

  final RecurrenceFrequency frequency;
  final RecurrenceRule? initialRule;

  @override
  State<_RecurrenceConfigDialog> createState() =>
      _RecurrenceConfigDialogState();
}

class _RecurrenceConfigDialogState extends State<_RecurrenceConfigDialog> {
  late int _interval;
  late List<int> _daysOfWeek;
  int? _dayOfMonth;
  DateTime? _endDate;
  int? _count;

  @override
  void initState() {
    super.initState();
    _interval = widget.initialRule?.interval ?? 1;
    _daysOfWeek = List.from(widget.initialRule?.daysOfWeek ?? <int>[]);
    _dayOfMonth = widget.initialRule?.dayOfMonth;
    _endDate = widget.initialRule?.endDate;
    _count = widget.initialRule?.count;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.recurrenceConfig),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interval
            ListTile(
              title: Text(l10n.recurrenceInterval),
              trailing: DropdownButton<int>(
                value: _interval,
                items: List.generate(30, (i) => i + 1)
                    .map((i) => DropdownMenuItem(value: i, child: Text('$i')))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _interval = value ?? 1;
                  });
                },
              ),
            ),

            // Days of week (for weekly recurrence)
            if (widget.frequency == RecurrenceFrequency.weekly) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.recurrenceDaysOfWeek,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  for (var day = 1; day <= 7; day++)
                    FilterChip(
                      label: Text(_dayAbbr(day, l10n)),
                      selected: _daysOfWeek.contains(day),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _daysOfWeek.add(day);
                          } else {
                            _daysOfWeek.remove(day);
                          }
                        });
                      },
                    ),
                ],
              ),
            ],

            // Day of month (for monthly recurrence)
            if (widget.frequency == RecurrenceFrequency.monthly) ...[
              const Divider(),
              SwitchListTile(
                title: Text(l10n.recurrenceSpecificDay),
                value: _dayOfMonth != null,
                onChanged: (value) {
                  setState(() {
                    _dayOfMonth = value ? DateTime.now().day : null;
                  });
                },
              ),
              if (_dayOfMonth != null)
                ListTile(
                  title: Text(l10n.recurrenceDayOfMonth(_dayOfMonth!)),
                  trailing: DropdownButton<int>(
                    value: _dayOfMonth,
                    items: List.generate(31, (i) => i + 1)
                        .map((i) =>
                            DropdownMenuItem(value: i, child: Text('$i')))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _dayOfMonth = value;
                      });
                    },
                  ),
                ),
            ],

            const Divider(),

            // End options
            RadioListTile<String>(
              title: Text(l10n.recurrenceNeverEnds),
              value: 'never',
              groupValue: _endDate != null
                  ? 'date'
                  : _count != null
                      ? 'count'
                      : 'never',
              onChanged: (value) {
                setState(() {
                  _endDate = null;
                  _count = null;
                });
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.recurrenceEndAfterCount),
              value: 'count',
              groupValue: _endDate != null
                  ? 'date'
                  : _count != null
                      ? 'count'
                      : 'never',
              onChanged: (value) {
                setState(() {
                  _count = 10;
                  _endDate = null;
                });
              },
            ),
            if (_count != null)
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.recurrenceOccurrences,
                  ),
                  controller: TextEditingController(text: '$_count'),
                  onChanged: (value) {
                    _count = int.tryParse(value);
                  },
                ),
              ),
            RadioListTile<String>(
              title: Text(l10n.recurrenceEndOnDate),
              value: 'date',
              groupValue: _endDate != null
                  ? 'date'
                  : _count != null
                      ? 'count'
                      : 'never',
              onChanged: (value) {
                setState(() {
                  _endDate = DateTime.now().add(const Duration(days: 30));
                  _count = null;
                });
              },
            ),
            if (_endDate != null)
              ListTile(
                contentPadding: const EdgeInsets.only(left: 56),
                title: Text(
                  '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null) {
                    setState(() {
                      _endDate = date;
                    });
                  }
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () {
            final rule = RecurrenceRule(
              frequency: widget.frequency,
              interval: _interval,
              daysOfWeek: _daysOfWeek,
              dayOfMonth: _dayOfMonth,
              endDate: _endDate,
              count: _count,
            );
            Navigator.pop(context, rule);
          },
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }

  String _dayAbbr(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case DateTime.monday:
        return l10n.weekdayMondayShort;
      case DateTime.tuesday:
        return l10n.weekdayTuesdayShort;
      case DateTime.wednesday:
        return l10n.weekdayWednesdayShort;
      case DateTime.thursday:
        return l10n.weekdayThursdayShort;
      case DateTime.friday:
        return l10n.weekdayFridayShort;
      case DateTime.saturday:
        return l10n.weekdaySaturdayShort;
      case DateTime.sunday:
        return l10n.weekdaySundayShort;
      default:
        return '';
    }
  }
}
