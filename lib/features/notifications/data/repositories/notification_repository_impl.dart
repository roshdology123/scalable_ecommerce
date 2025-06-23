import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/notification_stats.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notifications_local_datasource.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../models/notification_model.dart';
import '../models/notification_preferences_model.dart';
import '../models/fcm_token_model.dart';

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppLogger _logger = AppLogger();

  NotificationsRepositoryImpl(
      this._remoteDataSource,
      this._localDataSource,
      this._networkInfo,
      );

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    required String userId,
    int? limit,
    bool? unreadOnly,
    String? type,
    DateTime? since,
  }) async {
    try {
      _logger.logBusinessLogic(
        'repository_get_notifications_started',
        'repository_operation',
        {
          'user_id': userId,
          'limit': limit,
          'unread_only': unreadOnly,
          'type': type,
          'since': since?.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (await _networkInfo.isConnected) {
        // Try to get from remote first
        try {
          final remoteNotifications = await _remoteDataSource.getNotifications(
            userId: userId,
            limit: limit,
            unreadOnly: unreadOnly,
            type: type,
            since: since,
          );

          // Save to local storage for offline access
          await _localDataSource.saveNotifications(remoteNotifications);

          // Update last sync time
          await _localDataSource.saveLastSyncTime(DateTime.parse('2025-06-23 08:34:10'));

          final notifications = remoteNotifications.map((model) => model.toNotification()).toList();

          _logger.logBusinessLogic(
            'repository_get_notifications_success_remote',
            'repository_operation',
            {
              'notifications_count': notifications.length,
              'source': 'remote',
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );

          return Right(notifications);
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_get_notifications_remote_failed_fallback_local',
            'repository_operation',
            {
              'error': e.toString(),
              'fallback_to': 'local',
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
          // Fall back to local data
        }
      }

      // Get from local storage (offline or fallback)
      final localNotifications = await _localDataSource.getNotifications(
        unreadOnly: unreadOnly,
        limit: limit,
        type: type,
        since: since,
      );

      final notifications = localNotifications.map((model) => model.toNotification()).toList();

      _logger.logBusinessLogic(
        'repository_get_notifications_success_local',
        'repository_operation',
        {
          'notifications_count': notifications.length,
          'source': 'local',
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      return Right(notifications);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.getNotifications',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is ServerException) {
        return Left(ServerFailure(message: e.message));
      } else if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return const Left(ServerFailure(message: 'Failed to get notifications'));
      }
    }
  }

  @override
  Future<Either<Failure, AppNotification>> getNotificationById({
    required String notificationId,
    required String userId,
  }) async {
    try {
      _logger.logBusinessLogic(
        'repository_get_notification_by_id_started',
        'repository_operation',
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      // Try local first for speed
      final localNotification = await _localDataSource.getNotificationById(notificationId);

      if (localNotification != null) {
        _logger.logBusinessLogic(
          'repository_get_notification_by_id_success_local',
          'repository_operation',
          {
            'notification_id': notificationId,
            'source': 'local',
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:34:10',
          },
        );

        return Right(localNotification.toNotification());
      }

      // If not found locally and connected, try remote
      if (await _networkInfo.isConnected) {
        final remoteNotification = await _remoteDataSource.getNotificationById(
          notificationId: notificationId,
          userId: userId,
        );

        if (remoteNotification != null) {
          // Save to local storage
          await _localDataSource.saveNotification(remoteNotification);

          _logger.logBusinessLogic(
            'repository_get_notification_by_id_success_remote',
            'repository_operation',
            {
              'notification_id': notificationId,
              'source': 'remote',
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );

          return Right(remoteNotification.toNotification());
        }
      }

      // Not found anywhere
      return const Left(CacheFailure(message: 'Notification not found'));
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.getNotificationById',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is ServerException) {
        return Left(ServerFailure(message: e.message));
      } else if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return const Left(ServerFailure(message: 'Failed to get notification'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required String notificationId,
    required String userId,
  }) async {
    try {
      _logger.logUserAction('repository_mark_notification_read_started', {
        'notification_id': notificationId,
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:34:10',
      });

      // Mark as read locally immediately (optimistic update)
      await _localDataSource.markAsRead(notificationId);

      // Try to sync with remote if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.markAsRead(
            notificationId: notificationId,
            userId: userId,
          );

          _logger.logUserAction('repository_mark_notification_read_success_synced', {
            'notification_id': notificationId,
            'synced': true,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:34:10',
          });
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_mark_notification_read_sync_failed',
            'repository_operation',
            {
              'notification_id': notificationId,
              'sync_error': e.toString(),
              'local_updated': true,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
          // Continue even if remote sync fails - local update succeeded
        }
      }

      return const Right(null);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.markAsRead',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return const Left(CacheFailure(message: 'Failed to mark notification as read'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead({
    required String userId,
  }) async {
    try {
      _logger.logUserAction('repository_mark_all_notifications_read_started', {
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:34:10',
      });

      // Mark all as read locally immediately
      await _localDataSource.markAllAsRead();

      // Try to sync with remote if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.markAllAsRead(userId: userId);

          _logger.logUserAction('repository_mark_all_notifications_read_success_synced', {
            'user_id': userId,
            'synced': true,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:34:10',
          });
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_mark_all_notifications_read_sync_failed',
            'repository_operation',
            {
              'user_id': userId,
              'sync_error': e.toString(),
              'local_updated': true,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
          // Continue even if remote sync fails
        }
      }

      return const Right(null);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.markAllAsRead',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return const Left(CacheFailure(message: 'Failed to mark all notifications as read'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification({
    required String notificationId,
    required String userId,
  }) async {
    try {
      _logger.logUserAction('repository_delete_notification_started', {
        'notification_id': notificationId,
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:34:10',
      });

      // Delete locally immediately
      await _localDataSource.deleteNotification(notificationId);

      // Try to sync with remote if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.deleteNotification(
            notificationId: notificationId,
            userId: userId,
          );

          _logger.logUserAction('repository_delete_notification_success_synced', {
            'notification_id': notificationId,
            'synced': true,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:34:10',
          });
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_delete_notification_sync_failed',
            'repository_operation',
            {
              'notification_id': notificationId,
              'sync_error': e.toString(),
              'local_deleted': true,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
          // Continue even if remote sync fails
        }
      }

      return const Right(null);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.deleteNotification',
        e,
        StackTrace.current,
        {
          'notification_id': notificationId,
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return const Left(CacheFailure(message: 'Failed to delete notification'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationSettings({
    required String userId,
    required NotificationPreferences preferences,
  }) async {
    try {
      _logger.logBusinessLogic(
        'repository_update_notification_settings_started',
        'repository_operation',
        {
          'user_id': userId,
          'push_enabled': preferences.pushNotificationsEnabled,
          'email_enabled': preferences.emailNotificationsEnabled,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      // Convert domain entity to model
      final preferencesModel = NotificationPreferencesModel(
        userId: preferences.userId,
        pushNotificationsEnabled: preferences.pushNotificationsEnabled,
        emailNotificationsEnabled: preferences.emailNotificationsEnabled,
        smsNotificationsEnabled: preferences.smsNotificationsEnabled,
        orderUpdatesEnabled: preferences.orderUpdatesEnabled,
        promotionsEnabled: preferences.promotionsEnabled,
        cartAbandonmentEnabled: preferences.cartAbandonmentEnabled,
        priceAlertsEnabled: preferences.priceAlertsEnabled,
        stockAlertsEnabled: preferences.stockAlertsEnabled,
        newProductsEnabled: preferences.newProductsEnabled,
        orderUpdatesFrequency: preferences.orderUpdatesFrequency.name,
        promotionsFrequency: preferences.promotionsFrequency.name,
        newsletterFrequency: preferences.newsletterFrequency.name,
        quietHoursEnabled: preferences.quietHoursEnabled,
        quietHoursStart: preferences.quietHoursStart,
        quietHoursEnd: preferences.quietHoursEnd,
        subscribedTopics: preferences.subscribedTopics,
        mutedCategories: preferences.mutedCategories,
        soundPreference: preferences.soundPreference,
        vibrationPreference: preferences.vibrationPreference,
        showOnLockScreen: preferences.showOnLockScreen,
        showPreview: preferences.showPreview,
        lastUpdated: DateTime.parse('2025-06-23 08:34:10'),
      );

      // Save locally immediately
      await _localDataSource.saveNotificationPreferences(preferencesModel);

      // Try to sync with remote if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.updateNotificationPreferences(
            userId: userId,
            preferences: preferencesModel,
          );

          _logger.logBusinessLogic(
            'repository_update_notification_settings_success_synced',
            'repository_operation',
            {
              'user_id': userId,
              'synced': true,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_update_notification_settings_sync_failed',
            'repository_operation',
            {
              'user_id': userId,
              'sync_error': e.toString(),
              'local_updated': true,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
          // Continue even if remote sync fails
        }
      }

      return const Right(null);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.updateNotificationSettings',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure(message: e.message));
      } else {
        return const Left(CacheFailure(message: 'Failed to update notification settings'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateFCMToken({
    required String userId,
    required String fcmToken,
    String? deviceId,
    String? platform,
  }) async {
    try {
      _logger.logBusinessLogic(
        'repository_update_fcm_token_started',
        'repository_operation',
        {
          'user_id': userId,
          'token_length': fcmToken.length,
          'device_id': deviceId,
          'platform': platform,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      // Create FCM token model
      final tokenModel = FCMTokenModel.create(
        token: fcmToken,
        userId: userId,
        deviceId: deviceId ?? 'unknown_device',
        platform: platform ?? 'unknown_platform',
      );

      // Save locally immediately
      await _localDataSource.saveFCMToken(tokenModel);

      // Try to sync with remote if connected
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.updateFCMToken(
            userId: userId,
            tokenModel: tokenModel,
          );

          _logger.logBusinessLogic(
            'repository_update_fcm_token_success_synced',
            'repository_operation',
            {
              'user_id': userId,
              'synced': true,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_update_fcm_token_sync_failed',
            'repository_operation',
            {
              'user_id': userId,
              'sync_error': e.toString(),
              'local_updated': true,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
          // Continue even if remote sync fails
        }
      }

      return const Right(null);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.updateFCMToken',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else if (e is ServerException) {
        return Left(ServerFailure(message: e.message));
      } else {
        return const Left(CacheFailure(message: 'Failed to update FCM token'));
      }
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount({
    required String userId,
  }) async {
    try {
      _logger.logBusinessLogic(
        'repository_get_unread_count_started',
        'repository_operation',
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (await _networkInfo.isConnected) {
        // Try to get from remote first
        try {
          final remoteCount = await _remoteDataSource.getUnreadCount(userId: userId);

          _logger.logBusinessLogic(
            'repository_get_unread_count_success_remote',
            'repository_operation',
            {
              'unread_count': remoteCount,
              'source': 'remote',
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );

          return Right(remoteCount);
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_get_unread_count_remote_failed_fallback_local',
            'repository_operation',
            {
              'error': e.toString(),
              'fallback_to': 'local',
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );
          // Fall back to local count
        }
      }

      // Get from local storage
      final localCount = await _localDataSource.getUnreadCount();

      _logger.logBusinessLogic(
        'repository_get_unread_count_success_local',
        'repository_operation',
        {
          'unread_count': localCount,
          'source': 'local',
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      return Right(localCount);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.getUnreadCount',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is CacheException) {
        return Left(CacheFailure(message: e.message));
      } else {
        return const Left(CacheFailure(message: 'Failed to get unread count'));
      }
    }
  }

  @override
  Future<Either<Failure, NotificationStats>> getNotificationStats({
    required String userId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      _logger.logBusinessLogic(
        'repository_get_notification_stats_started',
        'repository_operation',
        {
          'user_id': userId,
          'from_date': fromDate?.toIso8601String(),
          'to_date': toDate?.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (await _networkInfo.isConnected) {
        try {
          final statsModel = await _remoteDataSource.getNotificationStats(
            userId: userId,
            fromDate: fromDate,
            toDate: toDate,
          );

          final stats = NotificationStats(
            totalNotifications: statsModel.totalNotifications,
            unreadCount: statsModel.unreadCount,
            readCount: statsModel.readCount,
            todayCount: statsModel.todayCount,
            weekCount: statsModel.weekCount,
            monthCount: statsModel.monthCount,
            typeBreakdown: statsModel.typeBreakdown,
            priorityBreakdown: statsModel.priorityBreakdown,
            dailyStats: statsModel.dailyStats,
            averageReadTime: statsModel.averageReadTime,
            engagementRate: statsModel.engagementRate,
            lastNotificationAt: statsModel.lastNotificationAt,
            lastReadAt: statsModel.lastReadAt,
            generatedAt: DateTime.parse('2025-06-23 08:34:10'),
          );

          _logger.logBusinessLogic(
            'repository_get_notification_stats_success',
            'repository_operation',
            {
              'total_notifications': stats.totalNotifications,
              'engagement_rate': stats.engagementRate,
              'source': 'remote',
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );

          return Right(stats);
        } catch (e) {
          _logger.logBusinessLogic(
            'repository_get_notification_stats_remote_failed',
            'repository_operation',
            {
              'error': e.toString(),
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:34:10',
            },
          );

          // Return empty stats on error
          return Right(NotificationStats.empty());
        }
      }

      // Return empty stats when offline
      return Right(NotificationStats.empty());
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.getNotificationStats',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      return const Left(ServerFailure(message: 'Failed to get notification statistics'));
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> syncNotifications({
    required String userId,
  }) async {
    try {
      _logger.logBusinessLogic(
        'repository_sync_notifications_started',
        'repository_operation',
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }

      // Get last sync time
      final lastSyncTime = await _localDataSource.getLastSyncTime();

      // Sync with remote
      final syncedNotifications = await _remoteDataSource.syncNotifications(
        userId: userId,
        lastSyncTime: lastSyncTime,
      );

      // Save synced notifications locally
      if (syncedNotifications.isNotEmpty) {
        await _localDataSource.saveNotifications(syncedNotifications);
      }

      // Update last sync time
      await _localDataSource.saveLastSyncTime(DateTime.parse('2025-06-23 08:34:10'));

      final notifications = syncedNotifications.map((model) => model.toNotification()).toList();

      _logger.logBusinessLogic(
        'repository_sync_notifications_success',
        'repository_operation',
        {
          'synced_count': notifications.length,
          'last_sync_time': lastSyncTime?.toIso8601String(),
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      return Right(notifications);
    } catch (e) {
      _logger.logErrorWithContext(
        'NotificationsRepositoryImpl.syncNotifications',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:34:10',
        },
      );

      if (e is ServerException) {
        return Left(ServerFailure(message: e.message));
      } else {
        return const Left(ServerFailure(message: 'Failed to sync notifications'));
      }
    }
  }
}