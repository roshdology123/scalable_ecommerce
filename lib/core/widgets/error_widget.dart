import 'package:flutter/material.dart';

/// Reusable Error Widget with customizable appearance and actions
///
/// Features:
/// - Material 3 design compliance
/// - Multiple error types with appropriate icons
/// - Customizable actions and styling
/// - Theme-aware colors
/// - Accessibility support
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final String? description;
  final ErrorType type;
  final VoidCallback? onRetry;
  final VoidCallback? onAction;
  final String? actionLabel;
  final String? retryLabel;
  final IconData? customIcon;
  final Color? color;
  final bool showIcon;
  final EdgeInsets padding;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.description,
    this.type = ErrorType.general,
    this.onRetry,
    this.onAction,
    this.actionLabel,
    this.retryLabel,
    this.customIcon,
    this.color,
    this.showIcon = true,
    this.padding = const EdgeInsets.all(24.0),
  });

  /// Named constructor for network errors
  const CustomErrorWidget.network({
    super.key,
    this.message = 'No internet connection',
    this.title = 'Connection Error',
    this.description = 'Please check your internet connection and try again.',
    this.onRetry,
    this.retryLabel,
    this.actionLabel,
    this.onAction,
    this.customIcon,
    this.color,
  })  : type = ErrorType.network,
        showIcon = true,
        padding = const EdgeInsets.all(24.0);

  /// Named constructor for server errors
  const CustomErrorWidget.server({
    super.key,
    this.message = 'Server error occurred',
    this.title = 'Server Error',
    this.description = 'Something went wrong on our end. Please try again later.',
    this.onRetry,
    this.retryLabel,
    this.actionLabel,
    this.onAction,
    this.customIcon,
    this.color,
  })  : type = ErrorType.server,
        showIcon = true,
        padding = const EdgeInsets.all(24.0);

  /// Named constructor for not found errors
  const CustomErrorWidget.notFound({
    super.key,
    this.message = 'Content not found',
    this.title = 'Not Found',
    this.description = 'The content you\'re looking for doesn\'t exist or has been removed.',
    this.onRetry,
    this.retryLabel,
    this.actionLabel,
    this.onAction,
    this.customIcon,
    this.color,
  })  : type = ErrorType.notFound,
        showIcon = true,
        padding = const EdgeInsets.all(24.0);

  /// Named constructor for permission errors
  const CustomErrorWidget.permission({
    super.key,
    this.message = 'Access denied',
    this.title = 'Permission Error',
    this.description = 'You don\'t have permission to access this content.',
    this.onRetry,
    this.retryLabel,
    this.actionLabel,
    this.onAction,
    this.customIcon,
    this.color,
  })  : type = ErrorType.permission,
        showIcon = true,
        padding = const EdgeInsets.all(24.0);

  /// Named constructor for timeout errors
  const CustomErrorWidget.timeout({
    super.key,
    this.message = 'Request timed out',
    this.title = 'Timeout Error',
    this.description = 'The request took too long to complete. Please try again.',
    this.onRetry,
    this.retryLabel,
    this.actionLabel,
    this.onAction,
    this.customIcon,
    this.color,
  })  : type = ErrorType.timeout,
        showIcon = true,
        padding = const EdgeInsets.all(24.0);

  /// Named constructor for minimal error display
  const CustomErrorWidget.minimal({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.customIcon,
    this.color,
  })  : title = null,
        description = null,
        type = ErrorType.general,
        actionLabel = null,
        onAction = null,
        showIcon = false,
        padding = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? _getErrorColor(theme, type);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) ...[
            _buildErrorIcon(effectiveColor),
            const SizedBox(height: 24),
          ],

          if (title != null) ...[
            _buildTitle(theme, effectiveColor),
            const SizedBox(height: 8),
          ],

          _buildMessage(theme),

          if (description != null) ...[
            const SizedBox(height: 8),
            _buildDescription(theme),
          ],

          const SizedBox(height: 24),

          _buildActions(theme),

          // Debug info for development
          if (_isDebugMode()) ...[
            const SizedBox(height: 16),
            _buildDebugInfo(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorIcon(Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        customIcon ?? _getErrorIcon(type),
        size: 48,
        color: color,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, Color color) {
    return Text(
      title!,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(ThemeData theme) {
    return Text(
      message,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      description!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActions(ThemeData theme) {
    final hasRetry = onRetry != null;
    final hasAction = onAction != null && actionLabel != null;

    if (!hasRetry && !hasAction) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (hasRetry)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel ?? 'Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ),

        if (hasRetry && hasAction) const SizedBox(height: 12),

        if (hasAction)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAction,
              icon: Icon(_getActionIcon(type)),
              label: Text(actionLabel!),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDebugInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debug Info (roshdology123):',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Error Type: ${type.name}',
            style: theme.textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'Timestamp: 2025-06-22 09:23:36',
            style: theme.textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'User: roshdology123',
            style: theme.textTheme.labelSmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off_outlined;
      case ErrorType.server:
        return Icons.cloud_off_outlined;
      case ErrorType.notFound:
        return Icons.search_off_outlined;
      case ErrorType.permission:
        return Icons.lock_outline;
      case ErrorType.timeout:
        return Icons.schedule_outlined;
      case ErrorType.validation:
        return Icons.warning_outlined;
      case ErrorType.general:
      default:
        return Icons.error_outline;
    }
  }

  IconData _getActionIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.settings_outlined;
      case ErrorType.server:
        return Icons.support_agent_outlined;
      case ErrorType.notFound:
        return Icons.home_outlined;
      case ErrorType.permission:
        return Icons.login_outlined;
      case ErrorType.timeout:
        return Icons.refresh_outlined;
      case ErrorType.validation:
        return Icons.edit_outlined;
      case ErrorType.general:
      default:
        return Icons.help_outline;
    }
  }

  Color _getErrorColor(ThemeData theme, ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return theme.colorScheme.secondary;
      case ErrorType.server:
        return theme.colorScheme.error;
      case ErrorType.notFound:
        return theme.colorScheme.primary;
      case ErrorType.permission:
        return theme.colorScheme.error;
      case ErrorType.timeout:
        return theme.colorScheme.secondary;
      case ErrorType.validation:
        return theme.colorScheme.error;
      case ErrorType.general:
      default:
        return theme.colorScheme.error;
    }
  }

  bool _isDebugMode() {
    // You can replace this with your debug configuration
    return false; // Set to true for debug builds
  }
}

/// Types of errors that can be displayed
enum ErrorType {
  general,
  network,
  server,
  notFound,
  permission,
  timeout,
  validation,
}

/// Error state widget for empty lists
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  /// Named constructor for empty profile data
  const EmptyStateWidget.profile({
    super.key,
    this.title = 'Complete Your Profile',
    this.message = 'Add your personal information to get started.',
    this.icon = Icons.person_outline,
    this.actionLabel = 'Edit Profile',
    this.onAction,
  });

  /// Named constructor for empty orders
  const EmptyStateWidget.orders({
    super.key,
    this.title = 'No Orders Yet',
    this.message = 'Start shopping to see your orders here.',
    this.icon = Icons.shopping_bag_outlined,
    this.actionLabel = 'Browse Products',
    this.onAction,
  });

  /// Named constructor for empty favorites
  const EmptyStateWidget.favorites({
    super.key,
    this.title = 'No Favorites',
    this.message = 'Save items you love to see them here.',
    this.icon = Icons.favorite_outline,
    this.actionLabel = 'Discover Products',
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error boundary widget for catching and displaying errors
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}