import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/user_preferences.dart';
import '../../../domain/usecases/get_user_preference_usecase.dart';
import '../../../domain/usecases/update_user_preference_usecase.dart';
import 'profile_preferences_state.dart';

/// Profile Preferences Cubit manages user preferences and settings
///
/// Handles:
/// - Loading and updating user preferences
/// - Theme mode changes (light, dark, system)
/// - Language and localization settings
/// - Notification preferences
/// - Privacy and security settings
/// - Data sharing preferences
/// - Currency and timezone settings
@injectable
class ProfilePreferencesCubit extends Cubit<ProfilePreferencesState> {
  final GetUserPreferencesUseCase _getUserPreferencesUseCase;
  final UpdateUserPreferencesUseCase _updateUserPreferencesUseCase;

  UserPreferences? _currentPreferences;

  ProfilePreferencesCubit({
    required GetUserPreferencesUseCase getUserPreferencesUseCase,
    required UpdateUserPreferencesUseCase updateUserPreferencesUseCase,
  })  : _getUserPreferencesUseCase = getUserPreferencesUseCase,
        _updateUserPreferencesUseCase = updateUserPreferencesUseCase,
        super(const ProfilePreferencesInitial()) {
    debugPrint('ProfilePreferencesCubit initialized for roshdology123 at 2025-06-22 08:33:00');
  }

  /// Get current preferences
  UserPreferences? get currentPreferences => _currentPreferences;

  /// Load user preferences
  Future<void> loadPreferences() async {
    if (state is ProfilePreferencesLoading) return;

    emit(const ProfilePreferencesLoading());
    debugPrint('Loading preferences for roshdology123...');

    final result = await _getUserPreferencesUseCase(NoParams());

    result.fold(
          (failure) {
        debugPrint('Failed to load preferences: ${failure.message}');

        if (failure.code.toString() == 'NO_INTERNET_CONNECTION') {
          emit(ProfilePreferencesNetworkError(
            message: 'No internet connection. Using cached preferences.',
            cachedPreferences: _currentPreferences,
          ));
        } else {
          emit(ProfilePreferencesError(
            message: failure.message,
            code: failure.code.toString(),
            currentPreferences: _currentPreferences,
          ));
        }
      },
          (preferences) {
        debugPrint('Preferences loaded successfully');
        _currentPreferences = preferences;
        emit(ProfilePreferencesLoaded(preferences: preferences));
      },
    );
  }

  /// Update theme mode
  Future<void> updateTheme(ThemeMode newTheme) async {
    if (_currentPreferences == null) {
      emit(const ProfilePreferencesError(
        message: 'No preferences loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PREFERENCES',
      ));
      return;
    }

    final previousTheme = _currentPreferences!.themeMode;
    if (previousTheme == newTheme) return; // No change needed

    emit(ProfileThemeChanging(
      currentPreferences: _currentPreferences!,
      newTheme: newTheme,
    ));

    debugPrint('Changing theme from ${previousTheme.name} to ${newTheme.name}...');

    final updatedPreferences = _currentPreferences!.copyWith(
      themeMode: newTheme,
      updatedAt: DateTime.parse('2025-06-22 08:33:00'),
    );

    await _updatePreferences(
      updatedPreferences,
      'theme',
          () => ProfileThemeChanged(
        preferences: updatedPreferences,
        previousTheme: previousTheme,
        newTheme: newTheme,
      ),
    );
  }

  /// Update language
  Future<void> updateLanguage(Language newLanguage) async {
    if (_currentPreferences == null) {
      emit(const ProfilePreferencesError(
        message: 'No preferences loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PREFERENCES',
      ));
      return;
    }

    final previousLanguage = _currentPreferences!.language;
    if (previousLanguage == newLanguage) return; // No change needed

    emit(ProfileLanguageChanging(
      currentPreferences: _currentPreferences!,
      newLanguage: newLanguage,
    ));

    debugPrint('Changing language from ${previousLanguage.name} to ${newLanguage.name}...');

    final updatedPreferences = _currentPreferences!.copyWith(
      language: newLanguage,
      updatedAt: DateTime.parse('2025-06-22 08:33:00'),
    );

    await _updatePreferences(
      updatedPreferences,
      'language',
          () => ProfileLanguageChanged(
        preferences: updatedPreferences,
        previousLanguage: previousLanguage,
        newLanguage: newLanguage,
      ),
    );
  }

  /// Update notification settings
  Future<void> updateNotificationSettings({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    NotificationFrequency? orderUpdates,
    NotificationFrequency? promotionalEmails,
    NotificationFrequency? newsletterSubscription,
  }) async {
    if (_currentPreferences == null) {
      emit(const ProfilePreferencesError(
        message: 'No preferences loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PREFERENCES',
      ));
      return;
    }

    emit(ProfileNotificationSettingsUpdating(currentPreferences: _currentPreferences!));
    debugPrint('Updating notification settings...');

    // Track changes for logging
    final changes = <String, bool>{};

    final updatedPreferences = _currentPreferences!.copyWith(
      pushNotificationsEnabled: pushNotifications,
      emailNotificationsEnabled: emailNotifications,
      smsNotificationsEnabled: smsNotifications,
      orderUpdates: orderUpdates,
      promotionalEmails: promotionalEmails,
      newsletterSubscription: newsletterSubscription,
      updatedAt: DateTime.parse('2025-06-22 08:33:00'),
    );

    // Log changes
    if (pushNotifications != null && pushNotifications != _currentPreferences!.pushNotificationsEnabled) {
      changes['pushNotifications'] = pushNotifications;
    }
    if (emailNotifications != null && emailNotifications != _currentPreferences!.emailNotificationsEnabled) {
      changes['emailNotifications'] = emailNotifications;
    }
    if (smsNotifications != null && smsNotifications != _currentPreferences!.smsNotificationsEnabled) {
      changes['smsNotifications'] = smsNotifications;
    }

    await _updatePreferences(
      updatedPreferences,
      'notifications',
          () => ProfileNotificationSettingsUpdated(
        preferences: updatedPreferences,
        changedSettings: changes,
      ),
    );
  }

  /// Update privacy settings
  Future<void> updatePrivacySettings({
    bool? shareDataForAnalytics,
    bool? shareDataForMarketing,
  }) async {
    if (_currentPreferences == null) {
      emit(const ProfilePreferencesError(
        message: 'No preferences loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PREFERENCES',
      ));
      return;
    }

    emit(ProfilePrivacySettingsUpdating(currentPreferences: _currentPreferences!));
    debugPrint('Updating privacy settings...');

    final previousPrivacyScore = _currentPreferences!.privacyScore;

    final updatedPreferences = _currentPreferences!.copyWith(
      shareDataForAnalytics: shareDataForAnalytics,
      shareDataForMarketing: shareDataForMarketing,
      updatedAt: DateTime.parse('2025-06-22 08:33:00'),
    );

    final newPrivacyScore = updatedPreferences.privacyScore;

    await _updatePreferences(
      updatedPreferences,
      'privacy',
          () => ProfilePrivacySettingsUpdated(
        preferences: updatedPreferences,
        newPrivacyScore: newPrivacyScore,
        previousPrivacyScore: previousPrivacyScore,
      ),
    );
  }

  /// Update security settings
  Future<void> updateSecuritySettings({
    bool? biometricAuth,
    bool? twoFactorAuth,
  }) async {
    if (_currentPreferences == null) {
      emit(const ProfilePreferencesError(
        message: 'No preferences loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PREFERENCES',
      ));
      return;
    }

    emit(ProfileSecuritySettingsUpdating(currentPreferences: _currentPreferences!));
    debugPrint('Updating security settings...');

    final previousSecurityLevel = _currentPreferences!.securityLevel;

    final updatedPreferences = _currentPreferences!.copyWith(
      biometricAuthEnabled: biometricAuth,
      twoFactorAuthEnabled: twoFactorAuth,
      updatedAt: DateTime.parse('2025-06-22 08:33:00'),
    );

    final newSecurityLevel = updatedPreferences.securityLevel;

    await _updatePreferences(
      updatedPreferences,
      'security',
          () => ProfileSecuritySettingsUpdated(
        preferences: updatedPreferences,
        newSecurityLevel: newSecurityLevel,
        previousSecurityLevel: previousSecurityLevel,
      ),
    );
  }

  /// Update currency and timezone
  Future<void> updateLocalizationSettings({
    String? currency,
    String? timeZone,
  }) async {
    if (_currentPreferences == null) {
      emit(const ProfilePreferencesError(
        message: 'No preferences loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PREFERENCES',
      ));
      return;
    }

    emit(ProfilePreferencesUpdating(
      currentPreferences: _currentPreferences!,
      updatingField: 'localization',
    ));

    debugPrint('Updating localization settings...');

    final updatedPreferences = _currentPreferences!.copyWith(
      currency: currency,
      timeZone: timeZone,
      updatedAt: DateTime.parse('2025-06-22 08:33:00'),
    );

    await _updatePreferences(
      updatedPreferences,
      'localization',
          () => ProfilePreferencesUpdated(
        preferences: updatedPreferences,
        message: 'Localization settings updated successfully',
        updatedField: 'localization',
      ),
    );
  }

  /// Reset preferences to defaults
  Future<void> resetToDefaults() async {
    emit(const ProfilePreferencesResetting());
    debugPrint('Resetting preferences to defaults...');

    final defaultPreferences = UserPreferences.defaultsForUser('11'); // roshdology123's ID

    await _updatePreferences(
      defaultPreferences,
      'reset',
          () => ProfilePreferencesReset(defaultPreferences: defaultPreferences),
    );
  }

  /// Refresh preferences data
  Future<void> refreshPreferences() async {
    debugPrint('Refreshing preferences data...');
    await loadPreferences();
  }

  /// Clear any error states and return to loaded state
  void clearError() {
    if (_currentPreferences != null) {
      emit(ProfilePreferencesLoaded(preferences: _currentPreferences!));
    } else {
      emit(const ProfilePreferencesInitial());
    }
  }

  /// Helper method to update preferences
  Future<void> _updatePreferences(
      UserPreferences updatedPreferences,
      String field,
      ProfilePreferencesState Function() successState,
      ) async {
    final params = UpdateUserPreferencesParams(preferences: updatedPreferences);
    final result = await _updateUserPreferencesUseCase(params);

    result.fold(
          (failure) {
        debugPrint('Failed to update $field: ${failure.message}');
        emit(ProfilePreferencesError(
          message: failure.message,
          code: failure.code.toString(),
          currentPreferences: _currentPreferences,
        ));
      },
          (preferences) {
        debugPrint('$field updated successfully');
        _currentPreferences = preferences;
        emit(successState());
      },
    );
  }

  /// Get quick stats about current preferences
  Map<String, dynamic> get preferencesStats {
    if (_currentPreferences == null) return {};

    return {
      'theme': _currentPreferences!.themeModeDisplayName,
      'language': _currentPreferences!.languageDisplayName,
      'notifications_enabled': _currentPreferences!.hasNotificationsEnabled,
      'security_level': _currentPreferences!.securityLevel,
      'privacy_score': _currentPreferences!.privacyScore,
      'currency': _currentPreferences!.currencyDisplayName,
      'last_updated': _currentPreferences!.updatedAt.toIso8601String(),
    };
  }

  @override
  Future<void> close() {
    debugPrint('ProfilePreferencesCubit disposed at 2025-06-22 08:33:00');
    return super.close();
  }
}