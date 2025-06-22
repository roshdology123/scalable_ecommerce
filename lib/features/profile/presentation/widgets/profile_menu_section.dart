import 'package:flutter/material.dart';

import '../pages/profile_page.dart'; // For ProfileMenuItem

/// Profile Menu Section Widget
///
/// Groups related menu items under a section title
class ProfileMenuSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            // Menu Items
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Column(
                children: [
                  _buildMenuItem(theme, item),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(ThemeData theme, ProfileMenuItem item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (item.textColor ?? theme.colorScheme.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          item.icon,
          size: 20,
          color: item.textColor ?? theme.colorScheme.primary,
        ),
      ),
      title: Text(
        item.title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: item.textColor ?? theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: item.trailing ?? Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: item.onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}