import 'package:todolist/src/core/utils/clock.dart';

/// Result of parsing natural language input
class ParsedReminder {
  ParsedReminder({
    required this.dateTime,
    this.isRelative = false,
    this.originalInput,
  });

  final DateTime dateTime;
  final bool isRelative;
  final String? originalInput;
}

/// Service for parsing natural language time expressions
class NaturalLanguageParser {
  NaturalLanguageParser(this._clock);

  final Clock _clock;

  /// Parse natural language input into a DateTime
  /// Supports Chinese and English expressions
  ParsedReminder? parse(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) return null;

    final now = _clock.now();

    // Try to parse various patterns
    DateTime? result;

    // Chinese patterns
    result ??= _parseChineseRelative(trimmed, now);
    result ??= _parseChineseAbsolute(trimmed, now);

    // English patterns
    result ??= _parseEnglishRelative(trimmed, now);
    result ??= _parseEnglishAbsolute(trimmed, now);

    // Time patterns (works for both languages)
    result ??= _parseTimePattern(trimmed, now);

    if (result != null) {
      return ParsedReminder(
        dateTime: result,
        isRelative: _isRelativeExpression(trimmed),
        originalInput: input,
      );
    }

    return null;
  }

  bool _isRelativeExpression(String input) {
    final relativeKeywords = [
      '后', 'after', 'in', 'later', '明天', 'tomorrow',
      '下午', 'afternoon', '晚上', 'evening', '今天', 'today',
    ];
    return relativeKeywords.any((keyword) => input.contains(keyword));
  }

  // Parse Chinese relative expressions
  // Examples: "5分钟后", "1小时后", "明天", "后天"
  DateTime? _parseChineseRelative(String input, DateTime now) {
    // "N分钟后" / "N分钟之后"
    final minutesMatch = RegExp(r'(\d+)\s*分钟[之]?后').firstMatch(input);
    if (minutesMatch != null) {
      final minutes = int.parse(minutesMatch.group(1)!);
      return now.add(Duration(minutes: minutes));
    }

    // "N小时后" / "N小时之后"
    final hoursMatch = RegExp(r'(\d+)\s*小时[之]?后').firstMatch(input);
    if (hoursMatch != null) {
      final hours = int.parse(hoursMatch.group(1)!);
      return now.add(Duration(hours: hours));
    }

    // "N天后" / "N天之后"
    final daysMatch = RegExp(r'(\d+)\s*天[之]?后').firstMatch(input);
    if (daysMatch != null) {
      final days = int.parse(daysMatch.group(1)!);
      return now.add(Duration(days: days));
    }

    // Specific day expressions
    if (input.contains('明天')) {
      return _setTimeOfDay(now.add(const Duration(days: 1)), input);
    }
    if (input.contains('后天')) {
      return _setTimeOfDay(now.add(const Duration(days: 2)), input);
    }
    if (input.contains('今天')) {
      return _setTimeOfDay(now, input);
    }

    return null;
  }

  // Parse Chinese absolute expressions
  // Examples: "下午3点", "晚上8点", "明天下午2点"
  DateTime? _parseChineseAbsolute(String input, DateTime now) {
    var baseDate = now;

    // Check for day modifiers
    if (input.contains('明天')) {
      baseDate = now.add(const Duration(days: 1));
    } else if (input.contains('后天')) {
      baseDate = now.add(const Duration(days: 2));
    }

    // Parse time with period (上午/下午/晚上/中午)
    final timeWithPeriod = RegExp(r'(上午|下午|晚上|中午)\s*(\d{1,2})\s*[点时]').firstMatch(input);
    if (timeWithPeriod != null) {
      final period = timeWithPeriod.group(1)!;
      var hour = int.parse(timeWithPeriod.group(2)!);

      // Adjust for 12-hour format
      if (period == '下午' && hour < 12) hour += 12;
      if (period == '晚上' && hour < 12) hour += 12;
      if (period == '中午' && hour == 12) hour = 12;

      // Parse minutes if present
      final minuteMatch = RegExp(r'(\d{1,2})\s*分').firstMatch(input);
      final minute = minuteMatch != null ? int.parse(minuteMatch.group(1)!) : 0;

      return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
    }

    // Parse 24-hour format: "15点", "14:30"
    final time24Match = RegExp(r'(\d{1,2})\s*[点时:](\d{2})?').firstMatch(input);
    if (time24Match != null) {
      final hour = int.parse(time24Match.group(1)!);
      final minute = time24Match.group(2) != null ? int.parse(time24Match.group(2)!) : 0;
      return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
    }

    return null;
  }

  // Parse English relative expressions
  // Examples: "in 5 minutes", "after 1 hour", "tomorrow"
  DateTime? _parseEnglishRelative(String input, DateTime now) {
    // "in N minutes/hours/days"
    final inMatch = RegExp(r'in\s+(\d+)\s+(minute|hour|day)s?').firstMatch(input);
    if (inMatch != null) {
      final amount = int.parse(inMatch.group(1)!);
      final unit = inMatch.group(2)!;

      switch (unit) {
        case 'minute':
          return now.add(Duration(minutes: amount));
        case 'hour':
          return now.add(Duration(hours: amount));
        case 'day':
          return now.add(Duration(days: amount));
      }
    }

    // "after N minutes/hours"
    final afterMatch = RegExp(r'after\s+(\d+)\s+(minute|hour)s?').firstMatch(input);
    if (afterMatch != null) {
      final amount = int.parse(afterMatch.group(1)!);
      final unit = afterMatch.group(2)!;

      switch (unit) {
        case 'minute':
          return now.add(Duration(minutes: amount));
        case 'hour':
          return now.add(Duration(hours: amount));
      }
    }

    // Specific day expressions
    if (input.contains('tomorrow')) {
      return _setTimeOfDay(now.add(const Duration(days: 1)), input);
    }
    if (input.contains('today')) {
      return _setTimeOfDay(now, input);
    }

    return null;
  }

  // Parse English absolute expressions
  // Examples: "3pm", "2:30pm", "tomorrow at 3pm"
  DateTime? _parseEnglishAbsolute(String input, DateTime now) {
    var baseDate = now;

    // Check for day modifiers
    if (input.contains('tomorrow')) {
      baseDate = now.add(const Duration(days: 1));
    }

    // Parse 12-hour format with am/pm
    final time12Match = RegExp(r'(\d{1,2})(?::(\d{2}))?\s*(am|pm)').firstMatch(input);
    if (time12Match != null) {
      var hour = int.parse(time12Match.group(1)!);
      final minute = time12Match.group(2) != null ? int.parse(time12Match.group(2)!) : 0;
      final period = time12Match.group(3)!;

      if (period == 'pm' && hour < 12) hour += 12;
      if (period == 'am' && hour == 12) hour = 0;

      return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
    }

    return null;
  }

  // Parse time patterns that work for both languages
  DateTime? _parseTimePattern(String input, DateTime now) {
    // ISO format: "2024-03-15 14:30"
    final isoMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})').firstMatch(input);
    if (isoMatch != null) {
      return DateTime(
        int.parse(isoMatch.group(1)!),
        int.parse(isoMatch.group(2)!),
        int.parse(isoMatch.group(3)!),
        int.parse(isoMatch.group(4)!),
        int.parse(isoMatch.group(5)!),
      );
    }

    return null;
  }

  // Helper to set time of day based on period keywords in input
  DateTime _setTimeOfDay(DateTime date, String input) {
    // Check for specific time periods
    if (input.contains('下午') || input.contains('afternoon')) {
      return DateTime(date.year, date.month, date.day, 15, 0); // 3 PM
    }
    if (input.contains('晚上') || input.contains('evening')) {
      return DateTime(date.year, date.month, date.day, 19, 0); // 7 PM
    }
    if (input.contains('早上') || input.contains('morning')) {
      return DateTime(date.year, date.month, date.day, 9, 0); // 9 AM
    }
    if (input.contains('中午') || input.contains('noon')) {
      return DateTime(date.year, date.month, date.day, 12, 0); // 12 PM
    }

    // Default to 9 AM if no time specified
    return DateTime(date.year, date.month, date.day, 9, 0);
  }
}
