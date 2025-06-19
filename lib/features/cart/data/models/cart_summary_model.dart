import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/cart_summary.dart';
import 'cart_item_model.dart';

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
    // Ensure we have a proper Map<String, dynamic>
    final safeJson = _ensureStringKeyMap(json);

    return CartSummaryModel(
      subtotal: (safeJson['subtotal'] as num?)?.toDouble() ?? 0.0,
      totalDiscount: (safeJson['totalDiscount'] as num?)?.toDouble() ??
          (safeJson['total_discount'] as num?)?.toDouble() ?? 0.0,
      totalTax: (safeJson['totalTax'] as num?)?.toDouble() ??
          (safeJson['total_tax'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (safeJson['shippingCost'] as num?)?.toDouble() ??
          (safeJson['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      total: (safeJson['total'] as num?)?.toDouble() ?? 0.0,
      totalItems: safeJson['totalItems'] as int? ?? safeJson['total_items'] as int? ?? 0,
      totalQuantity: safeJson['totalQuantity'] as int? ?? safeJson['total_quantity'] as int? ?? 0,
      appliedCouponCode: safeJson['appliedCouponCode']?.toString() ??
          safeJson['applied_coupon_code']?.toString(),
      couponDiscount: (safeJson['couponDiscount'] as num?)?.toDouble() ??
          (safeJson['coupon_discount'] as num?)?.toDouble(),
      couponDescription: safeJson['couponDescription']?.toString() ??
          safeJson['coupon_description']?.toString(),
      selectedShippingMethod: safeJson['selectedShippingMethod']?.toString() ??
          safeJson['selected_shipping_method']?.toString(),
      shippingMethodDescription: safeJson['shippingMethodDescription']?.toString() ??
          safeJson['shipping_method_description']?.toString(),
      estimatedDeliveryDays: (safeJson['estimatedDeliveryDays'] as num?)?.toDouble() ??
          (safeJson['estimated_delivery_days'] as num?)?.toDouble(),
      taxRate: (safeJson['taxRate'] as num?)?.toDouble() ??
          (safeJson['tax_rate'] as num?)?.toDouble() ?? 0.0,
      isFreeShipping: safeJson['isFreeShipping'] as bool? ??
          safeJson['is_free_shipping'] as bool? ?? false,
      freeShippingThreshold: (safeJson['freeShippingThreshold'] as num?)?.toDouble() ??
          (safeJson['free_shipping_threshold'] as num?)?.toDouble(),
      amountToFreeShipping: (safeJson['amountToFreeShipping'] as num?)?.toDouble() ??
          (safeJson['amount_to_free_shipping'] as num?)?.toDouble(),
      taxBreakdown: _extractDoubleMap(safeJson['taxBreakdown'] ?? safeJson['tax_breakdown']),
      discountBreakdown: _extractDoubleMap(safeJson['discountBreakdown'] ?? safeJson['discount_breakdown']),
      lastCalculated: _parseDateTime(safeJson['lastCalculated'] ?? safeJson['last_calculated']),
      currency: safeJson['currency']?.toString(),
      currencyCode: safeJson['currencyCode']?.toString() ??
          safeJson['currency_code']?.toString() ?? 'USD',
      metadata: safeJson['metadata'] != null ? _ensureStringKeyMap(safeJson['metadata']) : null,
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

  /// Calculate summary from cart items
  factory CartSummaryModel.calculateFromItems(List<CartItemModel> items) {
    final totalQuantity = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final subtotal = items.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
    final totalDiscount = items.fold<double>(0, (sum, item) =>
    sum + ((item.discountAmount ?? 0) * item.quantity));

    // Simple tax calculation (8% for demo)
    const taxRate = 0.08;
    final totalTax = subtotal * taxRate;

    // Free shipping threshold
    const freeShippingThreshold = 50.0;
    final shippingCost = subtotal >= freeShippingThreshold ? 0.0 : 10.0;
    final isFreeShipping = subtotal >= freeShippingThreshold;
    final amountToFreeShipping = isFreeShipping ? 0.0 : freeShippingThreshold - subtotal;

    final total = subtotal - totalDiscount + totalTax + shippingCost;

    return CartSummaryModel(
      subtotal: subtotal,
      totalDiscount: totalDiscount,
      totalTax: totalTax,
      shippingCost: shippingCost,
      total: total,
      totalItems: items.length,
      totalQuantity: totalQuantity,
      taxRate: taxRate,
      isFreeShipping: isFreeShipping,
      freeShippingThreshold: freeShippingThreshold,
      amountToFreeShipping: amountToFreeShipping,
      lastCalculated: DateTime.now(),
    );
  }

  /// Helper methods
  static Map<String, dynamic> _ensureStringKeyMap(dynamic map) {
    if (map == null) return {};
    if (map is Map<String, dynamic>) return map;
    if (map is Map) {
      return Map<String, dynamic>.from(map);
    }
    return {};
  }

  static Map<String, double>? _extractDoubleMap(dynamic map) {
    if (map == null) return null;
    if (map is Map<String, double>) return map;
    if (map is Map) {
      try {
        return Map<String, double>.from(
            map.map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return null;
      }
    }
    return null;
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