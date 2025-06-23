import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../profile/domain/entities/user_preferences.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/usecases/update_notification_settings_usecase.dart';
import '../../domain/usecases/subscribe_to_topic_usecase.dart';
import '../../domain/usecases/unsubscribe_from_topic_usecase.dart';
import '../../domain/usecases/update_fcm_token_usecase.dart';
import 'notification_preferences_state.dart';

@injectable
class NotificationPreferencesCubit extends Cubit<NotificationPreferencesState> {
  final UpdateNotificationSettingsUseCase _updateNotificationSettingsUseCase;
  final SubscribeToTopicUseCase _subscribeToTopicUseCase;
  final UnsubscribeFromTopicUseCase _unsubscribeFromTopicUseCase;
  final UpdateFCMTokenUseCase _updateFCMTokenUseCase;

  final AppLogger _logger = AppLogger();

  // Current user ID
  static const String _currentUserId = 'roshdology123';

  NotificationPreferencesCubit(
      this._updateNotificationSettingsUseCase,
      this._subscribeToTopicUseCase,
      this._unsubscribeFromTopicUseCase,
      this._updateFCMTokenUseCase,
      ) : super(const NotificationPreferencesState.initial()) {
    _logger.logBusinessLogic(
      'notification_preferences_cubit_initialized',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    // Load initial preferences
    _loadInitialPreferences();
  }
  void loadPreferences() {
    _loadInitialPreferences();
  }
  /// Load initial preferences
  void _loadInitialPreferences() {
    _logger.logBusinessLogic(
      'load_initial_preferences_started',
      'cubit_action',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    // Create default preferences for the user
    final defaultPreferences = NotificationPreferences.defaultForUser(_currentUserId);

    emit(NotificationPreferencesState.loaded(
      preferences: defaultPreferences,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    ));

    _logger.logBusinessLogic(
      'load_initial_preferences_success',
      'cubit_action',
      {
        'push_enabled': defaultPreferences.pushNotificationsEnabled,
        'email_enabled': defaultPreferences.emailNotificationsEnabled,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );
  }

  /// Update notification preferences
  Future<void> updatePreferences(NotificationPreferences preferences) async {
    _logger.logBusinessLogic(
      'update_preferences_started',
      'cubit_action',
      {
        'push_enabled': preferences.pushNotificationsEnabled,
        'email_enabled': preferences.emailNotificationsEnabled,
        'sms_enabled': preferences.smsNotificationsEnabled,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    emit(const NotificationPreferencesState.updating());

    final result = await _updateNotificationSettingsUseCase(
      UpdateNotificationSettingsParams(
        userId: _currentUserId,
        preferences: preferences,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationPreferencesCubit.updatePreferences',
          failure,
          StackTrace.current,
          {
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationPreferencesState.error(
          message: failure.message,
          preferences: state.preferences,
        ));
      },
          (_) {
        _logger.logBusinessLogic(
          'update_preferences_success',
          'cubit_action',
          {
            'enabled_types': preferences.enabledNotificationTypes.map((e) => e.name).toList(),
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationPreferencesState.loaded(
          preferences: preferences,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        ));
      },
    );
  }

  /// Toggle push notifications
  Future<void> togglePushNotifications(bool enabled) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      pushNotificationsEnabled: enabled,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Toggle email notifications
  Future<void> toggleEmailNotifications(bool enabled) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      emailNotificationsEnabled: enabled,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Toggle SMS notifications
  Future<void> toggleSMSNotifications(bool enabled) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      smsNotificationsEnabled: enabled,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Toggle notification type
  Future<void> toggleNotificationType(NotificationType type, bool enabled) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    NotificationPreferences updatedPreferences;

    switch (type) {
      case NotificationType.orderUpdate:
        updatedPreferences = currentPreferences.copyWith(
          orderUpdatesEnabled: enabled,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      case NotificationType.promotion:
        updatedPreferences = currentPreferences.copyWith(
          promotionsEnabled: enabled,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      case NotificationType.cartAbandonment:
        updatedPreferences = currentPreferences.copyWith(
          cartAbandonmentEnabled: enabled,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      case NotificationType.priceAlert:
        updatedPreferences = currentPreferences.copyWith(
          priceAlertsEnabled: enabled,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      case NotificationType.stockAlert:
        updatedPreferences = currentPreferences.copyWith(
          stockAlertsEnabled: enabled,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      case NotificationType.newProduct:
        updatedPreferences = currentPreferences.copyWith(
          newProductsEnabled: enabled,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      default:
        return; // No specific setting for general notifications
    }

    await updatePreferences(updatedPreferences);
  }

  /// Update notification frequency
  Future<void> updateFrequency(NotificationType type, NotificationFrequency frequency) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    NotificationPreferences updatedPreferences;

    switch (type) {
      case NotificationType.orderUpdate:
        updatedPreferences = currentPreferences.copyWith(
          orderUpdatesFrequency: frequency,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      case NotificationType.promotion:
        updatedPreferences = currentPreferences.copyWith(
          promotionsFrequency: frequency,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
      default:
        updatedPreferences = currentPreferences.copyWith(
          newsletterFrequency: frequency,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
        );
        break;
    }

    await updatePreferences(updatedPreferences);
  }

  /// Toggle quiet hours
  Future<void> toggleQuietHours(bool enabled) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      quietHoursEnabled: enabled,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Update quiet hours time
  Future<void> updateQuietHours(String startTime, String endTime) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      quietHoursStart: startTime,
      quietHoursEnd: endTime,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    _logger.logUserAction('subscribe_to_topic_started', {
      'topic': topic,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final result = await _subscribeToTopicUseCase(
      SubscribeToTopicParams(
        userId: _currentUserId,
        topic: topic,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationPreferencesCubit.subscribeToTopic',
          failure,
          StackTrace.current,
          {
            'topic': topic,
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationPreferencesState.error(
          message: failure.message,
          preferences: state.preferences,
        ));
      },
          (_) {
        _logger.logUserAction('subscribe_to_topic_success', {
          'topic': topic,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        });

        // Update local preferences to include the new topic
        final currentPreferences = state.preferences;
        if (currentPreferences != null) {
          final updatedTopics = [...currentPreferences.subscribedTopics];
          if (!updatedTopics.contains(topic)) {
            updatedTopics.add(topic);
          }

          final updatedPreferences = currentPreferences.copyWith(
            subscribedTopics: updatedTopics,
            lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          );

          emit(NotificationPreferencesState.loaded(
            preferences: updatedPreferences,
            lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          ));
        }
      },
    );
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    _logger.logUserAction('unsubscribe_from_topic_started', {
      'topic': topic,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final result = await _unsubscribeFromTopicUseCase(
      UnsubscribeFromTopicParams(
        userId: _currentUserId,
        topic: topic,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationPreferencesCubit.unsubscribeFromTopic',
          failure,
          StackTrace.current,
          {
            'topic': topic,
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationPreferencesState.error(
          message: failure.message,
          preferences: state.preferences,
        ));
      },
          (_) {
        _logger.logUserAction('unsubscribe_from_topic_success', {
          'topic': topic,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        });

        // Update local preferences to remove the topic
        final currentPreferences = state.preferences;
        if (currentPreferences != null) {
          final updatedTopics = currentPreferences.subscribedTopics
              .where((t) => t != topic)
              .toList();

          final updatedPreferences = currentPreferences.copyWith(
            subscribedTopics: updatedTopics,
            lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          );

          emit(NotificationPreferencesState.loaded(
            preferences: updatedPreferences,
            lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          ));
        }
      },
    );
  }

  /// Update FCM token
  Future<void> updateFCMToken(String fcmToken, {String? deviceId, String? platform}) async {
    _logger.logBusinessLogic(
      'update_fcm_token_started',
      'cubit_action',
      {
        'token_length': fcmToken.length,
        'device_id': deviceId,
        'platform': platform,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    final result = await _updateFCMTokenUseCase(
      UpdateFCMTokenParams(
        userId: _currentUserId,
        fcmToken: fcmToken,
        deviceId: deviceId,
        platform: platform,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationPreferencesCubit.updateFCMToken',
          failure,
          StackTrace.current,
          {
            'failure_message': failure.message,
            'device_id': deviceId,
            'platform': platform,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationPreferencesState.error(
          message: failure.message,
          preferences: state.preferences,
        ));
      },
          (_) {
        _logger.logBusinessLogic(
          'update_fcm_token_success',
          'cubit_action',
          {
            'device_id': deviceId,
            'platform': platform,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        // No need to update UI state for FCM token updates
      },
    );
  }

  /// Reset preferences to default
  Future<void> resetToDefaults() async {
    _logger.logUserAction('reset_preferences_to_defaults', {
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final defaultPreferences = NotificationPreferences.defaultForUser(_currentUserId);
    await updatePreferences(defaultPreferences);
  }

  /// Update sound preference
  Future<void> updateSoundPreference(String soundPreference) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      soundPreference: soundPreference,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Update vibration preference
  Future<void> updateVibrationPreference(String vibrationPreference) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      vibrationPreference: vibrationPreference,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Toggle show on lock screen
  Future<void> toggleShowOnLockScreen(bool enabled) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      showOnLockScreen: enabled,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Toggle show preview
  Future<void> toggleShowPreview(bool enabled) async {
    final currentPreferences = state.preferences;
    if (currentPreferences == null) return;

    final updatedPreferences = currentPreferences.copyWith(
      showPreview: enabled,
      lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
    );

    await updatePreferences(updatedPreferences);
  }

  /// Clear error state
  void clearError() {
    if (state.hasError) {
      final preferences = state.preferences;
      if (preferences != null) {
        emit(NotificationPreferencesState.loaded(
          preferences: preferences,
          lastUpdated: state.lastUpdated,
        ));
      } else {
        emit(const NotificationPreferencesState.initial());
      }
    }
  }

  @override
  Future<void> close() {
    _logger.logBusinessLogic(
      'notification_preferences_cubit_closed',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );
    return super.close();
  }
}