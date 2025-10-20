import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/entities/task.dart';

/// 任务自然语言解析结果
class ParsedTaskInfo {
  ParsedTaskInfo({
    required this.title,
    this.dueAt,
    this.remindAt,
    this.priority = TaskPriority.none,
    this.estimatedMinutes,
    this.notes,
    this.location,
    this.participants,
  });

  final String title;
  final DateTime? dueAt;
  final DateTime? remindAt;
  final TaskPriority priority;
  final int? estimatedMinutes;
  final String? notes;
  final String? location;
  final List<String>? participants;
}

/// 增强版NLP解析器 - 智能提取任务核心
class EnhancedTaskNlpParser {
  EnhancedTaskNlpParser(this._logger);

  final AppLogger _logger;

  /// 解析语音文本
  ParsedTaskInfo parseTaskFromText(String text) {
    _logger.info('NLP解析原文: $text');

    var workingText = text;
    DateTime? dueAt;
    DateTime? remindAt;
    var priority = TaskPriority.none;
    int? estimatedMinutes;
    String? location;
    List<String>? participants;

    // 1. 提取时间
    final timeInfo = _extractTime(text);
    if (timeInfo != null) {
      dueAt = timeInfo.dateTime;
      workingText = timeInfo.cleanedText;
      _logger.info('提取时间: ${dueAt.toString()}, 剩余: $workingText');
    }

    // 2. 提取地点
    final locationInfo = _extractLocation(workingText);
    if (locationInfo != null) {
      location = locationInfo.location;
      workingText = locationInfo.cleanedText;
      _logger.info('提取地点: $location, 剩余: $workingText');
    }

    // 3. 提取参与人
    final participantsInfo = _extractParticipants(workingText);
    if (participantsInfo != null) {
      participants = participantsInfo.participants;
      workingText = participantsInfo.cleanedText;
      _logger.info('提取参与人: $participants, 剩余: $workingText');
    }

    // 4. 提取优先级
    final priorityInfo = _extractPriority(workingText);
    if (priorityInfo != null) {
      priority = priorityInfo.priority;
      workingText = priorityInfo.cleanedText;
      _logger.info('提取优先级: $priority, 剩余: $workingText');
    }

    // 5. 提取时间估算
    final durationInfo = _extractDuration(workingText);
    if (durationInfo != null) {
      estimatedMinutes = durationInfo.minutes;
      workingText = durationInfo.cleanedText;
      _logger.info('提取时长: $estimatedMinutes分钟, 剩余: $workingText');
    }

    // 6. 提取动作词,构建标题
    final title = _extractTitle(workingText, location, participants);
    _logger.info('最终标题: $title');

    // 构建备注 - 包含原始语音文本和提取的信息
    final noteParts = <String>[];

    // 添加原始语音文本
    noteParts.add('💬 原始语音: $text');
    noteParts.add(''); // 空行分隔

    // 添加提取的结构化信息
    if (location != null) noteParts.add('📍 地点: $location');
    if (participants != null && participants.isNotEmpty) {
      noteParts.add('👥 参与人: ${participants.join("、")}');
    }

    final notes = noteParts.join('\n');

    return ParsedTaskInfo(
      title: title,
      dueAt: dueAt,
      remindAt: remindAt,
      priority: priority,
      estimatedMinutes: estimatedMinutes,
      notes: notes,
      location: location,
      participants: participants,
    );
  }

  /// 提取标题 - 保留动作和关键内容
  String _extractTitle(String text, String? location, List<String>? participants) {
    var title = text;

    // 移除常见的助手词
    final prefixes = ['帮我', '请帮我', '给我', '请给我', '请', '我要', '我想', '设定', '设置', '创建', '新建', '添加'];
    for (final prefix in prefixes) {
      if (title.startsWith(prefix)) {
        title = title.substring(prefix.length);
      }
    }

    // 移除"一个"、"一下"等
    title = title.replaceAll('一个', '').replaceAll('一下', '');

    // 清理多余空格和标点
    title = title.replaceAll(RegExp(r'\s+'), ' ').trim();
    title = title.replaceAll(RegExp(r'[，。！？、]+$'), '');

    // 如果标题为空,尝试从地点或参与人生成
    if (title.isEmpty || title.length < 2) {
      if (location != null && participants != null && participants.isNotEmpty) {
        return '与${participants[0]}在$location见面';
      } else if (location != null) {
        return '去$location';
      } else if (participants != null && participants.isNotEmpty) {
        return '与${participants[0]}见面';
      }
      return '新任务';
    }

    return title;
  }

  /// 提取时间
  _TimeInfo? _extractTime(String text) {
    final now = DateTime.now();
    DateTime? dateTime;
    var cleanedText = text;

    // 周几的匹配 - "周三下午2点"
    final weekdayMatch = RegExp(r'周([一二三四五六日天])([上下]午)?(\d{1,2})点?').firstMatch(text);
    if (weekdayMatch != null) {
      final weekdayMap = {'一': 1, '二': 2, '三': 3, '四': 4, '五': 5, '六': 6, '日': 7, '天': 7};
      final targetWeekday = weekdayMap[weekdayMatch.group(1)]!;
      final currentWeekday = now.weekday;

      // 计算距离目标周几的天数
      var daysToAdd = targetWeekday - currentWeekday;
      if (daysToAdd <= 0) daysToAdd += 7; // 如果是过去的,则指向下周

      final targetDate = now.add(Duration(days: daysToAdd));

      var hour = int.parse(weekdayMatch.group(3)!);
      if (weekdayMatch.group(2) == '下午' && hour < 12) hour += 12;
      if (weekdayMatch.group(2) == '上午' && hour == 12) hour = 0;

      dateTime = DateTime(targetDate.year, targetDate.month, targetDate.day, hour, 0);
      cleanedText = text.replaceAll(weekdayMatch.group(0)!, '');
      _logger.info('匹配到周几: ${weekdayMatch.group(0)}, 目标时间: $dateTime');
    }
    // 明天的匹配
    else if (text.contains('明天')) {
      final tomorrow = now.add(const Duration(days: 1));
      final match = RegExp(r'([上下]午)?(\d{1,2})点?').firstMatch(text);
      if (match != null) {
        var hour = int.parse(match.group(2)!);
        if (match.group(1) == '下午' && hour < 12) hour += 12;
        if (match.group(1) == '上午' && hour == 12) hour = 0;
        dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, 0);
      } else {
        dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
      }
      cleanedText = text.replaceAll(RegExp(r'明[天日]([上下]午)?\d{1,2}点?'), '');
    }
    // 今天的匹配
    else if (text.contains('今天')) {
      final match = RegExp(r'([上下]午)?(\d{1,2})点?').firstMatch(text);
      if (match != null) {
        var hour = int.parse(match.group(2)!);
        if (match.group(1) == '下午' && hour < 12) hour += 12;
        if (match.group(1) == '上午' && hour == 12) hour = 0;
        dateTime = DateTime(now.year, now.month, now.day, hour, 0);
      }
      cleanedText = text.replaceAll(RegExp(r'今[天日]([上下]午)?\d{1,2}点?'), '');
    }
    // 直接说时间 "下午2点"
    else {
      final match = RegExp(r'([上下]午)(\d{1,2})点').firstMatch(text);
      if (match != null) {
        var hour = int.parse(match.group(2)!);
        if (match.group(1) == '下午' && hour < 12) hour += 12;
        if (match.group(1) == '上午' && hour == 12) hour = 0;
        dateTime = DateTime(now.year, now.month, now.day, hour, 0);
        cleanedText = text.replaceAll(match.group(0)!, '');
      }
    }

    return dateTime != null ? _TimeInfo(dateTime: dateTime, cleanedText: cleanedText.trim()) : null;
  }

  /// 提取地点 - "在XXX"、"去XXX"、"到XXX"
  _LocationInfo? _extractLocation(String text) {
    // 匹配 "在xxx" 或 "去xxx" 或 "到xxx"
    final patterns = [
      RegExp(r'在([^\s，。！？与和跟]{2,10})(吃饭|见面|开会|聊天)?'),
      RegExp(r'去([^\s，。！？与和跟]{2,10})'),
      RegExp(r'到([^\s，。！？与和跟]{2,10})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        var location = match.group(1)!;
        // 移除常见的无用词
        location = location.replaceAll(RegExp(r'^的'), '');
        if (location.isNotEmpty) {
          final cleanedText = text.replaceAll(match.group(0)!, '');
          return _LocationInfo(location: location, cleanedText: cleanedText);
        }
      }
    }

    return null;
  }

  /// 提取参与人 - "和XXX"、"与XXX"、"跟XXX"
  _ParticipantsInfo? _extractParticipants(String text) {
    final patterns = [
      RegExp(r'[与和跟]([^\s，。！？在去到]{1,10})'),
    ];

    final participants = <String>[];
    var cleanedText = text;

    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        var participant = match.group(1)!;
        // 过滤掉一些不是人名的词
        if (!['我', '他', '她', '它', '你', '大家', '一起'].contains(participant)) {
          participants.add(participant);
          cleanedText = cleanedText.replaceAll(match.group(0)!, '');
        }
      }
    }

    return participants.isNotEmpty
        ? _ParticipantsInfo(participants: participants, cleanedText: cleanedText)
        : null;
  }

  /// 提取优先级
  _PriorityInfo? _extractPriority(String text) {
    if (text.contains(RegExp('紧急|非常重要|很重要|最重要'))) {
      return _PriorityInfo(
        priority: TaskPriority.high,
        cleanedText: text.replaceAll(RegExp('紧急|非常重要|很重要|最重要'), ''),
      );
    }
    if (text.contains(RegExp('重要'))) {
      return _PriorityInfo(
        priority: TaskPriority.high,
        cleanedText: text.replaceAll(RegExp('重要'), ''),
      );
    }
    return null;
  }

  /// 提取时长
  _DurationInfo? _extractDuration(String text) {
    final hourMatch = RegExp(r'(\d+)小时').firstMatch(text);
    if (hourMatch != null) {
      return _DurationInfo(
        minutes: int.parse(hourMatch.group(1)!) * 60,
        cleanedText: text.replaceAll(RegExp(r'\d+小时'), ''),
      );
    }
    final minMatch = RegExp(r'(\d+)分钟').firstMatch(text);
    if (minMatch != null) {
      return _DurationInfo(
        minutes: int.parse(minMatch.group(1)!),
        cleanedText: text.replaceAll(RegExp(r'\d+分钟'), ''),
      );
    }
    return null;
  }
}

class _TimeInfo {
  const _TimeInfo({required this.dateTime, required this.cleanedText});
  final DateTime dateTime;
  final String cleanedText;
}

class _LocationInfo {
  const _LocationInfo({required this.location, required this.cleanedText});
  final String location;
  final String cleanedText;
}

class _ParticipantsInfo {
  const _ParticipantsInfo({required this.participants, required this.cleanedText});
  final List<String> participants;
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
