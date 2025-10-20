import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/application/note_providers.dart';
import 'package:todolist/src/features/notes/presentation/note_editor_page.dart';

/// 笔记搜索页面
class NoteSearchPage extends ConsumerStatefulWidget {
  const NoteSearchPage({super.key});

  static const routeName = 'note-search';
  static const routePath = '/notes/search';

  @override
  ConsumerState<NoteSearchPage> createState() => _NoteSearchPageState();
}

class _NoteSearchPageState extends ConsumerState<NoteSearchPage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  String _currentQuery = '';
  List<String> _searchHistory = [];
  NoteCategory? _filterCategory;

  // 防抖Timer
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    // TODO: 从SharedPreferences加载搜索历史
    setState(() {
      _searchHistory = [];
    });
  }

  Future<void> _saveSearchHistory(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      // 移除重复项并添加到开头
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      // 限制历史记录数量
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.sublist(0, 10);
      }
    });

    // TODO: 保存到SharedPreferences
  }

  Future<void> _clearSearchHistory() async {
    setState(() {
      _searchHistory = [];
    });
    // TODO: 从SharedPreferences清除
  }

  /// 防抖搜索 - 用户输入时调用
  void _onSearchChanged(String query) {
    // 取消之前的Timer
    _debounceTimer?.cancel();

    // 如果查询为空,立即更新UI
    if (query.trim().isEmpty) {
      setState(() {
        _currentQuery = '';
      });
      return;
    }

    // 300ms后执行搜索
    _debounceTimer = Timer(_debounceDuration, () {
      _performSearch(query);
    });
  }

  /// 执行搜索 - 实际触发搜索逻辑
  void _performSearch(String query) {
    setState(() {
      _currentQuery = query;
    });
    if (query.trim().isNotEmpty) {
      _saveSearchHistory(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: '搜索笔记标题、内容或标签...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _currentQuery = '';
                      });
                    },
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            setState(() {}); // 更新清除按钮显示状态
            _onSearchChanged(value); // 防抖搜索
          },
          onSubmitted: (value) {
            _debounceTimer?.cancel(); // 取消防抖,立即搜索
            _performSearch(value);
          },
        ),
        actions: [
          // 分类筛选
          PopupMenuButton<NoteCategory?>(
            icon: Icon(
              Icons.filter_list,
              color: _filterCategory != null
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            tooltip: '按分类筛选',
            onSelected: (category) {
              setState(() {
                _filterCategory = category;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive),
                    SizedBox(width: 12),
                    Text('所有分类'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              ...NoteCategory.values.map((category) {
                final note = Note(
                  id: '',
                  title: '',
                  content: '',
                  category: category,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                return PopupMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Text(note.getCategoryIcon(), style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Text(note.getCategoryName()),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      body: _currentQuery.isEmpty
          ? _buildSearchHistory(theme)
          : _buildSearchResults(theme),
    );
  }

  Widget _buildSearchHistory(ThemeData theme) {
    if (_searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '搜索笔记',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '输入关键词搜索笔记标题、内容或标签',
              style: theme.textTheme.bodyMedium?.copyWith(
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
              Text(
                '搜索历史',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _clearSearchHistory,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('清空'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final query = _searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.north_west),
                  onPressed: () {
                    _searchController.text = query;
                    _performSearch(query);
                  },
                ),
                onTap: () {
                  _searchController.text = query;
                  _performSearch(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    final searchResultsAsync = ref.watch(searchNotesProvider(_currentQuery));

    return searchResultsAsync.when(
      data: (allResults) {
        // 应用分类筛选
        final results = _filterCategory == null
            ? allResults
            : allResults.where((note) => note.category == _filterCategory).toList();

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  '未找到匹配的笔记',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '尝试使用不同的关键词',
                  style: theme.textTheme.bodyMedium?.copyWith(
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
            // 搜索结果统计
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surfaceContainerHighest,
              child: Row(
                children: [
                  Icon(Icons.search, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '找到 ${results.length} 条结果',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_filterCategory != null) ...[
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(_getCategoryName(_filterCategory!)),
                      onDeleted: () {
                        setState(() {
                          _filterCategory = null;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),

            // 搜索结果列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final note = results[index];
                  return _SearchResultCard(
                    note: note,
                    query: _currentQuery,
                    onTap: () {
                      context.push('/notes/${note.id}');
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('搜索失败: $error'),
      ),
    );
  }

  String _getCategoryName(NoteCategory category) {
    final note = Note(
      id: '',
      title: '',
      content: '',
      category: category,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return note.getCategoryName();
  }
}

/// 搜索结果卡片
class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.note,
    required this.query,
    required this.onTap,
  });

  final Note note;
  final String query;
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
              // 标题行
              Row(
                children: [
                  Text(
                    note.getCategoryIcon(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _highlightText(note.title, query),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPinned)
                    Icon(
                      Icons.push_pin,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  if (note.isFavorite)
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 内容预览
              Text(
                note.getPreviewText(maxLength: 150),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // 元数据和标签
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // 分类
                  Chip(
                    label: Text(note.getCategoryName()),
                    avatar: Text(note.getCategoryIcon()),
                    visualDensity: VisualDensity.compact,
                  ),
                  // 标签
                  ...note.tags.take(3).map((tag) => Chip(
                        label: Text('#$tag'),
                        visualDensity: VisualDensity.compact,
                      )),
                  if (note.tags.length > 3)
                    Chip(
                      label: Text('+${note.tags.length - 3}'),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),

              // 更新时间
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(note.updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (note.wordCount != null && note.wordCount! > 0) ...[
                    Text(
                      '${note.wordCount}字',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (note.readingTimeMinutes != null && note.readingTimeMinutes! > 0)
                    Text(
                      '${note.readingTimeMinutes}分钟',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _highlightText(String text, String query) {
    // 简单高亮实现,返回原文本
    // TODO: 实现真正的高亮效果(使用RichText和TextSpan)
    return text;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return '刚刚';
        }
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (dateTime.year == now.year) {
      return '${dateTime.month}月${dateTime.day}日';
    } else {
      return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
    }
  }
}
