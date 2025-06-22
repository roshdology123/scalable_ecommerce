import 'package:flutter/material.dart';

/// Preference Selection Tile Widget for choice-based settings
///
/// Features:
/// - Material 3 design with proper theming
/// - Modal bottom sheet for selection
/// - Current value display
/// - Customizable options list
class PreferenceSelectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String currentValue;
  final List<Map<String, String>> options;
  final ValueChanged<String>? onChanged;

  const PreferenceSelectionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.currentValue,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentOption = options.firstWhere(
          (option) => option['value'] == currentValue,
      orElse: () => {'value': currentValue, 'label': currentValue},
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                currentOption['label'] ?? currentValue,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        onTap: () => _showSelectionSheet(context),
      ),
    );
  }

  void _showSelectionSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Options
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option['value'] == currentValue;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.surfaceContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        option['label'] ?? option['value'] ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                      )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        onChanged?.call(option['value'] ?? '');
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}