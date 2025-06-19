// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FavoriteItemModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  int get productId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get productTitle => throw _privateConstructorUsedError;
  @HiveField(3)
  String get productImage => throw _privateConstructorUsedError;
  @HiveField(4)
  double get price => throw _privateConstructorUsedError;
  @HiveField(5)
  double? get originalPrice => throw _privateConstructorUsedError;
  @HiveField(6)
  String get category => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get brand => throw _privateConstructorUsedError;
  @HiveField(8)
  double get rating => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isAvailable => throw _privateConstructorUsedError;
  @HiveField(10)
  bool get inStock => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime get addedAt => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime? get priceUpdatedAt => throw _privateConstructorUsedError;
  @HiveField(14)
  double? get previousPrice => throw _privateConstructorUsedError;
  @HiveField(15)
  bool get priceDropped => throw _privateConstructorUsedError;
  @HiveField(16)
  String? get collectionId => throw _privateConstructorUsedError;
  @HiveField(17)
  Map<String, String> get tags => throw _privateConstructorUsedError;
  @HiveField(18)
  int get viewCount => throw _privateConstructorUsedError;
  @HiveField(19)
  DateTime? get lastViewedAt => throw _privateConstructorUsedError;
  @HiveField(20)
  bool get isPriceTrackingEnabled => throw _privateConstructorUsedError;
  @HiveField(21)
  double? get targetPrice => throw _privateConstructorUsedError;
  @HiveField(22)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(23)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Create a copy of FavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteItemModelCopyWith<FavoriteItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteItemModelCopyWith<$Res> {
  factory $FavoriteItemModelCopyWith(
          FavoriteItemModel value, $Res Function(FavoriteItemModel) then) =
      _$FavoriteItemModelCopyWithImpl<$Res, FavoriteItemModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) int productId,
      @HiveField(2) String productTitle,
      @HiveField(3) String productImage,
      @HiveField(4) double price,
      @HiveField(5) double? originalPrice,
      @HiveField(6) String category,
      @HiveField(7) String? brand,
      @HiveField(8) double rating,
      @HiveField(9) bool isAvailable,
      @HiveField(10) bool inStock,
      @HiveField(11) DateTime addedAt,
      @HiveField(12) DateTime? updatedAt,
      @HiveField(13) DateTime? priceUpdatedAt,
      @HiveField(14) double? previousPrice,
      @HiveField(15) bool priceDropped,
      @HiveField(16) String? collectionId,
      @HiveField(17) Map<String, String> tags,
      @HiveField(18) int viewCount,
      @HiveField(19) DateTime? lastViewedAt,
      @HiveField(20) bool isPriceTrackingEnabled,
      @HiveField(21) double? targetPrice,
      @HiveField(22) String? notes,
      @HiveField(23) Map<String, dynamic> metadata});
}

/// @nodoc
class _$FavoriteItemModelCopyWithImpl<$Res, $Val extends FavoriteItemModel>
    implements $FavoriteItemModelCopyWith<$Res> {
  _$FavoriteItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productTitle = null,
    Object? productImage = null,
    Object? price = null,
    Object? originalPrice = freezed,
    Object? category = null,
    Object? brand = freezed,
    Object? rating = null,
    Object? isAvailable = null,
    Object? inStock = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
    Object? priceUpdatedAt = freezed,
    Object? previousPrice = freezed,
    Object? priceDropped = null,
    Object? collectionId = freezed,
    Object? tags = null,
    Object? viewCount = null,
    Object? lastViewedAt = freezed,
    Object? isPriceTrackingEnabled = null,
    Object? targetPrice = freezed,
    Object? notes = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productTitle: null == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priceUpdatedAt: freezed == priceUpdatedAt
          ? _value.priceUpdatedAt
          : priceUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      previousPrice: freezed == previousPrice
          ? _value.previousPrice
          : previousPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      priceDropped: null == priceDropped
          ? _value.priceDropped
          : priceDropped // ignore: cast_nullable_to_non_nullable
              as bool,
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastViewedAt: freezed == lastViewedAt
          ? _value.lastViewedAt
          : lastViewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPriceTrackingEnabled: null == isPriceTrackingEnabled
          ? _value.isPriceTrackingEnabled
          : isPriceTrackingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      targetPrice: freezed == targetPrice
          ? _value.targetPrice
          : targetPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoriteItemModelImplCopyWith<$Res>
    implements $FavoriteItemModelCopyWith<$Res> {
  factory _$$FavoriteItemModelImplCopyWith(_$FavoriteItemModelImpl value,
          $Res Function(_$FavoriteItemModelImpl) then) =
      __$$FavoriteItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) int productId,
      @HiveField(2) String productTitle,
      @HiveField(3) String productImage,
      @HiveField(4) double price,
      @HiveField(5) double? originalPrice,
      @HiveField(6) String category,
      @HiveField(7) String? brand,
      @HiveField(8) double rating,
      @HiveField(9) bool isAvailable,
      @HiveField(10) bool inStock,
      @HiveField(11) DateTime addedAt,
      @HiveField(12) DateTime? updatedAt,
      @HiveField(13) DateTime? priceUpdatedAt,
      @HiveField(14) double? previousPrice,
      @HiveField(15) bool priceDropped,
      @HiveField(16) String? collectionId,
      @HiveField(17) Map<String, String> tags,
      @HiveField(18) int viewCount,
      @HiveField(19) DateTime? lastViewedAt,
      @HiveField(20) bool isPriceTrackingEnabled,
      @HiveField(21) double? targetPrice,
      @HiveField(22) String? notes,
      @HiveField(23) Map<String, dynamic> metadata});
}

/// @nodoc
class __$$FavoriteItemModelImplCopyWithImpl<$Res>
    extends _$FavoriteItemModelCopyWithImpl<$Res, _$FavoriteItemModelImpl>
    implements _$$FavoriteItemModelImplCopyWith<$Res> {
  __$$FavoriteItemModelImplCopyWithImpl(_$FavoriteItemModelImpl _value,
      $Res Function(_$FavoriteItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productTitle = null,
    Object? productImage = null,
    Object? price = null,
    Object? originalPrice = freezed,
    Object? category = null,
    Object? brand = freezed,
    Object? rating = null,
    Object? isAvailable = null,
    Object? inStock = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
    Object? priceUpdatedAt = freezed,
    Object? previousPrice = freezed,
    Object? priceDropped = null,
    Object? collectionId = freezed,
    Object? tags = null,
    Object? viewCount = null,
    Object? lastViewedAt = freezed,
    Object? isPriceTrackingEnabled = null,
    Object? targetPrice = freezed,
    Object? notes = freezed,
    Object? metadata = null,
  }) {
    return _then(_$FavoriteItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productTitle: null == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: null == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priceUpdatedAt: freezed == priceUpdatedAt
          ? _value.priceUpdatedAt
          : priceUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      previousPrice: freezed == previousPrice
          ? _value.previousPrice
          : previousPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      priceDropped: null == priceDropped
          ? _value.priceDropped
          : priceDropped // ignore: cast_nullable_to_non_nullable
              as bool,
      collectionId: freezed == collectionId
          ? _value.collectionId
          : collectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastViewedAt: freezed == lastViewedAt
          ? _value.lastViewedAt
          : lastViewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPriceTrackingEnabled: null == isPriceTrackingEnabled
          ? _value.isPriceTrackingEnabled
          : isPriceTrackingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      targetPrice: freezed == targetPrice
          ? _value.targetPrice
          : targetPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$FavoriteItemModelImpl implements _FavoriteItemModel {
  const _$FavoriteItemModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.productId,
      @HiveField(2) required this.productTitle,
      @HiveField(3) required this.productImage,
      @HiveField(4) required this.price,
      @HiveField(5) this.originalPrice,
      @HiveField(6) required this.category,
      @HiveField(7) this.brand,
      @HiveField(8) required this.rating,
      @HiveField(9) required this.isAvailable,
      @HiveField(10) required this.inStock,
      @HiveField(11) required this.addedAt,
      @HiveField(12) this.updatedAt,
      @HiveField(13) this.priceUpdatedAt,
      @HiveField(14) this.previousPrice,
      @HiveField(15) this.priceDropped = false,
      @HiveField(16) this.collectionId,
      @HiveField(17) final Map<String, String> tags = const {},
      @HiveField(18) this.viewCount = 0,
      @HiveField(19) this.lastViewedAt,
      @HiveField(20) this.isPriceTrackingEnabled = false,
      @HiveField(21) this.targetPrice,
      @HiveField(22) this.notes,
      @HiveField(23) final Map<String, dynamic> metadata = const {}})
      : _tags = tags,
        _metadata = metadata;

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final int productId;
  @override
  @HiveField(2)
  final String productTitle;
  @override
  @HiveField(3)
  final String productImage;
  @override
  @HiveField(4)
  final double price;
  @override
  @HiveField(5)
  final double? originalPrice;
  @override
  @HiveField(6)
  final String category;
  @override
  @HiveField(7)
  final String? brand;
  @override
  @HiveField(8)
  final double rating;
  @override
  @HiveField(9)
  final bool isAvailable;
  @override
  @HiveField(10)
  final bool inStock;
  @override
  @HiveField(11)
  final DateTime addedAt;
  @override
  @HiveField(12)
  final DateTime? updatedAt;
  @override
  @HiveField(13)
  final DateTime? priceUpdatedAt;
  @override
  @HiveField(14)
  final double? previousPrice;
  @override
  @JsonKey()
  @HiveField(15)
  final bool priceDropped;
  @override
  @HiveField(16)
  final String? collectionId;
  final Map<String, String> _tags;
  @override
  @JsonKey()
  @HiveField(17)
  Map<String, String> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  @override
  @JsonKey()
  @HiveField(18)
  final int viewCount;
  @override
  @HiveField(19)
  final DateTime? lastViewedAt;
  @override
  @JsonKey()
  @HiveField(20)
  final bool isPriceTrackingEnabled;
  @override
  @HiveField(21)
  final double? targetPrice;
  @override
  @HiveField(22)
  final String? notes;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  @HiveField(23)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'FavoriteItemModel(id: $id, productId: $productId, productTitle: $productTitle, productImage: $productImage, price: $price, originalPrice: $originalPrice, category: $category, brand: $brand, rating: $rating, isAvailable: $isAvailable, inStock: $inStock, addedAt: $addedAt, updatedAt: $updatedAt, priceUpdatedAt: $priceUpdatedAt, previousPrice: $previousPrice, priceDropped: $priceDropped, collectionId: $collectionId, tags: $tags, viewCount: $viewCount, lastViewedAt: $lastViewedAt, isPriceTrackingEnabled: $isPriceTrackingEnabled, targetPrice: $targetPrice, notes: $notes, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productTitle, productTitle) ||
                other.productTitle == productTitle) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.inStock, inStock) || other.inStock == inStock) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.priceUpdatedAt, priceUpdatedAt) ||
                other.priceUpdatedAt == priceUpdatedAt) &&
            (identical(other.previousPrice, previousPrice) ||
                other.previousPrice == previousPrice) &&
            (identical(other.priceDropped, priceDropped) ||
                other.priceDropped == priceDropped) &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.lastViewedAt, lastViewedAt) ||
                other.lastViewedAt == lastViewedAt) &&
            (identical(other.isPriceTrackingEnabled, isPriceTrackingEnabled) ||
                other.isPriceTrackingEnabled == isPriceTrackingEnabled) &&
            (identical(other.targetPrice, targetPrice) ||
                other.targetPrice == targetPrice) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        productId,
        productTitle,
        productImage,
        price,
        originalPrice,
        category,
        brand,
        rating,
        isAvailable,
        inStock,
        addedAt,
        updatedAt,
        priceUpdatedAt,
        previousPrice,
        priceDropped,
        collectionId,
        const DeepCollectionEquality().hash(_tags),
        viewCount,
        lastViewedAt,
        isPriceTrackingEnabled,
        targetPrice,
        notes,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of FavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteItemModelImplCopyWith<_$FavoriteItemModelImpl> get copyWith =>
      __$$FavoriteItemModelImplCopyWithImpl<_$FavoriteItemModelImpl>(
          this, _$identity);
}

abstract class _FavoriteItemModel implements FavoriteItemModel {
  const factory _FavoriteItemModel(
          {@HiveField(0) required final String id,
          @HiveField(1) required final int productId,
          @HiveField(2) required final String productTitle,
          @HiveField(3) required final String productImage,
          @HiveField(4) required final double price,
          @HiveField(5) final double? originalPrice,
          @HiveField(6) required final String category,
          @HiveField(7) final String? brand,
          @HiveField(8) required final double rating,
          @HiveField(9) required final bool isAvailable,
          @HiveField(10) required final bool inStock,
          @HiveField(11) required final DateTime addedAt,
          @HiveField(12) final DateTime? updatedAt,
          @HiveField(13) final DateTime? priceUpdatedAt,
          @HiveField(14) final double? previousPrice,
          @HiveField(15) final bool priceDropped,
          @HiveField(16) final String? collectionId,
          @HiveField(17) final Map<String, String> tags,
          @HiveField(18) final int viewCount,
          @HiveField(19) final DateTime? lastViewedAt,
          @HiveField(20) final bool isPriceTrackingEnabled,
          @HiveField(21) final double? targetPrice,
          @HiveField(22) final String? notes,
          @HiveField(23) final Map<String, dynamic> metadata}) =
      _$FavoriteItemModelImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  int get productId;
  @override
  @HiveField(2)
  String get productTitle;
  @override
  @HiveField(3)
  String get productImage;
  @override
  @HiveField(4)
  double get price;
  @override
  @HiveField(5)
  double? get originalPrice;
  @override
  @HiveField(6)
  String get category;
  @override
  @HiveField(7)
  String? get brand;
  @override
  @HiveField(8)
  double get rating;
  @override
  @HiveField(9)
  bool get isAvailable;
  @override
  @HiveField(10)
  bool get inStock;
  @override
  @HiveField(11)
  DateTime get addedAt;
  @override
  @HiveField(12)
  DateTime? get updatedAt;
  @override
  @HiveField(13)
  DateTime? get priceUpdatedAt;
  @override
  @HiveField(14)
  double? get previousPrice;
  @override
  @HiveField(15)
  bool get priceDropped;
  @override
  @HiveField(16)
  String? get collectionId;
  @override
  @HiveField(17)
  Map<String, String> get tags;
  @override
  @HiveField(18)
  int get viewCount;
  @override
  @HiveField(19)
  DateTime? get lastViewedAt;
  @override
  @HiveField(20)
  bool get isPriceTrackingEnabled;
  @override
  @HiveField(21)
  double? get targetPrice;
  @override
  @HiveField(22)
  String? get notes;
  @override
  @HiveField(23)
  Map<String, dynamic> get metadata;

  /// Create a copy of FavoriteItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteItemModelImplCopyWith<_$FavoriteItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
