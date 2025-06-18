import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class ApplyCouponUseCase implements UseCase<Cart, ApplyCouponParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  ApplyCouponUseCase(this._repository);

  @override
  Future<Either<Failure, Cart>> call(ApplyCouponParams params) async {
    final startTime = DateTime.now();

    _logger.logUserAction('apply_coupon_usecase_started', {
      'coupon_code': params.couponCode,
      'user_id': params.userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:01:31',
    });

    // Validate parameters
    final validation = _validateCouponParams(params);
    if (validation != null) {
      _logger.logBusinessLogic(
        'apply_coupon_usecase',
        'validation_failed',
        {'error': validation.message, 'code': validation.code},
      );
      return Left(validation);
    }

    final result = await _repository.applyCoupon(
      couponCode: params.couponCode,
      userId: params.userId,
    );

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'apply_coupon_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'coupon_code': params.couponCode,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logUserAction('apply_coupon_usecase_success', {
        'coupon_code': params.couponCode,
        'discount_amount': cart.summary.couponDiscount,
        'cart_total': cart.summary.total,
        'savings': cart.summary.totalSavings,
        'duration_ms': duration.inMilliseconds,
        'user': 'roshdology123',
      }),
    );

    return result;
  }

  Failure? _validateCouponParams(ApplyCouponParams params) {
    if (params.userId == null) {
      return AuthFailure.unauthorized();
    }

    if (params.couponCode.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Coupon code cannot be empty',
        code: 'INVALID_COUPON_CODE',
      );
    }

    if (params.couponCode.length < 3) {
      return const ValidationFailure(
        message: 'Coupon code must be at least 3 characters',
        code: 'COUPON_CODE_TOO_SHORT',
      );
    }

    if (params.couponCode.length > 50) {
      return const ValidationFailure(
        message: 'Coupon code cannot exceed 50 characters',
        code: 'COUPON_CODE_TOO_LONG',
      );
    }

    // Basic format validation (alphanumeric with some special chars)
    final validCouponRegex = RegExp(r'^[A-Z0-9\-_]+$');
    if (!validCouponRegex.hasMatch(params.couponCode.toUpperCase())) {
      return ValidationFailure.invalidFormat('coupon code');
    }

    return null;
  }
}

class ApplyCouponParams extends Equatable {
  final String couponCode;
  final String? userId;

  const ApplyCouponParams({
    required this.couponCode,
    this.userId,
  });

  @override
  List<Object?> get props => [couponCode, userId];
}