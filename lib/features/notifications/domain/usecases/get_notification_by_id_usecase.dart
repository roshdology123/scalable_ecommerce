import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetNotificationByIdUseCase implements UseCase<AppNotification, GetNotificationByIdParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  GetNotificationByIdUseCase(this._repository);

  @override
  Future<Either<Failure, AppNotification>> call(GetNotificationByIdParams params) async {
    _logger.logBusinessLogic(
      'get_notification_by_id_usecase_started',
      'usecase_execution',
      {
        'notification_id': params.notificationId,
        'user_id': params.userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    final result = await _repository.getNotificationById(
      notificationId: params.notificationId,
      userId: params.userId,
    );

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'GetNotificationByIdUseCase',
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
          (notification) {
        _logger.logBusinessLogic(
          'get_notification_by_id_usecase_success',
          'usecase_execution',
          {
            'notification_id': params.notificationId,
            'notification_type': notification.type.name,
            'is_read': notification.isRead,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Right(notification);
      },
    );
  }
}

class GetNotificationByIdParams extends Equatable {
  final String notificationId;
  final String userId;

  const GetNotificationByIdParams({
    required this.notificationId,
    required this.userId,
  });

  @override
  List<Object> get props => [notificationId, userId];
}