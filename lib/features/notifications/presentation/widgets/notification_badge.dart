import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final Color? textColor;

  const NotificationBadge({
    super.key,
    required this.count,
    this.onTap,
    this.size = 24,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      // If no unread notifications, show only the icon without badge
      return IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: onTap,
        tooltip: 'No unread notifications',
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onTap,
          tooltip: 'View notifications',
        ),
        Positioned(
          right: 8,
          top: 10,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: color ?? Colors.red,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1.2),
              ),
              constraints: BoxConstraints(
                minWidth: size,
                minHeight: size - 10,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}