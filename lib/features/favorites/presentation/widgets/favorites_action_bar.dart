import 'package:flutter/material.dart';

class FavoritesActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onSelectAll;
  final VoidCallback? onClearSelection;
  final VoidCallback? onExitSelectionMode;

  const FavoritesActionBar({
    super.key,
    required this.selectedCount,
    this.onSelectAll,
    this.onClearSelection,
    this.onExitSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // Exit selection mode
          IconButton(
            onPressed: onExitSelectionMode,
            icon: const Icon(Icons.close),
            tooltip: 'Exit selection mode',
          ),

          const SizedBox(width: 8),

          // Selected count
          Expanded(
            child: Text(
              selectedCount == 0
                  ? 'Select items'
                  : '$selectedCount selected',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // Clear selection
          if (selectedCount > 0)
            TextButton(
              onPressed: onClearSelection,
              child: const Text('Clear'),
            ),

          const SizedBox(width: 8),

          // Select all
          TextButton(
            onPressed: onSelectAll,
            child: const Text('Select All'),
          ),
        ],
      ),
    );
  }
}