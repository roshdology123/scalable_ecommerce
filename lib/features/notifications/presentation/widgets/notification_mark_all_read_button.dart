import 'package:flutter/material.dart';

class NotificationMarkAllReadButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool enabled;

  const NotificationMarkAllReadButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mark_email_read_rounded),
      tooltip: "Mark all as read",
      onPressed: enabled ? onPressed : null,
      color: enabled ? Theme.of(context).primaryColor : Colors.grey,
    );
  }
}