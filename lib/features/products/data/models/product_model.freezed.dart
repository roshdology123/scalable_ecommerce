// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProductModel {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  double get price => throw _privateConstructorUsedError;
  @HiveField(3)
  String get description => throw _privateConstructorUsedError;
  @HiveField(4)
  String get category => throw _privateConstructorUsedError;
  @HiveField(5)
  String get image => throw _privateConstructorUsedError;
  @HiveField(6)
  RatingModel get rating => throw _privateConstructorUsedError;
  @HiveField(7)
  List<String> get images => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get brand => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get sku => throw _privateConstructorUsedError;
  @HiveField(10)
  int get stock => throw _privateConstructorUsedError;
  @HiveField(11)
  double? get originalPrice => throw _privateConstructorUsedError;
  @HiveField(12)
  double? get discountPercentage => throw _privateConstructorUsedError;
  @HiveField(13)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(14)
  bool get isAvailable => throw _privateConstructorUsedError;
  @HiveField(15)
  bool get isFeatured => throw _privateConstructorUsedError;
  @HiveField(16)
  bool get isNew => throw _privateConstructorUsedError;
  @HiveField(17)
  bool get isOnSale => throw _privateConstructorUsedError;
  @HiveField(18)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(19)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(20)
  Map<String, dynamic>? get specifications =>
      throw _privateConstructorUsedError;
  @HiveField(21)
  List<String> get colors => throw _privateConstructorUsedError;
  @HiveField(22)
  List<String> get sizes => throw _privateConstructorUsedError;
  @HiveField(23)
  String? get weight => throw _privateConstructorUsedError;
  @HiveField(24)
  String? get dimensions => throw _privateConstructorUsedError;
  @HiveField(25)
  String? get material => throw _privateConstructorUsedError;
  @HiveField(26)
  String? get warranty => throw _privateConstructorUsedError;
  @HiveField(27)
  int get viewCount => throw _privateConstructorUsedError;
  @HiveField(28)
  int get purchaseCount => throw _privateConstructorUsedError;
  @HiveField(29)
  DateTime? get lastViewedAt => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String title,
      @HiveField(2) double price,
      @HiveField(3) String description,
      @HiveField(4) String category,
      @HiveField(5) String image,
      @HiveField(6) RatingModel rating,
      @HiveField(7) List<String> images,
      @HiveField(8) String? brand,
      @HiveField(9) String? sku,
      @HiveField(10) int stock,
      @HiveField(11) double? originalPrice,
      @HiveField(12) double? discountPercentage,
      @HiveField(13) List<String> tags,
      @HiveField(14) bool isAvailable,
      @HiveField(15) bool isFeatured,
      @HiveField(16) bool isNew,
      @HiveField(17) bool isOnSale,
      @HiveField(18) DateTime? createdAt,
      @HiveField(19) DateTime? updatedAt,
      @HiveField(20) Map<String, dynamic>? specifications,
      @HiveField(21) List<String> colors,
      @HiveField(22) List<String> sizes,
      @HiveField(23) String? weight,
      @HiveField(24) String? dimensions,
      @HiveField(25) String? material,
      @HiveField(26) String? warranty,
      @HiveField(27) int viewCount,
      @HiveField(28) int purchaseCount,
      @HiveField(29) DateTime? lastViewedAt});

  $RatingModelCopyWith<$Res> get rating;
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? description = null,
    Object? category = null,
    Object? image = null,
    Object? rating = null,
    Object? images = null,
    Object? brand = freezed,
    Object? sku = freezed,
    Object? stock = null,
    Object? originalPrice = freezed,
    Object? discountPercentage = freezed,
    Object? tags = null,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? isNew = null,
    Object? isOnSale = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? specifications = freezed,
    Object? colors = null,
    Object? sizes = null,
    Object? weight = freezed,
    Object? dimensions = freezed,
    Object? material = freezed,
    Object? warranty = freezed,
    Object? viewCount = null,
    Object? purchaseCount = null,
    Object? lastViewedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as RatingModel,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sizes: null == sizes
          ? _value.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as String?,
      material: freezed == material
          ? _value.material
          : material // ignore: cast_nullable_to_non_nullable
              as String?,
      warranty: freezed == warranty
          ? _value.warranty
          : warranty // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseCount: null == purchaseCount
          ? _value.purchaseCount
          : purchaseCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastViewedAt: freezed == lastViewedAt
          ? _value.lastViewedAt
          : lastViewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RatingModelCopyWith<$Res> get rating {
    return $RatingModelCopyWith<$Res>(_value.rating, (value) {
      return _then(_value.copyWith(rating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String title,
      @HiveField(2) double price,
      @HiveField(3) String description,
      @HiveField(4) String category,
      @HiveField(5) String image,
      @HiveField(6) RatingModel rating,
      @HiveField(7) List<String> images,
      @HiveField(8) String? brand,
      @HiveField(9) String? sku,
      @HiveField(10) int stock,
      @HiveField(11) double? originalPrice,
      @HiveField(12) double? discountPercentage,
      @HiveField(13) List<String> tags,
      @HiveField(14) bool isAvailable,
      @HiveField(15) bool isFeatured,
      @HiveField(16) bool isNew,
      @HiveField(17) bool isOnSale,
      @HiveField(18) DateTime? createdAt,
      @HiveField(19) DateTime? updatedAt,
      @HiveField(20) Map<String, dynamic>? specifications,
      @HiveField(21) List<String> colors,
      @HiveField(22) List<String> sizes,
      @HiveField(23) String? weight,
      @HiveField(24) String? dimensions,
      @HiveField(25) String? material,
      @HiveField(26) String? warranty,
      @HiveField(27) int viewCount,
      @HiveField(28) int purchaseCount,
      @HiveField(29) DateTime? lastViewedAt});

  @override
  $RatingModelCopyWith<$Res> get rating;
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? description = null,
    Object? category = null,
    Object? image = null,
    Object? rating = null,
    Object? images = null,
    Object? brand = freezed,
    Object? sku = freezed,
    Object? stock = null,
    Object? originalPrice = freezed,
    Object? discountPercentage = freezed,
    Object? tags = null,
    Object? isAvailable = null,
    Object? isFeatured = null,
    Object? isNew = null,
    Object? isOnSale = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? specifications = freezed,
    Object? colors = null,
    Object? sizes = null,
    Object? weight = freezed,
    Object? dimensions = freezed,
    Object? material = freezed,
    Object? warranty = freezed,
    Object? viewCount = null,
    Object? purchaseCount = null,
    Object? lastViewedAt = freezed,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as RatingModel,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      specifications: freezed == specifications
          ? _value._specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      colors: null == colors
          ? _value._colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sizes: null == sizes
          ? _value._sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as String?,
      material: freezed == material
          ? _value.material
          : material // ignore: cast_nullable_to_non_nullable
              as String?,
      warranty: freezed == warranty
          ? _value.warranty
          : warranty // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseCount: null == purchaseCount
          ? _value.purchaseCount
          : purchaseCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastViewedAt: freezed == lastViewedAt
          ? _value.lastViewedAt
          : lastViewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ProductModelImpl implements _ProductModel {
  const _$ProductModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.price,
      @HiveField(3) required this.description,
      @HiveField(4) required this.category,
      @HiveField(5) required this.image,
      @HiveField(6) required this.rating,
      @HiveField(7) final List<String> images = const [],
      @HiveField(8) this.brand,
      @HiveField(9) this.sku,
      @HiveField(10) this.stock = 0,
      @HiveField(11) this.originalPrice,
      @HiveField(12) this.discountPercentage,
      @HiveField(13) final List<String> tags = const [],
      @HiveField(14) this.isAvailable = true,
      @HiveField(15) this.isFeatured = false,
      @HiveField(16) this.isNew = false,
      @HiveField(17) this.isOnSale = false,
      @HiveField(18) this.createdAt,
      @HiveField(19) this.updatedAt,
      @HiveField(20) final Map<String, dynamic>? specifications,
      @HiveField(21) final List<String> colors = const [],
      @HiveField(22) final List<String> sizes = const [],
      @HiveField(23) this.weight,
      @HiveField(24) this.dimensions,
      @HiveField(25) this.material,
      @HiveField(26) this.warranty,
      @HiveField(27) this.viewCount = 0,
      @HiveField(28) this.purchaseCount = 0,
      @HiveField(29) this.lastViewedAt})
      : _images = images,
        _tags = tags,
        _specifications = specifications,
        _colors = colors,
        _sizes = sizes;

  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final double price;
  @override
  @HiveField(3)
  final String description;
  @override
  @HiveField(4)
  final String category;
  @override
  @HiveField(5)
  final String image;
  @override
  @HiveField(6)
  final RatingModel rating;
  final List<String> _images;
  @override
  @JsonKey()
  @HiveField(7)
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @HiveField(8)
  final String? brand;
  @override
  @HiveField(9)
  final String? sku;
  @override
  @JsonKey()
  @HiveField(10)
  final int stock;
  @override
  @HiveField(11)
  final double? originalPrice;
  @override
  @HiveField(12)
  final double? discountPercentage;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(13)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  @HiveField(14)
  final bool isAvailable;
  @override
  @JsonKey()
  @HiveField(15)
  final bool isFeatured;
  @override
  @JsonKey()
  @HiveField(16)
  final bool isNew;
  @override
  @JsonKey()
  @HiveField(17)
  final bool isOnSale;
  @override
  @HiveField(18)
  final DateTime? createdAt;
  @override
  @HiveField(19)
  final DateTime? updatedAt;
  final Map<String, dynamic>? _specifications;
  @override
  @HiveField(20)
  Map<String, dynamic>? get specifications {
    final value = _specifications;
    if (value == null) return null;
    if (_specifications is EqualUnmodifiableMapView) return _specifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String> _colors;
  @override
  @JsonKey()
  @HiveField(21)
  List<String> get colors {
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colors);
  }

  final List<String> _sizes;
  @override
  @JsonKey()
  @HiveField(22)
  List<String> get sizes {
    if (_sizes is EqualUnmodifiableListView) return _sizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sizes);
  }

  @override
  @HiveField(23)
  final String? weight;
  @override
  @HiveField(24)
  final String? dimensions;
  @override
  @HiveField(25)
  final String? material;
  @override
  @HiveField(26)
  final String? warranty;
  @override
  @JsonKey()
  @HiveField(27)
  final int viewCount;
  @override
  @JsonKey()
  @HiveField(28)
  final int purchaseCount;
  @override
  @HiveField(29)
  final DateTime? lastViewedAt;

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating, images: $images, brand: $brand, sku: $sku, stock: $stock, originalPrice: $originalPrice, discountPercentage: $discountPercentage, tags: $tags, isAvailable: $isAvailable, isFeatured: $isFeatured, isNew: $isNew, isOnSale: $isOnSale, createdAt: $createdAt, updatedAt: $updatedAt, specifications: $specifications, colors: $colors, sizes: $sizes, weight: $weight, dimensions: $dimensions, material: $material, warranty: $warranty, viewCount: $viewCount, purchaseCount: $purchaseCount, lastViewedAt: $lastViewedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isNew, isNew) || other.isNew == isNew) &&
            (identical(other.isOnSale, isOnSale) ||
                other.isOnSale == isOnSale) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._specifications, _specifications) &&
            const DeepCollectionEquality().equals(other._colors, _colors) &&
            const DeepCollectionEquality().equals(other._sizes, _sizes) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.dimensions, dimensions) ||
                other.dimensions == dimensions) &&
            (identical(other.material, material) ||
                other.material == material) &&
            (identical(other.warranty, warranty) ||
                other.warranty == warranty) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.purchaseCount, purchaseCount) ||
                other.purchaseCount == purchaseCount) &&
            (identical(other.lastViewedAt, lastViewedAt) ||
                other.lastViewedAt == lastViewedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        price,
        description,
        category,
        image,
        rating,
        const DeepCollectionEquality().hash(_images),
        brand,
        sku,
        stock,
        originalPrice,
        discountPercentage,
        const DeepCollectionEquality().hash(_tags),
        isAvailable,
        isFeatured,
        isNew,
        isOnSale,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_specifications),
        const DeepCollectionEquality().hash(_colors),
        const DeepCollectionEquality().hash(_sizes),
        weight,
        dimensions,
        material,
        warranty,
        viewCount,
        purchaseCount,
        lastViewedAt
      ]);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);
}

abstract class _ProductModel implements ProductModel {
  const factory _ProductModel(
      {@HiveField(0) required final int id,
      @HiveField(1) required final String title,
      @HiveField(2) required final double price,
      @HiveField(3) required final String description,
      @HiveField(4) required final String category,
      @HiveField(5) required final String image,
      @HiveField(6) required final RatingModel rating,
      @HiveField(7) final List<String> images,
      @HiveField(8) final String? brand,
      @HiveField(9) final String? sku,
      @HiveField(10) final int stock,
      @HiveField(11) final double? originalPrice,
      @HiveField(12) final double? discountPercentage,
      @HiveField(13) final List<String> tags,
      @HiveField(14) final bool isAvailable,
      @HiveField(15) final bool isFeatured,
      @HiveField(16) final bool isNew,
      @HiveField(17) final bool isOnSale,
      @HiveField(18) final DateTime? createdAt,
      @HiveField(19) final DateTime? updatedAt,
      @HiveField(20) final Map<String, dynamic>? specifications,
      @HiveField(21) final List<String> colors,
      @HiveField(22) final List<String> sizes,
      @HiveField(23) final String? weight,
      @HiveField(24) final String? dimensions,
      @HiveField(25) final String? material,
      @HiveField(26) final String? warranty,
      @HiveField(27) final int viewCount,
      @HiveField(28) final int purchaseCount,
      @HiveField(29) final DateTime? lastViewedAt}) = _$ProductModelImpl;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  double get price;
  @override
  @HiveField(3)
  String get description;
  @override
  @HiveField(4)
  String get category;
  @override
  @HiveField(5)
  String get image;
  @override
  @HiveField(6)
  RatingModel get rating;
  @override
  @HiveField(7)
  List<String> get images;
  @override
  @HiveField(8)
  String? get brand;
  @override
  @HiveField(9)
  String? get sku;
  @override
  @HiveField(10)
  int get stock;
  @override
  @HiveField(11)
  double? get originalPrice;
  @override
  @HiveField(12)
  double? get discountPercentage;
  @override
  @HiveField(13)
  List<String> get tags;
  @override
  @HiveField(14)
  bool get isAvailable;
  @override
  @HiveField(15)
  bool get isFeatured;
  @override
  @HiveField(16)
  bool get isNew;
  @override
  @HiveField(17)
  bool get isOnSale;
  @override
  @HiveField(18)
  DateTime? get createdAt;
  @override
  @HiveField(19)
  DateTime? get updatedAt;
  @override
  @HiveField(20)
  Map<String, dynamic>? get specifications;
  @override
  @HiveField(21)
  List<String> get colors;
  @override
  @HiveField(22)
  List<String> get sizes;
  @override
  @HiveField(23)
  String? get weight;
  @override
  @HiveField(24)
  String? get dimensions;
  @override
  @HiveField(25)
  String? get material;
  @override
  @HiveField(26)
  String? get warranty;
  @override
  @HiveField(27)
  int get viewCount;
  @override
  @HiveField(28)
  int get purchaseCount;
  @override
  @HiveField(29)
  DateTime? get lastViewedAt;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
