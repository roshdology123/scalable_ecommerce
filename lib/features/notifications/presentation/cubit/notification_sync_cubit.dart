import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/sync_notifications_usecase.dart';
import 'notification_sync_state.dart';

@injectable
class NotificationSyncCubit extends Cubit<NotificationSyncState> {
  final SyncNotificationsUseCase _syncNotificationsUseCase;
  final AppLogger _logger = AppLogger();

  Timer? _autoSyncTimer;
  Timer? _retryTimer;

  // Current user ID
  static const String _currentUserId = 'roshdology123';

  // Auto sync configuration
  static const Duration _autoSyncInterval = Duration(minutes: 15);
  static const Duration _retryDelay = Duration(minutes: 2);
  static const int _maxRetryAttempts = 3;

  int _retryAttempts = 0;

  NotificationSyncCubit(
      this._syncNotificationsUseCase,
      ) : super(const NotificationSyncState.initial()) {
    _logger.logBusinessLogic(
      'notification_sync_cubit_initialized',
      'cubit_lifecycle',
      {
        'auto_sync_interval_minutes': _autoSyncInterval.inMinutes,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    // Start auto sync after initialization
    _startAutoSync();
  }

  /// Start auto sync timer
  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(_autoSyncInterval, (_) {
      if (!state.isSyncing) {
        syncNotifications(isAutoSync: true);
      }
    });

    _logger.logBusinessLogic(
      'auto_sync_started',
      'sync_management',
      {
        'interval_minutes': _autoSyncInterval.inMinutes,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );
  }

  /// Stop auto sync timer
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;

    _logger.logBusinessLogic(
      'auto_sync_stopped',
      'sync_management',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );
  }

  /// Sync notifications
  Future<void> syncNotifications({
    bool forceSync = false,
    bool isAutoSync = false,
  }) async {
    if (state.isSyncing && !forceSync) {
      _logger.logBusinessLogic(
        'sync_skipped_already_syncing',
        'sync_management',
        {
          'force_sync': forceSync,
          'is_auto_sync': isAutoSync,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        },
      );
      return;
    }

    _logger.logBusinessLogic(
      'sync_notifications_started',
      'sync_operation',
      {
        'force_sync': forceSync,
        'is_auto_sync': isAutoSync,
        'retry_attempts': _retryAttempts,
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    emit(NotificationSyncState.syncing(
      isAutoSync: isAutoSync,
      syncStartedAt: DateTime.parse('2025-06-23 08:47:28'),
      retryAttempts: _retryAttempts,
    ));

    final result = await _syncNotificationsUseCase(
      SyncNotificationsParams(
        userId: _currentUserId,
        forceSync: forceSync,
      ),
    );

    result.fold(
          (failure) {
        _retryAttempts++;

        _logger.logErrorWithContext(
          'NotificationSyncCubit.syncNotifications',
          failure,
          StackTrace.current,
          {
            'force_sync': forceSync,
            'is_auto_sync': isAutoSync,
            'retry_attempts': _retryAttempts,
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationSyncState.failed(
          error: failure.message,
          lastSyncAttempt: DateTime.parse('2025-06-23 08:47:28'),
          retryAttempts: _retryAttempts,
          canRetry: _retryAttempts < _maxRetryAttempts,
        ));

        // Schedule retry if we haven't exceeded max attempts
        if (_retryAttempts < _maxRetryAttempts) {
          _scheduleRetry(isAutoSync: isAutoSync);
        } else {
          _logger.logBusinessLogic(
            'sync_max_retries_exceeded',
            'sync_operation',
            {
              'max_attempts': _maxRetryAttempts,
              'user': _currentUserId,
              'timestamp': '2025-06-23 08:47:28',
            },
          );
        }
      },
          (syncedNotifications) {
        _retryAttempts = 0; // Reset retry attempts on success
        _retryTimer?.cancel(); // Cancel any pending retry

        _logger.logBusinessLogic(
          'sync_notifications_success',
          'sync_operation',
          {
            'synced_count': syncedNotifications.length,
            'force_sync': forceSync,
            'is_auto_sync': isAutoSync,
            'user': _currentUserId,
            'timestamp': '2025-06-23 08:47:28',
          },
        );

        emit(NotificationSyncState.completed(
          syncedNotifications: syncedNotifications,
          lastSyncAt: DateTime.parse('2025-06-23 08:47:28'),
          syncedCount: syncedNotifications.length,
          wasAutoSync: isAutoSync,
        ));
      },
    );
  }

  /// Schedule retry sync
  void _scheduleRetry({bool isAutoSync = false}) {
    _retryTimer?.cancel();
    _retryTimer = Timer(_retryDelay, () {
      _logger.logBusinessLogic(
        'sync_retry_scheduled',
        'sync_management',
        {
          'retry_attempt': _retryAttempts + 1,
          'delay_minutes': _retryDelay.inMinutes,
          'is_auto_sync': isAutoSync,
          'user': _currentUserId,
          'timestamp': '2025-06-23 08:47:28',
        },
      );

      syncNotifications(isAutoSync: isAutoSync);
    });
  }

  /// Manual retry sync
  Future<void> retrySyncNotifications() async {
    _logger.logUserAction('manual_sync_retry', {
      'retry_attempts': _retryAttempts,
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    await syncNotifications(forceSync: true);
  }

  /// Reset sync state
  void resetSyncState() {
    _retryAttempts = 0;
    _retryTimer?.cancel();

    _logger.logUserAction('sync_state_reset', {
      'user': _currentUserId,
      'timestamp': '2025-06-23 08:47:28',
    });

    emit(const NotificationSyncState.initial());
  }

  /// Check if sync is needed based on time since last sync
  bool get isSyncNeeded {
    return state.maybeWhen(
      completed: (_, lastSyncAt, __, ___) {
        final timeSinceLastSync = DateTime.parse('2025-06-23 08:47:28').difference(lastSyncAt);
        return timeSinceLastSync.inMinutes >= _autoSyncInterval.inMinutes;
      },
      orElse: () => true,
    );
  }

  /// Get sync status summary
  String get syncStatusSummary {
    return state.maybeWhen(
      initial: () => 'Not synced yet',
      syncing: (isAutoSync, syncStartedAt, retryAttempts) {
        final duration = DateTime.parse('2025-06-23 08:47:28').difference(syncStartedAt);
        return 'Syncing... (${duration.inSeconds}s)';
      },
      completed: (_, lastSyncAt, syncedCount, wasAutoSync) {
        final timeSince = DateTime.parse('2025-06-23 08:47:28').difference(lastSyncAt);
        final timeAgo = _formatTimeDifference(timeSince);
        return 'Last sync: $timeAgo ($syncedCount notifications)';
      },
      failed: (error, lastSyncAttempt, retryAttempts, canRetry) {
        final timeSince = DateTime.parse('2025-06-23 08:47:28').difference(lastSyncAttempt);
        final timeAgo = _formatTimeDifference(timeSince);
        return 'Sync failed $timeAgo ($retryAttempts attempts)';
      }, orElse: () {
        return 'Sync status unknown';
    },
    );
  }

  /// Format time difference for display
  String _formatTimeDifference(Duration difference) {
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Enable auto sync
  void enableAutoSync() {
    if (_autoSyncTimer == null) {
      _startAutoSync();
    }
  }

  /// Get next auto sync time
  DateTime? get nextAutoSyncTime {
    if (_autoSyncTimer == null) return null;

    final lastSyncTime = state.maybeWhen(
      completed: (_, lastSyncAt, __, ___) => lastSyncAt,
      orElse: () => DateTime.parse('2025-06-23 08:47:28'),
    );

    return lastSyncTime.add(_autoSyncInterval);
  }

  /// Get sync health status
  SyncHealth get syncHealth {
    return state.maybeWhen(
      completed: (_, lastSyncAt, __, ___) {
        final timeSinceLastSync = DateTime.parse('2025-06-23 08:47:28').difference(lastSyncAt);
        if (timeSinceLastSync.inMinutes < 30) {
          return SyncHealth.healthy;
        } else if (timeSinceLastSync.inHours < 2) {
          return SyncHealth.warning;
        } else {
          return SyncHealth.critical;
        }
      },
      failed: (_, __, retryAttempts, ___) {
        if (retryAttempts < 2) {
          return SyncHealth.warning;
        } else {
          return SyncHealth.critical;
        }
      },
      orElse: () => SyncHealth.unknown,
    );
  }

  @override
  Future<void> close() {
    _autoSyncTimer?.cancel();
    _retryTimer?.cancel();

    _logger.logBusinessLogic(
      'notification_sync_cubit_closed',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 08:47:28',
      },
    );

    return super.close();
  }
}

enum SyncHealth {
  healthy,
  warning,
  critical,
  unknown,
}