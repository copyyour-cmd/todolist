import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todolist/src/core/utils/date_formatter.dart';
import 'package:todolist/src/domain/entities/smart_reminder.dart';
import 'package:todolist/src/features/smart_reminders/application/smart_reminder_providers.dart';

class ReminderHistoryPage extends ConsumerStatefulWidget {
  const ReminderHistoryPage({super.key});

  static const routePath = '/reminder-history';
  static const routeName = 'reminderHistory';

  @override
  ConsumerState<ReminderHistoryPage> createState() =>
      _ReminderHistoryPageState();
}

class _ReminderHistoryPageState
    extends ConsumerState<ReminderHistoryPage>
    with SingleTickerProviderStateMixin {
  List<ReminderHistory>? _history;
  bool _isLoading = true;
  String _filter = 'all'; // all, completed, dismissed, pending
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(smartReminderServiceProvider);
      final history = await service.getHistory(limit: 100);
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<ReminderHistory> get _filteredHistory {
    if (_history == null) return [];
    
    switch (_filter) {
      case 'completed':
        return _history!.where((h) => h.wasCompleted).toList();
      case 'dismissed':
        return _history!.where((h) => h.wasDismissed).toList();
      case 'pending':
        return _history!.where((h) => !h.wasCompleted && !h.wasDismissed).toList();
      default:
        return _history!;
    }
  }

  Map<String, List<ReminderHistory>> get _groupedHistory {
    final grouped = <String, List<ReminderHistory>>{};
    final now = DateTime.now();

    for (final item in _filteredHistory) {
      final diff = now.difference(item.triggeredAt);
      String key;

      if (diff.inDays == 0) {
        key = '今天';
      } else if (diff.inDays == 1) {
        key = '昨天';
      } else if (diff.inDays < 7) {
        key = '本周';
      } else if (diff.inDays < 30) {
        key = '本月';
      } else {
        key = '更早';
      }

      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped;
  }

  int get _completedCount =>
      _history?.where((h) => h.wasCompleted).length ?? 0;
  int get _dismissedCount =>
      _history?.where((h) => h.wasDismissed).length ?? 0;
  int get _pendingCount => _history
          ?.where((h) => !h.wasCompleted && !h.wasDismissed)
          .length ??
      0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('提醒历史'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
            tooltip: '刷新',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _filter = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('全部'),
              ),
              const PopupMenuItem(
                value: 'pending',
                child: Text('待处理'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('已完成'),
              ),
              const PopupMenuItem(
                value: 'dismissed',
                child: Text('已忽略'),
              ),
            ],
          ),
        ],
        bottom: _history != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _StatCard(
                            label: '全部',
                            value: _history!.length,
                            icon: Icons.notifications,
                            color: colorScheme.primary,
                            isSelected: _filter == 'all',
                            onTap: () => setState(() => _filter = 'all'),
                          ),
                          const SizedBox(width: 8),
                          _StatCard(
                            label: '待处理',
                            value: _pendingCount,
                            icon: Icons.pending_actions,
                            color: Colors.orange,
                            isSelected: _filter == 'pending',
                            onTap: () => setState(() => _filter = 'pending'),
                          ),
                          const SizedBox(width: 8),
                          _StatCard(
                            label: '已完成',
                            value: _completedCount,
                            icon: Icons.check_circle,
                            color: Colors.green,
                            isSelected: _filter == 'completed',
                            onTap: () => setState(() => _filter = 'completed'),
                          ),
                          const SizedBox(width: 8),
                          _StatCard(
                            label: '已忽略',
                            value: _dismissedCount,
                            icon: Icons.cancel,
                            color: Colors.grey,
                            isSelected: _filter == 'dismissed',
                            onTap: () => setState(() => _filter = 'dismissed'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history == null || _history!.isEmpty
              ? _buildEmptyState(theme)
              : _filteredHistory.isEmpty
                  ? _buildNoResultsState(theme)
                  : _buildHistoryList(theme),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            '还没有提醒历史',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '当提醒触发时，它们会显示在这里',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add),
            label: const Text('创建提醒'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '没有找到匹配的记录',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() => _filter = 'all'),
            child: const Text('清除筛选'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(ThemeData theme) {
    final grouped = _groupedHistory;

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final key = grouped.keys.elementAt(index);
          final items = grouped[key]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      key,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: theme.dividerColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${items.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HistoryCard(
                      history: item,
                      onMarkCompleted: () => _markCompleted(item.id),
                      onMarkDismissed: () => _markDismissed(item.id),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  Future<void> _markCompleted(String historyId) async {
    try {
      final service = ref.read(smartReminderServiceProvider);
      await service.markHistoryCompleted(historyId);
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('已标记为完成'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('错误: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markDismissed(String historyId) async {
    try {
      final service = ref.read(smartReminderServiceProvider);
      await service.markHistoryDismissed(historyId);
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('已忽略'),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('错误: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.15)
                : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: color, width: 2)
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                '$value',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected ? color : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? color
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.history,
    required this.onMarkCompleted,
    required this.onMarkDismissed,
  });

  final ReminderHistory history;
  final VoidCallback onMarkCompleted;
  final VoidCallback onMarkDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm');

    IconData typeIcon;
    Color typeColor;
    String typeLabel;
    
    switch (history.type) {
      case ReminderType.time:
        typeIcon = Icons.schedule;
        typeColor = Colors.blue;
        typeLabel = '时间提醒';
      case ReminderType.location:
        typeIcon = Icons.location_on;
        typeColor = Colors.green;
        typeLabel = '位置提醒';
      case ReminderType.repeating:
        typeIcon = Icons.repeat;
        typeColor = Colors.orange;
        typeLabel = '重复提醒';
    }

    return Card(
      elevation: history.wasCompleted || history.wasDismissed ? 0 : 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to task detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(typeIcon, size: 20, color: typeColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          history.taskTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: history.wasCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                typeLabel,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: typeColor,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (history.wasCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '已完成',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (history.wasDismissed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cancel,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '已忽略',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ChineseDateFormatter.relative(history.triggeredAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeFormat.format(history.triggeredAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (history.locationName != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        history.locationName!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (!history.wasCompleted && !history.wasDismissed) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onMarkDismissed,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('忽略'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: onMarkCompleted,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('完成'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

