import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/notification_simulator.dart';
import '../models/notification_model.dart';
import '../models/notification_preferences_model.dart';
import '../models/fcm_token_model.dart';
import '../models/notification_stats_model.dart';

@injectable
class NotificationsRemoteDataSource {
  final DioClient _dioClient;
  final AppLogger _logger = AppLogger();
  final NotificationSimulator _simulator = NotificationSimulator();
  final Random _random = Random();

  NotificationsRemoteDataSource(this._dioClient);

  /// Simulate getting notifications from server
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int? limit,
    bool? unreadOnly,
    DateTime? since,
    String? type,
    int? offset,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_get_notifications_started',
        'api_simulation',
        {
          'user_id': userId,
          'limit': limit,
          'unread_only': unreadOnly,
          'since': since?.toIso8601String(),
          'type': type,
          'offset': offset,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1500)));

      // Simulate 3% chance of server error for testing
      if (_random.nextDouble() < 0.03) {
        throw const ServerException(message: 'Server temporarily unavailable');
      }

      // Generate mock notifications based on parameters
      final mockNotifications = _generateMockNotifications(
        userId: userId,
        limit: limit ?? 20,
        unreadOnly: unreadOnly ?? false,
        since: since,
        type: type,
        offset: offset ?? 0,
      );

      _logger.logBusinessLogic(
        'remote_get_notifications_success',
        'api_simulation',
        {
          'notifications_count': mockNotifications.length,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      return mockNotifications;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.getNotifications',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      if (e is ServerException) {
        rethrow;
      }
      throw const ServerException(message: 'Failed to fetch notifications from server');
    }
  }

  /// Get single notification by ID
  Future<NotificationModel?> getNotificationById({
    required String notificationId,
    required String userId,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_get_notification_by_id_started',
        'api_simulation',
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(800)));

      // Simulate notification not found (10% chance)
      if (_random.nextDouble() < 0.1) {
        return null;
      }

      // Generate a single mock notification
      final notification = _generateSingleMockNotification(notificationId, userId);

      _logger.logBusinessLogic(
        'remote_get_notification_by_id_success',
        'api_simulation',
        {
          'notification_id': notificationId,
          'found': notification != null,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      return notification;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.getNotificationById',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to fetch notification from server');
    }
  }

  /// Simulate marking notification as read on server
  Future<void> markAsRead({
    required String notificationId,
    required String userId,
  }) async {
    try {
      _logger.logUserAction('remote_mark_notification_read_started', {
        'notification_id': notificationId,
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(800)));

      // Simulate 5% chance of server error for testing
      if (_random.nextDouble() < 0.05) {
        throw const ServerException(message: 'Failed to update notification status');
      }

      _logger.logUserAction('remote_mark_notification_read_success', {
        'notification_id': notificationId,
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.markAsRead',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      rethrow;
    }
  }

  /// Simulate marking all notifications as read
  Future<void> markAllAsRead({required String userId}) async {
    try {
      _logger.logUserAction('remote_mark_all_notifications_read_started', {
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

      _logger.logUserAction('remote_mark_all_notifications_read_success', {
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.markAllAsRead',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to mark all notifications as read');
    }
  }

  /// Simulate deleting notification on server
  Future<void> deleteNotification({
    required String notificationId,
    required String userId,
  }) async {
    try {
      _logger.logUserAction('remote_delete_notification_started', {
        'notification_id': notificationId,
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));

      _logger.logUserAction('remote_delete_notification_success', {
        'notification_id': notificationId,
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.deleteNotification',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to delete notification from server');
    }
  }

  /// Simulate updating FCM token on server
  Future<void> updateFCMToken({
    required String userId,
    required FCMTokenModel tokenModel,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_update_fcm_token_started',
        'api_simulation',
        {
          'user_id': userId,
          'device_id': tokenModel.deviceId,
          'platform': tokenModel.platform,
          'token_length': tokenModel.token.length,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));

      // Simulate API call to update FCM token
      // In real implementation, this would be:
      // await _dioClient.post('/notifications/fcm-token', data: tokenModel.toApi());

      _logger.logBusinessLogic(
        'remote_update_fcm_token_success',
        'api_simulation',
        {
          'user_id': userId,
          'device_id': tokenModel.deviceId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.updateFCMToken',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to update FCM token on server');
    }
  }

  /// Simulate updating notification preferences on server
  Future<void> updateNotificationPreferences({
    required String userId,
    required NotificationPreferencesModel preferences,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_update_notification_preferences_started',
        'api_simulation',
        {
          'user_id': userId,
          'push_enabled': preferences.pushNotificationsEnabled,
          'email_enabled': preferences.emailNotificationsEnabled,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 400 + _random.nextInt(600)));

      // Simulate API call to update preferences
      // In real implementation:
      // await _dioClient.put('/notifications/preferences', data: preferences.toApi());

      _logger.logBusinessLogic(
        'remote_update_notification_preferences_success',
        'api_simulation',
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.updateNotificationPreferences',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to update notification preferences on server');
    }
  }

  /// Simulate getting notification preferences from server
  Future<NotificationPreferencesModel> getNotificationPreferences({
    required String userId,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_get_notification_preferences_started',
        'api_simulation',
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));

      // Generate mock preferences
      final preferences = _generateMockPreferences(userId);

      _logger.logBusinessLogic(
        'remote_get_notification_preferences_success',
        'api_simulation',
        {
          'user_id': userId,
          'push_enabled': preferences.pushNotificationsEnabled,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      return preferences;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.getNotificationPreferences',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to get notification preferences from server');
    }
  }

  /// Simulate getting unread count from server
  Future<int> getUnreadCount({required String userId}) async {
    try {
      _logger.logBusinessLogic(
        'remote_get_unread_count_started',
        'api_simulation',
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(500)));

      // Simulate random unread count
      final unreadCount = _random.nextInt(15);

      _logger.logBusinessLogic(
        'remote_get_unread_count_success',
        'api_simulation',
        {
          'user_id': userId,
          'unread_count': unreadCount,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      return unreadCount;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.getUnreadCount',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to get unread count from server');
    }
  }

  /// Simulate getting notification statistics
  Future<NotificationStatsModel> getNotificationStats({
    required String userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_get_notification_stats_started',
        'api_simulation',
        {
          'user_id': userId,
          'from_date': fromDate?.toIso8601String(),
          'to_date': toDate?.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));

      // Generate mock statistics
      final stats = _generateMockStats(userId, fromDate, toDate);

      _logger.logBusinessLogic(
        'remote_get_notification_stats_success',
        'api_simulation',
        {
          'user_id': userId,
          'total_notifications': stats.totalNotifications,
          'engagement_rate': stats.engagementRate,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      return stats;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.getNotificationStats',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to get notification statistics from server');
    }
  }

  /// Simulate sending test notification
  Future<void> sendTestNotification({
    required String userId,
    String? message,
    String? type,
  }) async {
    try {
      _logger.logUserAction('remote_send_test_notification_started', {
        'user_id': userId,
        'message': message,
        'type': type,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

      // Generate test notification through simulator
      _simulator.generateActionBasedNotification('test_notification', {
        'user_id': userId,
        'message': message ?? 'This is a test notification sent from the server!',
        'type': type ?? 'test',
        'sent_from': 'remote_api',
      });

      _logger.logUserAction('remote_send_test_notification_success', {
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:26:36',
      });
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.sendTestNotification',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to send test notification');
    }
  }

  /// Simulate subscribing to notification topic
  Future<void> subscribeToTopic({
    required String userId,
    required String topic,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_subscribe_to_topic_started',
        'api_simulation',
        {
          'user_id': userId,
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));

      _logger.logBusinessLogic(
        'remote_subscribe_to_topic_success',
        'api_simulation',
        {
          'user_id': userId,
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.subscribeToTopic',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to subscribe to topic');
    }
  }

  /// Simulate unsubscribing from notification topic
  Future<void> unsubscribeFromTopic({
    required String userId,
    required String topic,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_unsubscribe_from_topic_started',
        'api_simulation',
        {
          'user_id': userId,
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));

      _logger.logBusinessLogic(
        'remote_unsubscribe_from_topic_success',
        'api_simulation',
        {
          'user_id': userId,
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.unsubscribeFromTopic',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'topic': topic,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to unsubscribe from topic');
    }
  }

  /// Simulate synchronizing notifications with server
  Future<List<NotificationModel>> syncNotifications({
    required String userId,
    DateTime? lastSyncTime,
  }) async {
    try {
      _logger.logBusinessLogic(
        'remote_sync_notifications_started',
        'api_simulation',
        {
          'user_id': userId,
          'last_sync_time': lastSyncTime?.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(2000)));

      // Get notifications since last sync
      final syncedNotifications = await getNotifications(
        userId: userId,
        since: lastSyncTime,
        limit: 50,
      );

      _logger.logBusinessLogic(
        'remote_sync_notifications_success',
        'api_simulation',
        {
          'user_id': userId,
          'synced_count': syncedNotifications.length,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );

      return syncedNotifications;
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRemoteDataSource.syncNotifications',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:26:36',
        },
      );
      throw const ServerException(message: 'Failed to sync notifications with server');
    }
  }

  // =========================================================================
  // PRIVATE HELPER METHODS FOR MOCK DATA GENERATION
  // =========================================================================

  /// Generate mock notifications for simulation
  List<NotificationModel> _generateMockNotifications({
    required String userId,
    required int limit,
    required bool unreadOnly,
    DateTime? since,
    String? type,
    required int offset,
  }) {
    final notifications = <NotificationModel>[];
    final now = DateTime.parse('2025-06-23 08:26:36');

    final mockData = [
      {
        'title': '🎉 Welcome Back!',
        'body': 'Check out our latest deals and offers just for you!',
        'type': 'general',
        'priority': 'normal',
        'isRead': false,
        'hoursAgo': 1,
        'category': 'welcome',
      },
      {
        'title': '🔥 Flash Sale Alert!',
        'body': '50% OFF on Electronics! Limited time offer ending soon.',
        'type': 'promotion',
        'priority': 'high',
        'isRead': false,
        'hoursAgo': 2,
        'category': 'electronics',
      },
      {
        'title': '📦 Order Shipped!',
        'body': 'Your order #FS2025001 has been shipped and is on its way!',
        'type': 'orderUpdate',
        'priority': 'high',
        'isRead': true,
        'hoursAgo': 6,
        'category': 'orders',
      },
      {
        'title': '🛒 Forgot Something?',
        'body': 'You have 3 items waiting in your cart. Complete your purchase now!',
        'type': 'cartAbandonment',
        'priority': 'normal',
        'isRead': false,
        'hoursAgo': 12,
        'category': 'cart',
      },
      {
        'title': '💰 Price Drop Alert!',
        'body': 'MacBook Pro is now 15% cheaper! Was \$1299, now \$1104.15',
        'type': 'priceAlert',
        'priority': 'high',
        'isRead': true,
        'hoursAgo': 18,
        'category': 'electronics',
      },
      {
        'title': '⚠️ Low Stock Alert',
        'body': 'Only 3 units left of iPhone 14! Order now before it\'s gone.',
        'type': 'stockAlert',
        'priority': 'urgent',
        'isRead': false,
        'hoursAgo': 24,
        'category': 'electronics',
      },
      {
        'title': '🆕 New Product Launch',
        'body': 'Check out the latest iPhone 15 Pro Max now available!',
        'type': 'newProduct',
        'priority': 'normal',
        'isRead': true,
        'hoursAgo': 48,
        'category': 'electronics',
      },
    ];

    for (int i = offset; i < limit + offset && i < mockData.length * 3; i++) {
      final dataIndex = i % mockData.length;
      final data = mockData[dataIndex];

      // Filter by type if specified
      if (type != null && data['type'] != type) continue;

      final isRead = data['isRead'] as bool;

      // Filter by read status if specified
      if (unreadOnly && isRead) continue;

      final createdAt = now.subtract(Duration(hours: (data['hoursAgo'] as int) + (i ~/ mockData.length) * 24));

      // Filter by date if specified
      if (since != null && createdAt.isBefore(since)) continue;

      final notification = NotificationModel(
        id: 'mock_${now.millisecondsSinceEpoch}_$i',
        title: data['title'] as String,
        body: data['body'] as String,
        type: data['type'] as String,
        priority: data['priority'] as String,
        data: {
          'mock': true,
          'index': i,
          'category': data['category'],
          'generated_at': now.toIso8601String(),
          'source': 'remote_api',
          'utm_source': 'api_simulation',
          'utm_medium': 'mobile_app',
        },
        createdAt: createdAt,
        userId: userId,
        isRead: isRead,
        readAt: isRead ? createdAt.add(Duration(minutes: _random.nextInt(60))) : null,
        imageUrl: 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=${i + 1}',
        category: data['category'] as String,
        source: 'api',
      );

      notifications.add(notification);
    }

    return notifications.take(limit).toList();
  }

  /// Generate single mock notification
  NotificationModel _generateSingleMockNotification(String notificationId, String userId) {
    final now = DateTime.parse('2025-06-23 08:26:36');

    return NotificationModel(
      id: notificationId,
      title: '📱 Your Requested Notification',
      body: 'This is the notification you requested with ID: $notificationId',
      type: 'general',
      priority: 'normal',
      data: {
        'requested': true,
        'generated_at': now.toIso8601String(),
        'source': 'remote_api',
      },
      createdAt: now.subtract(Duration(hours: _random.nextInt(24))),
      userId: userId,
      isRead: _random.nextBool(),
      imageUrl: 'https://via.placeholder.com/100x100/2196F3/FFFFFF?text=📱',
      source: 'api',
    );
  }

  /// Generate mock notification preferences
  NotificationPreferencesModel _generateMockPreferences(String userId) {
    return NotificationPreferencesModel(
      userId: userId,
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: true,
      smsNotificationsEnabled: false,
      orderUpdatesEnabled: true,
      promotionsEnabled: _random.nextBool(),
      cartAbandonmentEnabled: true,
      priceAlertsEnabled: true,
      stockAlertsEnabled: true,
      newProductsEnabled: _random.nextBool(),
      orderUpdatesFrequency: 'immediately',
      promotionsFrequency: _random.nextBool() ? 'daily' : 'weekly',
      newsletterFrequency: 'weekly',
      quietHoursEnabled: _random.nextBool(),
      quietHoursStart: '22:00',
      quietHoursEnd: '08:00',
      subscribedTopics: [
        'general',
        'user_$userId',
        'electronics',
        if (_random.nextBool()) 'promotions',
        if (_random.nextBool()) 'jewelery',
      ],
      mutedCategories: _random.nextBool() ? ['spam'] : [],
      lastUpdated: DateTime.parse('2025-06-23 08:26:36'),
    );
  }

  /// Generate mock notification statistics
  NotificationStatsModel _generateMockStats(String userId, DateTime? fromDate, DateTime? toDate) {
    final totalNotifications = 50 + _random.nextInt(200);
    final readCount = (totalNotifications * (0.6 + _random.nextDouble() * 0.3)).round();
    final unreadCount = totalNotifications - readCount;

    return NotificationStatsModel(
      totalNotifications: totalNotifications,
      unreadCount: unreadCount,
      readCount: readCount,
      todayCount: 3 + _random.nextInt(10),
      weekCount: 15 + _random.nextInt(30),
      monthCount: totalNotifications,
      typeBreakdown: {
        'promotion': 20 + _random.nextInt(30),
        'orderUpdate': 10 + _random.nextInt(20),
        'cartAbandonment': 5 + _random.nextInt(15),
        'priceAlert': 8 + _random.nextInt(12),
        'stockAlert': 3 + _random.nextInt(8),
        'general': 4 + _random.nextInt(10),
      },
      priorityBreakdown: {
        'normal': (totalNotifications * 0.5).round(),
        'high': (totalNotifications * 0.3).round(),
        'low': (totalNotifications * 0.15).round(),
        'urgent': (totalNotifications * 0.05).round(),
      },
      dailyStats: _generateDailyStats(),
      averageReadTime: 2.5 + _random.nextDouble() * 5.0,
      engagementRate: 60.0 + _random.nextDouble() * 35.0,
      lastNotificationAt: DateTime.parse('2025-06-23 08:26:36').subtract(Duration(hours: _random.nextInt(24))),
      lastReadAt: DateTime.parse('2025-06-23 08:26:36').subtract(Duration(hours: _random.nextInt(6))),
      generatedAt: '2025-06-23 08:26:36',
    );
  }

  /// Generate daily statistics for the past week
  Map<String, int> _generateDailyStats() {
    final stats = <String, int>{};
    final now = DateTime.parse('2025-06-23 08:26:36');

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      stats[dateStr] = 1 + _random.nextInt(10);
    }

    return stats;
  }
}