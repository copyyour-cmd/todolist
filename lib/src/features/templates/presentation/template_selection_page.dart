import 'package:flutter/material.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/entities/task_template.dart';
import 'package:todolist/src/features/templates/application/template_service.dart';

class TemplateSelectionPage extends StatefulWidget {
  const TemplateSelectionPage({
    this.listId,
    super.key,
  });

  final String? listId;

  static const routePath = '/templates';
  static const routeName = 'templates';

  @override
  State<TemplateSelectionPage> createState() => _TemplateSelectionPageState();
}

class _TemplateSelectionPageState extends State<TemplateSelectionPage>
    with SingleTickerProviderStateMixin {
  final _templateService = TemplateService();
  final _searchController = TextEditingController();
  late TabController _tabController;

  List<TaskTemplate> _templates = [];
  List<TaskTemplate> _filteredTemplates = [];
  TemplateCategory? _selectedCategory;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TemplateCategory.values.length + 2, // +2 for "全部" and "常用"
      vsync: this,
    );
    _loadTemplates();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadTemplates() {
    setState(() {
      _templates = _templateService.getAllTemplates();
      _filteredTemplates = _templates;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _updateFilteredTemplates();
      });
    } else {
      setState(() {
        _isSearching = true;
        _filteredTemplates = _templateService.searchTemplates(query);
      });
    }
  }

  void _updateFilteredTemplates() {
    if (_selectedCategory == null) {
      // 显示所有模板
      _filteredTemplates = _templates;
    } else {
      _filteredTemplates =
          _templateService.getTemplatesByCategory(_selectedCategory!);
    }
  }

  Future<void> _selectTemplate(TaskTemplate template) async {
    // 显示模板详情对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _TemplateDetailDialog(template: template),
    );

    if (confirmed != true || !mounted) return;

    // 增加使用次数
    await _templateService.incrementUsageCount(template.id);

    // 从模板创建任务
    final task = template.createTask(listId: widget.listId);

    if (!mounted) return;

    // 返回创建的任务
    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('选择任务模板'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '搜索模板...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _searchController.clear,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                ),
              ),
              if (!_isSearching)
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  onTap: (index) {
                    setState(() {
                      if (index == 0) {
                        // 全部
                        _selectedCategory = null;
                        _filteredTemplates = _templates;
                      } else if (index == 1) {
                        // 常用
                        _selectedCategory = null;
                        _filteredTemplates =
                            _templateService.getPopularTemplates(limit: 20);
                      } else {
                        // 具体分类
                        _selectedCategory =
                            TemplateCategory.values[index - 2];
                        _updateFilteredTemplates();
                      }
                    });
                  },
                  tabs: [
                    const Tab(text: '全部'),
                    const Tab(text: '常用'),
                    ...TemplateCategory.values.map(
                      (category) => Tab(
                        icon: Icon(category.icon, size: 20),
                        text: category.displayName,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      body: _filteredTemplates.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isSearching ? '未找到匹配的模板' : '暂无模板',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredTemplates.length,
              itemBuilder: (context, index) {
                final template = _filteredTemplates[index];
                return _TemplateCard(
                  template: template,
                  onTap: () => _selectTemplate(template),
                );
              },
            ),
    );
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
                  // 图标
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(template.priority, theme)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      template.icon ?? template.category.icon,
                      color: _getPriorityColor(template.priority, theme),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 标题和分类
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
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              template.category.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            if (template.estimatedMinutes != null &&
                                template.estimatedMinutes! > 0) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: theme.colorScheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${template.estimatedMinutes}分钟',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 优先级指示器
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(template.priority, theme)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getPriorityText(template.priority),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getPriorityColor(template.priority, theme),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // 描述
              if (template.description != null &&
                  template.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  template.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // 标签
              if (template.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: template.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.labelSmall,
                      ),
                    );
                  }).toList(),
                ),
              ],
              // 使用次数
              if (template.usageCount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '已使用 ${template.usageCount} 次',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
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

  Color _getPriorityColor(TaskPriority priority, ThemeData theme) {
    switch (priority) {
      case TaskPriority.urgent:
        return Colors.red;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return '紧急';
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
    }
  }
}

class _TemplateDetailDialog extends StatelessWidget {
  const _TemplateDetailDialog({required this.template});

  final TaskTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getPriorityColor(template.priority, theme).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              template.icon ?? template.category.icon,
              color: _getPriorityColor(template.priority, theme),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              template.title,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 分类和优先级
            Row(
              children: [
                Icon(
                  template.category.icon,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  template.category.displayName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(template.priority, theme).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getPriorityText(template.priority),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getPriorityColor(template.priority, theme),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 描述
            if (template.description != null && template.description!.isNotEmpty) ...[
              Text(
                '模板介绍',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                template.description!,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],

            // 预计时长
            if (template.estimatedMinutes != null && template.estimatedMinutes! > 0) ...[
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '预计时长: ${template.estimatedMinutes} 分钟',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // 标签
            if (template.tags.isNotEmpty) ...[
              Text(
                '标签',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: template.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // 使用次数
            if (template.usageCount > 0) ...[
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '已被使用 ${template.usageCount} 次',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('使用此模板'),
        ),
      ],
    );
  }

  Color _getPriorityColor(TaskPriority priority, ThemeData theme) {
    switch (priority) {
      case TaskPriority.urgent:
        return Colors.red;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return '紧急';
      case TaskPriority.high:
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
    }
  }
}
