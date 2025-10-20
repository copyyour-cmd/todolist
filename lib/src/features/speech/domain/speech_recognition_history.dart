import 'package:hive/hive.dart';
import '../../../infrastructure/hive/type_ids.dart';

part 'speech_recognition_history.g.dart';

/// 语音识别历史记录
@HiveType(typeId: 86)
class SpeechRecognitionHistory {
  SpeechRecognitionHistory({
    required this.id,
    required this.text,
    required this.language,
    required this.timestamp,
    this.duration,
    this.mode,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text; // 识别的文本

  @HiveField(2)
  final String language; // 识别语言 (zh_CN, en_US, 等)

  @HiveField(3)
  final DateTime timestamp; // 识别时间

  @HiveField(4)
  final int? duration; // 识别时长(秒)

  @HiveField(5)
  final String? mode; // 识别模式 (online/offline/auto)

  /// 格式化语言显示名称
  String get languageDisplayName {
    switch (language) {
      case 'zh_CN':
        return '中文';
      case 'en_US':
        return '英文';
      case 'ja_JP':
        return '日文';
      case 'ko_KR':
        return '韩文';
      default:
        return language;
    }
  }

  /// 格式化时间显示
  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  String toString() => 'SpeechHistory(text: $text, lang: $language, time: $timestamp)';
}
