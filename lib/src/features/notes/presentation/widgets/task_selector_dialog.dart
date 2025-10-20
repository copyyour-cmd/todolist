import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';

/// 任务选择对话框
class TaskSelectorDialog extends ConsumerStatefulWidget {
  const TaskSelectorDialog({
    super.key,
    this.selectedTaskIds = const [],
    this.multiSelect = false,
  });

  final List<String> selectedTaskIds;
  final bool multiSelect;

  @override
  ConsumerState<TaskSelectorDialog> createState() => _TaskSelectorDialogState();
}

class _TaskSelectorDialogState extends ConsumerState<TaskSelectorDialog> {
  late Set<String> _selectedIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.selectedTaskIds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(allTasksProvider);

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(Icons.task, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  widget.multiSelect ? '选择任务' : '选择任务',
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 搜索框
            TextField(
              decoration: InputDecoration(
                hintText: '搜索任务...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),

            // 任务列表
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  // 过滤未完成的任务
                  final activeTasks = tasks
                      .where((task) => task.status != TaskStatus.completed &&
                                      task.status != TaskStatus.cancelled)
                      .toList();

                  // 应用搜索过滤
                  final filteredTasks = _searchQuery.isEmpty
                      ? activeTasks
                      : activeTasks
                          .where((task) =>
                              task.title.toLowerCase().contains(_searchQuery) ||
                              (task.notes
                                      ?.toLowerCase()
                                      .contains(_searchQuery) ??
                                  false))
                          .toList();

                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_outlined,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty ? '暂无待办任务' : '未找到匹配的任务',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final isSelected = _selectedIds.contains(task.id);

                      return _TaskListItem(
                        task: task,
                        isSelected: isSelected,
                        onTap: () {
                          if (widget.multiSelect) {
                            setState(() {
                              if (isSelected) {
                                _selectedIds.remove(task.id);
                              } else {
                                _selectedIds.add(task.id);
                              }
                            });
                          } else {
                            // 单选模式:直接返回选中的任务ID
                            Navigator.pop(context, task.id);
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('加载失败: $error'),
                ),
              ),
            ),

            // 底部按钮(仅多选模式)
            if (widget.multiSelect) ...[
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '已选择 ${_selectedIds.length} 个任务',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () =>
                            Navigator.pop(context, _selectedIds.toList()),
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 任务列表项
class _TaskListItem extends StatelessWidget {
  const _TaskListItem({
    required this.task,
    required this.isSelected,
    required this.onTap,
  });

  final Task task;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getPriorityColor(task.priority).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected
                ? theme.colorScheme.primary
                : _getPriorityColor(task.priority),
          ),
        ),
        title: Text(
          task.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: task.notes != null
            ? Text(
                task.notes!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 优先级标记
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPriorityLabel(task.priority),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _getPriorityColor(task.priority),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (task.dueAt != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.calendar_today,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return Colors.red;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.low:
        return Colors.grey;
      case TaskPriority.none:
        return Colors.grey[400]!;
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return '紧急';
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
      case TaskPriority.none:
        return '无';
    }
  }
}
