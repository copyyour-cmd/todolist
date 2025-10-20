// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(3)
  String get listId => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(4)
  List<String> get tagIds => throw _privateConstructorUsedError;
  @HiveField(5)
  TaskPriority get priority => throw _privateConstructorUsedError;
  @HiveField(6)
  TaskStatus get status => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get dueAt => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get remindAt => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
  List<SubTask> get subtasks => throw _privateConstructorUsedError;
  @HiveField(10)
  @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
  List<Attachment> get attachments => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @HiveField(14)
  int get version => throw _privateConstructorUsedError;
  @HiveField(15)
  @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
  RecurrenceRule? get recurrenceRule => throw _privateConstructorUsedError;
  @HiveField(16)
  String? get parentRecurringTaskId => throw _privateConstructorUsedError;
  @HiveField(17)
  int get recurrenceCount => throw _privateConstructorUsedError;
  @HiveField(18)
  int get sortOrder => throw _privateConstructorUsedError;
  @HiveField(19)
  int? get estimatedMinutes => throw _privateConstructorUsedError;
  @HiveField(20)
  int get actualMinutes => throw _privateConstructorUsedError;
  @HiveField(21)
  int get focusSessionCount => throw _privateConstructorUsedError;
  @HiveField(22)
  List<String> get smartReminderIds => throw _privateConstructorUsedError;
  @HiveField(23)
  ReminderMode get reminderMode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(3) String listId,
      @HiveField(12) DateTime createdAt,
      @HiveField(13) DateTime updatedAt,
      @HiveField(2) String? notes,
      @HiveField(4) List<String> tagIds,
      @HiveField(5) TaskPriority priority,
      @HiveField(6) TaskStatus status,
      @HiveField(7) DateTime? dueAt,
      @HiveField(8) DateTime? remindAt,
      @HiveField(9)
      @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
      List<SubTask> subtasks,
      @HiveField(10)
      @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
      List<Attachment> attachments,
      @HiveField(11) DateTime? completedAt,
      @HiveField(14) int version,
      @HiveField(15)
      @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
      RecurrenceRule? recurrenceRule,
      @HiveField(16) String? parentRecurringTaskId,
      @HiveField(17) int recurrenceCount,
      @HiveField(18) int sortOrder,
      @HiveField(19) int? estimatedMinutes,
      @HiveField(20) int actualMinutes,
      @HiveField(21) int focusSessionCount,
      @HiveField(22) List<String> smartReminderIds,
      @HiveField(23) ReminderMode reminderMode});

  $RecurrenceRuleCopyWith<$Res>? get recurrenceRule;
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? listId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? notes = freezed,
    Object? tagIds = null,
    Object? priority = null,
    Object? status = null,
    Object? dueAt = freezed,
    Object? remindAt = freezed,
    Object? subtasks = null,
    Object? attachments = null,
    Object? completedAt = freezed,
    Object? version = null,
    Object? recurrenceRule = freezed,
    Object? parentRecurringTaskId = freezed,
    Object? recurrenceCount = null,
    Object? sortOrder = null,
    Object? estimatedMinutes = freezed,
    Object? actualMinutes = null,
    Object? focusSessionCount = null,
    Object? smartReminderIds = null,
    Object? reminderMode = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tagIds: null == tagIds
          ? _value.tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      remindAt: freezed == remindAt
          ? _value.remindAt
          : remindAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subtasks: null == subtasks
          ? _value.subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<SubTask>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      recurrenceRule: freezed == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
      parentRecurringTaskId: freezed == parentRecurringTaskId
          ? _value.parentRecurringTaskId
          : parentRecurringTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceCount: null == recurrenceCount
          ? _value.recurrenceCount
          : recurrenceCount // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedMinutes: freezed == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      actualMinutes: null == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      focusSessionCount: null == focusSessionCount
          ? _value.focusSessionCount
          : focusSessionCount // ignore: cast_nullable_to_non_nullable
              as int,
      smartReminderIds: null == smartReminderIds
          ? _value.smartReminderIds
          : smartReminderIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reminderMode: null == reminderMode
          ? _value.reminderMode
          : reminderMode // ignore: cast_nullable_to_non_nullable
              as ReminderMode,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RecurrenceRuleCopyWith<$Res>? get recurrenceRule {
    if (_value.recurrenceRule == null) {
      return null;
    }

    return $RecurrenceRuleCopyWith<$Res>(_value.recurrenceRule!, (value) {
      return _then(_value.copyWith(recurrenceRule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(3) String listId,
      @HiveField(12) DateTime createdAt,
      @HiveField(13) DateTime updatedAt,
      @HiveField(2) String? notes,
      @HiveField(4) List<String> tagIds,
      @HiveField(5) TaskPriority priority,
      @HiveField(6) TaskStatus status,
      @HiveField(7) DateTime? dueAt,
      @HiveField(8) DateTime? remindAt,
      @HiveField(9)
      @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
      List<SubTask> subtasks,
      @HiveField(10)
      @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
      List<Attachment> attachments,
      @HiveField(11) DateTime? completedAt,
      @HiveField(14) int version,
      @HiveField(15)
      @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
      RecurrenceRule? recurrenceRule,
      @HiveField(16) String? parentRecurringTaskId,
      @HiveField(17) int recurrenceCount,
      @HiveField(18) int sortOrder,
      @HiveField(19) int? estimatedMinutes,
      @HiveField(20) int actualMinutes,
      @HiveField(21) int focusSessionCount,
      @HiveField(22) List<String> smartReminderIds,
      @HiveField(23) ReminderMode reminderMode});

  @override
  $RecurrenceRuleCopyWith<$Res>? get recurrenceRule;
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? listId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? notes = freezed,
    Object? tagIds = null,
    Object? priority = null,
    Object? status = null,
    Object? dueAt = freezed,
    Object? remindAt = freezed,
    Object? subtasks = null,
    Object? attachments = null,
    Object? completedAt = freezed,
    Object? version = null,
    Object? recurrenceRule = freezed,
    Object? parentRecurringTaskId = freezed,
    Object? recurrenceCount = null,
    Object? sortOrder = null,
    Object? estimatedMinutes = freezed,
    Object? actualMinutes = null,
    Object? focusSessionCount = null,
    Object? smartReminderIds = null,
    Object? reminderMode = null,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tagIds: null == tagIds
          ? _value._tagIds
          : tagIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      remindAt: freezed == remindAt
          ? _value.remindAt
          : remindAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subtasks: null == subtasks
          ? _value._subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<SubTask>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Attachment>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      recurrenceRule: freezed == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
      parentRecurringTaskId: freezed == parentRecurringTaskId
          ? _value.parentRecurringTaskId
          : parentRecurringTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      recurrenceCount: null == recurrenceCount
          ? _value.recurrenceCount
          : recurrenceCount // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedMinutes: freezed == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      actualMinutes: null == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      focusSessionCount: null == focusSessionCount
          ? _value.focusSessionCount
          : focusSessionCount // ignore: cast_nullable_to_non_nullable
              as int,
      smartReminderIds: null == smartReminderIds
          ? _value._smartReminderIds
          : smartReminderIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reminderMode: null == reminderMode
          ? _value.reminderMode
          : reminderMode // ignore: cast_nullable_to_non_nullable
              as ReminderMode,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl extends _Task {
  const _$TaskImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(3) required this.listId,
      @HiveField(12) required this.createdAt,
      @HiveField(13) required this.updatedAt,
      @HiveField(2) this.notes,
      @HiveField(4) final List<String> tagIds = const <String>[],
      @HiveField(5) this.priority = TaskPriority.none,
      @HiveField(6) this.status = TaskStatus.pending,
      @HiveField(7) this.dueAt,
      @HiveField(8) this.remindAt,
      @HiveField(9)
      @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
      final List<SubTask> subtasks = const <SubTask>[],
      @HiveField(10)
      @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
      final List<Attachment> attachments = const <Attachment>[],
      @HiveField(11) this.completedAt,
      @HiveField(14) this.version = 0,
      @HiveField(15)
      @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
      this.recurrenceRule,
      @HiveField(16) this.parentRecurringTaskId,
      @HiveField(17) this.recurrenceCount = 0,
      @HiveField(18) this.sortOrder = 0,
      @HiveField(19) this.estimatedMinutes,
      @HiveField(20) this.actualMinutes = 0,
      @HiveField(21) this.focusSessionCount = 0,
      @HiveField(22) final List<String> smartReminderIds = const <String>[],
      @HiveField(23) this.reminderMode = ReminderMode.notification})
      : _tagIds = tagIds,
        _subtasks = subtasks,
        _attachments = attachments,
        _smartReminderIds = smartReminderIds,
        super._();

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(3)
  final String listId;
  @override
  @HiveField(12)
  final DateTime createdAt;
  @override
  @HiveField(13)
  final DateTime updatedAt;
  @override
  @HiveField(2)
  final String? notes;
  final List<String> _tagIds;
  @override
  @JsonKey()
  @HiveField(4)
  List<String> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  @override
  @JsonKey()
  @HiveField(5)
  final TaskPriority priority;
  @override
  @JsonKey()
  @HiveField(6)
  final TaskStatus status;
  @override
  @HiveField(7)
  final DateTime? dueAt;
  @override
  @HiveField(8)
  final DateTime? remindAt;
  final List<SubTask> _subtasks;
  @override
  @HiveField(9)
  @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
  List<SubTask> get subtasks {
    if (_subtasks is EqualUnmodifiableListView) return _subtasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtasks);
  }

  final List<Attachment> _attachments;
  @override
  @HiveField(10)
  @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
  List<Attachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @HiveField(11)
  final DateTime? completedAt;
  @override
  @JsonKey()
  @HiveField(14)
  final int version;
  @override
  @HiveField(15)
  @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
  final RecurrenceRule? recurrenceRule;
  @override
  @HiveField(16)
  final String? parentRecurringTaskId;
  @override
  @JsonKey()
  @HiveField(17)
  final int recurrenceCount;
  @override
  @JsonKey()
  @HiveField(18)
  final int sortOrder;
  @override
  @HiveField(19)
  final int? estimatedMinutes;
  @override
  @JsonKey()
  @HiveField(20)
  final int actualMinutes;
  @override
  @JsonKey()
  @HiveField(21)
  final int focusSessionCount;
  final List<String> _smartReminderIds;
  @override
  @JsonKey()
  @HiveField(22)
  List<String> get smartReminderIds {
    if (_smartReminderIds is EqualUnmodifiableListView)
      return _smartReminderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_smartReminderIds);
  }

  @override
  @JsonKey()
  @HiveField(23)
  final ReminderMode reminderMode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, listId: $listId, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, tagIds: $tagIds, priority: $priority, status: $status, dueAt: $dueAt, remindAt: $remindAt, subtasks: $subtasks, attachments: $attachments, completedAt: $completedAt, version: $version, recurrenceRule: $recurrenceRule, parentRecurringTaskId: $parentRecurringTaskId, recurrenceCount: $recurrenceCount, sortOrder: $sortOrder, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, focusSessionCount: $focusSessionCount, smartReminderIds: $smartReminderIds, reminderMode: $reminderMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.listId, listId) || other.listId == listId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._tagIds, _tagIds) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.remindAt, remindAt) ||
                other.remindAt == remindAt) &&
            const DeepCollectionEquality().equals(other._subtasks, _subtasks) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.parentRecurringTaskId, parentRecurringTaskId) ||
                other.parentRecurringTaskId == parentRecurringTaskId) &&
            (identical(other.recurrenceCount, recurrenceCount) ||
                other.recurrenceCount == recurrenceCount) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes) &&
            (identical(other.focusSessionCount, focusSessionCount) ||
                other.focusSessionCount == focusSessionCount) &&
            const DeepCollectionEquality()
                .equals(other._smartReminderIds, _smartReminderIds) &&
            (identical(other.reminderMode, reminderMode) ||
                other.reminderMode == reminderMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        listId,
        createdAt,
        updatedAt,
        notes,
        const DeepCollectionEquality().hash(_tagIds),
        priority,
        status,
        dueAt,
        remindAt,
        const DeepCollectionEquality().hash(_subtasks),
        const DeepCollectionEquality().hash(_attachments),
        completedAt,
        version,
        recurrenceRule,
        parentRecurringTaskId,
        recurrenceCount,
        sortOrder,
        estimatedMinutes,
        actualMinutes,
        focusSessionCount,
        const DeepCollectionEquality().hash(_smartReminderIds),
        reminderMode
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task extends Task {
  const factory _Task(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(3) required final String listId,
      @HiveField(12) required final DateTime createdAt,
      @HiveField(13) required final DateTime updatedAt,
      @HiveField(2) final String? notes,
      @HiveField(4) final List<String> tagIds,
      @HiveField(5) final TaskPriority priority,
      @HiveField(6) final TaskStatus status,
      @HiveField(7) final DateTime? dueAt,
      @HiveField(8) final DateTime? remindAt,
      @HiveField(9)
      @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
      final List<SubTask> subtasks,
      @HiveField(10)
      @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
      final List<Attachment> attachments,
      @HiveField(11) final DateTime? completedAt,
      @HiveField(14) final int version,
      @HiveField(15)
      @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
      final RecurrenceRule? recurrenceRule,
      @HiveField(16) final String? parentRecurringTaskId,
      @HiveField(17) final int recurrenceCount,
      @HiveField(18) final int sortOrder,
      @HiveField(19) final int? estimatedMinutes,
      @HiveField(20) final int actualMinutes,
      @HiveField(21) final int focusSessionCount,
      @HiveField(22) final List<String> smartReminderIds,
      @HiveField(23) final ReminderMode reminderMode}) = _$TaskImpl;
  const _Task._() : super._();

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(3)
  String get listId;
  @override
  @HiveField(12)
  DateTime get createdAt;
  @override
  @HiveField(13)
  DateTime get updatedAt;
  @override
  @HiveField(2)
  String? get notes;
  @override
  @HiveField(4)
  List<String> get tagIds;
  @override
  @HiveField(5)
  TaskPriority get priority;
  @override
  @HiveField(6)
  TaskStatus get status;
  @override
  @HiveField(7)
  DateTime? get dueAt;
  @override
  @HiveField(8)
  DateTime? get remindAt;
  @override
  @HiveField(9)
  @JsonKey(fromJson: _subTasksFromJson, toJson: _subTasksToJson)
  List<SubTask> get subtasks;
  @override
  @HiveField(10)
  @JsonKey(fromJson: _attachmentsFromJson, toJson: _attachmentsToJson)
  List<Attachment> get attachments;
  @override
  @HiveField(11)
  DateTime? get completedAt;
  @override
  @HiveField(14)
  int get version;
  @override
  @HiveField(15)
  @JsonKey(fromJson: _recurrenceRuleFromJson, toJson: _recurrenceRuleToJson)
  RecurrenceRule? get recurrenceRule;
  @override
  @HiveField(16)
  String? get parentRecurringTaskId;
  @override
  @HiveField(17)
  int get recurrenceCount;
  @override
  @HiveField(18)
  int get sortOrder;
  @override
  @HiveField(19)
  int? get estimatedMinutes;
  @override
  @HiveField(20)
  int get actualMinutes;
  @override
  @HiveField(21)
  int get focusSessionCount;
  @override
  @HiveField(22)
  List<String> get smartReminderIds;
  @override
  @HiveField(23)
  ReminderMode get reminderMode;
  @override
  @JsonKey(ignore: true)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
