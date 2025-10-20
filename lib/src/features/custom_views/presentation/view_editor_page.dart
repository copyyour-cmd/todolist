import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/custom_view.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/features/custom_views/application/custom_view_providers.dart';

class ViewEditorPage extends ConsumerStatefulWidget {
  const ViewEditorPage({this.viewId, super.key});

  final String? viewId;

  static const routePath = '/view-editor';
  static const routeName = 'viewEditor';

  static String buildPath({String? viewId}) {
    if (viewId != null) {
      return '$routePath?id=$viewId';
    }
    return routePath;
  }

  @override
  ConsumerState<ViewEditorPage> createState() => _ViewEditorPageState();
}

class _ViewEditorPageState extends ConsumerState<ViewEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  final List<FilterCondition> _filters = [];
  SortConfig? _sortConfig;
  String? _selectedIcon;
  String? _selectedColor;

  bool _isLoading = false;
  CustomView? _existingView;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadView();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadView() async {
    if (widget.viewId == null) return;

    setState(() => _isLoading = true);
    try {
      final service = ref.read(customViewServiceProvider);
      final view = await service.getViewById(widget.viewId!);
      if (view != null) {
        setState(() {
          _existingView = view;
          _nameController.text = view.name;
          _descriptionController.text = view.description ?? '';
          _filters.addAll(view.filters);
          _sortConfig = view.sortConfig;
          _selectedIcon = view.icon;
          _selectedColor = view.color;
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewId == null ? '创建视图' : '编辑视图'),
        actions: [
          TextButton(
            onPressed: _saveView,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '视图名称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入视图名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述（可选）',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text(
              '图标和颜色',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _IconColorPicker(
              selectedIcon: _selectedIcon,
              selectedColor: _selectedColor,
              onIconChanged: (icon) => setState(() => _selectedIcon = icon),
              onColorChanged: (color) => setState(() => _selectedColor = color),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '筛选条件',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addFilter,
                  icon: const Icon(Icons.add),
                  label: const Text('添加条件'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_filters.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '暂无筛选条件',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ..._filters.asMap().entries.map((entry) {
                final index = entry.key;
                final filter = entry.value;
                return _FilterCard(
                  filter: filter,
                  onDelete: () => setState(() => _filters.removeAt(index)),
                );
              }),
            const SizedBox(height: 24),
            Text(
              '排序',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _SortConfigWidget(
              sortConfig: _sortConfig,
              onChanged: (config) => setState(() => _sortConfig = config),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFilter() async {
    final filter = await showDialog<FilterCondition>(
      context: context,
      builder: (context) => const _FilterEditorDialog(),
    );

    if (filter != null) {
      setState(() => _filters.add(filter));
    }
  }

  Future<void> _saveView() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final service = ref.read(customViewServiceProvider);

      if (_existingView != null) {
        // Update existing view
        final updated = _existingView!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          filters: _filters,
          sortConfig: _sortConfig,
          icon: _selectedIcon,
          color: _selectedColor,
        );
        await service.updateView(updated);
      } else {
        // Create new view
        await service.createView(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          type: ViewType.custom,
          filters: _filters,
          sortConfig: _sortConfig,
          icon: _selectedIcon,
          color: _selectedColor,
        );
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    }
  }
}

class _IconColorPicker extends StatelessWidget {
  const _IconColorPicker({
    required this.selectedIcon,
    required this.selectedColor,
    required this.onIconChanged,
    required this.onColorChanged,
  });

  final String? selectedIcon;
  final String? selectedColor;
  final ValueChanged<String?> onIconChanged;
  final ValueChanged<String?> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final icons = [
      ('view_list', Icons.view_list),
      ('star', Icons.star),
      ('work', Icons.work),
      ('home', Icons.home),
      ('school', Icons.school),
      ('shopping', Icons.shopping_cart),
    ];

    final colors = [
      ('red', Colors.red),
      ('orange', Colors.orange),
      ('yellow', Colors.yellow),
      ('green', Colors.green),
      ('blue', Colors.blue),
      ('purple', Colors.purple),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('图标'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: icons.map((entry) {
            final key = entry.$1;
            final icon = entry.$2;
            final isSelected = selectedIcon == key;
            return ActionChip(
              label: Icon(icon),
              backgroundColor: isSelected ? Colors.blue.withValues(alpha: 0.2) : null,
              side: BorderSide(
                color: isSelected ? Colors.blue : Colors.grey,
                width: isSelected ? 2 : 1,
              ),
              onPressed: () => onIconChanged(key),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('颜色'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: colors.map((entry) {
            final key = entry.$1;
            final color = entry.$2;
            final isSelected = selectedColor == key;
            return InkWell(
              onTap: () => onColorChanged(key),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.filter,
    required this.onDelete,
  });

  final FilterCondition filter;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String fieldName;
    switch (filter.field) {
      case FilterField.status:
        fieldName = '状态';
      case FilterField.priority:
        fieldName = '优先级';
      case FilterField.dueDate:
        fieldName = '截止日期';
      case FilterField.tags:
        fieldName = '标签';
      case FilterField.list:
        fieldName = '列表';
      case FilterField.title:
        fieldName = '标题';
      case FilterField.hasAttachments:
        fieldName = '附件';
      case FilterField.hasReminder:
        fieldName = '提醒';
      case FilterField.createdDate:
        fieldName = '创建日期';
      case FilterField.completedDate:
        fieldName = '完成日期';
    }

    String operatorName;
    switch (filter.operator) {
      case FilterOperator.equals:
        operatorName = '等于';
      case FilterOperator.notEquals:
        operatorName = '不等于';
      case FilterOperator.contains:
        operatorName = '包含';
      case FilterOperator.notContains:
        operatorName = '不包含';
      case FilterOperator.greaterThan:
        operatorName = '大于';
      case FilterOperator.lessThan:
        operatorName = '小于';
      case FilterOperator.isNull:
        operatorName = '为空';
      case FilterOperator.isNotNull:
        operatorName = '不为空';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text('$fieldName $operatorName ${filter.value ?? ""}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _SortConfigWidget extends StatelessWidget {
  const _SortConfigWidget({
    required this.sortConfig,
    required this.onChanged,
  });

  final SortConfig? sortConfig;
  final ValueChanged<SortConfig?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<FilterField>(
              initialValue: sortConfig?.field,
              decoration: const InputDecoration(
                labelText: '排序字段',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: FilterField.dueDate,
                  child: Text('截止日期'),
                ),
                DropdownMenuItem(
                  value: FilterField.priority,
                  child: Text('优先级'),
                ),
                DropdownMenuItem(
                  value: FilterField.createdDate,
                  child: Text('创建日期'),
                ),
                DropdownMenuItem(
                  value: FilterField.title,
                  child: Text('标题'),
                ),
              ],
              onChanged: (field) {
                if (field != null) {
                  onChanged(SortConfig(field: field));
                } else {
                  onChanged(null);
                }
              },
            ),
            if (sortConfig != null) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<SortOrder>(
                initialValue: sortConfig!.order,
                decoration: const InputDecoration(
                  labelText: '排序方式',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SortOrder.ascending,
                    child: Text('升序'),
                  ),
                  DropdownMenuItem(
                    value: SortOrder.descending,
                    child: Text('降序'),
                  ),
                ],
                onChanged: (order) {
                  if (order != null) {
                    onChanged(sortConfig!.copyWith(order: order));
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterEditorDialog extends StatefulWidget {
  const _FilterEditorDialog();

  @override
  State<_FilterEditorDialog> createState() => _FilterEditorDialogState();
}

class _FilterEditorDialogState extends State<_FilterEditorDialog> {
  FilterField _selectedField = FilterField.status;
  FilterOperator _selectedOperator = FilterOperator.equals;
  final _valueController = TextEditingController();
  bool _isPriorityExpanded = false;
  bool _isTagExpanded = false;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final needsValue = _selectedOperator != FilterOperator.isNull &&
        _selectedOperator != FilterOperator.isNotNull;

    return AlertDialog(
      title: const Text('添加筛选条件'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<FilterField>(
              initialValue: _selectedField,
              decoration: const InputDecoration(
                labelText: '字段',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: FilterField.status,
                  child: Text('状态'),
                ),
                DropdownMenuItem(
                  value: FilterField.priority,
                  child: Text('优先级'),
                ),
                DropdownMenuItem(
                  value: FilterField.title,
                  child: Text('标题'),
                ),
                DropdownMenuItem(
                  value: FilterField.tags,
                  child: Text('标签'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedField = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<FilterOperator>(
              initialValue: _selectedOperator,
              decoration: const InputDecoration(
                labelText: '操作符',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: FilterOperator.equals,
                  child: Text('等于'),
                ),
                DropdownMenuItem(
                  value: FilterOperator.notEquals,
                  child: Text('不等于'),
                ),
                DropdownMenuItem(
                  value: FilterOperator.contains,
                  child: Text('包含'),
                ),
                DropdownMenuItem(
                  value: FilterOperator.notContains,
                  child: Text('不包含'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedOperator = value);
                }
              },
            ),
            if (needsValue) ...[
              const SizedBox(height: 16),
              _buildValueField(),
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
            final filter = FilterCondition(
              field: _selectedField,
              operator: _selectedOperator,
              value: needsValue ? _valueController.text.trim() : null,
            );
            Navigator.of(context).pop(filter);
          },
          child: const Text('添加'),
        ),
      ],
    );
  }

  Widget _buildValueField() {
    switch (_selectedField) {
      case FilterField.status:
        return DropdownButtonFormField<TaskStatus>(
          decoration: const InputDecoration(
            labelText: '值',
            border: OutlineInputBorder(),
          ),
          items: TaskStatus.values
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              _valueController.text = value.name;
            }
          },
        );

      case FilterField.priority:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() => _isPriorityExpanded = !_isPriorityExpanded);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_valueController.text.isEmpty ? '选择优先级' : _valueController.text),
                    Icon(_isPriorityExpanded ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
              ),
            ),
            if (_isPriorityExpanded) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: TaskPriority.values.map((priority) {
                    return FilterChip(
                      label: Text(_getPriorityLabel(priority)),
                      selected: _valueController.text == priority.name,
                      onSelected: (selected) {
                        setState(() {
                          _valueController.text = priority.name;
                          _isPriorityExpanded = false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        );

      case FilterField.tags:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() => _isTagExpanded = !_isTagExpanded);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_valueController.text.isEmpty ? '选择标签' : _valueController.text),
                    Icon(_isTagExpanded ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
              ),
            ),
            if (_isTagExpanded) ...[
              const SizedBox(height: 8),
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
                    FilterChip(
                      label: const Text('收件箱'),
                      selected: _valueController.text == '收件箱',
                      onSelected: (selected) {
                        setState(() {
                          _valueController.text = '收件箱';
                          _isTagExpanded = false;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('计划'),
                      selected: _valueController.text == '计划',
                      onSelected: (selected) {
                        setState(() {
                          _valueController.text = '计划';
                          _isTagExpanded = false;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('专注'),
                      selected: _valueController.text == '专注',
                      onSelected: (selected) {
                        setState(() {
                          _valueController.text = '专注';
                          _isTagExpanded = false;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('个人'),
                      selected: _valueController.text == '个人',
                      onSelected: (selected) {
                        setState(() {
                          _valueController.text = '个人';
                          _isTagExpanded = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      default:
        return TextFormField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: '值',
            border: OutlineInputBorder(),
          ),
        );
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.none:
        return 'None';
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.critical:
        return 'Critical';
    }
  }
}
