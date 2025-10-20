import 'package:intl/intl.dart';

/// 中国常用日期格式化工具
class ChineseDateFormatter {
  ChineseDateFormatter._();

  /// 完整日期时间: 2025年01月15日 14:30
  static final dateTime = DateFormat('yyyy年MM月dd日 HH:mm');

  /// 日期: 2025年01月15日
  static final date = DateFormat('yyyy年MM月dd日');

  /// 月日: 01月15日
  static final monthDay = DateFormat('MM月dd日');

  /// 时间: 14:30
  static final time = DateFormat('HH:mm');

  /// 年月: 2025年01月
  static final yearMonth = DateFormat('yyyy年MM月');

  /// 完整日期时间带星期: 2025年01月15日 星期三 14:30
  static final dateTimeWithWeekday = DateFormat('yyyy年MM月dd日 EEEE HH:mm', 'zh_CN');

  /// 月日带星期: 01月15日 星期三
  static final monthDayWithWeekday = DateFormat('MM月dd日 EEEE', 'zh_CN');

  /// 相对时间: 2分钟前、昨天、上周等
  static String relative(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return '刚刚';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays == 1) {
      return '昨天';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks周前';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months个月前';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years年前';
    }
  }
}


