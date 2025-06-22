import 'package:flutter/material.dart';

/// Profile Action Card Widget for displaying actionable items
///
/// Features:
/// - Icon, title, and description
/// - Optional badge or trailing widget
/// - Customizable colors and styling
/// - Tap handling with proper visual feedback
class ProfileActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? badge;
  final Widget? trailing;
  final Color? color;
  final VoidCallback? onTap;
  final bool isDestructive;

  const ProfileActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.badge,
    this.trailing,
    this.color,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ??
        (isDestructive ? theme.colorScheme.error : theme.colorScheme.primary);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: effectiveColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDestructive ? effectiveColor : null,
                            ),
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          badge!,
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ] else if (onTap != null) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}