// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) {
  return _RecurrenceRule.fromJson(json);
}

/// @nodoc
mixin _$RecurrenceRule {
  @HiveField(0)
  RecurrenceFrequency get frequency => throw _privateConstructorUsedError;
  @HiveField(1)
  int get interval => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @HiveField(3)
  int? get count => throw _privateConstructorUsedError;
  @HiveField(4)
  List<int> get daysOfWeek => throw _privateConstructorUsedError;
  @HiveField(5)
  int? get dayOfMonth => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecurrenceRuleCopyWith<RecurrenceRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceRuleCopyWith<$Res> {
  factory $RecurrenceRuleCopyWith(
          RecurrenceRule value, $Res Function(RecurrenceRule) then) =
      _$RecurrenceRuleCopyWithImpl<$Res, RecurrenceRule>;
  @useResult
  $Res call(
      {@HiveField(0) RecurrenceFrequency frequency,
      @HiveField(1) int interval,
      @HiveField(2) DateTime? endDate,
      @HiveField(3) int? count,
      @HiveField(4) List<int> daysOfWeek,
      @HiveField(5) int? dayOfMonth});
}

/// @nodoc
class _$RecurrenceRuleCopyWithImpl<$Res, $Val extends RecurrenceRule>
    implements $RecurrenceRuleCopyWith<$Res> {
  _$RecurrenceRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? count = freezed,
    Object? daysOfWeek = null,
    Object? dayOfMonth = freezed,
  }) {
    return _then(_value.copyWith(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurrenceFrequency,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      daysOfWeek: null == daysOfWeek
          ? _value.daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as List<int>,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurrenceRuleImplCopyWith<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  factory _$$RecurrenceRuleImplCopyWith(_$RecurrenceRuleImpl value,
          $Res Function(_$RecurrenceRuleImpl) then) =
      __$$RecurrenceRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) RecurrenceFrequency frequency,
      @HiveField(1) int interval,
      @HiveField(2) DateTime? endDate,
      @HiveField(3) int? count,
      @HiveField(4) List<int> daysOfWeek,
      @HiveField(5) int? dayOfMonth});
}

/// @nodoc
class __$$RecurrenceRuleImplCopyWithImpl<$Res>
    extends _$RecurrenceRuleCopyWithImpl<$Res, _$RecurrenceRuleImpl>
    implements _$$RecurrenceRuleImplCopyWith<$Res> {
  __$$RecurrenceRuleImplCopyWithImpl(
      _$RecurrenceRuleImpl _value, $Res Function(_$RecurrenceRuleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? count = freezed,
    Object? daysOfWeek = null,
    Object? dayOfMonth = freezed,
  }) {
    return _then(_$RecurrenceRuleImpl(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurrenceFrequency,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      daysOfWeek: null == daysOfWeek
          ? _value._daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as List<int>,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurrenceRuleImpl extends _RecurrenceRule {
  const _$RecurrenceRuleImpl(
      {@HiveField(0) required this.frequency,
      @HiveField(1) this.interval = 1,
      @HiveField(2) this.endDate,
      @HiveField(3) this.count,
      @HiveField(4) final List<int> daysOfWeek = const <int>[],
      @HiveField(5) this.dayOfMonth})
      : _daysOfWeek = daysOfWeek,
        super._();

  factory _$RecurrenceRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceRuleImplFromJson(json);

  @override
  @HiveField(0)
  final RecurrenceFrequency frequency;
  @override
  @JsonKey()
  @HiveField(1)
  final int interval;
  @override
  @HiveField(2)
  final DateTime? endDate;
  @override
  @HiveField(3)
  final int? count;
  final List<int> _daysOfWeek;
  @override
  @JsonKey()
  @HiveField(4)
  List<int> get daysOfWeek {
    if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOfWeek);
  }

  @override
  @HiveField(5)
  final int? dayOfMonth;

  @override
  String toString() {
    return 'RecurrenceRule(frequency: $frequency, interval: $interval, endDate: $endDate, count: $count, daysOfWeek: $daysOfWeek, dayOfMonth: $dayOfMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceRuleImpl &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other._daysOfWeek, _daysOfWeek) &&
            (identical(other.dayOfMonth, dayOfMonth) ||
                other.dayOfMonth == dayOfMonth));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, frequency, interval, endDate,
      count, const DeepCollectionEquality().hash(_daysOfWeek), dayOfMonth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      __$$RecurrenceRuleImplCopyWithImpl<_$RecurrenceRuleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceRuleImplToJson(
      this,
    );
  }
}

abstract class _RecurrenceRule extends RecurrenceRule {
  const factory _RecurrenceRule(
      {@HiveField(0) required final RecurrenceFrequency frequency,
      @HiveField(1) final int interval,
      @HiveField(2) final DateTime? endDate,
      @HiveField(3) final int? count,
      @HiveField(4) final List<int> daysOfWeek,
      @HiveField(5) final int? dayOfMonth}) = _$RecurrenceRuleImpl;
  const _RecurrenceRule._() : super._();

  factory _RecurrenceRule.fromJson(Map<String, dynamic> json) =
      _$RecurrenceRuleImpl.fromJson;

  @override
  @HiveField(0)
  RecurrenceFrequency get frequency;
  @override
  @HiveField(1)
  int get interval;
  @override
  @HiveField(2)
  DateTime? get endDate;
  @override
  @HiveField(3)
  int? get count;
  @override
  @HiveField(4)
  List<int> get daysOfWeek;
  @override
  @HiveField(5)
  int? get dayOfMonth;
  @override
  @JsonKey(ignore: true)
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
