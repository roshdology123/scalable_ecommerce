import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_preferences.dart';


abstract class ProfilePreferencesState extends Equatable {
  const ProfilePreferencesState();

  @override
  List<Object?> get props => [];
}

/// Initial state when preferences cubit is first created
class ProfilePreferencesInitial extends ProfilePreferencesState {
  const ProfilePreferencesInitial();

  @override
  String toString() => 'ProfilePreferencesInitial';
}

/// State when preferences are being loaded from server or cache
class ProfilePreferencesLoading extends ProfilePreferencesState {
  const ProfilePreferencesLoading();

  @override
  String toString() => 'ProfilePreferencesLoading';
}

/// State when preferences have been successfully loaded
class ProfilePreferencesLoaded extends ProfilePreferencesState {
  final UserPreferences preferences;

  const ProfilePreferencesLoaded({required this.preferences});

  @override
  List<Object?> get props => [preferences];

  @override
  String toString() => 'ProfilePreferencesLoaded(theme: ${preferences.themeModeDisplayName})';
}

/// State when preferences are being updated
class ProfilePreferencesUpdating extends ProfilePreferencesState {
  final UserPreferences currentPreferences;
  final String updatingField;

  const ProfilePreferencesUpdating({
    required this.currentPreferences,
    this.updatingField = 'preferences',
  });

  @override
  List<Object?> get props => [currentPreferences, updatingField];

  @override
  String toString() => 'ProfilePreferencesUpdating(field: $updatingField)';
}

/// State when preferences have been successfully updated
class ProfilePreferencesUpdated extends ProfilePreferencesState {
  final UserPreferences preferences;
  final String message;
  final String updatedField;

  const ProfilePreferencesUpdated({
    required this.preferences,
    this.message = 'Preferences updated successfully',
    this.updatedField = 'preferences',
  });

  @override
  List<Object?> get props => [preferences, message, updatedField];

  @override
  String toString() => 'ProfilePreferencesUpdated(field: $updatedField, message: $message)';
}

/// State when theme is being changed
class ProfileThemeChanging extends ProfilePreferencesState {
  final UserPreferences currentPreferences;
  final ThemeMode newTheme;

  const ProfileThemeChanging({
    required this.currentPreferences,
    required this.newTheme,
  });

  @override
  List<Object?> get props => [currentPreferences, newTheme];

  @override
  String toString() => 'ProfileThemeChanging(newTheme: ${newTheme.name})';
}

/// State when theme has been successfully changed
class ProfileThemeChanged extends ProfilePreferencesState {
  final UserPreferences preferences;
  final ThemeMode previousTheme;
  final ThemeMode newTheme;

  const ProfileThemeChanged({
    required this.preferences,
    required this.previousTheme,
    required this.newTheme,
  });

  @override
  List<Object?> get props => [preferences, previousTheme, newTheme];

  @override
  String toString() => 'ProfileThemeChanged(from: ${previousTheme.name}, to: ${newTheme.name})';
}

/// State when language is being changed
class ProfileLanguageChanging extends ProfilePreferencesState {
  final UserPreferences currentPreferences;
  final Language newLanguage;

  const ProfileLanguageChanging({
    required this.currentPreferences,
    required this.newLanguage,
  });

  @override
  List<Object?> get props => [currentPreferences, newLanguage];

  @override
  String toString() => 'ProfileLanguageChanging(newLanguage: ${newLanguage.name})';
}

/// State when language has been successfully changed
class ProfileLanguageChanged extends ProfilePreferencesState {
  final UserPreferences preferences;
  final Language previousLanguage;
  final Language newLanguage;

  const ProfileLanguageChanged({
    required this.preferences,
    required this.previousLanguage,
    required this.newLanguage,
  });

  @override
  List<Object?> get props => [preferences, previousLanguage, newLanguage];

  @override
  String toString() => 'ProfileLanguageChanged(from: ${previousLanguage.name}, to: ${newLanguage.name})';
}

/// State when notification settings are being updated
class ProfileNotificationSettingsUpdating extends ProfilePreferencesState {
  final UserPreferences currentPreferences;

  const ProfileNotificationSettingsUpdating({required this.currentPreferences});

  @override
  List<Object?> get props => [currentPreferences];

  @override
  String toString() => 'ProfileNotificationSettingsUpdating';
}

/// State when notification settings have been updated
class ProfileNotificationSettingsUpdated extends ProfilePreferencesState {
  final UserPreferences preferences;
  final Map<String, bool> changedSettings;

  const ProfileNotificationSettingsUpdated({
    required this.preferences,
    required this.changedSettings,
  });

  @override
  List<Object?> get props => [preferences, changedSettings];

  @override
  String toString() => 'ProfileNotificationSettingsUpdated(changes: ${changedSettings.length})';
}

/// State when privacy settings are being updated
class ProfilePrivacySettingsUpdating extends ProfilePreferencesState {
  final UserPreferences currentPreferences;

  const ProfilePrivacySettingsUpdating({required this.currentPreferences});

  @override
  List<Object?> get props => [currentPreferences];

  @override
  String toString() => 'ProfilePrivacySettingsUpdating';
}

/// State when privacy settings have been updated
class ProfilePrivacySettingsUpdated extends ProfilePreferencesState {
  final UserPreferences preferences;
  final int newPrivacyScore;
  final int previousPrivacyScore;

  const ProfilePrivacySettingsUpdated({
    required this.preferences,
    required this.newPrivacyScore,
    required this.previousPrivacyScore,
  });

  @override
  List<Object?> get props => [preferences, newPrivacyScore, previousPrivacyScore];

  @override
  String toString() => 'ProfilePrivacySettingsUpdated(score: $previousPrivacyScore → $newPrivacyScore)';
}

/// State when security settings are being updated
class ProfileSecuritySettingsUpdating extends ProfilePreferencesState {
  final UserPreferences currentPreferences;

  const ProfileSecuritySettingsUpdating({required this.currentPreferences});

  @override
  List<Object?> get props => [currentPreferences];

  @override
  String toString() => 'ProfileSecuritySettingsUpdating';
}

/// State when security settings have been updated
class ProfileSecuritySettingsUpdated extends ProfilePreferencesState {
  final UserPreferences preferences;
  final String newSecurityLevel;
  final String previousSecurityLevel;

  const ProfileSecuritySettingsUpdated({
    required this.preferences,
    required this.newSecurityLevel,
    required this.previousSecurityLevel,
  });

  @override
  List<Object?> get props => [preferences, newSecurityLevel, previousSecurityLevel];

  @override
  String toString() => 'ProfileSecuritySettingsUpdated(level: $previousSecurityLevel → $newSecurityLevel)';
}

/// State when preferences are being reset to defaults
class ProfilePreferencesResetting extends ProfilePreferencesState {
  const ProfilePreferencesResetting();

  @override
  String toString() => 'ProfilePreferencesResetting';
}

/// State when preferences have been reset to defaults
class ProfilePreferencesReset extends ProfilePreferencesState {
  final UserPreferences defaultPreferences;

  const ProfilePreferencesReset({required this.defaultPreferences});

  @override
  List<Object?> get props => [defaultPreferences];

  @override
  String toString() => 'ProfilePreferencesReset';
}

/// State when an error has occurred with preferences
class ProfilePreferencesError extends ProfilePreferencesState {
  final String message;
  final String code;
  final UserPreferences? currentPreferences;

  const ProfilePreferencesError({
    required this.message,
    required this.code,
    this.currentPreferences,
  });

  @override
  List<Object?> get props => [message, code, currentPreferences];

  @override
  String toString() => 'ProfilePreferencesError(code: $code, message: $message)';
}

/// State when a network error has occurred with preferences
class ProfilePreferencesNetworkError extends ProfilePreferencesState {
  final String message;
  final UserPreferences? cachedPreferences;

  const ProfilePreferencesNetworkError({
    required this.message,
    this.cachedPreferences,
  });

  @override
  List<Object?> get props => [message, cachedPreferences];

  @override
  String toString() => 'ProfilePreferencesNetworkError(message: $message, hasCachedPreferences: ${cachedPreferences != null})';
}