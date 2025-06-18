import 'package:equatable/equatable.dart';

class CartSummary extends Equatable {
  final double subtotal;
  final double totalDiscount;
  final double totalTax;
  final double shippingCost;
  final double total;
  final int totalItems;
  final int totalQuantity;
  final String? appliedCouponCode;
  final double? couponDiscount;
  final String? couponDescription;
  final String? selectedShippingMethod;
  final String? shippingMethodDescription;
  final double? estimatedDeliveryDays;
  final double taxRate;
  final bool isFreeShipping;
  final double? freeShippingThreshold;
  final double? amountToFreeShipping;
  final Map<String, double>? taxBreakdown;
  final Map<String, double>? discountBreakdown;
  final DateTime? lastCalculated;
  final String? currency;
  final String currencyCode;
  final Map<String, dynamic>? metadata;

  const CartSummary({
    required this.subtotal,
    required this.totalDiscount,
    required this.totalTax,
    required this.shippingCost,
    required this.total,
    required this.totalItems,
    required this.totalQuantity,
    this.appliedCouponCode,
    this.couponDiscount,
    this.couponDescription,
    this.selectedShippingMethod,
    this.shippingMethodDescription,
    this.estimatedDeliveryDays,
    this.taxRate = 0.0,
    this.isFreeShipping = false,
    this.freeShippingThreshold,
    this.amountToFreeShipping,
    this.taxBreakdown,
    this.discountBreakdown,
    this.lastCalculated,
    this.currency,
    this.currencyCode = 'USD',
    this.metadata,
  });

  /// Business Logic Methods

  /// Check if cart is empty
  bool get isEmpty => totalItems == 0;

  /// Check if cart has items
  bool get hasItems => totalItems > 0;

  /// Check if cart qualifies for free shipping
  bool get qualifiesForFreeShipping {
    if (freeShippingThreshold == null) return isFreeShipping;
    return subtotal >= freeShippingThreshold!;
  }

  /// Get savings from discounts
  double get totalSavings => totalDiscount + (couponDiscount ?? 0.0);

  /// Check if any coupon is applied
  bool get hasCouponApplied => appliedCouponCode != null && couponDiscount != null;

  /// Get effective tax rate
  double get effectiveTaxRate => subtotal > 0 ? (totalTax / subtotal) : 0.0;

  /// Get shipping rate as percentage of subtotal
  double get shippingRate => subtotal > 0 ? (shippingCost / subtotal) : 0.0;

  /// Get discount rate as percentage of subtotal
  double get discountRate => subtotal > 0 ? (totalSavings / subtotal) : 0.0;

  /// Calculate total before discounts
  double get totalBeforeDiscounts => subtotal + totalTax + shippingCost;

  /// Calculate grand total with all adjustments
  double get grandTotal => total;

  /// Get average item price
  double get averageItemPrice => totalItems > 0 ? subtotal / totalItems : 0.0;

  /// Get average quantity per item
  double get averageQuantityPerItem => totalItems > 0 ? totalQuantity / totalItems : 0.0;

  /// Check if cart is over a certain threshold
  bool isOverThreshold(double threshold) => subtotal >= threshold;

  /// Get formatted currency amounts
  String get formattedSubtotal => formatCurrency(subtotal);
  String get formattedTotalDiscount => formatCurrency(totalDiscount);
  String get formattedTotalTax => formatCurrency(totalTax);
  String get formattedShippingCost => formatCurrency(shippingCost);
  String get formattedTotal => formatCurrency(total);
  String get formattedTotalSavings => formatCurrency(totalSavings);
  String get formattedCouponDiscount => formatCurrency(couponDiscount ?? 0.0);
  String get formattedAmountToFreeShipping => formatCurrency(amountToFreeShipping ?? 0.0);

  /// Format currency based on currency code
  String formatCurrency(double amount) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${amount.toStringAsFixed(0)}';
      default:
        return '$currencyCode ${amount.toStringAsFixed(2)}';
    }
  }

  /// Get shipping status message
  String get shippingStatusMessage {
    if (isFreeShipping) {
      return 'Free shipping applied';
    } else if (freeShippingThreshold != null && amountToFreeShipping != null) {
      if (amountToFreeShipping! > 0) {
        return 'Add ${formattedAmountToFreeShipping} more for free shipping';
      } else {
        return 'Qualifies for free shipping';
      }
    } else if (shippingCost > 0) {
      return 'Shipping: ${formattedShippingCost}';
    } else {
      return 'Shipping calculated at checkout';
    }
  }

  /// Get estimated delivery message
  String get estimatedDeliveryMessage {
    if (estimatedDeliveryDays == null) return 'Delivery time varies';

    final days = estimatedDeliveryDays!.round();
    if (days == 0) {
      return 'Same-day delivery';
    } else if (days == 1) {
      return 'Next-day delivery';
    } else if (days <= 3) {
      return '$days-day delivery';
    } else if (days <= 7) {
      return '${days}+ days delivery';
    } else {
      return '1-2 weeks delivery';
    }
  }

  /// Get cart health score (0-100)
  int get cartHealthScore {
    int score = 100;

    // Penalize for no items
    if (isEmpty) return 0;

    // Bonus for free shipping
    if (isFreeShipping) score += 10;

    // Bonus for discounts
    if (totalSavings > 0) score += 5;

    // Bonus for coupons
    if (hasCouponApplied) score += 10;

    // Penalize for high shipping cost
    if (shippingCost > subtotal * 0.1) score -= 10;

    // Penalize for high tax
    if (totalTax > subtotal * 0.12) score -= 5;

    return score.clamp(0, 100);
  }

  /// Check if summary needs recalculation
  bool get needsRecalculation {
    if (lastCalculated == null) return true;
    return DateTime.now().difference(lastCalculated!).inMinutes > 30;
  }

  /// Get breakdown of total cost
  Map<String, double> get costBreakdown => {
    'Subtotal': subtotal,
    'Tax': totalTax,
    'Shipping': shippingCost,
    'Discounts': -totalSavings,
    'Total': total,
  };

  /// Get promotional messages
  List<String> get promotionalMessages {
    final messages = <String>[];

    if (freeShippingThreshold != null && amountToFreeShipping != null && amountToFreeShipping! > 0) {
      messages.add('Add ${formattedAmountToFreeShipping} more for FREE shipping! 🚚');
    }

    if (totalSavings > 0) {
      messages.add('You\'re saving ${formattedTotalSavings}! 💰');
    }

    if (isFreeShipping) {
      messages.add('FREE shipping applied! 🎉');
    }

    return messages;
  }

  CartSummary copyWith({
    double? subtotal,
    double? totalDiscount,
    double? totalTax,
    double? shippingCost,
    double? total,
    int? totalItems,
    int? totalQuantity,
    String? appliedCouponCode,
    double? couponDiscount,
    String? couponDescription,
    String? selectedShippingMethod,
    String? shippingMethodDescription,
    double? estimatedDeliveryDays,
    double? taxRate,
    bool? isFreeShipping,
    double? freeShippingThreshold,
    double? amountToFreeShipping,
    Map<String, double>? taxBreakdown,
    Map<String, double>? discountBreakdown,
    DateTime? lastCalculated,
    String? currency,
    String? currencyCode,
    Map<String, dynamic>? metadata,
  }) {
    return CartSummary(
      subtotal: subtotal ?? this.subtotal,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalTax: totalTax ?? this.totalTax,
      shippingCost: shippingCost ?? this.shippingCost,
      total: total ?? this.total,
      totalItems: totalItems ?? this.totalItems,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      couponDescription: couponDescription ?? this.couponDescription,
      selectedShippingMethod: selectedShippingMethod ?? this.selectedShippingMethod,
      shippingMethodDescription: shippingMethodDescription ?? this.shippingMethodDescription,
      estimatedDeliveryDays: estimatedDeliveryDays ?? this.estimatedDeliveryDays,
      taxRate: taxRate ?? this.taxRate,
      isFreeShipping: isFreeShipping ?? this.isFreeShipping,
      freeShippingThreshold: freeShippingThreshold ?? this.freeShippingThreshold,
      amountToFreeShipping: amountToFreeShipping ?? this.amountToFreeShipping,
      taxBreakdown: taxBreakdown ?? this.taxBreakdown,
      discountBreakdown: discountBreakdown ?? this.discountBreakdown,
      lastCalculated: lastCalculated ?? this.lastCalculated,
      currency: currency ?? this.currency,
      currencyCode: currencyCode ?? this.currencyCode,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
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
    taxBreakdown,
    discountBreakdown,
    lastCalculated,
    currency,
    currencyCode,
    metadata,
  ];

  @override
  String toString() => 'CartSummary(items: $totalItems, quantity: $totalQuantity, '
      'subtotal: $formattedSubtotal, total: $formattedTotal, savings: $formattedTotalSavings)';
}