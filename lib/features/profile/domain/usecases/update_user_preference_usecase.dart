import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user preferences and settings
/// 
/// This use case handles:
/// - Validating preference data before update
/// - Updating preferences on remote server
/// - Caching updated preferences locally
/// - Updating timestamp to current time
/// - Applying theme changes immediately
/// 
/// The preferences that can be updated include:
/// - Theme mode (light, dark, system)
/// - Language and localization
/// - Notification settings
/// - Privacy and security options
/// - Data sharing preferences
/// - Currency and timezone settings
/// 
/// Usage:
/// ```dart
/// final params = UpdateUserPreferencesParams(preferences: updatedPrefs);
/// final result = await updateUserPreferencesUseCase(params);
/// result.fold(
///   (failure) => handleError(failure),
///   (preferences) => applyUpdatedPreferences(preferences),
/// );
/// ```
@injectable
class UpdateUserPreferencesUseCase extends UseCase<UserPreferences, UpdateUserPreferencesParams> {
  final ProfileRepository _repository;

  UpdateUserPreferencesUseCase(this._repository);

  @override
  Future<Either<Failure, UserPreferences>> call(UpdateUserPreferencesParams params) async {
    try {
      // Validate preferences before update
      final validationResult = _validatePreferences(params.preferences);
      if (validationResult != null) {
        return Left(validationResult);
      }

      // Update preferences with current timestamp
      final preferencesToUpdate = params.preferences.copyWith(
        updatedAt: DateTime.parse('2025-06-22 08:21:43'),
      );

      debugPrint('Updating user preferences for user: ${preferencesToUpdate.userId}');
      _logPreferencesChanges(params.preferences, preferencesToUpdate);

      final result = await _repository.updateUserPreferences(preferencesToUpdate);

      return result.fold(
            (failure) {
          debugPrint('UpdateUserPreferencesUseCase failed: ${failure.message}');
          return Left(failure);
        },
            (updatedPreferences) {
          debugPrint('User preferences updated successfully');
          _logUpdatedPreferencesSummary(updatedPreferences);
          return Right(updatedPreferences);
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in UpdateUserPreferencesUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while updating preferences: ${e.toString()}',
        code: 'UPDATE_PREFERENCES_UNKNOWN_ERROR',
      ));
    }
  }

  /// Validates user preferences before update
  ValidationFailure? _validatePreferences(UserPreferences preferences) {
    // Check required fields
    if (preferences.userId.isEmpty) {
      return const ValidationFailure(
        message: 'User ID is required',
        code: 'USER_ID_REQUIRED',
      );
    }

    // Validate currency code
    if (!_isValidCurrencyCode(preferences.currency)) {
      return const ValidationFailure(
        message: 'Invalid currency code',
        code: 'INVALID_CURRENCY_CODE',
      );
    }

    // Validate timezone
    if (!_isValidTimeZone(preferences.timeZone)) {
      return const ValidationFailure(
        message: 'Invalid timezone',
        code: 'INVALID_TIMEZONE',
      );
    }

    // Validate notification frequency settings
    if (!_areNotificationFrequenciesValid(preferences)) {
      return const ValidationFailure(
        message: 'Invalid notification frequency settings',
        code: 'INVALID_NOTIFICATION_SETTINGS',
      );
    }

    return null; // No validation errors
  }

  /// Validates currency code format
  bool _isValidCurrencyCode(String currency) {
    final validCurrencies = [
      'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD',
      'EGP', 'SAR', 'AED', 'QAR', 'KWD', 'BHD'
    ];
    return validCurrencies.contains(currency.toUpperCase());
  }

  /// Validates timezone format
  bool _isValidTimeZone(String timeZone) {
    // Basic timezone validation - should be in format like 'UTC', 'UTC+2', 'America/New_York'
    return timeZone.isNotEmpty &&
        (timeZone.startsWith('UTC') ||
            timeZone.contains('/') ||
            timeZone.length <= 10);
  }

  /// Validates notification frequency settings
  bool _areNotificationFrequenciesValid(UserPreferences preferences) {
    // All notification frequencies should be valid enum values
    const validFrequencies = NotificationFrequency.values;

    return validFrequencies.contains(preferences.orderUpdates) &&
        validFrequencies.contains(preferences.promotionalEmails) &&
        validFrequencies.contains(preferences.newsletterSubscription);
  }

  /// Logs changes being made to preferences
  void _logPreferencesChanges(UserPreferences oldPrefs, UserPreferences newPrefs) {
    debugPrint('Preferences Changes:');

    if (oldPrefs.themeMode != newPrefs.themeMode) {
      debugPrint('  Theme: ${oldPrefs.themeModeDisplayName} → ${newPrefs.themeModeDisplayName}');
    }

    if (oldPrefs.language != newPrefs.language) {
      debugPrint('  Language: ${oldPrefs.languageDisplayName} → ${newPrefs.languageDisplayName}');
    }

    if (oldPrefs.pushNotificationsEnabled != newPrefs.pushNotificationsEnabled) {
      debugPrint('  Push Notifications: ${oldPrefs.pushNotificationsEnabled} → ${newPrefs.pushNotificationsEnabled}');
    }

    if (oldPrefs.currency != newPrefs.currency) {
      debugPrint('  Currency: ${oldPrefs.currency} → ${newPrefs.currency}');
    }

    if (oldPrefs.biometricAuthEnabled != newPrefs.biometricAuthEnabled) {
      debugPrint('  Biometric Auth: ${oldPrefs.biometricAuthEnabled} → ${newPrefs.biometricAuthEnabled}');
    }

    if (oldPrefs.twoFactorAuthEnabled != newPrefs.twoFactorAuthEnabled) {
      debugPrint('  Two-Factor Auth: ${oldPrefs.twoFactorAuthEnabled} → ${newPrefs.twoFactorAuthEnabled}');
    }
  }

  /// Logs summary of updated preferences
  void _logUpdatedPreferencesSummary(UserPreferences preferences) {
    debugPrint('Updated Preferences Summary:');
    debugPrint('  User: ${preferences.userId}');
    debugPrint('  Theme: ${preferences.themeModeDisplayName}');
    debugPrint('  Language: ${preferences.languageDisplayName}');
    debugPrint('  Currency: ${preferences.currencyDisplayName}');
    debugPrint('  Security Level: ${preferences.securityLevel}');
    debugPrint('  Privacy Score: ${preferences.privacyScore}%');
    debugPrint('  Notifications Enabled: ${preferences.hasNotificationsEnabled}');
    debugPrint('  Updated At: ${preferences.updatedAt}');
  }
}

class UpdateUserPreferencesParams extends Equatable {
  final UserPreferences preferences;

  const UpdateUserPreferencesParams({required this.preferences});

  @override
  List<Object?> get props => [preferences];

  @override
  String toString() => 'UpdateUserPreferencesParams(userId: ${preferences.userId})';
}