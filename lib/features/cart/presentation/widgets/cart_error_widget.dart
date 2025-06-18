import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';

class CartErrorWidget extends StatelessWidget {
  final Failure failure;
  final bool canRetry;
  final VoidCallback? onRetry;
  final VoidCallback? onContinueShopping;
  final VoidCallback? onContactSupport;
  final bool showErrorDetails;

  const CartErrorWidget({
    super.key,
    required this.failure,
    this.canRetry = false,
    this.onRetry,
    this.onContinueShopping,
    this.onContactSupport,
    this.showErrorDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    logger.logBusinessLogic(
      'cart_error_widget_displayed',
      'error_state',
      {
        'error_type': failure.runtimeType.toString(),
        'error_code': failure.code,
        'error_message': failure.message,
        'can_retry': canRetry,
        'show_details': showErrorDetails,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:20:50',
      },
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            _buildErrorIcon(context),

            const SizedBox(height: 24),

            // Error Title
            Text(
              _getErrorTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Error Message
            Text(
              _getErrorMessage(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Error Details (if enabled)
            if (showErrorDetails) ...[
              const SizedBox(height: 16),
              _buildErrorDetails(context),
            ],

            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(context, logger),

            // Support Section
            const SizedBox(height: 24),
            _buildSupportSection(context, logger),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon(BuildContext context) {
    IconData iconData;
    Color iconColor = Theme.of(context).colorScheme.error;

    switch (failure.runtimeType) {
      case NetworkFailure:
        iconData = Icons.wifi_off;
        break;
      case AuthFailure:
        iconData = Icons.lock_outline;
        break;
      case ValidationFailure:
        iconData = Icons.error_outline;
        break;
      case BusinessFailure:
        iconData = Icons.business_center_outlined;
        break;
      case ServerFailure:
        iconData = Icons.dns_outlined;
        break;
      default:
        iconData = Icons.warning_amber;
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 40,
        color: iconColor,
      ),
    );
  }

  Widget _buildErrorDetails(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Technical Details',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (failure.code != null) ...[
                Text(
                  'Error Code: ${failure.code}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                'Type: ${failure.runtimeType}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Message: ${failure.message}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
              if (failure.data != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Data: ${failure.data}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLogger logger) {
    return Column(
      children: [
        // Primary Action (Retry or Continue Shopping)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (canRetry && onRetry != null) {
                logger.logUserAction('cart_error_retry_pressed', {
                  'error_type': failure.runtimeType.toString(),
                  'error_code': failure.code,
                  'user': 'roshdology123',
                  'timestamp': '2025-06-18 14:20:50',
                });
                onRetry!();
              } else if (onContinueShopping != null) {
                logger.logUserAction('cart_error_continue_shopping_pressed', {
                  'error_type': failure.runtimeType.toString(),
                  'error_code': failure.code,
                  'user': 'roshdology123',
                  'timestamp': '2025-06-18 14:20:50',
                });
                onContinueShopping!();
              }
            },
            icon: Icon(canRetry ? Icons.refresh : Icons.store),
            label: Text(canRetry ? 'Try Again' : 'Continue Shopping'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Secondary Actions
        if (canRetry && onContinueShopping != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                logger.logUserAction('cart_error_continue_shopping_secondary_pressed', {
                  'error_type': failure.runtimeType.toString(),
                  'user': 'roshdology123',
                  'timestamp': '2025-06-18 14:20:50',
                });
                onContinueShopping!();
              },
              icon: const Icon(Icons.store),
              label: const Text('Continue Shopping'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context, AppLogger logger) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Need Help?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'If this problem persists, our support team is here to help.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: onContactSupport ?? () {
                  logger.logUserAction('cart_error_contact_support_pressed', {
                    'error_type': failure.runtimeType.toString(),
                    'error_code': failure.code,
                    'user': 'roshdology123',
                    'timestamp': '2025-06-18 14:20:50',
                  });
                  // Navigate to support or show contact options
                },
                icon: const Icon(Icons.support_agent, size: 18),
                label: const Text('Contact Support'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),

              TextButton.icon(
                onPressed: () {
                  logger.logUserAction('cart_error_faq_pressed', {
                    'error_type': failure.runtimeType.toString(),
                    'user': 'roshdology123',
                    'timestamp': '2025-06-18 14:20:50',
                  });
                  // Navigate to FAQ
                  Navigator.pushNamed(context, '/faq');
                },
                icon: const Icon(Icons.help_outline, size: 18),
                label: const Text('FAQ'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getErrorTitle() {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Connection Problem';
      case AuthFailure:
        return 'Authentication Required';
      case ValidationFailure:
        return 'Invalid Information';
      case BusinessFailure:
        if (failure.code == 'CART_EMPTY') {
          return 'Cart is Empty';
        } else if (failure.code == 'INSUFFICIENT_STOCK') {
          return 'Item Unavailable';
        }
        return 'Unable to Process';
      case ServerFailure:
        return 'Server Error';
      default:
        return 'Something Went Wrong';
    }
  }

  String _getErrorMessage() {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Please check your internet connection and try again.';
      case AuthFailure:
        return 'Please log in to continue with your cart.';
      case ValidationFailure:
        return 'Please check your information and try again.';
      case BusinessFailure:
        return failure.message;
      case ServerFailure:
        return 'Our servers are experiencing issues. Please try again in a moment.';
      default:
        return failure.message;
    }
  }
}