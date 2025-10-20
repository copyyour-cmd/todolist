// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FilterCondition _$FilterConditionFromJson(Map<String, dynamic> json) {
  return _FilterCondition.fromJson(json);
}

/// @nodoc
mixin _$FilterCondition {
  @HiveField(0)
  FilterField get field => throw _privateConstructorUsedError;
  @HiveField(1)
  FilterOperator get operator => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterConditionCopyWith<FilterCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterConditionCopyWith<$Res> {
  factory $FilterConditionCopyWith(
          FilterCondition value, $Res Function(FilterCondition) then) =
      _$FilterConditionCopyWithImpl<$Res, FilterCondition>;
  @useResult
  $Res call(
      {@HiveField(0) FilterField field,
      @HiveField(1) FilterOperator operator,
      @HiveField(2) String? value});
}

/// @nodoc
class _$FilterConditionCopyWithImpl<$Res, $Val extends FilterCondition>
    implements $FilterConditionCopyWith<$Res> {
  _$FilterConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? operator = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as FilterField,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as FilterOperator,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterConditionImplCopyWith<$Res>
    implements $FilterConditionCopyWith<$Res> {
  factory _$$FilterConditionImplCopyWith(_$FilterConditionImpl value,
          $Res Function(_$FilterConditionImpl) then) =
      __$$FilterConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) FilterField field,
      @HiveField(1) FilterOperator operator,
      @HiveField(2) String? value});
}

/// @nodoc
class __$$FilterConditionImplCopyWithImpl<$Res>
    extends _$FilterConditionCopyWithImpl<$Res, _$FilterConditionImpl>
    implements _$$FilterConditionImplCopyWith<$Res> {
  __$$FilterConditionImplCopyWithImpl(
      _$FilterConditionImpl _value, $Res Function(_$FilterConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? operator = null,
    Object? value = freezed,
  }) {
    return _then(_$FilterConditionImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as FilterField,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as FilterOperator,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterConditionImpl extends _FilterCondition {
  const _$FilterConditionImpl(
      {@HiveField(0) required this.field,
      @HiveField(1) required this.operator,
      @HiveField(2) this.value})
      : super._();

  factory _$FilterConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterConditionImplFromJson(json);

  @override
  @HiveField(0)
  final FilterField field;
  @override
  @HiveField(1)
  final FilterOperator operator;
  @override
  @HiveField(2)
  final String? value;

  @override
  String toString() {
    return 'FilterCondition(field: $field, operator: $operator, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterConditionImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, field, operator, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterConditionImplCopyWith<_$FilterConditionImpl> get copyWith =>
      __$$FilterConditionImplCopyWithImpl<_$FilterConditionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterConditionImplToJson(
      this,
    );
  }
}

abstract class _FilterCondition extends FilterCondition {
  const factory _FilterCondition(
      {@HiveField(0) required final FilterField field,
      @HiveField(1) required final FilterOperator operator,
      @HiveField(2) final String? value}) = _$FilterConditionImpl;
  const _FilterCondition._() : super._();

  factory _FilterCondition.fromJson(Map<String, dynamic> json) =
      _$FilterConditionImpl.fromJson;

  @override
  @HiveField(0)
  FilterField get field;
  @override
  @HiveField(1)
  FilterOperator get operator;
  @override
  @HiveField(2)
  String? get value;
  @override
  @JsonKey(ignore: true)
  _$$FilterConditionImplCopyWith<_$FilterConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SortConfig _$SortConfigFromJson(Map<String, dynamic> json) {
  return _SortConfig.fromJson(json);
}

/// @nodoc
mixin _$SortConfig {
  @HiveField(0)
  FilterField get field => throw _privateConstructorUsedError;
  @HiveField(1)
  SortOrder get order => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SortConfigCopyWith<SortConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortConfigCopyWith<$Res> {
  factory $SortConfigCopyWith(
          SortConfig value, $Res Function(SortConfig) then) =
      _$SortConfigCopyWithImpl<$Res, SortConfig>;
  @useResult
  $Res call({@HiveField(0) FilterField field, @HiveField(1) SortOrder order});
}

/// @nodoc
class _$SortConfigCopyWithImpl<$Res, $Val extends SortConfig>
    implements $SortConfigCopyWith<$Res> {
  _$SortConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as FilterField,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as SortOrder,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SortConfigImplCopyWith<$Res>
    implements $SortConfigCopyWith<$Res> {
  factory _$$SortConfigImplCopyWith(
          _$SortConfigImpl value, $Res Function(_$SortConfigImpl) then) =
      __$$SortConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) FilterField field, @HiveField(1) SortOrder order});
}

/// @nodoc
class __$$SortConfigImplCopyWithImpl<$Res>
    extends _$SortConfigCopyWithImpl<$Res, _$SortConfigImpl>
    implements _$$SortConfigImplCopyWith<$Res> {
  __$$SortConfigImplCopyWithImpl(
      _$SortConfigImpl _value, $Res Function(_$SortConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? order = null,
  }) {
    return _then(_$SortConfigImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as FilterField,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as SortOrder,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SortConfigImpl extends _SortConfig {
  const _$SortConfigImpl(
      {@HiveField(0) required this.field,
      @HiveField(1) this.order = SortOrder.ascending})
      : super._();

  factory _$SortConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SortConfigImplFromJson(json);

  @override
  @HiveField(0)
  final FilterField field;
  @override
  @JsonKey()
  @HiveField(1)
  final SortOrder order;

  @override
  String toString() {
    return 'SortConfig(field: $field, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortConfigImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, field, order);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SortConfigImplCopyWith<_$SortConfigImpl> get copyWith =>
      __$$SortConfigImplCopyWithImpl<_$SortConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SortConfigImplToJson(
      this,
    );
  }
}

abstract class _SortConfig extends SortConfig {
  const factory _SortConfig(
      {@HiveField(0) required final FilterField field,
      @HiveField(1) final SortOrder order}) = _$SortConfigImpl;
  const _SortConfig._() : super._();

  factory _SortConfig.fromJson(Map<String, dynamic> json) =
      _$SortConfigImpl.fromJson;

  @override
  @HiveField(0)
  FilterField get field;
  @override
  @HiveField(1)
  SortOrder get order;
  @override
  @JsonKey(ignore: true)
  _$$SortConfigImplCopyWith<_$SortConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomView _$CustomViewFromJson(Map<String, dynamic> json) {
  return _CustomView.fromJson(json);
}

/// @nodoc
mixin _$CustomView {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(3)
  ViewType get type => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(4)
  List<FilterCondition> get filters => throw _privateConstructorUsedError;
  @HiveField(5)
  SortConfig? get sortConfig => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isFavorite => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get icon => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get color => throw _privateConstructorUsedError;
  @HiveField(11)
  int get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomViewCopyWith<CustomView> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomViewCopyWith<$Res> {
  factory $CustomViewCopyWith(
          CustomView value, $Res Function(CustomView) then) =
      _$CustomViewCopyWithImpl<$Res, CustomView>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(3) ViewType type,
      @HiveField(9) DateTime createdAt,
      @HiveField(10) DateTime updatedAt,
      @HiveField(2) String? description,
      @HiveField(4) List<FilterCondition> filters,
      @HiveField(5) SortConfig? sortConfig,
      @HiveField(6) bool isFavorite,
      @HiveField(7) String? icon,
      @HiveField(8) String? color,
      @HiveField(11) int sortOrder});

  $SortConfigCopyWith<$Res>? get sortConfig;
}

/// @nodoc
class _$CustomViewCopyWithImpl<$Res, $Val extends CustomView>
    implements $CustomViewCopyWith<$Res> {
  _$CustomViewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? description = freezed,
    Object? filters = null,
    Object? sortConfig = freezed,
    Object? isFavorite = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? sortOrder = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ViewType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<FilterCondition>,
      sortConfig: freezed == sortConfig
          ? _value.sortConfig
          : sortConfig // ignore: cast_nullable_to_non_nullable
              as SortConfig?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SortConfigCopyWith<$Res>? get sortConfig {
    if (_value.sortConfig == null) {
      return null;
    }

    return $SortConfigCopyWith<$Res>(_value.sortConfig!, (value) {
      return _then(_value.copyWith(sortConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomViewImplCopyWith<$Res>
    implements $CustomViewCopyWith<$Res> {
  factory _$$CustomViewImplCopyWith(
          _$CustomViewImpl value, $Res Function(_$CustomViewImpl) then) =
      __$$CustomViewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(3) ViewType type,
      @HiveField(9) DateTime createdAt,
      @HiveField(10) DateTime updatedAt,
      @HiveField(2) String? description,
      @HiveField(4) List<FilterCondition> filters,
      @HiveField(5) SortConfig? sortConfig,
      @HiveField(6) bool isFavorite,
      @HiveField(7) String? icon,
      @HiveField(8) String? color,
      @HiveField(11) int sortOrder});

  @override
  $SortConfigCopyWith<$Res>? get sortConfig;
}

/// @nodoc
class __$$CustomViewImplCopyWithImpl<$Res>
    extends _$CustomViewCopyWithImpl<$Res, _$CustomViewImpl>
    implements _$$CustomViewImplCopyWith<$Res> {
  __$$CustomViewImplCopyWithImpl(
      _$CustomViewImpl _value, $Res Function(_$CustomViewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? description = freezed,
    Object? filters = null,
    Object? sortConfig = freezed,
    Object? isFavorite = null,
    Object? icon = freezed,
    Object? color = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_$CustomViewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ViewType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<FilterCondition>,
      sortConfig: freezed == sortConfig
          ? _value.sortConfig
          : sortConfig // ignore: cast_nullable_to_non_nullable
              as SortConfig?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomViewImpl extends _CustomView {
  const _$CustomViewImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(3) required this.type,
      @HiveField(9) required this.createdAt,
      @HiveField(10) required this.updatedAt,
      @HiveField(2) this.description,
      @HiveField(4) final List<FilterCondition> filters = const [],
      @HiveField(5) this.sortConfig,
      @HiveField(6) this.isFavorite = false,
      @HiveField(7) this.icon,
      @HiveField(8) this.color,
      @HiveField(11) this.sortOrder = 0})
      : _filters = filters,
        super._();

  factory _$CustomViewImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomViewImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(3)
  final ViewType type;
  @override
  @HiveField(9)
  final DateTime createdAt;
  @override
  @HiveField(10)
  final DateTime updatedAt;
  @override
  @HiveField(2)
  final String? description;
  final List<FilterCondition> _filters;
  @override
  @JsonKey()
  @HiveField(4)
  List<FilterCondition> get filters {
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filters);
  }

  @override
  @HiveField(5)
  final SortConfig? sortConfig;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isFavorite;
  @override
  @HiveField(7)
  final String? icon;
  @override
  @HiveField(8)
  final String? color;
  @override
  @JsonKey()
  @HiveField(11)
  final int sortOrder;

  @override
  String toString() {
    return 'CustomView(id: $id, name: $name, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, filters: $filters, sortConfig: $sortConfig, isFavorite: $isFavorite, icon: $icon, color: $color, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomViewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.sortConfig, sortConfig) ||
                other.sortConfig == sortConfig) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      createdAt,
      updatedAt,
      description,
      const DeepCollectionEquality().hash(_filters),
      sortConfig,
      isFavorite,
      icon,
      color,
      sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomViewImplCopyWith<_$CustomViewImpl> get copyWith =>
      __$$CustomViewImplCopyWithImpl<_$CustomViewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomViewImplToJson(
      this,
    );
  }
}

abstract class _CustomView extends CustomView {
  const factory _CustomView(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(3) required final ViewType type,
      @HiveField(9) required final DateTime createdAt,
      @HiveField(10) required final DateTime updatedAt,
      @HiveField(2) final String? description,
      @HiveField(4) final List<FilterCondition> filters,
      @HiveField(5) final SortConfig? sortConfig,
      @HiveField(6) final bool isFavorite,
      @HiveField(7) final String? icon,
      @HiveField(8) final String? color,
      @HiveField(11) final int sortOrder}) = _$CustomViewImpl;
  const _CustomView._() : super._();

  factory _CustomView.fromJson(Map<String, dynamic> json) =
      _$CustomViewImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(3)
  ViewType get type;
  @override
  @HiveField(9)
  DateTime get createdAt;
  @override
  @HiveField(10)
  DateTime get updatedAt;
  @override
  @HiveField(2)
  String? get description;
  @override
  @HiveField(4)
  List<FilterCondition> get filters;
  @override
  @HiveField(5)
  SortConfig? get sortConfig;
  @override
  @HiveField(6)
  bool get isFavorite;
  @override
  @HiveField(7)
  String? get icon;
  @override
  @HiveField(8)
  String? get color;
  @override
  @HiveField(11)
  int get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$CustomViewImplCopyWith<_$CustomViewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
