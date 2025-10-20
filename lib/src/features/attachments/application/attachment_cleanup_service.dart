import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';

/// 附件清理结果
class CleanupResult {
  const CleanupResult({
    required this.scannedFiles,
    required this.orphanedFiles,
    required this.deletedFiles,
    required this.failedFiles,
    required this.freedSpaceBytes,
  });

  final int scannedFiles; // 扫描的文件数
  final int orphanedFiles; // 孤立文件数
  final int deletedFiles; // 已删除文件数
  final int failedFiles; // 删除失败文件数
  final int freedSpaceBytes; // 释放的空间(字节)

  String get freedSpaceFormatted {
    if (freedSpaceBytes < 1024) return '$freedSpaceBytes B';
    if (freedSpaceBytes < 1024 * 1024) {
      return '${(freedSpaceBytes / 1024).toStringAsFixed(2)} KB';
    }
    if (freedSpaceBytes < 1024 * 1024 * 1024) {
      return '${(freedSpaceBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(freedSpaceBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  String toString() {
    return 'CleanupResult('
        'scanned: $scannedFiles, '
        'orphaned: $orphanedFiles, '
        'deleted: $deletedFiles, '
        'failed: $failedFiles, '
        'freed: $freedSpaceFormatted'
        ')';
  }
}

/// 附件清理服务
/// 负责扫描和清理孤立的附件文件
class AttachmentCleanupService {
  AttachmentCleanupService({
    required NoteRepository noteRepository,
    required TaskRepository taskRepository,
    required AppLogger logger,
  })  : _noteRepository = noteRepository,
        _taskRepository = taskRepository,
        _logger = logger;

  final NoteRepository _noteRepository;
  final TaskRepository _taskRepository;
  final AppLogger _logger;

  /// 获取附件目录路径
  Future<String> get _attachmentsDir async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/attachments';
  }

  /// 扫描并清理所有孤立文件
  Future<CleanupResult> cleanupOrphanedFiles({
    bool dryRun = false, // 如果为true，只扫描不删除
  }) async {
    _logger.info('Starting attachment cleanup', {'dryRun': dryRun});

    final startTime = DateTime.now();

    // 1. 收集所有被使用的文件路径
    final usedFiles = await _collectUsedFiles();
    _logger.info('Used files collected', {'count': usedFiles.length});

    // 2. 扫描附件目录
    final dir = Directory(await _attachmentsDir);
    if (!await dir.exists()) {
      _logger.info('Attachments directory does not exist');
      return const CleanupResult(
        scannedFiles: 0,
        orphanedFiles: 0,
        deletedFiles: 0,
        failedFiles: 0,
        freedSpaceBytes: 0,
      );
    }

    // 3. 查找孤立文件
    final orphanedFiles = <File>[];
    var scannedCount = 0;

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        scannedCount++;
        if (!usedFiles.contains(entity.path)) {
          orphanedFiles.add(entity);
        }
      }
    }

    _logger.info('Orphaned files found', {
      'scanned': scannedCount,
      'orphaned': orphanedFiles.length,
    });

    // 4. 删除孤立文件（如果不是dry run）
    var deletedCount = 0;
    var failedCount = 0;
    var freedSpace = 0;

    if (!dryRun) {
      for (final file in orphanedFiles) {
        try {
          final fileSize = await file.length();
          await file.delete();
          deletedCount++;
          freedSpace += fileSize;
          _logger.info('Orphaned file deleted', {'path': file.path});
        } catch (e, stackTrace) {
          failedCount++;
          _logger.error('Failed to delete orphaned file: ${file.path}', e, stackTrace);
        }
      }
    }

    final duration = DateTime.now().difference(startTime);
    final result = CleanupResult(
      scannedFiles: scannedCount,
      orphanedFiles: orphanedFiles.length,
      deletedFiles: deletedCount,
      failedFiles: failedCount,
      freedSpaceBytes: freedSpace,
    );

    _logger.info('Attachment cleanup completed', {
      'duration': '${duration.inMilliseconds}ms',
      'result': result.toString(),
    });

    return result;
  }

  /// 收集所有被使用的文件路径
  Future<Set<String>> _collectUsedFiles() async {
    final usedFiles = <String>{};

    // 从笔记中收集
    try {
      final notes = await _noteRepository.getAll();
      for (final note in notes) {
        usedFiles.addAll(note.imageUrls);
        usedFiles.addAll(note.attachmentUrls);
        if (note.coverImageUrl != null) {
          usedFiles.add(note.coverImageUrl!);
        }
      }
      _logger.info('Files collected from notes', {
        'noteCount': notes.length,
        'fileCount': usedFiles.length,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to collect files from notes', e, stackTrace);
    }

    // 从任务中收集
    try {
      final tasks = await _taskRepository.getAll();
      for (final task in tasks) {
        // 如果Task实体有附件字段，在这里添加
        // usedFiles.addAll(task.attachmentUrls);
      }
      _logger.info('Files collected from tasks', {
        'taskCount': tasks.length,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to collect files from tasks', e, stackTrace);
    }

    return usedFiles;
  }

  /// 获取附件目录的存储信息
  Future<StorageInfo> getStorageInfo() async {
    final dir = Directory(await _attachmentsDir);
    if (!await dir.exists()) {
      return const StorageInfo(
        totalFiles: 0,
        totalSizeBytes: 0,
        imageFiles: 0,
        audioFiles: 0,
        documentFiles: 0,
      );
    }

    var totalFiles = 0;
    var totalSize = 0;
    var imageFiles = 0;
    var audioFiles = 0;
    var documentFiles = 0;

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        totalFiles++;
        try {
          totalSize += await entity.length();

          final extension = entity.path.split('.').last.toLowerCase();
          if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
            imageFiles++;
          } else if (['m4a', 'mp3', 'wav', 'aac'].contains(extension)) {
            audioFiles++;
          } else if (['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx']
              .contains(extension)) {
            documentFiles++;
          }
        } catch (e, stackTrace) {
          _logger.error('Failed to get file info: ${entity.path}', e, stackTrace);
        }
      }
    }

    return StorageInfo(
      totalFiles: totalFiles,
      totalSizeBytes: totalSize,
      imageFiles: imageFiles,
      audioFiles: audioFiles,
      documentFiles: documentFiles,
    );
  }

  /// 清理指定笔记的附件（当笔记被删除时）
  Future<void> cleanupNoteAttachments(
    List<String> imageUrls,
    List<String> attachmentUrls,
    String? coverImageUrl,
  ) async {
    var deletedCount = 0;
    var failedCount = 0;

    // 清理图片
    for (final imagePath in imageUrls) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
        }
      } catch (e, stackTrace) {
        failedCount++;
        _logger.error('Failed to delete image: $imagePath', e, stackTrace);
      }
    }

    // 清理附件
    for (final attachmentPath in attachmentUrls) {
      try {
        final file = File(attachmentPath);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
        }
      } catch (e, stackTrace) {
        failedCount++;
        _logger.error('Failed to delete attachment: $attachmentPath', e, stackTrace);
      }
    }

    // 清理封面图片
    if (coverImageUrl != null) {
      try {
        final file = File(coverImageUrl);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
        }
      } catch (e, stackTrace) {
        failedCount++;
        _logger.error('Failed to delete cover image: $coverImageUrl', e, stackTrace);
      }
    }

    _logger.info('Note attachments cleaned up', {
      'deleted': deletedCount,
      'failed': failedCount,
    });
  }
}

/// 存储信息
class StorageInfo {
  const StorageInfo({
    required this.totalFiles,
    required this.totalSizeBytes,
    required this.imageFiles,
    required this.audioFiles,
    required this.documentFiles,
  });

  final int totalFiles;
  final int totalSizeBytes;
  final int imageFiles;
  final int audioFiles;
  final int documentFiles;

  String get totalSizeFormatted {
    if (totalSizeBytes < 1024) return '$totalSizeBytes B';
    if (totalSizeBytes < 1024 * 1024) {
      return '${(totalSizeBytes / 1024).toStringAsFixed(2)} KB';
    }
    if (totalSizeBytes < 1024 * 1024 * 1024) {
      return '${(totalSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(totalSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  String toString() {
    return 'StorageInfo('
        'total: $totalFiles files ($totalSizeFormatted), '
        'images: $imageFiles, '
        'audio: $audioFiles, '
        'documents: $documentFiles'
        ')';
  }
}
