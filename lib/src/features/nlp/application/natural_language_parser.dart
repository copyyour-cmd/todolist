import 'package:todolist/src/domain/entities/task.dart';

/// 解析结果
class ParsedTask {
  const ParsedTask({
    required this.title,
    this.dueDate,
    this.priority,
    this.tags,
    this.listName,
  });

  final String title;
  final DateTime? dueDate;
  final TaskPriority? priority;
  final List<String>? tags;
  final String? listName;
}

/// 自然语言解析器
class NaturalLanguageParser {
  /// 将时间表达式中的中文数字转换为阿拉伯数字
  String _convertChineseNumbers(String text) {
    var result = text;

    // 只转换时间相关的中文数字，使用更精确的正则匹配
    // 匹配 "X点"、"X点X分"、"X点半" 等时间表达式
    final timePatterns = [
      // 匹配 "零点" 到 "十二点"
      RegExp('(零|一|二|三|四|五|六|七|八|九|十|十一|十二)点'),
      // 匹配 "X分" (在点之后)
      RegExp('点(零|一|二|三|四|五|六|七|八|九|十|十一|十二|十三|十四|十五|十六|十七|十八|十九|二十|三十|四十|五十|五十九)分'),
    ];

    // 中文数字映射
    final numberMap = {
      '零': '0', '一': '1', '二': '2', '三': '3', '四': '4',
      '五': '5', '六': '6', '七': '7', '八': '8', '九': '9',
      '十': '10', '十一': '11', '十二': '12', '十三': '13', '十四': '14',
      '十五': '15', '十六': '16', '十七': '17', '十八': '18', '十九': '19',
      '二十': '20', '三十': '30', '四十': '40', '五十': '50', '五十九': '59',
    };

    // 替换时间中的中文数字
    for (final pattern in timePatterns) {
      result = result.replaceAllMapped(pattern, (match) {
        var matched = match.group(0)!;
        numberMap.forEach((chinese, arabic) {
          matched = matched.replaceAll(chinese, arabic);
        });
        return matched;
      });
    }

    return result;
  }

  /// 解析输入文本
  ParsedTask parse(String input) {
    print('[NLP解析] 输入: $input');
    var cleanedInput = input.trim();
    if (cleanedInput.isEmpty) {
      return ParsedTask(title: '');
    }

    // 转换中文数字为阿拉伯数字
    cleanedInput = _convertChineseNumbers(cleanedInput);
    print('[NLP解析] 转换数字后: $cleanedInput');

    DateTime? dueDate;
    TaskPriority? priority;
    var tags = <String>[];
    String? listName;
    var title = cleanedInput;

    // 1. 提取时间
    final timeResult = _extractTime(title);
    if (timeResult.time != null) {
      dueDate = timeResult.time;
      title = timeResult.cleanedText;
      print('[NLP解析] 提取时间: $dueDate');
    }

    // 2. 提取优先级
    final priorityResult = _extractPriority(title);
    if (priorityResult.priority != null) {
      priority = priorityResult.priority;
      title = priorityResult.cleanedText;
    }

    // 3. 提取标签
    final tagResult = _extractTags(title);
    if (tagResult.tags.isNotEmpty) {
      tags = tagResult.tags;
      title = tagResult.cleanedText;
    }

    // 4. 提取清单
    final listResult = _extractList(title);
    if (listResult.listName != null) {
      listName = listResult.listName;
      title = listResult.cleanedText;
    }

    return ParsedTask(
      title: title.trim(),
      dueDate: dueDate,
      priority: priority,
      tags: tags.isEmpty ? null : tags,
      listName: listName,
    );
  }

  /// 提取时间信息
  _TimeExtractionResult _extractTime(String text) {
    final now = DateTime.now();
    DateTime? parsedTime;
    var cleanedText = text;

    // 相对日期模式
    final relativeDatePatterns = {
      '今天': () => DateTime(now.year, now.month, now.day),
      '明天': () => DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      '后天': () => DateTime(now.year, now.month, now.day).add(const Duration(days: 2)),
      '大后天': () => DateTime(now.year, now.month, now.day).add(const Duration(days: 3)),
      '本周': () => DateTime(now.year, now.month, now.day),
      '下周': () => DateTime(now.year, now.month, now.day).add(const Duration(days: 7)),
    };

    // 星期模式
    final weekdayPatterns = {
      '周一|星期一': DateTime.monday,
      '周二|星期二': DateTime.tuesday,
      '周三|星期三': DateTime.wednesday,
      '周四|星期四': DateTime.thursday,
      '周五|星期五': DateTime.friday,
      '周六|星期六': DateTime.saturday,
      '周日|星期日|周天|星期天': DateTime.sunday,
    };

    // 检查相对日期
    for (final entry in relativeDatePatterns.entries) {
      final pattern = RegExp(entry.key);
      if (pattern.hasMatch(text)) {
        parsedTime = entry.value();
        cleanedText = text.replaceFirst(pattern, '').trim();
        break;
      }
    }

    // 检查星期
    if (parsedTime == null) {
      for (final entry in weekdayPatterns.entries) {
        final pattern = RegExp(entry.key);
        final match = pattern.firstMatch(text);
        if (match != null) {
          final targetWeekday = entry.value;
          final isNextWeek = text.contains('下周') || text.contains('下星期');
          parsedTime = _getNextWeekday(now, targetWeekday, nextWeek: isNextWeek);
          cleanedText = text.replaceFirst(pattern, '').replaceAll(RegExp('下周|下星期'), '').trim();
          break;
        }
      }
    }

    // 提取具体时间（小时）
    if (parsedTime != null) {
      final timePattern = RegExp(r'(上午|早上|中午|下午|晚上|傍晚)?(\d{1,2})[点:](半|(\d{1,2})分?)?');
      final timeMatch = timePattern.firstMatch(cleanedText);
      print('[NLP解析] 提取具体时间 - cleanedText: $cleanedText');
      print('[NLP解析] 提取具体时间 - timeMatch: ${timeMatch?.group(0)}');

      if (timeMatch != null) {
        final period = timeMatch.group(1);
        var hour = int.parse(timeMatch.group(2)!);
        final minuteStr = timeMatch.group(3);
        var minute = 0;
        print('[NLP解析] 时间段: $period, 小时: $hour, 分钟字符串: $minuteStr');

        if (minuteStr != null) {
          if (minuteStr == '半') {
            minute = 30;
          } else {
            minute = int.parse(minuteStr.replaceAll(RegExp('[分:]'), ''));
          }
        }
        print('[NLP解析] 最终分钟数: $minute');

        // 根据时段调整小时
        if (period != null) {
          if ((period == '下午' || period == '傍晚') && hour < 12) {
            hour += 12;
          } else if (period == '晚上' && hour < 12) {
            hour += 12;
          } else if (period == '中午' && hour < 12) {
            hour = 12;
          }
        }

        parsedTime = DateTime(
          parsedTime.year,
          parsedTime.month,
          parsedTime.day,
          hour,
          minute,
        );

        cleanedText = cleanedText.replaceFirst(timePattern, '').trim();
      } else {
        // 如果没有指定具体时间，设置为当天 23:59
        parsedTime = DateTime(
          parsedTime.year,
          parsedTime.month,
          parsedTime.day,
          23,
          59,
        );
      }
    }

    // 月日模式 (如: 3月15日)
    if (parsedTime == null) {
      final datePattern = RegExp(r'(\d{1,2})月(\d{1,2})日?');
      final dateMatch = datePattern.firstMatch(text);

      if (dateMatch != null) {
        final month = int.parse(dateMatch.group(1)!);
        final day = int.parse(dateMatch.group(2)!);
        var year = now.year;

        // 如果日期已过，设为明年
        if (month < now.month || (month == now.month && day < now.day)) {
          year++;
        }

        parsedTime = DateTime(year, month, day);
        cleanedText = text.replaceFirst(datePattern, '').trim();
      }
    }

    return _TimeExtractionResult(time: parsedTime, cleanedText: cleanedText);
  }

  /// 获取下一个指定星期几的日期
  DateTime _getNextWeekday(DateTime from, int targetWeekday, {bool nextWeek = false}) {
    var daysToAdd = targetWeekday - from.weekday;
    if (daysToAdd <= 0 || nextWeek) {
      daysToAdd += 7;
    }
    return DateTime(from.year, from.month, from.day).add(Duration(days: daysToAdd));
  }

  /// 提取优先级
  _PriorityExtractionResult _extractPriority(String text) {
    TaskPriority? priority;
    var cleanedText = text;

    final priorityPatterns = {
      '紧急|非常重要|最重要|立即|马上|关键': TaskPriority.critical,
      '重要|高优先级': TaskPriority.high,
      '中等|一般': TaskPriority.medium,
      '低优先级|不急|可选': TaskPriority.low,
    };

    for (final entry in priorityPatterns.entries) {
      final pattern = RegExp(entry.key);
      if (pattern.hasMatch(text)) {
        priority = entry.value;
        cleanedText = text.replaceFirst(pattern, '').trim();
        break;
      }
    }

    return _PriorityExtractionResult(
      priority: priority,
      cleanedText: cleanedText,
    );
  }

  /// 提取标签
  _TagExtractionResult _extractTags(String text) {
    final tags = <String>[];
    var cleanedText = text;

    // 匹配 #标签 模式
    final tagPattern = RegExp(r'#([\u4e00-\u9fa5a-zA-Z0-9_]+)');
    final matches = tagPattern.allMatches(text);

    for (final match in matches) {
      final tag = match.group(1);
      if (tag != null && tag.isNotEmpty) {
        tags.add(tag);
      }
    }

    if (tags.isNotEmpty) {
      cleanedText = text.replaceAll(tagPattern, '').trim();
    }

    return _TagExtractionResult(tags: tags, cleanedText: cleanedText);
  }

  /// 提取清单
  _ListExtractionResult _extractList(String text) {
    String? listName;
    var cleanedText = text;

    // 匹配 @清单名 模式
    final listPattern = RegExp(r'@([\u4e00-\u9fa5a-zA-Z0-9_]+)');
    final match = listPattern.firstMatch(text);

    if (match != null) {
      listName = match.group(1);
      cleanedText = text.replaceFirst(listPattern, '').trim();
    }

    return _ListExtractionResult(
      listName: listName,
      cleanedText: cleanedText,
    );
  }
}

// 辅助类
class _TimeExtractionResult {
  const _TimeExtractionResult({
    required this.time,
    required this.cleanedText,
  });

  final DateTime? time;
  final String cleanedText;
}

class _PriorityExtractionResult {
  const _PriorityExtractionResult({
    required this.priority,
    required this.cleanedText,
  });

  final TaskPriority? priority;
  final String cleanedText;
}

class _TagExtractionResult {
  const _TagExtractionResult({
    required this.tags,
    required this.cleanedText,
  });

  final List<String> tags;
  final String cleanedText;
}

class _ListExtractionResult {
  const _ListExtractionResult({
    required this.listName,
    required this.cleanedText,
  });

  final String? listName;
  final String cleanedText;
}
