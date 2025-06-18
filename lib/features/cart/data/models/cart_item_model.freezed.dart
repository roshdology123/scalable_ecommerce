// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartItemModel {
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
  double get originalPrice => throw _privateConstructorUsedError;
  @HiveField(6)
  int get quantity => throw _privateConstructorUsedError;
  @HiveField(7)
  int get maxQuantity => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get selectedColor => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get selectedSize => throw _privateConstructorUsedError;
  @HiveField(10)
  Map<String, String> get selectedVariants =>
      throw _privateConstructorUsedError;
  @HiveField(11)
  bool get isAvailable => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get inStock => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get brand => throw _privateConstructorUsedError;
  @HiveField(14)
  String? get category => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get sku => throw _privateConstructorUsedError;
  @HiveField(16)
  double? get discountPercentage => throw _privateConstructorUsedError;
  @HiveField(17)
  double? get discountAmount => throw _privateConstructorUsedError;
  @HiveField(18)
  DateTime get addedAt => throw _privateConstructorUsedError;
  @HiveField(19)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(20)
  DateTime? get lastPriceCheck => throw _privateConstructorUsedError;
  @HiveField(21)
  bool get priceChanged => throw _privateConstructorUsedError;
  @HiveField(22)
  double? get previousPrice => throw _privateConstructorUsedError;
  @HiveField(23)
  bool get isSelected => throw _privateConstructorUsedError;
  @HiveField(24)
  String? get specialOfferId => throw _privateConstructorUsedError;
  @HiveField(25)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemModelCopyWith<CartItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemModelCopyWith<$Res> {
  factory $CartItemModelCopyWith(
          CartItemModel value, $Res Function(CartItemModel) then) =
      _$CartItemModelCopyWithImpl<$Res, CartItemModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) int productId,
      @HiveField(2) String productTitle,
      @HiveField(3) String productImage,
      @HiveField(4) double price,
      @HiveField(5) double originalPrice,
      @HiveField(6) int quantity,
      @HiveField(7) int maxQuantity,
      @HiveField(8) String? selectedColor,
      @HiveField(9) String? selectedSize,
      @HiveField(10) Map<String, String> selectedVariants,
      @HiveField(11) bool isAvailable,
      @HiveField(12) bool inStock,
      @HiveField(13) String? brand,
      @HiveField(14) String? category,
      @HiveField(15) String? sku,
      @HiveField(16) double? discountPercentage,
      @HiveField(17) double? discountAmount,
      @HiveField(18) DateTime addedAt,
      @HiveField(19) DateTime? updatedAt,
      @HiveField(20) DateTime? lastPriceCheck,
      @HiveField(21) bool priceChanged,
      @HiveField(22) double? previousPrice,
      @HiveField(23) bool isSelected,
      @HiveField(24) String? specialOfferId,
      @HiveField(25) Map<String, dynamic>? metadata});
}

/// @nodoc
class _$CartItemModelCopyWithImpl<$Res, $Val extends CartItemModel>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productTitle = null,
    Object? productImage = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? quantity = null,
    Object? maxQuantity = null,
    Object? selectedColor = freezed,
    Object? selectedSize = freezed,
    Object? selectedVariants = null,
    Object? isAvailable = null,
    Object? inStock = null,
    Object? brand = freezed,
    Object? category = freezed,
    Object? sku = freezed,
    Object? discountPercentage = freezed,
    Object? discountAmount = freezed,
    Object? addedAt = null,
    Object? updatedAt = freezed,
    Object? lastPriceCheck = freezed,
    Object? priceChanged = null,
    Object? previousPrice = freezed,
    Object? isSelected = null,
    Object? specialOfferId = freezed,
    Object? metadata = freezed,
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
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      maxQuantity: null == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      selectedColor: freezed == selectedColor
          ? _value.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSize: freezed == selectedSize
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVariants: null == selectedVariants
          ? _value.selectedVariants
          : selectedVariants // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastPriceCheck: freezed == lastPriceCheck
          ? _value.lastPriceCheck
          : lastPriceCheck // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priceChanged: null == priceChanged
          ? _value.priceChanged
          : priceChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      previousPrice: freezed == previousPrice
          ? _value.previousPrice
          : previousPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      specialOfferId: freezed == specialOfferId
          ? _value.specialOfferId
          : specialOfferId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartItemModelImplCopyWith<$Res>
    implements $CartItemModelCopyWith<$Res> {
  factory _$$CartItemModelImplCopyWith(
          _$CartItemModelImpl value, $Res Function(_$CartItemModelImpl) then) =
      __$$CartItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) int productId,
      @HiveField(2) String productTitle,
      @HiveField(3) String productImage,
      @HiveField(4) double price,
      @HiveField(5) double originalPrice,
      @HiveField(6) int quantity,
      @HiveField(7) int maxQuantity,
      @HiveField(8) String? selectedColor,
      @HiveField(9) String? selectedSize,
      @HiveField(10) Map<String, String> selectedVariants,
      @HiveField(11) bool isAvailable,
      @HiveField(12) bool inStock,
      @HiveField(13) String? brand,
      @HiveField(14) String? category,
      @HiveField(15) String? sku,
      @HiveField(16) double? discountPercentage,
      @HiveField(17) double? discountAmount,
      @HiveField(18) DateTime addedAt,
      @HiveField(19) DateTime? updatedAt,
      @HiveField(20) DateTime? lastPriceCheck,
      @HiveField(21) bool priceChanged,
      @HiveField(22) double? previousPrice,
      @HiveField(23) bool isSelected,
      @HiveField(24) String? specialOfferId,
      @HiveField(25) Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$CartItemModelImplCopyWithImpl<$Res>
    extends _$CartItemModelCopyWithImpl<$Res, _$CartItemModelImpl>
    implements _$$CartItemModelImplCopyWith<$Res> {
  __$$CartItemModelImplCopyWithImpl(
      _$CartItemModelImpl _value, $Res Function(_$CartItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productTitle = null,
    Object? productImage = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? quantity = null,
    Object? maxQuantity = null,
    Object? selectedColor = freezed,
    Object? selectedSize = freezed,
    Object? selectedVariants = null,
    Object? isAvailable = null,
    Object? inStock = null,
    Object? brand = freezed,
    Object? category = freezed,
    Object? sku = freezed,
    Object? discountPercentage = freezed,
    Object? discountAmount = freezed,
    Object? addedAt = null,
    Object? updatedAt = freezed,
    Object? lastPriceCheck = freezed,
    Object? priceChanged = null,
    Object? previousPrice = freezed,
    Object? isSelected = null,
    Object? specialOfferId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$CartItemModelImpl(
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
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      maxQuantity: null == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      selectedColor: freezed == selectedColor
          ? _value.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSize: freezed == selectedSize
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVariants: null == selectedVariants
          ? _value._selectedVariants
          : selectedVariants // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      inStock: null == inStock
          ? _value.inStock
          : inStock // ignore: cast_nullable_to_non_nullable
              as bool,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      discountPercentage: freezed == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastPriceCheck: freezed == lastPriceCheck
          ? _value.lastPriceCheck
          : lastPriceCheck // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priceChanged: null == priceChanged
          ? _value.priceChanged
          : priceChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      previousPrice: freezed == previousPrice
          ? _value.previousPrice
          : previousPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      specialOfferId: freezed == specialOfferId
          ? _value.specialOfferId
          : specialOfferId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$CartItemModelImpl implements _CartItemModel {
  const _$CartItemModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.productId,
      @HiveField(2) required this.productTitle,
      @HiveField(3) required this.productImage,
      @HiveField(4) required this.price,
      @HiveField(5) required this.originalPrice,
      @HiveField(6) required this.quantity,
      @HiveField(7) required this.maxQuantity,
      @HiveField(8) this.selectedColor,
      @HiveField(9) this.selectedSize,
      @HiveField(10) required final Map<String, String> selectedVariants,
      @HiveField(11) required this.isAvailable,
      @HiveField(12) required this.inStock,
      @HiveField(13) this.brand,
      @HiveField(14) this.category,
      @HiveField(15) this.sku,
      @HiveField(16) this.discountPercentage,
      @HiveField(17) this.discountAmount,
      @HiveField(18) required this.addedAt,
      @HiveField(19) this.updatedAt,
      @HiveField(20) this.lastPriceCheck,
      @HiveField(21) this.priceChanged = false,
      @HiveField(22) this.previousPrice,
      @HiveField(23) this.isSelected = false,
      @HiveField(24) this.specialOfferId,
      @HiveField(25) final Map<String, dynamic>? metadata})
      : _selectedVariants = selectedVariants,
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
  final double originalPrice;
  @override
  @HiveField(6)
  final int quantity;
  @override
  @HiveField(7)
  final int maxQuantity;
  @override
  @HiveField(8)
  final String? selectedColor;
  @override
  @HiveField(9)
  final String? selectedSize;
  final Map<String, String> _selectedVariants;
  @override
  @HiveField(10)
  Map<String, String> get selectedVariants {
    if (_selectedVariants is EqualUnmodifiableMapView) return _selectedVariants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectedVariants);
  }

  @override
  @HiveField(11)
  final bool isAvailable;
  @override
  @HiveField(12)
  final bool inStock;
  @override
  @HiveField(13)
  final String? brand;
  @override
  @HiveField(14)
  final String? category;
  @override
  @HiveField(15)
  final String? sku;
  @override
  @HiveField(16)
  final double? discountPercentage;
  @override
  @HiveField(17)
  final double? discountAmount;
  @override
  @HiveField(18)
  final DateTime addedAt;
  @override
  @HiveField(19)
  final DateTime? updatedAt;
  @override
  @HiveField(20)
  final DateTime? lastPriceCheck;
  @override
  @JsonKey()
  @HiveField(21)
  final bool priceChanged;
  @override
  @HiveField(22)
  final double? previousPrice;
  @override
  @JsonKey()
  @HiveField(23)
  final bool isSelected;
  @override
  @HiveField(24)
  final String? specialOfferId;
  final Map<String, dynamic>? _metadata;
  @override
  @HiveField(25)
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CartItemModel(id: $id, productId: $productId, productTitle: $productTitle, productImage: $productImage, price: $price, originalPrice: $originalPrice, quantity: $quantity, maxQuantity: $maxQuantity, selectedColor: $selectedColor, selectedSize: $selectedSize, selectedVariants: $selectedVariants, isAvailable: $isAvailable, inStock: $inStock, brand: $brand, category: $category, sku: $sku, discountPercentage: $discountPercentage, discountAmount: $discountAmount, addedAt: $addedAt, updatedAt: $updatedAt, lastPriceCheck: $lastPriceCheck, priceChanged: $priceChanged, previousPrice: $previousPrice, isSelected: $isSelected, specialOfferId: $specialOfferId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemModelImpl &&
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
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.maxQuantity, maxQuantity) ||
                other.maxQuantity == maxQuantity) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.selectedSize, selectedSize) ||
                other.selectedSize == selectedSize) &&
            const DeepCollectionEquality()
                .equals(other._selectedVariants, _selectedVariants) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.inStock, inStock) || other.inStock == inStock) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastPriceCheck, lastPriceCheck) ||
                other.lastPriceCheck == lastPriceCheck) &&
            (identical(other.priceChanged, priceChanged) ||
                other.priceChanged == priceChanged) &&
            (identical(other.previousPrice, previousPrice) ||
                other.previousPrice == previousPrice) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.specialOfferId, specialOfferId) ||
                other.specialOfferId == specialOfferId) &&
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
        quantity,
        maxQuantity,
        selectedColor,
        selectedSize,
        const DeepCollectionEquality().hash(_selectedVariants),
        isAvailable,
        inStock,
        brand,
        category,
        sku,
        discountPercentage,
        discountAmount,
        addedAt,
        updatedAt,
        lastPriceCheck,
        priceChanged,
        previousPrice,
        isSelected,
        specialOfferId,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemModelImplCopyWith<_$CartItemModelImpl> get copyWith =>
      __$$CartItemModelImplCopyWithImpl<_$CartItemModelImpl>(this, _$identity);
}

abstract class _CartItemModel implements CartItemModel {
  const factory _CartItemModel(
          {@HiveField(0) required final String id,
          @HiveField(1) required final int productId,
          @HiveField(2) required final String productTitle,
          @HiveField(3) required final String productImage,
          @HiveField(4) required final double price,
          @HiveField(5) required final double originalPrice,
          @HiveField(6) required final int quantity,
          @HiveField(7) required final int maxQuantity,
          @HiveField(8) final String? selectedColor,
          @HiveField(9) final String? selectedSize,
          @HiveField(10) required final Map<String, String> selectedVariants,
          @HiveField(11) required final bool isAvailable,
          @HiveField(12) required final bool inStock,
          @HiveField(13) final String? brand,
          @HiveField(14) final String? category,
          @HiveField(15) final String? sku,
          @HiveField(16) final double? discountPercentage,
          @HiveField(17) final double? discountAmount,
          @HiveField(18) required final DateTime addedAt,
          @HiveField(19) final DateTime? updatedAt,
          @HiveField(20) final DateTime? lastPriceCheck,
          @HiveField(21) final bool priceChanged,
          @HiveField(22) final double? previousPrice,
          @HiveField(23) final bool isSelected,
          @HiveField(24) final String? specialOfferId,
          @HiveField(25) final Map<String, dynamic>? metadata}) =
      _$CartItemModelImpl;

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
  double get originalPrice;
  @override
  @HiveField(6)
  int get quantity;
  @override
  @HiveField(7)
  int get maxQuantity;
  @override
  @HiveField(8)
  String? get selectedColor;
  @override
  @HiveField(9)
  String? get selectedSize;
  @override
  @HiveField(10)
  Map<String, String> get selectedVariants;
  @override
  @HiveField(11)
  bool get isAvailable;
  @override
  @HiveField(12)
  bool get inStock;
  @override
  @HiveField(13)
  String? get brand;
  @override
  @HiveField(14)
  String? get category;
  @override
  @HiveField(15)
  String? get sku;
  @override
  @HiveField(16)
  double? get discountPercentage;
  @override
  @HiveField(17)
  double? get discountAmount;
  @override
  @HiveField(18)
  DateTime get addedAt;
  @override
  @HiveField(19)
  DateTime? get updatedAt;
  @override
  @HiveField(20)
  DateTime? get lastPriceCheck;
  @override
  @HiveField(21)
  bool get priceChanged;
  @override
  @HiveField(22)
  double? get previousPrice;
  @override
  @HiveField(23)
  bool get isSelected;
  @override
  @HiveField(24)
  String? get specialOfferId;
  @override
  @HiveField(25)
  Map<String, dynamic>? get metadata;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemModelImplCopyWith<_$CartItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
