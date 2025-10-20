// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Interruption _$InterruptionFromJson(Map<String, dynamic> json) {
  return _Interruption.fromJson(json);
}

/// @nodoc
mixin _$Interruption {
  @HiveField(0)
  DateTime get timestamp => throw _privateConstructorUsedError;
  @HiveField(1)
  String get reason => throw _privateConstructorUsedError;
  @HiveField(2)
  int? get resumedAfterSeconds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InterruptionCopyWith<Interruption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterruptionCopyWith<$Res> {
  factory $InterruptionCopyWith(
          Interruption value, $Res Function(Interruption) then) =
      _$InterruptionCopyWithImpl<$Res, Interruption>;
  @useResult
  $Res call(
      {@HiveField(0) DateTime timestamp,
      @HiveField(1) String reason,
      @HiveField(2) int? resumedAfterSeconds});
}

/// @nodoc
class _$InterruptionCopyWithImpl<$Res, $Val extends Interruption>
    implements $InterruptionCopyWith<$Res> {
  _$InterruptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? reason = null,
    Object? resumedAfterSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      resumedAfterSeconds: freezed == resumedAfterSeconds
          ? _value.resumedAfterSeconds
          : resumedAfterSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InterruptionImplCopyWith<$Res>
    implements $InterruptionCopyWith<$Res> {
  factory _$$InterruptionImplCopyWith(
          _$InterruptionImpl value, $Res Function(_$InterruptionImpl) then) =
      __$$InterruptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) DateTime timestamp,
      @HiveField(1) String reason,
      @HiveField(2) int? resumedAfterSeconds});
}

/// @nodoc
class __$$InterruptionImplCopyWithImpl<$Res>
    extends _$InterruptionCopyWithImpl<$Res, _$InterruptionImpl>
    implements _$$InterruptionImplCopyWith<$Res> {
  __$$InterruptionImplCopyWithImpl(
      _$InterruptionImpl _value, $Res Function(_$InterruptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? reason = null,
    Object? resumedAfterSeconds = freezed,
  }) {
    return _then(_$InterruptionImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      resumedAfterSeconds: freezed == resumedAfterSeconds
          ? _value.resumedAfterSeconds
          : resumedAfterSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InterruptionImpl extends _Interruption {
  const _$InterruptionImpl(
      {@HiveField(0) required this.timestamp,
      @HiveField(1) required this.reason,
      @HiveField(2) this.resumedAfterSeconds})
      : super._();

  factory _$InterruptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterruptionImplFromJson(json);

  @override
  @HiveField(0)
  final DateTime timestamp;
  @override
  @HiveField(1)
  final String reason;
  @override
  @HiveField(2)
  final int? resumedAfterSeconds;

  @override
  String toString() {
    return 'Interruption(timestamp: $timestamp, reason: $reason, resumedAfterSeconds: $resumedAfterSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterruptionImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.resumedAfterSeconds, resumedAfterSeconds) ||
                other.resumedAfterSeconds == resumedAfterSeconds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, timestamp, reason, resumedAfterSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InterruptionImplCopyWith<_$InterruptionImpl> get copyWith =>
      __$$InterruptionImplCopyWithImpl<_$InterruptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InterruptionImplToJson(
      this,
    );
  }
}

abstract class _Interruption extends Interruption {
  const factory _Interruption(
      {@HiveField(0) required final DateTime timestamp,
      @HiveField(1) required final String reason,
      @HiveField(2) final int? resumedAfterSeconds}) = _$InterruptionImpl;
  const _Interruption._() : super._();

  factory _Interruption.fromJson(Map<String, dynamic> json) =
      _$InterruptionImpl.fromJson;

  @override
  @HiveField(0)
  DateTime get timestamp;
  @override
  @HiveField(1)
  String get reason;
  @override
  @HiveField(2)
  int? get resumedAfterSeconds;
  @override
  @JsonKey(ignore: true)
  _$$InterruptionImplCopyWith<_$InterruptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FocusSession _$FocusSessionFromJson(Map<String, dynamic> json) {
  return _FocusSession.fromJson(json);
}

/// @nodoc
mixin _$FocusSession {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(2)
  int get durationMinutes => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get startedAt => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get taskId => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isCompleted => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get wasCancelled => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(8)
  @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
  List<Interruption> get interruptions => throw _privateConstructorUsedError;
  @HiveField(9)
  int? get pausedSeconds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FocusSessionCopyWith<FocusSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusSessionCopyWith<$Res> {
  factory $FocusSessionCopyWith(
          FocusSession value, $Res Function(FocusSession) then) =
      _$FocusSessionCopyWithImpl<$Res, FocusSession>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(2) int durationMinutes,
      @HiveField(3) DateTime startedAt,
      @HiveField(1) String? taskId,
      @HiveField(4) DateTime? completedAt,
      @HiveField(5) bool isCompleted,
      @HiveField(6) bool wasCancelled,
      @HiveField(7) String? notes,
      @HiveField(8)
      @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
      List<Interruption> interruptions,
      @HiveField(9) int? pausedSeconds});
}

/// @nodoc
class _$FocusSessionCopyWithImpl<$Res, $Val extends FocusSession>
    implements $FocusSessionCopyWith<$Res> {
  _$FocusSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? durationMinutes = null,
    Object? startedAt = null,
    Object? taskId = freezed,
    Object? completedAt = freezed,
    Object? isCompleted = null,
    Object? wasCancelled = null,
    Object? notes = freezed,
    Object? interruptions = null,
    Object? pausedSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      wasCancelled: null == wasCancelled
          ? _value.wasCancelled
          : wasCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      interruptions: null == interruptions
          ? _value.interruptions
          : interruptions // ignore: cast_nullable_to_non_nullable
              as List<Interruption>,
      pausedSeconds: freezed == pausedSeconds
          ? _value.pausedSeconds
          : pausedSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FocusSessionImplCopyWith<$Res>
    implements $FocusSessionCopyWith<$Res> {
  factory _$$FocusSessionImplCopyWith(
          _$FocusSessionImpl value, $Res Function(_$FocusSessionImpl) then) =
      __$$FocusSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(2) int durationMinutes,
      @HiveField(3) DateTime startedAt,
      @HiveField(1) String? taskId,
      @HiveField(4) DateTime? completedAt,
      @HiveField(5) bool isCompleted,
      @HiveField(6) bool wasCancelled,
      @HiveField(7) String? notes,
      @HiveField(8)
      @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
      List<Interruption> interruptions,
      @HiveField(9) int? pausedSeconds});
}

/// @nodoc
class __$$FocusSessionImplCopyWithImpl<$Res>
    extends _$FocusSessionCopyWithImpl<$Res, _$FocusSessionImpl>
    implements _$$FocusSessionImplCopyWith<$Res> {
  __$$FocusSessionImplCopyWithImpl(
      _$FocusSessionImpl _value, $Res Function(_$FocusSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? durationMinutes = null,
    Object? startedAt = null,
    Object? taskId = freezed,
    Object? completedAt = freezed,
    Object? isCompleted = null,
    Object? wasCancelled = null,
    Object? notes = freezed,
    Object? interruptions = null,
    Object? pausedSeconds = freezed,
  }) {
    return _then(_$FocusSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      wasCancelled: null == wasCancelled
          ? _value.wasCancelled
          : wasCancelled // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      interruptions: null == interruptions
          ? _value._interruptions
          : interruptions // ignore: cast_nullable_to_non_nullable
              as List<Interruption>,
      pausedSeconds: freezed == pausedSeconds
          ? _value.pausedSeconds
          : pausedSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusSessionImpl extends _FocusSession {
  const _$FocusSessionImpl(
      {@HiveField(0) required this.id,
      @HiveField(2) required this.durationMinutes,
      @HiveField(3) required this.startedAt,
      @HiveField(1) this.taskId,
      @HiveField(4) this.completedAt,
      @HiveField(5) this.isCompleted = false,
      @HiveField(6) this.wasCancelled = false,
      @HiveField(7) this.notes,
      @HiveField(8)
      @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
      final List<Interruption> interruptions = const <Interruption>[],
      @HiveField(9) this.pausedSeconds})
      : _interruptions = interruptions,
        super._();

  factory _$FocusSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusSessionImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(2)
  final int durationMinutes;
  @override
  @HiveField(3)
  final DateTime startedAt;
  @override
  @HiveField(1)
  final String? taskId;
  @override
  @HiveField(4)
  final DateTime? completedAt;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isCompleted;
  @override
  @JsonKey()
  @HiveField(6)
  final bool wasCancelled;
  @override
  @HiveField(7)
  final String? notes;
  final List<Interruption> _interruptions;
  @override
  @HiveField(8)
  @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
  List<Interruption> get interruptions {
    if (_interruptions is EqualUnmodifiableListView) return _interruptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interruptions);
  }

  @override
  @HiveField(9)
  final int? pausedSeconds;

  @override
  String toString() {
    return 'FocusSession(id: $id, durationMinutes: $durationMinutes, startedAt: $startedAt, taskId: $taskId, completedAt: $completedAt, isCompleted: $isCompleted, wasCancelled: $wasCancelled, notes: $notes, interruptions: $interruptions, pausedSeconds: $pausedSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.wasCancelled, wasCancelled) ||
                other.wasCancelled == wasCancelled) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._interruptions, _interruptions) &&
            (identical(other.pausedSeconds, pausedSeconds) ||
                other.pausedSeconds == pausedSeconds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      durationMinutes,
      startedAt,
      taskId,
      completedAt,
      isCompleted,
      wasCancelled,
      notes,
      const DeepCollectionEquality().hash(_interruptions),
      pausedSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      __$$FocusSessionImplCopyWithImpl<_$FocusSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusSessionImplToJson(
      this,
    );
  }
}

abstract class _FocusSession extends FocusSession {
  const factory _FocusSession(
      {@HiveField(0) required final String id,
      @HiveField(2) required final int durationMinutes,
      @HiveField(3) required final DateTime startedAt,
      @HiveField(1) final String? taskId,
      @HiveField(4) final DateTime? completedAt,
      @HiveField(5) final bool isCompleted,
      @HiveField(6) final bool wasCancelled,
      @HiveField(7) final String? notes,
      @HiveField(8)
      @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
      final List<Interruption> interruptions,
      @HiveField(9) final int? pausedSeconds}) = _$FocusSessionImpl;
  const _FocusSession._() : super._();

  factory _FocusSession.fromJson(Map<String, dynamic> json) =
      _$FocusSessionImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(2)
  int get durationMinutes;
  @override
  @HiveField(3)
  DateTime get startedAt;
  @override
  @HiveField(1)
  String? get taskId;
  @override
  @HiveField(4)
  DateTime? get completedAt;
  @override
  @HiveField(5)
  bool get isCompleted;
  @override
  @HiveField(6)
  bool get wasCancelled;
  @override
  @HiveField(7)
  String? get notes;
  @override
  @HiveField(8)
  @JsonKey(fromJson: _interruptionsFromJson, toJson: _interruptionsToJson)
  List<Interruption> get interruptions;
  @override
  @HiveField(9)
  int? get pausedSeconds;
  @override
  @JsonKey(ignore: true)
  _$$FocusSessionImplCopyWith<_$FocusSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
