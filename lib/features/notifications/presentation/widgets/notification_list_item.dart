import 'package:flutter/material.dart';

class NotificationListItem extends StatelessWidget {
  final String title;
  final String body;
  final bool unread;
  final String? timestamp;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NotificationListItem({
    super.key,
    required this.title,
    required this.body,
    this.unread = false,
    this.timestamp,
    this.icon,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: unread ? Theme.of(context).colorScheme.primary.withOpacity(0.06) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 2),
                child: Icon(icon, size: 26, color: unread ? Theme.of(context).primaryColor : Colors.grey[500]),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: unread ? FontWeight.bold : FontWeight.w500,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                      if (timestamp != null)
                        Text(
                          timestamp!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: 13.7,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ]
          ],
        ),
      ),
    );
  }
}