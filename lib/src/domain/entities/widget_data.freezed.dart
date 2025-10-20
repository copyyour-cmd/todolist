// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WidgetData _$WidgetDataFromJson(Map<String, dynamic> json) {
  return _WidgetData.fromJson(json);
}

/// @nodoc
mixin _$WidgetData {
  WidgetType get type => throw _privateConstructorUsedError;
  String get widgetId => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WidgetDataCopyWith<WidgetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WidgetDataCopyWith<$Res> {
  factory $WidgetDataCopyWith(
          WidgetData value, $Res Function(WidgetData) then) =
      _$WidgetDataCopyWithImpl<$Res, WidgetData>;
  @useResult
  $Res call(
      {WidgetType type,
      String widgetId,
      Map<String, dynamic> data,
      DateTime lastUpdated});
}

/// @nodoc
class _$WidgetDataCopyWithImpl<$Res, $Val extends WidgetData>
    implements $WidgetDataCopyWith<$Res> {
  _$WidgetDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? widgetId = null,
    Object? data = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WidgetType,
      widgetId: null == widgetId
          ? _value.widgetId
          : widgetId // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WidgetDataImplCopyWith<$Res>
    implements $WidgetDataCopyWith<$Res> {
  factory _$$WidgetDataImplCopyWith(
          _$WidgetDataImpl value, $Res Function(_$WidgetDataImpl) then) =
      __$$WidgetDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WidgetType type,
      String widgetId,
      Map<String, dynamic> data,
      DateTime lastUpdated});
}

/// @nodoc
class __$$WidgetDataImplCopyWithImpl<$Res>
    extends _$WidgetDataCopyWithImpl<$Res, _$WidgetDataImpl>
    implements _$$WidgetDataImplCopyWith<$Res> {
  __$$WidgetDataImplCopyWithImpl(
      _$WidgetDataImpl _value, $Res Function(_$WidgetDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? widgetId = null,
    Object? data = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$WidgetDataImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WidgetType,
      widgetId: null == widgetId
          ? _value.widgetId
          : widgetId // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WidgetDataImpl implements _WidgetData {
  const _$WidgetDataImpl(
      {required this.type,
      required this.widgetId,
      required final Map<String, dynamic> data,
      required this.lastUpdated})
      : _data = data;

  factory _$WidgetDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$WidgetDataImplFromJson(json);

  @override
  final WidgetType type;
  @override
  final String widgetId;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'WidgetData(type: $type, widgetId: $widgetId, data: $data, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WidgetDataImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.widgetId, widgetId) ||
                other.widgetId == widgetId) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, widgetId,
      const DeepCollectionEquality().hash(_data), lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WidgetDataImplCopyWith<_$WidgetDataImpl> get copyWith =>
      __$$WidgetDataImplCopyWithImpl<_$WidgetDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WidgetDataImplToJson(
      this,
    );
  }
}

abstract class _WidgetData implements WidgetData {
  const factory _WidgetData(
      {required final WidgetType type,
      required final String widgetId,
      required final Map<String, dynamic> data,
      required final DateTime lastUpdated}) = _$WidgetDataImpl;

  factory _WidgetData.fromJson(Map<String, dynamic> json) =
      _$WidgetDataImpl.fromJson;

  @override
  WidgetType get type;
  @override
  String get widgetId;
  @override
  Map<String, dynamic> get data;
  @override
  DateTime get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$WidgetDataImplCopyWith<_$WidgetDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TodayTasksWidgetData _$TodayTasksWidgetDataFromJson(Map<String, dynamic> json) {
  return _TodayTasksWidgetData.fromJson(json);
}

/// @nodoc
mixin _$TodayTasksWidgetData {
  int get totalTasks => throw _privateConstructorUsedError;
  int get completedTasks => throw _privateConstructorUsedError;
  List<TaskWidgetItem> get tasks => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TodayTasksWidgetDataCopyWith<TodayTasksWidgetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodayTasksWidgetDataCopyWith<$Res> {
  factory $TodayTasksWidgetDataCopyWith(TodayTasksWidgetData value,
          $Res Function(TodayTasksWidgetData) then) =
      _$TodayTasksWidgetDataCopyWithImpl<$Res, TodayTasksWidgetData>;
  @useResult
  $Res call({int totalTasks, int completedTasks, List<TaskWidgetItem> tasks});
}

/// @nodoc
class _$TodayTasksWidgetDataCopyWithImpl<$Res,
        $Val extends TodayTasksWidgetData>
    implements $TodayTasksWidgetDataCopyWith<$Res> {
  _$TodayTasksWidgetDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTasks = null,
    Object? completedTasks = null,
    Object? tasks = null,
  }) {
    return _then(_value.copyWith(
      totalTasks: null == totalTasks
          ? _value.totalTasks
          : totalTasks // ignore: cast_nullable_to_non_nullable
              as int,
      completedTasks: null == completedTasks
          ? _value.completedTasks
          : completedTasks // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskWidgetItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodayTasksWidgetDataImplCopyWith<$Res>
    implements $TodayTasksWidgetDataCopyWith<$Res> {
  factory _$$TodayTasksWidgetDataImplCopyWith(_$TodayTasksWidgetDataImpl value,
          $Res Function(_$TodayTasksWidgetDataImpl) then) =
      __$$TodayTasksWidgetDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalTasks, int completedTasks, List<TaskWidgetItem> tasks});
}

/// @nodoc
class __$$TodayTasksWidgetDataImplCopyWithImpl<$Res>
    extends _$TodayTasksWidgetDataCopyWithImpl<$Res, _$TodayTasksWidgetDataImpl>
    implements _$$TodayTasksWidgetDataImplCopyWith<$Res> {
  __$$TodayTasksWidgetDataImplCopyWithImpl(_$TodayTasksWidgetDataImpl _value,
      $Res Function(_$TodayTasksWidgetDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTasks = null,
    Object? completedTasks = null,
    Object? tasks = null,
  }) {
    return _then(_$TodayTasksWidgetDataImpl(
      totalTasks: null == totalTasks
          ? _value.totalTasks
          : totalTasks // ignore: cast_nullable_to_non_nullable
              as int,
      completedTasks: null == completedTasks
          ? _value.completedTasks
          : completedTasks // ignore: cast_nullable_to_non_nullable
              as int,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskWidgetItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodayTasksWidgetDataImpl extends _TodayTasksWidgetData {
  const _$TodayTasksWidgetDataImpl(
      {required this.totalTasks,
      required this.completedTasks,
      required final List<TaskWidgetItem> tasks})
      : _tasks = tasks,
        super._();

  factory _$TodayTasksWidgetDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodayTasksWidgetDataImplFromJson(json);

  @override
  final int totalTasks;
  @override
  final int completedTasks;
  final List<TaskWidgetItem> _tasks;
  @override
  List<TaskWidgetItem> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'TodayTasksWidgetData(totalTasks: $totalTasks, completedTasks: $completedTasks, tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodayTasksWidgetDataImpl &&
            (identical(other.totalTasks, totalTasks) ||
                other.totalTasks == totalTasks) &&
            (identical(other.completedTasks, completedTasks) ||
                other.completedTasks == completedTasks) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalTasks, completedTasks,
      const DeepCollectionEquality().hash(_tasks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodayTasksWidgetDataImplCopyWith<_$TodayTasksWidgetDataImpl>
      get copyWith =>
          __$$TodayTasksWidgetDataImplCopyWithImpl<_$TodayTasksWidgetDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodayTasksWidgetDataImplToJson(
      this,
    );
  }
}

abstract class _TodayTasksWidgetData extends TodayTasksWidgetData {
  const factory _TodayTasksWidgetData(
      {required final int totalTasks,
      required final int completedTasks,
      required final List<TaskWidgetItem> tasks}) = _$TodayTasksWidgetDataImpl;
  const _TodayTasksWidgetData._() : super._();

  factory _TodayTasksWidgetData.fromJson(Map<String, dynamic> json) =
      _$TodayTasksWidgetDataImpl.fromJson;

  @override
  int get totalTasks;
  @override
  int get completedTasks;
  @override
  List<TaskWidgetItem> get tasks;
  @override
  @JsonKey(ignore: true)
  _$$TodayTasksWidgetDataImplCopyWith<_$TodayTasksWidgetDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TaskWidgetItem _$TaskWidgetItemFromJson(Map<String, dynamic> json) {
  return _TaskWidgetItem.fromJson(json);
}

/// @nodoc
mixin _$TaskWidgetItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  String? get priority => throw _privateConstructorUsedError;
  DateTime? get dueAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskWidgetItemCopyWith<TaskWidgetItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskWidgetItemCopyWith<$Res> {
  factory $TaskWidgetItemCopyWith(
          TaskWidgetItem value, $Res Function(TaskWidgetItem) then) =
      _$TaskWidgetItemCopyWithImpl<$Res, TaskWidgetItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      bool isCompleted,
      String? priority,
      DateTime? dueAt});
}

/// @nodoc
class _$TaskWidgetItemCopyWithImpl<$Res, $Val extends TaskWidgetItem>
    implements $TaskWidgetItemCopyWith<$Res> {
  _$TaskWidgetItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? priority = freezed,
    Object? dueAt = freezed,
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
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskWidgetItemImplCopyWith<$Res>
    implements $TaskWidgetItemCopyWith<$Res> {
  factory _$$TaskWidgetItemImplCopyWith(_$TaskWidgetItemImpl value,
          $Res Function(_$TaskWidgetItemImpl) then) =
      __$$TaskWidgetItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      bool isCompleted,
      String? priority,
      DateTime? dueAt});
}

/// @nodoc
class __$$TaskWidgetItemImplCopyWithImpl<$Res>
    extends _$TaskWidgetItemCopyWithImpl<$Res, _$TaskWidgetItemImpl>
    implements _$$TaskWidgetItemImplCopyWith<$Res> {
  __$$TaskWidgetItemImplCopyWithImpl(
      _$TaskWidgetItemImpl _value, $Res Function(_$TaskWidgetItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? priority = freezed,
    Object? dueAt = freezed,
  }) {
    return _then(_$TaskWidgetItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskWidgetItemImpl implements _TaskWidgetItem {
  const _$TaskWidgetItemImpl(
      {required this.id,
      required this.title,
      required this.isCompleted,
      this.priority,
      this.dueAt});

  factory _$TaskWidgetItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskWidgetItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final bool isCompleted;
  @override
  final String? priority;
  @override
  final DateTime? dueAt;

  @override
  String toString() {
    return 'TaskWidgetItem(id: $id, title: $title, isCompleted: $isCompleted, priority: $priority, dueAt: $dueAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskWidgetItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, isCompleted, priority, dueAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskWidgetItemImplCopyWith<_$TaskWidgetItemImpl> get copyWith =>
      __$$TaskWidgetItemImplCopyWithImpl<_$TaskWidgetItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskWidgetItemImplToJson(
      this,
    );
  }
}

abstract class _TaskWidgetItem implements TaskWidgetItem {
  const factory _TaskWidgetItem(
      {required final String id,
      required final String title,
      required final bool isCompleted,
      final String? priority,
      final DateTime? dueAt}) = _$TaskWidgetItemImpl;

  factory _TaskWidgetItem.fromJson(Map<String, dynamic> json) =
      _$TaskWidgetItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  String? get priority;
  @override
  DateTime? get dueAt;
  @override
  @JsonKey(ignore: true)
  _$$TaskWidgetItemImplCopyWith<_$TaskWidgetItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FocusStatsWidgetData _$FocusStatsWidgetDataFromJson(Map<String, dynamic> json) {
  return _FocusStatsWidgetData.fromJson(json);
}

/// @nodoc
mixin _$FocusStatsWidgetData {
  int get todayMinutes => throw _privateConstructorUsedError;
  int get todaySessions => throw _privateConstructorUsedError;
  int get weekMinutes => throw _privateConstructorUsedError;
  int get totalMinutes => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FocusStatsWidgetDataCopyWith<FocusStatsWidgetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FocusStatsWidgetDataCopyWith<$Res> {
  factory $FocusStatsWidgetDataCopyWith(FocusStatsWidgetData value,
          $Res Function(FocusStatsWidgetData) then) =
      _$FocusStatsWidgetDataCopyWithImpl<$Res, FocusStatsWidgetData>;
  @useResult
  $Res call(
      {int todayMinutes,
      int todaySessions,
      int weekMinutes,
      int totalMinutes,
      int currentStreak});
}

/// @nodoc
class _$FocusStatsWidgetDataCopyWithImpl<$Res,
        $Val extends FocusStatsWidgetData>
    implements $FocusStatsWidgetDataCopyWith<$Res> {
  _$FocusStatsWidgetDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayMinutes = null,
    Object? todaySessions = null,
    Object? weekMinutes = null,
    Object? totalMinutes = null,
    Object? currentStreak = null,
  }) {
    return _then(_value.copyWith(
      todayMinutes: null == todayMinutes
          ? _value.todayMinutes
          : todayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      todaySessions: null == todaySessions
          ? _value.todaySessions
          : todaySessions // ignore: cast_nullable_to_non_nullable
              as int,
      weekMinutes: null == weekMinutes
          ? _value.weekMinutes
          : weekMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FocusStatsWidgetDataImplCopyWith<$Res>
    implements $FocusStatsWidgetDataCopyWith<$Res> {
  factory _$$FocusStatsWidgetDataImplCopyWith(_$FocusStatsWidgetDataImpl value,
          $Res Function(_$FocusStatsWidgetDataImpl) then) =
      __$$FocusStatsWidgetDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int todayMinutes,
      int todaySessions,
      int weekMinutes,
      int totalMinutes,
      int currentStreak});
}

/// @nodoc
class __$$FocusStatsWidgetDataImplCopyWithImpl<$Res>
    extends _$FocusStatsWidgetDataCopyWithImpl<$Res, _$FocusStatsWidgetDataImpl>
    implements _$$FocusStatsWidgetDataImplCopyWith<$Res> {
  __$$FocusStatsWidgetDataImplCopyWithImpl(_$FocusStatsWidgetDataImpl _value,
      $Res Function(_$FocusStatsWidgetDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayMinutes = null,
    Object? todaySessions = null,
    Object? weekMinutes = null,
    Object? totalMinutes = null,
    Object? currentStreak = null,
  }) {
    return _then(_$FocusStatsWidgetDataImpl(
      todayMinutes: null == todayMinutes
          ? _value.todayMinutes
          : todayMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      todaySessions: null == todaySessions
          ? _value.todaySessions
          : todaySessions // ignore: cast_nullable_to_non_nullable
              as int,
      weekMinutes: null == weekMinutes
          ? _value.weekMinutes
          : weekMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutes: null == totalMinutes
          ? _value.totalMinutes
          : totalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FocusStatsWidgetDataImpl extends _FocusStatsWidgetData {
  const _$FocusStatsWidgetDataImpl(
      {required this.todayMinutes,
      required this.todaySessions,
      required this.weekMinutes,
      required this.totalMinutes,
      required this.currentStreak})
      : super._();

  factory _$FocusStatsWidgetDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FocusStatsWidgetDataImplFromJson(json);

  @override
  final int todayMinutes;
  @override
  final int todaySessions;
  @override
  final int weekMinutes;
  @override
  final int totalMinutes;
  @override
  final int currentStreak;

  @override
  String toString() {
    return 'FocusStatsWidgetData(todayMinutes: $todayMinutes, todaySessions: $todaySessions, weekMinutes: $weekMinutes, totalMinutes: $totalMinutes, currentStreak: $currentStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FocusStatsWidgetDataImpl &&
            (identical(other.todayMinutes, todayMinutes) ||
                other.todayMinutes == todayMinutes) &&
            (identical(other.todaySessions, todaySessions) ||
                other.todaySessions == todaySessions) &&
            (identical(other.weekMinutes, weekMinutes) ||
                other.weekMinutes == weekMinutes) &&
            (identical(other.totalMinutes, totalMinutes) ||
                other.totalMinutes == totalMinutes) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, todayMinutes, todaySessions,
      weekMinutes, totalMinutes, currentStreak);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FocusStatsWidgetDataImplCopyWith<_$FocusStatsWidgetDataImpl>
      get copyWith =>
          __$$FocusStatsWidgetDataImplCopyWithImpl<_$FocusStatsWidgetDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FocusStatsWidgetDataImplToJson(
      this,
    );
  }
}

abstract class _FocusStatsWidgetData extends FocusStatsWidgetData {
  const factory _FocusStatsWidgetData(
      {required final int todayMinutes,
      required final int todaySessions,
      required final int weekMinutes,
      required final int totalMinutes,
      required final int currentStreak}) = _$FocusStatsWidgetDataImpl;
  const _FocusStatsWidgetData._() : super._();

  factory _FocusStatsWidgetData.fromJson(Map<String, dynamic> json) =
      _$FocusStatsWidgetDataImpl.fromJson;

  @override
  int get todayMinutes;
  @override
  int get todaySessions;
  @override
  int get weekMinutes;
  @override
  int get totalMinutes;
  @override
  int get currentStreak;
  @override
  @JsonKey(ignore: true)
  _$$FocusStatsWidgetDataImplCopyWith<_$FocusStatsWidgetDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

QuickIdeaWidgetData _$QuickIdeaWidgetDataFromJson(Map<String, dynamic> json) {
  return _QuickIdeaWidgetData.fromJson(json);
}

/// @nodoc
mixin _$QuickIdeaWidgetData {
  int get totalIdeas => throw _privateConstructorUsedError;
  int get todayIdeas => throw _privateConstructorUsedError;
  List<String> get recentIdeas => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuickIdeaWidgetDataCopyWith<QuickIdeaWidgetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickIdeaWidgetDataCopyWith<$Res> {
  factory $QuickIdeaWidgetDataCopyWith(
          QuickIdeaWidgetData value, $Res Function(QuickIdeaWidgetData) then) =
      _$QuickIdeaWidgetDataCopyWithImpl<$Res, QuickIdeaWidgetData>;
  @useResult
  $Res call({int totalIdeas, int todayIdeas, List<String> recentIdeas});
}

/// @nodoc
class _$QuickIdeaWidgetDataCopyWithImpl<$Res, $Val extends QuickIdeaWidgetData>
    implements $QuickIdeaWidgetDataCopyWith<$Res> {
  _$QuickIdeaWidgetDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIdeas = null,
    Object? todayIdeas = null,
    Object? recentIdeas = null,
  }) {
    return _then(_value.copyWith(
      totalIdeas: null == totalIdeas
          ? _value.totalIdeas
          : totalIdeas // ignore: cast_nullable_to_non_nullable
              as int,
      todayIdeas: null == todayIdeas
          ? _value.todayIdeas
          : todayIdeas // ignore: cast_nullable_to_non_nullable
              as int,
      recentIdeas: null == recentIdeas
          ? _value.recentIdeas
          : recentIdeas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuickIdeaWidgetDataImplCopyWith<$Res>
    implements $QuickIdeaWidgetDataCopyWith<$Res> {
  factory _$$QuickIdeaWidgetDataImplCopyWith(_$QuickIdeaWidgetDataImpl value,
          $Res Function(_$QuickIdeaWidgetDataImpl) then) =
      __$$QuickIdeaWidgetDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalIdeas, int todayIdeas, List<String> recentIdeas});
}

/// @nodoc
class __$$QuickIdeaWidgetDataImplCopyWithImpl<$Res>
    extends _$QuickIdeaWidgetDataCopyWithImpl<$Res, _$QuickIdeaWidgetDataImpl>
    implements _$$QuickIdeaWidgetDataImplCopyWith<$Res> {
  __$$QuickIdeaWidgetDataImplCopyWithImpl(_$QuickIdeaWidgetDataImpl _value,
      $Res Function(_$QuickIdeaWidgetDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIdeas = null,
    Object? todayIdeas = null,
    Object? recentIdeas = null,
  }) {
    return _then(_$QuickIdeaWidgetDataImpl(
      totalIdeas: null == totalIdeas
          ? _value.totalIdeas
          : totalIdeas // ignore: cast_nullable_to_non_nullable
              as int,
      todayIdeas: null == todayIdeas
          ? _value.todayIdeas
          : todayIdeas // ignore: cast_nullable_to_non_nullable
              as int,
      recentIdeas: null == recentIdeas
          ? _value._recentIdeas
          : recentIdeas // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickIdeaWidgetDataImpl implements _QuickIdeaWidgetData {
  const _$QuickIdeaWidgetDataImpl(
      {required this.totalIdeas,
      required this.todayIdeas,
      required final List<String> recentIdeas})
      : _recentIdeas = recentIdeas;

  factory _$QuickIdeaWidgetDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickIdeaWidgetDataImplFromJson(json);

  @override
  final int totalIdeas;
  @override
  final int todayIdeas;
  final List<String> _recentIdeas;
  @override
  List<String> get recentIdeas {
    if (_recentIdeas is EqualUnmodifiableListView) return _recentIdeas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentIdeas);
  }

  @override
  String toString() {
    return 'QuickIdeaWidgetData(totalIdeas: $totalIdeas, todayIdeas: $todayIdeas, recentIdeas: $recentIdeas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickIdeaWidgetDataImpl &&
            (identical(other.totalIdeas, totalIdeas) ||
                other.totalIdeas == totalIdeas) &&
            (identical(other.todayIdeas, todayIdeas) ||
                other.todayIdeas == todayIdeas) &&
            const DeepCollectionEquality()
                .equals(other._recentIdeas, _recentIdeas));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalIdeas, todayIdeas,
      const DeepCollectionEquality().hash(_recentIdeas));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickIdeaWidgetDataImplCopyWith<_$QuickIdeaWidgetDataImpl> get copyWith =>
      __$$QuickIdeaWidgetDataImplCopyWithImpl<_$QuickIdeaWidgetDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickIdeaWidgetDataImplToJson(
      this,
    );
  }
}

abstract class _QuickIdeaWidgetData implements QuickIdeaWidgetData {
  const factory _QuickIdeaWidgetData(
      {required final int totalIdeas,
      required final int todayIdeas,
      required final List<String> recentIdeas}) = _$QuickIdeaWidgetDataImpl;

  factory _QuickIdeaWidgetData.fromJson(Map<String, dynamic> json) =
      _$QuickIdeaWidgetDataImpl.fromJson;

  @override
  int get totalIdeas;
  @override
  int get todayIdeas;
  @override
  List<String> get recentIdeas;
  @override
  @JsonKey(ignore: true)
  _$$QuickIdeaWidgetDataImplCopyWith<_$QuickIdeaWidgetDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
