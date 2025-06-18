import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class SyncCartUseCase implements UseCase<Cart, SyncCartParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  SyncCartUseCase(this._repository);

  @override
  Future<Either<Failure, Cart>> call(SyncCartParams params) async {
    final startTime = DateTime.now();

    _logger.logBusinessLogic(
      'sync_cart_usecase',
      'started',
      {
        'user_id': params.userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:01:31',
      },
    );

    // Validate parameters
    if (params.userId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'User ID cannot be empty for cart sync',
        code: 'INVALID_USER_ID',
      ));
    }

    final result = await _repository.syncCart(params.userId);

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'sync_cart_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'user_id': params.userId,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logBusinessLogic(
        'sync_cart_usecase',
        'success',
        {
          'cart_id': cart.id,
          'items_count': cart.items.length,
          'cart_version': cart.version,
          'is_synced': cart.isSynced,
          'has_conflicts': cart.hasConflicts,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
    );

    return result;
  }
}

class SyncCartParams extends Equatable {
  final String userId;

  const SyncCartParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}