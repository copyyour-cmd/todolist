import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/data/note_link_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

part 'note_providers.g.dart';

/// 所有笔记流
@riverpod
Stream<List<Note>> notes(NotesRef ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.watchAll();
}

/// 根据ID获取笔记流
@riverpod
Stream<Note?> noteById(NoteByIdRef ref, String noteId) {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.watchById(noteId);
}

/// 根据分类获取笔记
@riverpod
Future<List<Note>> notesByCategory(
  NotesByCategoryRef ref,
  NoteCategory category,
) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getByCategory(category);
}

/// 收藏的笔记
@riverpod
Future<List<Note>> favoriteNotes(FavoriteNotesRef ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getFavorites();
}

/// 置顶的笔记
@riverpod
Future<List<Note>> pinnedNotes(PinnedNotesRef ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getPinned();
}

/// 归档的笔记
@riverpod
Future<List<Note>> archivedNotes(ArchivedNotesRef ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getArchived();
}

/// 最近查看的笔记
@riverpod
Future<List<Note>> recentlyViewedNotes(
  RecentlyViewedNotesRef ref, {
  int limit = 10,
}) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getRecentlyViewed(limit: limit);
}

/// 最近更新的笔记
@riverpod
Future<List<Note>> recentlyUpdatedNotes(
  RecentlyUpdatedNotesRef ref, {
  int limit = 10,
}) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getRecentlyUpdated(limit: limit);
}

/// 根据文件夹获取笔记
@riverpod
Future<List<Note>> notesByFolder(
  NotesByFolderRef ref,
  String? folderPath,
) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getByFolder(folderPath);
}

/// 根据标签获取笔记
@riverpod
Future<List<Note>> notesByTag(NotesByTagRef ref, String tag) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getByTag(tag);
}

/// 搜索笔记
@riverpod
Future<List<Note>> searchNotes(SearchNotesRef ref, String query) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.search(query);
}

/// 笔记统计信息
@riverpod
Future<NoteStatistics> noteStatistics(NoteStatisticsRef ref) async {
  final allNotes = await ref.watch(notesProvider.future);

  return NoteStatistics(
    totalNotes: allNotes.length,
    favoriteCount: allNotes.where((n) => n.isFavorite).length,
    pinnedCount: allNotes.where((n) => n.isPinned).length,
    archivedCount: allNotes.where((n) => n.isArchived).length,
    categoryCount: {
      for (final category in NoteCategory.values)
        category: allNotes.where((n) => n.category == category).length,
    },
    totalWordCount: allNotes.fold<int>(
      0,
      (sum, note) => sum + (note.wordCount ?? 0),
    ),
  );
}

/// 笔记链接服务Provider
@riverpod
NoteLinkService noteLinkService(NoteLinkServiceRef ref) {
  final repository = ref.watch(noteRepositoryProvider);
  return NoteLinkService(noteRepository: repository);
}

/// 获取笔记的反向链接(哪些笔记链接到了这个笔记)
@riverpod
Future<List<Note>> noteBacklinks(
  NoteBacklinksRef ref,
  String noteId,
) async {
  final linkService = ref.watch(noteLinkServiceProvider);
  return linkService.getBacklinks(noteId);
}

/// 获取笔记的正向链接(这个笔记链接到了哪些笔记)
@riverpod
Future<List<Note>> noteOutboundLinks(
  NoteOutboundLinksRef ref,
  String noteId,
) async {
  final linkService = ref.watch(noteLinkServiceProvider);
  return linkService.getOutboundLinks(noteId);
}

/// 获取笔记的完整链接统计
@riverpod
Future<NoteLinkStats> noteLinkStats(
  NoteLinkStatsRef ref,
  String noteId,
) async {
  final linkService = ref.watch(noteLinkServiceProvider);
  return linkService.getLinkStats(noteId);
}

/// 笔记统计数据类
class NoteStatistics {
  const NoteStatistics({
    required this.totalNotes,
    required this.favoriteCount,
    required this.pinnedCount,
    required this.archivedCount,
    required this.categoryCount,
    required this.totalWordCount,
  });

  final int totalNotes;
  final int favoriteCount;
  final int pinnedCount;
  final int archivedCount;
  final Map<NoteCategory, int> categoryCount;
  final int totalWordCount;

  /// 平均字数
  int get averageWordCount {
    if (totalNotes == 0) return 0;
    return (totalWordCount / totalNotes).round();
  }
}
