// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskSuggestion _$TaskSuggestionFromJson(Map<String, dynamic> json) {
  return _TaskSuggestion.fromJson(json);
}

/// @nodoc
mixin _$TaskSuggestion {
  Task get task => throw _privateConstructorUsedError;
  double get priorityScore => throw _privateConstructorUsedError;
  SuggestedTimeSlot? get bestTimeSlot => throw _privateConstructorUsedError;
  int get predictedMinutes => throw _privateConstructorUsedError;
  double get completionProbability => throw _privateConstructorUsedError;
  List<String> get reasons => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskSuggestionCopyWith<TaskSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskSuggestionCopyWith<$Res> {
  factory $TaskSuggestionCopyWith(
          TaskSuggestion value, $Res Function(TaskSuggestion) then) =
      _$TaskSuggestionCopyWithImpl<$Res, TaskSuggestion>;
  @useResult
  $Res call(
      {Task task,
      double priorityScore,
      SuggestedTimeSlot? bestTimeSlot,
      int predictedMinutes,
      double completionProbability,
      List<String> reasons});

  $TaskCopyWith<$Res> get task;
  $SuggestedTimeSlotCopyWith<$Res>? get bestTimeSlot;
}

/// @nodoc
class _$TaskSuggestionCopyWithImpl<$Res, $Val extends TaskSuggestion>
    implements $TaskSuggestionCopyWith<$Res> {
  _$TaskSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
    Object? priorityScore = null,
    Object? bestTimeSlot = freezed,
    Object? predictedMinutes = null,
    Object? completionProbability = null,
    Object? reasons = null,
  }) {
    return _then(_value.copyWith(
      task: null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      bestTimeSlot: freezed == bestTimeSlot
          ? _value.bestTimeSlot
          : bestTimeSlot // ignore: cast_nullable_to_non_nullable
              as SuggestedTimeSlot?,
      predictedMinutes: null == predictedMinutes
          ? _value.predictedMinutes
          : predictedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      completionProbability: null == completionProbability
          ? _value.completionProbability
          : completionProbability // ignore: cast_nullable_to_non_nullable
              as double,
      reasons: null == reasons
          ? _value.reasons
          : reasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TaskCopyWith<$Res> get task {
    return $TaskCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SuggestedTimeSlotCopyWith<$Res>? get bestTimeSlot {
    if (_value.bestTimeSlot == null) {
      return null;
    }

    return $SuggestedTimeSlotCopyWith<$Res>(_value.bestTimeSlot!, (value) {
      return _then(_value.copyWith(bestTimeSlot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskSuggestionImplCopyWith<$Res>
    implements $TaskSuggestionCopyWith<$Res> {
  factory _$$TaskSuggestionImplCopyWith(_$TaskSuggestionImpl value,
          $Res Function(_$TaskSuggestionImpl) then) =
      __$$TaskSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Task task,
      double priorityScore,
      SuggestedTimeSlot? bestTimeSlot,
      int predictedMinutes,
      double completionProbability,
      List<String> reasons});

  @override
  $TaskCopyWith<$Res> get task;
  @override
  $SuggestedTimeSlotCopyWith<$Res>? get bestTimeSlot;
}

/// @nodoc
class __$$TaskSuggestionImplCopyWithImpl<$Res>
    extends _$TaskSuggestionCopyWithImpl<$Res, _$TaskSuggestionImpl>
    implements _$$TaskSuggestionImplCopyWith<$Res> {
  __$$TaskSuggestionImplCopyWithImpl(
      _$TaskSuggestionImpl _value, $Res Function(_$TaskSuggestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
    Object? priorityScore = null,
    Object? bestTimeSlot = freezed,
    Object? predictedMinutes = null,
    Object? completionProbability = null,
    Object? reasons = null,
  }) {
    return _then(_$TaskSuggestionImpl(
      task: null == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      bestTimeSlot: freezed == bestTimeSlot
          ? _value.bestTimeSlot
          : bestTimeSlot // ignore: cast_nullable_to_non_nullable
              as SuggestedTimeSlot?,
      predictedMinutes: null == predictedMinutes
          ? _value.predictedMinutes
          : predictedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      completionProbability: null == completionProbability
          ? _value.completionProbability
          : completionProbability // ignore: cast_nullable_to_non_nullable
              as double,
      reasons: null == reasons
          ? _value._reasons
          : reasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskSuggestionImpl extends _TaskSuggestion {
  const _$TaskSuggestionImpl(
      {required this.task,
      required this.priorityScore,
      required this.bestTimeSlot,
      required this.predictedMinutes,
      required this.completionProbability,
      required final List<String> reasons})
      : _reasons = reasons,
        super._();

  factory _$TaskSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskSuggestionImplFromJson(json);

  @override
  final Task task;
  @override
  final double priorityScore;
  @override
  final SuggestedTimeSlot? bestTimeSlot;
  @override
  final int predictedMinutes;
  @override
  final double completionProbability;
  final List<String> _reasons;
  @override
  List<String> get reasons {
    if (_reasons is EqualUnmodifiableListView) return _reasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reasons);
  }

  @override
  String toString() {
    return 'TaskSuggestion(task: $task, priorityScore: $priorityScore, bestTimeSlot: $bestTimeSlot, predictedMinutes: $predictedMinutes, completionProbability: $completionProbability, reasons: $reasons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskSuggestionImpl &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.priorityScore, priorityScore) ||
                other.priorityScore == priorityScore) &&
            (identical(other.bestTimeSlot, bestTimeSlot) ||
                other.bestTimeSlot == bestTimeSlot) &&
            (identical(other.predictedMinutes, predictedMinutes) ||
                other.predictedMinutes == predictedMinutes) &&
            (identical(other.completionProbability, completionProbability) ||
                other.completionProbability == completionProbability) &&
            const DeepCollectionEquality().equals(other._reasons, _reasons));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      task,
      priorityScore,
      bestTimeSlot,
      predictedMinutes,
      completionProbability,
      const DeepCollectionEquality().hash(_reasons));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskSuggestionImplCopyWith<_$TaskSuggestionImpl> get copyWith =>
      __$$TaskSuggestionImplCopyWithImpl<_$TaskSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskSuggestionImplToJson(
      this,
    );
  }
}

abstract class _TaskSuggestion extends TaskSuggestion {
  const factory _TaskSuggestion(
      {required final Task task,
      required final double priorityScore,
      required final SuggestedTimeSlot? bestTimeSlot,
      required final int predictedMinutes,
      required final double completionProbability,
      required final List<String> reasons}) = _$TaskSuggestionImpl;
  const _TaskSuggestion._() : super._();

  factory _TaskSuggestion.fromJson(Map<String, dynamic> json) =
      _$TaskSuggestionImpl.fromJson;

  @override
  Task get task;
  @override
  double get priorityScore;
  @override
  SuggestedTimeSlot? get bestTimeSlot;
  @override
  int get predictedMinutes;
  @override
  double get completionProbability;
  @override
  List<String> get reasons;
  @override
  @JsonKey(ignore: true)
  _$$TaskSuggestionImplCopyWith<_$TaskSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestedTimeSlot _$SuggestedTimeSlotFromJson(Map<String, dynamic> json) {
  return _SuggestedTimeSlot.fromJson(json);
}

/// @nodoc
mixin _$SuggestedTimeSlot {
  int get hourOfDay => throw _privateConstructorUsedError;
  String get timeLabel => throw _privateConstructorUsedError;
  double get successRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuggestedTimeSlotCopyWith<SuggestedTimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedTimeSlotCopyWith<$Res> {
  factory $SuggestedTimeSlotCopyWith(
          SuggestedTimeSlot value, $Res Function(SuggestedTimeSlot) then) =
      _$SuggestedTimeSlotCopyWithImpl<$Res, SuggestedTimeSlot>;
  @useResult
  $Res call({int hourOfDay, String timeLabel, double successRate});
}

/// @nodoc
class _$SuggestedTimeSlotCopyWithImpl<$Res, $Val extends SuggestedTimeSlot>
    implements $SuggestedTimeSlotCopyWith<$Res> {
  _$SuggestedTimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hourOfDay = null,
    Object? timeLabel = null,
    Object? successRate = null,
  }) {
    return _then(_value.copyWith(
      hourOfDay: null == hourOfDay
          ? _value.hourOfDay
          : hourOfDay // ignore: cast_nullable_to_non_nullable
              as int,
      timeLabel: null == timeLabel
          ? _value.timeLabel
          : timeLabel // ignore: cast_nullable_to_non_nullable
              as String,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestedTimeSlotImplCopyWith<$Res>
    implements $SuggestedTimeSlotCopyWith<$Res> {
  factory _$$SuggestedTimeSlotImplCopyWith(_$SuggestedTimeSlotImpl value,
          $Res Function(_$SuggestedTimeSlotImpl) then) =
      __$$SuggestedTimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hourOfDay, String timeLabel, double successRate});
}

/// @nodoc
class __$$SuggestedTimeSlotImplCopyWithImpl<$Res>
    extends _$SuggestedTimeSlotCopyWithImpl<$Res, _$SuggestedTimeSlotImpl>
    implements _$$SuggestedTimeSlotImplCopyWith<$Res> {
  __$$SuggestedTimeSlotImplCopyWithImpl(_$SuggestedTimeSlotImpl _value,
      $Res Function(_$SuggestedTimeSlotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hourOfDay = null,
    Object? timeLabel = null,
    Object? successRate = null,
  }) {
    return _then(_$SuggestedTimeSlotImpl(
      hourOfDay: null == hourOfDay
          ? _value.hourOfDay
          : hourOfDay // ignore: cast_nullable_to_non_nullable
              as int,
      timeLabel: null == timeLabel
          ? _value.timeLabel
          : timeLabel // ignore: cast_nullable_to_non_nullable
              as String,
      successRate: null == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedTimeSlotImpl extends _SuggestedTimeSlot {
  const _$SuggestedTimeSlotImpl(
      {required this.hourOfDay,
      required this.timeLabel,
      required this.successRate})
      : super._();

  factory _$SuggestedTimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestedTimeSlotImplFromJson(json);

  @override
  final int hourOfDay;
  @override
  final String timeLabel;
  @override
  final double successRate;

  @override
  String toString() {
    return 'SuggestedTimeSlot(hourOfDay: $hourOfDay, timeLabel: $timeLabel, successRate: $successRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedTimeSlotImpl &&
            (identical(other.hourOfDay, hourOfDay) ||
                other.hourOfDay == hourOfDay) &&
            (identical(other.timeLabel, timeLabel) ||
                other.timeLabel == timeLabel) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hourOfDay, timeLabel, successRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedTimeSlotImplCopyWith<_$SuggestedTimeSlotImpl> get copyWith =>
      __$$SuggestedTimeSlotImplCopyWithImpl<_$SuggestedTimeSlotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedTimeSlotImplToJson(
      this,
    );
  }
}

abstract class _SuggestedTimeSlot extends SuggestedTimeSlot {
  const factory _SuggestedTimeSlot(
      {required final int hourOfDay,
      required final String timeLabel,
      required final double successRate}) = _$SuggestedTimeSlotImpl;
  const _SuggestedTimeSlot._() : super._();

  factory _SuggestedTimeSlot.fromJson(Map<String, dynamic> json) =
      _$SuggestedTimeSlotImpl.fromJson;

  @override
  int get hourOfDay;
  @override
  String get timeLabel;
  @override
  double get successRate;
  @override
  @JsonKey(ignore: true)
  _$$SuggestedTimeSlotImplCopyWith<_$SuggestedTimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
