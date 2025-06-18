// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartSummaryModel {
  @HiveField(0)
  double get subtotal => throw _privateConstructorUsedError;
  @HiveField(1)
  double get totalDiscount => throw _privateConstructorUsedError;
  @HiveField(2)
  double get totalTax => throw _privateConstructorUsedError;
  @HiveField(3)
  double get shippingCost => throw _privateConstructorUsedError;
  @HiveField(4)
  double get total => throw _privateConstructorUsedError;
  @HiveField(5)
  int get totalItems => throw _privateConstructorUsedError;
  @HiveField(6)
  int get totalQuantity => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get appliedCouponCode => throw _privateConstructorUsedError;
  @HiveField(8)
  double? get couponDiscount => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get couponDescription => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get selectedShippingMethod => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get shippingMethodDescription => throw _privateConstructorUsedError;
  @HiveField(12)
  double? get estimatedDeliveryDays => throw _privateConstructorUsedError;
  @HiveField(13)
  double get taxRate => throw _privateConstructorUsedError;
  @HiveField(14)
  bool get isFreeShipping => throw _privateConstructorUsedError;
  @HiveField(15)
  double? get freeShippingThreshold => throw _privateConstructorUsedError;
  @HiveField(16)
  double? get amountToFreeShipping => throw _privateConstructorUsedError;
  @HiveField(17)
  Map<String, double>? get taxBreakdown => throw _privateConstructorUsedError;
  @HiveField(18)
  Map<String, double>? get discountBreakdown =>
      throw _privateConstructorUsedError;
  @HiveField(19)
  DateTime? get lastCalculated => throw _privateConstructorUsedError;
  @HiveField(20)
  String? get currency => throw _privateConstructorUsedError;
  @HiveField(21)
  String get currencyCode => throw _privateConstructorUsedError;
  @HiveField(22)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartSummaryModelCopyWith<CartSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartSummaryModelCopyWith<$Res> {
  factory $CartSummaryModelCopyWith(
          CartSummaryModel value, $Res Function(CartSummaryModel) then) =
      _$CartSummaryModelCopyWithImpl<$Res, CartSummaryModel>;
  @useResult
  $Res call(
      {@HiveField(0) double subtotal,
      @HiveField(1) double totalDiscount,
      @HiveField(2) double totalTax,
      @HiveField(3) double shippingCost,
      @HiveField(4) double total,
      @HiveField(5) int totalItems,
      @HiveField(6) int totalQuantity,
      @HiveField(7) String? appliedCouponCode,
      @HiveField(8) double? couponDiscount,
      @HiveField(9) String? couponDescription,
      @HiveField(10) String? selectedShippingMethod,
      @HiveField(11) String? shippingMethodDescription,
      @HiveField(12) double? estimatedDeliveryDays,
      @HiveField(13) double taxRate,
      @HiveField(14) bool isFreeShipping,
      @HiveField(15) double? freeShippingThreshold,
      @HiveField(16) double? amountToFreeShipping,
      @HiveField(17) Map<String, double>? taxBreakdown,
      @HiveField(18) Map<String, double>? discountBreakdown,
      @HiveField(19) DateTime? lastCalculated,
      @HiveField(20) String? currency,
      @HiveField(21) String currencyCode,
      @HiveField(22) Map<String, dynamic>? metadata});
}

/// @nodoc
class _$CartSummaryModelCopyWithImpl<$Res, $Val extends CartSummaryModel>
    implements $CartSummaryModelCopyWith<$Res> {
  _$CartSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? totalDiscount = null,
    Object? totalTax = null,
    Object? shippingCost = null,
    Object? total = null,
    Object? totalItems = null,
    Object? totalQuantity = null,
    Object? appliedCouponCode = freezed,
    Object? couponDiscount = freezed,
    Object? couponDescription = freezed,
    Object? selectedShippingMethod = freezed,
    Object? shippingMethodDescription = freezed,
    Object? estimatedDeliveryDays = freezed,
    Object? taxRate = null,
    Object? isFreeShipping = null,
    Object? freeShippingThreshold = freezed,
    Object? amountToFreeShipping = freezed,
    Object? taxBreakdown = freezed,
    Object? discountBreakdown = freezed,
    Object? lastCalculated = freezed,
    Object? currency = freezed,
    Object? currencyCode = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      totalDiscount: null == totalDiscount
          ? _value.totalDiscount
          : totalDiscount // ignore: cast_nullable_to_non_nullable
              as double,
      totalTax: null == totalTax
          ? _value.totalTax
          : totalTax // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      appliedCouponCode: freezed == appliedCouponCode
          ? _value.appliedCouponCode
          : appliedCouponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      couponDiscount: freezed == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      couponDescription: freezed == couponDescription
          ? _value.couponDescription
          : couponDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedShippingMethod: freezed == selectedShippingMethod
          ? _value.selectedShippingMethod
          : selectedShippingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingMethodDescription: freezed == shippingMethodDescription
          ? _value.shippingMethodDescription
          : shippingMethodDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDeliveryDays: freezed == estimatedDeliveryDays
          ? _value.estimatedDeliveryDays
          : estimatedDeliveryDays // ignore: cast_nullable_to_non_nullable
              as double?,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      isFreeShipping: null == isFreeShipping
          ? _value.isFreeShipping
          : isFreeShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      freeShippingThreshold: freezed == freeShippingThreshold
          ? _value.freeShippingThreshold
          : freeShippingThreshold // ignore: cast_nullable_to_non_nullable
              as double?,
      amountToFreeShipping: freezed == amountToFreeShipping
          ? _value.amountToFreeShipping
          : amountToFreeShipping // ignore: cast_nullable_to_non_nullable
              as double?,
      taxBreakdown: freezed == taxBreakdown
          ? _value.taxBreakdown
          : taxBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      discountBreakdown: freezed == discountBreakdown
          ? _value.discountBreakdown
          : discountBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      lastCalculated: freezed == lastCalculated
          ? _value.lastCalculated
          : lastCalculated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartSummaryModelImplCopyWith<$Res>
    implements $CartSummaryModelCopyWith<$Res> {
  factory _$$CartSummaryModelImplCopyWith(_$CartSummaryModelImpl value,
          $Res Function(_$CartSummaryModelImpl) then) =
      __$$CartSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) double subtotal,
      @HiveField(1) double totalDiscount,
      @HiveField(2) double totalTax,
      @HiveField(3) double shippingCost,
      @HiveField(4) double total,
      @HiveField(5) int totalItems,
      @HiveField(6) int totalQuantity,
      @HiveField(7) String? appliedCouponCode,
      @HiveField(8) double? couponDiscount,
      @HiveField(9) String? couponDescription,
      @HiveField(10) String? selectedShippingMethod,
      @HiveField(11) String? shippingMethodDescription,
      @HiveField(12) double? estimatedDeliveryDays,
      @HiveField(13) double taxRate,
      @HiveField(14) bool isFreeShipping,
      @HiveField(15) double? freeShippingThreshold,
      @HiveField(16) double? amountToFreeShipping,
      @HiveField(17) Map<String, double>? taxBreakdown,
      @HiveField(18) Map<String, double>? discountBreakdown,
      @HiveField(19) DateTime? lastCalculated,
      @HiveField(20) String? currency,
      @HiveField(21) String currencyCode,
      @HiveField(22) Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$CartSummaryModelImplCopyWithImpl<$Res>
    extends _$CartSummaryModelCopyWithImpl<$Res, _$CartSummaryModelImpl>
    implements _$$CartSummaryModelImplCopyWith<$Res> {
  __$$CartSummaryModelImplCopyWithImpl(_$CartSummaryModelImpl _value,
      $Res Function(_$CartSummaryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
    Object? totalDiscount = null,
    Object? totalTax = null,
    Object? shippingCost = null,
    Object? total = null,
    Object? totalItems = null,
    Object? totalQuantity = null,
    Object? appliedCouponCode = freezed,
    Object? couponDiscount = freezed,
    Object? couponDescription = freezed,
    Object? selectedShippingMethod = freezed,
    Object? shippingMethodDescription = freezed,
    Object? estimatedDeliveryDays = freezed,
    Object? taxRate = null,
    Object? isFreeShipping = null,
    Object? freeShippingThreshold = freezed,
    Object? amountToFreeShipping = freezed,
    Object? taxBreakdown = freezed,
    Object? discountBreakdown = freezed,
    Object? lastCalculated = freezed,
    Object? currency = freezed,
    Object? currencyCode = null,
    Object? metadata = freezed,
  }) {
    return _then(_$CartSummaryModelImpl(
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      totalDiscount: null == totalDiscount
          ? _value.totalDiscount
          : totalDiscount // ignore: cast_nullable_to_non_nullable
              as double,
      totalTax: null == totalTax
          ? _value.totalTax
          : totalTax // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      appliedCouponCode: freezed == appliedCouponCode
          ? _value.appliedCouponCode
          : appliedCouponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      couponDiscount: freezed == couponDiscount
          ? _value.couponDiscount
          : couponDiscount // ignore: cast_nullable_to_non_nullable
              as double?,
      couponDescription: freezed == couponDescription
          ? _value.couponDescription
          : couponDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedShippingMethod: freezed == selectedShippingMethod
          ? _value.selectedShippingMethod
          : selectedShippingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingMethodDescription: freezed == shippingMethodDescription
          ? _value.shippingMethodDescription
          : shippingMethodDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDeliveryDays: freezed == estimatedDeliveryDays
          ? _value.estimatedDeliveryDays
          : estimatedDeliveryDays // ignore: cast_nullable_to_non_nullable
              as double?,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      isFreeShipping: null == isFreeShipping
          ? _value.isFreeShipping
          : isFreeShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      freeShippingThreshold: freezed == freeShippingThreshold
          ? _value.freeShippingThreshold
          : freeShippingThreshold // ignore: cast_nullable_to_non_nullable
              as double?,
      amountToFreeShipping: freezed == amountToFreeShipping
          ? _value.amountToFreeShipping
          : amountToFreeShipping // ignore: cast_nullable_to_non_nullable
              as double?,
      taxBreakdown: freezed == taxBreakdown
          ? _value._taxBreakdown
          : taxBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      discountBreakdown: freezed == discountBreakdown
          ? _value._discountBreakdown
          : discountBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      lastCalculated: freezed == lastCalculated
          ? _value.lastCalculated
          : lastCalculated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$CartSummaryModelImpl implements _CartSummaryModel {
  const _$CartSummaryModelImpl(
      {@HiveField(0) required this.subtotal,
      @HiveField(1) required this.totalDiscount,
      @HiveField(2) required this.totalTax,
      @HiveField(3) required this.shippingCost,
      @HiveField(4) required this.total,
      @HiveField(5) required this.totalItems,
      @HiveField(6) required this.totalQuantity,
      @HiveField(7) this.appliedCouponCode,
      @HiveField(8) this.couponDiscount,
      @HiveField(9) this.couponDescription,
      @HiveField(10) this.selectedShippingMethod,
      @HiveField(11) this.shippingMethodDescription,
      @HiveField(12) this.estimatedDeliveryDays,
      @HiveField(13) this.taxRate = 0.0,
      @HiveField(14) this.isFreeShipping = false,
      @HiveField(15) this.freeShippingThreshold,
      @HiveField(16) this.amountToFreeShipping,
      @HiveField(17) final Map<String, double>? taxBreakdown,
      @HiveField(18) final Map<String, double>? discountBreakdown,
      @HiveField(19) this.lastCalculated,
      @HiveField(20) this.currency,
      @HiveField(21) this.currencyCode = 'USD',
      @HiveField(22) final Map<String, dynamic>? metadata})
      : _taxBreakdown = taxBreakdown,
        _discountBreakdown = discountBreakdown,
        _metadata = metadata;

  @override
  @HiveField(0)
  final double subtotal;
  @override
  @HiveField(1)
  final double totalDiscount;
  @override
  @HiveField(2)
  final double totalTax;
  @override
  @HiveField(3)
  final double shippingCost;
  @override
  @HiveField(4)
  final double total;
  @override
  @HiveField(5)
  final int totalItems;
  @override
  @HiveField(6)
  final int totalQuantity;
  @override
  @HiveField(7)
  final String? appliedCouponCode;
  @override
  @HiveField(8)
  final double? couponDiscount;
  @override
  @HiveField(9)
  final String? couponDescription;
  @override
  @HiveField(10)
  final String? selectedShippingMethod;
  @override
  @HiveField(11)
  final String? shippingMethodDescription;
  @override
  @HiveField(12)
  final double? estimatedDeliveryDays;
  @override
  @JsonKey()
  @HiveField(13)
  final double taxRate;
  @override
  @JsonKey()
  @HiveField(14)
  final bool isFreeShipping;
  @override
  @HiveField(15)
  final double? freeShippingThreshold;
  @override
  @HiveField(16)
  final double? amountToFreeShipping;
  final Map<String, double>? _taxBreakdown;
  @override
  @HiveField(17)
  Map<String, double>? get taxBreakdown {
    final value = _taxBreakdown;
    if (value == null) return null;
    if (_taxBreakdown is EqualUnmodifiableMapView) return _taxBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, double>? _discountBreakdown;
  @override
  @HiveField(18)
  Map<String, double>? get discountBreakdown {
    final value = _discountBreakdown;
    if (value == null) return null;
    if (_discountBreakdown is EqualUnmodifiableMapView)
      return _discountBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @HiveField(19)
  final DateTime? lastCalculated;
  @override
  @HiveField(20)
  final String? currency;
  @override
  @JsonKey()
  @HiveField(21)
  final String currencyCode;
  final Map<String, dynamic>? _metadata;
  @override
  @HiveField(22)
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CartSummaryModel(subtotal: $subtotal, totalDiscount: $totalDiscount, totalTax: $totalTax, shippingCost: $shippingCost, total: $total, totalItems: $totalItems, totalQuantity: $totalQuantity, appliedCouponCode: $appliedCouponCode, couponDiscount: $couponDiscount, couponDescription: $couponDescription, selectedShippingMethod: $selectedShippingMethod, shippingMethodDescription: $shippingMethodDescription, estimatedDeliveryDays: $estimatedDeliveryDays, taxRate: $taxRate, isFreeShipping: $isFreeShipping, freeShippingThreshold: $freeShippingThreshold, amountToFreeShipping: $amountToFreeShipping, taxBreakdown: $taxBreakdown, discountBreakdown: $discountBreakdown, lastCalculated: $lastCalculated, currency: $currency, currencyCode: $currencyCode, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartSummaryModelImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.totalDiscount, totalDiscount) ||
                other.totalDiscount == totalDiscount) &&
            (identical(other.totalTax, totalTax) ||
                other.totalTax == totalTax) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.appliedCouponCode, appliedCouponCode) ||
                other.appliedCouponCode == appliedCouponCode) &&
            (identical(other.couponDiscount, couponDiscount) ||
                other.couponDiscount == couponDiscount) &&
            (identical(other.couponDescription, couponDescription) ||
                other.couponDescription == couponDescription) &&
            (identical(other.selectedShippingMethod, selectedShippingMethod) ||
                other.selectedShippingMethod == selectedShippingMethod) &&
            (identical(other.shippingMethodDescription,
                    shippingMethodDescription) ||
                other.shippingMethodDescription == shippingMethodDescription) &&
            (identical(other.estimatedDeliveryDays, estimatedDeliveryDays) ||
                other.estimatedDeliveryDays == estimatedDeliveryDays) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.isFreeShipping, isFreeShipping) ||
                other.isFreeShipping == isFreeShipping) &&
            (identical(other.freeShippingThreshold, freeShippingThreshold) ||
                other.freeShippingThreshold == freeShippingThreshold) &&
            (identical(other.amountToFreeShipping, amountToFreeShipping) ||
                other.amountToFreeShipping == amountToFreeShipping) &&
            const DeepCollectionEquality()
                .equals(other._taxBreakdown, _taxBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._discountBreakdown, _discountBreakdown) &&
            (identical(other.lastCalculated, lastCalculated) ||
                other.lastCalculated == lastCalculated) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        subtotal,
        totalDiscount,
        totalTax,
        shippingCost,
        total,
        totalItems,
        totalQuantity,
        appliedCouponCode,
        couponDiscount,
        couponDescription,
        selectedShippingMethod,
        shippingMethodDescription,
        estimatedDeliveryDays,
        taxRate,
        isFreeShipping,
        freeShippingThreshold,
        amountToFreeShipping,
        const DeepCollectionEquality().hash(_taxBreakdown),
        const DeepCollectionEquality().hash(_discountBreakdown),
        lastCalculated,
        currency,
        currencyCode,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartSummaryModelImplCopyWith<_$CartSummaryModelImpl> get copyWith =>
      __$$CartSummaryModelImplCopyWithImpl<_$CartSummaryModelImpl>(
          this, _$identity);
}

abstract class _CartSummaryModel implements CartSummaryModel {
  const factory _CartSummaryModel(
          {@HiveField(0) required final double subtotal,
          @HiveField(1) required final double totalDiscount,
          @HiveField(2) required final double totalTax,
          @HiveField(3) required final double shippingCost,
          @HiveField(4) required final double total,
          @HiveField(5) required final int totalItems,
          @HiveField(6) required final int totalQuantity,
          @HiveField(7) final String? appliedCouponCode,
          @HiveField(8) final double? couponDiscount,
          @HiveField(9) final String? couponDescription,
          @HiveField(10) final String? selectedShippingMethod,
          @HiveField(11) final String? shippingMethodDescription,
          @HiveField(12) final double? estimatedDeliveryDays,
          @HiveField(13) final double taxRate,
          @HiveField(14) final bool isFreeShipping,
          @HiveField(15) final double? freeShippingThreshold,
          @HiveField(16) final double? amountToFreeShipping,
          @HiveField(17) final Map<String, double>? taxBreakdown,
          @HiveField(18) final Map<String, double>? discountBreakdown,
          @HiveField(19) final DateTime? lastCalculated,
          @HiveField(20) final String? currency,
          @HiveField(21) final String currencyCode,
          @HiveField(22) final Map<String, dynamic>? metadata}) =
      _$CartSummaryModelImpl;

  @override
  @HiveField(0)
  double get subtotal;
  @override
  @HiveField(1)
  double get totalDiscount;
  @override
  @HiveField(2)
  double get totalTax;
  @override
  @HiveField(3)
  double get shippingCost;
  @override
  @HiveField(4)
  double get total;
  @override
  @HiveField(5)
  int get totalItems;
  @override
  @HiveField(6)
  int get totalQuantity;
  @override
  @HiveField(7)
  String? get appliedCouponCode;
  @override
  @HiveField(8)
  double? get couponDiscount;
  @override
  @HiveField(9)
  String? get couponDescription;
  @override
  @HiveField(10)
  String? get selectedShippingMethod;
  @override
  @HiveField(11)
  String? get shippingMethodDescription;
  @override
  @HiveField(12)
  double? get estimatedDeliveryDays;
  @override
  @HiveField(13)
  double get taxRate;
  @override
  @HiveField(14)
  bool get isFreeShipping;
  @override
  @HiveField(15)
  double? get freeShippingThreshold;
  @override
  @HiveField(16)
  double? get amountToFreeShipping;
  @override
  @HiveField(17)
  Map<String, double>? get taxBreakdown;
  @override
  @HiveField(18)
  Map<String, double>? get discountBreakdown;
  @override
  @HiveField(19)
  DateTime? get lastCalculated;
  @override
  @HiveField(20)
  String? get currency;
  @override
  @HiveField(21)
  String get currencyCode;
  @override
  @HiveField(22)
  Map<String, dynamic>? get metadata;

  /// Create a copy of CartSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartSummaryModelImplCopyWith<_$CartSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
