import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_list.dart';
import '../widgets/notification_badge.dart';
import '../widgets/notification_empty_state.dart';
import '../widgets/notification_error_widget.dart';
import '../widgets/notification_filter_chips.dart';
import '../widgets/notification_search_bar.dart';
import '../widgets/notification_floating_counter.dart';
import '../widgets/notification_shimmer_loading.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  void _openSettings(BuildContext context) {
    context.push( '/notifications/settings');
  }

  void _openAnalytics(BuildContext context) {
    context.push( '/notifications/analytics');
  }

  void _onSearch(BuildContext context, String query) {
    // TODO: Connect to search logic in cubit
    context.read<NotificationsCubit>().loadNotifications();
  }

  void _onFilterChanged(BuildContext context, {String? type, bool? unreadOnly}) {
    context.read<NotificationsCubit>().loadNotifications(
      type: type,
      unreadOnly: unreadOnly,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<NotificationsCubit>()..loadNotifications(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return NotificationBadge(
                  count: state.unreadCount,
                  onTap: () => context.read<NotificationsCubit>().refresh(),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.analytics_outlined),
              tooltip: "Analytics",
              onPressed: () => _openAnalytics(context),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: "Settings",
              onPressed: () => _openSettings(context),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocConsumer<NotificationsCubit, NotificationsState>(
            listener: (context, state) {
              if (state.hasError && state.statusMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.statusMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const NotificationShimmerLoading();
              }

              if (state.hasError) {
                return NotificationErrorWidget(
                  message: state.statusMessage,
                  onRetry: () => context.read<NotificationsCubit>().refresh(),
                );
              }

              if (state.isEmpty) {
                return const NotificationEmptyState();
              }

              // Main loaded content
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<NotificationsCubit>().refresh(),
                child: Column(
                  children: [
                    // Search bar and filter chips
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: NotificationSearchBar(
                        onChanged: (q) => _onSearch(context, q),
                      ),
                    ),
                    NotificationFilterChips(
                      selectedType: state.appliedFilters?.type,
                      unreadOnly: state.appliedFilters?.unreadOnly ?? false,
                      onTypeChanged: (type) => _onFilterChanged(context, type: type?.name),
                      onUnreadChanged: (unread) => _onFilterChanged(context, unreadOnly: unread),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: NotificationList(
                        notifications: state.notifications,
                        onNotificationTap: (notification) {
                          context.push(
                            '/notifications/detail/${notification.id}',
                          );
                        },
                        onMarkRead: (notification) {
                          context.read<NotificationsCubit>().markAsRead(notification.id);
                        },
                        onDelete: (notification) {
                          context.read<NotificationsCubit>().deleteNotification(notification.id);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.unreadCount == 0) return const SizedBox.shrink();
            return NotificationFloatingCounter(
              count: state.unreadCount,
              onTap: () => context.read<NotificationsCubit>().filterByReadStatus(true),
            );
          },
        ),
      ),
    );
  }
}