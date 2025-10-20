import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/features/notes/domain/note_link_parser.dart';

/// 笔记链接关系
class NoteLinkRelation {
  const NoteLinkRelation({
    required this.sourceNoteId,
    required this.targetNoteId,
    required this.targetTitle,
  });

  final String sourceNoteId; // 源笔记ID（包含链接的笔记）
  final String targetNoteId; // 目标笔记ID（被链接的笔记）
  final String targetTitle; // 目标笔记标题

  @override
  String toString() =>
      'NoteLinkRelation(source: $sourceNoteId -> target: $targetNoteId)';
}

/// 笔记链接服务
/// 负责管理笔记间的双向链接关系
class NoteLinkService {
  NoteLinkService({
    required NoteRepository noteRepository,
  }) : _noteRepository = noteRepository;

  final NoteRepository _noteRepository;

  /// 构建标题到ID的映射（用于链接解析）
  Future<Map<String, String>> buildTitleToIdMap() async {
    final notes = await _noteRepository.getAll();
    final map = <String, String>{};

    for (final note in notes) {
      map[note.title] = note.id;
    }

    return map;
  }

  /// 从笔记内容中提取链接关系
  Future<List<NoteLinkRelation>> extractLinks(Note note) async {
    final linkedTitles = NoteLinkParser.extractLinkedTitles(note.content);
    final titleToIdMap = await buildTitleToIdMap();

    final relations = <NoteLinkRelation>[];
    for (final title in linkedTitles) {
      final targetId = titleToIdMap[title];
      if (targetId != null && targetId != note.id) {
        // 找到了对应的笔记，且不是自己
        relations.add(
          NoteLinkRelation(
            sourceNoteId: note.id,
            targetNoteId: targetId,
            targetTitle: title,
          ),
        );
      }
    }

    return relations;
  }

  /// 更新笔记的链接关系
  /// 根据内容中的 [[笔记名]] 自动更新 linkedNoteIds
  Future<Note> updateNoteLinks(Note note) async {
    final relations = await extractLinks(note);
    final linkedNoteIds = relations.map((r) => r.targetNoteId).toList();

    // 如果链接没有变化，直接返回
    if (_areListsEqual(note.linkedNoteIds, linkedNoteIds)) {
      return note;
    }

    // 更新链接列表
    final updated = note.copyWith(linkedNoteIds: linkedNoteIds);
    await _noteRepository.save(updated);

    return updated;
  }

  /// 获取反向链接（哪些笔记链接到了指定笔记）
  Future<List<Note>> getBacklinks(String noteId) async {
    final targetNote = await _noteRepository.getById(noteId);
    if (targetNote == null) return [];

    final allNotes = await _noteRepository.getAll();
    final backlinks = <Note>[];

    for (final note in allNotes) {
      if (note.id == noteId) continue; // 跳过自己

      // 检查是否在 linkedNoteIds 中
      if (note.linkedNoteIds.contains(noteId)) {
        backlinks.add(note);
        continue;
      }

      // 检查内容中是否有 [[标题]] 引用
      if (NoteLinkParser.containsLinkTo(note.content, targetNote.title)) {
        backlinks.add(note);
      }
    }

    return backlinks;
  }

  /// 获取正向链接（指定笔记链接到了哪些笔记）
  Future<List<Note>> getOutboundLinks(String noteId) async {
    final sourceNote = await _noteRepository.getById(noteId);
    if (sourceNote == null) return [];

    final linkedNotes = <Note>[];
    for (final linkedId in sourceNote.linkedNoteIds) {
      final note = await _noteRepository.getById(linkedId);
      if (note != null) {
        linkedNotes.add(note);
      }
    }

    return linkedNotes;
  }

  /// 获取所有链接关系（用于知识图谱）
  Future<List<NoteLinkRelation>> getAllLinkRelations() async {
    final allNotes = await _noteRepository.getAll();
    final relations = <NoteLinkRelation>[];

    for (final note in allNotes) {
      final noteRelations = await extractLinks(note);
      relations.addAll(noteRelations);
    }

    return relations;
  }

  /// 获取笔记的所有连接（正向+反向）
  Future<NoteLinkStats> getLinkStats(String noteId) async {
    final outbound = await getOutboundLinks(noteId);
    final backlinks = await getBacklinks(noteId);

    return NoteLinkStats(
      noteId: noteId,
      outboundLinks: outbound,
      backlinks: backlinks,
      totalConnections: outbound.length + backlinks.length,
    );
  }

  /// 当笔记标题改变时，更新所有引用它的笔记
  Future<void> updateReferencesOnTitleChange(
    String noteId,
    String oldTitle,
    String newTitle,
  ) async {
    final backlinks = await getBacklinks(noteId);

    for (final note in backlinks) {
      // 替换内容中的旧标题链接
      final updatedContent = NoteLinkParser.replaceLinkTitle(
        note.content,
        oldTitle,
        newTitle,
      );

      if (updatedContent != note.content) {
        final updated = note.copyWith(content: updatedContent);
        await _noteRepository.save(updated);
      }
    }
  }

  /// 当笔记被删除时，清理所有引用
  Future<void> cleanupLinksOnDelete(String noteId, String title) async {
    final allNotes = await _noteRepository.getAll();

    for (final note in allNotes) {
      var needsUpdate = false;

      // 从 linkedNoteIds 中移除
      List<String>? updatedLinkedIds;
      if (note.linkedNoteIds.contains(noteId)) {
        updatedLinkedIds =
            note.linkedNoteIds.where((id) => id != noteId).toList();
        needsUpdate = true;
      }

      // 从内容中移除链接（可选：可以选择保留文本或完全移除）
      String? updatedContent;
      if (NoteLinkParser.containsLinkTo(note.content, title)) {
        updatedContent = NoteLinkParser.removeLinksTo(note.content, title);
        needsUpdate = true;
      }

      if (needsUpdate) {
        var updated = note;
        if (updatedLinkedIds != null) {
          updated = updated.copyWith(linkedNoteIds: updatedLinkedIds);
        }
        if (updatedContent != null) {
          updated = updated.copyWith(content: updatedContent);
        }
        await _noteRepository.save(updated);
      }
    }
  }

  /// 搜索可链接的笔记（用于自动完成）
  Future<List<Note>> searchLinkableNotes(
    String query, {
    String? excludeNoteId,
  }) async {
    if (query.isEmpty) return [];

    final allNotes = await _noteRepository.getAll();
    final queryLower = query.toLowerCase();

    return allNotes
        .where((note) {
          if (excludeNoteId != null && note.id == excludeNoteId) {
            return false; // 排除当前笔记
          }
          return note.title.toLowerCase().contains(queryLower);
        })
        .take(10) // 限制结果数量
        .toList();
  }

  /// 比较两个列表是否相等（不考虑顺序）
  bool _areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    final set1 = Set<String>.from(list1);
    final set2 = Set<String>.from(list2);
    return set1.containsAll(set2) && set2.containsAll(set1);
  }
}

/// 笔记链接统计信息
class NoteLinkStats {
  const NoteLinkStats({
    required this.noteId,
    required this.outboundLinks,
    required this.backlinks,
    required this.totalConnections,
  });

  final String noteId;
  final List<Note> outboundLinks; // 正向链接（该笔记链接到的笔记）
  final List<Note> backlinks; // 反向链接（链接到该笔记的笔记）
  final int totalConnections; // 总连接数

  bool get hasLinks => totalConnections > 0;

  @override
  String toString() =>
      'NoteLinkStats(outbound: ${outboundLinks.length}, backlinks: ${backlinks.length})';
}
