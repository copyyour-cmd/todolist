import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todolist/l10n/app_localizations.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/date_formatter.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/attachment.dart';
import 'package:todolist/src/domain/entities/recurrence_rule.dart';
import 'package:todolist/src/domain/entities/sub_task.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/attachments/application/attachment_providers.dart';
import 'package:todolist/src/features/attachments/presentation/attachment_list.dart';
import 'package:todolist/src/features/attachments/presentation/attachment_picker.dart';
import 'package:todolist/src/features/smart_reminders/presentation/unified_reminder_picker.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/features/tasks/application/task_suggestion_provider.dart';
import 'package:todolist/src/features/voice/application/baidu_voice_providers.dart';
import 'package:todolist/src/features/voice/presentation/baidu_voice_dialog.dart';
import 'package:todolist/src/features/voice/presentation/voice_input_button.dart';

class TaskComposerSheet extends ConsumerStatefulWidget {
  const TaskComposerSheet({super.key, this.initialTask});

  final Task? initialTask;

  static Future<void> show(BuildContext context, {Task? task}) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => TaskComposerSheet(initialTask: task),
      ),
    );
  }

  @override
  ConsumerState<TaskComposerSheet> createState() => _TaskComposerSheetState();
}

class _EditableSubTask {
  _EditableSubTask({required this.id, required this.title, this.isCompleted = false});

  final String id;
  String title;
  bool isCompleted;
}

class _TaskComposerSheetState extends ConsumerState<TaskComposerSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late final TextEditingController _subTaskController;
  late final TextEditingController _quickInputController;

  String? _selectedListId;
  DateTime? _dueAt;
  DateTime? _remindAt;
  TaskPriority _priority = TaskPriority.none;
  final List<String> _selectedTagIds = <String>[];
  final List<_EditableSubTask> _subTasks = <_EditableSubTask>[];
  final List<Attachment> _attachments = <Attachment>[];
  RecurrenceRule? _recurrenceRule;
  int? _estimatedMinutes;
  final List<SmartReminderConfig> _smartReminders = <SmartReminderConfig>[];
  bool _isSaving = false;
  final bool _isPriorityExpanded = false;
  bool _isTagsExpanded = false;
  final bool _showAdvancedOptions = false; // 添加高级选项折叠状态

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _notesController = TextEditingController(text: task?.notes ?? '');
    _subTaskController = TextEditingController();
    _quickInputController = TextEditingController();

    if (task != null) {
      _selectedListId = task.listId;
      _dueAt = task.dueAt;
      _remindAt = task.remindAt;
      _priority = task.priority;
      _selectedTagIds.addAll(task.tagIds);
      _recurrenceRule = task.recurrenceRule;
      _attachments.addAll(task.attachments);
      _estimatedMinutes = task.estimatedMinutes;
      _subTasks.addAll(
        task.subtasks.map(
          (sub) => _EditableSubTask(
            id: sub.id,
            title: sub.title,
            isCompleted: sub.isCompleted,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _subTaskController.dispose();
    _quickInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formatter = ChineseDateFormatter.dateTime;
    final listsAsync = ref.watch(taskListsProvider);
    final tagsAsync = ref.watch(tagsProvider);

    final lists = listsAsync.valueOrNull ?? <TaskList>[];
    final tags = tagsAsync.valueOrNull ?? <Tag>[];

    _maybeSelectDefaultList(lists);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.initialTask == null
              ? l10n.taskFormNewTitle
              : l10n.taskFormEditTitle,
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : () => _save(lists),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // 标题输入框 - 集成智能语音输入
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _titleController,
                builder: (context, value, _) {
                  return TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.taskFormTitleLabel,
                      hintText: '如: 明天下午3点开会 #工作 紧急',
                      border: const OutlineInputBorder(),
                      helperText: '💡支持智能解析: 时间、优先级、标签等',
                      helperMaxLines: 2,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 智能解析按钮 - 仅当有文本时显示
                          if (value.text.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                Icons.auto_awesome,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              onPressed: () {
                                _quickInputController.text = _titleController.text;
                                _parseQuickInput();
                              },
                              tooltip: '智能解析',
                            ),
                          // 语音输入按钮
                          IconButton(
                            icon: const Icon(Icons.mic, size: 20),
                            onPressed: () async {
                              final result = await showDialog<String>(
                                context: context,
                                builder: (context) => const BaiduVoiceDialog(),
                              );
                              if (result != null && result.isNotEmpty) {
                                _titleController.text = result;
                                // 自动解析语音输入
                                _quickInputController.text = result;
                                _parseQuickInput();
                              }
                            },
                            tooltip: '语音输入',
                          ),
                        ],
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return l10n.taskFormTitleValidation;
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _selectedListId,
                items: [
                  for (final list in lists)
                    DropdownMenuItem<String>(
                      value: list.id,
                      child: Text(list.name),
                    ),
                ],
                decoration: InputDecoration(
                  labelText: l10n.taskFormListLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _selectedListId = value),
              ),
              const SizedBox(height: 16),
              // 优先级选择 - 紧凑Chip组
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.taskFormPriorityLabel,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.taskPriorityHigh),
                        selected: _priority == TaskPriority.high,
                        onSelected: _isSaving
                            ? null
                            : (selected) {
                                setState(() => _priority = selected ? TaskPriority.high : TaskPriority.none);
                              },
                        avatar: _priority == TaskPriority.high ? const Icon(Icons.flag, size: 16) : null,
                      ),
                      ChoiceChip(
                        label: Text(l10n.taskPriorityMedium),
                        selected: _priority == TaskPriority.medium,
                        onSelected: _isSaving
                            ? null
                            : (selected) {
                                setState(() => _priority = selected ? TaskPriority.medium : TaskPriority.none);
                              },
                        avatar: _priority == TaskPriority.medium ? const Icon(Icons.flag, size: 16) : null,
                      ),
                      ChoiceChip(
                        label: Text(l10n.taskPriorityLow),
                        selected: _priority == TaskPriority.low,
                        onSelected: _isSaving
                            ? null
                            : (selected) {
                                setState(() => _priority = selected ? TaskPriority.low : TaskPriority.none);
                              },
                        avatar: _priority == TaskPriority.low ? const Icon(Icons.flag, size: 16) : null,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: l10n.taskFormNotesLabel,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                  suffixIcon: VoiceInputButton(
                    onTextRecognized: (text) {
                      if (_notesController.text.isEmpty) {
                        _notesController.text = text;
                      } else {
                        _notesController.text = '${_notesController.text}\n$text';
                      }
                    },
                    size: 20,
                  ),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 24),
                InkWell(
                  onTap: _isSaving
                      ? null
                      : () {
                          setState(() => _isTagsExpanded = !_isTagsExpanded);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.taskFormTagsLabel, style: theme.textTheme.titleSmall),
                      Icon(_isTagsExpanded ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
                if (_isTagsExpanded) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tag in tags)
                          FilterChip(
                            label: Text(tag.name),
                            selected: _selectedTagIds.contains(tag.id),
                            onSelected: _isSaving
                                ? null
                                : (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedTagIds.add(tag.id);
                                      } else {
                                        _selectedTagIds.remove(tag.id);
                                      }
                                    });
                                  },
                          ),
                      ],
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              _DateRow(
                label: l10n.taskFormDueDate,
                value: _dueAt,
                onPick: _isSaving
                    ? null
                    : () => _pickDateTime(
                          context,
                          onSelected: (value) => setState(() => _dueAt = value),
                        ),
                onClear: _isSaving
                    ? null
                    : () => setState(() {
                          _dueAt = null;
                        }),
              ),
              const SizedBox(height: 12),
              // 统一的提醒设置按钮
              OutlinedButton.icon(
                onPressed: _isSaving
                    ? null
                    : () async {
                        await UnifiedReminderPicker.show(
                          context,
                          onSelect: (mainReminder, smartReminders) {
                            setState(() {
                              _remindAt = mainReminder;
                              _smartReminders.clear();
                              _smartReminders.addAll(smartReminders);
                            });
                          },
                          currentReminder: _remindAt,
                          smartReminders: _smartReminders,
                        );
                      },
                icon: Icon(
                  _remindAt != null || _smartReminders.isNotEmpty
                      ? Icons.notifications_active
                      : Icons.notifications_outlined,
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_getReminderSummary()),
                ),
              ),
              const SizedBox(height: 12),
              // 重复规则 - 下拉菜单
              DropdownButtonFormField<String>(
                initialValue: _recurrenceRule == null ? null : _getRecurrenceKey(_recurrenceRule!),
                decoration: InputDecoration(
                  labelText: l10n.taskFormRecurrence,
                  prefixIcon: const Icon(Icons.repeat),
                  border: const OutlineInputBorder(),
                  suffixIcon: _recurrenceRule != null
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => _recurrenceRule = null),
                        )
                      : null,
                ),
                hint: Text(l10n.taskFormRecurrenceNone),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.taskFormRecurrenceNone),
                  ),
                  DropdownMenuItem<String>(
                    value: 'daily',
                    child: Text(l10n.recurrenceDaily),
                  ),
                  DropdownMenuItem<String>(
                    value: 'weekly',
                    child: Text(l10n.recurrenceWeekly),
                  ),
                  DropdownMenuItem<String>(
                    value: 'monthly',
                    child: Text(l10n.recurrenceMonthly),
                  ),
                  DropdownMenuItem<String>(
                    value: 'yearly',
                    child: Text(l10n.recurrenceYearly),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      _recurrenceRule = null;
                    } else {
                      _recurrenceRule = _createRecurrenceRule(value);
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              _EstimatedTimeInput(
                estimatedMinutes: _estimatedMinutes,
                listId: _selectedListId,
                tagIds: _selectedTagIds,
                onChanged: _isSaving
                    ? null
                    : (minutes) => setState(() => _estimatedMinutes = minutes),
              ),
              const SizedBox(height: 24),
              Text(l10n.taskFormSubtasks, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              for (final subtask in _subTasks)
                Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: subtask.isCompleted,
                      onChanged: _isSaving
                          ? null
                          : (value) {
                              if (value == null) return;
                              setState(() => subtask.isCompleted = value);
                            },
                    ),
                    title: TextFormField(
                      initialValue: subtask.title,
                      decoration: const InputDecoration(border: InputBorder.none),
                      onChanged: (value) => subtask.title = value,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _isSaving
                          ? null
                          : () => setState(() => _subTasks.remove(subtask)),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subTaskController,
                      decoration: InputDecoration(
                        labelText: l10n.taskFormAddSubtask,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addSubTask(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _addSubTask,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.taskFormAdd),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.taskFormAttachments, style: theme.textTheme.titleMedium),
                  AttachmentPicker(
                    onAttachmentAdded: (attachment) {
                      setState(() => _attachments.add(attachment));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AttachmentList(
                attachments: _attachments,
                onDelete: (attachment) async {
                  final attachmentService = ref.read(attachmentServiceProvider);
                  await attachmentService.deleteAttachment(attachment);
                  setState(() => _attachments.remove(attachment));
                },
              ),
              const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _maybeSelectDefaultList(List<TaskList> lists) {
    if (_selectedListId != null || lists.isEmpty) {
      return;
    }
    final defaultList = lists.firstWhere(
      (list) => list.isDefault,
      orElse: () => lists.first,
    );
    _selectedListId = defaultList.id;
  }

  void _addSubTask() {
    final text = _subTaskController.text.trim();
    if (text.isEmpty) {
      return;
    }
    final id = ref.read(idGeneratorProvider).generate();
    setState(() {
      _subTasks.add(_EditableSubTask(id: id, title: text));
      _subTaskController.clear();
    });
  }

  void _parseQuickInput() {
    final input = _quickInputController.text.trim();
    if (input.isEmpty) return;

    // 使用增强版NLP解析器
    final enhancedParser = ref.read(enhancedTaskNlpParserProvider);
    
    // 记录原始输入（用于调试）
    debugPrint('╔═══════════════════════════════════════════════════════════╗');
    debugPrint('║ 📝 语音识别原始文本                                        ║');
    debugPrint('╚═══════════════════════════════════════════════════════════╝');
    debugPrint('原文: "$input"');
    debugPrint('长度: ${input.length} 字符');
    debugPrint('包含"提前": ${input.contains("提前")}');
    debugPrint('包含"提醒": ${input.contains("提醒")}');
    debugPrint('包含数字: ${input.contains(RegExp(r'\d'))}');
    debugPrint('');
    
    final parsed = enhancedParser.parseTaskFromText(input);

    debugPrint('╔═══════════════════════════════════════════════════════════╗');
    debugPrint('║ 🧠 NLP解析结果                                             ║');
    debugPrint('╚═══════════════════════════════════════════════════════════╝');
    debugPrint('✨ 标题: ${parsed.title}');
    debugPrint('📅 截止时间: ${parsed.dueAt}');
    debugPrint('⏰ 提醒时间: ${parsed.remindAt}');
    debugPrint('📍 地点: ${parsed.location}');
    debugPrint('👥 参与人: ${parsed.participants}');
    debugPrint('🔥 优先级: ${parsed.priority}');
    debugPrint('⏱️  时长: ${parsed.estimatedMinutes}');
    debugPrint('═══════════════════════════════════════════════════════════');

    setState(() {
      // 设置标题（已智能提取核心）
      if (parsed.title.isNotEmpty) {
        _titleController.text = parsed.title;
      }

      // 设置截止时间
      if (parsed.dueAt != null) {
        _dueAt = parsed.dueAt;
      }

      // 设置提醒时间
      if (parsed.remindAt != null) {
        _remindAt = parsed.remindAt;
        debugPrint('✓ 提醒时间已设置: $_remindAt');
      }

      // 设置优先级
      _priority = parsed.priority;

      // 设置时间估算
      if (parsed.estimatedMinutes != null) {
        _estimatedMinutes = parsed.estimatedMinutes;
      }

      // 设置备注（包括地点和参与人信息）
      final notesParts = <String>[];
      
      // 保留现有备注
      if (_notesController.text.isNotEmpty) {
        notesParts.add(_notesController.text);
      }
      
      // 添加NLP提取的备注
      if (parsed.notes != null && parsed.notes!.isNotEmpty) {
        notesParts.add(parsed.notes!);
      }
      
      // 添加地点
      if (parsed.location != null && parsed.location!.isNotEmpty) {
        notesParts.add('📍 地点: ${parsed.location}');
        debugPrint('✓ 地点已添加到备注: ${parsed.location}');
      }
      
      // 添加参与人
      if (parsed.participants != null && parsed.participants!.isNotEmpty) {
        notesParts.add('👥 参与人: ${parsed.participants!.join("、")}');
        debugPrint('✓ 参与人已添加到备注: ${parsed.participants!.join("、")}');
      }
      
      if (notesParts.isNotEmpty) {
        _notesController.text = notesParts.join('\n');
        debugPrint('✓ 最终备注内容:\n${_notesController.text}');
      }

      // 清空快速输入框
      _quickInputController.clear();
    });

    // 显示解析结果提示
    final timeStr = parsed.dueAt != null 
        ? DateFormat('M月d日 HH:mm').format(parsed.dueAt!)
        : '';
    final remindStr = parsed.remindAt != null
        ? '⏰提前${parsed.dueAt!.difference(parsed.remindAt!).inMinutes}分钟'
        : '';
    final priorityStr = parsed.priority != TaskPriority.none 
        ? _getPriorityLabel(parsed.priority)
        : '';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✓ 已解析: ${parsed.title}'
          '${timeStr.isNotEmpty ? ' 📅$timeStr' : ''}'
          '${remindStr.isNotEmpty ? ' $remindStr' : ''}'
          '${priorityStr.isNotEmpty ? ' 🔥$priorityStr' : ''}',
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getRecurrenceKey(RecurrenceRule rule) {
    switch (rule.frequency) {
      case RecurrenceFrequency.daily:
        return 'daily';
      case RecurrenceFrequency.weekly:
        return 'weekly';
      case RecurrenceFrequency.monthly:
        return 'monthly';
      case RecurrenceFrequency.yearly:
        return 'yearly';
      case RecurrenceFrequency.custom:
        return 'daily'; // 默认为每日
    }
  }

  RecurrenceRule _createRecurrenceRule(String key) {
    switch (key) {
      case 'daily':
        return const RecurrenceRule(frequency: RecurrenceFrequency.daily, interval: 1);
      case 'weekly':
        return const RecurrenceRule(frequency: RecurrenceFrequency.weekly, interval: 1);
      case 'monthly':
        return const RecurrenceRule(frequency: RecurrenceFrequency.monthly, interval: 1);
      case 'yearly':
        return const RecurrenceRule(frequency: RecurrenceFrequency.yearly, interval: 1);
      default:
        return const RecurrenceRule(frequency: RecurrenceFrequency.daily, interval: 1);
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return '紧急';
      case TaskPriority.high:
        return '重要';
      case TaskPriority.medium:
        return '一般';
      case TaskPriority.low:
        return '低';
      case TaskPriority.none:
        return '';
    }
  }

  String _getReminderSummary() {
    final hasMainReminder = _remindAt != null;
    final smartCount = _smartReminders.length;

    if (hasMainReminder && smartCount > 0) {
      return '提醒: ${ChineseDateFormatter.dateTime.format(_remindAt!)} + $smartCount个智能提醒';
    } else if (hasMainReminder) {
      return '提醒: ${ChineseDateFormatter.dateTime.format(_remindAt!)}';
    } else if (smartCount > 0) {
      return '智能提醒: $smartCount个';
    } else {
      return '设置提醒';
    }
  }

  Future<void> _save(List<TaskList> lists) async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedListId == null && lists.isNotEmpty) {
      _selectedListId = lists.first.id;
    }
    final listId = _selectedListId;
    if (listId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.taskFormSelectList)),
      );
      return;
    }

    // Prevent multiple clicks
    if (_isSaving) return;
    setState(() => _isSaving = true);

    // Prepare data before closing
    final clock = ref.read(clockProvider);
    final subtasks = _subTasks
        .where((item) => item.title.trim().isNotEmpty)
        .map(
          (item) => SubTask(
            id: item.id,
            title: item.title.trim(),
            isCompleted: item.isCompleted,
            completedAt: item.isCompleted ? clock.now() : null,
          ),
        )
        .toList();

    final input = TaskCreationInput(
      title: _titleController.text.trim(),
      listId: listId,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      dueAt: _dueAt,
      remindAt: _remindAt,
      tagIds: List<String>.from(_selectedTagIds),
      priority: _priority,
      subtasks: subtasks,
      attachments: List<Attachment>.from(_attachments),
      recurrenceRule: _recurrenceRule,
      estimatedMinutes: _estimatedMinutes,
      smartReminders: List<SmartReminderConfig>.from(_smartReminders),
    );

    // Close the sheet immediately to provide instant feedback
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Save in background
    try {
      final service = ref.read(taskServiceProvider);
      if (widget.initialTask == null) {
        await service.createTask(input);
      } else {
        await service.updateTask(
          widget.initialTask!,
          TaskUpdateInput(
            title: input.title,
            listId: input.listId,
            notes: input.notes,
            dueAt: input.dueAt,
            remindAt: input.remindAt,
            tagIds: input.tagIds,
            priority: input.priority,
            subtasks: input.subtasks,
            attachments: input.attachments,
            recurrenceRule: input.recurrenceRule,
            estimatedMinutes: input.estimatedMinutes,
            smartReminders: input.smartReminders,
          ),
        );
      }
    } catch (error) {
      // Note: Can't show SnackBar here as the widget is already disposed
      // Error handling could be improved with a global error handler
      debugPrint('Error saving task: $error');
    }
  }

  Future<void> _pickDateTime(
    BuildContext context, {
    required void Function(DateTime?) onSelected,
  }) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: _dueAt != null
          ? TimeOfDay.fromDateTime(_dueAt!)
          : TimeOfDay(hour: now.hour, minute: now.minute),
    );
    if (time == null) {
      onSelected(DateTime(date.year, date.month, date.day));
      return;
    }
    onSelected(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback? onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final formatter = ChineseDateFormatter.dateTime;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.event_outlined),
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value == null ? label : formatter.format(value!),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: value == null ? null : onClear,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}

String _priorityLabel(TaskPriority priority, AppLocalizations l10n) {
  return switch (priority) {
    TaskPriority.none => l10n.taskPriorityNone,
    TaskPriority.low => l10n.taskPriorityLow,
    TaskPriority.medium => l10n.taskPriorityMedium,
    TaskPriority.high => l10n.taskPriorityHigh,
    TaskPriority.critical => l10n.taskPriorityCritical,
  };
}

class _EstimatedTimeInput extends ConsumerWidget {
  const _EstimatedTimeInput({
    required this.estimatedMinutes,
    required this.listId,
    required this.tagIds,
    required this.onChanged,
  });

  final int? estimatedMinutes;
  final String? listId;
  final List<String> tagIds;
  final void Function(int?)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch suggestion provider
    final suggestionAsync = ref.watch(taskSuggestionProvider(
      listId: listId,
      tagIds: tagIds,
    ));

    // Calculate pomodoros (25 min each)
    final pomodoros = estimatedMinutes != null ? (estimatedMinutes! / 25).ceil() : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int?>(
              initialValue: estimatedMinutes,
              decoration: InputDecoration(
                labelText: '预估时间',
                prefixIcon: const Icon(Icons.timer_outlined),
                border: const OutlineInputBorder(),
                suffixIcon: estimatedMinutes != null
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: onChanged != null ? () => onChanged!(null) : null,
                      )
                    : null,
              ),
              hint: const Text('选择预估时间'),
              items: const [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text('未设置'),
                ),
                DropdownMenuItem<int>(
                  value: 15,
                  child: Text('15分钟'),
                ),
                DropdownMenuItem<int>(
                  value: 25,
                  child: Text('25分钟 (1🍅)'),
                ),
                DropdownMenuItem<int>(
                  value: 50,
                  child: Text('50分钟 (2🍅)'),
                ),
                DropdownMenuItem<int>(
                  value: 60,
                  child: Text('1小时'),
                ),
                DropdownMenuItem<int>(
                  value: 120,
                  child: Text('2小时'),
                ),
                DropdownMenuItem<int>(
                  value: -1,
                  child: Text('自定义...'),
                ),
              ],
              onChanged: onChanged != null
                  ? (value) {
                      if (value == -1) {
                        _showCustomDialog(context);
                      } else {
                        onChanged!(value);
                      }
                    }
                  : null,
            ),
            if (estimatedMinutes != null) ...[
              const SizedBox(height: 12),
              Text(
                '约 $pomodoros 个番茄钟 ($estimatedMinutes 分钟)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            // Smart suggestion
            suggestionAsync.when(
              data: (suggestion) {
                if (suggestion == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '💡 智能建议: ${suggestion.suggestedMinutes}分钟',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                '基于${suggestion.basedOnTasksCount}个相似任务 · 可信度${suggestion.confidenceLabel}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (onChanged != null)
                          TextButton(
                            onPressed: () => onChanged!(suggestion.suggestedMinutes),
                            child: const Text('采用'),
                          ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomDialog(BuildContext context) async {
    final controller = TextEditingController(
      text: estimatedMinutes?.toString() ?? '',
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('自定义时间'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '分钟',
            suffixText: '分钟',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.of(context).pop(value);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (result != null && onChanged != null) {
      onChanged!(result);
    }
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.minutes,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int? minutes;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
    );
  }
}










