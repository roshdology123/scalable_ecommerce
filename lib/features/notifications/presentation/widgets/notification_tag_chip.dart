import 'package:flutter/material.dart';

class NotificationTagChip extends StatelessWidget {
  final String tag;
  final bool selected;
  final Color? color;
  final VoidCallback? onTap;

  const NotificationTagChip({
    super.key,
    required this.tag,
    this.selected = false,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(tag),
      selected: selected,
      onSelected: (_) => onTap?.call(),
      selectedColor: color ?? Theme.of(context).colorScheme.secondary.withOpacity(0.18),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selected
            ? Theme.of(context).colorScheme.secondary
            : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}