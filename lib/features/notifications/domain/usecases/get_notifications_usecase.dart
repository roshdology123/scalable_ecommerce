import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetNotificationsUseCase implements UseCase<List<AppNotification>, GetNotificationsParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AppNotification>>> call(GetNotificationsParams params) async {
    _logger.logBusinessLogic(
      'get_notifications_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'limit': params.limit,
        'unread_only': params.unreadOnly,
        'type': params.type,
        'since': params.since?.toIso8601String(),
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    final result = await _repository.getNotifications(
      userId: params.userId,
      limit: params.limit,
      unreadOnly: params.unreadOnly,
      type: params.type,
      since: params.since,
    );

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'GetNotificationsUseCase',
          failure,
          StackTrace.current,
          {
            'user_id': params.userId,
            'failure_type': failure.runtimeType.toString(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Left(failure);
      },
          (notifications) {
        _logger.logBusinessLogic(
          'get_notifications_usecase_success',
          'usecase_execution',
          {
            'user_id': params.userId,
            'notifications_count': notifications.length,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Right(notifications);
      },
    );
  }
}

class GetNotificationsParams extends Equatable {
  final String userId;
  final int? limit;
  final bool? unreadOnly;
  final String? type;
  final DateTime? since;

  const GetNotificationsParams({
    required this.userId,
    this.limit,
    this.unreadOnly,
    this.type,
    this.since,
  });

  @override
  List<Object?> get props => [userId, limit, unreadOnly, type, since];
}