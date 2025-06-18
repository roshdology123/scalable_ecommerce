import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class RemoveFromCartUseCase implements UseCase<Cart, RemoveFromCartParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  RemoveFromCartUseCase(this._repository);

  @override
  Future<Either<Failure, Cart>> call(RemoveFromCartParams params) async {
    final startTime = DateTime.now();

    _logger.logUserAction('remove_from_cart_usecase_started', {
      'item_id': params.itemId,
      'user_id': params.userId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:01:31',
    });

    // Validate parameters
    if (params.itemId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Item ID cannot be empty',
        code: 'INVALID_ITEM_ID',
      ));
    }

    final result = await _repository.removeFromCart(
      itemId: params.itemId,
      userId: params.userId,
    );

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'remove_from_cart_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'item_id': params.itemId,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logUserAction('remove_from_cart_usecase_success', {
        'item_id': params.itemId,
        'remaining_items': cart.items.length,
        'cart_total': cart.summary.total,
        'duration_ms': duration.inMilliseconds,
        'user': 'roshdology123',
      }),
    );

    return result;
  }
}

class RemoveFromCartParams extends Equatable {
  final String itemId;
  final String? userId;

  const RemoveFromCartParams({
    required this.itemId,
    this.userId,
  });

  @override
  List<Object?> get props => [itemId, userId];
}