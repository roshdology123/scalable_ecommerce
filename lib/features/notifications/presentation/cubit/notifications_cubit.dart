import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/clear_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_notification_by_id_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/send_test_notification_usecase.dart';
import 'notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetNotificationByIdUseCase _getNotificationByIdUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final ClearNotificationsUseCase _clearNotificationsUseCase;
  final GetUnreadCountUseCase _getUnreadCountUseCase;
  final SendTestNotificationUseCase _sendTestNotificationUseCase;

  final AppLogger _logger = AppLogger();

  // Timer for periodic refresh
  Timer? _refreshTimer;

  // Current user ID
  static const String _currentUserId = 'roshdology123';

  NotificationsCubit(
      this._getNotificationsUseCase,
      this._getNotificationByIdUseCase,
      this._markAsReadUseCase,
      this._markAllAsReadUseCase,
      this._deleteNotificationUseCase,
      this._clearNotificationsUseCase,
      this._getUnreadCountUseCase,
      this._sendTestNotificationUseCase,
      ) : super(const NotificationsState.initial()) {
    _logger.logBusinessLogic(
      'notifications_cubit_initialized',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    // Start periodic refresh every 5 minutes
    _startPeriodicRefresh();
  }

  /// Load notifications with filters
  Future<void> loadNotifications({
    int? limit,
    bool? unreadOnly,
    String? type,
    DateTime? since,
    bool isRefresh = false,
  }) async {
    if (!isRefresh && state.isLoading) return;

    _logger.logBusinessLogic(
      'load_notifications_started',
      'cubit_action',
      {
        'limit': limit,
        'unread_only': unreadOnly,
        'type': type,
        'since': since?.toIso8601String(),
        'is_refresh': isRefresh,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    if (isRefresh) {
      state.maybeWhen(
        loaded: (notifications, unreadCount, lastUpdated, selectedNotification, appliedFilters, isRefreshing) {
          emit(NotificationsState.loaded(
            notifications: notifications,
            unreadCount: unreadCount,
            lastUpdated: lastUpdated,
            selectedNotification: selectedNotification,
            appliedFilters: appliedFilters,
            isRefreshing: true,
          ));
        },
        orElse: () => emit(const NotificationsState.loading()),
      );
    } else {
      emit(const NotificationsState.loading());
    }

    final result = await _getNotificationsUseCase(
      GetNotificationsParams(
        userId: _currentUserId,
        limit: limit,
        unreadOnly: unreadOnly,
        type: type,
        since: since,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.loadNotifications',
          failure,
          StackTrace.current,
          {
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );
        emit(NotificationsState.error(
          message: failure.message,
          notifications: state.notifications,
          unreadCount: state.unreadCount,
        ));
      },
          (notifications) {
        _logger.logBusinessLogic(
          'load_notifications_success',
          'cubit_action',
          {
            'notifications_count': notifications.length,
            'unread_count': notifications.where((n) => !n.isRead).length,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        final unreadCount = notifications.where((n) => !n.isRead).length;

        emit(NotificationsState.loaded(
          notifications: notifications,
          unreadCount: unreadCount,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          appliedFilters: NotificationFilters(
            limit: limit,
            unreadOnly: unreadOnly,
            type: type,
            since: since,
          ),
        ));
      },
    );
  }

  /// Get notification by ID
  Future<void> getNotificationById(String notificationId) async {
    _logger.logBusinessLogic(
      'get_notification_by_id_started',
      'cubit_action',
      {
        'notification_id': notificationId,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    // Only show loading if you're already in loaded state, otherwise do nothing or emit loading explicitly.
    state.maybeWhen(
      loaded: (notifications, unreadCount, lastUpdated, selectedNotification, appliedFilters, isRefreshing) {
        emit(NotificationsState.loaded(
          notifications: notifications,
          unreadCount: unreadCount,
          lastUpdated: lastUpdated,
          selectedNotification: selectedNotification,
          appliedFilters: appliedFilters,
          isRefreshing: isRefreshing,

        ));
      },
      orElse: () {
        emit(const NotificationsState.loading());
      },
    );

    final result = await _getNotificationByIdUseCase(
      GetNotificationByIdParams(
        notificationId: notificationId,
        userId: _currentUserId,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.getNotificationById',
          failure,
          StackTrace.current,
          {
            'notification_id': notificationId,
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationsState.error(
          message: failure.message,
          notifications: state.notifications,
          unreadCount: state.unreadCount,
        ));
      },
          (notification) {
        _logger.logBusinessLogic(
          'get_notification_by_id_success',
          'cubit_action',
          {
            'notification_id': notificationId,
            'notification_type': notification.type.name,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        // Update the notifications list with the fetched notification
        final updatedNotifications = state.notifications.map((n) {
          return n.id == notification.id ? notification : n;
        }).toList();

        emit(NotificationsState.loaded(
          notifications: updatedNotifications,
          unreadCount: state.unreadCount,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          selectedNotification: notification,
          appliedFilters: state.appliedFilters,
        ));
      },
    );
  }


  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    _logger.logUserAction('mark_notification_as_read_started', {
      'notification_id': notificationId,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final result = await _markAsReadUseCase(
      MarkAsReadParams(
        notificationId: notificationId,
        userId: _currentUserId,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.markAsRead',
          failure,
          StackTrace.current,
          {
            'notification_id': notificationId,
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationsState.error(
          message: failure.message,
          notifications: state.notifications,
          unreadCount: state.unreadCount,
        ));
      },
          (_) {
        _logger.logUserAction('mark_notification_as_read_success', {
          'notification_id': notificationId,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        });

        // Optimistically update the notification in the list
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(
              isRead: true,
              readAt: DateTime.parse('2025-06-23 08:47:28'),
            );
          }
          return notification;
        }).toList();

        final newUnreadCount = updatedNotifications.where((n) => !n.isRead).length;

        emit(NotificationsState.loaded(
          notifications: updatedNotifications,
          unreadCount: newUnreadCount,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          appliedFilters: state.appliedFilters,
        ));
      },
    );
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    _logger.logUserAction('mark_all_notifications_as_read_started', {
      'current_unread_count': state.unreadCount,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final result = await _markAllAsReadUseCase(
      const MarkAllAsReadParams(userId: _currentUserId),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.markAllAsRead',
          failure,
          StackTrace.current,
          {
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationsState.error(
          message: failure.message,
          notifications: state.notifications,
          unreadCount: state.unreadCount,
        ));
      },
          (_) {
        _logger.logUserAction('mark_all_notifications_as_read_success', {
          'previous_unread_count': state.unreadCount,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        });

        // Optimistically update all notifications as read
        final updatedNotifications = state.notifications.map((notification) {
          return notification.copyWith(
            isRead: true,
            readAt: notification.readAt ?? DateTime.parse('2025-06-23 08:47:28'),
          );
        }).toList();

        emit(NotificationsState.loaded(
          notifications: updatedNotifications,
          unreadCount: 0,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          appliedFilters: state.appliedFilters,
        ));
      },
    );
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    _logger.logUserAction('delete_notification_started', {
      'notification_id': notificationId,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final result = await _deleteNotificationUseCase(
      DeleteNotificationParams(
        notificationId: notificationId,
        userId: _currentUserId,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.deleteNotification',
          failure,
          StackTrace.current,
          {
            'notification_id': notificationId,
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationsState.error(
          message: failure.message,
          notifications: state.notifications,
          unreadCount: state.unreadCount,
        ));
      },
          (_) {
        _logger.logUserAction('delete_notification_success', {
          'notification_id': notificationId,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        });

        // Remove the notification from the list
        final updatedNotifications = state.notifications
            .where((notification) => notification.id != notificationId)
            .toList();

        final newUnreadCount = updatedNotifications.where((n) => !n.isRead).length;

        emit(NotificationsState.loaded(
          notifications: updatedNotifications,
          unreadCount: newUnreadCount,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          appliedFilters: state.appliedFilters,
        ));
      },
    );
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    _logger.logUserAction('clear_all_notifications_started', {
      'current_notifications_count': state.notifications.length,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final result = await _clearNotificationsUseCase(
      const ClearNotificationsParams(userId: _currentUserId),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.clearAllNotifications',
          failure,
          StackTrace.current,
          {
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationsState.error(
          message: failure.message,
          notifications: state.notifications,
          unreadCount: state.unreadCount,
        ));
      },
          (_) {
        _logger.logUserAction('clear_all_notifications_success', {
          'cleared_count': state.notifications.length,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        });

        emit(NotificationsState.loaded(
          notifications: const [],
          unreadCount: 0,
          lastUpdated: DateTime.parse('2025-06-23 08:47:28'),
          appliedFilters: state.appliedFilters,
        ));
      },
    );
  }

  /// Refresh unread count
  Future<void> refreshUnreadCount() async {
    _logger.logBusinessLogic(
      'refresh_unread_count_started',
      'cubit_action',
      {
        'current_count': state.unreadCount,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    final result = await _getUnreadCountUseCase(
      const GetUnreadCountParams(userId: _currentUserId),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.refreshUnreadCount',
          failure,
          StackTrace.current,
          {
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );
      },
          (unreadCount) {
        _logger.logBusinessLogic(
          'refresh_unread_count_success',
          'cubit_action',
          {
            'new_unread_count': unreadCount,
            'previous_count': state.unreadCount,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );
        state.maybeWhen(
          loaded: (notifications, _, lastUpdated, selectedNotification, appliedFilters, isRefreshing) {
            emit(NotificationsState.loaded(
              notifications: notifications,
              unreadCount: unreadCount,
              lastUpdated: lastUpdated,
              selectedNotification: selectedNotification,
              appliedFilters: appliedFilters,
              isRefreshing: isRefreshing,
            ));
          },
          orElse: () {},
        );
      },
    );
  }


  /// Send test notification
  Future<void> sendTestNotification({String? message}) async {
    _logger.logUserAction('send_test_notification_started', {
      'has_custom_message': message != null,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    final result = await _sendTestNotificationUseCase(
      SendTestNotificationParams(
        userId: _currentUserId,
        message: message,
        type: 'test',
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationsCubit.sendTestNotification',
          failure,
          StackTrace.current,
          {
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationsState.error(
          message: failure.message,
          notifications: state.notifications,
          unreadCount: state.unreadCount,
        ));
      },
          (_) {
        _logger.logUserAction('send_test_notification_success', {
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        });

        // Refresh notifications to show the test notification
        loadNotifications(isRefresh: true);
      },
    );
  }

  /// Filter notifications by type
  void filterByType(String? type) {
    _logger.logUserAction('filter_notifications_by_type', {
      'type': type,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    loadNotifications(
      type: type,
      limit: state.appliedFilters?.limit,
      unreadOnly: state.appliedFilters?.unreadOnly,
      since: state.appliedFilters?.since,
    );
  }

  /// Filter notifications by read status
  void filterByReadStatus(bool? unreadOnly) {
    _logger.logUserAction('filter_notifications_by_read_status', {
      'unread_only': unreadOnly,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    loadNotifications(
      unreadOnly: unreadOnly,
      type: state.appliedFilters?.type,
      limit: state.appliedFilters?.limit,
      since: state.appliedFilters?.since,
    );
  }

  /// Refresh notifications
  Future<void> refresh() async {
    await loadNotifications(
      isRefresh: true,
      limit: state.appliedFilters?.limit,
      unreadOnly: state.appliedFilters?.unreadOnly,
      type: state.appliedFilters?.type,
      since: state.appliedFilters?.since,
    );
  }

  /// Start periodic refresh
  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (!state.isLoading && !state.isRefreshing) {
        refreshUnreadCount();
      }
    });
  }

  /// Stop periodic refresh
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;

    _logger.logBusinessLogic(
      'periodic_refresh_stopped',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );
  }

  /// Clear error state
  void clearError() {
    if (state.hasError) {
      emit(NotificationsState.loaded(
        notifications: state.notifications,
        unreadCount: state.unreadCount,
        lastUpdated: state.lastUpdated,
        appliedFilters: state.appliedFilters,
      ));
    }
  }

  /// Select notification
  void selectNotification(AppNotification? notification) {
    state.maybeWhen(
      loaded: (notifications, unreadCount, lastUpdated, selectedNotification, appliedFilters, isRefreshing) {
        emit(NotificationsState.loaded(
          notifications: notifications,
          unreadCount: unreadCount,
          lastUpdated: lastUpdated,
          selectedNotification: notification,
          appliedFilters: appliedFilters,
          isRefreshing: isRefreshing,
        ));
      },
      orElse: () {
      },
    );
  }

  /// Get notifications by priority
  List<AppNotification> getNotificationsByPriority(NotificationPriority priority) {
    return state.notifications.where((n) => n.priority == priority).toList();
  }

  /// Get notifications by type
  List<AppNotification> getNotificationsByType(NotificationType type) {
    return state.notifications.where((n) => n.type == type).toList();
  }

  /// Get unread notifications
  List<AppNotification> get unreadNotifications {
    return state.notifications.where((n) => !n.isRead).toList();
  }

  /// Get read notifications
  List<AppNotification> get readNotifications {
    return state.notifications.where((n) => n.isRead).toList();
  }

  /// Get recent notifications (last 24 hours)
  List<AppNotification> get recentNotifications {
    final yesterday = DateTime.parse('2025-06-23 08:47:28').subtract(const Duration(hours: 24));
    return state.notifications.where((n) => n.createdAt.isAfter(yesterday)).toList();
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    _logger.logBusinessLogic(
      'notifications_cubit_closed',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );
    return super.close();
  }
}