import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart.dart';

class CartActionButtons extends StatelessWidget {
  final Cart cart;
  final bool isLoading;
  final VoidCallback? onCheckout;
  final VoidCallback? onContinueShopping;
  final VoidCallback? onSaveForLater;
  final bool showSaveForLater;

  const CartActionButtons({
    super.key,
    required this.cart,
    required this.onCheckout,
    this.isLoading = false,
    this.onContinueShopping,
    this.onSaveForLater,
    this.showSaveForLater = false,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    logger.logBusinessLogic(
      'cart_action_buttons_rendered',
      'ui_component',
      {
        'cart_total': cart.summary.total,
        'items_count': cart.items.length,
        'is_valid_for_checkout': cart.isValidForCheckout,
        'is_loading': isLoading,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:18:15',
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cart validation warnings
        if (!cart.isValidForCheckout)
          _buildValidationWarnings(context),

        // Action buttons
        Row(
          children: [
            // Continue Shopping (optional)
            if (onContinueShopping != null)
              Expanded(
                flex: 1,
                child: _buildContinueShoppingButton(context, logger),
              ),

            if (onContinueShopping != null)
              const SizedBox(width: 12),

            // Checkout Button
            Expanded(
              flex: onContinueShopping != null ? 2 : 1,
              child: _buildCheckoutButton(context, logger),
            ),
          ],
        ),

        // Save for Later (optional)
        if (showSaveForLater && onSaveForLater != null) ...[
          const SizedBox(height: 8),
          _buildSaveForLaterButton(context, logger),
        ],

        // Security and Payment Info
        const SizedBox(height: 12),
        _buildSecurityInfo(context),
      ],
    );
  }

  Widget _buildValidationWarnings(BuildContext context) {
    final issues = cart.validationIssues;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Please fix the following issues:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...issues.map((issue) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                Expanded(
                  child: Text(
                    issue,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, AppLogger logger) {
    final isEnabled = !isLoading && cart.isValidForCheckout && cart.hasItems;

    return ElevatedButton(
      onPressed: isEnabled ? () {
        logger.logUserAction('checkout_button_pressed', {
          'cart_id': cart.id,
          'cart_total': cart.summary.total,
          'items_count': cart.items.length,
          'total_quantity': cart.summary.totalQuantity,
          'has_coupon': cart.summary.hasCouponApplied,
          'shipping_method': cart.summary.selectedShippingMethod,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:18:15',
        });
        onCheckout?.call();
      } : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined),
          const SizedBox(width: 8),
          Text(
            'Checkout • ${cart.summary.formattedTotal}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueShoppingButton(BuildContext context, AppLogger logger) {
    return OutlinedButton(
      onPressed: isLoading ? null : () {
        logger.logUserAction('continue_shopping_button_pressed', {
          'source': 'cart_action_buttons',
          'cart_items_count': cart.items.length,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:18:15',
        });
        onContinueShopping?.call();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store),
          SizedBox(width: 8),
          Text('Shop More'),
        ],
      ),
    );
  }

  Widget _buildSaveForLaterButton(BuildContext context, AppLogger logger) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isLoading ? null : () {
          logger.logUserAction('save_for_later_button_pressed', {
            'cart_id': cart.id,
            'items_count': cart.items.length,
            'user': 'roshdology123',
            'timestamp': '2025-06-18 14:18:15',
          });
          onSaveForLater?.call();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border),
            SizedBox(width: 8),
            Text('Save for Later'),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.security,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          'Secure Checkout',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.credit_card,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          'Multiple Payment Options',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}