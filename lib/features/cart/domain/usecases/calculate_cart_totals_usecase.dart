import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart_summary.dart';
import '../repositories/cart_repository.dart';

@injectable
class CalculateCartTotalsUseCase implements UseCase<CartSummary, CalculateCartTotalsParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  CalculateCartTotalsUseCase(this._repository);

  @override
  Future<Either<Failure, CartSummary>> call(CalculateCartTotalsParams params) async {
    final startTime = DateTime.now();

    _logger.logBusinessLogic(
      'calculate_cart_totals_usecase',
      'started',
      {
        'shipping_method_id': params.shippingMethodId,
        'coupon_code': params.couponCode,
        'tax_exemption_id': params.taxExemptionId,
        'shipping_address_country': params.shippingAddressCountry,
        'billing_address_country': params.billingAddressCountry,
        'user_id': params.userId ?? 'guest',
        'force_recalculate': params.forceRecalculate,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:11:09',
      },
    );

    // Validate business rules before calculation
    final validation = _validateCalculationParams(params);
    if (validation != null) {
      _logger.logBusinessLogic(
        'calculate_cart_totals_usecase',
        'validation_failed',
        {
          'error': validation.message,
          'code': validation.code,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:11:09',
        },
      );
      return Left(validation);
    }

    final result = await _repository.calculateCartTotals(
      shippingMethodId: params.shippingMethodId,
      couponCode: params.couponCode,
      userId: params.userId,
    );

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'calculate_cart_totals_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'shipping_method_id': params.shippingMethodId,
          'coupon_code': params.couponCode,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:11:09',
        },
      ),
          (summary) => _logger.logBusinessLogic(
        'calculate_cart_totals_usecase',
        'success',
        {
          'subtotal': summary.subtotal,
          'total_tax': summary.totalTax,
          'shipping_cost': summary.shippingCost,
          'total_discount': summary.totalDiscount,
          'coupon_discount': summary.couponDiscount,
          'final_total': summary.total,
          'items_count': summary.totalItems,
          'total_quantity': summary.totalQuantity,
          'is_free_shipping': summary.isFreeShipping,
          'has_coupon': summary.hasCouponApplied,
          'tax_rate': summary.taxRate,
          'currency_code': summary.currencyCode,
          'amount_to_free_shipping': summary.amountToFreeShipping,
          'cart_health_score': summary.cartHealthScore,
          'promotional_messages_count': summary.promotionalMessages.length,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:11:09',
        },
      ),
    );

    return result;
  }

  Failure? _validateCalculationParams(CalculateCartTotalsParams params) {
    // Validate shipping method format
    if (params.shippingMethodId != null) {
      final validShippingMethods = ['standard', 'express', 'overnight', 'pickup'];
      if (!validShippingMethods.contains(params.shippingMethodId)) {
        return const ValidationFailure(
          message: 'Invalid shipping method selected',
          code: 'INVALID_SHIPPING_METHOD',
        );
      }
    }

    // Validate coupon code format
    if (params.couponCode != null) {
      final couponCode = params.couponCode!.trim();
      if (couponCode.isEmpty) {
        return const ValidationFailure(
          message: 'Coupon code cannot be empty',
          code: 'EMPTY_COUPON_CODE',
        );
      }

      if (couponCode.length < 3 || couponCode.length > 50) {
        return const ValidationFailure(
          message: 'Coupon code must be between 3 and 50 characters',
          code: 'INVALID_COUPON_LENGTH',
        );
      }

      // Basic alphanumeric validation
      final validCouponRegex = RegExp(r'^[A-Z0-9\-_]+$');
      if (!validCouponRegex.hasMatch(couponCode.toUpperCase())) {
        return const ValidationFailure(
          message: 'Coupon code contains invalid characters',
          code: 'INVALID_COUPON_FORMAT',
        );
      }
    }

    // Validate country codes (ISO 3166-1 alpha-2)
    if (params.shippingAddressCountry != null) {
      if (params.shippingAddressCountry!.length != 2) {
        return const ValidationFailure(
          message: 'Invalid shipping address country code',
          code: 'INVALID_SHIPPING_COUNTRY',
        );
      }
    }

    if (params.billingAddressCountry != null) {
      if (params.billingAddressCountry!.length != 2) {
        return const ValidationFailure(
          message: 'Invalid billing address country code',
          code: 'INVALID_BILLING_COUNTRY',
        );
      }
    }

    // Validate tax exemption ID format
    if (params.taxExemptionId != null) {
      final taxId = params.taxExemptionId!.trim();
      if (taxId.isEmpty) {
        return const ValidationFailure(
          message: 'Tax exemption ID cannot be empty',
          code: 'EMPTY_TAX_EXEMPTION_ID',
        );
      }

      if (taxId.length < 5 || taxId.length > 20) {
        return const ValidationFailure(
          message: 'Tax exemption ID must be between 5 and 20 characters',
          code: 'INVALID_TAX_EXEMPTION_LENGTH',
        );
      }
    }

    return null;
  }
}

class CalculateCartTotalsParams extends Equatable {
  final String? shippingMethodId;
  final String? couponCode;
  final String? userId;
  final String? shippingAddressCountry;
  final String? billingAddressCountry;
  final String? taxExemptionId;
  final bool forceRecalculate;
  final bool includeTax;
  final bool includeShipping;
  final double? customTaxRate;
  final Map<String, dynamic>? additionalFees;

  const CalculateCartTotalsParams({
    this.shippingMethodId,
    this.couponCode,
    this.userId,
    this.shippingAddressCountry,
    this.billingAddressCountry,
    this.taxExemptionId,
    this.forceRecalculate = false,
    this.includeTax = true,
    this.includeShipping = true,
    this.customTaxRate,
    this.additionalFees,
  });

  factory CalculateCartTotalsParams.basic({
    String? userId,
  }) {
    return CalculateCartTotalsParams(
      userId: userId,
      forceRecalculate: false,
      includeTax: true,
      includeShipping: true,
    );
  }

  factory CalculateCartTotalsParams.withShipping({
    required String shippingMethodId,
    String? userId,
    String? shippingCountry,
  }) {
    return CalculateCartTotalsParams(
      shippingMethodId: shippingMethodId,
      userId: userId,
      shippingAddressCountry: shippingCountry,
      forceRecalculate: true,
      includeTax: true,
      includeShipping: true,
    );
  }

  factory CalculateCartTotalsParams.withCoupon({
    required String couponCode,
    String? userId,
    String? shippingMethodId,
  }) {
    return CalculateCartTotalsParams(
      couponCode: couponCode,
      userId: userId,
      shippingMethodId: shippingMethodId,
      forceRecalculate: true,
      includeTax: true,
      includeShipping: true,
    );
  }

  factory CalculateCartTotalsParams.withTaxExemption({
    required String taxExemptionId,
    String? userId,
    String? shippingMethodId,
    String? couponCode,
  }) {
    return CalculateCartTotalsParams(
      taxExemptionId: taxExemptionId,
      userId: userId,
      shippingMethodId: shippingMethodId,
      couponCode: couponCode,
      forceRecalculate: true,
      includeTax: false,
      includeShipping: true,
    );
  }

  factory CalculateCartTotalsParams.checkout({
    required String shippingMethodId,
    required String shippingCountry,
    required String billingCountry,
    String? couponCode,
    String? taxExemptionId,
    String? userId,
  }) {
    return CalculateCartTotalsParams(
      shippingMethodId: shippingMethodId,
      shippingAddressCountry: shippingCountry,
      billingAddressCountry: billingCountry,
      couponCode: couponCode,
      taxExemptionId: taxExemptionId,
      userId: userId,
      forceRecalculate: true,
      includeTax: true,
      includeShipping: true,
    );
  }

  @override
  List<Object?> get props => [
    shippingMethodId,
    couponCode,
    userId,
    shippingAddressCountry,
    billingAddressCountry,
    taxExemptionId,
    forceRecalculate,
    includeTax,
    includeShipping,
    customTaxRate,
    additionalFees,
  ];

  @override
  String toString() => 'CalculateCartTotalsParams('
      'shippingMethodId: $shippingMethodId, '
      'couponCode: $couponCode, '
      'userId: $userId, '
      'shippingCountry: $shippingAddressCountry, '
      'billingCountry: $billingAddressCountry, '
      'taxExemptionId: $taxExemptionId, '
      'forceRecalculate: $forceRecalculate, '
      'includeTax: $includeTax, '
      'includeShipping: $includeShipping'
      ')';
}