import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'recurrence_rule.freezed.dart';
part 'recurrence_rule.g.dart';

@HiveType(typeId: 6, adapterName: 'RecurrenceRuleAdapter')
@freezed
class RecurrenceRule with _$RecurrenceRule {
  const factory RecurrenceRule({
    @HiveField(0) required RecurrenceFrequency frequency,
    @HiveField(1) @Default(1) int interval,
    @HiveField(2) DateTime? endDate,
    @HiveField(3) int? count,
    @HiveField(4) @Default(<int>[]) List<int> daysOfWeek,
    @HiveField(5) int? dayOfMonth,
  }) = _RecurrenceRule;

  const RecurrenceRule._();

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);

  /// Calculate next occurrence date after given date
  DateTime nextOccurrence(DateTime after) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return after.add(Duration(days: interval));

      case RecurrenceFrequency.weekly:
        if (daysOfWeek.isEmpty) {
          return after.add(Duration(days: 7 * interval));
        }
        // Find next day of week
        var nextDate = after.add(const Duration(days: 1));
        while (!daysOfWeek.contains(nextDate.weekday)) {
          nextDate = nextDate.add(const Duration(days: 1));
        }
        return nextDate;

      case RecurrenceFrequency.monthly:
        if (dayOfMonth != null) {
          var nextMonth = DateTime(
            after.year,
            after.month + interval,
            dayOfMonth!,
          );
          // Handle invalid dates (e.g., Feb 31)
          if (nextMonth.day != dayOfMonth) {
            nextMonth = DateTime(
              nextMonth.year,
              nextMonth.month + 1,
              0,
            ); // Last day of month
          }
          return nextMonth;
        }
        return DateTime(
          after.year,
          after.month + interval,
          after.day,
        );

      case RecurrenceFrequency.yearly:
        return DateTime(
          after.year + interval,
          after.month,
          after.day,
        );

      case RecurrenceFrequency.custom:
        return after.add(Duration(days: interval));
    }
  }

  /// Check if recurrence should end
  bool shouldEnd(DateTime current, int occurrenceCount) {
    if (endDate != null && current.isAfter(endDate!)) {
      return true;
    }
    if (count != null && occurrenceCount >= count!) {
      return true;
    }
    return false;
  }
}

@HiveType(typeId: 7, adapterName: 'RecurrenceFrequencyAdapter')
@JsonEnum()
enum RecurrenceFrequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
  @HiveField(4)
  custom,
}
