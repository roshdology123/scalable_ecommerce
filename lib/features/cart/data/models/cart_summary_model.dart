import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/cart_summary.dart';

part 'cart_summary_model.freezed.dart';
part 'cart_summary_model.g.dart';

@freezed
@HiveType(typeId: 11)
class CartSummaryModel with _$CartSummaryModel {
  const factory CartSummaryModel({
    @HiveField(0) required double subtotal,
    @HiveField(1) required double totalDiscount,
    @HiveField(2) required double totalTax,
    @HiveField(3) required double shippingCost,
    @HiveField(4) required double total,
    @HiveField(5) required int totalItems,
    @HiveField(6) required int totalQuantity,
    @HiveField(7) String? appliedCouponCode,
    @HiveField(8) double? couponDiscount,
    @HiveField(9) String? couponDescription,
    @HiveField(10) String? selectedShippingMethod,
    @HiveField(11) String? shippingMethodDescription,
    @HiveField(12) double? estimatedDeliveryDays,
    @HiveField(13) @Default(0.0) double taxRate,
    @HiveField(14) @Default(false) bool isFreeShipping,
    @HiveField(15) double? freeShippingThreshold,
    @HiveField(16) double? amountToFreeShipping,
    @HiveField(17) Map<String, double>? taxBreakdown,
    @HiveField(18) Map<String, double>? discountBreakdown,
    @HiveField(19) DateTime? lastCalculated,
    @HiveField(20) String? currency,
    @HiveField(21) @Default('USD') String currencyCode,
    @HiveField(22) Map<String, dynamic>? metadata,
  }) = _CartSummaryModel;

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ??
          (json['total_discount'] as num?)?.toDouble() ?? 0.0,
      totalTax: (json['totalTax'] as num?)?.toDouble() ??
          (json['total_tax'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ??
          (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      totalItems: json['totalItems'] as int? ?? json['total_items'] as int? ?? 0,
      totalQuantity: json['totalQuantity'] as int? ?? json['total_quantity'] as int? ?? 0,
      appliedCouponCode: json['appliedCouponCode']?.toString() ??
          json['applied_coupon_code']?.toString(),
      couponDiscount: (json['couponDiscount'] as num?)?.toDouble() ??
          (json['coupon_discount'] as num?)?.toDouble(),
      couponDescription: json['couponDescription']?.toString() ??
          json['coupon_description']?.toString(),
      selectedShippingMethod: json['selectedShippingMethod']?.toString() ??
          json['selected_shipping_method']?.toString(),
      shippingMethodDescription: json['shippingMethodDescription']?.toString() ??
          json['shipping_method_description']?.toString(),
      estimatedDeliveryDays: (json['estimatedDeliveryDays'] as num?)?.toDouble() ??
          (json['estimated_delivery_days'] as num?)?.toDouble(),
      taxRate: (json['taxRate'] as num?)?.toDouble() ??
          (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
      isFreeShipping: json['isFreeShipping'] as bool? ??
          json['is_free_shipping'] as bool? ?? false,
      freeShippingThreshold: (json['freeShippingThreshold'] as num?)?.toDouble() ??
          (json['free_shipping_threshold'] as num?)?.toDouble(),
      amountToFreeShipping: (json['amountToFreeShipping'] as num?)?.toDouble() ??
          (json['amount_to_free_shipping'] as num?)?.toDouble(),
      taxBreakdown: json['taxBreakdown'] != null
          ? Map<String, double>.from(
          (json['taxBreakdown'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
      )
          : json['tax_breakdown'] != null
          ? Map<String, double>.from(
          (json['tax_breakdown'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
      )
          : null,
      discountBreakdown: json['discountBreakdown'] != null
          ? Map<String, double>.from(
          (json['discountBreakdown'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
      )
          : json['discount_breakdown'] != null
          ? Map<String, double>.from(
          (json['discount_breakdown'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
      )
          : null,
      lastCalculated: json['lastCalculated'] != null
          ? DateTime.parse(json['lastCalculated'])
          : json['last_calculated'] != null
          ? DateTime.parse(json['last_calculated'])
          : DateTime.now(),
      currency: json['currency']?.toString(),
      currencyCode: json['currencyCode']?.toString() ??
          json['currency_code']?.toString() ?? 'USD',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory CartSummaryModel.fromCartSummary(CartSummary summary) {
    return CartSummaryModel(
      subtotal: summary.subtotal,
      totalDiscount: summary.totalDiscount,
      totalTax: summary.totalTax,
      shippingCost: summary.shippingCost,
      total: summary.total,
      totalItems: summary.totalItems,
      totalQuantity: summary.totalQuantity,
      appliedCouponCode: summary.appliedCouponCode,
      couponDiscount: summary.couponDiscount,
      couponDescription: summary.couponDescription,
      selectedShippingMethod: summary.selectedShippingMethod,
      shippingMethodDescription: summary.shippingMethodDescription,
      estimatedDeliveryDays: summary.estimatedDeliveryDays,
      taxRate: summary.taxRate,
      isFreeShipping: summary.isFreeShipping,
      freeShippingThreshold: summary.freeShippingThreshold,
      amountToFreeShipping: summary.amountToFreeShipping,
      taxBreakdown: summary.taxBreakdown,
      discountBreakdown: summary.discountBreakdown,
      lastCalculated: summary.lastCalculated,
      currency: summary.currency,
      currencyCode: summary.currencyCode,
      metadata: summary.metadata,
    );
  }
}

// Extension for CartSummaryModel
extension CartSummaryModelExtension on CartSummaryModel {
  CartSummary toCartSummary() {
    return CartSummary(
      subtotal: subtotal,
      totalDiscount: totalDiscount,
      totalTax: totalTax,
      shippingCost: shippingCost,
      total: total,
      totalItems: totalItems,
      totalQuantity: totalQuantity,
      appliedCouponCode: appliedCouponCode,
      couponDiscount: couponDiscount,
      couponDescription: couponDescription,
      selectedShippingMethod: selectedShippingMethod,
      shippingMethodDescription: shippingMethodDescription,
      estimatedDeliveryDays: estimatedDeliveryDays,
      taxRate: taxRate,
      isFreeShipping: isFreeShipping,
      freeShippingThreshold: freeShippingThreshold,
      amountToFreeShipping: amountToFreeShipping,
      taxBreakdown: taxBreakdown,
      discountBreakdown: discountBreakdown,
      lastCalculated: lastCalculated,
      currency: currency,
      currencyCode: currencyCode,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'totalDiscount': totalDiscount,
      'totalTax': totalTax,
      'shippingCost': shippingCost,
      'total': total,
      'totalItems': totalItems,
      'totalQuantity': totalQuantity,
      'appliedCouponCode': appliedCouponCode,
      'couponDiscount': couponDiscount,
      'couponDescription': couponDescription,
      'selectedShippingMethod': selectedShippingMethod,
      'shippingMethodDescription': shippingMethodDescription,
      'estimatedDeliveryDays': estimatedDeliveryDays,
      'taxRate': taxRate,
      'isFreeShipping': isFreeShipping,
      'freeShippingThreshold': freeShippingThreshold,
      'amountToFreeShipping': amountToFreeShipping,
      'taxBreakdown': taxBreakdown,
      'discountBreakdown': discountBreakdown,
      'lastCalculated': lastCalculated?.toIso8601String(),
      'currency': currency,
      'currencyCode': currencyCode,
      'metadata': metadata,
    };
  }
}