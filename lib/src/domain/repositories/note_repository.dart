import 'package:todolist/src/domain/entities/note.dart';

/// 笔记仓储接口
abstract class NoteRepository {
  /// 获取所有笔记
  Future<List<Note>> getAll();

  /// 监听所有笔记变化
  Stream<List<Note>> watchAll();

  /// 根据ID获取笔记
  Future<Note?> getById(String id);

  /// 监听单个笔记变化
  Stream<Note?> watchById(String id);

  /// 保存笔记
  Future<void> save(Note note);

  /// 批量保存笔记
  Future<void> saveAll(Iterable<Note> notes);

  /// 删除笔记
  Future<void> delete(String id);

  /// 批量删除笔记
  Future<void> deleteAll(Iterable<String> ids);

  /// 清空所有笔记
  Future<void> clear();

  /// 根据分类获取笔记
  Future<List<Note>> getByCategory(NoteCategory category);

  /// 根据标签获取笔记
  Future<List<Note>> getByTag(String tag);

  /// 获取收藏的笔记
  Future<List<Note>> getFavorites();

  /// 获取置顶的笔记
  Future<List<Note>> getPinned();

  /// 获取归档的笔记
  Future<List<Note>> getArchived();

  /// 根据文件夹路径获取笔记
  Future<List<Note>> getByFolder(String? folderPath);

  /// 搜索笔记(标题和内容)
  Future<List<Note>> search(String query);

  /// 获取最近查看的笔记
  Future<List<Note>> getRecentlyViewed({int limit = 10});

  /// 获取最近更新的笔记
  Future<List<Note>> getRecentlyUpdated({int limit = 10});
}
