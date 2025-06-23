import 'package:flutter/material.dart';
import '../../domain/entities/notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final bool isDetail;
  final VoidCallback? onTap;
  final VoidCallback? onMarkRead;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    this.isDetail = false,
    this.onTap,
    this.onMarkRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final readColor = notification.isRead
        ? Colors.grey[100]
        : Theme.of(context).colorScheme.primary.withOpacity(0.06);

    return Card(
      color: readColor,
      elevation: isDetail ? 4 : 1,
      margin: isDetail
          ? const EdgeInsets.symmetric(horizontal: 0, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon, Type, Priority, Time
              Row(
                children: [
                  Text(
                    notification.typeIcon,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _typeLabel(notification.type),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (notification.isUrgent)
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text('URGENT',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        backgroundColor: Colors.redAccent,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  Text(
                    notification.displayTime,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Optional image
              if (notification.imageUrl != null && notification.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      notification.imageUrl!,
                      height: isDetail ? 160 : 96,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Text(
                notification.title,
                style: TextStyle(
                  fontSize: isDetail ? 19 : 16,
                  fontWeight: isDetail ? FontWeight.bold : FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (notification.body.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: isDetail ? 16 : 14,
                    color: Colors.black87,
                  ),
                ),
              ],
              // Display tags
              if (notification.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 6,
                    children: notification.tags
                        .map((tag) => Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.grey[200],
                    ))
                        .toList(),
                  ),
                ),
              // Extra info for detail view
              if (isDetail && notification.data.isNotEmpty) ...[
                const Divider(height: 24),
                ...notification.data.entries.map(
                      (e) => Row(
                    children: [
                      Text(
                        '${e.key}: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      Expanded(
                        child: Text(
                          '${e.value}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Action URL button
              if (isDetail && notification.actionUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open'),
                    onPressed: () {
                      // You can use url_launcher here to open the URL
                    },
                  ),
                ),
              // List item actions
              if (!isDetail)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!notification.isRead && onMarkRead != null)
                      IconButton(
                        icon: const Icon(Icons.mark_email_read_outlined),
                        tooltip: "Mark as read",
                        onPressed: onMarkRead,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: "Delete",
                        onPressed: onDelete,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.orderUpdate:
        return "Order Update";
      case NotificationType.promotion:
        return "Promotion";
      case NotificationType.cartAbandonment:
        return "Abandoned Cart";
      case NotificationType.newProduct:
        return "New Product";
      case NotificationType.priceAlert:
        return "Price Alert";
      case NotificationType.stockAlert:
        return "Stock Alert";
      case NotificationType.general:
      default:
        return "Notification";
    }
  }
}