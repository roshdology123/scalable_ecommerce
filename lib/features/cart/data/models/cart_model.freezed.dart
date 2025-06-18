// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  List<CartItemModel> get items => throw _privateConstructorUsedError;
  @HiveField(3)
  CartSummaryModel get summary => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isSynced => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get hasPendingChanges => throw _privateConstructorUsedError;
  @HiveField(9)
  String get status => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get sessionId => throw _privateConstructorUsedError;
  @HiveField(11)
  Map<String, String>? get appliedCoupons => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get shippingAddress => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get billingAddress => throw _privateConstructorUsedError;
  @HiveField(14)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @HiveField(15)
  DateTime? get abandonedAt => throw _privateConstructorUsedError;
  @HiveField(16)
  int get version => throw _privateConstructorUsedError;
  @HiveField(17)
  List<String>? get conflictingFields => throw _privateConstructorUsedError;
  @HiveField(18)
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Create a copy of CartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartModelCopyWith<CartModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartModelCopyWith<$Res> {
  factory $CartModelCopyWith(CartModel value, $Res Function(CartModel) then) =
      _$CartModelCopyWithImpl<$Res, CartModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String? userId,
      @HiveField(2) List<CartItemModel> items,
      @HiveField(3) CartSummaryModel summary,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime updatedAt,
      @HiveField(6) DateTime? lastSyncedAt,
      @HiveField(7) bool isSynced,
      @HiveField(8) bool hasPendingChanges,
      @HiveField(9) String status,
      @HiveField(10) String? sessionId,
      @HiveField(11) Map<String, String>? appliedCoupons,
      @HiveField(12) String? shippingAddress,
      @HiveField(13) String? billingAddress,
      @HiveField(14) Map<String, dynamic>? metadata,
      @HiveField(15) DateTime? abandonedAt,
      @HiveField(16) int version,
      @HiveField(17) List<String>? conflictingFields,
      @HiveField(18) DateTime? expiresAt});

  $CartSummaryModelCopyWith<$Res> get summary;
}

/// @nodoc
class _$CartModelCopyWithImpl<$Res, $Val extends CartModel>
    implements $CartModelCopyWith<$Res> {
  _$CartModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? items = null,
    Object? summary = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isSynced = null,
    Object? hasPendingChanges = null,
    Object? status = null,
    Object? sessionId = freezed,
    Object? appliedCoupons = freezed,
    Object? shippingAddress = freezed,
    Object? billingAddress = freezed,
    Object? metadata = freezed,
    Object? abandonedAt = freezed,
    Object? version = null,
    Object? conflictingFields = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItemModel>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as CartSummaryModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPendingChanges: null == hasPendingChanges
          ? _value.hasPendingChanges
          : hasPendingChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedCoupons: freezed == appliedCoupons
          ? _value.appliedCoupons
          : appliedCoupons // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      billingAddress: freezed == billingAddress
          ? _value.billingAddress
          : billingAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      abandonedAt: freezed == abandonedAt
          ? _value.abandonedAt
          : abandonedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      conflictingFields: freezed == conflictingFields
          ? _value.conflictingFields
          : conflictingFields // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of CartModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartSummaryModelCopyWith<$Res> get summary {
    return $CartSummaryModelCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartModelImplCopyWith<$Res>
    implements $CartModelCopyWith<$Res> {
  factory _$$CartModelImplCopyWith(
          _$CartModelImpl value, $Res Function(_$CartModelImpl) then) =
      __$$CartModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String? userId,
      @HiveField(2) List<CartItemModel> items,
      @HiveField(3) CartSummaryModel summary,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime updatedAt,
      @HiveField(6) DateTime? lastSyncedAt,
      @HiveField(7) bool isSynced,
      @HiveField(8) bool hasPendingChanges,
      @HiveField(9) String status,
      @HiveField(10) String? sessionId,
      @HiveField(11) Map<String, String>? appliedCoupons,
      @HiveField(12) String? shippingAddress,
      @HiveField(13) String? billingAddress,
      @HiveField(14) Map<String, dynamic>? metadata,
      @HiveField(15) DateTime? abandonedAt,
      @HiveField(16) int version,
      @HiveField(17) List<String>? conflictingFields,
      @HiveField(18) DateTime? expiresAt});

  @override
  $CartSummaryModelCopyWith<$Res> get summary;
}

/// @nodoc
class __$$CartModelImplCopyWithImpl<$Res>
    extends _$CartModelCopyWithImpl<$Res, _$CartModelImpl>
    implements _$$CartModelImplCopyWith<$Res> {
  __$$CartModelImplCopyWithImpl(
      _$CartModelImpl _value, $Res Function(_$CartModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? items = null,
    Object? summary = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? isSynced = null,
    Object? hasPendingChanges = null,
    Object? status = null,
    Object? sessionId = freezed,
    Object? appliedCoupons = freezed,
    Object? shippingAddress = freezed,
    Object? billingAddress = freezed,
    Object? metadata = freezed,
    Object? abandonedAt = freezed,
    Object? version = null,
    Object? conflictingFields = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$CartModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItemModel>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as CartSummaryModel,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPendingChanges: null == hasPendingChanges
          ? _value.hasPendingChanges
          : hasPendingChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedCoupons: freezed == appliedCoupons
          ? _value._appliedCoupons
          : appliedCoupons // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      billingAddress: freezed == billingAddress
          ? _value.billingAddress
          : billingAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      abandonedAt: freezed == abandonedAt
          ? _value.abandonedAt
          : abandonedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      conflictingFields: freezed == conflictingFields
          ? _value._conflictingFields
          : conflictingFields // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CartModelImpl implements _CartModel {
  const _$CartModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) this.userId,
      @HiveField(2) required final List<CartItemModel> items,
      @HiveField(3) required this.summary,
      @HiveField(4) required this.createdAt,
      @HiveField(5) required this.updatedAt,
      @HiveField(6) this.lastSyncedAt,
      @HiveField(7) this.isSynced = false,
      @HiveField(8) this.hasPendingChanges = false,
      @HiveField(9) this.status = 'active',
      @HiveField(10) this.sessionId,
      @HiveField(11) final Map<String, String>? appliedCoupons,
      @HiveField(12) this.shippingAddress,
      @HiveField(13) this.billingAddress,
      @HiveField(14) final Map<String, dynamic>? metadata,
      @HiveField(15) this.abandonedAt,
      @HiveField(16) this.version = 0,
      @HiveField(17) final List<String>? conflictingFields,
      @HiveField(18) this.expiresAt})
      : _items = items,
        _appliedCoupons = appliedCoupons,
        _metadata = metadata,
        _conflictingFields = conflictingFields;

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String? userId;
  final List<CartItemModel> _items;
  @override
  @HiveField(2)
  List<CartItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @HiveField(3)
  final CartSummaryModel summary;
  @override
  @HiveField(4)
  final DateTime createdAt;
  @override
  @HiveField(5)
  final DateTime updatedAt;
  @override
  @HiveField(6)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isSynced;
  @override
  @JsonKey()
  @HiveField(8)
  final bool hasPendingChanges;
  @override
  @JsonKey()
  @HiveField(9)
  final String status;
  @override
  @HiveField(10)
  final String? sessionId;
  final Map<String, String>? _appliedCoupons;
  @override
  @HiveField(11)
  Map<String, String>? get appliedCoupons {
    final value = _appliedCoupons;
    if (value == null) return null;
    if (_appliedCoupons is EqualUnmodifiableMapView) return _appliedCoupons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @HiveField(12)
  final String? shippingAddress;
  @override
  @HiveField(13)
  final String? billingAddress;
  final Map<String, dynamic>? _metadata;
  @override
  @HiveField(14)
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @HiveField(15)
  final DateTime? abandonedAt;
  @override
  @JsonKey()
  @HiveField(16)
  final int version;
  final List<String>? _conflictingFields;
  @override
  @HiveField(17)
  List<String>? get conflictingFields {
    final value = _conflictingFields;
    if (value == null) return null;
    if (_conflictingFields is EqualUnmodifiableListView)
      return _conflictingFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @HiveField(18)
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'CartModel(id: $id, userId: $userId, items: $items, summary: $summary, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, isSynced: $isSynced, hasPendingChanges: $hasPendingChanges, status: $status, sessionId: $sessionId, appliedCoupons: $appliedCoupons, shippingAddress: $shippingAddress, billingAddress: $billingAddress, metadata: $metadata, abandonedAt: $abandonedAt, version: $version, conflictingFields: $conflictingFields, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.hasPendingChanges, hasPendingChanges) ||
                other.hasPendingChanges == hasPendingChanges) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality()
                .equals(other._appliedCoupons, _appliedCoupons) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.billingAddress, billingAddress) ||
                other.billingAddress == billingAddress) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.abandonedAt, abandonedAt) ||
                other.abandonedAt == abandonedAt) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality()
                .equals(other._conflictingFields, _conflictingFields) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        const DeepCollectionEquality().hash(_items),
        summary,
        createdAt,
        updatedAt,
        lastSyncedAt,
        isSynced,
        hasPendingChanges,
        status,
        sessionId,
        const DeepCollectionEquality().hash(_appliedCoupons),
        shippingAddress,
        billingAddress,
        const DeepCollectionEquality().hash(_metadata),
        abandonedAt,
        version,
        const DeepCollectionEquality().hash(_conflictingFields),
        expiresAt
      ]);

  /// Create a copy of CartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartModelImplCopyWith<_$CartModelImpl> get copyWith =>
      __$$CartModelImplCopyWithImpl<_$CartModelImpl>(this, _$identity);
}

abstract class _CartModel implements CartModel {
  const factory _CartModel(
      {@HiveField(0) required final String id,
      @HiveField(1) final String? userId,
      @HiveField(2) required final List<CartItemModel> items,
      @HiveField(3) required final CartSummaryModel summary,
      @HiveField(4) required final DateTime createdAt,
      @HiveField(5) required final DateTime updatedAt,
      @HiveField(6) final DateTime? lastSyncedAt,
      @HiveField(7) final bool isSynced,
      @HiveField(8) final bool hasPendingChanges,
      @HiveField(9) final String status,
      @HiveField(10) final String? sessionId,
      @HiveField(11) final Map<String, String>? appliedCoupons,
      @HiveField(12) final String? shippingAddress,
      @HiveField(13) final String? billingAddress,
      @HiveField(14) final Map<String, dynamic>? metadata,
      @HiveField(15) final DateTime? abandonedAt,
      @HiveField(16) final int version,
      @HiveField(17) final List<String>? conflictingFields,
      @HiveField(18) final DateTime? expiresAt}) = _$CartModelImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String? get userId;
  @override
  @HiveField(2)
  List<CartItemModel> get items;
  @override
  @HiveField(3)
  CartSummaryModel get summary;
  @override
  @HiveField(4)
  DateTime get createdAt;
  @override
  @HiveField(5)
  DateTime get updatedAt;
  @override
  @HiveField(6)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(7)
  bool get isSynced;
  @override
  @HiveField(8)
  bool get hasPendingChanges;
  @override
  @HiveField(9)
  String get status;
  @override
  @HiveField(10)
  String? get sessionId;
  @override
  @HiveField(11)
  Map<String, String>? get appliedCoupons;
  @override
  @HiveField(12)
  String? get shippingAddress;
  @override
  @HiveField(13)
  String? get billingAddress;
  @override
  @HiveField(14)
  Map<String, dynamic>? get metadata;
  @override
  @HiveField(15)
  DateTime? get abandonedAt;
  @override
  @HiveField(16)
  int get version;
  @override
  @HiveField(17)
  List<String>? get conflictingFields;
  @override
  @HiveField(18)
  DateTime? get expiresAt;

  /// Create a copy of CartModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartModelImplCopyWith<_$CartModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
