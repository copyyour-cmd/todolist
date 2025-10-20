import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_template.dart';
import 'package:todolist/src/features/templates/application/template_providers.dart';

class TemplateEditorPage extends ConsumerStatefulWidget {
  const TemplateEditorPage({super.key, this.template});

  final TaskTemplate? template;

  static const routeName = 'template-editor';
  static const routePath = '/templates/editor';

  @override
  ConsumerState<TemplateEditorPage> createState() => _TemplateEditorPageState();
}

class _TemplateEditorPageState extends ConsumerState<TemplateEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _subtaskController;

  TemplateCategory _category = TemplateCategory.custom;
  TaskPriority _priority = TaskPriority.medium;
  int? _estimatedMinutes;
  IconData? _selectedIcon;
  final List<String> _subtasks = [];
  bool _enableRecurrence = false;
  RecurrenceFrequency _recurrenceFrequency = RecurrenceFrequency.daily;
  int _recurrenceInterval = 1;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    _titleController = TextEditingController(text: template?.title ?? '');
    _descriptionController = TextEditingController(text: template?.description ?? '');
    _subtaskController = TextEditingController();

    if (template != null) {
      _category = template.category;
      _priority = template.priority;
      _estimatedMinutes = template.estimatedMinutes;
      _selectedIcon = template.icon;
      _subtasks.addAll(template.defaultSubtasks.map((s) => s.title));
      if (template.defaultRecurrence != null) {
        _enableRecurrence = true;
        _recurrenceFrequency = template.defaultRecurrence!.frequency;
        _recurrenceInterval = template.defaultRecurrence!.interval;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.template != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑模板' : '创建自定义模板'),
        actions: [
          if (isEditing && !widget.template!.isBuiltIn)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
              tooltip: '删除模板',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '模板名称',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入模板名称';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<TemplateCategory>(
              decoration: const InputDecoration(
                labelText: '分类',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              initialValue: _category,
              items: TemplateCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(category.icon, size: 20),
                      const SizedBox(width: 12),
                      Text(category.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
            ),

            const SizedBox(height: 16),

            // Priority
            DropdownButtonFormField<TaskPriority>(
              decoration: const InputDecoration(
                labelText: '优先级',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              initialValue: _priority,
              items: [
                TaskPriority.critical,
                TaskPriority.high,
                TaskPriority.medium,
                TaskPriority.low,
                TaskPriority.none,
              ].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(_getPriorityText(priority)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _priority = value);
                }
              },
            ),

            const SizedBox(height: 16),

            // Estimated minutes
            TextFormField(
              decoration: const InputDecoration(
                labelText: '预估时间(分钟)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.schedule),
                suffixText: '分钟',
              ),
              initialValue: _estimatedMinutes?.toString() ?? '',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsed = int.tryParse(value);
                setState(() => _estimatedMinutes = parsed);
              },
            ),

            const SizedBox(height: 16),

            // Icon selector
            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: const Text('自定义图标'),
                trailing: _selectedIcon != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(_selectedIcon, color: theme.colorScheme.onPrimaryContainer),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () => _showIconPicker(context),
              ),
            ),

            const SizedBox(height: 24),

            // Subtasks section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '任务步骤',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_subtasks.length} 个步骤',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Subtask list
            if (_subtasks.isNotEmpty)
              ...List.generate(_subtasks.length, (index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 12,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(_subtasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() => _subtasks.removeAt(index));
                      },
                    ),
                  ),
                );
              }),

            // Add subtask
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskController,
                    decoration: const InputDecoration(
                      hintText: '添加步骤...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addSubtask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addSubtask,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recurrence settings
            Card(
              child: SwitchListTile(
                title: const Text('默认重复设置'),
                subtitle: const Text('为此模板设置默认的重复规则'),
                value: _enableRecurrence,
                onChanged: (value) => setState(() => _enableRecurrence = value),
              ),
            ),

            if (_enableRecurrence) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<RecurrenceFrequency>(
                decoration: const InputDecoration(
                  labelText: '重复频率',
                  border: OutlineInputBorder(),
                ),
                initialValue: _recurrenceFrequency,
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
                    setState(() => _recurrenceFrequency = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '间隔',
                  border: OutlineInputBorder(),
                  helperText: '每隔多少天/周/月重复一次',
                ),
                initialValue: _recurrenceInterval.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    setState(() => _recurrenceInterval = parsed);
                  }
                },
              ),
            ],

            const SizedBox(height: 32),

            // Save button
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveTemplate,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? '保存中...' : (isEditing ? '保存修改' : '创建模板')),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSubtask() {
    final text = _subtaskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _subtasks.add(text);
        _subtaskController.clear();
      });
    }
  }

  Future<void> _showIconPicker(BuildContext context) async {
    final result = await showDialog<IconData>(
      context: context,
      builder: (context) => _IconPickerDialog(selectedIcon: _selectedIcon),
    );

    if (result != null) {
      setState(() => _selectedIcon = result);
    }
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final idGen = ref.read(idGeneratorProvider);
      final now = DateTime.now();

      final template = TaskTemplate(
        id: widget.template?.id ?? idGen.generate(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        category: _category,
        priority: _priority,
        estimatedMinutes: _estimatedMinutes,
        iconCodePoint: _selectedIcon?.codePoint,
        isBuiltIn: false,
        usageCount: widget.template?.usageCount ?? 0,
        createdAt: widget.template?.createdAt ?? now,
        defaultSubtasks: _subtasks
            .map((title) => SubTask(
                  id: idGen.generate(),
                  title: title,
                  isCompleted: false,
                ))
            .toList(),
        defaultRecurrence: _enableRecurrence
            ? RecurrenceRule(
                frequency: _recurrenceFrequency,
                interval: _recurrenceInterval,
              )
            : null,
      );

      await ref.read(templateActionsProvider.notifier).saveTemplate(template);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.template != null ? '模板已更新' : '自定义模板已创建',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除模板'),
        content: const Text('确定要删除这个自定义模板吗?此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed ?? false && mounted) {
      await ref
          .read(templateActionsProvider.notifier)
          .deleteTemplate(widget.template!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('模板已删除')),
        );
        context.pop();
      }
    }
  }

  String _getPriorityText(TaskPriority priority) {
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

class _IconPickerDialog extends StatefulWidget {
  const _IconPickerDialog({this.selectedIcon});

  final IconData? selectedIcon;

  @override
  State<_IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<_IconPickerDialog> {
  static final List<IconData> _commonIcons = [
    // 工作学习
    Icons.work,
    Icons.school,
    Icons.book,
    Icons.edit,
    Icons.laptop,
    Icons.code,
    Icons.business,

    // 健身运动
    Icons.fitness_center,
    Icons.sports,
    Icons.directions_run,
    Icons.sports_basketball,
    Icons.pool,
    Icons.directions_bike,

    // 生活
    Icons.home,
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.local_cafe,
    Icons.movie,
    Icons.music_note,

    // 健康
    Icons.favorite,
    Icons.healing,
    Icons.local_hospital,
    Icons.spa,
    Icons.psychology,

    // 社交
    Icons.people,
    Icons.person,
    Icons.family_restroom,
    Icons.phone,
    Icons.email,

    // 财务
    Icons.account_balance,
    Icons.payments,
    Icons.savings,
    Icons.wallet,

    // 创意
    Icons.palette,
    Icons.draw,
    Icons.camera_alt,
    Icons.photo,

    // 旅行
    Icons.flight,
    Icons.luggage,
    Icons.hotel,
    Icons.map,

    // 项目
    Icons.folder,
    Icons.task,
    Icons.dashboard,
    Icons.checklist,

    // 习惯
    Icons.track_changes,
    Icons.schedule,
    Icons.timer,
    Icons.alarm,

    // 其他
    Icons.star,
    Icons.bookmark,
    Icons.celebration,
    Icons.emoji_events,
    Icons.lightbulb,
    Icons.rocket_launch,
  ];

  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('选择图标'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _commonIcons.length,
          itemBuilder: (context, index) {
            final icon = _commonIcons[index];
            final isSelected = _selectedIcon == icon;

            return InkWell(
              onTap: () => setState(() => _selectedIcon = icon),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selectedIcon),
          child: const Text('确定'),
        ),
      ],
    );
  }
}
