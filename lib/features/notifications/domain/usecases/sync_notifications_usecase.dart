import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

@injectable
class SyncNotificationsUseCase implements UseCase<List<AppNotification>, SyncNotificationsParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  SyncNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AppNotification>>> call(SyncNotificationsParams params) async {
    _logger.logBusinessLogic(
      'sync_notifications_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'force_sync': params.forceSync,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    final result = await _repository.syncNotifications(userId: params.userId);

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'SyncNotificationsUseCase',
          failure,
          StackTrace.current,
          {
            'user_id': params.userId,
            'force_sync': params.forceSync,
            'failure_type': failure.runtimeType.toString(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Left(failure);
      },
          (notifications) {
        _logger.logBusinessLogic(
          'sync_notifications_usecase_success',
          'usecase_execution',
          {
            'user_id': params.userId,
            'synced_notifications_count': notifications.length,
            'force_sync': params.forceSync,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Right(notifications);
      },
    );
  }
}

class SyncNotificationsParams extends Equatable {
  final String userId;
  final bool forceSync;

  const SyncNotificationsParams({
    required this.userId,
    this.forceSync = false,
  });

  @override
  List<Object> get props => [userId, forceSync];
}