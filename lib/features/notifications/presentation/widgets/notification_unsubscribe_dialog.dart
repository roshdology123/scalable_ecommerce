import 'package:flutter/material.dart';

class NotificationUnsubscribeDialog extends StatelessWidget {
  final String channelName;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const NotificationUnsubscribeDialog({
    super.key,
    required this.channelName,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unsubscribe?'),
      content: Text(
        'Are you sure you want to unsubscribe from "$channelName" notifications? '
            'You will stop receiving updates from this channel.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onCancel != null) onCancel!();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm!();
          },
          child: const Text('Unsubscribe'),
        ),
      ],
    );
  }
}