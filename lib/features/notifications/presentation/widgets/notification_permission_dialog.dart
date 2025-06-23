import 'package:flutter/material.dart';

class NotificationPermissionDialog extends StatelessWidget {
  final VoidCallback? onAllow;
  final VoidCallback? onDeny;

  const NotificationPermissionDialog({
    super.key,
    this.onAllow,
    this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enable Notifications'),
      content: const Text(
        'To stay up to date, please allow notification permissions. '
            'We only send notifications relevant to your interests.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onDeny != null) onDeny!();
          },
          child: const Text('Not now'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onAllow != null) onAllow!();
          },
          child: const Text('Allow'),
        ),
      ],
    );
  }
}