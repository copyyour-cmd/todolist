import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../infrastructure/hive/type_ids.dart';

part 'note.freezed.dart';
part 'note.g.dart';

/// 笔记分类
@HiveType(typeId: HiveTypeIds.note)
enum NoteCategory {
  @HiveField(0)
  general, // 通用
  @HiveField(1)
  work, // 工作
  @HiveField(2)
  personal, // 个人
  @HiveField(3)
  study, // 学习
  @HiveField(4)
  project, // 项目
  @HiveField(5)
  meeting, // 会议
  @HiveField(6)
  journal, // 日记
  @HiveField(7)
  reference, // 参考资料
}

/// 笔记实体 - 使用Freezed实现不可变性
@HiveType(typeId: HiveTypeIds.noteAdapter, adapterName: 'NoteAdapter')
@freezed
class Note with _$Note {
  const factory Note({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String content, // Markdown格式内容
    @HiveField(16) required DateTime createdAt,
    @HiveField(17) required DateTime updatedAt,
    @HiveField(3) @Default(NoteCategory.general) NoteCategory category,
    @HiveField(4) @Default(<String>[]) List<String> tags,
    @HiveField(5) @Default(false) bool isPinned, // 是否置顶
    @HiveField(6) @Default(false) bool isFavorite, // 是否收藏
    @HiveField(7) @Default(false) bool isArchived, // 是否归档
    @HiveField(8) String? folderPath, // 文件夹路径(支持层级)
    @HiveField(9) @Default(<String>[]) List<String> linkedTaskIds, // 关联的任务ID
    @HiveField(10) @Default(<String>[]) List<String> linkedNoteIds, // 关联的笔记ID
    @HiveField(11) @Default(<String>[]) List<String> imageUrls, // 图片URL列表
    @HiveField(12) @Default(<String>[]) List<String> attachmentUrls, // 附件URL列表
    @HiveField(13) String? coverImageUrl, // 封面图片
    @HiveField(14) int? wordCount, // 字数统计
    @HiveField(15) int? readingTimeMinutes, // 预计阅读时间(分钟)
    @HiveField(18) DateTime? lastViewedAt, // 最后查看时间
    @HiveField(19) @Default(0) int viewCount, // 查看次数
    @HiveField(20) @Default(0) int version, // 版本号
    @HiveField(21) String? ocrText, // OCR识别的图片文字(用于搜索)
  }) = _Note;

  const Note._();

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  /// 获取分类显示名称
  String getCategoryName() {
    switch (category) {
      case NoteCategory.general:
        return '通用';
      case NoteCategory.work:
        return '工作';
      case NoteCategory.personal:
        return '个人';
      case NoteCategory.study:
        return '学习';
      case NoteCategory.project:
        return '项目';
      case NoteCategory.meeting:
        return '会议';
      case NoteCategory.journal:
        return '日记';
      case NoteCategory.reference:
        return '参考资料';
    }
  }

  /// 获取分类图标
  String getCategoryIcon() {
    switch (category) {
      case NoteCategory.general:
        return '📝';
      case NoteCategory.work:
        return '💼';
      case NoteCategory.personal:
        return '👤';
      case NoteCategory.study:
        return '📚';
      case NoteCategory.project:
        return '📊';
      case NoteCategory.meeting:
        return '🤝';
      case NoteCategory.journal:
        return '📔';
      case NoteCategory.reference:
        return '📖';
    }
  }

  /// 是否有关联内容
  bool get hasLinks => linkedTaskIds.isNotEmpty || linkedNoteIds.isNotEmpty;

  /// 是否有图片
  bool get hasImages => imageUrls.isNotEmpty;

  /// 是否有附件
  bool get hasAttachments => attachmentUrls.isNotEmpty;

  /// 获取简短预览文本(去除Markdown标记)
  String getPreviewText({int maxLength = 100}) {
    // 简单移除Markdown标记
    final preview = content
        .replaceAll(RegExp(r'#{1,6}\s'), '') // 移除标题标记
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1') // 移除粗体
        .replaceAll(RegExp(r'\*(.+?)\*'), r'$1') // 移除斜体
        .replaceAll(RegExp(r'`(.+?)`'), r'$1') // 移除行内代码
        .replaceAll(RegExp(r'\[(.+?)\]\(.+?\)'), r'$1') // 移除链接
        .replaceAll(RegExp(r'!\[.*?\]\(.+?\)'), '') // 移除图片
        .replaceAll(RegExp('```[\\s\\S]*?```'), '[代码块]') // 移除代码块
        .replaceAll(RegExp(r'\n+'), ' ') // 替换换行为空格
        .trim();

    if (preview.length > maxLength) {
      return '${preview.substring(0, maxLength)}...';
    }
    return preview;
  }

  /// 计算字数和阅读时间
  Note updateStatistics() {
    final wordCount = content.length;
    final readingTimeMinutes = (wordCount / 400).ceil(); // 假设每分钟阅读400字

    return copyWith(
      wordCount: wordCount,
      readingTimeMinutes: readingTimeMinutes,
      updatedAt: DateTime.now(),
    );
  }

  /// 增加查看次数
  Note incrementViewCount() {
    return copyWith(
      viewCount: viewCount + 1,
      lastViewedAt: DateTime.now(),
    );
  }
}
