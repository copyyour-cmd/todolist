import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';

class SearchResult {
  SearchResult({
    required this.task,
    required this.matchedInTitle,
    required this.matchedInNotes,
    required this.matchedInTags,
    required this.matchedTagNames,
  });

  final Task task;
  final bool matchedInTitle;
  final bool matchedInNotes;
  final bool matchedInTags;
  final List<String> matchedTagNames;
}

class SearchService {
  SearchService(this._preferences);

  final SharedPreferences _preferences;
  static const _searchHistoryKey = 'search_history';
  static const _maxHistoryItems = 10;

  // 搜索结果缓存
  final Map<String, List<SearchResult>> _cache = {};
  static const _maxCacheSize = 50;

  List<String> getSearchHistory() {
    return _preferences.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final history = getSearchHistory();

    // Remove if already exists
    history.remove(query);

    // Add to beginning
    history.insert(0, query);

    // Keep only max items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    await _preferences.setStringList(_searchHistoryKey, history);
  }

  Future<void> removeFromHistory(String query) async {
    final history = getSearchHistory();
    history.remove(query);
    await _preferences.setStringList(_searchHistoryKey, history);
  }

  Future<void> clearHistory() async {
    await _preferences.remove(_searchHistoryKey);
  }

  List<SearchResult> searchTasks({
    required String query,
    required List<Task> tasks,
    required Map<String, Tag> tagMap,
  }) {
    if (query.trim().isEmpty) return [];

    // 生成缓存key
    final cacheKey = '${query.toLowerCase()}_${tasks.length}';

    // 检查缓存
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // 执行搜索
    final lowerQuery = query.toLowerCase();
    final results = <SearchResult>[];

    for (final task in tasks) {
      var matchedInTitle = false;
      var matchedInNotes = false;
      var matchedInTags = false;
      final matchedTagNames = <String>[];

      // Check title
      if (task.title.toLowerCase().contains(lowerQuery)) {
        matchedInTitle = true;
      }

      // Check notes
      if (task.notes?.toLowerCase().contains(lowerQuery) ?? false) {
        matchedInNotes = true;
      }

      // Check tags
      for (final tagId in task.tagIds) {
        final tag = tagMap[tagId];
        if (tag != null && tag.name.toLowerCase().contains(lowerQuery)) {
          matchedInTags = true;
          matchedTagNames.add(tag.name);
        }
      }

      // Add to results if any match found
      if (matchedInTitle || matchedInNotes || matchedInTags) {
        results.add(SearchResult(
          task: task,
          matchedInTitle: matchedInTitle,
          matchedInNotes: matchedInNotes,
          matchedInTags: matchedInTags,
          matchedTagNames: matchedTagNames,
        ));
      }
    }

    // 缓存结果(限制缓存大小)
    _cacheResults(cacheKey, results);

    return results;
  }

  /// 缓存搜索结果
  void _cacheResults(String key, List<SearchResult> results) {
    // 如果缓存已满,删除最早的条目
    if (_cache.length >= _maxCacheSize) {
      final firstKey = _cache.keys.first;
      _cache.remove(firstKey);
    }
    _cache[key] = results;
  }

  /// 清除缓存
  void clearCache() {
    _cache.clear();
  }
}

final searchServiceProvider = Provider<SearchService>((ref) {
  throw UnimplementedError('searchServiceProvider not initialized');
});

final searchHistoryProvider = StateProvider<List<String>>((ref) {
  final service = ref.watch(searchServiceProvider);
  return service.getSearchHistory();
});
