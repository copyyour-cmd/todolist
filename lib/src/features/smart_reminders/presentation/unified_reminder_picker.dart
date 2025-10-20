import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:intl/intl.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';
import 'package:todolist/src/features/reminders/presentation/reminder_mode_dialog.dart';
import 'package:todolist/src/features/reminders/application/reminder_preferences_service.dart';

/// 统一的提醒选择器 - 合并了快速提醒和智能提醒功能
class UnifiedReminderPicker extends ConsumerStatefulWidget {
  const UnifiedReminderPicker({
    required this.onSelect,
    this.currentReminder,
    this.smartReminders,
    this.currentReminderMode,
    super.key,
  });

  final void Function(
    DateTime? mainReminder,
    List<SmartReminderConfig> smartReminders,
    ReminderMode reminderMode,
  ) onSelect;
  final DateTime? currentReminder;
  final List<SmartReminderConfig>? smartReminders;
  final ReminderMode? currentReminderMode;

  static Future<void> show(
    BuildContext context, {
    required void Function(
      DateTime? mainReminder,
      List<SmartReminderConfig> smartReminders,
      ReminderMode reminderMode,
    ) onSelect,
    DateTime? currentReminder,
    List<SmartReminderConfig>? smartReminders,
    ReminderMode? currentReminderMode,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => UnifiedReminderPicker(
        onSelect: onSelect,
        currentReminder: currentReminder,
        smartReminders: smartReminders,
        currentReminderMode: currentReminderMode,
      ),
    );
  }

  @override
  ConsumerState<UnifiedReminderPicker> createState() => _UnifiedReminderPickerState();
}

class _UnifiedReminderPickerState extends ConsumerState<UnifiedReminderPicker> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _mainReminder;
  List<SmartReminderConfig> _smartReminders = [];
  late ReminderMode _reminderMode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _mainReminder = widget.currentReminder;
    _smartReminders = widget.smartReminders != null
        ? List.from(widget.smartReminders!)
        : [];
    // 如果有传入的提醒模式就用它，否则使用用户偏好的默认值
    _reminderMode = widget.currentReminderMode ?? ReminderMode.notification;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyAndClose() {
    widget.onSelect(_mainReminder, _smartReminders, _reminderMode);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = const SystemClock().now();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, size: 28),
                const SizedBox(width: 12),
                Text(
                  '设置提醒',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _applyAndClose,
                  child: const Text('完成', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 提醒模式选择器
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () async {
                final selectedMode = await showReminderModeDialog(
                  context,
                  currentMode: _reminderMode,
                );
                if (selectedMode != null) {
                  setState(() => _reminderMode = selectedMode);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _reminderMode.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '提醒方式',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _reminderMode.displayName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab 切换
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.access_time), text: '快速设置'),
              Tab(icon: Icon(Icons.auto_awesome), text: '高级提醒'),
            ],
          ),

          // Tab 内容
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: TabBarView(
              controller: _tabController,
              children: [
                // 快速设置标签页
                _buildQuickTab(now),
                // 高级提醒标签页
                _buildAdvancedTab(now),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 快速设置标签页
  Widget _buildQuickTab(DateTime now) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '主要提醒时间',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        _QuickOption(
          title: '15分钟后',
          subtitle: _formatTime(now.add(const Duration(minutes: 15))),
          onTap: () => setState(() => _mainReminder = now.add(const Duration(minutes: 15))),
          isSelected: _isSelected(now.add(const Duration(minutes: 15))),
        ),
        _QuickOption(
          title: '1小时后',
          subtitle: _formatTime(now.add(const Duration(hours: 1))),
          onTap: () => setState(() => _mainReminder = now.add(const Duration(hours: 1))),
          isSelected: _isSelected(now.add(const Duration(hours: 1))),
        ),
        _QuickOption(
          title: '3小时后',
          subtitle: _formatTime(now.add(const Duration(hours: 3))),
          onTap: () => setState(() => _mainReminder = now.add(const Duration(hours: 3))),
          isSelected: _isSelected(now.add(const Duration(hours: 3))),
        ),
        _QuickOption(
          title: '明天上午9点',
          subtitle: _formatTime(_tomorrow(9, 0)),
          onTap: () => setState(() => _mainReminder = _tomorrow(9, 0)),
          isSelected: _isSelected(_tomorrow(9, 0)),
        ),
        _QuickOption(
          title: '明天下午2点',
          subtitle: _formatTime(_tomorrow(14, 0)),
          onTap: () => setState(() => _mainReminder = _tomorrow(14, 0)),
          isSelected: _isSelected(_tomorrow(14, 0)),
        ),
        _QuickOption(
          title: '下周一上午9点',
          subtitle: _formatTime(_nextMonday(9, 0)),
          onTap: () => setState(() => _mainReminder = _nextMonday(9, 0)),
          isSelected: _isSelected(_nextMonday(9, 0)),
        ),
        const Divider(),
        _QuickOption(
          title: '自定义时间',
          icon: Icons.schedule,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _mainReminder ?? now.add(const Duration(days: 1)),
              firstDate: now,
              lastDate: now.add(const Duration(days: 365)),
            );
            if (date == null || !mounted) return;

            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                _mainReminder ?? now.add(const Duration(hours: 1)),
              ),
            );
            if (time == null || !mounted) return;

            setState(() {
              _mainReminder = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          },
        ),
        if (_mainReminder != null) ...[
          const Divider(),
          _QuickOption(
            title: '清除提醒',
            icon: Icons.clear,
            textColor: Colors.red,
            onTap: () => setState(() => _mainReminder = null),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  // 高级提醒标签页
  Widget _buildAdvancedTab(DateTime now) {
    return Column(
      children: [
        // 当前设置的额外提醒列表
        Expanded(
          child: _smartReminders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '还没有额外提醒',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '添加多个提醒时间或重复提醒',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _smartReminders.length,
                  itemBuilder: (context, index) {
                    final config = _smartReminders[index];
                    return ListTile(
                      leading: Icon(
                        config.type == 'repeating' ? Icons.repeat : Icons.alarm,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(_formatDateTime(config.scheduledAt)),
                      subtitle: config.type == 'repeating'
                          ? Text(
                              '每${config.repeatIntervalMinutes}分钟重复，共${config.repeatMaxCount}次',
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() => _smartReminders.removeAt(index));
                        },
                      ),
                    );
                  },
                ),
        ),

        // 添加按钮区域
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _addTimeReminder,
                icon: const Icon(Icons.alarm_add),
                label: const Text('添加额外提醒时间'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _addRepeatingReminder,
                icon: const Icon(Icons.repeat),
                label: const Text('添加重复提醒'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
      _smartReminders.add(SmartReminderConfig.time(scheduledAt: scheduledAt));
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

    // 显示重复配置对话框
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => _RepeatConfigDialog(),
    );

    if (result == null || !mounted) return;

    setState(() {
      _smartReminders.add(
        SmartReminderConfig.repeating(
          scheduledAt: scheduledAt,
          intervalMinutes: result['interval']!,
          maxRepeats: result['maxRepeats']!,
        ),
      );
    });
  }

  bool _isSelected(DateTime time) {
    if (_mainReminder == null) return false;
    return time.difference(_mainReminder!).abs().inMinutes < 5;
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

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(dt.year, dt.month, dt.day);

    String dateStr;
    if (dateOnly == today) {
      dateStr = '今天';
    } else if (dateOnly == tomorrow) {
      dateStr = '明天';
    } else {
      dateStr = DateFormat('MM/dd').format(dt);
    }

    final timeStr = DateFormat('HH:mm').format(dt);
    return '$dateStr $timeStr';
  }
}

class _QuickOption extends StatelessWidget {
  const _QuickOption({
    required this.title,
    required this.onTap,
    this.subtitle,
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

class _RepeatConfigDialog extends StatefulWidget {
  @override
  State<_RepeatConfigDialog> createState() => _RepeatConfigDialogState();
}

class _RepeatConfigDialogState extends State<_RepeatConfigDialog> {
  int _intervalMinutes = 30;
  int _maxRepeats = 5;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('重复提醒设置'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 间隔选择
          Row(
            children: [
              const Text('提醒间隔'),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<int>(
                  value: _intervalMinutes,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('每 5 分钟')),
                    DropdownMenuItem(value: 10, child: Text('每 10 分钟')),
                    DropdownMenuItem(value: 15, child: Text('每 15 分钟')),
                    DropdownMenuItem(value: 30, child: Text('每 30 分钟')),
                    DropdownMenuItem(value: 60, child: Text('每 1 小时')),
                    DropdownMenuItem(value: 120, child: Text('每 2 小时')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _intervalMinutes = value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 次数选择
          Row(
            children: [
              const Text('重复次数'),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<int>(
                  value: _maxRepeats,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 3, child: Text('3 次')),
                    DropdownMenuItem(value: 5, child: Text('5 次')),
                    DropdownMenuItem(value: 10, child: Text('10 次')),
                    DropdownMenuItem(value: 15, child: Text('15 次')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _maxRepeats = value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 说明
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '将从指定时间开始，每$_intervalMinutes分钟提醒一次，共$_maxRepeats次',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, {
            'interval': _intervalMinutes,
            'maxRepeats': _maxRepeats,
          }),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
