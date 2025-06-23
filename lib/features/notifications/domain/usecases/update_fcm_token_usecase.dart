import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/notification_repository.dart';

@injectable
class UpdateFCMTokenUseCase implements UseCase<void, UpdateFCMTokenParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  UpdateFCMTokenUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UpdateFCMTokenParams params) async {
    _logger.logBusinessLogic(
      'update_fcm_token_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'token_length': params.fcmToken.length,
        'device_id': params.deviceId,
        'platform': params.platform,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    // Validate FCM token
    if (!_isValidFCMToken(params.fcmToken)) {
      _logger.logBusinessLogic(
        'update_fcm_token_validation_failed',
        'usecase_execution',
        {
          'user_id': params.userId,
          'token_length': params.fcmToken.length,
          'error': 'Invalid FCM token format',
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        },
      );
      return const Left(ValidationFailure(message: 'Invalid FCM token format'));
    }

    final result = await _repository.updateFCMToken(
      userId: params.userId,
      fcmToken: params.fcmToken,
      deviceId: params.deviceId,
      platform: params.platform,
    );

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'UpdateFCMTokenUseCase',
          failure,
          StackTrace.current,
          {
            'user_id': params.userId,
            'device_id': params.deviceId,
            'platform': params.platform,
            'failure_type': failure.runtimeType.toString(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Left(failure);
      },
          (_) {
        _logger.logBusinessLogic(
          'update_fcm_token_usecase_success',
          'usecase_execution',
          {
            'user_id': params.userId,
            'device_id': params.deviceId,
            'platform': params.platform,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return const Right(null);
      },
    );
  }

  bool _isValidFCMToken(String token) {
    // Basic FCM token validation
    return token.isNotEmpty &&
        token.length > 50 &&
        token.length < 500 &&
        !token.contains(' ');
  }
}

class UpdateFCMTokenParams extends Equatable {
  final String userId;
  final String fcmToken;
  final String? deviceId;
  final String? platform;

  const UpdateFCMTokenParams({
    required this.userId,
    required this.fcmToken,
    this.deviceId,
    this.platform,
  });

  @override
  List<Object?> get props => [userId, fcmToken, deviceId, platform];
}