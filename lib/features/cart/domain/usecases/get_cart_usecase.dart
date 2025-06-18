import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class GetCartUseCase implements UseCase<Cart, GetCartParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  GetCartUseCase(this._repository);

  @override
  Future<Either<Failure, Cart>> call(GetCartParams params) async {
    final startTime = DateTime.now();

    _logger.logBusinessLogic(
      'get_cart_usecase',
      'started',
      {
        'user_id': params.userId ?? 'guest',
        'force_refresh': params.forceRefresh,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:11:09',
      },
    );

    final result = await _repository.getCart(params.userId);

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'get_cart_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'user_id': params.userId ?? 'guest',
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:11:09',
        },
      ),
          (cart) => _logger.logBusinessLogic(
        'get_cart_usecase',
        'success',
        {
          'cart_id': cart.id,
          'items_count': cart.items.length,
          'total_quantity': cart.summary.totalQuantity,
          'cart_total': cart.summary.total,
          'is_guest': cart.isGuestCart,
          'is_empty': cart.isEmpty,
          'needs_sync': cart.needsSync,
          'has_conflicts': cart.hasConflicts,
          'cart_status': cart.status,
          'last_updated': cart.updatedAt.toIso8601String(),
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:11:09',
        },
      ),
    );

    return result;
  }
}

class GetCartParams extends Equatable {
  final String? userId;
  final bool forceRefresh;
  final bool includeUnavailableItems;
  final bool validatePrices;

  const GetCartParams({
    this.userId,
    this.forceRefresh = false,
    this.includeUnavailableItems = true,
    this.validatePrices = false,
  });

  @override
  List<Object?> get props => [
    userId,
    forceRefresh,
    includeUnavailableItems,
    validatePrices,
  ];

  @override
  String toString() => 'GetCartParams('
      'userId: $userId, '
      'forceRefresh: $forceRefresh, '
      'includeUnavailableItems: $includeUnavailableItems, '
      'validatePrices: $validatePrices'
      ')';
}