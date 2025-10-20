// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'title.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserTitle _$UserTitleFromJson(Map<String, dynamic> json) {
  return _UserTitle.fromJson(json);
}

/// @nodoc
mixin _$UserTitle {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError; // 称号名称
  String get description => throw _privateConstructorUsedError; // 称号描述
  TitleCategory get category => throw _privateConstructorUsedError; // 类别
  TitleRarity get rarity => throw _privateConstructorUsedError; // 稀有度
  String get icon => throw _privateConstructorUsedError; // 图标
  bool get isUnlocked => throw _privateConstructorUsedError; // 是否已解锁
  DateTime? get unlockedAt => throw _privateConstructorUsedError; // 解锁时间
  int get requiredValue => throw _privateConstructorUsedError; // 解锁所需数值
  String? get requiredCondition => throw _privateConstructorUsedError; // 解锁条件描述
  int get pointsBonus => throw _privateConstructorUsedError; // 积分加成百分比
  String? get themeUnlock => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserTitleCopyWith<UserTitle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserTitleCopyWith<$Res> {
  factory $UserTitleCopyWith(UserTitle value, $Res Function(UserTitle) then) =
      _$UserTitleCopyWithImpl<$Res, UserTitle>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      TitleCategory category,
      TitleRarity rarity,
      String icon,
      bool isUnlocked,
      DateTime? unlockedAt,
      int requiredValue,
      String? requiredCondition,
      int pointsBonus,
      String? themeUnlock});
}

/// @nodoc
class _$UserTitleCopyWithImpl<$Res, $Val extends UserTitle>
    implements $UserTitleCopyWith<$Res> {
  _$UserTitleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? rarity = null,
    Object? icon = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? requiredValue = null,
    Object? requiredCondition = freezed,
    Object? pointsBonus = null,
    Object? themeUnlock = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TitleCategory,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as TitleRarity,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredValue: null == requiredValue
          ? _value.requiredValue
          : requiredValue // ignore: cast_nullable_to_non_nullable
              as int,
      requiredCondition: freezed == requiredCondition
          ? _value.requiredCondition
          : requiredCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      pointsBonus: null == pointsBonus
          ? _value.pointsBonus
          : pointsBonus // ignore: cast_nullable_to_non_nullable
              as int,
      themeUnlock: freezed == themeUnlock
          ? _value.themeUnlock
          : themeUnlock // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserTitleImplCopyWith<$Res>
    implements $UserTitleCopyWith<$Res> {
  factory _$$UserTitleImplCopyWith(
          _$UserTitleImpl value, $Res Function(_$UserTitleImpl) then) =
      __$$UserTitleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      TitleCategory category,
      TitleRarity rarity,
      String icon,
      bool isUnlocked,
      DateTime? unlockedAt,
      int requiredValue,
      String? requiredCondition,
      int pointsBonus,
      String? themeUnlock});
}

/// @nodoc
class __$$UserTitleImplCopyWithImpl<$Res>
    extends _$UserTitleCopyWithImpl<$Res, _$UserTitleImpl>
    implements _$$UserTitleImplCopyWith<$Res> {
  __$$UserTitleImplCopyWithImpl(
      _$UserTitleImpl _value, $Res Function(_$UserTitleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? rarity = null,
    Object? icon = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? requiredValue = null,
    Object? requiredCondition = freezed,
    Object? pointsBonus = null,
    Object? themeUnlock = freezed,
  }) {
    return _then(_$UserTitleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TitleCategory,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as TitleRarity,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requiredValue: null == requiredValue
          ? _value.requiredValue
          : requiredValue // ignore: cast_nullable_to_non_nullable
              as int,
      requiredCondition: freezed == requiredCondition
          ? _value.requiredCondition
          : requiredCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      pointsBonus: null == pointsBonus
          ? _value.pointsBonus
          : pointsBonus // ignore: cast_nullable_to_non_nullable
              as int,
      themeUnlock: freezed == themeUnlock
          ? _value.themeUnlock
          : themeUnlock // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserTitleImpl extends _UserTitle {
  const _$UserTitleImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.rarity,
      required this.icon,
      this.isUnlocked = false,
      this.unlockedAt,
      this.requiredValue = 0,
      this.requiredCondition,
      this.pointsBonus = 0,
      this.themeUnlock})
      : super._();

  factory _$UserTitleImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserTitleImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
// 称号名称
  @override
  final String description;
// 称号描述
  @override
  final TitleCategory category;
// 类别
  @override
  final TitleRarity rarity;
// 稀有度
  @override
  final String icon;
// 图标
  @override
  @JsonKey()
  final bool isUnlocked;
// 是否已解锁
  @override
  final DateTime? unlockedAt;
// 解锁时间
  @override
  @JsonKey()
  final int requiredValue;
// 解锁所需数值
  @override
  final String? requiredCondition;
// 解锁条件描述
  @override
  @JsonKey()
  final int pointsBonus;
// 积分加成百分比
  @override
  final String? themeUnlock;

  @override
  String toString() {
    return 'UserTitle(id: $id, name: $name, description: $description, category: $category, rarity: $rarity, icon: $icon, isUnlocked: $isUnlocked, unlockedAt: $unlockedAt, requiredValue: $requiredValue, requiredCondition: $requiredCondition, pointsBonus: $pointsBonus, themeUnlock: $themeUnlock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserTitleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.requiredValue, requiredValue) ||
                other.requiredValue == requiredValue) &&
            (identical(other.requiredCondition, requiredCondition) ||
                other.requiredCondition == requiredCondition) &&
            (identical(other.pointsBonus, pointsBonus) ||
                other.pointsBonus == pointsBonus) &&
            (identical(other.themeUnlock, themeUnlock) ||
                other.themeUnlock == themeUnlock));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      rarity,
      icon,
      isUnlocked,
      unlockedAt,
      requiredValue,
      requiredCondition,
      pointsBonus,
      themeUnlock);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserTitleImplCopyWith<_$UserTitleImpl> get copyWith =>
      __$$UserTitleImplCopyWithImpl<_$UserTitleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserTitleImplToJson(
      this,
    );
  }
}

abstract class _UserTitle extends UserTitle {
  const factory _UserTitle(
      {required final String id,
      required final String name,
      required final String description,
      required final TitleCategory category,
      required final TitleRarity rarity,
      required final String icon,
      final bool isUnlocked,
      final DateTime? unlockedAt,
      final int requiredValue,
      final String? requiredCondition,
      final int pointsBonus,
      final String? themeUnlock}) = _$UserTitleImpl;
  const _UserTitle._() : super._();

  factory _UserTitle.fromJson(Map<String, dynamic> json) =
      _$UserTitleImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override // 称号名称
  String get description;
  @override // 称号描述
  TitleCategory get category;
  @override // 类别
  TitleRarity get rarity;
  @override // 稀有度
  String get icon;
  @override // 图标
  bool get isUnlocked;
  @override // 是否已解锁
  DateTime? get unlockedAt;
  @override // 解锁时间
  int get requiredValue;
  @override // 解锁所需数值
  String? get requiredCondition;
  @override // 解锁条件描述
  int get pointsBonus;
  @override // 积分加成百分比
  String? get themeUnlock;
  @override
  @JsonKey(ignore: true)
  _$$UserTitleImplCopyWith<_$UserTitleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
