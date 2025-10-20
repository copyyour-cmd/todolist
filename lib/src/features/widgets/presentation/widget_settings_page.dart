import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/widgets/application/widget_providers.dart';

class WidgetSettingsPage extends ConsumerStatefulWidget {
  const WidgetSettingsPage({super.key});

  static const routePath = '/widget-settings';
  static const routeName = 'widgetSettings';

  @override
  ConsumerState<WidgetSettingsPage> createState() =>
      _WidgetSettingsPageState();
}

class _WidgetSettingsPageState extends ConsumerState<WidgetSettingsPage> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('小部件设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.widgets,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '今日任务小部件',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '在主屏幕显示今天的任务列表，包括逾期和即将到期的任务。',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _isUpdating ? null : _updateWidget,
                    icon: _isUpdating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(_isUpdating ? '更新中...' : '立即更新小部件'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '使用说明',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInstruction(
                    '1.',
                    '长按主屏幕空白处',
                    theme,
                  ),
                  _buildInstruction(
                    '2.',
                    '选择"小部件"或"Widgets"',
                    theme,
                  ),
                  _buildInstruction(
                    '3.',
                    '找到"TodoList"应用',
                    theme,
                  ),
                  _buildInstruction(
                    '4.',
                    '拖动"今日任务"小部件到主屏幕',
                    theme,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.featured_play_list,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '小部件功能',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFeature(
                    Icons.view_list,
                    '显示最多5个今日任务',
                    theme,
                  ),
                  _buildFeature(
                    Icons.priority_high,
                    '按优先级和截止时间排序',
                    theme,
                  ),
                  _buildFeature(
                    Icons.warning_amber,
                    '高亮显示逾期任务',
                    theme,
                  ),
                  _buildFeature(
                    Icons.touch_app,
                    '点击任务快速打开详情',
                    theme,
                  ),
                  _buildFeature(
                    Icons.auto_awesome,
                    '自动更新任务状态',
                    theme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String number, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              number,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateWidget() async {
    setState(() => _isUpdating = true);

    try {
      final widgetService = ref.read(widgetServiceProvider);
      final tasksAsync = ref.read(allTasksProvider);

      await tasksAsync.when(
        data: (tasks) async {
          await widgetService.updateTodayTasks(tasks);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('小部件已更新'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        loading: () async {},
        error: (error, stack) async {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('更新失败: $error')),
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}
