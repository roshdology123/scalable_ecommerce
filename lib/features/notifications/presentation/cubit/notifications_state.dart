import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _Initial;

  const factory NotificationsState.loading() = _Loading;

  const factory NotificationsState.loaded({
    required List<AppNotification> notifications,
    required int unreadCount,
    DateTime? lastUpdated,
    AppNotification? selectedNotification,
    NotificationFilters? appliedFilters,
    @Default(false) bool isRefreshing,
  }) = _Loaded;

  const factory NotificationsState.error({
    required String message,
    @Default([]) List<AppNotification> notifications,
    @Default(0) int unreadCount,
    DateTime? lastUpdated,
    NotificationFilters? appliedFilters,
  }) = _Error;
}

@freezed
class NotificationFilters with _$NotificationFilters {
  const factory NotificationFilters({
    int? limit,
    bool? unreadOnly,
    String? type,
    DateTime? since,
  }) = _NotificationFilters;
}

extension NotificationsStateExtensions on NotificationsState {
  bool get isLoading => maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
  AppNotification? get selectedNotification => maybeWhen(
    loaded: (_, __, ___, selectedNotification, ____, _____) => selectedNotification,
    orElse: () => null,
  );
  bool get isRefreshing => maybeWhen(
    loaded: (_, __, ___, ____, _____, isRefreshing) => isRefreshing,
    orElse: () => false,
  );

  bool get hasError => maybeWhen(
    error: (_, __, ___, ____, _____) => true,
    orElse: () => false,
  );

  bool get hasData => maybeWhen(
    loaded: (notifications, _, __, ___, ____, _____) => notifications.isNotEmpty,
    orElse: () => false,
  );

  bool get isEmpty => maybeWhen(
    loaded: (notifications, _, __, ___, ____, _____) => notifications.isEmpty,
    orElse: () => true,
  );

  List<AppNotification> get notifications => maybeWhen(
    loaded: (notifications, _, __, ___, ____, _____) => notifications,
    error: (_, notifications, __, ___, ____) => notifications,
    orElse: () => const [],
  );

  int get unreadCount => maybeWhen(
    loaded: (_, unreadCount, __, ___, ____, _____) => unreadCount,
    error: (_, __, unreadCount, ___, ____) => unreadCount,
    orElse: () => 0,
  );

  DateTime? get lastUpdated => maybeWhen(
    loaded: (_, __, lastUpdated, ___, ____, _____) => lastUpdated,
    error: (_, __, ___, lastUpdated, ____) => lastUpdated,
    orElse: () => null,
  );

  NotificationFilters? get appliedFilters => maybeWhen(
    loaded: (_, __, ___, ____, appliedFilters, _____) => appliedFilters,
    error: (_, __, ___, ____, appliedFilters) => appliedFilters,
    orElse: () => null,
  );

  bool get hasFiltersApplied => appliedFilters != null && (
      appliedFilters!.type != null ||
          appliedFilters!.unreadOnly == true ||
          appliedFilters!.since != null
  );

  String get statusMessage => maybeWhen(
    initial: () => 'Ready to load notifications',
    loading: () => 'Loading notifications...',
    loaded: (notifications, unreadCount, _, __, ___, isRefreshing) {
      if (isRefreshing) return 'Refreshing...';
      if (notifications.isEmpty) return 'No notifications found';
      return '${notifications.length} notifications loaded${unreadCount > 0 ? ' ($unreadCount unread)' : ''}';
    },
    error: (message, _, __, ___, ____) => 'Error: $message', orElse: () {
      return 'Unknown state';
  },
  );
}