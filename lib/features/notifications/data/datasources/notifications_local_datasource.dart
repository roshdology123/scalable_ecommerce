import 'package:injectable/injectable.dart';
import 'package:scalable_ecommerce/features/notifications/data/models/notification_preferences_model.dart';

import '../../../../core/storage/local_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/notification_model.dart';
import '../models/fcm_token_model.dart';

@injectable
class NotificationsLocalDataSource {
  final AppLogger _logger = AppLogger();

  /// Get notifications from local storage
  Future<List<NotificationModel>> getNotifications({
    bool? unreadOnly,
    int? limit,
    String? type,
    DateTime? since,
  }) async {
    try {
      _logger.logBusinessLogic(
        'local_get_notifications_started',
        'local_storage',
        {
          'unread_only': unreadOnly,
          'limit': limit,
          'type': type,
          'since': since?.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      // Get all notifications and filter out nulls
      var notifications = LocalStorage.getNotifications(
        unreadOnly: unreadOnly,
        limit: limit,
      ).where((n) => n != null).cast<NotificationModel>().toList();

      // Filter by type if specified
      if (type != null) {
        notifications = notifications.where((n) => n.type == type).toList();
      }

      // Filter by date if specified
      if (since != null) {
        notifications = notifications.where((n) => n.createdAt.isAfter(since)).toList();
      }

      // Remove expired notifications
      notifications = notifications.where((n) => !n.hasExpired).toList();

      _logger.logBusinessLogic(
        'local_get_notifications_success',
        'local_storage',
        {
          'notifications_count': notifications.length,
          'filtered_by_type': type != null,
          'filtered_by_date': since != null,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      return notifications;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.getNotifications',
        e,
        StackTrace.current,
        {
          'unread_only': unreadOnly,
          'limit': limit,
          'type': type,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to get notifications from local storage');
    }
  }

  /// Save notifications to local storage
  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    try {
      _logger.logBusinessLogic(
        'local_save_notifications_started',
        'local_storage',
        {
          'notifications_count': notifications.length,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      await LocalStorage.saveNotifications(notifications);

      _logger.logBusinessLogic(
        'local_save_notifications_success',
        'local_storage',
        {
          'notifications_count': notifications.length,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.saveNotifications',
        e,
        StackTrace.current,
        {
          'notifications_count': notifications.length,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to save notifications to local storage');
    }
  }

  /// Save single notification
  Future<void> saveNotification(NotificationModel notification) async {
    try {
      await LocalStorage.saveNotification(notification);

      _logger.logBusinessLogic(
        'local_save_single_notification_success',
        'local_storage',
        {
          'notification_id': notification.id,
          'type': notification.type,
          'source': notification.source,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.saveNotification',
        e,
        StackTrace.current,
        {
          'notification_id': notification.id,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to save notification to local storage');
    }
  }

  /// Get notification by ID
  Future<NotificationModel?> getNotificationById(String notificationId) async {
    try {
      final notification = LocalStorage.getNotification(notificationId);

      _logger.logBusinessLogic(
        'local_get_notification_by_id',
        'local_storage',
        {
          'notification_id': notificationId,
          'found': notification != null,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      return notification;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.getNotificationById',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      return null;
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await LocalStorage.markNotificationAsRead(notificationId);

      _logger.logUserAction('local_mark_notification_read', {
        'notification_id': notificationId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:30:59',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.markAsRead',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to mark notification as read');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await LocalStorage.markAllNotificationsAsRead();

      _logger.logUserAction('local_mark_all_notifications_read', {
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:30:59',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.markAllAsRead',
        e,
        StackTrace.current,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to mark all notifications as read');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await LocalStorage.deleteNotification(notificationId);

      _logger.logUserAction('local_delete_notification', {
        'notification_id': notificationId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:30:59',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.deleteNotification',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to delete notification');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await LocalStorage.clearNotifications();

      _logger.logUserAction('local_clear_all_notifications', {
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:30:59',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.clearAllNotifications',
        e,
        StackTrace.current,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to clear all notifications');
    }
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    try {
      final count = LocalStorage.getUnreadNotificationsCount();

      _logger.logBusinessLogic(
        'local_get_unread_count',
        'local_storage',
        {
          'unread_count': count,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      return count;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.getUnreadCount',
        e,
        StackTrace.current,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      return 0;
    }
  }

  /// Get notifications by type
  Future<List<NotificationModel>> getNotificationsByType(String type) async {
    try {
      // Get notifications and filter out nulls
      final notifications = LocalStorage.getNotificationsByType(type)
          .where((n) => n != null)
          .cast<NotificationModel>()
          .toList();

      _logger.logBusinessLogic(
        'local_get_notifications_by_type',
        'local_storage',
        {
          'type': type,
          'notifications_count': notifications.length,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      return notifications;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.getNotificationsByType',
        e,
        StackTrace.current,
        {
          'type': type,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to get notifications by type');
    }
  }

  /// Save notification preferences
  Future<void> saveNotificationPreferences(NotificationPreferencesModel preferences) async {
    try {
      // Store preferences in local storage
      await LocalStorage.savePushNotificationsEnabled(preferences.pushNotificationsEnabled);
      await LocalStorage.saveEmailNotificationsEnabled(preferences.emailNotificationsEnabled);
      await LocalStorage.saveSMSNotificationsEnabled(preferences.smsNotificationsEnabled);

      _logger.logBusinessLogic(
        'local_save_notification_preferences_success',
        'local_storage',
        {
          'user_id': preferences.userId,
          'push_enabled': preferences.pushNotificationsEnabled,
          'email_enabled': preferences.emailNotificationsEnabled,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.saveNotificationPreferences',
        e,
        StackTrace.current,
        {
          'user_id': preferences.userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to save notification preferences');
    }
  }

  /// Get notification preferences
  Future<NotificationPreferencesModel?> getNotificationPreferences(String userId) async {
    try {
      // For now, create from individual settings
      final pushEnabled = LocalStorage.getPushNotificationsEnabled();
      final emailEnabled = LocalStorage.getEmailNotificationsEnabled();
      final smsEnabled = LocalStorage.getSMSNotificationsEnabled();

      final preferences = NotificationPreferencesModel(
        userId: userId,
        pushNotificationsEnabled: pushEnabled,
        emailNotificationsEnabled: emailEnabled,
        smsNotificationsEnabled: smsEnabled,
        lastUpdated: DateTime.parse('2025-06-23 08:30:59'),
      );

      _logger.logBusinessLogic(
        'local_get_notification_preferences_success',
        'local_storage',
        {
          'user_id': userId,
          'push_enabled': pushEnabled,
          'email_enabled': emailEnabled,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      return preferences;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.getNotificationPreferences',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      return null;
    }
  }

  /// Save FCM token
  Future<void> saveFCMToken(FCMTokenModel tokenModel) async {
    try {
      await LocalStorage.saveFCMToken(tokenModel.token);

      _logger.logBusinessLogic(
        'local_save_fcm_token_success',
        'local_storage',
        {
          'user_id': tokenModel.userId,
          'device_id': tokenModel.deviceId,
          'platform': tokenModel.platform,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.saveFCMToken',
        e,
        StackTrace.current,
        {
          'user_id': tokenModel.userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to save FCM token');
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      final token = LocalStorage.getFCMToken();

      _logger.logBusinessLogic(
        'local_get_fcm_token',
        'local_storage',
        {
          'has_token': token != null,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      return token;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.getFCMToken',
        e,
        StackTrace.current,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      return null;
    }
  }

  /// Save last sync time
  Future<void> saveLastSyncTime(DateTime syncTime) async {
    try {
      await LocalStorage.saveLastNotificationSync(syncTime);

      _logger.logBusinessLogic(
        'local_save_last_sync_time',
        'local_storage',
        {
          'sync_time': syncTime.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.saveLastSyncTime',
        e,
        StackTrace.current,
        {
          'sync_time': syncTime.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      throw const CacheException(message: 'Failed to save last sync time');
    }
  }

  /// Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    try {
      final syncTime = LocalStorage.getLastNotificationSync();

      _logger.logBusinessLogic(
        'local_get_last_sync_time',
        'local_storage',
        {
          'sync_time': syncTime?.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );

      return syncTime;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsLocalDataSource.getLastSyncTime',
        e,
        StackTrace.current,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:30:59',
        },
      );
      return null;
    }
  }
}