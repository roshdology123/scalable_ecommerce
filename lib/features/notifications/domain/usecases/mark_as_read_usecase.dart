import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/notification_repository.dart';

@injectable
class MarkAsReadUseCase implements UseCase<void, MarkAsReadParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  MarkAsReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) async {
    _logger.logUserAction('mark_as_read_usecase_started', {
      'notification_id': params.notificationId,
      'user_id': params.userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 08:39:37',
    });

    final result = await _repository.markAsRead(
      notificationId: params.notificationId,
      userId: params.userId,
    );

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'MarkAsReadUseCase',
          failure,
          StackTrace.current,
          {
            'notification_id': params.notificationId,
            'user_id': params.userId,
            'failure_type': failure.runtimeType.toString(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Left(failure);
      },
          (_) {
        _logger.logUserAction('mark_as_read_usecase_success', {
          'notification_id': params.notificationId,
          'user_id': params.userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        });
        return const Right(null);
      },
    );
  }
}

class MarkAsReadParams extends Equatable {
  final String notificationId;
  final String userId;

  const MarkAsReadParams({
    required this.notificationId,
    required this.userId,
  });

  @override
  List<Object> get props => [notificationId, userId];
}