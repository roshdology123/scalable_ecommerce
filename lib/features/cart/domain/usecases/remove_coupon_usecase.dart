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
    _logger.logBusinessLogic(
      'remove_coupon_usecase',
      'started',
      {
        'coupon_code': params.couponCode,
        'user_id': params.userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:21:20',
      },
    );

    final result = await _repository.removeCoupon(
      couponCode: params.couponCode,
      userId: params.userId,
    );

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'remove_coupon_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'coupon_code': params.couponCode,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logBusinessLogic(
        'remove_coupon_usecase',
        'success',
        {
          'coupon_code': params.couponCode,
          'new_total': cart.summary.total,
          'user': 'roshdology123',
        },
      ),
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