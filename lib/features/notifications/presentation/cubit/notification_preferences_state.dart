import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_preferences.dart';

part 'notification_preferences_state.freezed.dart';

@freezed
class NotificationPreferencesState with _$NotificationPreferencesState {
  const factory NotificationPreferencesState.initial() = _Initial;

  const factory NotificationPreferencesState.loading() = _Loading;

  const factory NotificationPreferencesState.updating() = _Updating;

  const factory NotificationPreferencesState.loaded({
    required NotificationPreferences preferences,
    DateTime? lastUpdated,
  }) = _Loaded;

  const factory NotificationPreferencesState.error({
    required String message,
    NotificationPreferences? preferences,
    DateTime? lastUpdated,
  }) = _Error;
}

extension NotificationPreferencesStateExtensions on NotificationPreferencesState {
  bool get isLoading => maybeWhen(
    loading: () => true,
    orElse: () => false,
  );

  bool get isUpdating => maybeWhen(
    updating: () => true,
    orElse: () => false,
  );

  bool get hasError => maybeWhen(
    error: (_, __, ___) => true,
    orElse: () => false,
  );

  bool get hasData => maybeWhen(
    loaded: (_, __) => true,
    orElse: () => false,
  );

  NotificationPreferences? get preferences => maybeWhen(
    loaded: (preferences, _) => preferences,
    error: (_, preferences, __) => preferences,
    orElse: () => null,
  );

  DateTime? get lastUpdated => maybeWhen(
    loaded: (_, lastUpdated) => lastUpdated,
    error: (_, __, lastUpdated) => lastUpdated,
    orElse: () => null,
  );

  String get statusMessage => maybeWhen(
    initial: () => 'Ready to load preferences',
    loading: () => 'Loading preferences...',
    updating: () => 'Updating preferences...',
    loaded: (preferences, lastUpdated) {
      final enabledCount = preferences.enabledNotificationTypes.length;
      return 'Preferences loaded ($enabledCount types enabled)';
    },
    error: (message, _, __) => 'Error: $message', orElse: () {
      return 'Unknown state';
  },
  );

  bool get canUpdate => maybeWhen(
    loaded: (_, __) => true,
    orElse: () => false,
  );

  bool get isBusy => isLoading || isUpdating;
}