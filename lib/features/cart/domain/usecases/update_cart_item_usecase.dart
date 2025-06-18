import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class UpdateCartItemUseCase implements UseCase<Cart, UpdateCartItemParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  UpdateCartItemUseCase(this._repository);

  @override
  Future<Either<Failure, Cart>> call(UpdateCartItemParams params) async {
    final startTime = DateTime.now();

    _logger.logUserAction('update_cart_item_usecase_started', {
      'item_id': params.itemId,
      'new_quantity': params.quantity,
      'user_id': params.userId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:01:31',
    });

    // Validate parameters
    final validation = _validateUpdateParams(params);
    if (validation != null) {
      _logger.logBusinessLogic(
        'update_cart_item_usecase',
        'validation_failed',
        {'error': validation.message, 'code': validation.code},
      );
      return Left(validation);
    }

    final result = await _repository.updateCartItem(
      itemId: params.itemId,
      quantity: params.quantity,
      selectedColor: params.selectedColor,
      selectedSize: params.selectedSize,
      userId: params.userId,
    );

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'update_cart_item_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'item_id': params.itemId,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logUserAction('update_cart_item_usecase_success', {
        'item_id': params.itemId,
        'new_quantity': params.quantity,
        'cart_items': cart.items.length,
        'cart_total': cart.summary.total,
        'duration_ms': duration.inMilliseconds,
        'user': 'roshdology123',
      }),
    );

    return result;
  }

  Failure? _validateUpdateParams(UpdateCartItemParams params) {
    if (params.itemId.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Item ID cannot be empty',
        code: 'INVALID_ITEM_ID',
      );
    }

    if (params.quantity != null) {
      if (params.quantity! <= 0) {
        return BusinessFailure.invalidQuantity();
      }

      if (params.quantity! > 999) {
        return const BusinessFailure(
          message: 'Quantity cannot exceed 999 items',
          code: 'QUANTITY_TOO_HIGH',
        );
      }
    }

    return null;
  }
}

class UpdateCartItemParams extends Equatable {
  final String itemId;
  final int? quantity;
  final String? selectedColor;
  final String? selectedSize;
  final String? userId;

  const UpdateCartItemParams({
    required this.itemId,
    this.quantity,
    this.selectedColor,
    this.selectedSize,
    this.userId,
  });

  @override
  List<Object?> get props => [
    itemId,
    quantity,
    selectedColor,
    selectedSize,
    userId,
  ];
}