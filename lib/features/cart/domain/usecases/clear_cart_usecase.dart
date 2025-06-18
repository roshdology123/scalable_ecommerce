import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/cart_repository.dart';

@injectable
class ClearCartUseCase implements UseCase<void, ClearCartParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  ClearCartUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ClearCartParams params) async {
    final startTime = DateTime.now();

    _logger.logUserAction('clear_cart_usecase_started', {
      'user_id': params.userId ?? 'guest',
      'reason': params.reason,
      'save_for_later': params.saveForLater,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:11:09',
    });

    // Log the action for analytics/audit
    _logger.logBusinessLogic(
      'cart_clearing_initiated',
      'user_action',
      {
        'user_id': params.userId ?? 'guest',
        'clear_reason': params.reason ?? 'user_initiated',
        'save_abandoned': params.saveForLater,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:11:09',
      },
    );

    final result = await _repository.clearCart(params.userId);

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'clear_cart_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'user_id': params.userId ?? 'guest',
          'reason': params.reason,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:11:09',
        },
      ),
          (_) => _logger.logUserAction('clear_cart_usecase_success', {
        'user_id': params.userId ?? 'guest',
        'reason': params.reason,
        'duration_ms': duration.inMilliseconds,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:11:09',
      }),
    );

    return result;
  }
}

class ClearCartParams extends Equatable {
  final String? userId;
  final String? reason;
  final bool saveForLater;
  final bool notifyUser;

  const ClearCartParams({
    this.userId,
    this.reason,
    this.saveForLater = false,
    this.notifyUser = true,
  });

  factory ClearCartParams.userInitiated({String? userId}) {
    return ClearCartParams(
      userId: userId,
      reason: 'user_initiated',
      saveForLater: false,
      notifyUser: true,
    );
  }

  factory ClearCartParams.checkout({String? userId}) {
    return ClearCartParams(
      userId: userId,
      reason: 'checkout_completed',
      saveForLater: false,
      notifyUser: false,
    );
  }

  factory ClearCartParams.expired({String? userId}) {
    return ClearCartParams(
      userId: userId,
      reason: 'cart_expired',
      saveForLater: true,
      notifyUser: false,
    );
  }

  factory ClearCartParams.logout({String? userId}) {
    return ClearCartParams(
      userId: userId,
      reason: 'user_logout',
      saveForLater: true,
      notifyUser: false,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    reason,
    saveForLater,
    notifyUser,
  ];

  @override
  String toString() => 'ClearCartParams('
      'userId: $userId, '
      'reason: $reason, '
      'saveForLater: $saveForLater, '
      'notifyUser: $notifyUser'
      ')';
}