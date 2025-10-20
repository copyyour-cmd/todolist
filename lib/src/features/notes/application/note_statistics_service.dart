import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// 笔记统计数据
class NoteStatistics {
  const NoteStatistics({
    required this.totalNotes,
    required this.totalWords,
    required this.averageWordsPerNote,
    required this.notesByCategory,
    required this.notesByDate,
    required this.tagFrequency,
    required this.writingHeatmap,
    required this.longestNote,
    required this.mostViewedNote,
    required this.recentNotes,
  });

  final int totalNotes; // 总笔记数
  final int totalWords; // 总字数
  final int averageWordsPerNote; // 平均每篇字数
  final Map<NoteCategory, int> notesByCategory; // 按分类统计
  final Map<DateTime, int> notesByDate; // 按日期统计
  final Map<String, int> tagFrequency; // 标签频率
  final Map<DateTime, int> writingHeatmap; // 写作热力图数据
  final Note? longestNote; // 最长笔记
  final Note? mostViewedNote; // 最多浏览笔记
  final List<Note> recentNotes; // 最近笔记

  /// 获取最常用的标签(前N个)
  List<MapEntry<String, int>> getTopTags(int count) {
    final sorted = tagFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(count).toList();
  }

  /// 获取日期范围内的笔记趋势
  Map<DateTime, int> getTrend(DateTime startDate, DateTime endDate) {
    return Map.fromEntries(
      notesByDate.entries.where(
        (entry) =>
            !entry.key.isBefore(startDate) && !entry.key.isAfter(endDate),
      ),
    );
  }
}

/// 笔记统计服务
class NoteStatisticsService {
  NoteStatisticsService(this._noteRepository);

  final NoteRepository _noteRepository;

  /// 计算笔记统计数据
  Future<NoteStatistics> calculateStatistics() async {
    final notes = await _noteRepository.getAll();

    if (notes.isEmpty) {
      return NoteStatistics(
        totalNotes: 0,
        totalWords: 0,
        averageWordsPerNote: 0,
        notesByCategory: {},
        notesByDate: {},
        tagFrequency: {},
        writingHeatmap: {},
        longestNote: null,
        mostViewedNote: null,
        recentNotes: [],
      );
    }

    // 计算基本统计
    final totalWords = notes.fold<int>(
      0,
      (sum, note) => sum + (note.wordCount ?? note.content.length),
    );

    // 按分类统计
    final notesByCategory = <NoteCategory, int>{};
    for (final note in notes) {
      notesByCategory[note.category] =
          (notesByCategory[note.category] ?? 0) + 1;
    }

    // 按日期统计(按天)
    final notesByDate = <DateTime, int>{};
    for (final note in notes) {
      final date = DateTime(
        note.createdAt.year,
        note.createdAt.month,
        note.createdAt.day,
      );
      notesByDate[date] = (notesByDate[date] ?? 0) + 1;
    }

    // 标签频率统计
    final tagFrequency = <String, int>{};
    for (final note in notes) {
      for (final tag in note.tags) {
        tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
      }
    }

    // 写作热力图(最近365天)
    final now = DateTime.now();
    final writingHeatmap = <DateTime, int>{};
    for (var i = 364; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(
        Duration(days: i),
      );
      writingHeatmap[date] = 0;
    }
    for (final note in notes) {
      final date = DateTime(
        note.createdAt.year,
        note.createdAt.month,
        note.createdAt.day,
      );
      if (writingHeatmap.containsKey(date)) {
        writingHeatmap[date] = writingHeatmap[date]! + 1;
      }
    }

    // 找出最长笔记
    Note? longestNote;
    int maxWords = 0;
    for (final note in notes) {
      final words = note.wordCount ?? note.content.length;
      if (words > maxWords) {
        maxWords = words;
        longestNote = note;
      }
    }

    // 找出最多浏览笔记
    Note? mostViewedNote;
    int maxViews = 0;
    for (final note in notes) {
      if (note.viewCount > maxViews) {
        maxViews = note.viewCount;
        mostViewedNote = note;
      }
    }

    // 最近笔记(前10条)
    final sortedNotes = List<Note>.from(notes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recentNotes = sortedNotes.take(10).toList();

    return NoteStatistics(
      totalNotes: notes.length,
      totalWords: totalWords,
      averageWordsPerNote: totalWords ~/ notes.length,
      notesByCategory: notesByCategory,
      notesByDate: notesByDate,
      tagFrequency: tagFrequency,
      writingHeatmap: writingHeatmap,
      longestNote: longestNote,
      mostViewedNote: mostViewedNote,
      recentNotes: recentNotes,
    );
  }

  /// 获取指定时间范围的统计
  Future<NoteStatistics> calculateStatisticsForPeriod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allNotes = await _noteRepository.getAll();
    final notes = allNotes.where((note) {
      return !note.createdAt.isBefore(startDate) &&
          !note.createdAt.isAfter(endDate);
    }).toList();

    // 类似的统计逻辑,但只针对时间范围内的笔记
    if (notes.isEmpty) {
      return NoteStatistics(
        totalNotes: 0,
        totalWords: 0,
        averageWordsPerNote: 0,
        notesByCategory: {},
        notesByDate: {},
        tagFrequency: {},
        writingHeatmap: {},
        longestNote: null,
        mostViewedNote: null,
        recentNotes: [],
      );
    }

    final totalWords = notes.fold<int>(
      0,
      (sum, note) => sum + (note.wordCount ?? note.content.length),
    );

    final notesByCategory = <NoteCategory, int>{};
    for (final note in notes) {
      notesByCategory[note.category] =
          (notesByCategory[note.category] ?? 0) + 1;
    }

    final notesByDate = <DateTime, int>{};
    for (final note in notes) {
      final date = DateTime(
        note.createdAt.year,
        note.createdAt.month,
        note.createdAt.day,
      );
      notesByDate[date] = (notesByDate[date] ?? 0) + 1;
    }

    final tagFrequency = <String, int>{};
    for (final note in notes) {
      for (final tag in note.tags) {
        tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
      }
    }

    return NoteStatistics(
      totalNotes: notes.length,
      totalWords: totalWords,
      averageWordsPerNote: totalWords ~/ notes.length,
      notesByCategory: notesByCategory,
      notesByDate: notesByDate,
      tagFrequency: tagFrequency,
      writingHeatmap: notesByDate,
      longestNote: notes.isNotEmpty ? notes.first : null,
      mostViewedNote: notes.isNotEmpty ? notes.first : null,
      recentNotes: notes.take(10).toList(),
    );
  }
}

final noteStatisticsServiceProvider = Provider<NoteStatisticsService>((ref) {
  final noteRepository = ref.watch(noteRepositoryProvider);
  return NoteStatisticsService(noteRepository);
});

final noteStatisticsProvider = FutureProvider<NoteStatistics>((ref) async {
  final service = ref.watch(noteStatisticsServiceProvider);
  return service.calculateStatistics();
});
