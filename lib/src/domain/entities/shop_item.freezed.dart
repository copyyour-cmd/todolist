// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShopItem _$ShopItemFromJson(Map<String, dynamic> json) {
  return _ShopItem.fromJson(json);
}

/// @nodoc
mixin _$ShopItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  ShopItemCategory get category => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  ShopItemRarity get rarity => throw _privateConstructorUsedError;
  bool get isLimited => throw _privateConstructorUsedError;
  DateTime? get limitedUntil => throw _privateConstructorUsedError;
  bool get isPurchased => throw _privateConstructorUsedError;
  DateTime? get purchasedAt => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 商品数据（JSON格式存储具体配置）
  Map<String, dynamic>? get itemData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShopItemCopyWith<ShopItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopItemCopyWith<$Res> {
  factory $ShopItemCopyWith(ShopItem value, $Res Function(ShopItem) then) =
      _$ShopItemCopyWithImpl<$Res, ShopItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String icon,
      ShopItemCategory category,
      int price,
      ShopItemRarity rarity,
      bool isLimited,
      DateTime? limitedUntil,
      bool isPurchased,
      DateTime? purchasedAt,
      bool isAvailable,
      DateTime createdAt,
      Map<String, dynamic>? itemData});
}

/// @nodoc
class _$ShopItemCopyWithImpl<$Res, $Val extends ShopItem>
    implements $ShopItemCopyWith<$Res> {
  _$ShopItemCopyWithImpl(this._value, this._then);

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
    Object? icon = null,
    Object? category = null,
    Object? price = null,
    Object? rarity = null,
    Object? isLimited = null,
    Object? limitedUntil = freezed,
    Object? isPurchased = null,
    Object? purchasedAt = freezed,
    Object? isAvailable = null,
    Object? createdAt = null,
    Object? itemData = freezed,
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
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ShopItemCategory,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as ShopItemRarity,
      isLimited: null == isLimited
          ? _value.isLimited
          : isLimited // ignore: cast_nullable_to_non_nullable
              as bool,
      limitedUntil: freezed == limitedUntil
          ? _value.limitedUntil
          : limitedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPurchased: null == isPurchased
          ? _value.isPurchased
          : isPurchased // ignore: cast_nullable_to_non_nullable
              as bool,
      purchasedAt: freezed == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      itemData: freezed == itemData
          ? _value.itemData
          : itemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShopItemImplCopyWith<$Res>
    implements $ShopItemCopyWith<$Res> {
  factory _$$ShopItemImplCopyWith(
          _$ShopItemImpl value, $Res Function(_$ShopItemImpl) then) =
      __$$ShopItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String icon,
      ShopItemCategory category,
      int price,
      ShopItemRarity rarity,
      bool isLimited,
      DateTime? limitedUntil,
      bool isPurchased,
      DateTime? purchasedAt,
      bool isAvailable,
      DateTime createdAt,
      Map<String, dynamic>? itemData});
}

/// @nodoc
class __$$ShopItemImplCopyWithImpl<$Res>
    extends _$ShopItemCopyWithImpl<$Res, _$ShopItemImpl>
    implements _$$ShopItemImplCopyWith<$Res> {
  __$$ShopItemImplCopyWithImpl(
      _$ShopItemImpl _value, $Res Function(_$ShopItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? icon = null,
    Object? category = null,
    Object? price = null,
    Object? rarity = null,
    Object? isLimited = null,
    Object? limitedUntil = freezed,
    Object? isPurchased = null,
    Object? purchasedAt = freezed,
    Object? isAvailable = null,
    Object? createdAt = null,
    Object? itemData = freezed,
  }) {
    return _then(_$ShopItemImpl(
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
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ShopItemCategory,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as ShopItemRarity,
      isLimited: null == isLimited
          ? _value.isLimited
          : isLimited // ignore: cast_nullable_to_non_nullable
              as bool,
      limitedUntil: freezed == limitedUntil
          ? _value.limitedUntil
          : limitedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPurchased: null == isPurchased
          ? _value.isPurchased
          : isPurchased // ignore: cast_nullable_to_non_nullable
              as bool,
      purchasedAt: freezed == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      itemData: freezed == itemData
          ? _value._itemData
          : itemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopItemImpl extends _ShopItem {
  const _$ShopItemImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.category,
      required this.price,
      required this.rarity,
      this.isLimited = false,
      this.limitedUntil,
      this.isPurchased = false,
      this.purchasedAt,
      this.isAvailable = true,
      required this.createdAt,
      final Map<String, dynamic>? itemData})
      : _itemData = itemData,
        super._();

  factory _$ShopItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String icon;
  @override
  final ShopItemCategory category;
  @override
  final int price;
  @override
  final ShopItemRarity rarity;
  @override
  @JsonKey()
  final bool isLimited;
  @override
  final DateTime? limitedUntil;
  @override
  @JsonKey()
  final bool isPurchased;
  @override
  final DateTime? purchasedAt;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final DateTime createdAt;

  /// 商品数据（JSON格式存储具体配置）
  final Map<String, dynamic>? _itemData;

  /// 商品数据（JSON格式存储具体配置）
  @override
  Map<String, dynamic>? get itemData {
    final value = _itemData;
    if (value == null) return null;
    if (_itemData is EqualUnmodifiableMapView) return _itemData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ShopItem(id: $id, name: $name, description: $description, icon: $icon, category: $category, price: $price, rarity: $rarity, isLimited: $isLimited, limitedUntil: $limitedUntil, isPurchased: $isPurchased, purchasedAt: $purchasedAt, isAvailable: $isAvailable, createdAt: $createdAt, itemData: $itemData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.isLimited, isLimited) ||
                other.isLimited == isLimited) &&
            (identical(other.limitedUntil, limitedUntil) ||
                other.limitedUntil == limitedUntil) &&
            (identical(other.isPurchased, isPurchased) ||
                other.isPurchased == isPurchased) &&
            (identical(other.purchasedAt, purchasedAt) ||
                other.purchasedAt == purchasedAt) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._itemData, _itemData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      icon,
      category,
      price,
      rarity,
      isLimited,
      limitedUntil,
      isPurchased,
      purchasedAt,
      isAvailable,
      createdAt,
      const DeepCollectionEquality().hash(_itemData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopItemImplCopyWith<_$ShopItemImpl> get copyWith =>
      __$$ShopItemImplCopyWithImpl<_$ShopItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopItemImplToJson(
      this,
    );
  }
}

abstract class _ShopItem extends ShopItem {
  const factory _ShopItem(
      {required final String id,
      required final String name,
      required final String description,
      required final String icon,
      required final ShopItemCategory category,
      required final int price,
      required final ShopItemRarity rarity,
      final bool isLimited,
      final DateTime? limitedUntil,
      final bool isPurchased,
      final DateTime? purchasedAt,
      final bool isAvailable,
      required final DateTime createdAt,
      final Map<String, dynamic>? itemData}) = _$ShopItemImpl;
  const _ShopItem._() : super._();

  factory _ShopItem.fromJson(Map<String, dynamic> json) =
      _$ShopItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get icon;
  @override
  ShopItemCategory get category;
  @override
  int get price;
  @override
  ShopItemRarity get rarity;
  @override
  bool get isLimited;
  @override
  DateTime? get limitedUntil;
  @override
  bool get isPurchased;
  @override
  DateTime? get purchasedAt;
  @override
  bool get isAvailable;
  @override
  DateTime get createdAt;
  @override

  /// 商品数据（JSON格式存储具体配置）
  Map<String, dynamic>? get itemData;
  @override
  @JsonKey(ignore: true)
  _$$ShopItemImplCopyWith<_$ShopItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseRecord _$PurchaseRecordFromJson(Map<String, dynamic> json) {
  return _PurchaseRecord.fromJson(json);
}

/// @nodoc
mixin _$PurchaseRecord {
  String get id => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  int get pricePaid => throw _privateConstructorUsedError;
  DateTime get purchasedAt => throw _privateConstructorUsedError;
  bool get isFromLuckyDraw => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseRecordCopyWith<PurchaseRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseRecordCopyWith<$Res> {
  factory $PurchaseRecordCopyWith(
          PurchaseRecord value, $Res Function(PurchaseRecord) then) =
      _$PurchaseRecordCopyWithImpl<$Res, PurchaseRecord>;
  @useResult
  $Res call(
      {String id,
      String itemId,
      String itemName,
      int pricePaid,
      DateTime purchasedAt,
      bool isFromLuckyDraw});
}

/// @nodoc
class _$PurchaseRecordCopyWithImpl<$Res, $Val extends PurchaseRecord>
    implements $PurchaseRecordCopyWith<$Res> {
  _$PurchaseRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? pricePaid = null,
    Object? purchasedAt = null,
    Object? isFromLuckyDraw = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      pricePaid: null == pricePaid
          ? _value.pricePaid
          : pricePaid // ignore: cast_nullable_to_non_nullable
              as int,
      purchasedAt: null == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromLuckyDraw: null == isFromLuckyDraw
          ? _value.isFromLuckyDraw
          : isFromLuckyDraw // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseRecordImplCopyWith<$Res>
    implements $PurchaseRecordCopyWith<$Res> {
  factory _$$PurchaseRecordImplCopyWith(_$PurchaseRecordImpl value,
          $Res Function(_$PurchaseRecordImpl) then) =
      __$$PurchaseRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String itemId,
      String itemName,
      int pricePaid,
      DateTime purchasedAt,
      bool isFromLuckyDraw});
}

/// @nodoc
class __$$PurchaseRecordImplCopyWithImpl<$Res>
    extends _$PurchaseRecordCopyWithImpl<$Res, _$PurchaseRecordImpl>
    implements _$$PurchaseRecordImplCopyWith<$Res> {
  __$$PurchaseRecordImplCopyWithImpl(
      _$PurchaseRecordImpl _value, $Res Function(_$PurchaseRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? pricePaid = null,
    Object? purchasedAt = null,
    Object? isFromLuckyDraw = null,
  }) {
    return _then(_$PurchaseRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      pricePaid: null == pricePaid
          ? _value.pricePaid
          : pricePaid // ignore: cast_nullable_to_non_nullable
              as int,
      purchasedAt: null == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFromLuckyDraw: null == isFromLuckyDraw
          ? _value.isFromLuckyDraw
          : isFromLuckyDraw // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseRecordImpl implements _PurchaseRecord {
  const _$PurchaseRecordImpl(
      {required this.id,
      required this.itemId,
      required this.itemName,
      required this.pricePaid,
      required this.purchasedAt,
      this.isFromLuckyDraw = false});

  factory _$PurchaseRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String itemId;
  @override
  final String itemName;
  @override
  final int pricePaid;
  @override
  final DateTime purchasedAt;
  @override
  @JsonKey()
  final bool isFromLuckyDraw;

  @override
  String toString() {
    return 'PurchaseRecord(id: $id, itemId: $itemId, itemName: $itemName, pricePaid: $pricePaid, purchasedAt: $purchasedAt, isFromLuckyDraw: $isFromLuckyDraw)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.pricePaid, pricePaid) ||
                other.pricePaid == pricePaid) &&
            (identical(other.purchasedAt, purchasedAt) ||
                other.purchasedAt == purchasedAt) &&
            (identical(other.isFromLuckyDraw, isFromLuckyDraw) ||
                other.isFromLuckyDraw == isFromLuckyDraw));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, itemId, itemName, pricePaid,
      purchasedAt, isFromLuckyDraw);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseRecordImplCopyWith<_$PurchaseRecordImpl> get copyWith =>
      __$$PurchaseRecordImplCopyWithImpl<_$PurchaseRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseRecordImplToJson(
      this,
    );
  }
}

abstract class _PurchaseRecord implements PurchaseRecord {
  const factory _PurchaseRecord(
      {required final String id,
      required final String itemId,
      required final String itemName,
      required final int pricePaid,
      required final DateTime purchasedAt,
      final bool isFromLuckyDraw}) = _$PurchaseRecordImpl;

  factory _PurchaseRecord.fromJson(Map<String, dynamic> json) =
      _$PurchaseRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get itemId;
  @override
  String get itemName;
  @override
  int get pricePaid;
  @override
  DateTime get purchasedAt;
  @override
  bool get isFromLuckyDraw;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseRecordImplCopyWith<_$PurchaseRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserInventory _$UserInventoryFromJson(Map<String, dynamic> json) {
  return _UserInventory.fromJson(json);
}

/// @nodoc
mixin _$UserInventory {
  String get id => throw _privateConstructorUsedError;
  List<String> get ownedItemIds => throw _privateConstructorUsedError;
  List<String> get purchaseRecordIds => throw _privateConstructorUsedError;
  DateTime? get lastLuckyDrawAt => throw _privateConstructorUsedError;
  int get luckyDrawCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserInventoryCopyWith<UserInventory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInventoryCopyWith<$Res> {
  factory $UserInventoryCopyWith(
          UserInventory value, $Res Function(UserInventory) then) =
      _$UserInventoryCopyWithImpl<$Res, UserInventory>;
  @useResult
  $Res call(
      {String id,
      List<String> ownedItemIds,
      List<String> purchaseRecordIds,
      DateTime? lastLuckyDrawAt,
      int luckyDrawCount,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserInventoryCopyWithImpl<$Res, $Val extends UserInventory>
    implements $UserInventoryCopyWith<$Res> {
  _$UserInventoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownedItemIds = null,
    Object? purchaseRecordIds = null,
    Object? lastLuckyDrawAt = freezed,
    Object? luckyDrawCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownedItemIds: null == ownedItemIds
          ? _value.ownedItemIds
          : ownedItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      purchaseRecordIds: null == purchaseRecordIds
          ? _value.purchaseRecordIds
          : purchaseRecordIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastLuckyDrawAt: freezed == lastLuckyDrawAt
          ? _value.lastLuckyDrawAt
          : lastLuckyDrawAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      luckyDrawCount: null == luckyDrawCount
          ? _value.luckyDrawCount
          : luckyDrawCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserInventoryImplCopyWith<$Res>
    implements $UserInventoryCopyWith<$Res> {
  factory _$$UserInventoryImplCopyWith(
          _$UserInventoryImpl value, $Res Function(_$UserInventoryImpl) then) =
      __$$UserInventoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<String> ownedItemIds,
      List<String> purchaseRecordIds,
      DateTime? lastLuckyDrawAt,
      int luckyDrawCount,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserInventoryImplCopyWithImpl<$Res>
    extends _$UserInventoryCopyWithImpl<$Res, _$UserInventoryImpl>
    implements _$$UserInventoryImplCopyWith<$Res> {
  __$$UserInventoryImplCopyWithImpl(
      _$UserInventoryImpl _value, $Res Function(_$UserInventoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownedItemIds = null,
    Object? purchaseRecordIds = null,
    Object? lastLuckyDrawAt = freezed,
    Object? luckyDrawCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserInventoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownedItemIds: null == ownedItemIds
          ? _value._ownedItemIds
          : ownedItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      purchaseRecordIds: null == purchaseRecordIds
          ? _value._purchaseRecordIds
          : purchaseRecordIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastLuckyDrawAt: freezed == lastLuckyDrawAt
          ? _value.lastLuckyDrawAt
          : lastLuckyDrawAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      luckyDrawCount: null == luckyDrawCount
          ? _value.luckyDrawCount
          : luckyDrawCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInventoryImpl extends _UserInventory {
  const _$UserInventoryImpl(
      {required this.id,
      final List<String> ownedItemIds = const <String>[],
      final List<String> purchaseRecordIds = const <String>[],
      this.lastLuckyDrawAt,
      this.luckyDrawCount = 0,
      required this.createdAt,
      required this.updatedAt})
      : _ownedItemIds = ownedItemIds,
        _purchaseRecordIds = purchaseRecordIds,
        super._();

  factory _$UserInventoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInventoryImplFromJson(json);

  @override
  final String id;
  final List<String> _ownedItemIds;
  @override
  @JsonKey()
  List<String> get ownedItemIds {
    if (_ownedItemIds is EqualUnmodifiableListView) return _ownedItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ownedItemIds);
  }

  final List<String> _purchaseRecordIds;
  @override
  @JsonKey()
  List<String> get purchaseRecordIds {
    if (_purchaseRecordIds is EqualUnmodifiableListView)
      return _purchaseRecordIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchaseRecordIds);
  }

  @override
  final DateTime? lastLuckyDrawAt;
  @override
  @JsonKey()
  final int luckyDrawCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserInventory(id: $id, ownedItemIds: $ownedItemIds, purchaseRecordIds: $purchaseRecordIds, lastLuckyDrawAt: $lastLuckyDrawAt, luckyDrawCount: $luckyDrawCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInventoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._ownedItemIds, _ownedItemIds) &&
            const DeepCollectionEquality()
                .equals(other._purchaseRecordIds, _purchaseRecordIds) &&
            (identical(other.lastLuckyDrawAt, lastLuckyDrawAt) ||
                other.lastLuckyDrawAt == lastLuckyDrawAt) &&
            (identical(other.luckyDrawCount, luckyDrawCount) ||
                other.luckyDrawCount == luckyDrawCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_ownedItemIds),
      const DeepCollectionEquality().hash(_purchaseRecordIds),
      lastLuckyDrawAt,
      luckyDrawCount,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInventoryImplCopyWith<_$UserInventoryImpl> get copyWith =>
      __$$UserInventoryImplCopyWithImpl<_$UserInventoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInventoryImplToJson(
      this,
    );
  }
}

abstract class _UserInventory extends UserInventory {
  const factory _UserInventory(
      {required final String id,
      final List<String> ownedItemIds,
      final List<String> purchaseRecordIds,
      final DateTime? lastLuckyDrawAt,
      final int luckyDrawCount,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserInventoryImpl;
  const _UserInventory._() : super._();

  factory _UserInventory.fromJson(Map<String, dynamic> json) =
      _$UserInventoryImpl.fromJson;

  @override
  String get id;
  @override
  List<String> get ownedItemIds;
  @override
  List<String> get purchaseRecordIds;
  @override
  DateTime? get lastLuckyDrawAt;
  @override
  int get luckyDrawCount;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserInventoryImplCopyWith<_$UserInventoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
