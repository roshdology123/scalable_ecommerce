import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/profile.dart';
import 'profile_avatar.dart';

/// Profile Header Widget displaying user's basic information
///
/// Shows:
/// - Profile avatar with edit capability
/// - User's full name and username
/// - Email address with verification status
/// - Profile completion indicator
/// - Member since information
class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Avatar and Edit Button
            Row(
              children: [
                ProfileAvatar(
                  imageUrl: profile.profileImageUrl,
                  initials: profile.initials,
                  size: 80,
                  onTap: () => _showImageOptions(context),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      Text(
                        profile.fullName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Username - use actual username from profile
                      Text(
                        '@${profile.id}', // Using ID as username for FakeStore API users
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Email with verification status
                      Row(
                        children: [
                          Icon(
                            profile.isEmailVerified
                                ? Icons.verified_outlined
                                : Icons.email_outlined,
                            size: 16,
                            color: profile.isEmailVerified
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              profile.email,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Edit Button
                IconButton(
                  onPressed: onEditPressed ?? () => context.push('/profile/edit'),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Profile Completion and Member Info
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.account_circle_outlined,
                    title: 'Profile Complete',
                    value: '${profile.profileCompletionPercentage.toStringAsFixed(0)}%',
                    color: _getCompletionColor(theme, profile.profileCompletionPercentage),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.calendar_today_outlined,
                    title: 'Member Since',
                    value: profile.membershipDuration,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            // Bio Section (if available)
            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
                ),
                child: Text(
                  profile.bio!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Last Updated Info
            const SizedBox(height: 12),
            Text(
              'Last updated: ${_formatDate(profile.updatedAt)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
      }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getCompletionColor(ThemeData theme, double percentage) {
    if (percentage >= 80) return theme.colorScheme.tertiary;
    if (percentage >= 60) return theme.colorScheme.secondary;
    return theme.colorScheme.error;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showImageOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Profile Photo',
              style: theme.textTheme.headlineSmall,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  context,
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    // Implement camera functionality
                  },
                ),
                _buildImageOption(
                  context,
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    // Implement gallery functionality
                  },
                ),
                if (profile.profileImageUrl != null)
                  _buildImageOption(
                    context,
                    icon: Icons.delete_outline,
                    label: 'Remove',
                    color: theme.colorScheme.error,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement remove functionality
                    },
                  ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
        Color? color,
      }) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: effectiveColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: effectiveColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: effectiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}