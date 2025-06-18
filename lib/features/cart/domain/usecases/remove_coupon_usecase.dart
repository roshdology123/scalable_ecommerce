import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class RemoveCouponUseCase implements UseCase<Cart, RemoveCouponParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  RemoveCouponUseCase(this._repository);

  @override
  Future<Either<Failure, Cart>> call(RemoveCouponParams params) async {
    final startTime = DateTime.now();

    _logger.logUserAction('remove_coupon_usecase_started', {
      'coupon_code': params.couponCode,
      'user_id': params.userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:01:31',
    });

    // Validate parameters
    if (params.userId == null) {
      return Left(AuthFailure.unauthorized());
    }

    if (params.couponCode.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Coupon code cannot be empty',
        code: 'INVALID_COUPON_CODE',
      ));
    }

    final result = await _repository.removeCoupon(
      couponCode: params.couponCode,
      userId: params.userId,
    );

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'remove_coupon_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'coupon_code': params.couponCode,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logUserAction('remove_coupon_usecase_success', {
        'coupon_code': params.couponCode,
        'cart_total': cart.summary.total,
        'duration_ms': duration.inMilliseconds,
        'user': 'roshdology123',
      }),
    );

    return result;
  }
}

class RemoveCouponParams extends Equatable {
  final String couponCode;
  final String? userId;

  const RemoveCouponParams({
    required this.couponCode,
    this.userId,
  });

  @override
  List<Object?> get props => [couponCode, userId];
}