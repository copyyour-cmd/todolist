// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskTemplate _$TaskTemplateFromJson(Map<String, dynamic> json) {
  return _TaskTemplate.fromJson(json);
}

/// @nodoc
mixin _$TaskTemplate {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(3)
  TemplateCategory get category => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(4)
  TaskPriority get priority => throw _privateConstructorUsedError;
  @HiveField(5)
  int? get estimatedMinutes => throw _privateConstructorUsedError;
  @HiveField(6)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(7)
  int? get iconCodePoint => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isBuiltIn => throw _privateConstructorUsedError;
  @HiveField(9)
  int get usageCount => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(11)
  List<SubTask> get defaultSubtasks => throw _privateConstructorUsedError;
  @HiveField(12)
  RecurrenceRule? get defaultRecurrence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskTemplateCopyWith<TaskTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskTemplateCopyWith<$Res> {
  factory $TaskTemplateCopyWith(
          TaskTemplate value, $Res Function(TaskTemplate) then) =
      _$TaskTemplateCopyWithImpl<$Res, TaskTemplate>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(3) TemplateCategory category,
      @HiveField(2) String? description,
      @HiveField(4) TaskPriority priority,
      @HiveField(5) int? estimatedMinutes,
      @HiveField(6) List<String> tags,
      @HiveField(7) int? iconCodePoint,
      @HiveField(8) bool isBuiltIn,
      @HiveField(9) int usageCount,
      @HiveField(10) DateTime? createdAt,
      @HiveField(11) List<SubTask> defaultSubtasks,
      @HiveField(12) RecurrenceRule? defaultRecurrence});

  $RecurrenceRuleCopyWith<$Res>? get defaultRecurrence;
}

/// @nodoc
class _$TaskTemplateCopyWithImpl<$Res, $Val extends TaskTemplate>
    implements $TaskTemplateCopyWith<$Res> {
  _$TaskTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? description = freezed,
    Object? priority = null,
    Object? estimatedMinutes = freezed,
    Object? tags = null,
    Object? iconCodePoint = freezed,
    Object? isBuiltIn = null,
    Object? usageCount = null,
    Object? createdAt = freezed,
    Object? defaultSubtasks = null,
    Object? defaultRecurrence = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TemplateCategory,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      estimatedMinutes: freezed == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      iconCodePoint: freezed == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int?,
      isBuiltIn: null == isBuiltIn
          ? _value.isBuiltIn
          : isBuiltIn // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      defaultSubtasks: null == defaultSubtasks
          ? _value.defaultSubtasks
          : defaultSubtasks // ignore: cast_nullable_to_non_nullable
              as List<SubTask>,
      defaultRecurrence: freezed == defaultRecurrence
          ? _value.defaultRecurrence
          : defaultRecurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RecurrenceRuleCopyWith<$Res>? get defaultRecurrence {
    if (_value.defaultRecurrence == null) {
      return null;
    }

    return $RecurrenceRuleCopyWith<$Res>(_value.defaultRecurrence!, (value) {
      return _then(_value.copyWith(defaultRecurrence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskTemplateImplCopyWith<$Res>
    implements $TaskTemplateCopyWith<$Res> {
  factory _$$TaskTemplateImplCopyWith(
          _$TaskTemplateImpl value, $Res Function(_$TaskTemplateImpl) then) =
      __$$TaskTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(3) TemplateCategory category,
      @HiveField(2) String? description,
      @HiveField(4) TaskPriority priority,
      @HiveField(5) int? estimatedMinutes,
      @HiveField(6) List<String> tags,
      @HiveField(7) int? iconCodePoint,
      @HiveField(8) bool isBuiltIn,
      @HiveField(9) int usageCount,
      @HiveField(10) DateTime? createdAt,
      @HiveField(11) List<SubTask> defaultSubtasks,
      @HiveField(12) RecurrenceRule? defaultRecurrence});

  @override
  $RecurrenceRuleCopyWith<$Res>? get defaultRecurrence;
}

/// @nodoc
class __$$TaskTemplateImplCopyWithImpl<$Res>
    extends _$TaskTemplateCopyWithImpl<$Res, _$TaskTemplateImpl>
    implements _$$TaskTemplateImplCopyWith<$Res> {
  __$$TaskTemplateImplCopyWithImpl(
      _$TaskTemplateImpl _value, $Res Function(_$TaskTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? description = freezed,
    Object? priority = null,
    Object? estimatedMinutes = freezed,
    Object? tags = null,
    Object? iconCodePoint = freezed,
    Object? isBuiltIn = null,
    Object? usageCount = null,
    Object? createdAt = freezed,
    Object? defaultSubtasks = null,
    Object? defaultRecurrence = freezed,
  }) {
    return _then(_$TaskTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TemplateCategory,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      estimatedMinutes: freezed == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      iconCodePoint: freezed == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int?,
      isBuiltIn: null == isBuiltIn
          ? _value.isBuiltIn
          : isBuiltIn // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      defaultSubtasks: null == defaultSubtasks
          ? _value._defaultSubtasks
          : defaultSubtasks // ignore: cast_nullable_to_non_nullable
              as List<SubTask>,
      defaultRecurrence: freezed == defaultRecurrence
          ? _value.defaultRecurrence
          : defaultRecurrence // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskTemplateImpl extends _TaskTemplate {
  const _$TaskTemplateImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(3) required this.category,
      @HiveField(2) this.description,
      @HiveField(4) this.priority = TaskPriority.medium,
      @HiveField(5) this.estimatedMinutes,
      @HiveField(6) final List<String> tags = const [],
      @HiveField(7) this.iconCodePoint,
      @HiveField(8) this.isBuiltIn = false,
      @HiveField(9) this.usageCount = 0,
      @HiveField(10) this.createdAt,
      @HiveField(11) final List<SubTask> defaultSubtasks = const [],
      @HiveField(12) this.defaultRecurrence})
      : _tags = tags,
        _defaultSubtasks = defaultSubtasks,
        super._();

  factory _$TaskTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskTemplateImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(3)
  final TemplateCategory category;
  @override
  @HiveField(2)
  final String? description;
  @override
  @JsonKey()
  @HiveField(4)
  final TaskPriority priority;
  @override
  @HiveField(5)
  final int? estimatedMinutes;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(6)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @HiveField(7)
  final int? iconCodePoint;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isBuiltIn;
  @override
  @JsonKey()
  @HiveField(9)
  final int usageCount;
  @override
  @HiveField(10)
  final DateTime? createdAt;
  final List<SubTask> _defaultSubtasks;
  @override
  @JsonKey()
  @HiveField(11)
  List<SubTask> get defaultSubtasks {
    if (_defaultSubtasks is EqualUnmodifiableListView) return _defaultSubtasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultSubtasks);
  }

  @override
  @HiveField(12)
  final RecurrenceRule? defaultRecurrence;

  @override
  String toString() {
    return 'TaskTemplate(id: $id, title: $title, category: $category, description: $description, priority: $priority, estimatedMinutes: $estimatedMinutes, tags: $tags, iconCodePoint: $iconCodePoint, isBuiltIn: $isBuiltIn, usageCount: $usageCount, createdAt: $createdAt, defaultSubtasks: $defaultSubtasks, defaultRecurrence: $defaultRecurrence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.iconCodePoint, iconCodePoint) ||
                other.iconCodePoint == iconCodePoint) &&
            (identical(other.isBuiltIn, isBuiltIn) ||
                other.isBuiltIn == isBuiltIn) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._defaultSubtasks, _defaultSubtasks) &&
            (identical(other.defaultRecurrence, defaultRecurrence) ||
                other.defaultRecurrence == defaultRecurrence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      category,
      description,
      priority,
      estimatedMinutes,
      const DeepCollectionEquality().hash(_tags),
      iconCodePoint,
      isBuiltIn,
      usageCount,
      createdAt,
      const DeepCollectionEquality().hash(_defaultSubtasks),
      defaultRecurrence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskTemplateImplCopyWith<_$TaskTemplateImpl> get copyWith =>
      __$$TaskTemplateImplCopyWithImpl<_$TaskTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskTemplateImplToJson(
      this,
    );
  }
}

abstract class _TaskTemplate extends TaskTemplate {
  const factory _TaskTemplate(
          {@HiveField(0) required final String id,
          @HiveField(1) required final String title,
          @HiveField(3) required final TemplateCategory category,
          @HiveField(2) final String? description,
          @HiveField(4) final TaskPriority priority,
          @HiveField(5) final int? estimatedMinutes,
          @HiveField(6) final List<String> tags,
          @HiveField(7) final int? iconCodePoint,
          @HiveField(8) final bool isBuiltIn,
          @HiveField(9) final int usageCount,
          @HiveField(10) final DateTime? createdAt,
          @HiveField(11) final List<SubTask> defaultSubtasks,
          @HiveField(12) final RecurrenceRule? defaultRecurrence}) =
      _$TaskTemplateImpl;
  const _TaskTemplate._() : super._();

  factory _TaskTemplate.fromJson(Map<String, dynamic> json) =
      _$TaskTemplateImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(3)
  TemplateCategory get category;
  @override
  @HiveField(2)
  String? get description;
  @override
  @HiveField(4)
  TaskPriority get priority;
  @override
  @HiveField(5)
  int? get estimatedMinutes;
  @override
  @HiveField(6)
  List<String> get tags;
  @override
  @HiveField(7)
  int? get iconCodePoint;
  @override
  @HiveField(8)
  bool get isBuiltIn;
  @override
  @HiveField(9)
  int get usageCount;
  @override
  @HiveField(10)
  DateTime? get createdAt;
  @override
  @HiveField(11)
  List<SubTask> get defaultSubtasks;
  @override
  @HiveField(12)
  RecurrenceRule? get defaultRecurrence;
  @override
  @JsonKey(ignore: true)
  _$$TaskTemplateImplCopyWith<_$TaskTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
