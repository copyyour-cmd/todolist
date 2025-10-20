import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/entities/task.dart';

/// 任务自然语言解析结果
class ParsedTaskInfo {
  ParsedTaskInfo({
    required this.title,
    this.dueAt,
    this.priority = TaskPriority.none,
    this.estimatedMinutes,
    this.notes,
  });

  final String title;
  final DateTime? dueAt;
  final TaskPriority priority;
  final int? estimatedMinutes;
  final String? notes;
}

/// 任务自然语言解析器
/// 从语音文本中提取任务信息
class TaskNlpParser {
  TaskNlpParser(this._logger);

  final AppLogger _logger;

  /// 解析语音文本，提取任务信息
  ParsedTaskInfo parseTaskFromText(String text) {
    _logger.info('NLP解析: $text');

    var title = text;
    DateTime? dueAt;
    var priority = TaskPriority.none;
    int? estimatedMinutes;
    String? notes;

    // 1. 提取时间信息
    final timeInfo = _extractTime(text);
    if (timeInfo != null) {
      dueAt = timeInfo.dateTime;
      title = timeInfo.cleanedText;
      _logger.info('提取到时间: $dueAt');
    }

    // 2. 提取优先级
    final priorityInfo = _extractPriority(title);
    if (priorityInfo != null) {
      priority = priorityInfo.priority;
      title = priorityInfo.cleanedText;
      _logger.info('提取到优先级: $priority');
    }

    // 3. 提取时间估算
    final durationInfo = _extractDuration(title);
    if (durationInfo != null) {
      estimatedMinutes = durationInfo.minutes;
      title = durationInfo.cleanedText;
      _logger.info('提取到时长: $estimatedMinutes 分钟');
    }

    // 4. 清理标题
    title = _cleanTitle(title);

    _logger.info('解析结果 - 标题: $title, 时间: $dueAt, 优先级: $priority');

    return ParsedTaskInfo(
      title: title,
      dueAt: dueAt,
      priority: priority,
      estimatedMinutes: estimatedMinutes,
      notes: notes,
    );
  }

  /// 提取时间信息
  _TimeInfo? _extractTime(String text) {
    final now = DateTime.now();
    DateTime? dateTime;
    var cleanedText = text;

    // 今天 + 时间
    if (text.contains('今天') || text.contains('今日')) {
      final timeMatch = RegExp(r'([上下]午)?(\d{1,2})点(\d{1,2}分?)?').firstMatch(text);
      if (timeMatch != null) {
        var hour = int.parse(timeMatch.group(2)!);
        final minute = timeMatch.group(3) != null
            ? int.parse(timeMatch.group(3)!.replaceAll('分', ''))
            : 0;

        if (timeMatch.group(1) == '下午' && hour < 12) hour += 12;
        if (timeMatch.group(1) == '上午' && hour == 12) hour = 0;

        dateTime = DateTime(now.year, now.month, now.day, hour, minute);
        cleanedText = text.replaceAll(RegExp(r'今[天日]([上下]午)?\d{1,2}点(\d{1,2}分?)?'), '');
      } else {
        dateTime = DateTime(now.year, now.month, now.day, 23, 59);
        cleanedText = text.replaceAll(RegExp('今[天日]'), '');
      }
    }
    // 明天
    else if (text.contains('明天') || text.contains('明日')) {
      final tomorrow = now.add(const Duration(days: 1));
      final timeMatch = RegExp(r'([上下]午)?(\d{1,2})点(\d{1,2}分?)?').firstMatch(text);
      if (timeMatch != null) {
        var hour = int.parse(timeMatch.group(2)!);
        final minute = timeMatch.group(3) != null
            ? int.parse(timeMatch.group(3)!.replaceAll('分', ''))
            : 0;

        if (timeMatch.group(1) == '下午' && hour < 12) hour += 12;
        if (timeMatch.group(1) == '上午' && hour == 12) hour = 0;

        dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);
        cleanedText = text.replaceAll(RegExp(r'明[天日]([上下]午)?\d{1,2}点(\d{1,2}分?)?'), '');
      } else {
        dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59);
        cleanedText = text.replaceAll(RegExp('明[天日]'), '');
      }
    }
    // 后天
    else if (text.contains('后天')) {
      final dayAfterTomorrow = now.add(const Duration(days: 2));
      dateTime = DateTime(dayAfterTomorrow.year, dayAfterTomorrow.month, dayAfterTomorrow.day, 23, 59);
      cleanedText = text.replaceAll('后天', '');
    }
    // 本周X
    else if (text.contains(RegExp('本?周[一二三四五六日天]'))) {
      final weekdayMatch = RegExp('本?周([一二三四五六日天])').firstMatch(text);
      if (weekdayMatch != null) {
        final targetWeekday = _parseWeekday(weekdayMatch.group(1)!);
        dateTime = _getNextWeekday(now, targetWeekday);
        cleanedText = text.replaceAll(RegExp('本?周[一二三四五六日天]'), '');
      }
    }
    // 下周X
    else if (text.contains(RegExp('下周[一二三四五六日天]'))) {
      final weekdayMatch = RegExp('下周([一二三四五六日天])').firstMatch(text);
      if (weekdayMatch != null) {
        final targetWeekday = _parseWeekday(weekdayMatch.group(1)!);
        dateTime = _getNextWeekday(now.add(const Duration(days: 7)), targetWeekday);
        cleanedText = text.replaceAll(RegExp('下周[一二三四五六日天]'), '');
      }
    }

    if (dateTime == null) return null;
    return _TimeInfo(dateTime: dateTime, cleanedText: cleanedText.trim());
  }

  /// 提取优先级
  _PriorityInfo? _extractPriority(String text) {
    TaskPriority? priority;
    var cleanedText = text;

    if (text.contains(RegExp('紧急|非常重要|很重要|特别重要'))) {
      priority = TaskPriority.critical;
      cleanedText = text.replaceAll(RegExp('紧急|非常重要|很重要|特别重要'), '');
    } else if (text.contains(RegExp('重要|高优先级'))) {
      priority = TaskPriority.high;
      cleanedText = text.replaceAll(RegExp('重要|高优先级'), '');
    } else if (text.contains(RegExp('一般|中等|普通'))) {
      priority = TaskPriority.medium;
      cleanedText = text.replaceAll(RegExp('一般|中等|普通'), '');
    } else if (text.contains(RegExp('不重要|低优先级'))) {
      priority = TaskPriority.low;
      cleanedText = text.replaceAll(RegExp('不重要|低优先级'), '');
    }

    if (priority == null) return null;
    return _PriorityInfo(priority: priority, cleanedText: cleanedText.trim());
  }

  /// 提取时长估算
  _DurationInfo? _extractDuration(String text) {
    int? minutes;
    var cleanedText = text;

    // X小时
    final hourMatch = RegExp(r'(\d+)(?:个)?小时').firstMatch(text);
    if (hourMatch != null) {
      minutes = int.parse(hourMatch.group(1)!) * 60;
      cleanedText = text.replaceAll(RegExp(r'\d+(?:个)?小时'), '');
    }
    // X分钟
    else {
      final minuteMatch = RegExp(r'(\d+)分钟').firstMatch(text);
      if (minuteMatch != null) {
        minutes = int.parse(minuteMatch.group(1)!);
        cleanedText = text.replaceAll(RegExp(r'\d+分钟'), '');
      }
    }

    if (minutes == null) return null;
    return _DurationInfo(minutes: minutes, cleanedText: cleanedText.trim());
  }

  /// 清理标题（移除多余的空格和标点）
  String _cleanTitle(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[，。、！？\s]+'), '')
        .replaceAll(RegExp(r'[，。、！？\s]+$'), '')
        .trim();
  }

  /// 解析星期
  int _parseWeekday(String weekday) {
    switch (weekday) {
      case '一': return DateTime.monday;
      case '二': return DateTime.tuesday;
      case '三': return DateTime.wednesday;
      case '四': return DateTime.thursday;
      case '五': return DateTime.friday;
      case '六': return DateTime.saturday;
      case '日':
      case '天': return DateTime.sunday;
      default: return DateTime.monday;
    }
  }

  /// 获取下一个指定星期几的日期
  DateTime _getNextWeekday(DateTime from, int targetWeekday) {
    final currentWeekday = from.weekday;
    final daysUntilTarget = (targetWeekday - currentWeekday + 7) % 7;
    final targetDate = from.add(Duration(days: daysUntilTarget == 0 ? 7 : daysUntilTarget));
    return DateTime(targetDate.year, targetDate.month, targetDate.day, 23, 59);
  }
}

class _TimeInfo {
  const _TimeInfo({required this.dateTime, required this.cleanedText});
  final DateTime dateTime;
  final String cleanedText;
}

class _PriorityInfo {
  const _PriorityInfo({required this.priority, required this.cleanedText});
  final TaskPriority priority;
  final String cleanedText;
}

class _DurationInfo {
  const _DurationInfo({required this.minutes, required this.cleanedText});
  final int minutes;
  final String cleanedText;
}
