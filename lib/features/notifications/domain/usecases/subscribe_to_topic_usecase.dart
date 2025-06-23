import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/services/notification_service.dart';

@injectable
class SubscribeToTopicUseCase implements UseCase<void, SubscribeToTopicParams> {
  final NotificationService _notificationService;
  final AppLogger _logger = AppLogger();

  SubscribeToTopicUseCase(this._notificationService);

  @override
  Future<Either<Failure, void>> call(SubscribeToTopicParams params) async {
    _logger.logBusinessLogic(
      'subscribe_to_topic_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'topic': params.topic,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    try {
      // Validate topic name
      if (!_isValidTopicName(params.topic)) {
        _logger.logBusinessLogic(
          'subscribe_to_topic_validation_failed',
          'usecase_execution',
          {
            'user_id': params.userId,
            'topic': params.topic,
            'error': 'Invalid topic name format',
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return const Left(ValidationFailure(message: 'Invalid topic name format'));
      }

      // Subscribe to Firebase topic
      await _notificationService.subscribeToTopic(params.topic);

      _logger.logBusinessLogic(
        'subscribe_to_topic_usecase_success',
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
        'SubscribeToTopicUseCase',
        e,
        StackTrace.current,
        {
          'user_id': params.userId,
          'topic': params.topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        },
      );
      return const Left(ServerFailure(message: 'Failed to subscribe to topic'));
    }
  }

  bool _isValidTopicName(String topic) {
    // Firebase topic names must match [a-zA-Z0-9-_.~%]+
    final regex = RegExp(r'^[a-zA-Z0-9\-_.~%]+$');
    return regex.hasMatch(topic) && topic.isNotEmpty && topic.length <= 900;
  }
}

class SubscribeToTopicParams extends Equatable {
  final String userId;
  final String topic;

  const SubscribeToTopicParams({
    required this.userId,
    required this.topic,
  });

  @override
  List<Object> get props => [userId, topic];
}