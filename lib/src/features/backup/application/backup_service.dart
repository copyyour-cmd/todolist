import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/repositories/note_repository.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/features/backup/domain/backup_data.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';
import 'package:intl/intl.dart';

/// 备份服务
class BackupService {
  BackupService({
    required TaskRepository taskRepository,
    required NoteRepository noteRepository,
    required AppLogger logger,
  })  : _taskRepository = taskRepository,
        _noteRepository = noteRepository,
        _logger = logger;

  final TaskRepository _taskRepository;
  final NoteRepository _noteRepository;
  final AppLogger _logger;

  static const String _backupVersion = '1.0';
  static const String _backupFileExtension = '.json';

  /// 创建备份
  Future<File> createBackup({String? customPath}) async {
    try {
      _logger.info('开始创建备份...');

      // 获取所有任务和笔记
      final tasks = await _taskRepository.getAll();
      final notes = await _noteRepository.getAll();

      _logger.info('获取数据完成', {
        'tasksCount': tasks.length,
        'notesCount': notes.length,
      });

      // 创建备份数据
      final backupData = BackupData(
        version: _backupVersion,
        createdAt: DateTime.now(),
        tasks: tasks,
        notes: notes,
      );

      // 转换为JSON
      final jsonData = backupData.toJson();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      // 保存到文件
      final file = await _saveBackupFile(jsonString, customPath);

      _logger.info('备份创建成功', {'path': file.path});
      return file;
    } catch (e, stackTrace) {
      _logger.error('创建备份失败', e, stackTrace);
      rethrow;
    }
  }

  /// 保存备份文件
  Future<File> _saveBackupFile(String content, String? customPath) async {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'todolist_backup_$timestamp$_backupFileExtension';

    final File file;
    if (customPath != null) {
      file = File('$customPath/$fileName');
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${directory.path}/backups');
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      file = File('${backupDir.path}/$fileName');
    }

    await file.writeAsString(content);
    return file;
  }

  /// 从文件还原备份
  Future<void> restoreFromFile(File file, {bool merge = false}) async {
    try {
      _logger.info('开始还原备份', {'path': file.path, 'merge': merge});

      // 读取文件
      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // 解析备份数据
      final backupData = BackupData.fromJson(jsonData);

      _logger.info('解析备份数据完成', {
        'version': backupData.version,
        'tasksCount': backupData.tasks.length,
        'notesCount': backupData.notes.length,
      });

      // 如果不是合并模式,清空现有数据
      if (!merge) {
        await _taskRepository.clear();
        await _noteRepository.clear();
        _logger.info('已清空现有数据');
      }

      // 还原任务
      await _taskRepository.saveAll(backupData.tasks);
      _logger.info('任务还原完成', {'count': backupData.tasks.length});

      // 还原笔记
      await _noteRepository.saveAll(backupData.notes);
      _logger.info('笔记还原完成', {'count': backupData.notes.length});

      _logger.info('备份还原成功');
    } catch (e, stackTrace) {
      _logger.error('还原备份失败', e, stackTrace);
      rethrow;
    }
  }

  /// 从JSON字符串还原备份
  Future<void> restoreFromJson(String jsonString, {bool merge = false}) async {
    try {
      _logger.info('开始从JSON还原备份', {'merge': merge});

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final backupData = BackupData.fromJson(jsonData);

      _logger.info('解析备份数据完成', {
        'version': backupData.version,
        'tasksCount': backupData.tasks.length,
        'notesCount': backupData.notes.length,
      });

      // 如果不是合并模式,清空现有数据
      if (!merge) {
        await _taskRepository.clear();
        await _noteRepository.clear();
        _logger.info('已清空现有数据');
      }

      // 还原任务
      await _taskRepository.saveAll(backupData.tasks);
      _logger.info('任务还原完成', {'count': backupData.tasks.length});

      // 还原笔记
      await _noteRepository.saveAll(backupData.notes);
      _logger.info('笔记还原完成', {'count': backupData.notes.length});

      _logger.info('备份还原成功');
    } catch (e, stackTrace) {
      _logger.error('还原备份失败', e, stackTrace);
      rethrow;
    }
  }

  /// 获取所有备份文件
  Future<List<File>> getBackupFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${directory.path}/backups');

      if (!await backupDir.exists()) {
        return [];
      }

      final files = await backupDir
          .list()
          .where((entity) =>
              entity is File && entity.path.endsWith(_backupFileExtension))
          .cast<File>()
          .toList();

      // 按修改时间倒序排列
      files.sort((a, b) => b
          .lastModifiedSync()
          .compareTo(a.lastModifiedSync()));

      return files;
    } catch (e, stackTrace) {
      _logger.error('获取备份文件列表失败', e, stackTrace);
      return [];
    }
  }

  /// 删除备份文件
  Future<void> deleteBackupFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        _logger.info('备份文件已删除', {'path': file.path});
      }
    } catch (e, stackTrace) {
      _logger.error('删除备份文件失败', e, stackTrace);
      rethrow;
    }
  }

  /// 获取备份文件信息
  Future<BackupFileInfo?> getBackupFileInfo(File file) async {
    try {
      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final backupData = BackupData.fromJson(jsonData);

      final stats = await file.stat();

      return BackupFileInfo(
        file: file,
        fileName: file.path.split('/').last,
        createdAt: backupData.createdAt,
        fileSize: stats.size,
        tasksCount: backupData.tasks.length,
        notesCount: backupData.notes.length,
        version: backupData.version,
      );
    } catch (e, stackTrace) {
      _logger.error('获取备份文件信息失败', e, stackTrace);
      return null;
    }
  }
}

/// 备份文件信息
class BackupFileInfo {
  BackupFileInfo({
    required this.file,
    required this.fileName,
    required this.createdAt,
    required this.fileSize,
    required this.tasksCount,
    required this.notesCount,
    required this.version,
  });

  final File file;
  final String fileName;
  final DateTime createdAt;
  final int fileSize;
  final int tasksCount;
  final int notesCount;
  final String version;

  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    taskRepository: ref.watch(taskRepositoryProvider),
    noteRepository: ref.watch(noteRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
