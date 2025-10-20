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

/// 现代化设计的任务编辑页面
class ModernTaskComposerSheet extends ConsumerStatefulWidget {
  const ModernTaskComposerSheet({super.key, this.initialTask});

  final Task? initialTask;

  static Future<void> show(BuildContext context, {Task? task}) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ModernTaskComposerSheet(initialTask: task),
      ),
    );
  }

  @override
  ConsumerState<ModernTaskComposerSheet> createState() => _ModernTaskComposerSheetState();
}

class _EditableSubTask {
  _EditableSubTask({required this.id, required this.title, this.isCompleted = false});

  final String id;
  String title;
  bool isCompleted;
}

class _ModernTaskComposerSheetState extends ConsumerState<ModernTaskComposerSheet> {
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
    final listsAsync = ref.watch(taskListsProvider);
    final tagsAsync = ref.watch(tagsProvider);
    final lists = listsAsync.valueOrNull ?? <TaskList>[];
    final tags = tagsAsync.valueOrNull ?? <Tag>[];
    _maybeSelectDefaultList(lists);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.initialTask == null ? l10n.taskFormNewTitle : l10n.taskFormEditTitle,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          FilledButton(
            onPressed: _isSaving ? null : () => _save(lists),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('保存'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 基本信息卡片
              _buildBasicInfoCard(theme, l10n, lists),
              const SizedBox(height: 16),

              // 优先级和标签卡片
              _buildPriorityAndTagsCard(theme, l10n, tags),
              const SizedBox(height: 16),

              // 时间设置卡片
              _buildTimeSettingsCard(theme, l10n),
              const SizedBox(height: 16),

              // 预估时间卡片
              _buildEstimatedTimeCard(),
              const SizedBox(height: 16),

              // 子任务卡片
              if (_subTasks.isNotEmpty) ...[
                _buildSubTasksCard(theme, l10n),
                const SizedBox(height: 16),
              ],

              // 添加子任务
              _buildAddSubTaskCard(theme, l10n),
              const SizedBox(height: 16),

              // 附件卡片
              if (_attachments.isNotEmpty) ...[
                _buildAttachmentsCard(theme, l10n),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(ThemeData theme, AppLocalizations l10n, List<TaskList> lists) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _titleController,
              builder: (context, value, _) {
                return TextFormField(
                  controller: _titleController,
                  style: theme.textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: '任务标题',
                    hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                    border: InputBorder.none,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (value.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 22),
                            onPressed: () {
                              _quickInputController.text = _titleController.text;
                              _parseQuickInput();
                            },
                            tooltip: '智能解析',
                          ),
                        IconButton(
                          icon: Icon(Icons.mic_outlined, color: theme.colorScheme.primary, size: 22),
                          onPressed: () async {
                            final result = await showDialog<String>(
                              context: context,
                              builder: (context) => const BaiduVoiceDialog(),
                            );
                            if (result != null && result.isNotEmpty) {
                              _titleController.text = result;
                              _quickInputController.text = result;
                              _parseQuickInput();
                            }
                          },
                          tooltip: '语音输入',
                        ),
                      ],
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.taskFormTitleValidation;
                    }
                    return null;
                  },
                );
              },
            ),
            const Divider(height: 24),

            // 所属列表
            DropdownButtonFormField<String>(
              value: _selectedListId,
              decoration: InputDecoration(
                labelText: '所属列表',
                prefixIcon: Icon(Icons.folder_outlined, color: theme.colorScheme.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
              items: [
                for (final list in lists)
                  DropdownMenuItem<String>(
                    value: list.id,
                    child: Text(list.name),
                  ),
              ],
              onChanged: _isSaving ? null : (value) => setState(() => _selectedListId = value),
            ),
            const SizedBox(height: 16),

            // 备注
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: '备注',
                hintText: '添加详细描述...',
                prefixIcon: Icon(Icons.notes_outlined, color: theme.colorScheme.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityAndTagsCard(ThemeData theme, AppLocalizations l10n, List<Tag> tags) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 优先级
            Text('优先级', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPriorityChip(theme, l10n, TaskPriority.high, '重要', Colors.red),
                _buildPriorityChip(theme, l10n, TaskPriority.medium, '一般', Colors.orange),
                _buildPriorityChip(theme, l10n, TaskPriority.low, '低', Colors.blue),
                _buildPriorityChip(theme, l10n, TaskPriority.none, '无', Colors.grey),
              ],
            ),

            if (tags.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // 标签
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('标签', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    _selectedTagIds.isEmpty ? '未选择' : '${_selectedTagIds.length} 个',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
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
                      side: BorderSide(
                        color: _selectedTagIds.contains(tag.id)
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(ThemeData theme, AppLocalizations l10n, TaskPriority priority, String label, Color color) {
    final isSelected = _priority == priority;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: _isSaving ? null : (selected) => setState(() => _priority = selected ? priority : TaskPriority.none),
      avatar: isSelected ? Icon(Icons.flag, size: 16, color: color) : null,
      selectedColor: color.withValues(alpha: 0.2),
      side: BorderSide(color: isSelected ? color : theme.colorScheme.outline.withValues(alpha: 0.5)),
    );
  }

  Widget _buildTimeSettingsCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('时间设置', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 截止时间
            _buildModernTimeButton(
              theme,
              icon: Icons.event_outlined,
              label: '截止时间',
              value: _dueAt,
              onTap: () => _pickDateTime(context, onSelected: (value) => setState(() => _dueAt = value)),
              onClear: () => setState(() => _dueAt = null),
            ),
            const SizedBox(height: 12),

            // 提醒
            _buildModernTimeButton(
              theme,
              icon: _remindAt != null || _smartReminders.isNotEmpty
                  ? Icons.notifications_active
                  : Icons.notifications_outlined,
              label: '提醒',
              value: null,
              customText: _getReminderSummary(),
              onTap: () async {
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
              onClear: _remindAt == null && _smartReminders.isEmpty
                  ? null
                  : () => setState(() {
                        _remindAt = null;
                        _smartReminders.clear();
                      }),
            ),
            const SizedBox(height: 12),

            // 重复规则
            DropdownButtonFormField<String>(
              value: _recurrenceRule == null ? null : _getRecurrenceKey(_recurrenceRule!),
              decoration: InputDecoration(
                labelText: '重复',
                prefixIcon: Icon(Icons.repeat, color: theme.colorScheme.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
              hint: Text(l10n.taskFormRecurrenceNone),
              items: [
                DropdownMenuItem<String>(value: null, child: Text(l10n.taskFormRecurrenceNone)),
                DropdownMenuItem<String>(value: 'daily', child: Text(l10n.recurrenceDaily)),
                DropdownMenuItem<String>(value: 'weekly', child: Text(l10n.recurrenceWeekly)),
                DropdownMenuItem<String>(value: 'monthly', child: Text(l10n.recurrenceMonthly)),
                DropdownMenuItem<String>(value: 'yearly', child: Text(l10n.recurrenceYearly)),
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
          ],
        ),
      ),
    );
  }

  Widget _buildModernTimeButton(
    ThemeData theme, {
    required IconData icon,
    required String label,
    DateTime? value,
    String? customText,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final hasValue = value != null || customText != null;
    final displayText = customText ?? (value != null ? ChineseDateFormatter.dateTime.format(value) : label);

    return InkWell(
      onTap: _isSaving ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: hasValue ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: hasValue ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (hasValue && onClear != null)
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: _isSaving ? null : onClear,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatedTimeCard() {
    final suggestionAsync = ref.watch(taskSuggestionProvider(
      listId: _selectedListId,
      tagIds: _selectedTagIds,
    ));

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '预估时间',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTimeChip('15分钟', 15),
                _buildTimeChip('25分钟 🍅', 25),
                _buildTimeChip('50分钟 🍅🍅', 50),
                _buildTimeChip('1小时', 60),
                _buildTimeChip('2小时', 120),
                if (_estimatedMinutes != null && ![15, 25, 50, 60, 120].contains(_estimatedMinutes))
                  _buildTimeChip('$_estimatedMinutes分钟', _estimatedMinutes!),
              ],
            ),

            // 智能建议
            suggestionAsync.when(
              data: (suggestion) {
                if (suggestion == null) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '建议: ${suggestion.suggestedMinutes}分钟',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              '基于${suggestion.basedOnTasksCount}个相似任务',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: () => setState(() => _estimatedMinutes = suggestion.suggestedMinutes),
                        child: const Text('采用'),
                      ),
                    ],
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

  Widget _buildTimeChip(String label, int minutes) {
    final isSelected = _estimatedMinutes == minutes;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: _isSaving ? null : (selected) => setState(() => _estimatedMinutes = selected ? minutes : null),
    );
  }

  Widget _buildSubTasksCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('子任务', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final subtask in _subTasks)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
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
                    onPressed: _isSaving ? null : () => setState(() => _subTasks.remove(subtask)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSubTaskCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _subTaskController,
                decoration: InputDecoration(
                  hintText: '添加子任务',
                  prefixIcon: Icon(Icons.add_task, color: theme.colorScheme.primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
                onSubmitted: (_) => _addSubTask(),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: _isSaving ? null : _addSubTask,
              icon: const Icon(Icons.add),
              label: const Text('添加'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('附件', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    );
  }

  // Helper methods
  void _maybeSelectDefaultList(List<TaskList> lists) {
    if (_selectedListId != null || lists.isEmpty) return;
    final defaultList = lists.firstWhere((list) => list.isDefault, orElse: () => lists.first);
    _selectedListId = defaultList.id;
  }

  void _addSubTask() {
    final text = _subTaskController.text.trim();
    if (text.isEmpty) return;
    final id = ref.read(idGeneratorProvider).generate();
    setState(() {
      _subTasks.add(_EditableSubTask(id: id, title: text));
      _subTaskController.clear();
    });
  }

  void _parseQuickInput() {
    final input = _quickInputController.text.trim();
    if (input.isEmpty) return;

    final enhancedParser = ref.read(enhancedTaskNlpParserProvider);
    final parsed = enhancedParser.parseTaskFromText(input);

    setState(() {
      if (parsed.title.isNotEmpty) _titleController.text = parsed.title;
      if (parsed.dueAt != null) _dueAt = parsed.dueAt;
      if (parsed.remindAt != null) _remindAt = parsed.remindAt;
      _priority = parsed.priority;
      if (parsed.estimatedMinutes != null) _estimatedMinutes = parsed.estimatedMinutes;

      final notesParts = <String>[];
      if (_notesController.text.isNotEmpty) notesParts.add(_notesController.text);
      if (parsed.notes != null && parsed.notes!.isNotEmpty) notesParts.add(parsed.notes!);
      if (parsed.location != null && parsed.location!.isNotEmpty) notesParts.add('📍 地点: ${parsed.location}');
      if (parsed.participants != null && parsed.participants!.isNotEmpty) {
        notesParts.add('👥 参与人: ${parsed.participants!.join("、")}');
      }
      if (notesParts.isNotEmpty) _notesController.text = notesParts.join('\n');
      _quickInputController.clear();
    });

    final timeStr = parsed.dueAt != null ? DateFormat('M月d日 HH:mm').format(parsed.dueAt!) : '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ 已解析: ${parsed.title}${timeStr.isNotEmpty ? ' 📅$timeStr' : ''}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getRecurrenceKey(RecurrenceRule rule) {
    return switch (rule.frequency) {
      RecurrenceFrequency.daily => 'daily',
      RecurrenceFrequency.weekly => 'weekly',
      RecurrenceFrequency.monthly => 'monthly',
      RecurrenceFrequency.yearly => 'yearly',
      RecurrenceFrequency.custom => 'daily',
    };
  }

  RecurrenceRule _createRecurrenceRule(String key) {
    return switch (key) {
      'daily' => const RecurrenceRule(frequency: RecurrenceFrequency.daily, interval: 1),
      'weekly' => const RecurrenceRule(frequency: RecurrenceFrequency.weekly, interval: 1),
      'monthly' => const RecurrenceRule(frequency: RecurrenceFrequency.monthly, interval: 1),
      'yearly' => const RecurrenceRule(frequency: RecurrenceFrequency.yearly, interval: 1),
      _ => const RecurrenceRule(frequency: RecurrenceFrequency.daily, interval: 1),
    };
  }

  String _getReminderSummary() {
    final hasMainReminder = _remindAt != null;
    final smartCount = _smartReminders.length;

    if (!hasMainReminder && smartCount == 0) return '设置提醒';
    if (hasMainReminder && smartCount > 0) {
      return '${ChineseDateFormatter.dateTime.format(_remindAt!)} + $smartCount个智能提醒';
    } else if (hasMainReminder) {
      return ChineseDateFormatter.dateTime.format(_remindAt!);
    } else {
      return '$smartCount个智能提醒';
    }
  }

  Future<void> _save(List<TaskList> lists) async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedListId == null && lists.isNotEmpty) _selectedListId = lists.first.id;
    final listId = _selectedListId;
    if (listId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.taskFormSelectList)));
      return;
    }

    if (_isSaving) return;
    setState(() => _isSaving = true);

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

    if (context.mounted) Navigator.of(context).pop();

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
      debugPrint('Error saving task: $error');
    }
  }

  Future<void> _pickDateTime(BuildContext context, {required void Function(DateTime?) onSelected}) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _dueAt != null ? TimeOfDay.fromDateTime(_dueAt!) : TimeOfDay(hour: now.hour, minute: now.minute),
    );
    if (time == null) {
      onSelected(DateTime(date.year, date.month, date.day));
      return;
    }
    onSelected(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}
