import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/notification_preferences.dart';
import '../repositories/notification_repository.dart';

@injectable
class UpdateNotificationSettingsUseCase implements UseCase<void, UpdateNotificationSettingsParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  UpdateNotificationSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UpdateNotificationSettingsParams params) async {
    _logger.logBusinessLogic(
      'update_notification_settings_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'push_enabled': params.preferences.pushNotificationsEnabled,
        'email_enabled': params.preferences.emailNotificationsEnabled,
        'sms_enabled': params.preferences.smsNotificationsEnabled,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    // Validate preferences before updating
    final validationResult = _validatePreferences(params.preferences);
    if (validationResult != null) {
      _logger.logBusinessLogic(
        'update_notification_settings_validation_failed',
        'usecase_execution',
        {
          'user_id': params.userId,
          'validation_error': validationResult,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        },
      );
      return Left(ValidationFailure(message: validationResult));
    }

    final result = await _repository.updateNotificationSettings(
      userId: params.userId,
      preferences: params.preferences,
    );

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'UpdateNotificationSettingsUseCase',
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
          (_) {
        _logger.logBusinessLogic(
          'update_notification_settings_usecase_success',
          'usecase_execution',
          {
            'user_id': params.userId,
            'enabled_types': params.preferences.enabledNotificationTypes.map((e) => e.name).toList(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return const Right(null);
      },
    );
  }

  String? _validatePreferences(NotificationPreferences preferences) {
    // Validate quiet hours format
    if (preferences.quietHoursEnabled) {
      if (!_isValidTimeFormat(preferences.quietHoursStart)) {
        return 'Invalid quiet hours start time format. Use HH:MM format.';
      }
      if (!_isValidTimeFormat(preferences.quietHoursEnd)) {
        return 'Invalid quiet hours end time format. Use HH:MM format.';
      }
    }

    // Validate at least one notification method is enabled
    if (!preferences.hasAnyNotificationsEnabled) {
      return 'At least one notification method must be enabled.';
    }

    // Validate subscribed topics
    if (preferences.subscribedTopics.any((topic) => topic.trim().isEmpty)) {
      return 'Subscribed topics cannot contain empty values.';
    }

    return null; // Valid
  }

  bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regex.hasMatch(time);
  }
}

class UpdateNotificationSettingsParams extends Equatable {
  final String userId;
  final NotificationPreferences preferences;

  const UpdateNotificationSettingsParams({
    required this.userId,
    required this.preferences,
  });

  @override
  List<Object> get props => [userId, preferences];
}