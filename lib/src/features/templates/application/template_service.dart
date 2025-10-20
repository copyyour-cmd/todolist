import 'package:hive/hive.dart';
import 'package:todolist/src/core/constants/preset_templates.dart';
import 'package:todolist/src/domain/entities/task_template.dart';

/// 任务模板服务
class TemplateService {
  static const String _boxName = 'task_templates';

  Box<TaskTemplate> get _box => Hive.box<TaskTemplate>(_boxName);

  /// 初始化预设模板
  Future<void> initializePresetTemplates() async {
    // 检查是否已经初始化过
    final hasInitialized = _box.get('_initialized') != null;
    if (hasInitialized) {
      return;
    }

    // 添加所有预设模板
    for (final template in PresetTemplates.all) {
      await _box.put(template.id, template);
    }

    // 标记为已初始化
    await _box.put(
      '_initialized',
      TaskTemplate(
        id: '_initialized',
        title: '_initialized',
        category: TemplateCategory.custom,
        isBuiltIn: true,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// 获取所有模板
  List<TaskTemplate> getAllTemplates() {
    return _box.values
        .where((template) => template.id != '_initialized')
        .toList()
      ..sort((a, b) {
        // 先按分类排序
        final categoryCompare = a.category.index.compareTo(b.category.index);
        if (categoryCompare != 0) return categoryCompare;
        // 再按使用次数降序
        final usageCompare = b.usageCount.compareTo(a.usageCount);
        if (usageCompare != 0) return usageCompare;
        // 最后按标题排序
        return a.title.compareTo(b.title);
      });
  }

  /// 按分类获取模板
  List<TaskTemplate> getTemplatesByCategory(TemplateCategory category) {
    return _box.values
        .where((template) =>
            template.category == category && template.id != '_initialized')
        .toList()
      ..sort((a, b) {
        // 按使用次数降序
        final usageCompare = b.usageCount.compareTo(a.usageCount);
        if (usageCompare != 0) return usageCompare;
        // 按标题排序
        return a.title.compareTo(b.title);
      });
  }

  /// 获取常用模板（按使用次数排序）
  List<TaskTemplate> getPopularTemplates({int limit = 10}) {
    final templates = _box.values
        .where((template) => template.id != '_initialized')
        .toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));

    return templates.take(limit).toList();
  }

  /// 搜索模板
  List<TaskTemplate> searchTemplates(String query) {
    if (query.trim().isEmpty) {
      return getAllTemplates();
    }

    final lowerQuery = query.toLowerCase();
    return _box.values
        .where((template) =>
            template.id != '_initialized' &&
            (template.title.toLowerCase().contains(lowerQuery) ||
                (template.description?.toLowerCase().contains(lowerQuery) ??
                    false) ||
                template.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))))
        .toList()
      ..sort((a, b) {
        // 标题匹配优先
        final aTitleMatch = a.title.toLowerCase().contains(lowerQuery);
        final bTitleMatch = b.title.toLowerCase().contains(lowerQuery);
        if (aTitleMatch && !bTitleMatch) return -1;
        if (!aTitleMatch && bTitleMatch) return 1;
        // 再按使用次数排序
        return b.usageCount.compareTo(a.usageCount);
      });
  }

  /// 获取单个模板
  TaskTemplate? getTemplate(String id) {
    return _box.get(id);
  }

  /// 添加自定义模板
  Future<void> addTemplate(TaskTemplate template) async {
    await _box.put(template.id, template);
  }

  /// 更新模板
  Future<void> updateTemplate(TaskTemplate template) async {
    await _box.put(template.id, template);
  }

  /// 删除模板（仅限非内置模板）
  Future<bool> deleteTemplate(String id) async {
    final template = _box.get(id);
    if (template == null || template.isBuiltIn) {
      return false;
    }
    await _box.delete(id);
    return true;
  }

  /// 增加模板使用次数
  Future<void> incrementUsageCount(String id) async {
    final template = _box.get(id);
    if (template != null) {
      final updated = TaskTemplate(
        id: template.id,
        title: template.title,
        description: template.description,
        category: template.category,
        priority: template.priority,
        estimatedMinutes: template.estimatedMinutes,
        tags: template.tags,
        iconCodePoint: template.iconCodePoint,
        isBuiltIn: template.isBuiltIn,
        usageCount: template.usageCount + 1,
        createdAt: template.createdAt,
      );
      await _box.put(id, updated);
    }
  }

  /// 获取分类统计
  Map<TemplateCategory, int> getCategoryStats() {
    final stats = <TemplateCategory, int>{};
    for (final category in TemplateCategory.values) {
      stats[category] = _box.values
          .where((t) => t.category == category && t.id != '_initialized')
          .length;
    }
    return stats;
  }

  /// 重置所有预设模板
  Future<void> resetPresetTemplates() async {
    // 保存自定义模板
    final customTemplates = _box.values
        .where((template) => !template.isBuiltIn && template.id != '_initialized')
        .toList();

    // 清空box
    await _box.clear();

    // 重新添加预设模板
    for (final template in PresetTemplates.all) {
      await _box.put(template.id, template);
    }

    // 恢复自定义模板
    for (final template in customTemplates) {
      await _box.put(template.id, template);
    }

    // 标记为已初始化
    await _box.put(
      '_initialized',
      TaskTemplate(
        id: '_initialized',
        title: '_initialized',
        category: TemplateCategory.custom,
        isBuiltIn: true,
        createdAt: DateTime.now(),
      ),
    );
  }
}
