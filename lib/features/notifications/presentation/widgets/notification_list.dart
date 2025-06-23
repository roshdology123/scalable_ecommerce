import 'package:flutter/material.dart';
import 'package:scalable_ecommerce/features/notifications/domain/entities/notification.dart';
import 'notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<AppNotification> notifications;
  final void Function(AppNotification notification)? onNotificationTap;
  final void Function(AppNotification notification)? onMarkRead;
  final void Function(AppNotification notification)? onDelete;

  const NotificationList({
    super.key,
    required this.notifications,
    this.onNotificationTap,
    this.onMarkRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationCard(
          notification: notification,
          onTap: onNotificationTap != null ? () => onNotificationTap!(notification) : null,
          onMarkRead: onMarkRead != null ? () => onMarkRead!(notification) : null,
          onDelete: onDelete != null ? () => onDelete!(notification) : null,
        );
      },
    );
  }
}