import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/notification_simulator.dart';

@injectable
class SendTestNotificationUseCase implements UseCase<void, SendTestNotificationParams> {
  final NotificationService _notificationService;
  final NotificationSimulator _notificationSimulator;
  final AppLogger _logger = AppLogger();

  SendTestNotificationUseCase(
      this._notificationService,
      this._notificationSimulator,
      );

  @override
  Future<Either<Failure, void>> call(SendTestNotificationParams params) async {
    _logger.logUserAction('send_test_notification_usecase_started', {
      'user_id': params.userId,
      'message': params.message,
      'type': params.type,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 08:39:37',
    });

    try {
      // Generate test notification through simulator
      _notificationSimulator.generateActionBasedNotification('test_notification', {
        'user_id': params.userId,
        'message': params.message ?? 'This is a test notification sent at 2025-06-23 08:39:37',
        'type': params.type ?? 'test',
        'sent_from': 'test_usecase',
        'requested_by': 'roshdology123',
      });

      // Also send through Firebase if in production mode
      if (!_notificationService.isSimulationEnabled) {
        await _notificationService.sendTestNotification();
      }

      _logger.logUserAction('send_test_notification_usecase_success', {
        'user_id': params.userId,
        'simulation_enabled': _notificationService.isSimulationEnabled,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      });

      return const Right(null);
    } catch (e) {
      _logger.logErrorWithContext(
        'SendTestNotificationUseCase',
        e,
        StackTrace.current,
        {
          'user_id': params.userId,
          'message': params.message,
          'type': params.type,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        },
      );
      return const Left(ServerFailure(message: 'Failed to send test notification'));
    }
  }
}

class SendTestNotificationParams extends Equatable {
  final String userId;
  final String? message;
  final String? type;

  const SendTestNotificationParams({
    required this.userId,
    this.message,
    this.type,
  });

  @override
  List<Object?> get props => [userId, message, type];
}