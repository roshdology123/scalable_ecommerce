import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_shimmer_loading.dart';
import '../widgets/notification_error_widget.dart';

class NotificationDetailPage extends StatelessWidget {
  final String notificationId;

  const NotificationDetailPage({
    super.key,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch the notification on page open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().getNotificationById(notificationId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: () {
              context.read<NotificationsCubit>().deleteNotification(notificationId);
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark as Read',
            onPressed: () {
              context.read<NotificationsCubit>().markAsRead(notificationId);
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const NotificationShimmerLoading();
          }
          if (state.hasError) {
            return NotificationErrorWidget(
              message: state.statusMessage,
              onRetry: () =>
                  context.read<NotificationsCubit>().getNotificationById(notificationId),
            );
          }

          AppNotification? notification = state.notifications
              .where((n) => n.id == notificationId)
              .cast<AppNotification?>()
              .firstWhere(
                (n) => true,
            orElse: () => state.selectedNotification,
          );
          if (notification == null) {
            return const Center(child: Text('Notification not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: NotificationCard(
              notification: notification,
              isDetail: true,
              onMarkRead: () => context.read<NotificationsCubit>().markAsRead(notification.id),
              onDelete: () {
                context.read<NotificationsCubit>().deleteNotification(notification.id);
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}