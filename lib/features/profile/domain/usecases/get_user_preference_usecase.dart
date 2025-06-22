import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/profile_repository.dart';

/// Use case for retrieving user preferences and settings
/// 
/// This use case handles:
/// - Fetching preferences from remote server when online
/// - Falling back to cached preferences when offline
/// - Returning default preferences if none exist
/// - Handling various error scenarios
/// 
/// The preferences include:
/// - Theme and appearance settings
/// - Notification preferences
/// - Privacy and security settings
/// - Language and localization
/// - Data sharing preferences
/// 
/// Usage:
/// ```dart
/// final result = await getUserPreferencesUseCase(NoParams());
/// result.fold(
///   (failure) => handleError(failure),
///   (preferences) => applyUserPreferences(preferences),
/// );
/// ```
@injectable
class GetUserPreferencesUseCase extends UseCase<UserPreferences, NoParams> {
  final ProfileRepository _repository;

  GetUserPreferencesUseCase(this._repository);

  @override
  Future<Either<Failure, UserPreferences>> call(NoParams params) async {
    try {
      debugPrint('Fetching user preferences for roshdology123');

      final result = await _repository.getUserPreferences();

      return result.fold(
            (failure) {
          debugPrint('GetUserPreferencesUseCase failed: ${failure.message}');

          // If it's a cache failure, return default preferences
          if (failure is CacheFailure) {
            debugPrint('No cached preferences found, returning defaults');
            final defaultPreferences = UserPreferences.defaultsForUser('11'); // roshdology123's ID
            return Right(defaultPreferences);
          }

          return Left(failure);
        },
            (preferences) {
          debugPrint('User preferences retrieved successfully');

          // Validate preferences data
          if (preferences.userId.isEmpty) {
            debugPrint('Invalid preferences data: empty user ID');
            return const Left(ValidationFailure(
              message: 'Invalid preferences data received',
              code: 'INVALID_PREFERENCES_DATA',
            ));
          }

          // Log preferences summary for debugging
          _logPreferencesSummary(preferences);

          return Right(preferences);
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in GetUserPreferencesUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while getting preferences: ${e.toString()}',
        code: 'GET_PREFERENCES_UNKNOWN_ERROR',
      ));
    }
  }

  /// Logs a summary of user preferences for debugging
  void _logPreferencesSummary(UserPreferences preferences) {
    debugPrint('Preferences Summary:');
    debugPrint('  Theme: ${preferences.themeModeDisplayName}');
    debugPrint('  Language: ${preferences.languageDisplayName}');
    debugPrint('  Push Notifications: ${preferences.pushNotificationsEnabled}');
    debugPrint('  Email Notifications: ${preferences.emailNotificationsEnabled}');
    debugPrint('  Security Level: ${preferences.securityLevel}');
    debugPrint('  Privacy Score: ${preferences.privacyScore}%');
    debugPrint('  Last Updated: ${preferences.updatedAt}');
  }
}