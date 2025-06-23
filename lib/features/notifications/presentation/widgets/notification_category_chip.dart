import 'package:flutter/material.dart';

class NotificationCategoryChip extends StatelessWidget {
  final String category;
  final Color? color;
  final bool selected;
  final VoidCallback? onTap;

  const NotificationCategoryChip({
    super.key,
    required this.category,
    this.color,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(category),
      selected: selected,
      onSelected: (_) => onTap?.call(),
      selectedColor: color ?? Theme.of(context).colorScheme.primary.withOpacity(0.14),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}