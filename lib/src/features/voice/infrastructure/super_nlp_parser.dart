import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/domain/entities/task.dart';

/// 超强NLP解析结果
class ParsedTaskInfo {
  ParsedTaskInfo({
    required this.title,
    this.dueAt,
    this.remindAt,
    this.priority = TaskPriority.none,
    this.estimatedMinutes,
    this.notes,
    this.tags,
    this.location,
    this.participants,
  });

  final String title;
  final DateTime? dueAt;
  final DateTime? remindAt;
  final TaskPriority priority;
  final int? estimatedMinutes;
  final String? notes;
  final List<String>? tags;
  final String? location; // 地点
  final List<String>? participants; // 参与人
}

/// 超强NLP任务解析器
/// 支持复杂语义理解、智能提取、同义词识别
class SuperNlpParser {
  SuperNlpParser(this._logger);

  final AppLogger _logger;

  /// 核心解析方法
  ParsedTaskInfo parseTaskFromText(String text) {
    _logger.info('🧠 超强NLP开始解析: $text');

    var title = text;
    DateTime? dueAt;
    DateTime? remindAt;
    var priority = TaskPriority.none;
    int? estimatedMinutes;
    String? notes;
    List<String>? tags;
    String? location;
    List<String>? participants;

    // 1. 提取标签 #工作 #重要
    final tagResult = _extractTags(title);
    if (tagResult.tags.isNotEmpty) {
      tags = tagResult.tags;
      title = tagResult.cleanedText;
      _logger.info('✓ 提取标签: ${tags.join(", ")}');
    }

    // 2. 提取地点 在XX、去XX
    final locationResult = _extractLocation(title);
    if (locationResult.location != null) {
      location = locationResult.location;
      title = locationResult.cleanedText;
      _logger.info('✓ 提取地点: $location');
    }

    // 3. 提取参与人 和XX一起、@XX
    final participantsResult = _extractParticipants(title);
    if (participantsResult.participants != null) {
      participants = participantsResult.participants;
      title = participantsResult.cleanedText;
      _logger.info('✓ 参与人: ${participants!.join(", ")}');
    }

    // 4. 提取时间信息（支持多种复杂格式）
    final timeResult = _extractTime(title);
    if (timeResult.dueAt != null) {
      dueAt = timeResult.dueAt;
      remindAt = timeResult.remindAt;
      title = timeResult.cleanedText;
      _logger.info('✓ 截止时间: $dueAt');
      if (remindAt != null) {
        _logger.info('✓ 提醒时间: $remindAt');
      }
    }

    // 5. 提取优先级（支持多种表达）
    final priorityResult = _extractPriority(title);
    if (priorityResult.priority != TaskPriority.none) {
      priority = priorityResult.priority;
      title = priorityResult.cleanedText;
      _logger.info('✓ 优先级: $priority');
    }

    // 6. 提取时间估算
    final durationResult = _extractDuration(title);
    if (durationResult.minutes != null) {
      estimatedMinutes = durationResult.minutes;
      title = durationResult.cleanedText;
      _logger.info('✓ 估算时长: $estimatedMinutes分钟');
    }

    // 7. 移除语音助手前缀
    title = _removeVoiceHelpers(title);

    // 8. 智能提取任务核心
    title = _extractTaskCore(title);

    // 9. 最终清理
    title = _cleanTitle(title);

    _logger.info('🎯 最终标题: $title');

    return ParsedTaskInfo(
      title: title,
      dueAt: dueAt,
      remindAt: remindAt,
      priority: priority,
      estimatedMinutes: estimatedMinutes,
      notes: notes,
      tags: tags,
      location: location,
      participants: participants,
    );
  }

  /// 提取标签 #工作 #项目
  _TagResult _extractTags(String text) {
    final tags = <String>[];
    var cleaned = text;

    final tagPattern = RegExp(r'#([\u4e00-\u9fa5a-zA-Z0-9_]+)');
    final matches = tagPattern.allMatches(text);

    for (final match in matches) {
      tags.add(match.group(1)!);
    }

    if (tags.isNotEmpty) {
      cleaned = text.replaceAll(tagPattern, '').trim();
    }

    return _TagResult(tags: tags, cleanedText: cleaned);
  }

  /// 提取时间信息（支持复杂格式）
  _TimeResult _extractTime(String text) {
    final now = DateTime.now();
    DateTime? dueAt;
    DateTime? remindAt;
    var cleaned = text;

    // 1. 今天系列
    if (text.contains(RegExp('今[天日晚]|今晚'))) {
      final timeMatch = _extractTimeOfDay(text);
      if (timeMatch != null) {
        dueAt = DateTime(now.year, now.month, now.day, timeMatch.hour, timeMatch.minute);
        cleaned = text
            .replaceAll(RegExp('今[天日晚]'), '')
            .replaceAll(RegExp('[上下中]午|早上|晚上|傍晚'), '')
            .replaceAll(RegExp(r'\d{1,2}[点:]\d{0,2}分?'), '');
      } else {
        dueAt = DateTime(now.year, now.month, now.day, 23, 59);
        cleaned = text.replaceAll(RegExp('今[天日晚]'), '');
      }
    }
    // 2. 明天系列
    else if (text.contains(RegExp('明[天日早晚]|明早|明晚'))) {
      final tomorrow = now.add(const Duration(days: 1));
      final timeMatch = _extractTimeOfDay(text);
      if (timeMatch != null) {
        dueAt = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, timeMatch.hour, timeMatch.minute);
        cleaned = text
            .replaceAll(RegExp('明[天日早晚]'), '')
            .replaceAll(RegExp('[上下中]午|早上|晚上|傍晚'), '')
            .replaceAll(RegExp(r'\d{1,2}[点:]\d{0,2}分?'), '');
      } else {
        dueAt = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59);
        cleaned = text.replaceAll(RegExp('明[天日早晚]'), '');
      }
    }
    // 3. 后天
    else if (text.contains('后天')) {
      final day = now.add(const Duration(days: 2));
      final timeMatch = _extractTimeOfDay(text);
      if (timeMatch != null) {
        dueAt = DateTime(day.year, day.month, day.day, timeMatch.hour, timeMatch.minute);
        cleaned = text
            .replaceAll('后天', '')
            .replaceAll(RegExp('[上下中]午|早上|晚上|傍晚'), '')
            .replaceAll(RegExp(r'\d{1,2}[点:]\d{0,2}分?'), '');
      } else {
        dueAt = DateTime(day.year, day.month, day.day, 23, 59);
        cleaned = text.replaceAll('后天', '');
      }
    }
    // 4. X天后
    else if (text.contains(RegExp(r'(\d+)天[后之]后'))) {
      final match = RegExp(r'(\d+)天[后之]后').firstMatch(text);
      if (match != null) {
        final days = int.parse(match.group(1)!);
        final targetDay = now.add(Duration(days: days));
        dueAt = DateTime(targetDay.year, targetDay.month, targetDay.day, 23, 59);
        cleaned = text.replaceAll(RegExp(r'\d+天[后之]后'), '');
      }
    }
    // 5. 下周X / 本周X
    else if (text.contains(RegExp('[本下这]?周[一二三四五六日天末]'))) {
      final weekMatch = RegExp('([本下这]?)周([一二三四五六日天末])').firstMatch(text);
      if (weekMatch != null) {
        final isNextWeek = weekMatch.group(1) == '下';
        final weekdayStr = weekMatch.group(2)!;
        final targetWeekday = _parseWeekday(weekdayStr);

        var targetDate = _getNextWeekday(now, targetWeekday);
        if (isNextWeek || targetDate.isBefore(now)) {
          targetDate = targetDate.add(const Duration(days: 7));
        }

        final timeMatch = _extractTimeOfDay(text);
        if (timeMatch != null) {
          dueAt = DateTime(targetDate.year, targetDate.month, targetDate.day, timeMatch.hour, timeMatch.minute);
        } else {
          dueAt = DateTime(targetDate.year, targetDate.month, targetDate.day, 9, 0);
        }

        cleaned = text
            .replaceAll(RegExp('[本下这]?周[一二三四五六日天末]'), '')
            .replaceAll(RegExp('[上下中]午|早上|晚上'), '')
            .replaceAll(RegExp(r'\d{1,2}[点:]\d{0,2}分?'), '');
      }
    }
    // 6. X月X日
    else if (text.contains(RegExp(r'(\d{1,2})月(\d{1,2})[日号]'))) {
      final match = RegExp(r'(\d{1,2})月(\d{1,2})[日号]').firstMatch(text);
      if (match != null) {
        final month = int.parse(match.group(1)!);
        final day = int.parse(match.group(2)!);
        var year = now.year;
        if (month < now.month || (month == now.month && day < now.day)) {
          year++;
        }
        dueAt = DateTime(year, month, day, 23, 59);
        cleaned = text.replaceAll(RegExp(r'\d{1,2}月\d{1,2}[日号]'), '');
      }
    }

    // 提取提前提醒时间
    _logger.info('  [提醒检查] dueAt=$dueAt, 原文="$text"');
    _logger.info('  [提醒检查] 包含"提前"=${text.contains("提前")}, 包含"提醒"=${text.contains("提醒")}');
    
    if (dueAt != null) {
      _logger.info('  [提醒提取] 开始提取提醒时间...');
      
      // 支持多种提醒表达方式（更宽松的匹配）
      final remindPatterns = [
        // "提前X分钟/小时/天"
        RegExp(r'提前([零一二三四五六七八九十百两]+|[\d]+)(分钟|小时|天)'),
        // "X分钟/小时前提醒" 或 "X分钟提醒"
        RegExp(r'([零一二三四五六七八九十百两]+|[\d]+)(分钟|小时|天)[前之]?提醒'),
        // "早X分钟提醒"
        RegExp(r'早([零一二三四五六七八九十百两]+|[\d]+)(分钟|小时|天)'),
        // "前X分钟" （更宽松）
        RegExp(r'前([零一二三四五六七八九十百两]+|[\d]+)(分钟|小时|天)'),
      ];
      
      for (final pattern in remindPatterns) {
        final remindMatch = pattern.firstMatch(text);
        if (remindMatch != null) {
          _logger.info('  [匹配成功] 模式: ${pattern.pattern}');
          
          final valueStr = remindMatch.group(1)!;
          final unit = remindMatch.group(2)!;
          
          // 转换中文数字
          final value = _chineseToNumber(valueStr) ?? int.tryParse(valueStr);
          
          if (value != null) {
            _logger.info('  [提醒参数] 数值=$value, 单位=$unit');
            
            switch (unit) {
              case '分钟':
                remindAt = dueAt.subtract(Duration(minutes: value));
              case '小时':
                remindAt = dueAt.subtract(Duration(hours: value));
              case '天':
                remindAt = dueAt.subtract(Duration(days: value));
            }
            
            _logger.info('  [提醒时间] 已计算: $remindAt');
            cleaned = cleaned.replaceAll(pattern, '').trim();
            cleaned = cleaned.replaceAll(RegExp('[，,]?提醒我?'), '').trim();
            break;
          }
        }
      }
    }

    return _TimeResult(dueAt: dueAt, remindAt: remindAt, cleanedText: cleaned.trim());
  }

  /// 提取一天中的时间
  _TimeOfDay? _extractTimeOfDay(String text) {
    _logger.info('  [时间提取] 尝试从文本提取时间: $text');
    
    // 支持多种时间格式
    final patterns = [
      // 下午3点 / 下午三点 / 三点半
      RegExp(r'([上下中]午|早上|晚上|傍晚)?([零一二三四五六七八九十]{1,2}|[两]|\d{1,2})[点:]([零一二三四五六七八九十]{1,2}|半|\d{1,2})?分?'),
      // 早上 / 中午 / 晚上（默认时间）
      RegExp('(早上|上午|中午|下午|傍晚|晚上|夜里|凌晨)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final period = match.groupCount >= 1 ? match.group(1) : null;
        final hourStr = match.groupCount >= 2 ? match.group(2) : null;

        _logger.info('  [匹配成功] 时段:$period, 小时:$hourStr');

        var hour = 0;
        var minute = 0;

        if (hourStr != null && hourStr.isNotEmpty) {
          // 转换中文数字
          hour = _chineseToNumber(hourStr) ?? int.tryParse(hourStr) ?? 0;
          _logger.info('  [转换小时] $hourStr → $hour');

          // 分钟
          final minuteStr = match.groupCount >= 3 ? match.group(3) : null;
          if (minuteStr == '半') {
            minute = 30;
          } else if (minuteStr != null) {
            final minuteNum = _chineseToNumber(minuteStr) ?? int.tryParse(minuteStr);
            if (minuteNum != null) minute = minuteNum;
          }
          _logger.info('  [转换分钟] ${minuteStr ?? "无"} → $minute');
        } else if (period != null) {
          // 只有时段，使用默认时间
          hour = _getDefaultHour(period);
          _logger.info('  [默认时间] $period → $hour:00');
        }

        // 根据时段调整小时
        if (period != null && hour > 0) {
          if ((period == '下午' || period == '傍晚') && hour < 12) {
            hour += 12;
            _logger.info('  [调整下午] $hour-12 → $hour');
          } else if (period == '晚上' && hour < 12) {
            hour += 12;
            _logger.info('  [调整晚上] $hour-12 → $hour');
          } else if (period == '中午' && hour != 12) {
            hour = 12;
          }
        }

        _logger.info('  [最终时间] $hour:${minute.toString().padLeft(2, "0")}');

        if (hour >= 0 && hour < 24) {
          return _TimeOfDay(hour: hour, minute: minute);
        }
      }
    }

    _logger.info('  [时间提取] 未找到时间信息');
    return null;
  }

  /// 中文数字转阿拉伯数字（增强版）
  int? _chineseToNumber(String chinese) {
    // 直接映射
    final directMap = {
      '零': 0, '一': 1, '二': 2, '三': 3, '四': 4,
      '五': 5, '六': 6, '七': 7, '八': 8, '九': 9,
      '十': 10, '两': 2,
      '十一': 11, '十二': 12, '十三': 13, '十四': 14, '十五': 15,
      '十六': 16, '十七': 17, '十八': 18, '十九': 19,
      '二十': 20, '三十': 30, '四十': 40, '五十': 50,
      '六十': 60, '七十': 70, '八十': 80, '九十': 90,
      '一百': 100, '两百': 200,
    };
    
    if (directMap.containsKey(chinese)) {
      return directMap[chinese];
    }
    
    // 尝试直接解析阿拉伯数字
    final num = int.tryParse(chinese);
    if (num != null) return num;
    
    // 处理"二十三"、"三十五"等组合
    if (chinese.length == 3) {
      final tens = directMap[chinese.substring(0, 2)];
      final ones = directMap[chinese.substring(2, 3)];
      if (tens != null && ones != null) {
        return tens + ones;
      }
    }
    
    return null;
  }

  /// 获取时段的默认小时
  int _getDefaultHour(String period) {
    switch (period) {
      case '早上':
      case '上午':
        return 9;
      case '中午':
        return 12;
      case '下午':
        return 14;
      case '傍晚':
        return 18;
      case '晚上':
        return 20;
      case '夜里':
      case '凌晨':
        return 1;
      default:
        return 9;
    }
  }

  /// 提取优先级（支持多种表达）
  _PriorityResult _extractPriority(String text) {
    var priority = TaskPriority.none;
    var cleaned = text;

    // 紧急级别（最高）
    if (text.contains(RegExp('紧急|火急|非常重要|极其重要|很重要|特别重要|最重要|立即|马上|尽快|刻不容缓|当务之急'))) {
      priority = TaskPriority.critical;
      cleaned = text.replaceAll(RegExp('紧急|火急|非常重要|极其重要|很重要|特别重要|最重要|立即|马上|尽快|刻不容缓|当务之急'), '');
    }
    // 重要级别（高）
    else if (text.contains(RegExp('重要|优先|高优先级|需要重视'))) {
      priority = TaskPriority.high;
      cleaned = text.replaceAll(RegExp('重要|优先|高优先级|需要重视'), '');
    }
    // 一般级别（中）
    else if (text.contains(RegExp('一般|中等|普通|正常'))) {
      priority = TaskPriority.medium;
      cleaned = text.replaceAll(RegExp('一般|中等|普通|正常'), '');
    }
    // 低优先级
    else if (text.contains(RegExp('不重要|不急|低优先级|可选|有空|随便'))) {
      priority = TaskPriority.low;
      cleaned = text.replaceAll(RegExp('不重要|不急|低优先级|可选|有空|随便'), '');
    }

    return _PriorityResult(priority: priority, cleanedText: cleaned.trim());
  }

  /// 提取时间估算（支持多种表达）
  _DurationResult _extractDuration(String text) {
    int? minutes;
    var cleaned = text;

    // X小时Y分钟
    final complexMatch = RegExp(r'(\d+)小时(\d+)分钟').firstMatch(text);
    if (complexMatch != null) {
      final hours = int.parse(complexMatch.group(1)!);
      final mins = int.parse(complexMatch.group(2)!);
      minutes = hours * 60 + mins;
      cleaned = text.replaceAll(RegExp(r'\d+小时\d+分钟'), '');
    }
    // X小时
    else {
      final hourMatch = RegExp(r'(\d+)(?:个)?小时').firstMatch(text);
      if (hourMatch != null) {
        minutes = int.parse(hourMatch.group(1)!) * 60;
        cleaned = text.replaceAll(RegExp(r'\d+(?:个)?小时'), '');
      }
      // X分钟
      else {
        final minMatch = RegExp(r'(\d+)分钟').firstMatch(text);
        if (minMatch != null) {
          minutes = int.parse(minMatch.group(1)!);
          cleaned = text.replaceAll(RegExp(r'\d+分钟'), '');
        }
      }
    }

    // 半小时
    if (text.contains('半小时') || text.contains('半个小时')) {
      minutes = 30;
      cleaned = text.replaceAll(RegExp('半(?:个)?小时'), '');
    }
    // 一刻钟
    else if (text.contains('一刻钟') || text.contains('15分钟')) {
      minutes = 15;
      cleaned = text.replaceAll(RegExp('一刻钟'), '');
    }

    return _DurationResult(minutes: minutes, cleanedText: cleaned.trim());
  }

  /// 移除语音助手词汇
  String _removeVoiceHelpers(String text) {
    var cleaned = text;

    // 前缀词（从长到短匹配）
    final prefixes = [
      '请你帮我设定一个', '请帮我设定一个', '请你帮我创建一个', '请帮我创建一个',
      '请你给我设定一个', '请给我设定一个', '请你给我创建一个', '请给我创建一个',
      '请你帮我添加一个', '请帮我添加一个', '请你给我添加一个', '请给我添加一个',
      '帮我设定一个', '给我设定一个', '帮我创建一个', '给我创建一个',
      '帮我添加一个', '给我添加一个', '请你提醒我', '请提醒我', '提醒我',
      '请你帮我记录', '请帮我记录', '帮我记录', '请你给我记录', '给我记录',
      '请你设定', '请设定', '设定一个', '创建一个', '添加一个', '记录一个',
      '请你', '请', '帮我', '给我', '我要', '我想', '需要', '要',
    ];

    for (final prefix in prefixes) {
      if (cleaned.startsWith(prefix)) {
        cleaned = cleaned.substring(prefix.length).trim();
        break;
      }
    }

    // 移除"一个"、"一项"、"一下"
    cleaned = cleaned
        .replaceAll(RegExp('^一个'), '')
        .replaceAll(RegExp('^一项'), '')
        .replaceAll(RegExp('^一下'), '')
        .replaceAll(RegExp('^的'), '')
        .trim();

    // 移除后缀
    cleaned = cleaned
        .replaceAll(RegExp(r'的?任务$'), '')
        .replaceAll(RegExp(r'的?事项$'), '')
        .replaceAll(RegExp(r'的?事情$'), '')
        .replaceAll(RegExp(r'这件事$'), '')
        .trim();

    return cleaned;
  }

  /// 智能提取任务核心（超强版）
  String _extractTaskCore(String text) {
    if (text.isEmpty) return text;

    // 1. 尝试匹配动词+名词模式
    final taskPatterns = {
      // 会议沟通类
      '(参加|召开|举行|组织|安排|准备)?(.{0,5}?)(会议|开会|讨论|交流|沟通|面谈|面试|谈话|会面|座谈)':
          '会议讨论',
      // 文档工作类
      '(写|撰写|编写|完成|整理|修改|审核|提交|发布)?(.{0,5}?)(报告|总结|方案|计划|文档|文稿|材料|PPT|演示文稿|提案)':
          '文档工作',
      // 学习类
      '(学习|学会|掌握|复习|预习|研究|钻研|阅读|看|读|背)?(.{0,5}?)(课程|教程|书籍|文章|资料|知识|内容|章节|课文)':
          '学习',
      // 编程类
      '(写|编写|开发|实现|优化|重构|调试|测试|部署|发布)?(.{0,5}?)(代码|程序|功能|模块|接口|API|组件|页面|系统)':
          '编程',
      // 生活事务类
      '(去|到)?(.{0,3}?)(购物|买菜|买东西|采购|逛街|shopping)': '购物',
      '(做|准备|煮|烧|炒)?(.{0,3}?)(饭|菜|早餐|午餐|晚餐|早饭|晚饭|食物)': '做饭',
      '(洗|晾|晒|叠|整理)?(.{0,3}?)(衣服|衣物|被子|床单)': '洗衣',
      '(打扫|清理|收拾|整理|清洁|扫|拖)?(.{0,3}?)(房间|屋子|家里|卫生|地板|桌子)': '打扫',
      // 健康运动类
      '(去)?(.{0,3}?)(跑步|慢跑|晨跑|夜跑|running)': '跑步',
      '(去)?(.{0,3}?)(锻炼|健身|运动|健身|训练|workout)': '锻炼',
      '(去)?(.{0,3}?)(游泳|瑜伽|骑车|爬山|登山|徒步)': '运动',
      // 医疗健康类
      '(去)?(.{0,3}?)(看病|就医|就诊|问诊|复诊|看医生)': '看病',
      '(去)?(.{0,3}?)(体检|检查|拍片|化验|验血)': '体检',
      '(去)?(.{0,3}?)(打针|输液|注射|接种|打疫苗)': '打针',
      '(去)?(.{0,3}?)(拿药|取药|买药|配药)': '拿药',
      '(挂号|预约|约)?(.{0,3}?)(挂号|预约)': '预约挂号',
      // 金融财务类
      '(去)?(.{0,3}?)(支付|付款|缴费|交费|充值|转账|汇款|还款)': '支付',
      // 社交活动类
      '(和|与|跟)?(.{0,4}?)(见面|约会|聚会|聚餐|吃饭|喝茶|聊天)': '社交',
      // 出行交通类
      '(去|到)?(.{0,3}?)(机场|火车站|汽车站|地铁站|车站)': '出行',
      '(送|接)?(.{0,3}?)(人|孩子|父母|朋友|客人)': '接送',
      '(打车|叫车|约车|开车|坐车|乘车)': '交通',
      // 工作任务类
      '(处理|解决|修复|排查)?(.{0,4}?)(问题|bug|故障|异常|错误)': '处理问题',
      '(联系|打电话|发消息|发邮件|回复)?(.{0,4}?)(客户|用户|同事|领导|合作伙伴)': '联系沟通',
      '(参加|出席|参与)?(.{0,4}?)(活动|会议|培训|研讨会|讲座|论坛)': '活动',
    };

    // 尝试匹配模式
    for (final entry in taskPatterns.entries) {
      final regex = RegExp(entry.key);
      final match = regex.firstMatch(text);
      if (match != null) {
        final verb = match.group(1) ?? '';
        final modifier = match.group(2) ?? '';
        final noun = match.group(3) ?? '';

        // 构建标题
        var core = '';

        // 保留有意义的修饰词
        if (modifier.isNotEmpty && !modifier.contains(RegExp('[的地得]')) && modifier.length <= 4) {
          core = modifier + noun;
        } else {
          core = noun;
        }

        // 保留有意义的动词
        if (verb.isNotEmpty && !['去', '到', '要', '和', '与', '跟'].contains(verb)) {
          core = verb + core;
        }

        _logger.info('✓ 匹配模式: ${entry.value}');
        _logger.info('  动词=$verb, 修饰=$modifier, 名词=$noun → $core');

        return core;
      }
    }

    // 如果没匹配到，使用简化策略
    return _simplifyByStructure(text);
  }

  /// 根据句子结构简化
  String _simplifyByStructure(String text) {
    if (text.length <= 8) return text;

    // 策略1: 提取最后一个"的"之后的内容
    final deIndex = text.lastIndexOf('的');
    if (deIndex > 0 && deIndex < text.length - 2) {
      final after = text.substring(deIndex + 1);
      if (after.length >= 2 && after.length <= 10) {
        _logger.info('  简化策略: 提取"的"后 → $after');
        return after;
      }
    }

    // 策略2: 提取逗号/顿号之前的内容
    final punctMatch = text.indexOf(RegExp('[，,、；]'));
    if (punctMatch > 0 && punctMatch <= 12) {
      final before = text.substring(0, punctMatch);
      _logger.info('  简化策略: 提取标点前 → $before');
      return before;
    }

    // 策略3: 查找最后出现的常见名词
    final commonNouns = [
      '会议', '会', '讨论', '工作', '任务', '事情', '事项',
      '报告', '文档', '方案', '计划', '总结',
      '学习', '复习', '课程', '作业',
      '锻炼', '运动', '跑步',
    ];

    for (final noun in commonNouns) {
      final index = text.lastIndexOf(noun);
      if (index >= 0) {
        // 提取名词前2-3个字作为修饰
        final start = index > 3 ? index - 3 : 0;
        final core = text.substring(start, index + noun.length);
        _logger.info('  简化策略: 找到名词"$noun" → $core');
        return core;
      }
    }

    // 策略4: 如果太长，截取前12字
    if (text.length > 12) {
      final simplified = text.substring(0, 12);
      _logger.info('  简化策略: 截取前12字 → $simplified');
      return simplified;
    }

    return text;
  }

  /// 清理标题
  String _cleanTitle(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ') // 多空格变单空格
        .replaceAll(RegExp(r'^[，。、！？；：的地得\s]+'), '') // 移除开头标点
        .replaceAll(RegExp(r'[，。、！？；：\s]+$'), '') // 移除结尾标点
        .replaceAll(RegExp(r'的$'), '') // 移除结尾的"的"
        .trim();
  }

  /// 解析星期
  int _parseWeekday(String weekday) {
    const weekMap = {
      '一': DateTime.monday,
      '二': DateTime.tuesday,
      '三': DateTime.wednesday,
      '四': DateTime.thursday,
      '五': DateTime.friday,
      '六': DateTime.saturday,
      '日': DateTime.sunday,
      '天': DateTime.sunday,
      '末': DateTime.sunday, // 周末默认周日
    };
    return weekMap[weekday] ?? DateTime.monday;
  }

  /// 获取下一个指定星期
  DateTime _getNextWeekday(DateTime from, int targetWeekday) {
    var daysToAdd = targetWeekday - from.weekday;
    if (daysToAdd <= 0) daysToAdd += 7;
    return from.add(Duration(days: daysToAdd));
  }

  /// 提取地点信息
  _LocationResult _extractLocation(String text) {
    String? location;
    var cleaned = text;

    // 匹配 "在XX"、"去XX"、"到XX"，但要在"和"、"跟"、动词之前停止
    final patterns = [
      RegExp(r'在([\u4e00-\u9fa5]{2,6})(?=[和跟与同一起去做开参加召]|$)'),
      RegExp(r'去([\u4e00-\u9fa5]{2,6})(?=[和跟与同一起做开参加召]|$)'),
      RegExp(r'到([\u4e00-\u9fa5]{2,6})(?=[和跟与同一起做开参加召]|$)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final candidate = match.group(1)!;
        // 排除时间词
        if (!['今天', '明天', '后天', '本周', '下周', '这里', '那里'].contains(candidate)) {
          location = candidate;
          cleaned = text.replaceFirst(RegExp('在$candidate'), '').trim();
          break;
        }
      }
    }

    return _LocationResult(location: location, cleanedText: cleaned);
  }

  /// 提取参与人信息
  _ParticipantsResult _extractParticipants(String text) {
    final participants = <String>[];
    var cleaned = text;

    // 匹配 "和XX一起"、"@XX"、"叫上XX"、"约XX"
    final patterns = [
      RegExp(r'和([\u4e00-\u9fa5]{2,6})一起'),
      RegExp(r'@([\u4e00-\u9fa5a-zA-Z0-9_]+)'),
      RegExp(r'叫上([\u4e00-\u9fa5]{2,6})'),
      RegExp(r'约([\u4e00-\u9fa5]{2,6})'),
      RegExp(r'邀请([\u4e00-\u9fa5]{2,6})'),
    ];

    for (final pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        final person = match.group(1)!;
        if (person.length >= 2 && person.length <= 6) {
          participants.add(person);
        }
      }
      cleaned = cleaned.replaceAll(pattern, '').trim();
    }

    return _ParticipantsResult(
      participants: participants.isEmpty ? null : participants,
      cleanedText: cleaned,
    );
  }
}

// 辅助类
class _TagResult {
  const _TagResult({required this.tags, required this.cleanedText});
  final List<String> tags;
  final String cleanedText;
}

class _TimeResult {
  const _TimeResult({required this.cleanedText, this.dueAt, this.remindAt});
  final DateTime? dueAt;
  final DateTime? remindAt;
  final String cleanedText;
}

class _TimeOfDay {
  const _TimeOfDay({required this.hour, required this.minute});
  final int hour;
  final int minute;
}

class _PriorityResult {
  const _PriorityResult({required this.priority, required this.cleanedText});
  final TaskPriority priority;
  final String cleanedText;
}

class _DurationResult {
  const _DurationResult({required this.cleanedText, this.minutes});
  final int? minutes;
  final String cleanedText;
}

class _LocationResult {
  const _LocationResult({required this.cleanedText, this.location});
  final String? location;
  final String cleanedText;
}

class _ParticipantsResult {
  const _ParticipantsResult({required this.cleanedText, this.participants});
  final List<String>? participants;
  final String cleanedText;
}

