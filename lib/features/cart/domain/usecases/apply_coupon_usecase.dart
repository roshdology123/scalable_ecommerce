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
    _logger.logBusinessLogic(
      'apply_coupon_usecase',
      'started',
      {
        'coupon_code': params.couponCode,
        'user_id': params.userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:21:20',
      },
    );

    final result = await _repository.applyCoupon(
      couponCode: params.couponCode,
      userId: params.userId,
    );

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'apply_coupon_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'coupon_code': params.couponCode,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logBusinessLogic(
        'apply_coupon_usecase',
        'success',
        {
          'coupon_code': params.couponCode,
          'discount_amount': cart.summary.couponDiscount,
          'new_total': cart.summary.total,
          'user': 'roshdology123',
        },
      ),
    );

    return result;
  }
}

class ApplyCouponParams extends Equatable {
  final String couponCode;
  final String? userId;
  final String? cartId; // Keep this for compatibility

  const ApplyCouponParams({
    required this.couponCode,
    this.userId,
    this.cartId,
  });

  @override
  List<Object?> get props => [couponCode, userId, cartId];
}