import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/features/notes/application/note_providers.dart';
import 'package:todolist/src/features/search/application/enhanced_search_service.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';

/// 增强的全局搜索页面
/// 支持模糊搜索、筛选、搜索历史
class EnhancedSearchPage extends ConsumerStatefulWidget {
  const EnhancedSearchPage({super.key});

  static const routePath = '/enhanced-search';
  static const routeName = 'enhanced-search';

  @override
  ConsumerState<EnhancedSearchPage> createState() => _EnhancedSearchPageState();
}

class _EnhancedSearchPageState extends ConsumerState<EnhancedSearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<EnhancedSearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final service = ref.read(enhancedSearchServiceProvider);
    final tasks = ref.read(allTasksProvider).valueOrNull ?? [];
    final notes = ref.read(notesProvider).valueOrNull ?? [];
    final tags = ref.read(tagsProvider).valueOrNull ?? [];
    final tagMap = {for (final tag in tags) tag.id: tag};
    final filter = ref.read(searchFilterProvider);

    final results = service.searchAll(
      query: query,
      tasks: tasks,
      notes: notes,
      tagMap: tagMap,
      filter: filter,
    );

    setState(() {
      _searchResults = results;
    });

    // 添加到历史
    await service.addToHistory(query);
    ref.invalidate(searchHistoryEnhancedProvider);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _isSearching = false;
    });
    _focusNode.requestFocus();
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '搜索任务和笔记...',
            border: InputBorder.none,
            hintStyle: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          style: theme.textTheme.titleLarge,
          onChanged: _performSearch,
          onSubmitted: _performSearch,
        ),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_alt : Icons.filter_alt_outlined),
            onPressed: _toggleFilters,
            tooltip: '筛选',
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: Column(
        children: [
          // 筛选器面板
          if (_showFilters) _FilterPanel(),

          // 搜索结果或历史
          Expanded(
            child: _isSearching
                ? _SearchResultsList(
                    query: _searchController.text,
                    results: _searchResults,
                  )
                : _SearchHistoryList(
                    onHistoryTap: (query) {
                      _searchController.text = query;
                      _performSearch(query);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 筛选面板
class _FilterPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filter = ref.watch(searchFilterProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间筛选
            Text(
              '时间范围',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: filter.startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        ref.read(searchFilterProvider.notifier).state =
                            filter.copyWith(startDate: date);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      filter.startDate != null
                          ? DateFormat('yyyy-MM-dd').format(filter.startDate!)
                          : '开始日期',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: filter.endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        ref.read(searchFilterProvider.notifier).state =
                            filter.copyWith(endDate: date);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      filter.endDate != null
                          ? DateFormat('yyyy-MM-dd').format(filter.endDate!)
                          : '结束日期',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 分类筛选
            Text(
              '笔记分类',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: NoteCategory.values.map((category) {
                final note = Note(
                  id: '',
                  title: '',
                  content: '',
                  category: category,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                final isSelected = filter.noteCategories.contains(category);

                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(note.getCategoryIcon()),
                      const SizedBox(width: 4),
                      Text(note.getCategoryName(), style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    final categories = List<NoteCategory>.from(filter.noteCategories);
                    if (selected) {
                      categories.add(category);
                    } else {
                      categories.remove(category);
                    }
                    ref.read(searchFilterProvider.notifier).state =
                        filter.copyWith(noteCategories: categories);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 选项
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('显示已完成任务', style: TextStyle(fontSize: 14)),
              value: filter.showCompleted,
              onChanged: (value) {
                ref.read(searchFilterProvider.notifier).state =
                    filter.copyWith(showCompleted: value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('显示已归档笔记', style: TextStyle(fontSize: 14)),
              value: filter.showArchived,
              onChanged: (value) {
                ref.read(searchFilterProvider.notifier).state =
                    filter.copyWith(showArchived: value);
              },
            ),

            // 重置按钮
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(searchFilterProvider.notifier).state = const SearchFilter();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('重置筛选'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 搜索历史列表
class _SearchHistoryList extends ConsumerWidget {
  const _SearchHistoryList({required this.onHistoryTap});

  final void Function(String) onHistoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final history = ref.watch(searchHistoryEnhancedProvider);

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 72,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              '开始搜索任务和笔记',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '支持模糊搜索和高级筛选',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '搜索历史',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  final service = ref.read(enhancedSearchServiceProvider);
                  await service.clearHistory();
                  ref.invalidate(searchHistoryEnhancedProvider);
                },
                child: const Text('清除'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final query = history[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () async {
                    final service = ref.read(enhancedSearchServiceProvider);
                    await service.removeFromHistory(query);
                    ref.invalidate(searchHistoryEnhancedProvider);
                  },
                ),
                onTap: () => onHistoryTap(query),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 搜索结果列表
class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    required this.query,
    required this.results,
  });

  final String query;
  final List<EnhancedSearchResult> results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 72,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            const Text(
              '未找到相关结果',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '尝试使用不同的关键词',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '找到 ${results.length} 个结果',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _SearchResultCard(
                result: result,
                query: query,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 搜索结果卡片
class _SearchResultCard extends ConsumerWidget {
  const _SearchResultCard({
    required this.result,
    required this.query,
  });

  final EnhancedSearchResult result;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          if (result.type == SearchResultType.task) {
            context.push('/tasks/${result.task!.id}');
          } else {
            context.push('/notes/${result.note!.id}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 类型标识
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: result.type == SearchResultType.task
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          result.type == SearchResultType.task
                              ? Icons.task_alt
                              : Icons.note,
                          size: 14,
                          color: result.type == SearchResultType.task
                              ? Colors.blue
                              : Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          result.type == SearchResultType.task ? '任务' : '笔记',
                          style: TextStyle(
                            fontSize: 12,
                            color: result.type == SearchResultType.task
                                ? Colors.blue
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${result.score.toInt()}%',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 标题
              _HighlightedText(
                text: result.title,
                query: query,
                highlight: result.matchedInTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 内容预览
              if (result.content.isNotEmpty) ...[
                const SizedBox(height: 8),
                _HighlightedText(
                  text: result.content,
                  query: query,
                  highlight: result.matchedInContent,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                ),
              ],

              // 标签
              if (result.matchedTagNames.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: result.matchedTagNames.map((tag) {
                    return Chip(
                      label: Text('#$tag'),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 高亮文本组件
class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.highlight,
    this.style,
    this.maxLines,
  });

  final String text;
  final String query;
  final bool highlight;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    if (!highlight || query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final theme = Theme.of(context);
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];

    var currentIndex = 0;
    while (currentIndex < text.length) {
      final matchIndex = lowerText.indexOf(lowerQuery, currentIndex);
      if (matchIndex == -1) {
        spans.add(TextSpan(text: text.substring(currentIndex), style: style));
        break;
      }

      if (matchIndex > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, matchIndex),
          style: style,
        ));
      }

      spans.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: style?.copyWith(
          backgroundColor: theme.colorScheme.primaryContainer,
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ));

      currentIndex = matchIndex + query.length;
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }
}
