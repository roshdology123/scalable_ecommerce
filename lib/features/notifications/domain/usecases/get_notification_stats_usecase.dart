import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/notification_stats.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetNotificationStatsUseCase implements UseCase<NotificationStats, GetNotificationStatsParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  GetNotificationStatsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationStats>> call(GetNotificationStatsParams params) async {
    _logger.logBusinessLogic(
      'get_notification_stats_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'from_date': params.fromDate?.toIso8601String(),
        'to_date': params.toDate?.toIso8601String(),
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    // Validate date range
    if (params.fromDate != null && params.toDate != null) {
      if (params.fromDate!.isAfter(params.toDate!)) {
        _logger.logBusinessLogic(
          'get_notification_stats_validation_failed',
          'usecase_execution',
          {
            'user_id': params.userId,
            'error': 'From date cannot be after to date',
            'from_date': params.fromDate!.toIso8601String(),
            'to_date': params.toDate!.toIso8601String(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return const Left(ValidationFailure(message: 'From date cannot be after to date'));
      }
    }

    final result = await _repository.getNotificationStats(
      userId: params.userId,
      fromDate: params.fromDate,
      toDate: params.toDate,
    );

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'GetNotificationStatsUseCase',
          failure,
          StackTrace.current,
          {
            'user_id': params.userId,
            'from_date': params.fromDate?.toIso8601String(),
            'to_date': params.toDate?.toIso8601String(),
            'failure_type': failure.runtimeType.toString(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Left(failure);
      },
          (stats) {
        _logger.logBusinessLogic(
          'get_notification_stats_usecase_success',
          'usecase_execution',
          {
            'user_id': params.userId,
            'total_notifications': stats.totalNotifications,
            'engagement_rate': stats.engagementRate,
            'most_common_type': stats.mostCommonType,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Right(stats);
      },
    );
  }
}

class GetNotificationStatsParams extends Equatable {
  final String userId;
  final DateTime? fromDate;
  final DateTime? toDate;

  const GetNotificationStatsParams({
    required this.userId,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [userId, fromDate, toDate];
}