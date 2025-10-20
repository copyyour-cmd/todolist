import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

/// 笔记创建输入
class NoteCreationInput {
  NoteCreationInput({
    required this.title,
    required this.content,
    this.category = NoteCategory.general,
    List<String>? tags,
    this.folderPath,
    List<String>? linkedTaskIds,
    List<String>? linkedNoteIds,
    List<String>? imageUrls,
    List<String>? attachmentUrls,
    this.coverImageUrl,
  })  : tags = tags ?? <String>[],
        linkedTaskIds = linkedTaskIds ?? <String>[],
        linkedNoteIds = linkedNoteIds ?? <String>[],
        imageUrls = imageUrls ?? <String>[],
        attachmentUrls = attachmentUrls ?? <String>[];

  final String title;
  final String content;
  final NoteCategory category;
  final List<String> tags;
  final String? folderPath;
  final List<String> linkedTaskIds;
  final List<String> linkedNoteIds;
  final List<String> imageUrls;
  final List<String> attachmentUrls;
  final String? coverImageUrl;
}

/// 笔记更新输入
class NoteUpdateInput {
  NoteUpdateInput({
    required this.title,
    required this.content,
    this.category,
    this.tags,
    this.folderPath,
    this.linkedTaskIds,
    this.linkedNoteIds,
    this.imageUrls,
    this.attachmentUrls,
    this.coverImageUrl,
  });

  final String title;
  final String content;
  final NoteCategory? category;
  final List<String>? tags;
  final String? folderPath;
  final List<String>? linkedTaskIds;
  final List<String>? linkedNoteIds;
  final List<String>? imageUrls;
  final List<String>? attachmentUrls;
  final String? coverImageUrl;
}

/// 笔记服务
class NoteService {
  NoteService({
    required NoteRepository noteRepository,
    required Clock clock,
    required IdGenerator idGenerator,
    required AppLogger logger,
  })  : _noteRepository = noteRepository,
        _clock = clock,
        _idGenerator = idGenerator,
        _logger = logger;

  final NoteRepository _noteRepository;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final AppLogger _logger;

  /// 创建笔记
  Future<Note> createNote(NoteCreationInput input) async {
    final now = _clock.now();

    var note = Note(
      id: _idGenerator.generate(),
      title: input.title.trim(),
      content: input.content,
      category: input.category,
      tags: input.tags,
      folderPath: input.folderPath,
      linkedTaskIds: input.linkedTaskIds,
      linkedNoteIds: input.linkedNoteIds,
      imageUrls: input.imageUrls,
      attachmentUrls: input.attachmentUrls,
      coverImageUrl: input.coverImageUrl,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );

    // 自动计算统计信息
    note = note.updateStatistics();

    await _noteRepository.save(note);
    _logger.info('Note created', {'noteId': note.id, 'title': note.title});
    return note;
  }

  /// 更新笔记
  Future<Note> updateNote(Note existing, NoteUpdateInput input) async {
    var updated = existing.copyWith(
      title: input.title.trim(),
      content: input.content,
      category: input.category ?? existing.category,
      tags: input.tags ?? existing.tags,
      folderPath: input.folderPath ?? existing.folderPath,
      linkedTaskIds: input.linkedTaskIds ?? existing.linkedTaskIds,
      linkedNoteIds: input.linkedNoteIds ?? existing.linkedNoteIds,
      imageUrls: input.imageUrls ?? existing.imageUrls,
      attachmentUrls: input.attachmentUrls ?? existing.attachmentUrls,
      coverImageUrl: input.coverImageUrl ?? existing.coverImageUrl,
      version: existing.version + 1,
    );

    // 重新计算统计信息
    updated = updated.updateStatistics();

    await _noteRepository.save(updated);
    _logger.info('Note updated', {'noteId': updated.id, 'title': updated.title});
    return updated;
  }

  /// 删除笔记（包括清理所有附件）
  Future<void> deleteNote(String noteId) async {
    // 获取笔记信息
    final note = await _noteRepository.getById(noteId);
    if (note == null) {
      _logger.warning('Note not found for deletion', noteId);
      return;
    }

    // 清理所有附件
    await _cleanupAttachments(note);

    // 删除笔记记录
    await _noteRepository.delete(noteId);
    _logger.info('Note and attachments deleted', {
      'noteId': noteId,
      'imageCount': note.imageUrls.length,
      'attachmentCount': note.attachmentUrls.length,
    });
  }

  /// 清理笔记的所有附件文件
  Future<void> _cleanupAttachments(Note note) async {
    var deletedCount = 0;
    var failedCount = 0;

    // 清理图片
    for (final imagePath in note.imageUrls) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
          _logger.info('Image deleted', {'path': imagePath});
        }
      } catch (e, stackTrace) {
        failedCount++;
        _logger.error('Failed to delete image: $imagePath', e, stackTrace);
      }
    }

    // 清理附件
    for (final attachmentPath in note.attachmentUrls) {
      try {
        final file = File(attachmentPath);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
          _logger.info('Attachment deleted', {'path': attachmentPath});
        }
      } catch (e, stackTrace) {
        failedCount++;
        _logger.error('Failed to delete attachment: $attachmentPath', e, stackTrace);
      }
    }

    // 清理封面图片
    if (note.coverImageUrl != null) {
      try {
        final file = File(note.coverImageUrl!);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
          _logger.info('Cover image deleted', {'path': note.coverImageUrl!});
        }
      } catch (e, stackTrace) {
        failedCount++;
        _logger.error('Failed to delete cover image: ${note.coverImageUrl}', e, stackTrace);
      }
    }

    if (deletedCount > 0 || failedCount > 0) {
      _logger.info('Attachments cleanup completed', {
        'noteId': note.id,
        'deleted': deletedCount,
        'failed': failedCount,
      });
    }
  }

  /// 批量删除笔记（包括清理所有附件）
  Future<void> deleteNotes(List<String> noteIds) async {
    var deletedNotesCount = 0;
    var deletedAttachmentsCount = 0;

    for (final noteId in noteIds) {
      final note = await _noteRepository.getById(noteId);
      if (note != null) {
        final attachmentCount =
            note.imageUrls.length + note.attachmentUrls.length;
        if (note.coverImageUrl != null) {
          deletedAttachmentsCount++;
        }

        await _cleanupAttachments(note);
        deletedAttachmentsCount += attachmentCount;
        deletedNotesCount++;
      }
    }

    await _noteRepository.deleteAll(noteIds);
    _logger.info('Batch notes deleted', {
      'notesCount': deletedNotesCount,
      'attachmentsCount': deletedAttachmentsCount,
    });
  }

  /// 切换收藏状态
  Future<Note> toggleFavorite(Note note) async {
    final updated = note.copyWith(
      isFavorite: !note.isFavorite,
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Note favorite toggled', {
      'noteId': note.id,
      'isFavorite': updated.isFavorite,
    });
    return updated;
  }

  /// 切换置顶状态
  Future<Note> togglePin(Note note) async {
    final updated = note.copyWith(
      isPinned: !note.isPinned,
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Note pin toggled', {
      'noteId': note.id,
      'isPinned': updated.isPinned,
    });
    return updated;
  }

  /// 归档笔记
  Future<Note> archiveNote(Note note) async {
    final updated = note.copyWith(
      isArchived: true,
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Note archived', note.id);
    return updated;
  }

  /// 取消归档
  Future<Note> unarchiveNote(Note note) async {
    final updated = note.copyWith(
      isArchived: false,
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Note unarchived', note.id);
    return updated;
  }

  /// 记录查看
  Future<Note> recordView(Note note) async {
    final updated = note.incrementViewCount();
    await _noteRepository.save(updated);
    return updated;
  }

  /// 添加标签
  Future<Note> addTag(Note note, String tag) async {
    if (note.tags.contains(tag)) {
      return note;
    }

    final updated = note.copyWith(
      tags: [...note.tags, tag],
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Tag added to note', {'noteId': note.id, 'tag': tag});
    return updated;
  }

  /// 移除标签
  Future<Note> removeTag(Note note, String tag) async {
    if (!note.tags.contains(tag)) {
      return note;
    }

    final updated = note.copyWith(
      tags: note.tags.where((t) => t != tag).toList(),
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Tag removed from note', {'noteId': note.id, 'tag': tag});
    return updated;
  }

  /// 添加任务链接
  Future<Note> linkTask(Note note, String taskId) async {
    if (note.linkedTaskIds.contains(taskId)) {
      return note;
    }

    final updated = note.copyWith(
      linkedTaskIds: [...note.linkedTaskIds, taskId],
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Task linked to note', {'noteId': note.id, 'taskId': taskId});
    return updated;
  }

  /// 移除任务链接
  Future<Note> unlinkTask(Note note, String taskId) async {
    if (!note.linkedTaskIds.contains(taskId)) {
      return note;
    }

    final updated = note.copyWith(
      linkedTaskIds: note.linkedTaskIds.where((id) => id != taskId).toList(),
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Task unlinked from note', {
      'noteId': note.id,
      'taskId': taskId,
    });
    return updated;
  }

  /// 添加笔记链接
  Future<Note> linkNote(Note note, String linkedNoteId) async {
    if (note.linkedNoteIds.contains(linkedNoteId)) {
      return note;
    }

    final updated = note.copyWith(
      linkedNoteIds: [...note.linkedNoteIds, linkedNoteId],
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Note linked', {'noteId': note.id, 'linkedNoteId': linkedNoteId});
    return updated;
  }

  /// 移除笔记链接
  Future<Note> unlinkNote(Note note, String linkedNoteId) async {
    if (!note.linkedNoteIds.contains(linkedNoteId)) {
      return note;
    }

    final updated = note.copyWith(
      linkedNoteIds: note.linkedNoteIds.where((id) => id != linkedNoteId).toList(),
      version: note.version + 1,
    );
    await _noteRepository.save(updated);
    _logger.info('Note unlinked', {
      'noteId': note.id,
      'linkedNoteId': linkedNoteId,
    });
    return updated;
  }

  /// 复制笔记
  Future<Note> duplicateNote(Note original) async {
    final now = _clock.now();

    var duplicate = Note(
      id: _idGenerator.generate(),
      title: '${original.title} (副本)',
      content: original.content,
      category: original.category,
      tags: [...original.tags],
      folderPath: original.folderPath,
      linkedTaskIds: [...original.linkedTaskIds],
      linkedNoteIds: [...original.linkedNoteIds],
      imageUrls: [...original.imageUrls],
      attachmentUrls: [...original.attachmentUrls],
      coverImageUrl: original.coverImageUrl,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );

    duplicate = duplicate.updateStatistics();

    await _noteRepository.save(duplicate);
    _logger.info('Note duplicated', {
      'originalId': original.id,
      'duplicateId': duplicate.id,
    });
    return duplicate;
  }
}

final noteServiceProvider = Provider<NoteService>((ref) {
  return NoteService(
    noteRepository: ref.watch(noteRepositoryProvider),
    clock: ref.watch(clockProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
