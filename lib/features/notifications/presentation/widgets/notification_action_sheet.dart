import 'package:flutter/material.dart';

class NotificationActionSheet extends StatelessWidget {
  final List<NotificationActionSheetItem> actions;

  const NotificationActionSheet({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: actions
            .map((action) => ListTile(
          leading: Icon(action.icon, color: action.danger ? Colors.red : null),
          title: Text(
            action.label,
            style: TextStyle(
              color: action.danger ? Colors.red : null,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: action.onTap,
        ))
            .toList(),
      ),
    );
  }
}

class NotificationActionSheetItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  NotificationActionSheetItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });
}