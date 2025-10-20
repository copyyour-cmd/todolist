import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_template.dart';
import 'package:todolist/src/features/templates/application/template_providers.dart';
import 'package:todolist/src/features/templates/presentation/template_editor_page.dart';

class TemplateBrowserPage extends ConsumerStatefulWidget {
  const TemplateBrowserPage({super.key});

  static const routeName = 'templates';
  static const routePath = '/templates';

  @override
  ConsumerState<TemplateBrowserPage> createState() => _TemplateBrowserPageState();
}

class _TemplateBrowserPageState extends ConsumerState<TemplateBrowserPage> {
  TemplateCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templatesAsync = _selectedCategory == null
        ? ref.watch(allTemplatesProvider)
        : ref.watch(templatesByCategoryProvider(_selectedCategory!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TemplateEditorPage(),
                ),
              );
              // Refresh templates after returning
              ref.invalidate(allTemplatesProvider);
            },
            tooltip: 'Create Custom Template',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          _buildCategoryFilter(theme),
          const Divider(height: 1),

          // Template list
          Expanded(
            child: templatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Failed to load: $error')),
              data: (templates) {
                if (templates.isEmpty) {
                  return const Center(
                    child: Text('No templates available'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return _TemplateCard(
                      template: template,
                      onTap: () => _showTemplateDetail(context, template),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // All categories chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: _selectedCategory == null,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = null);
                }
              },
            ),
          ),

          // Individual category chips
          for (final category in TemplateCategory.values)
            if (category != TemplateCategory.custom) ...[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  avatar: Icon(category.icon, size: 18),
                  label: Text(category.displayName),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                ),
              ),
            ],
        ],
      ),
    );
  }

  Future<void> _showTemplateDetail(BuildContext context, TaskTemplate template) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TemplateDetailSheet(
        template: template,
        onUse: () => _showTemplateConfigDialog(context, template),
      ),
    );
  }

  Future<void> _showTemplateConfigDialog(BuildContext context, TaskTemplate template) async {
    // Close the detail sheet first
    Navigator.of(context).pop();

    final config = await showDialog<TemplateConfiguration>(
      context: context,
      builder: (context) => _TemplateConfigurationDialog(template: template),
    );

    if (config != null) {
      await _useTemplateWithConfig(template, config);
    }
  }

  Future<void> _useTemplateWithConfig(TaskTemplate template, TemplateConfiguration config) async {
    final notifier = ref.read(templateActionsProvider.notifier);
    await notifier.createTaskFromTemplateWithConfig(template.id, config);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已从模板创建任务: ${template.title}')),
      );
      context.pop();
    }
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.onTap,
  });

  final TaskTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      template.icon ?? template.category.icon,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              template.category.icon,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              template.category.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (template.estimatedMinutes != null) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${template.estimatedMinutes} min',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow icon to indicate tap
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),

              // Description
              if (template.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  template.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Subtasks preview
              if (template.defaultSubtasks.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.checklist,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      '${template.defaultSubtasks.length} steps',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],

              // Usage count
              if (template.usageCount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Used ${template.usageCount} times',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
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

class _TemplateDetailSheet extends ConsumerWidget {
  const _TemplateDetailSheet({required this.template, required this.onUse});

  final TaskTemplate template;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                children: [
                  // Icon and title
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          template.icon ?? template.category.icon,
                          size: 32,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              template.category.displayName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (template.description != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      template.description!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],

                  // Metadata
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (template.estimatedMinutes != null) ...[
                        Chip(
                          avatar: const Icon(Icons.schedule, size: 18),
                          label: Text('${template.estimatedMinutes} min'),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Chip(
                        avatar: Icon(_getPriorityIcon(template.priority), size: 18),
                        label: Text(_getPriorityText(template.priority)),
                      ),
                    ],
                  ),

                  // Subtasks
                  if (template.defaultSubtasks.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Steps',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...template.defaultSubtasks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final subtask = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  subtask.title,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 32),

                  // Use button
                  FilledButton.icon(
                    onPressed: onUse,
                    icon: const Icon(Icons.add),
                    label: const Text('使用此模板'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  // Edit button (for custom templates only)
                  if (!template.isBuiltIn) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TemplateEditorPage(template: template),
                          ),
                        );
                        // Refresh templates
                        ref.invalidate(allTemplatesProvider);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('编辑模板'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return Icons.warning;
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.none:
        return Icons.remove;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return 'Critical';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.none:
        return 'None';
    }
  }
}

/// Dialog for configuring template parameters before creating task
class _TemplateConfigurationDialog extends StatefulWidget {
  const _TemplateConfigurationDialog({required this.template});

  final TaskTemplate template;

  @override
  State<_TemplateConfigurationDialog> createState() => _TemplateConfigurationDialogState();
}

class _TemplateConfigurationDialogState extends State<_TemplateConfigurationDialog> {
  bool _enableRecurrence = false;
  RecurrenceFrequency _frequency = RecurrenceFrequency.daily;
  int _interval = 1;
  DateTime? _dueDate;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    // Set default due date to tomorrow
    _dueDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('配置任务参数'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Template name
            Text(
              widget.template.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Due date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('截止日期'),
              subtitle: Text(
                _dueDate != null
                    ? '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}'
                    : '未设置',
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _dueDate = picked);
                }
              },
            ),

            // Reminder time
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications),
              title: const Text('提醒时间'),
              subtitle: Text(
                _reminderTime != null
                    ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
                    : '不设置提醒',
              ),
              trailing: _reminderTime != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _reminderTime = null),
                    )
                  : null,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
                );
                if (picked != null) {
                  setState(() => _reminderTime = picked);
                }
              },
            ),

            const Divider(),

            // Recurrence toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('设置重复周期'),
              subtitle: const Text('适合健身、学习等长期任务'),
              value: _enableRecurrence,
              onChanged: (value) => setState(() => _enableRecurrence = value),
            ),

            // Recurrence configuration (shown when enabled)
            if (_enableRecurrence) ...[
              const SizedBox(height: 16),

              // Frequency selector
              DropdownButtonFormField<RecurrenceFrequency>(
                decoration: const InputDecoration(
                  labelText: '重复频率',
                  border: OutlineInputBorder(),
                ),
                initialValue: _frequency,
                items: const [
                  DropdownMenuItem(
                    value: RecurrenceFrequency.daily,
                    child: Text('每天'),
                  ),
                  DropdownMenuItem(
                    value: RecurrenceFrequency.weekly,
                    child: Text('每周'),
                  ),
                  DropdownMenuItem(
                    value: RecurrenceFrequency.monthly,
                    child: Text('每月'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _frequency = value);
                  }
                },
              ),

              const SizedBox(height: 16),

              // Interval selector
              TextFormField(
                decoration: InputDecoration(
                  labelText: '间隔',
                  helperText: _getIntervalHelpText(),
                  border: const OutlineInputBorder(),
                  suffixText: _getIntervalUnit(),
                ),
                initialValue: _interval.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    setState(() => _interval = parsed);
                  }
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final config = TemplateConfiguration(
              dueDate: _dueDate,
              reminderTime: _reminderTime,
              recurrenceRule: _enableRecurrence
                  ? RecurrenceRule(
                      frequency: _frequency,
                      interval: _interval,
                    )
                  : null,
            );
            Navigator.of(context).pop(config);
          },
          child: const Text('确认'),
        ),
      ],
    );
  }

  String _getIntervalHelpText() {
    switch (_frequency) {
      case RecurrenceFrequency.daily:
        return '每隔几天重复一次';
      case RecurrenceFrequency.weekly:
        return '每隔几周重复一次';
      case RecurrenceFrequency.monthly:
        return '每隔几个月重复一次';
      case RecurrenceFrequency.yearly:
        return '每隔几年重复一次';
      case RecurrenceFrequency.custom:
        return '自定义重复规则';
    }
  }

  String _getIntervalUnit() {
    switch (_frequency) {
      case RecurrenceFrequency.daily:
        return '天';
      case RecurrenceFrequency.weekly:
        return '周';
      case RecurrenceFrequency.monthly:
        return '月';
      case RecurrenceFrequency.yearly:
        return '年';
      case RecurrenceFrequency.custom:
        return '';
    }
  }
}
