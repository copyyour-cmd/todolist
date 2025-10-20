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
import 'package:todolist/src/features/notes/presentation/widgets/styled_text_field.dart';
import 'package:todolist/src/features/smart_reminders/presentation/unified_reminder_picker.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/features/tasks/application/task_suggestion_provider.dart';
import 'package:todolist/src/features/voice/application/baidu_voice_providers.dart';
import 'package:todolist/src/features/voice/presentation/baidu_voice_dialog.dart';
import 'package:todolist/src/features/reminders/domain/reminder_mode.dart';
import 'package:todolist/src/features/reminders/application/reminder_preferences_service.dart';

/// 现代简约设计的任务编辑页面
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
  late final StyledTextEditingController _contentController;
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
  ReminderMode _reminderMode = ReminderMode.notification; // 默认值为标准通知
  bool _isSaving = false;

  // 现代配色方案
  static const _bgColor = Color(0xFFFAFAFA);
  static const _cardColor = Colors.white;
  static const _textPrimary = Color(0xFF1F1F1F);
  static const _textSecondary = Color(0xFF757575);
  static const _borderColor = Color(0xFFE0E0E0);
  static const _inputBg = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;

    // 合并标题和内容,第一行作为标题
    final initialText = task != null
        ? '${task.title}${task.notes != null && task.notes!.isNotEmpty ? '\n${task.notes}' : ''}'
        : '';
    _contentController = StyledTextEditingController(text: initialText);
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
      _reminderMode = task.reminderMode; // 读取保存的提醒模式
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
    _contentController.dispose();
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
      backgroundColor: _bgColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _cardColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: _textPrimary, size: 24),
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.initialTask == null ? '新建任务' : '编辑任务',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 任务内容输入 - 第一行作为标题
              _buildContentSection(theme, l10n),
              const SizedBox(height: 16),

              // 优先级选择
              _buildPrioritySection(theme, l10n),
              const SizedBox(height: 20),

              // 时间设置
              _buildTimeSection(theme, l10n),
              const SizedBox(height: 20),

              // 标签
              if (tags.isNotEmpty) ...[
                _buildTagsSection(theme, tags),
                const SizedBox(height: 20),
              ],

              // 预估时间
              _buildEstimatedTimeSection(theme),
              const SizedBox(height: 20),

              // 子任务
              _buildSubTasksSection(theme, l10n),
              const SizedBox(height: 20),

              // 附件
              if (_attachments.isNotEmpty) ...[
                _buildAttachmentsSection(theme, l10n),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 16),

              // 保存按钮
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isSaving ? null : () => _save(lists),
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: _isSaving
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  '保存任务',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(ThemeData theme, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // 工具栏(语音和AI)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.mic_none, color: theme.colorScheme.primary, size: 22),
                onPressed: () async {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) => const BaiduVoiceDialog(),
                  );
                  if (result != null && result.isNotEmpty) {
                    _contentController.text = result;
                    _quickInputController.text = result;
                    _parseQuickInput();
                  }
                },
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
                tooltip: '语音输入',
              ),
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.auto_awesome_outlined, color: theme.colorScheme.primary, size: 22),
                onPressed: () {
                  _quickInputController.text = _contentController.text;
                  _parseQuickInput();
                },
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
                tooltip: '智能解析',
              ),
            ],
          ),
          // 内容输入框
          TextFormField(
            controller: _contentController,
            minLines: 3,
            maxLines: 10,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: _textPrimary,
            ),
            decoration: InputDecoration(
              hintText: '第一行作为任务标题\n\n继续输入任务详细内容...',
              hintStyle: TextStyle(
                fontSize: 14,
                color: _textSecondary.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return l10n.taskFormTitleValidation;
              }
              // 检查第一行是否为空
              final lines = val.split('\n');
              if (lines.first.trim().isEmpty) {
                return '第一行不能为空,将作为任务标题';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListSelector(ThemeData theme, List<TaskList> lists) {
    if (lists.isEmpty) return const SizedBox.shrink();

    final selectedList = lists.firstWhere(
      (l) => l.id == _selectedListId,
      orElse: () => lists.first,
    );

    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text('选择列表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            children: lists.map((list) {
              return RadioListTile<String>(
                value: list.id,
                groupValue: _selectedListId,
                title: Text(list.name, style: TextStyle(fontSize: 15)),
                onChanged: (value) {
                  Navigator.pop(context, value);
                },
              );
            }).toList(),
          ),
        );
        if (selected != null) {
          setState(() => _selectedListId = selected);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.folder_outlined, size: 20, color: theme.colorScheme.primary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedList.name,
                style: TextStyle(fontSize: 15, color: _textPrimary, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: _textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '优先级',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textSecondary),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPriorityOption(
                label: '高',
                icon: Icons.priority_high_rounded,
                color: Color(0xFFEF5350),
                priority: TaskPriority.high,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildPriorityOption(
                label: '中',
                icon: Icons.remove_rounded,
                color: Color(0xFFFF9800),
                priority: TaskPriority.medium,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildPriorityOption(
                label: '低',
                icon: Icons.trending_down_rounded,
                color: Color(0xFF42A5F5),
                priority: TaskPriority.low,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildPriorityOption(
                label: '无',
                icon: Icons.circle_outlined,
                color: _textSecondary,
                priority: TaskPriority.none,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityOption({
    required String label,
    required IconData icon,
    required Color color,
    required TaskPriority priority,
  }) {
    final isSelected = _priority == priority;

    return GestureDetector(
      onTap: () => setState(() => _priority = priority),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : _cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : _borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : _textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '时间',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textSecondary),
        ),
        SizedBox(height: 12),
        _buildTimeButton(
          icon: Icons.event_outlined,
          label: '截止时间',
          value: _dueAt != null ? ChineseDateFormatter.dateTime.format(_dueAt!) : null,
          onTap: () => _pickDateTime(context, onSelected: (value) => setState(() => _dueAt = value)),
          onClear: _dueAt != null ? () => setState(() => _dueAt = null) : null,
          theme: theme,
        ),
        SizedBox(height: 8),
        _buildTimeButton(
          icon: Icons.notifications_outlined,
          label: '提醒',
          value: _getReminderSummary() != '设置提醒' ? _getReminderSummary() : null,
          onTap: () async {
            // 获取用户偏好的默认提醒模式
            final defaultMode = ref.read(defaultReminderModeProvider);

            await UnifiedReminderPicker.show(
              context,
              onSelect: (mainReminder, smartReminders, reminderMode) {
                setState(() {
                  _remindAt = mainReminder;
                  _smartReminders.clear();
                  _smartReminders.addAll(smartReminders);
                  _reminderMode = reminderMode; // 保存用户选择的提醒模式
                });
              },
              currentReminder: _remindAt,
              smartReminders: _smartReminders,
              currentReminderMode: defaultMode,
            );
          },
          onClear: _remindAt != null || _smartReminders.isNotEmpty
              ? () => setState(() {
                    _remindAt = null;
                    _smartReminders.clear();
                  })
              : null,
          theme: theme,
        ),
        SizedBox(height: 8),
        _buildTimeButton(
          icon: Icons.repeat,
          label: '重复',
          value: _recurrenceRule != null ? _getRecurrenceLabel(_recurrenceRule!) : null,
          onTap: () async {
            final selected = await showDialog<String>(
              context: context,
              builder: (context) => SimpleDialog(
                title: Text('重复', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  RadioListTile<String>(
                    value: 'none',
                    groupValue: _recurrenceRule == null ? 'none' : _getRecurrenceKey(_recurrenceRule!),
                    title: Text('不重复', style: TextStyle(fontSize: 15)),
                    onChanged: (value) => Navigator.pop(context, value),
                  ),
                  RadioListTile<String>(
                    value: 'daily',
                    groupValue: _recurrenceRule == null ? 'none' : _getRecurrenceKey(_recurrenceRule!),
                    title: Text('每天', style: TextStyle(fontSize: 15)),
                    onChanged: (value) => Navigator.pop(context, value),
                  ),
                  RadioListTile<String>(
                    value: 'weekly',
                    groupValue: _recurrenceRule == null ? 'none' : _getRecurrenceKey(_recurrenceRule!),
                    title: Text('每周', style: TextStyle(fontSize: 15)),
                    onChanged: (value) => Navigator.pop(context, value),
                  ),
                  RadioListTile<String>(
                    value: 'monthly',
                    groupValue: _recurrenceRule == null ? 'none' : _getRecurrenceKey(_recurrenceRule!),
                    title: Text('每月', style: TextStyle(fontSize: 15)),
                    onChanged: (value) => Navigator.pop(context, value),
                  ),
                ],
              ),
            );
            if (selected != null) {
              setState(() {
                if (selected == 'none') {
                  _recurrenceRule = null;
                } else {
                  _recurrenceRule = _createRecurrenceRule(selected);
                }
              });
            }
          },
          onClear: _recurrenceRule != null ? () => setState(() => _recurrenceRule = null) : null,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildTimeButton({
    required IconData icon,
    required String label,
    String? value,
    required VoidCallback onTap,
    VoidCallback? onClear,
    required ThemeData theme,
  }) {
    final hasValue = value != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasValue ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : _cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasValue ? theme.colorScheme.primary.withValues(alpha: 0.5) : _borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: hasValue ? theme.colorScheme.primary : _textSecondary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  fontSize: 14,
                  color: hasValue ? theme.colorScheme.primary : _textSecondary,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (hasValue && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 18, color: _textSecondary),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection(ThemeData theme, List<Tag> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '标签',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textSecondary),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            final isSelected = _selectedTagIds.contains(tag.id);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTagIds.remove(tag.id);
                  } else {
                    _selectedTagIds.add(tag.id);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : _cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : _borderColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  tag.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? theme.colorScheme.primary : _textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEstimatedTimeSection(ThemeData theme) {
    final suggestionAsync = ref.watch(taskSuggestionProvider(
      listId: _selectedListId,
      tagIds: _selectedTagIds,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '预估时间',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textSecondary),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTimeChip('15分钟', 15, theme),
            _buildTimeChip('25分钟', 25, theme),
            _buildTimeChip('50分钟', 50, theme),
            _buildTimeChip('1小时', 60, theme),
            _buildTimeChip('2小时', 120, theme),
          ],
        ),
        suggestionAsync.when(
          data: (suggestion) {
            if (suggestion == null) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outlined, size: 18, color: theme.colorScheme.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '建议 ${suggestion.suggestedMinutes}分钟',
                      style: TextStyle(fontSize: 13, color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _estimatedMinutes = suggestion.suggestedMinutes),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('采用', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTimeChip(String label, int minutes, ThemeData theme) {
    final isSelected = _estimatedMinutes == minutes;

    return GestureDetector(
      onTap: () => setState(() => _estimatedMinutes = isSelected ? null : minutes),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : _cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? theme.colorScheme.primary : _borderColor, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : _textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


  Widget _buildSubTasksSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '子任务',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textSecondary),
        ),
        SizedBox(height: 12),
        // 现有子任务
        if (_subTasks.isNotEmpty)
          ...List.generate(_subTasks.length, (index) {
            final subtask = _subTasks[index];
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _borderColor, width: 1),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: subtask.isCompleted,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => subtask.isCompleted = value);
                        }
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: subtask.title,
                      style: TextStyle(fontSize: 14, color: _textPrimary),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onChanged: (value) => subtask.title = value,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: _textSecondary),
                    onPressed: () => setState(() => _subTasks.remove(subtask)),
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
        // 添加子任务
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _inputBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor, width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.add, size: 20, color: theme.colorScheme.primary),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _subTaskController,
                  style: TextStyle(fontSize: 14, color: _textPrimary),
                  decoration: InputDecoration(
                    hintText: '添加子任务',
                    hintStyle: TextStyle(fontSize: 14, color: _textSecondary.withValues(alpha: 0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _addSubTask(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '附件',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textSecondary),
            ),
            AttachmentPicker(
              onAttachmentAdded: (attachment) {
                setState(() => _attachments.add(attachment));
              },
            ),
          ],
        ),
        SizedBox(height: 12),
        AttachmentList(
          attachments: _attachments,
          onDelete: (attachment) async {
            final attachmentService = ref.read(attachmentServiceProvider);
            await attachmentService.deleteAttachment(attachment);
            setState(() => _attachments.remove(attachment));
          },
        ),
      ],
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
      // 构建内容:第一行是标题,后续是notes
      final contentParts = <String>[];
      if (parsed.title.isNotEmpty) {
        contentParts.add(parsed.title);
      }

      // 获取当前已有的notes(除去第一行标题)
      final currentLines = _contentController.text.split('\n');
      final currentNotes = currentLines.length > 1 ? currentLines.sublist(1).join('\n').trim() : '';
      if (currentNotes.isNotEmpty) contentParts.add(currentNotes);

      if (parsed.notes != null && parsed.notes!.isNotEmpty) contentParts.add(parsed.notes!);
      if (parsed.location != null && parsed.location!.isNotEmpty) contentParts.add('📍 地点: ${parsed.location}');
      if (parsed.participants != null && parsed.participants!.isNotEmpty) {
        contentParts.add('👥 参与人: ${parsed.participants!.join("、")}');
      }

      if (contentParts.isNotEmpty) _contentController.text = contentParts.join('\n');

      if (parsed.dueAt != null) _dueAt = parsed.dueAt;
      if (parsed.remindAt != null) _remindAt = parsed.remindAt;
      _priority = parsed.priority;
      if (parsed.estimatedMinutes != null) _estimatedMinutes = parsed.estimatedMinutes;

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

  String _getRecurrenceLabel(RecurrenceRule rule) {
    return switch (rule.frequency) {
      RecurrenceFrequency.daily => '每天',
      RecurrenceFrequency.weekly => '每周',
      RecurrenceFrequency.monthly => '每月',
      RecurrenceFrequency.yearly => '每年',
      RecurrenceFrequency.custom => '自定义',
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
      return '${ChineseDateFormatter.dateTime.format(_remindAt!)} +$smartCount';
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

    // 从内容中分离标题和notes
    final fullText = _contentController.text.trim();
    final lines = fullText.split('\n');
    final title = lines.first.trim();
    final notes = lines.length > 1 ? lines.sublist(1).join('\n').trim() : '';

    final input = TaskCreationInput(
      title: title,
      listId: listId,
      notes: notes.isEmpty ? null : notes,
      dueAt: _dueAt,
      remindAt: _remindAt,
      tagIds: List<String>.from(_selectedTagIds),
      priority: _priority,
      subtasks: subtasks,
      attachments: List<Attachment>.from(_attachments),
      recurrenceRule: _recurrenceRule,
      estimatedMinutes: _estimatedMinutes,
      smartReminders: List<SmartReminderConfig>.from(_smartReminders),
      reminderMode: _reminderMode,
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
            reminderMode: input.reminderMode,
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
