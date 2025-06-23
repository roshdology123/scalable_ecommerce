import 'package:flutter/material.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? action;

  const NotificationSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          if (icon != null) const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          if (action != null) action!,
        ],
      ),
    );
  }
}