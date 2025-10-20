// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompletionTrendPoint _$CompletionTrendPointFromJson(Map<String, dynamic> json) {
  return _CompletionTrendPoint.fromJson(json);
}

/// @nodoc
mixin _$CompletionTrendPoint {
  DateTime get date => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompletionTrendPointCopyWith<CompletionTrendPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionTrendPointCopyWith<$Res> {
  factory $CompletionTrendPointCopyWith(CompletionTrendPoint value,
          $Res Function(CompletionTrendPoint) then) =
      _$CompletionTrendPointCopyWithImpl<$Res, CompletionTrendPoint>;
  @useResult
  $Res call({DateTime date, int completedCount, int totalCount});
}

/// @nodoc
class _$CompletionTrendPointCopyWithImpl<$Res,
        $Val extends CompletionTrendPoint>
    implements $CompletionTrendPointCopyWith<$Res> {
  _$CompletionTrendPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completedCount = null,
    Object? totalCount = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompletionTrendPointImplCopyWith<$Res>
    implements $CompletionTrendPointCopyWith<$Res> {
  factory _$$CompletionTrendPointImplCopyWith(_$CompletionTrendPointImpl value,
          $Res Function(_$CompletionTrendPointImpl) then) =
      __$$CompletionTrendPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int completedCount, int totalCount});
}

/// @nodoc
class __$$CompletionTrendPointImplCopyWithImpl<$Res>
    extends _$CompletionTrendPointCopyWithImpl<$Res, _$CompletionTrendPointImpl>
    implements _$$CompletionTrendPointImplCopyWith<$Res> {
  __$$CompletionTrendPointImplCopyWithImpl(_$CompletionTrendPointImpl _value,
      $Res Function(_$CompletionTrendPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completedCount = null,
    Object? totalCount = null,
  }) {
    return _then(_$CompletionTrendPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompletionTrendPointImpl extends _CompletionTrendPoint {
  const _$CompletionTrendPointImpl(
      {required this.date,
      required this.completedCount,
      required this.totalCount})
      : super._();

  factory _$CompletionTrendPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompletionTrendPointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int completedCount;
  @override
  final int totalCount;

  @override
  String toString() {
    return 'CompletionTrendPoint(date: $date, completedCount: $completedCount, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionTrendPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, completedCount, totalCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionTrendPointImplCopyWith<_$CompletionTrendPointImpl>
      get copyWith =>
          __$$CompletionTrendPointImplCopyWithImpl<_$CompletionTrendPointImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompletionTrendPointImplToJson(
      this,
    );
  }
}

abstract class _CompletionTrendPoint extends CompletionTrendPoint {
  const factory _CompletionTrendPoint(
      {required final DateTime date,
      required final int completedCount,
      required final int totalCount}) = _$CompletionTrendPointImpl;
  const _CompletionTrendPoint._() : super._();

  factory _CompletionTrendPoint.fromJson(Map<String, dynamic> json) =
      _$CompletionTrendPointImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get completedCount;
  @override
  int get totalCount;
  @override
  @JsonKey(ignore: true)
  _$$CompletionTrendPointImplCopyWith<_$CompletionTrendPointImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CompletionRateByCategory _$CompletionRateByCategoryFromJson(
    Map<String, dynamic> json) {
  return _CompletionRateByCategory.fromJson(json);
}

/// @nodoc
mixin _$CompletionRateByCategory {
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompletionRateByCategoryCopyWith<CompletionRateByCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletionRateByCategoryCopyWith<$Res> {
  factory $CompletionRateByCategoryCopyWith(CompletionRateByCategory value,
          $Res Function(CompletionRateByCategory) then) =
      _$CompletionRateByCategoryCopyWithImpl<$Res, CompletionRateByCategory>;
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      int completedCount,
      int totalCount,
      int color});
}

/// @nodoc
class _$CompletionRateByCategoryCopyWithImpl<$Res,
        $Val extends CompletionRateByCategory>
    implements $CompletionRateByCategoryCopyWith<$Res> {
  _$CompletionRateByCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? completedCount = null,
    Object? totalCount = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompletionRateByCategoryImplCopyWith<$Res>
    implements $CompletionRateByCategoryCopyWith<$Res> {
  factory _$$CompletionRateByCategoryImplCopyWith(
          _$CompletionRateByCategoryImpl value,
          $Res Function(_$CompletionRateByCategoryImpl) then) =
      __$$CompletionRateByCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      String categoryName,
      int completedCount,
      int totalCount,
      int color});
}

/// @nodoc
class __$$CompletionRateByCategoryImplCopyWithImpl<$Res>
    extends _$CompletionRateByCategoryCopyWithImpl<$Res,
        _$CompletionRateByCategoryImpl>
    implements _$$CompletionRateByCategoryImplCopyWith<$Res> {
  __$$CompletionRateByCategoryImplCopyWithImpl(
      _$CompletionRateByCategoryImpl _value,
      $Res Function(_$CompletionRateByCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? completedCount = null,
    Object? totalCount = null,
    Object? color = null,
  }) {
    return _then(_$CompletionRateByCategoryImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompletionRateByCategoryImpl extends _CompletionRateByCategory {
  const _$CompletionRateByCategoryImpl(
      {required this.categoryId,
      required this.categoryName,
      required this.completedCount,
      required this.totalCount,
      required this.color})
      : super._();

  factory _$CompletionRateByCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompletionRateByCategoryImplFromJson(json);

  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final int completedCount;
  @override
  final int totalCount;
  @override
  final int color;

  @override
  String toString() {
    return 'CompletionRateByCategory(categoryId: $categoryId, categoryName: $categoryName, completedCount: $completedCount, totalCount: $totalCount, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletionRateByCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, categoryId, categoryName, completedCount, totalCount, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletionRateByCategoryImplCopyWith<_$CompletionRateByCategoryImpl>
      get copyWith => __$$CompletionRateByCategoryImplCopyWithImpl<
          _$CompletionRateByCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompletionRateByCategoryImplToJson(
      this,
    );
  }
}

abstract class _CompletionRateByCategory extends CompletionRateByCategory {
  const factory _CompletionRateByCategory(
      {required final String categoryId,
      required final String categoryName,
      required final int completedCount,
      required final int totalCount,
      required final int color}) = _$CompletionRateByCategoryImpl;
  const _CompletionRateByCategory._() : super._();

  factory _CompletionRateByCategory.fromJson(Map<String, dynamic> json) =
      _$CompletionRateByCategoryImpl.fromJson;

  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  int get completedCount;
  @override
  int get totalCount;
  @override
  int get color;
  @override
  @JsonKey(ignore: true)
  _$$CompletionRateByCategoryImplCopyWith<_$CompletionRateByCategoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProcrastinationStat _$ProcrastinationStatFromJson(Map<String, dynamic> json) {
  return _ProcrastinationStat.fromJson(json);
}

/// @nodoc
mixin _$ProcrastinationStat {
  String get taskId => throw _privateConstructorUsedError;
  String get taskTitle => throw _privateConstructorUsedError;
  int get postponeCount => throw _privateConstructorUsedError;
  int get overdueDays => throw _privateConstructorUsedError;
  DateTime? get dueAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProcrastinationStatCopyWith<ProcrastinationStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcrastinationStatCopyWith<$Res> {
  factory $ProcrastinationStatCopyWith(
          ProcrastinationStat value, $Res Function(ProcrastinationStat) then) =
      _$ProcrastinationStatCopyWithImpl<$Res, ProcrastinationStat>;
  @useResult
  $Res call(
      {String taskId,
      String taskTitle,
      int postponeCount,
      int overdueDays,
      DateTime? dueAt});
}

/// @nodoc
class _$ProcrastinationStatCopyWithImpl<$Res, $Val extends ProcrastinationStat>
    implements $ProcrastinationStatCopyWith<$Res> {
  _$ProcrastinationStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? taskTitle = null,
    Object? postponeCount = null,
    Object? overdueDays = null,
    Object? dueAt = freezed,
  }) {
    return _then(_value.copyWith(
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      taskTitle: null == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String,
      postponeCount: null == postponeCount
          ? _value.postponeCount
          : postponeCount // ignore: cast_nullable_to_non_nullable
              as int,
      overdueDays: null == overdueDays
          ? _value.overdueDays
          : overdueDays // ignore: cast_nullable_to_non_nullable
              as int,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProcrastinationStatImplCopyWith<$Res>
    implements $ProcrastinationStatCopyWith<$Res> {
  factory _$$ProcrastinationStatImplCopyWith(_$ProcrastinationStatImpl value,
          $Res Function(_$ProcrastinationStatImpl) then) =
      __$$ProcrastinationStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String taskId,
      String taskTitle,
      int postponeCount,
      int overdueDays,
      DateTime? dueAt});
}

/// @nodoc
class __$$ProcrastinationStatImplCopyWithImpl<$Res>
    extends _$ProcrastinationStatCopyWithImpl<$Res, _$ProcrastinationStatImpl>
    implements _$$ProcrastinationStatImplCopyWith<$Res> {
  __$$ProcrastinationStatImplCopyWithImpl(_$ProcrastinationStatImpl _value,
      $Res Function(_$ProcrastinationStatImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? taskTitle = null,
    Object? postponeCount = null,
    Object? overdueDays = null,
    Object? dueAt = freezed,
  }) {
    return _then(_$ProcrastinationStatImpl(
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      taskTitle: null == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String,
      postponeCount: null == postponeCount
          ? _value.postponeCount
          : postponeCount // ignore: cast_nullable_to_non_nullable
              as int,
      overdueDays: null == overdueDays
          ? _value.overdueDays
          : overdueDays // ignore: cast_nullable_to_non_nullable
              as int,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcrastinationStatImpl implements _ProcrastinationStat {
  const _$ProcrastinationStatImpl(
      {required this.taskId,
      required this.taskTitle,
      required this.postponeCount,
      required this.overdueDays,
      required this.dueAt});

  factory _$ProcrastinationStatImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcrastinationStatImplFromJson(json);

  @override
  final String taskId;
  @override
  final String taskTitle;
  @override
  final int postponeCount;
  @override
  final int overdueDays;
  @override
  final DateTime? dueAt;

  @override
  String toString() {
    return 'ProcrastinationStat(taskId: $taskId, taskTitle: $taskTitle, postponeCount: $postponeCount, overdueDays: $overdueDays, dueAt: $dueAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcrastinationStatImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.taskTitle, taskTitle) ||
                other.taskTitle == taskTitle) &&
            (identical(other.postponeCount, postponeCount) ||
                other.postponeCount == postponeCount) &&
            (identical(other.overdueDays, overdueDays) ||
                other.overdueDays == overdueDays) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, taskId, taskTitle, postponeCount, overdueDays, dueAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcrastinationStatImplCopyWith<_$ProcrastinationStatImpl> get copyWith =>
      __$$ProcrastinationStatImplCopyWithImpl<_$ProcrastinationStatImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcrastinationStatImplToJson(
      this,
    );
  }
}

abstract class _ProcrastinationStat implements ProcrastinationStat {
  const factory _ProcrastinationStat(
      {required final String taskId,
      required final String taskTitle,
      required final int postponeCount,
      required final int overdueDays,
      required final DateTime? dueAt}) = _$ProcrastinationStatImpl;

  factory _ProcrastinationStat.fromJson(Map<String, dynamic> json) =
      _$ProcrastinationStatImpl.fromJson;

  @override
  String get taskId;
  @override
  String get taskTitle;
  @override
  int get postponeCount;
  @override
  int get overdueDays;
  @override
  DateTime? get dueAt;
  @override
  @JsonKey(ignore: true)
  _$$ProcrastinationStatImplCopyWith<_$ProcrastinationStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductivityByTimeSlot _$ProductivityByTimeSlotFromJson(
    Map<String, dynamic> json) {
  return _ProductivityByTimeSlot.fromJson(json);
}

/// @nodoc
mixin _$ProductivityByTimeSlot {
  int get hour => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError;
  int get totalMinutesSpent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductivityByTimeSlotCopyWith<ProductivityByTimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductivityByTimeSlotCopyWith<$Res> {
  factory $ProductivityByTimeSlotCopyWith(ProductivityByTimeSlot value,
          $Res Function(ProductivityByTimeSlot) then) =
      _$ProductivityByTimeSlotCopyWithImpl<$Res, ProductivityByTimeSlot>;
  @useResult
  $Res call({int hour, int completedCount, int totalMinutesSpent});
}

/// @nodoc
class _$ProductivityByTimeSlotCopyWithImpl<$Res,
        $Val extends ProductivityByTimeSlot>
    implements $ProductivityByTimeSlotCopyWith<$Res> {
  _$ProductivityByTimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? completedCount = null,
    Object? totalMinutesSpent = null,
  }) {
    return _then(_value.copyWith(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutesSpent: null == totalMinutesSpent
          ? _value.totalMinutesSpent
          : totalMinutesSpent // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductivityByTimeSlotImplCopyWith<$Res>
    implements $ProductivityByTimeSlotCopyWith<$Res> {
  factory _$$ProductivityByTimeSlotImplCopyWith(
          _$ProductivityByTimeSlotImpl value,
          $Res Function(_$ProductivityByTimeSlotImpl) then) =
      __$$ProductivityByTimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int completedCount, int totalMinutesSpent});
}

/// @nodoc
class __$$ProductivityByTimeSlotImplCopyWithImpl<$Res>
    extends _$ProductivityByTimeSlotCopyWithImpl<$Res,
        _$ProductivityByTimeSlotImpl>
    implements _$$ProductivityByTimeSlotImplCopyWith<$Res> {
  __$$ProductivityByTimeSlotImplCopyWithImpl(
      _$ProductivityByTimeSlotImpl _value,
      $Res Function(_$ProductivityByTimeSlotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? completedCount = null,
    Object? totalMinutesSpent = null,
  }) {
    return _then(_$ProductivityByTimeSlotImpl(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalMinutesSpent: null == totalMinutesSpent
          ? _value.totalMinutesSpent
          : totalMinutesSpent // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductivityByTimeSlotImpl extends _ProductivityByTimeSlot {
  const _$ProductivityByTimeSlotImpl(
      {required this.hour,
      required this.completedCount,
      required this.totalMinutesSpent})
      : super._();

  factory _$ProductivityByTimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductivityByTimeSlotImplFromJson(json);

  @override
  final int hour;
  @override
  final int completedCount;
  @override
  final int totalMinutesSpent;

  @override
  String toString() {
    return 'ProductivityByTimeSlot(hour: $hour, completedCount: $completedCount, totalMinutesSpent: $totalMinutesSpent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductivityByTimeSlotImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.totalMinutesSpent, totalMinutesSpent) ||
                other.totalMinutesSpent == totalMinutesSpent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hour, completedCount, totalMinutesSpent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductivityByTimeSlotImplCopyWith<_$ProductivityByTimeSlotImpl>
      get copyWith => __$$ProductivityByTimeSlotImplCopyWithImpl<
          _$ProductivityByTimeSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductivityByTimeSlotImplToJson(
      this,
    );
  }
}

abstract class _ProductivityByTimeSlot extends ProductivityByTimeSlot {
  const factory _ProductivityByTimeSlot(
      {required final int hour,
      required final int completedCount,
      required final int totalMinutesSpent}) = _$ProductivityByTimeSlotImpl;
  const _ProductivityByTimeSlot._() : super._();

  factory _ProductivityByTimeSlot.fromJson(Map<String, dynamic> json) =
      _$ProductivityByTimeSlotImpl.fromJson;

  @override
  int get hour;
  @override
  int get completedCount;
  @override
  int get totalMinutesSpent;
  @override
  @JsonKey(ignore: true)
  _$$ProductivityByTimeSlotImplCopyWith<_$ProductivityByTimeSlotImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HeatmapDataPoint _$HeatmapDataPointFromJson(Map<String, dynamic> json) {
  return _HeatmapDataPoint.fromJson(json);
}

/// @nodoc
mixin _$HeatmapDataPoint {
  DateTime get date => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError;
  int get intensity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HeatmapDataPointCopyWith<HeatmapDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeatmapDataPointCopyWith<$Res> {
  factory $HeatmapDataPointCopyWith(
          HeatmapDataPoint value, $Res Function(HeatmapDataPoint) then) =
      _$HeatmapDataPointCopyWithImpl<$Res, HeatmapDataPoint>;
  @useResult
  $Res call({DateTime date, int completedCount, int intensity});
}

/// @nodoc
class _$HeatmapDataPointCopyWithImpl<$Res, $Val extends HeatmapDataPoint>
    implements $HeatmapDataPointCopyWith<$Res> {
  _$HeatmapDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completedCount = null,
    Object? intensity = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeatmapDataPointImplCopyWith<$Res>
    implements $HeatmapDataPointCopyWith<$Res> {
  factory _$$HeatmapDataPointImplCopyWith(_$HeatmapDataPointImpl value,
          $Res Function(_$HeatmapDataPointImpl) then) =
      __$$HeatmapDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int completedCount, int intensity});
}

/// @nodoc
class __$$HeatmapDataPointImplCopyWithImpl<$Res>
    extends _$HeatmapDataPointCopyWithImpl<$Res, _$HeatmapDataPointImpl>
    implements _$$HeatmapDataPointImplCopyWith<$Res> {
  __$$HeatmapDataPointImplCopyWithImpl(_$HeatmapDataPointImpl _value,
      $Res Function(_$HeatmapDataPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completedCount = null,
    Object? intensity = null,
  }) {
    return _then(_$HeatmapDataPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeatmapDataPointImpl implements _HeatmapDataPoint {
  const _$HeatmapDataPointImpl(
      {required this.date,
      required this.completedCount,
      required this.intensity});

  factory _$HeatmapDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeatmapDataPointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final int completedCount;
  @override
  final int intensity;

  @override
  String toString() {
    return 'HeatmapDataPoint(date: $date, completedCount: $completedCount, intensity: $intensity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeatmapDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, completedCount, intensity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HeatmapDataPointImplCopyWith<_$HeatmapDataPointImpl> get copyWith =>
      __$$HeatmapDataPointImplCopyWithImpl<_$HeatmapDataPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeatmapDataPointImplToJson(
      this,
    );
  }
}

abstract class _HeatmapDataPoint implements HeatmapDataPoint {
  const factory _HeatmapDataPoint(
      {required final DateTime date,
      required final int completedCount,
      required final int intensity}) = _$HeatmapDataPointImpl;

  factory _HeatmapDataPoint.fromJson(Map<String, dynamic> json) =
      _$HeatmapDataPointImpl.fromJson;

  @override
  DateTime get date;
  @override
  int get completedCount;
  @override
  int get intensity;
  @override
  @JsonKey(ignore: true)
  _$$HeatmapDataPointImplCopyWith<_$HeatmapDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskStatistics _$TaskStatisticsFromJson(Map<String, dynamic> json) {
  return _TaskStatistics.fromJson(json);
}

/// @nodoc
mixin _$TaskStatistics {
// 趋势数据
  List<CompletionTrendPoint> get last7Days =>
      throw _privateConstructorUsedError;
  List<CompletionTrendPoint> get last30Days =>
      throw _privateConstructorUsedError;
  List<CompletionTrendPoint> get last90Days =>
      throw _privateConstructorUsedError; // 分类完成率
  List<CompletionRateByCategory> get byList =>
      throw _privateConstructorUsedError;
  List<CompletionRateByCategory> get byTag =>
      throw _privateConstructorUsedError;
  List<CompletionRateByCategory> get byPriority =>
      throw _privateConstructorUsedError; // 拖延排行
  List<ProcrastinationStat> get topProcrastinated =>
      throw _privateConstructorUsedError; // 时段分析
  List<ProductivityByTimeSlot> get productivityByHour =>
      throw _privateConstructorUsedError; // 热力图
  List<HeatmapDataPoint> get heatmapData =>
      throw _privateConstructorUsedError; // 汇总指标
  int get totalTasksCompleted => throw _privateConstructorUsedError;
  int get totalTasksCreated => throw _privateConstructorUsedError;
  double get overallCompletionRate => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  DateTime? get lastCompletionDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskStatisticsCopyWith<TaskStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStatisticsCopyWith<$Res> {
  factory $TaskStatisticsCopyWith(
          TaskStatistics value, $Res Function(TaskStatistics) then) =
      _$TaskStatisticsCopyWithImpl<$Res, TaskStatistics>;
  @useResult
  $Res call(
      {List<CompletionTrendPoint> last7Days,
      List<CompletionTrendPoint> last30Days,
      List<CompletionTrendPoint> last90Days,
      List<CompletionRateByCategory> byList,
      List<CompletionRateByCategory> byTag,
      List<CompletionRateByCategory> byPriority,
      List<ProcrastinationStat> topProcrastinated,
      List<ProductivityByTimeSlot> productivityByHour,
      List<HeatmapDataPoint> heatmapData,
      int totalTasksCompleted,
      int totalTasksCreated,
      double overallCompletionRate,
      int currentStreak,
      int longestStreak,
      DateTime? lastCompletionDate});
}

/// @nodoc
class _$TaskStatisticsCopyWithImpl<$Res, $Val extends TaskStatistics>
    implements $TaskStatisticsCopyWith<$Res> {
  _$TaskStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last7Days = null,
    Object? last30Days = null,
    Object? last90Days = null,
    Object? byList = null,
    Object? byTag = null,
    Object? byPriority = null,
    Object? topProcrastinated = null,
    Object? productivityByHour = null,
    Object? heatmapData = null,
    Object? totalTasksCompleted = null,
    Object? totalTasksCreated = null,
    Object? overallCompletionRate = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCompletionDate = freezed,
  }) {
    return _then(_value.copyWith(
      last7Days: null == last7Days
          ? _value.last7Days
          : last7Days // ignore: cast_nullable_to_non_nullable
              as List<CompletionTrendPoint>,
      last30Days: null == last30Days
          ? _value.last30Days
          : last30Days // ignore: cast_nullable_to_non_nullable
              as List<CompletionTrendPoint>,
      last90Days: null == last90Days
          ? _value.last90Days
          : last90Days // ignore: cast_nullable_to_non_nullable
              as List<CompletionTrendPoint>,
      byList: null == byList
          ? _value.byList
          : byList // ignore: cast_nullable_to_non_nullable
              as List<CompletionRateByCategory>,
      byTag: null == byTag
          ? _value.byTag
          : byTag // ignore: cast_nullable_to_non_nullable
              as List<CompletionRateByCategory>,
      byPriority: null == byPriority
          ? _value.byPriority
          : byPriority // ignore: cast_nullable_to_non_nullable
              as List<CompletionRateByCategory>,
      topProcrastinated: null == topProcrastinated
          ? _value.topProcrastinated
          : topProcrastinated // ignore: cast_nullable_to_non_nullable
              as List<ProcrastinationStat>,
      productivityByHour: null == productivityByHour
          ? _value.productivityByHour
          : productivityByHour // ignore: cast_nullable_to_non_nullable
              as List<ProductivityByTimeSlot>,
      heatmapData: null == heatmapData
          ? _value.heatmapData
          : heatmapData // ignore: cast_nullable_to_non_nullable
              as List<HeatmapDataPoint>,
      totalTasksCompleted: null == totalTasksCompleted
          ? _value.totalTasksCompleted
          : totalTasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalTasksCreated: null == totalTasksCreated
          ? _value.totalTasksCreated
          : totalTasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      overallCompletionRate: null == overallCompletionRate
          ? _value.overallCompletionRate
          : overallCompletionRate // ignore: cast_nullable_to_non_nullable
              as double,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastCompletionDate: freezed == lastCompletionDate
          ? _value.lastCompletionDate
          : lastCompletionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskStatisticsImplCopyWith<$Res>
    implements $TaskStatisticsCopyWith<$Res> {
  factory _$$TaskStatisticsImplCopyWith(_$TaskStatisticsImpl value,
          $Res Function(_$TaskStatisticsImpl) then) =
      __$$TaskStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CompletionTrendPoint> last7Days,
      List<CompletionTrendPoint> last30Days,
      List<CompletionTrendPoint> last90Days,
      List<CompletionRateByCategory> byList,
      List<CompletionRateByCategory> byTag,
      List<CompletionRateByCategory> byPriority,
      List<ProcrastinationStat> topProcrastinated,
      List<ProductivityByTimeSlot> productivityByHour,
      List<HeatmapDataPoint> heatmapData,
      int totalTasksCompleted,
      int totalTasksCreated,
      double overallCompletionRate,
      int currentStreak,
      int longestStreak,
      DateTime? lastCompletionDate});
}

/// @nodoc
class __$$TaskStatisticsImplCopyWithImpl<$Res>
    extends _$TaskStatisticsCopyWithImpl<$Res, _$TaskStatisticsImpl>
    implements _$$TaskStatisticsImplCopyWith<$Res> {
  __$$TaskStatisticsImplCopyWithImpl(
      _$TaskStatisticsImpl _value, $Res Function(_$TaskStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? last7Days = null,
    Object? last30Days = null,
    Object? last90Days = null,
    Object? byList = null,
    Object? byTag = null,
    Object? byPriority = null,
    Object? topProcrastinated = null,
    Object? productivityByHour = null,
    Object? heatmapData = null,
    Object? totalTasksCompleted = null,
    Object? totalTasksCreated = null,
    Object? overallCompletionRate = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastCompletionDate = freezed,
  }) {
    return _then(_$TaskStatisticsImpl(
      last7Days: null == last7Days
          ? _value._last7Days
          : last7Days // ignore: cast_nullable_to_non_nullable
              as List<CompletionTrendPoint>,
      last30Days: null == last30Days
          ? _value._last30Days
          : last30Days // ignore: cast_nullable_to_non_nullable
              as List<CompletionTrendPoint>,
      last90Days: null == last90Days
          ? _value._last90Days
          : last90Days // ignore: cast_nullable_to_non_nullable
              as List<CompletionTrendPoint>,
      byList: null == byList
          ? _value._byList
          : byList // ignore: cast_nullable_to_non_nullable
              as List<CompletionRateByCategory>,
      byTag: null == byTag
          ? _value._byTag
          : byTag // ignore: cast_nullable_to_non_nullable
              as List<CompletionRateByCategory>,
      byPriority: null == byPriority
          ? _value._byPriority
          : byPriority // ignore: cast_nullable_to_non_nullable
              as List<CompletionRateByCategory>,
      topProcrastinated: null == topProcrastinated
          ? _value._topProcrastinated
          : topProcrastinated // ignore: cast_nullable_to_non_nullable
              as List<ProcrastinationStat>,
      productivityByHour: null == productivityByHour
          ? _value._productivityByHour
          : productivityByHour // ignore: cast_nullable_to_non_nullable
              as List<ProductivityByTimeSlot>,
      heatmapData: null == heatmapData
          ? _value._heatmapData
          : heatmapData // ignore: cast_nullable_to_non_nullable
              as List<HeatmapDataPoint>,
      totalTasksCompleted: null == totalTasksCompleted
          ? _value.totalTasksCompleted
          : totalTasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalTasksCreated: null == totalTasksCreated
          ? _value.totalTasksCreated
          : totalTasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      overallCompletionRate: null == overallCompletionRate
          ? _value.overallCompletionRate
          : overallCompletionRate // ignore: cast_nullable_to_non_nullable
              as double,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastCompletionDate: freezed == lastCompletionDate
          ? _value.lastCompletionDate
          : lastCompletionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskStatisticsImpl extends _TaskStatistics {
  const _$TaskStatisticsImpl(
      {required final List<CompletionTrendPoint> last7Days,
      required final List<CompletionTrendPoint> last30Days,
      required final List<CompletionTrendPoint> last90Days,
      required final List<CompletionRateByCategory> byList,
      required final List<CompletionRateByCategory> byTag,
      required final List<CompletionRateByCategory> byPriority,
      required final List<ProcrastinationStat> topProcrastinated,
      required final List<ProductivityByTimeSlot> productivityByHour,
      required final List<HeatmapDataPoint> heatmapData,
      required this.totalTasksCompleted,
      required this.totalTasksCreated,
      required this.overallCompletionRate,
      required this.currentStreak,
      required this.longestStreak,
      required this.lastCompletionDate})
      : _last7Days = last7Days,
        _last30Days = last30Days,
        _last90Days = last90Days,
        _byList = byList,
        _byTag = byTag,
        _byPriority = byPriority,
        _topProcrastinated = topProcrastinated,
        _productivityByHour = productivityByHour,
        _heatmapData = heatmapData,
        super._();

  factory _$TaskStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskStatisticsImplFromJson(json);

// 趋势数据
  final List<CompletionTrendPoint> _last7Days;
// 趋势数据
  @override
  List<CompletionTrendPoint> get last7Days {
    if (_last7Days is EqualUnmodifiableListView) return _last7Days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_last7Days);
  }

  final List<CompletionTrendPoint> _last30Days;
  @override
  List<CompletionTrendPoint> get last30Days {
    if (_last30Days is EqualUnmodifiableListView) return _last30Days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_last30Days);
  }

  final List<CompletionTrendPoint> _last90Days;
  @override
  List<CompletionTrendPoint> get last90Days {
    if (_last90Days is EqualUnmodifiableListView) return _last90Days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_last90Days);
  }

// 分类完成率
  final List<CompletionRateByCategory> _byList;
// 分类完成率
  @override
  List<CompletionRateByCategory> get byList {
    if (_byList is EqualUnmodifiableListView) return _byList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byList);
  }

  final List<CompletionRateByCategory> _byTag;
  @override
  List<CompletionRateByCategory> get byTag {
    if (_byTag is EqualUnmodifiableListView) return _byTag;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byTag);
  }

  final List<CompletionRateByCategory> _byPriority;
  @override
  List<CompletionRateByCategory> get byPriority {
    if (_byPriority is EqualUnmodifiableListView) return _byPriority;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byPriority);
  }

// 拖延排行
  final List<ProcrastinationStat> _topProcrastinated;
// 拖延排行
  @override
  List<ProcrastinationStat> get topProcrastinated {
    if (_topProcrastinated is EqualUnmodifiableListView)
      return _topProcrastinated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topProcrastinated);
  }

// 时段分析
  final List<ProductivityByTimeSlot> _productivityByHour;
// 时段分析
  @override
  List<ProductivityByTimeSlot> get productivityByHour {
    if (_productivityByHour is EqualUnmodifiableListView)
      return _productivityByHour;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productivityByHour);
  }

// 热力图
  final List<HeatmapDataPoint> _heatmapData;
// 热力图
  @override
  List<HeatmapDataPoint> get heatmapData {
    if (_heatmapData is EqualUnmodifiableListView) return _heatmapData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heatmapData);
  }

// 汇总指标
  @override
  final int totalTasksCompleted;
  @override
  final int totalTasksCreated;
  @override
  final double overallCompletionRate;
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final DateTime? lastCompletionDate;

  @override
  String toString() {
    return 'TaskStatistics(last7Days: $last7Days, last30Days: $last30Days, last90Days: $last90Days, byList: $byList, byTag: $byTag, byPriority: $byPriority, topProcrastinated: $topProcrastinated, productivityByHour: $productivityByHour, heatmapData: $heatmapData, totalTasksCompleted: $totalTasksCompleted, totalTasksCreated: $totalTasksCreated, overallCompletionRate: $overallCompletionRate, currentStreak: $currentStreak, longestStreak: $longestStreak, lastCompletionDate: $lastCompletionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStatisticsImpl &&
            const DeepCollectionEquality()
                .equals(other._last7Days, _last7Days) &&
            const DeepCollectionEquality()
                .equals(other._last30Days, _last30Days) &&
            const DeepCollectionEquality()
                .equals(other._last90Days, _last90Days) &&
            const DeepCollectionEquality().equals(other._byList, _byList) &&
            const DeepCollectionEquality().equals(other._byTag, _byTag) &&
            const DeepCollectionEquality()
                .equals(other._byPriority, _byPriority) &&
            const DeepCollectionEquality()
                .equals(other._topProcrastinated, _topProcrastinated) &&
            const DeepCollectionEquality()
                .equals(other._productivityByHour, _productivityByHour) &&
            const DeepCollectionEquality()
                .equals(other._heatmapData, _heatmapData) &&
            (identical(other.totalTasksCompleted, totalTasksCompleted) ||
                other.totalTasksCompleted == totalTasksCompleted) &&
            (identical(other.totalTasksCreated, totalTasksCreated) ||
                other.totalTasksCreated == totalTasksCreated) &&
            (identical(other.overallCompletionRate, overallCompletionRate) ||
                other.overallCompletionRate == overallCompletionRate) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastCompletionDate, lastCompletionDate) ||
                other.lastCompletionDate == lastCompletionDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_last7Days),
      const DeepCollectionEquality().hash(_last30Days),
      const DeepCollectionEquality().hash(_last90Days),
      const DeepCollectionEquality().hash(_byList),
      const DeepCollectionEquality().hash(_byTag),
      const DeepCollectionEquality().hash(_byPriority),
      const DeepCollectionEquality().hash(_topProcrastinated),
      const DeepCollectionEquality().hash(_productivityByHour),
      const DeepCollectionEquality().hash(_heatmapData),
      totalTasksCompleted,
      totalTasksCreated,
      overallCompletionRate,
      currentStreak,
      longestStreak,
      lastCompletionDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStatisticsImplCopyWith<_$TaskStatisticsImpl> get copyWith =>
      __$$TaskStatisticsImplCopyWithImpl<_$TaskStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskStatisticsImplToJson(
      this,
    );
  }
}

abstract class _TaskStatistics extends TaskStatistics {
  const factory _TaskStatistics(
      {required final List<CompletionTrendPoint> last7Days,
      required final List<CompletionTrendPoint> last30Days,
      required final List<CompletionTrendPoint> last90Days,
      required final List<CompletionRateByCategory> byList,
      required final List<CompletionRateByCategory> byTag,
      required final List<CompletionRateByCategory> byPriority,
      required final List<ProcrastinationStat> topProcrastinated,
      required final List<ProductivityByTimeSlot> productivityByHour,
      required final List<HeatmapDataPoint> heatmapData,
      required final int totalTasksCompleted,
      required final int totalTasksCreated,
      required final double overallCompletionRate,
      required final int currentStreak,
      required final int longestStreak,
      required final DateTime? lastCompletionDate}) = _$TaskStatisticsImpl;
  const _TaskStatistics._() : super._();

  factory _TaskStatistics.fromJson(Map<String, dynamic> json) =
      _$TaskStatisticsImpl.fromJson;

  @override // 趋势数据
  List<CompletionTrendPoint> get last7Days;
  @override
  List<CompletionTrendPoint> get last30Days;
  @override
  List<CompletionTrendPoint> get last90Days;
  @override // 分类完成率
  List<CompletionRateByCategory> get byList;
  @override
  List<CompletionRateByCategory> get byTag;
  @override
  List<CompletionRateByCategory> get byPriority;
  @override // 拖延排行
  List<ProcrastinationStat> get topProcrastinated;
  @override // 时段分析
  List<ProductivityByTimeSlot> get productivityByHour;
  @override // 热力图
  List<HeatmapDataPoint> get heatmapData;
  @override // 汇总指标
  int get totalTasksCompleted;
  @override
  int get totalTasksCreated;
  @override
  double get overallCompletionRate;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  DateTime? get lastCompletionDate;
  @override
  @JsonKey(ignore: true)
  _$$TaskStatisticsImplCopyWith<_$TaskStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
