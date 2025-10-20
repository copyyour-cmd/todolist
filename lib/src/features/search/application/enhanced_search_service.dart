import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/domain/entities/task.dart';

/// 搜索结果类型
enum SearchResultType {
  task,
  note,
}

/// 增强的搜索结果
class EnhancedSearchResult {
  EnhancedSearchResult({
    required this.type,
    required this.score,
    this.task,
    this.note,
    required this.matchedInTitle,
    required this.matchedInContent,
    required this.matchedInTags,
    required this.matchedTagNames,
    this.highlights = const [],
  });

  final SearchResultType type;
  final double score; // 匹配度分数，用于排序
  final Task? task;
  final Note? note;
  final bool matchedInTitle;
  final bool matchedInContent;
  final bool matchedInTags;
  final List<String> matchedTagNames;
  final List<String> highlights; // 高亮片段

  String get title => type == SearchResultType.task ? task!.title : note!.title;
  String get content =>
      type == SearchResultType.task ? (task!.notes ?? '') : note!.content;
}

/// 搜索筛选器
class SearchFilter {
  const SearchFilter({
    this.startDate,
    this.endDate,
    this.tags = const [],
    this.noteCategories = const [],
    this.showCompleted = true,
    this.showArchived = false,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tags;
  final List<NoteCategory> noteCategories;
  final bool showCompleted;
  final bool showArchived;

  SearchFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    List<NoteCategory>? noteCategories,
    bool? showCompleted,
    bool? showArchived,
  }) {
    return SearchFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tags: tags ?? this.tags,
      noteCategories: noteCategories ?? this.noteCategories,
      showCompleted: showCompleted ?? this.showCompleted,
      showArchived: showArchived ?? this.showArchived,
    );
  }
}

/// 增强的搜索服务
/// 支持模糊搜索、筛选、搜索历史等
class EnhancedSearchService {
  EnhancedSearchService(this._preferences);

  final SharedPreferences _preferences;
  static const _searchHistoryKey = 'enhanced_search_history';
  static const _maxHistoryItems = 20;

  // 搜索结果缓存
  final Map<String, List<EnhancedSearchResult>> _cache = {};
  static const _maxCacheSize = 100;

  /// 获取搜索历史
  List<String> getSearchHistory() {
    return _preferences.getStringList(_searchHistoryKey) ?? [];
  }

  /// 添加到历史
  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final history = getSearchHistory();
    history.remove(query); // 移除重复
    history.insert(0, query); // 添加到开头

    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    await _preferences.setStringList(_searchHistoryKey, history);
  }

  /// 从历史中移除
  Future<void> removeFromHistory(String query) async {
    final history = getSearchHistory();
    history.remove(query);
    await _preferences.setStringList(_searchHistoryKey, history);
  }

  /// 清空历史
  Future<void> clearHistory() async {
    await _preferences.remove(_searchHistoryKey);
  }

  /// 计算 Levenshtein 距离（用于模糊匹配）
  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );

    for (var i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= s1.length; i++) {
      for (var j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // 删除
          matrix[i][j - 1] + 1, // 插入
          matrix[i - 1][j - 1] + cost, // 替换
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// 计算相似度分数 (0-100)
  double _calculateSimilarity(String text, String query) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    // 精确匹配
    if (lowerText == lowerQuery) return 100.0;

    // 包含匹配
    if (lowerText.contains(lowerQuery)) {
      return 90.0 - (lowerText.indexOf(lowerQuery) * 0.1);
    }

    // 模糊匹配
    final distance = _levenshteinDistance(lowerText, lowerQuery);
    final maxLen = lowerText.length > lowerQuery.length
        ? lowerText.length
        : lowerQuery.length;

    if (maxLen == 0) return 0.0;

    final similarity = (1 - distance / maxLen) * 100;
    return similarity > 50 ? similarity : 0.0; // 相似度阈值
  }

  /// 搜索任务（支持模糊搜索）
  List<EnhancedSearchResult> searchTasks({
    required String query,
    required List<Task> tasks,
    required Map<String, Tag> tagMap,
    SearchFilter? filter,
  }) {
    if (query.trim().isEmpty) return [];

    // 生成缓存key
    final cacheKey = 'tasks_${query.toLowerCase()}_${tasks.length}_${filter.hashCode}';

    // 检查缓存
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final results = <EnhancedSearchResult>[];
    final lowerQuery = query.toLowerCase();

    for (final task in tasks) {
      // 应用筛选
      if (filter != null) {
        if (!filter.showCompleted && task.isCompleted) continue;
        if (filter.startDate != null && task.createdAt.isBefore(filter.startDate!)) {
          continue;
        }
        if (filter.endDate != null && task.createdAt.isAfter(filter.endDate!)) {
          continue;
        }
        if (filter.tags.isNotEmpty) {
          final hasMatchingTag = task.tagIds.any((id) => filter.tags.contains(id));
          if (!hasMatchingTag) continue;
        }
      }

      var matchedInTitle = false;
      var matchedInNotes = false;
      var matchedInTags = false;
      final matchedTagNames = <String>[];
      var score = 0.0;

      // 检查标题
      final titleScore = _calculateSimilarity(task.title, query);
      if (titleScore > 0) {
        matchedInTitle = true;
        score += titleScore * 2; // 标题权重更高
      }

      // 检查备注
      if (task.notes != null) {
        final notesScore = _calculateSimilarity(task.notes!, query);
        if (notesScore > 0) {
          matchedInNotes = true;
          score += notesScore;
        }
      }

      // 检查标签
      for (final tagId in task.tagIds) {
        final tag = tagMap[tagId];
        if (tag != null && tag.name.toLowerCase().contains(lowerQuery)) {
          matchedInTags = true;
          matchedTagNames.add(tag.name);
          score += 50; // 标签匹配加分
        }
      }

      if (matchedInTitle || matchedInNotes || matchedInTags) {
        results.add(EnhancedSearchResult(
          type: SearchResultType.task,
          task: task,
          score: score,
          matchedInTitle: matchedInTitle,
          matchedInContent: matchedInNotes,
          matchedInTags: matchedInTags,
          matchedTagNames: matchedTagNames,
        ));
      }
    }

    // 按分数排序
    results.sort((a, b) => b.score.compareTo(a.score));

    // 缓存结果
    _cacheResults(cacheKey, results);

    return results;
  }

  /// 搜索笔记（支持模糊搜索）
  List<EnhancedSearchResult> searchNotes({
    required String query,
    required List<Note> notes,
    SearchFilter? filter,
  }) {
    if (query.trim().isEmpty) return [];

    // 生成缓存key
    final cacheKey = 'notes_${query.toLowerCase()}_${notes.length}_${filter.hashCode}';

    // 检查缓存
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final results = <EnhancedSearchResult>[];

    for (final note in notes) {
      // 应用筛选
      if (filter != null) {
        if (!filter.showArchived && note.isArchived) continue;
        if (filter.startDate != null && note.createdAt.isBefore(filter.startDate!)) {
          continue;
        }
        if (filter.endDate != null && note.createdAt.isAfter(filter.endDate!)) {
          continue;
        }
        if (filter.noteCategories.isNotEmpty &&
            !filter.noteCategories.contains(note.category)) {
          continue;
        }
        if (filter.tags.isNotEmpty) {
          final hasMatchingTag = note.tags.any((tag) => filter.tags.contains(tag));
          if (!hasMatchingTag) continue;
        }
      }

      var matchedInTitle = false;
      var matchedInContent = false;
      var matchedInTags = false;
      final matchedTagNames = <String>[];
      var score = 0.0;

      // 检查标题
      final titleScore = _calculateSimilarity(note.title, query);
      if (titleScore > 0) {
        matchedInTitle = true;
        score += titleScore * 2;
      }

      // 检查内容
      final contentScore = _calculateSimilarity(note.content, query);
      if (contentScore > 0) {
        matchedInContent = true;
        score += contentScore;
      }

      // 检查OCR文本
      if (note.ocrText != null && note.ocrText!.isNotEmpty) {
        final ocrScore = _calculateSimilarity(note.ocrText!, query);
        if (ocrScore > 0) {
          matchedInContent = true; // OCR文本也算作内容匹配
          score += ocrScore * 0.8; // OCR文本权重稍低
        }
      }

      // 检查标签
      final lowerQuery = query.toLowerCase();
      for (final tag in note.tags) {
        if (tag.toLowerCase().contains(lowerQuery)) {
          matchedInTags = true;
          matchedTagNames.add(tag);
          score += 50;
        }
      }

      if (matchedInTitle || matchedInContent || matchedInTags) {
        results.add(EnhancedSearchResult(
          type: SearchResultType.note,
          note: note,
          score: score,
          matchedInTitle: matchedInTitle,
          matchedInContent: matchedInContent,
          matchedInTags: matchedInTags,
          matchedTagNames: matchedTagNames,
          highlights: _extractHighlights(note.content, query),
        ));
      }
    }

    // 按分数排序
    results.sort((a, b) => b.score.compareTo(a.score));

    // 缓存结果
    _cacheResults(cacheKey, results);

    return results;
  }

  /// 综合搜索（任务+笔记）
  List<EnhancedSearchResult> searchAll({
    required String query,
    required List<Task> tasks,
    required List<Note> notes,
    required Map<String, Tag> tagMap,
    SearchFilter? filter,
  }) {
    final taskResults = searchTasks(
      query: query,
      tasks: tasks,
      tagMap: tagMap,
      filter: filter,
    );

    final noteResults = searchNotes(
      query: query,
      notes: notes,
      filter: filter,
    );

    final allResults = [...taskResults, ...noteResults];
    allResults.sort((a, b) => b.score.compareTo(a.score));

    return allResults;
  }

  /// 提取高亮片段
  List<String> _extractHighlights(String content, String query, {int contextLength = 50}) {
    final highlights = <String>[];
    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();

    var startIndex = 0;
    while (startIndex < content.length) {
      final matchIndex = lowerContent.indexOf(lowerQuery, startIndex);
      if (matchIndex == -1) break;

      final start = (matchIndex - contextLength).clamp(0, content.length);
      final end = (matchIndex + query.length + contextLength).clamp(0, content.length);

      var snippet = content.substring(start, end);
      if (start > 0) snippet = '...$snippet';
      if (end < content.length) snippet = '$snippet...';

      highlights.add(snippet);

      startIndex = matchIndex + query.length;
      if (highlights.length >= 3) break; // 最多3个片段
    }

    return highlights;
  }

  /// 缓存搜索结果
  void _cacheResults(String key, List<EnhancedSearchResult> results) {
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

final enhancedSearchServiceProvider = Provider<EnhancedSearchService>((ref) {
  throw UnimplementedError('enhancedSearchServiceProvider not initialized');
});

final searchHistoryEnhancedProvider = StateProvider<List<String>>((ref) {
  final service = ref.watch(enhancedSearchServiceProvider);
  return service.getSearchHistory();
});

final searchFilterProvider = StateProvider<SearchFilter>((ref) {
  return const SearchFilter();
});
