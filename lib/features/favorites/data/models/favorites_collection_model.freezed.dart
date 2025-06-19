// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_collection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FavoritesCollectionModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get icon => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get color => throw _privateConstructorUsedError;
  @HiveField(5)
  List<String> get productIds => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isDefault => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isSmartCollection => throw _privateConstructorUsedError;
  @HiveField(8)
  Map<String, dynamic>? get smartRules => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(11)
  bool get isPublic => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get shareToken => throw _privateConstructorUsedError;
  @HiveField(13)
  int get sortOrder => throw _privateConstructorUsedError;
  @HiveField(14)
  Map<String, String> get tags => throw _privateConstructorUsedError;
  @HiveField(15)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Create a copy of FavoritesCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoritesCollectionModelCopyWith<FavoritesCollectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritesCollectionModelCopyWith<$Res> {
  factory $FavoritesCollectionModelCopyWith(FavoritesCollectionModel value,
          $Res Function(FavoritesCollectionModel) then) =
      _$FavoritesCollectionModelCopyWithImpl<$Res, FavoritesCollectionModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String? description,
      @HiveField(3) String? icon,
      @HiveField(4) String? color,
      @HiveField(5) List<String> productIds,
      @HiveField(6) bool isDefault,
      @HiveField(7) bool isSmartCollection,
      @HiveField(8) Map<String, dynamic>? smartRules,
      @HiveField(9) DateTime createdAt,
      @HiveField(10) DateTime updatedAt,
      @HiveField(11) bool isPublic,
      @HiveField(12) String? shareToken,
      @HiveField(13) int sortOrder,
      @HiveField(14) Map<String, String> tags,
      @HiveField(15) Map<String, dynamic> metadata});
}

/// @nodoc
class _$FavoritesCollectionModelCopyWithImpl<$Res,
        $Val extends FavoritesCollectionModel>
    implements $FavoritesCollectionModelCopyWith<$Res> {
  _$FavoritesCollectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoritesCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? productIds = null,
    Object? isDefault = null,
    Object? isSmartCollection = null,
    Object? smartRules = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isPublic = null,
    Object? shareToken = freezed,
    Object? sortOrder = null,
    Object? tags = null,
    Object? metadata = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      productIds: null == productIds
          ? _value.productIds
          : productIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmartCollection: null == isSmartCollection
          ? _value.isSmartCollection
          : isSmartCollection // ignore: cast_nullable_to_non_nullable
              as bool,
      smartRules: freezed == smartRules
          ? _value.smartRules
          : smartRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoritesCollectionModelImplCopyWith<$Res>
    implements $FavoritesCollectionModelCopyWith<$Res> {
  factory _$$FavoritesCollectionModelImplCopyWith(
          _$FavoritesCollectionModelImpl value,
          $Res Function(_$FavoritesCollectionModelImpl) then) =
      __$$FavoritesCollectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String? description,
      @HiveField(3) String? icon,
      @HiveField(4) String? color,
      @HiveField(5) List<String> productIds,
      @HiveField(6) bool isDefault,
      @HiveField(7) bool isSmartCollection,
      @HiveField(8) Map<String, dynamic>? smartRules,
      @HiveField(9) DateTime createdAt,
      @HiveField(10) DateTime updatedAt,
      @HiveField(11) bool isPublic,
      @HiveField(12) String? shareToken,
      @HiveField(13) int sortOrder,
      @HiveField(14) Map<String, String> tags,
      @HiveField(15) Map<String, dynamic> metadata});
}

/// @nodoc
class __$$FavoritesCollectionModelImplCopyWithImpl<$Res>
    extends _$FavoritesCollectionModelCopyWithImpl<$Res,
        _$FavoritesCollectionModelImpl>
    implements _$$FavoritesCollectionModelImplCopyWith<$Res> {
  __$$FavoritesCollectionModelImplCopyWithImpl(
      _$FavoritesCollectionModelImpl _value,
      $Res Function(_$FavoritesCollectionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoritesCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? productIds = null,
    Object? isDefault = null,
    Object? isSmartCollection = null,
    Object? smartRules = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isPublic = null,
    Object? shareToken = freezed,
    Object? sortOrder = null,
    Object? tags = null,
    Object? metadata = null,
  }) {
    return _then(_$FavoritesCollectionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      productIds: null == productIds
          ? _value._productIds
          : productIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmartCollection: null == isSmartCollection
          ? _value.isSmartCollection
          : isSmartCollection // ignore: cast_nullable_to_non_nullable
              as bool,
      smartRules: freezed == smartRules
          ? _value._smartRules
          : smartRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: freezed == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$FavoritesCollectionModelImpl implements _FavoritesCollectionModel {
  const _$FavoritesCollectionModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) this.description,
      @HiveField(3) this.icon,
      @HiveField(4) this.color,
      @HiveField(5) final List<String> productIds = const [],
      @HiveField(6) this.isDefault = false,
      @HiveField(7) this.isSmartCollection = false,
      @HiveField(8) final Map<String, dynamic>? smartRules,
      @HiveField(9) required this.createdAt,
      @HiveField(10) required this.updatedAt,
      @HiveField(11) this.isPublic = false,
      @HiveField(12) this.shareToken,
      @HiveField(13) this.sortOrder = 0,
      @HiveField(14) final Map<String, String> tags = const {},
      @HiveField(15) final Map<String, dynamic> metadata = const {}})
      : _productIds = productIds,
        _smartRules = smartRules,
        _tags = tags,
        _metadata = metadata;

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String? description;
  @override
  @HiveField(3)
  final String? icon;
  @override
  @HiveField(4)
  final String? color;
  final List<String> _productIds;
  @override
  @JsonKey()
  @HiveField(5)
  List<String> get productIds {
    if (_productIds is EqualUnmodifiableListView) return _productIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productIds);
  }

  @override
  @JsonKey()
  @HiveField(6)
  final bool isDefault;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isSmartCollection;
  final Map<String, dynamic>? _smartRules;
  @override
  @HiveField(8)
  Map<String, dynamic>? get smartRules {
    final value = _smartRules;
    if (value == null) return null;
    if (_smartRules is EqualUnmodifiableMapView) return _smartRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @HiveField(9)
  final DateTime createdAt;
  @override
  @HiveField(10)
  final DateTime updatedAt;
  @override
  @JsonKey()
  @HiveField(11)
  final bool isPublic;
  @override
  @HiveField(12)
  final String? shareToken;
  @override
  @JsonKey()
  @HiveField(13)
  final int sortOrder;
  final Map<String, String> _tags;
  @override
  @JsonKey()
  @HiveField(14)
  Map<String, String> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  @HiveField(15)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'FavoritesCollectionModel(id: $id, name: $name, description: $description, icon: $icon, color: $color, productIds: $productIds, isDefault: $isDefault, isSmartCollection: $isSmartCollection, smartRules: $smartRules, createdAt: $createdAt, updatedAt: $updatedAt, isPublic: $isPublic, shareToken: $shareToken, sortOrder: $sortOrder, tags: $tags, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritesCollectionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality()
                .equals(other._productIds, _productIds) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isSmartCollection, isSmartCollection) ||
                other.isSmartCollection == isSmartCollection) &&
            const DeepCollectionEquality()
                .equals(other._smartRules, _smartRules) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.shareToken, shareToken) ||
                other.shareToken == shareToken) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      icon,
      color,
      const DeepCollectionEquality().hash(_productIds),
      isDefault,
      isSmartCollection,
      const DeepCollectionEquality().hash(_smartRules),
      createdAt,
      updatedAt,
      isPublic,
      shareToken,
      sortOrder,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of FavoritesCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritesCollectionModelImplCopyWith<_$FavoritesCollectionModelImpl>
      get copyWith => __$$FavoritesCollectionModelImplCopyWithImpl<
          _$FavoritesCollectionModelImpl>(this, _$identity);
}

abstract class _FavoritesCollectionModel implements FavoritesCollectionModel {
  const factory _FavoritesCollectionModel(
          {@HiveField(0) required final String id,
          @HiveField(1) required final String name,
          @HiveField(2) final String? description,
          @HiveField(3) final String? icon,
          @HiveField(4) final String? color,
          @HiveField(5) final List<String> productIds,
          @HiveField(6) final bool isDefault,
          @HiveField(7) final bool isSmartCollection,
          @HiveField(8) final Map<String, dynamic>? smartRules,
          @HiveField(9) required final DateTime createdAt,
          @HiveField(10) required final DateTime updatedAt,
          @HiveField(11) final bool isPublic,
          @HiveField(12) final String? shareToken,
          @HiveField(13) final int sortOrder,
          @HiveField(14) final Map<String, String> tags,
          @HiveField(15) final Map<String, dynamic> metadata}) =
      _$FavoritesCollectionModelImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String? get description;
  @override
  @HiveField(3)
  String? get icon;
  @override
  @HiveField(4)
  String? get color;
  @override
  @HiveField(5)
  List<String> get productIds;
  @override
  @HiveField(6)
  bool get isDefault;
  @override
  @HiveField(7)
  bool get isSmartCollection;
  @override
  @HiveField(8)
  Map<String, dynamic>? get smartRules;
  @override
  @HiveField(9)
  DateTime get createdAt;
  @override
  @HiveField(10)
  DateTime get updatedAt;
  @override
  @HiveField(11)
  bool get isPublic;
  @override
  @HiveField(12)
  String? get shareToken;
  @override
  @HiveField(13)
  int get sortOrder;
  @override
  @HiveField(14)
  Map<String, String> get tags;
  @override
  @HiveField(15)
  Map<String, dynamic> get metadata;

  /// Create a copy of FavoritesCollectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoritesCollectionModelImplCopyWith<_$FavoritesCollectionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
