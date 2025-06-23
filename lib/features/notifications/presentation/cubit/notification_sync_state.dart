import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification.dart';

part 'notification_sync_state.freezed.dart';

@freezed
class NotificationSyncState with _$NotificationSyncState {
  const factory NotificationSyncState.initial() = _Initial;

  const factory NotificationSyncState.syncing({
    @Default(false) bool isAutoSync,
    required DateTime syncStartedAt,
    @Default(0) int retryAttempts,
  }) = _Syncing;

  const factory NotificationSyncState.completed({
    required List<AppNotification> syncedNotifications,
    required DateTime lastSyncAt,
    required int syncedCount,
    @Default(false) bool wasAutoSync,
  }) = _Completed;

  const factory NotificationSyncState.failed({
    required String error,
    required DateTime lastSyncAttempt,
    @Default(0) int retryAttempts,
    @Default(true) bool canRetry,
  }) = _Failed;
}

extension NotificationSyncStateExtensions on NotificationSyncState {
  bool get isSyncing => maybeWhen(
    syncing: (_, __, ___) => true,
    orElse: () => false,
  );

  bool get hasError => maybeWhen(
    failed: (_, __, ___, ____) => true,
    orElse: () => false,
  );

  bool get hasCompletedSync => maybeWhen(
    completed: (_, __, ___, ____) => true,
    orElse: () => false,
  );

  bool get canRetry => maybeWhen(
    failed: (_, __, ___, canRetry) => canRetry,
    orElse: () => false,
  );

  DateTime? get lastSyncTime => maybeWhen(
    completed: (_, lastSyncAt, __, ___) => lastSyncAt,
    failed: (_, lastSyncAttempt, __, ___) => lastSyncAttempt,
    orElse: () => null,
  );

  int get retryAttempts => maybeWhen(
    syncing: (_, __, retryAttempts) => retryAttempts,
    failed: (_, __, retryAttempts, ___) => retryAttempts,
    orElse: () => 0,
  );

  List<AppNotification> get syncedNotifications => maybeWhen(
    completed: (syncedNotifications, _, __, ___) => syncedNotifications,
    orElse: () => const [],
  );

  String get statusMessage => maybeWhen(
    initial: () => 'Ready to sync',
    syncing: (isAutoSync, syncStartedAt, retryAttempts) {
      final duration = DateTime.parse('2025-06-23 08:52:28').difference(syncStartedAt);
      final syncType = isAutoSync ? 'Auto sync' : 'Manual sync';
      final retryText = retryAttempts > 0 ? ' (retry #$retryAttempts)' : '';
      return '$syncType in progress... (${duration.inSeconds}s)$retryText';
    },
    completed: (_, lastSyncAt, syncedCount, wasAutoSync) {
      final timeSince = DateTime.parse('2025-06-23 08:52:28').difference(lastSyncAt);
      final timeAgo = _formatDuration(timeSince);
      final syncType = wasAutoSync ? 'Auto' : 'Manual';
      return '$syncType sync completed $timeAgo ($syncedCount notifications)';
    },
    failed: (error, lastSyncAttempt, retryAttempts, canRetry) {
      final timeSince = DateTime.parse('2025-06-23 08:52:28').difference(lastSyncAttempt);
      final timeAgo = _formatDuration(timeSince);
      final retryText = canRetry ? ' (can retry)' : ' (max retries reached)';
      return 'Sync failed $timeAgo$retryText';
    }, orElse: () {
      return 'Unknown sync state';
  },
  );

  String get errorMessage => maybeWhen(
    failed: (error, _, __, ___) => error,
    orElse: () => '',
  );

  bool get isHealthy => maybeWhen(
    completed: (_, lastSyncAt, __, ___) {
      final timeSince = DateTime.parse('2025-06-23 08:52:28').difference(lastSyncAt);
      return timeSince.inMinutes < 30; // Healthy if synced within 30 minutes
    },
    orElse: () => false,
  );

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return 'just now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else {
      return '${duration.inDays}d ago';
    }
  }
}