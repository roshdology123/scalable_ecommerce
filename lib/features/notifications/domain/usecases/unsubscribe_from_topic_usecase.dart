import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/services/notification_service.dart';

@injectable
class UnsubscribeFromTopicUseCase implements UseCase<void, UnsubscribeFromTopicParams> {
  final NotificationService _notificationService;
  final AppLogger _logger = AppLogger();

  UnsubscribeFromTopicUseCase(this._notificationService);

  @override
  Future<Either<Failure, void>> call(UnsubscribeFromTopicParams params) async {
    _logger.logBusinessLogic(
      'unsubscribe_from_topic_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'topic': params.topic,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    try {
      // Unsubscribe from Firebase topic
      await _notificationService.unsubscribeFromTopic(params.topic);

      _logger.logBusinessLogic(
        'unsubscribe_from_topic_usecase_success',
        'usecase_execution',
        {
          'user_id': params.userId,
          'topic': params.topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        },
      );

      return const Right(null);
    } catch (e) {
      _logger.logErrorWithContext(
        'UnsubscribeFromTopicUseCase',
        e,
        StackTrace.current,
        {
          'user_id': params.userId,
          'topic': params.topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        },
      );
      return const Left(ServerFailure(message: 'Failed to unsubscribe from topic'));
    }
  }
}

class UnsubscribeFromTopicParams extends Equatable {
  final String userId;
  final String topic;

  const UnsubscribeFromTopicParams({
    required this.userId,
    required this.topic,
  });

  @override
  List<Object> get props => [userId, topic];
}