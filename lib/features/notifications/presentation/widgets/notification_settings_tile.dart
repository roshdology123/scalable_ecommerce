import 'package:flutter/material.dart';

class NotificationSettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;

  const NotificationSettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}