import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Profile Avatar Widget with fallback to initials
///
/// Features:
/// - Network image loading with caching
/// - Fallback to user initials
/// - Loading and error states
/// - Customizable size and onTap behavior
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = 60,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingAvatar(theme),
            errorWidget: (context, url, error) => _buildInitialsAvatar(theme),
          )
              : _buildInitialsAvatar(theme),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAvatar(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}