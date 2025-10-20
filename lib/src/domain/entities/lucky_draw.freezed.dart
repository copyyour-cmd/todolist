// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lucky_draw.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrizeConfig _$PrizeConfigFromJson(Map<String, dynamic> json) {
  return _PrizeConfig.fromJson(json);
}

/// @nodoc
mixin _$PrizeConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  PrizeType get type => throw _privateConstructorUsedError;
  PrizeRarity get rarity => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError; // 积分数值或其他数值
  String? get itemId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrizeConfigCopyWith<PrizeConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrizeConfigCopyWith<$Res> {
  factory $PrizeConfigCopyWith(
          PrizeConfig value, $Res Function(PrizeConfig) then) =
      _$PrizeConfigCopyWithImpl<$Res, PrizeConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      PrizeType type,
      PrizeRarity rarity,
      String icon,
      int value,
      String? itemId});
}

/// @nodoc
class _$PrizeConfigCopyWithImpl<$Res, $Val extends PrizeConfig>
    implements $PrizeConfigCopyWith<$Res> {
  _$PrizeConfigCopyWithImpl(this._value, this._then);

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
    Object? type = null,
    Object? rarity = null,
    Object? icon = null,
    Object? value = null,
    Object? itemId = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PrizeType,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as PrizeRarity,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrizeConfigImplCopyWith<$Res>
    implements $PrizeConfigCopyWith<$Res> {
  factory _$$PrizeConfigImplCopyWith(
          _$PrizeConfigImpl value, $Res Function(_$PrizeConfigImpl) then) =
      __$$PrizeConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      PrizeType type,
      PrizeRarity rarity,
      String icon,
      int value,
      String? itemId});
}

/// @nodoc
class __$$PrizeConfigImplCopyWithImpl<$Res>
    extends _$PrizeConfigCopyWithImpl<$Res, _$PrizeConfigImpl>
    implements _$$PrizeConfigImplCopyWith<$Res> {
  __$$PrizeConfigImplCopyWithImpl(
      _$PrizeConfigImpl _value, $Res Function(_$PrizeConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? rarity = null,
    Object? icon = null,
    Object? value = null,
    Object? itemId = freezed,
  }) {
    return _then(_$PrizeConfigImpl(
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PrizeType,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as PrizeRarity,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrizeConfigImpl extends _PrizeConfig {
  const _$PrizeConfigImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.rarity,
      required this.icon,
      this.value = 0,
      this.itemId})
      : super._();

  factory _$PrizeConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrizeConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final PrizeType type;
  @override
  final PrizeRarity rarity;
  @override
  final String icon;
  @override
  @JsonKey()
  final int value;
// 积分数值或其他数值
  @override
  final String? itemId;

  @override
  String toString() {
    return 'PrizeConfig(id: $id, name: $name, description: $description, type: $type, rarity: $rarity, icon: $icon, value: $value, itemId: $itemId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrizeConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.itemId, itemId) || other.itemId == itemId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, type, rarity, icon, value, itemId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrizeConfigImplCopyWith<_$PrizeConfigImpl> get copyWith =>
      __$$PrizeConfigImplCopyWithImpl<_$PrizeConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrizeConfigImplToJson(
      this,
    );
  }
}

abstract class _PrizeConfig extends PrizeConfig {
  const factory _PrizeConfig(
      {required final String id,
      required final String name,
      required final String description,
      required final PrizeType type,
      required final PrizeRarity rarity,
      required final String icon,
      final int value,
      final String? itemId}) = _$PrizeConfigImpl;
  const _PrizeConfig._() : super._();

  factory _PrizeConfig.fromJson(Map<String, dynamic> json) =
      _$PrizeConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  PrizeType get type;
  @override
  PrizeRarity get rarity;
  @override
  String get icon;
  @override
  int get value;
  @override // 积分数值或其他数值
  String? get itemId;
  @override
  @JsonKey(ignore: true)
  _$$PrizeConfigImplCopyWith<_$PrizeConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LuckyDrawRecord _$LuckyDrawRecordFromJson(Map<String, dynamic> json) {
  return _LuckyDrawRecord.fromJson(json);
}

/// @nodoc
mixin _$LuckyDrawRecord {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get prizeId => throw _privateConstructorUsedError; // 奖品ID
  String get prizeName => throw _privateConstructorUsedError; // 奖品名称
  PrizeType get prizeType => throw _privateConstructorUsedError;
  PrizeRarity get prizeRarity => throw _privateConstructorUsedError;
  int get costPoints => throw _privateConstructorUsedError; // 花费积分(免费为0)
  bool get isFree => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LuckyDrawRecordCopyWith<LuckyDrawRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuckyDrawRecordCopyWith<$Res> {
  factory $LuckyDrawRecordCopyWith(
          LuckyDrawRecord value, $Res Function(LuckyDrawRecord) then) =
      _$LuckyDrawRecordCopyWithImpl<$Res, LuckyDrawRecord>;
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      String prizeId,
      String prizeName,
      PrizeType prizeType,
      PrizeRarity prizeRarity,
      int costPoints,
      bool isFree});
}

/// @nodoc
class _$LuckyDrawRecordCopyWithImpl<$Res, $Val extends LuckyDrawRecord>
    implements $LuckyDrawRecordCopyWith<$Res> {
  _$LuckyDrawRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? prizeId = null,
    Object? prizeName = null,
    Object? prizeType = null,
    Object? prizeRarity = null,
    Object? costPoints = null,
    Object? isFree = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      prizeId: null == prizeId
          ? _value.prizeId
          : prizeId // ignore: cast_nullable_to_non_nullable
              as String,
      prizeName: null == prizeName
          ? _value.prizeName
          : prizeName // ignore: cast_nullable_to_non_nullable
              as String,
      prizeType: null == prizeType
          ? _value.prizeType
          : prizeType // ignore: cast_nullable_to_non_nullable
              as PrizeType,
      prizeRarity: null == prizeRarity
          ? _value.prizeRarity
          : prizeRarity // ignore: cast_nullable_to_non_nullable
              as PrizeRarity,
      costPoints: null == costPoints
          ? _value.costPoints
          : costPoints // ignore: cast_nullable_to_non_nullable
              as int,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LuckyDrawRecordImplCopyWith<$Res>
    implements $LuckyDrawRecordCopyWith<$Res> {
  factory _$$LuckyDrawRecordImplCopyWith(_$LuckyDrawRecordImpl value,
          $Res Function(_$LuckyDrawRecordImpl) then) =
      __$$LuckyDrawRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      String prizeId,
      String prizeName,
      PrizeType prizeType,
      PrizeRarity prizeRarity,
      int costPoints,
      bool isFree});
}

/// @nodoc
class __$$LuckyDrawRecordImplCopyWithImpl<$Res>
    extends _$LuckyDrawRecordCopyWithImpl<$Res, _$LuckyDrawRecordImpl>
    implements _$$LuckyDrawRecordImplCopyWith<$Res> {
  __$$LuckyDrawRecordImplCopyWithImpl(
      _$LuckyDrawRecordImpl _value, $Res Function(_$LuckyDrawRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? prizeId = null,
    Object? prizeName = null,
    Object? prizeType = null,
    Object? prizeRarity = null,
    Object? costPoints = null,
    Object? isFree = null,
  }) {
    return _then(_$LuckyDrawRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      prizeId: null == prizeId
          ? _value.prizeId
          : prizeId // ignore: cast_nullable_to_non_nullable
              as String,
      prizeName: null == prizeName
          ? _value.prizeName
          : prizeName // ignore: cast_nullable_to_non_nullable
              as String,
      prizeType: null == prizeType
          ? _value.prizeType
          : prizeType // ignore: cast_nullable_to_non_nullable
              as PrizeType,
      prizeRarity: null == prizeRarity
          ? _value.prizeRarity
          : prizeRarity // ignore: cast_nullable_to_non_nullable
              as PrizeRarity,
      costPoints: null == costPoints
          ? _value.costPoints
          : costPoints // ignore: cast_nullable_to_non_nullable
              as int,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LuckyDrawRecordImpl extends _LuckyDrawRecord {
  const _$LuckyDrawRecordImpl(
      {required this.id,
      required this.createdAt,
      required this.prizeId,
      required this.prizeName,
      required this.prizeType,
      required this.prizeRarity,
      this.costPoints = 0,
      this.isFree = false})
      : super._();

  factory _$LuckyDrawRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$LuckyDrawRecordImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final String prizeId;
// 奖品ID
  @override
  final String prizeName;
// 奖品名称
  @override
  final PrizeType prizeType;
  @override
  final PrizeRarity prizeRarity;
  @override
  @JsonKey()
  final int costPoints;
// 花费积分(免费为0)
  @override
  @JsonKey()
  final bool isFree;

  @override
  String toString() {
    return 'LuckyDrawRecord(id: $id, createdAt: $createdAt, prizeId: $prizeId, prizeName: $prizeName, prizeType: $prizeType, prizeRarity: $prizeRarity, costPoints: $costPoints, isFree: $isFree)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LuckyDrawRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.prizeId, prizeId) || other.prizeId == prizeId) &&
            (identical(other.prizeName, prizeName) ||
                other.prizeName == prizeName) &&
            (identical(other.prizeType, prizeType) ||
                other.prizeType == prizeType) &&
            (identical(other.prizeRarity, prizeRarity) ||
                other.prizeRarity == prizeRarity) &&
            (identical(other.costPoints, costPoints) ||
                other.costPoints == costPoints) &&
            (identical(other.isFree, isFree) || other.isFree == isFree));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, prizeId,
      prizeName, prizeType, prizeRarity, costPoints, isFree);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LuckyDrawRecordImplCopyWith<_$LuckyDrawRecordImpl> get copyWith =>
      __$$LuckyDrawRecordImplCopyWithImpl<_$LuckyDrawRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LuckyDrawRecordImplToJson(
      this,
    );
  }
}

abstract class _LuckyDrawRecord extends LuckyDrawRecord {
  const factory _LuckyDrawRecord(
      {required final String id,
      required final DateTime createdAt,
      required final String prizeId,
      required final String prizeName,
      required final PrizeType prizeType,
      required final PrizeRarity prizeRarity,
      final int costPoints,
      final bool isFree}) = _$LuckyDrawRecordImpl;
  const _LuckyDrawRecord._() : super._();

  factory _LuckyDrawRecord.fromJson(Map<String, dynamic> json) =
      _$LuckyDrawRecordImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  String get prizeId;
  @override // 奖品ID
  String get prizeName;
  @override // 奖品名称
  PrizeType get prizeType;
  @override
  PrizeRarity get prizeRarity;
  @override
  int get costPoints;
  @override // 花费积分(免费为0)
  bool get isFree;
  @override
  @JsonKey(ignore: true)
  _$$LuckyDrawRecordImplCopyWith<_$LuckyDrawRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LuckyDrawStats _$LuckyDrawStatsFromJson(Map<String, dynamic> json) {
  return _LuckyDrawStats.fromJson(json);
}

/// @nodoc
mixin _$LuckyDrawStats {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get totalDraws => throw _privateConstructorUsedError; // 总抽奖次数
  int get freeDrawsToday => throw _privateConstructorUsedError; // 今日免费次数
  DateTime? get lastFreeDrawDate =>
      throw _privateConstructorUsedError; // 最后免费抽奖日期
  int get pityCounter => throw _privateConstructorUsedError; // 保底计数器
  int get epicPityCounter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LuckyDrawStatsCopyWith<LuckyDrawStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LuckyDrawStatsCopyWith<$Res> {
  factory $LuckyDrawStatsCopyWith(
          LuckyDrawStats value, $Res Function(LuckyDrawStats) then) =
      _$LuckyDrawStatsCopyWithImpl<$Res, LuckyDrawStats>;
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      int totalDraws,
      int freeDrawsToday,
      DateTime? lastFreeDrawDate,
      int pityCounter,
      int epicPityCounter});
}

/// @nodoc
class _$LuckyDrawStatsCopyWithImpl<$Res, $Val extends LuckyDrawStats>
    implements $LuckyDrawStatsCopyWith<$Res> {
  _$LuckyDrawStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? totalDraws = null,
    Object? freeDrawsToday = null,
    Object? lastFreeDrawDate = freezed,
    Object? pityCounter = null,
    Object? epicPityCounter = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalDraws: null == totalDraws
          ? _value.totalDraws
          : totalDraws // ignore: cast_nullable_to_non_nullable
              as int,
      freeDrawsToday: null == freeDrawsToday
          ? _value.freeDrawsToday
          : freeDrawsToday // ignore: cast_nullable_to_non_nullable
              as int,
      lastFreeDrawDate: freezed == lastFreeDrawDate
          ? _value.lastFreeDrawDate
          : lastFreeDrawDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pityCounter: null == pityCounter
          ? _value.pityCounter
          : pityCounter // ignore: cast_nullable_to_non_nullable
              as int,
      epicPityCounter: null == epicPityCounter
          ? _value.epicPityCounter
          : epicPityCounter // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LuckyDrawStatsImplCopyWith<$Res>
    implements $LuckyDrawStatsCopyWith<$Res> {
  factory _$$LuckyDrawStatsImplCopyWith(_$LuckyDrawStatsImpl value,
          $Res Function(_$LuckyDrawStatsImpl) then) =
      __$$LuckyDrawStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      int totalDraws,
      int freeDrawsToday,
      DateTime? lastFreeDrawDate,
      int pityCounter,
      int epicPityCounter});
}

/// @nodoc
class __$$LuckyDrawStatsImplCopyWithImpl<$Res>
    extends _$LuckyDrawStatsCopyWithImpl<$Res, _$LuckyDrawStatsImpl>
    implements _$$LuckyDrawStatsImplCopyWith<$Res> {
  __$$LuckyDrawStatsImplCopyWithImpl(
      _$LuckyDrawStatsImpl _value, $Res Function(_$LuckyDrawStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? totalDraws = null,
    Object? freeDrawsToday = null,
    Object? lastFreeDrawDate = freezed,
    Object? pityCounter = null,
    Object? epicPityCounter = null,
  }) {
    return _then(_$LuckyDrawStatsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalDraws: null == totalDraws
          ? _value.totalDraws
          : totalDraws // ignore: cast_nullable_to_non_nullable
              as int,
      freeDrawsToday: null == freeDrawsToday
          ? _value.freeDrawsToday
          : freeDrawsToday // ignore: cast_nullable_to_non_nullable
              as int,
      lastFreeDrawDate: freezed == lastFreeDrawDate
          ? _value.lastFreeDrawDate
          : lastFreeDrawDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pityCounter: null == pityCounter
          ? _value.pityCounter
          : pityCounter // ignore: cast_nullable_to_non_nullable
              as int,
      epicPityCounter: null == epicPityCounter
          ? _value.epicPityCounter
          : epicPityCounter // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LuckyDrawStatsImpl extends _LuckyDrawStats {
  const _$LuckyDrawStatsImpl(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.totalDraws = 0,
      this.freeDrawsToday = 0,
      this.lastFreeDrawDate,
      this.pityCounter = 0,
      this.epicPityCounter = 0})
      : super._();

  factory _$LuckyDrawStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LuckyDrawStatsImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int totalDraws;
// 总抽奖次数
  @override
  @JsonKey()
  final int freeDrawsToday;
// 今日免费次数
  @override
  final DateTime? lastFreeDrawDate;
// 最后免费抽奖日期
  @override
  @JsonKey()
  final int pityCounter;
// 保底计数器
  @override
  @JsonKey()
  final int epicPityCounter;

  @override
  String toString() {
    return 'LuckyDrawStats(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, totalDraws: $totalDraws, freeDrawsToday: $freeDrawsToday, lastFreeDrawDate: $lastFreeDrawDate, pityCounter: $pityCounter, epicPityCounter: $epicPityCounter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LuckyDrawStatsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.totalDraws, totalDraws) ||
                other.totalDraws == totalDraws) &&
            (identical(other.freeDrawsToday, freeDrawsToday) ||
                other.freeDrawsToday == freeDrawsToday) &&
            (identical(other.lastFreeDrawDate, lastFreeDrawDate) ||
                other.lastFreeDrawDate == lastFreeDrawDate) &&
            (identical(other.pityCounter, pityCounter) ||
                other.pityCounter == pityCounter) &&
            (identical(other.epicPityCounter, epicPityCounter) ||
                other.epicPityCounter == epicPityCounter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      totalDraws,
      freeDrawsToday,
      lastFreeDrawDate,
      pityCounter,
      epicPityCounter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LuckyDrawStatsImplCopyWith<_$LuckyDrawStatsImpl> get copyWith =>
      __$$LuckyDrawStatsImplCopyWithImpl<_$LuckyDrawStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LuckyDrawStatsImplToJson(
      this,
    );
  }
}

abstract class _LuckyDrawStats extends LuckyDrawStats {
  const factory _LuckyDrawStats(
      {required final String id,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final int totalDraws,
      final int freeDrawsToday,
      final DateTime? lastFreeDrawDate,
      final int pityCounter,
      final int epicPityCounter}) = _$LuckyDrawStatsImpl;
  const _LuckyDrawStats._() : super._();

  factory _LuckyDrawStats.fromJson(Map<String, dynamic> json) =
      _$LuckyDrawStatsImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get totalDraws;
  @override // 总抽奖次数
  int get freeDrawsToday;
  @override // 今日免费次数
  DateTime? get lastFreeDrawDate;
  @override // 最后免费抽奖日期
  int get pityCounter;
  @override // 保底计数器
  int get epicPityCounter;
  @override
  @JsonKey(ignore: true)
  _$$LuckyDrawStatsImplCopyWith<_$LuckyDrawStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
