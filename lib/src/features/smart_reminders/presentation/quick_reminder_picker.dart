import 'package:flutter/material.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/core/utils/clock.dart';

/// Quick reminder time picker with preset options
class QuickReminderPicker extends StatelessWidget {
  const QuickReminderPicker({
    required this.onSelect,
    this.currentReminder,
    super.key,
  });

  final void Function(DateTime?) onSelect;
  final DateTime? currentReminder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = const SystemClock().now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '快速设置提醒',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        _QuickOption(
          title: '15分钟后',
          subtitle: _formatTime(now.add(const Duration(minutes: 15))),
          onTap: () {
            onSelect(now.add(const Duration(minutes: 15)));
            Navigator.of(context).pop();
          },
          isSelected: _isSelected(now.add(const Duration(minutes: 15))),
        ),
        _QuickOption(
          title: '1小时后',
          subtitle: _formatTime(now.add(const Duration(hours: 1))),
          onTap: () {
            onSelect(now.add(const Duration(hours: 1)));
            Navigator.of(context).pop();
          },
          isSelected: _isSelected(now.add(const Duration(hours: 1))),
        ),
        _QuickOption(
          title: '3小时后',
          subtitle: _formatTime(now.add(const Duration(hours: 3))),
          onTap: () {
            onSelect(now.add(const Duration(hours: 3)));
            Navigator.of(context).pop();
          },
          isSelected: _isSelected(now.add(const Duration(hours: 3))),
        ),
        _QuickOption(
          title: '明天上午9点',
          subtitle: _formatTime(_tomorrow(9, 0)),
          onTap: () {
            onSelect(_tomorrow(9, 0));
            Navigator.of(context).pop();
          },
          isSelected: _isSelected(_tomorrow(9, 0)),
        ),
        _QuickOption(
          title: '明天下午2点',
          subtitle: _formatTime(_tomorrow(14, 0)),
          onTap: () {
            onSelect(_tomorrow(14, 0));
            Navigator.of(context).pop();
          },
          isSelected: _isSelected(_tomorrow(14, 0)),
        ),
        _QuickOption(
          title: '下周一上午9点',
          subtitle: _formatTime(_nextMonday(9, 0)),
          onTap: () {
            onSelect(_nextMonday(9, 0));
            Navigator.of(context).pop();
          },
          isSelected: _isSelected(_nextMonday(9, 0)),
        ),
        const Divider(),
        _QuickOption(
          title: '自定义时间',
          icon: Icons.schedule,
          onTap: () async {
            Navigator.of(context).pop();
            final date = await showDatePicker(
              context: context,
              initialDate: currentReminder ?? now.add(const Duration(days: 1)),
              firstDate: now,
              lastDate: now.add(const Duration(days: 365)),
            );
            if (date == null) return;

            if (!context.mounted) return;
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                currentReminder ?? now.add(const Duration(hours: 1)),
              ),
            );
            if (time == null) return;

            final dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            onSelect(dateTime);
          },
        ),
        if (currentReminder != null) ...[
          const Divider(),
          _QuickOption(
            title: '清除提醒',
            icon: Icons.clear,
            textColor: Colors.red,
            onTap: () {
              onSelect(null);
              Navigator.of(context).pop();
            },
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  bool _isSelected(DateTime time) {
    if (currentReminder == null) return false;
    return time.difference(currentReminder!).abs().inMinutes < 5;
  }

  DateTime _tomorrow(int hour, int minute) {
    final now = const SystemClock().now();
    return DateTime(
      now.year,
      now.month,
      now.day + 1,
      hour,
      minute,
    );
  }

  DateTime _nextMonday(int hour, int minute) {
    final now = const SystemClock().now();
    final daysUntilMonday = (DateTime.monday - now.weekday + 7) % 7;
    final nextMonday = now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
    return DateTime(
      nextMonday.year,
      nextMonday.month,
      nextMonday.day,
      hour,
      minute,
    );
  }

  String _formatTime(DateTime time) {
    final now = const SystemClock().now();
    final diff = time.difference(now);

    if (diff.inDays == 0) {
      return '今天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return '明天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  static Future<void> show(
    BuildContext context, {
    required void Function(DateTime?) onSelect,
    DateTime? currentReminder,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) => QuickReminderPicker(
        onSelect: onSelect,
        currentReminder: currentReminder,
      ),
    );
  }
}

class _QuickOption extends StatelessWidget {
  const _QuickOption({
    required this.title,
    required this.onTap, this.subtitle,
    this.icon,
    this.isSelected = false,
    this.textColor,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: textColor)
          : isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.access_time),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
      selected: isSelected,
    );
  }
}
