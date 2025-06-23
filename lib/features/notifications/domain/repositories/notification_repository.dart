import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/notification.dart';
import '../entities/notification_preferences.dart';
import '../entities/notification_stats.dart';

abstract class NotificationsRepository {
  /// Get notifications for user
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    required String userId,
    int? limit,
    bool? unreadOnly,
    String? type,
    DateTime? since,
  });

  /// Get single notification by ID
  Future<Either<Failure, AppNotification>> getNotificationById({
    required String notificationId,
    required String userId,
  });

  /// Mark notification as read
  Future<Either<Failure, void>> markAsRead({
    required String notificationId,
    required String userId,
  });

  /// Mark all notifications as read
  Future<Either<Failure, void>> markAllAsRead({
    required String userId,
  });

  /// Delete notification
  Future<Either<Failure, void>> deleteNotification({
    required String notificationId,
    required String userId,
  });

  /// Update notification settings
  Future<Either<Failure, void>> updateNotificationSettings({
    required String userId,
    required NotificationPreferences preferences,
  });

  /// Update FCM token
  Future<Either<Failure, void>> updateFCMToken({
    required String userId,
    required String fcmToken,
    String? deviceId,
    String? platform,
  });

  /// Get unread notifications count
  Future<Either<Failure, int>> getUnreadCount({
    required String userId,
  });

  /// Get notification statistics
  Future<Either<Failure, NotificationStats>> getNotificationStats({
    required String userId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Sync notifications with server
  Future<Either<Failure, List<AppNotification>>> syncNotifications({
    required String userId,
  });
}