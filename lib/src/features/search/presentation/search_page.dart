import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/search/application/search_service.dart';
import 'package:todolist/src/features/tasks/application/task_catalog_providers.dart';
import 'package:todolist/src/features/tasks/application/task_service.dart';
import 'package:todolist/src/features/tasks/presentation/task_detail_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  static const routePath = '/search';
  static const routeName = 'search';

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;

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

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final service = ref.read(searchServiceProvider);
    final tasks = ref.read(allTasksProvider).valueOrNull ?? [];
    final tags = ref.read(tagsProvider).valueOrNull ?? [];
    final tagMap = {for (final tag in tags) tag.id: tag};

    final results = service.searchTasks(
      query: query,
      tasks: tasks,
      tagMap: tagMap,
    );

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });

    // Add to history
    service.addToHistory(query);
    ref.invalidate(searchHistoryProvider);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _isSearching = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
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
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: _isSearching
          ? _SearchResults(
              query: _searchController.text,
              results: _searchResults,
            )
          : _SearchHistory(
              onHistoryTap: (query) {
                _searchController.text = query;
                _performSearch(query);
              },
            ),
    );
  }
}

class _SearchHistory extends ConsumerWidget {
  const _SearchHistory({required this.onHistoryTap});

  final void Function(String) onHistoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final history = ref.watch(searchHistoryProvider);

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                size: 72,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.searchEmptyHistory,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
                l10n.searchRecentSearches,
                style: theme.textTheme.titleSmall,
              ),
              TextButton(
                onPressed: () async {
                  final service = ref.read(searchServiceProvider);
                  await service.clearHistory();
                  ref.invalidate(searchHistoryProvider);
                },
                child: Text(l10n.searchClearHistory),
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
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    final service = ref.read(searchServiceProvider);
                    await service.removeFromHistory(query);
                    ref.invalidate(searchHistoryProvider);
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

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.query,
    required this.results,
  });

  final String query;
  final List<SearchResult> results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 72,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.searchNoResults,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.searchNoResultsHint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final listsAsync = ref.watch(taskListsProvider);
    final tagsAsync = ref.watch(tagsProvider);

    final listMap = {
      for (final list in listsAsync.valueOrNull ?? <TaskList>[])
        list.id: list,
    };
    final tagMap = {
      for (final tag in tagsAsync.valueOrNull ?? <Tag>[]) tag.id: tag,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.searchResultsCount(results.length),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _SearchResultTile(
                result: result,
                query: query,
                listMap: listMap,
                tagMap: tagMap,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({
    required this.result,
    required this.query,
    required this.listMap,
    required this.tagMap,
  });

  final SearchResult result;
  final String query;
  final Map<String, TaskList> listMap;
  final Map<String, Tag> tagMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final task = result.task;
    final taskList = listMap[task.listId];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          context.push(TaskDetailPage.buildPath(task.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      if (value != null) {
                        final service = ref.read(taskServiceProvider);
                        await service.toggleCompletion(task, isCompleted: value);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HighlightedText(
                          text: task.title,
                          query: query,
                          highlight: result.matchedInTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (task.notes != null && task.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          _HighlightedText(
                            text: task.notes!,
                            query: query,
                            highlight: result.matchedInNotes,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (task.tagIds.isNotEmpty || result.matchedInTags) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: task.tagIds.map((tagId) {
                    final tag = tagMap[tagId];
                    if (tag == null) return const SizedBox.shrink();
                    final isMatched = result.matchedTagNames.contains(tag.name);
                    return _TagChip(
                      tag: tag,
                      query: query,
                      isMatched: isMatched,
                    );
                  }).toList(),
                ),
              ],
              if (taskList != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _iconFromString(taskList.iconName ?? 'inbox'),
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      taskList.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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

  IconData _iconFromString(String name) {
    const iconMap = {
      'inbox': Icons.inbox,
      'work': Icons.work,
      'home': Icons.home,
      'shopping_cart': Icons.shopping_cart,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'calendar_today': Icons.calendar_today,
      'school': Icons.school,
      'fitness_center': Icons.fitness_center,
      'restaurant': Icons.restaurant,
      'flight': Icons.flight,
      'lightbulb': Icons.lightbulb,
      'brush': Icons.brush,
      'music_note': Icons.music_note,
      'sports_soccer': Icons.sports_soccer,
    };
    return iconMap[name] ?? Icons.list;
  }
}

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
        // No more matches
        spans.add(TextSpan(
          text: text.substring(currentIndex),
          style: style,
        ));
        break;
      }

      // Add text before match
      if (matchIndex > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, matchIndex),
          style: style,
        ));
      }

      // Add highlighted match
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

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    required this.query,
    required this.isMatched,
  });

  final Tag tag;
  final String query;
  final bool isMatched;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorFromHex(tag.colorHex);

    if (!isMatched) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.label, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              tag.name,
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ),
      );
    }

    // Highlighted tag
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.label,
            size: 12,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            tag.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final sanitized = hex.replaceFirst('#', '');
    final value = int.tryParse(sanitized, radix: 16) ?? 0xFF8896AB;
    return Color(0xFF000000 | value);
  }
}
