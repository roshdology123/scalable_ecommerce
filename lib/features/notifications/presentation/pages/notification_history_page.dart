import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_empty_state.dart';
import '../widgets/notification_error_widget.dart';
import '../widgets/notification_list.dart';
import '../widgets/notification_search_bar.dart';
import '../widgets/notification_filter_chips.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});

  @override
  State<NotificationHistoryPage> createState() => _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {
  String _searchQuery = '';

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    // Optionally: context.read<NotificationsCubit>().searchNotifications(query);
  }

  void _onFilterChanged({String? type, bool? unreadOnly}) {
    context.read<NotificationsCubit>().loadNotifications(
      type: type,
      unreadOnly: unreadOnly,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<NotificationsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification History'),
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError) {
              return NotificationErrorWidget(
                message: state.statusMessage,
                onRetry: () => context.read<NotificationsCubit>().refresh(),
              );
            }
            final filteredNotifications = _searchQuery.isEmpty
                ? state.notifications
                : state.notifications
                .where((n) =>
            n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                n.body.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
            if (filteredNotifications.isEmpty) {
              return const NotificationEmptyState(
                message: 'No notifications found in history.',
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: NotificationSearchBar(
                    onChanged: _onSearchChanged,
                  ),
                ),
                NotificationFilterChips(
                  selectedType: state.appliedFilters?.type,
                  unreadOnly: state.appliedFilters?.unreadOnly ?? false,
                  onTypeChanged: (type) => _onFilterChanged(type: type?.name),
                  onUnreadChanged: (unread) => _onFilterChanged(unreadOnly: unread),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: NotificationList(
                    notifications: filteredNotifications,
                    onNotificationTap: (notification) {
                      Navigator.pushNamed(
                        context,
                        '/notifications/detail',
                        arguments: notification.id,
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
            );
          },
        ),
      ),
    );
  }
}