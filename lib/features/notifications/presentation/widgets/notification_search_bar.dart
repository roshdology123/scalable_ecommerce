import 'package:flutter/material.dart';

class NotificationSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? hint;

  const NotificationSearchBar({
    super.key,
    this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint ?? 'Search notifications...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      ),
      onChanged: onChanged,
    );
  }
}