import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart_summary.dart';
import 'shipping_options_widget.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartSummary summary;
  final Function(String)? onShippingMethodChanged;
  final bool showShippingOptions;
  final bool showPromotionalMessages;
  final bool isExpanded;

  const CartSummaryWidget({
    super.key,
    required this.summary,
    this.onShippingMethodChanged,
    this.showShippingOptions = true,
    this.showPromotionalMessages = true,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    logger.logBusinessLogic(
      'cart_summary_widget_rendered',
      'ui_update',
      {
        'subtotal': summary.subtotal,
        'total': summary.total,
        'items_count': summary.totalItems,
        'has_coupon': summary.hasCouponApplied,
        'is_free_shipping': summary.isFreeShipping,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:14:05',
      },
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),

            const SizedBox(height: 16),

            // Promotional Messages
            if (showPromotionalMessages && summary.promotionalMessages.isNotEmpty)
              _buildPromotionalMessages(context),

            // Order Summary
            _buildOrderSummary(context),

            // Shipping Options
            if (showShippingOptions && onShippingMethodChanged != null)
              _buildShippingSection(context),

            const Divider(height: 24),

            // Total
            _buildTotal(context),

            // Cart Health Score (for debugging/admin)
            if (summary.cartHealthScore < 80)
              _buildHealthScore(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.receipt_long,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'Order Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (summary.totalItems > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${summary.totalItems} item${summary.totalItems == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPromotionalMessages(BuildContext context) {
    return Column(
      children: summary.promotionalMessages.map((message) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_offer,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Column(
      children: [
        // Subtotal
        _buildSummaryRow(
          context,
          'Subtotal',
          summary.formattedSubtotal,
        ),

        // Discounts
        if (summary.totalDiscount > 0)
          _buildSummaryRow(
            context,
            'Item Discounts',
            '-${summary.formatCurrency(summary.totalDiscount)}',
            color: Theme.of(context).colorScheme.error,
          ),

        // Coupon Discount
        if (summary.hasCouponApplied && summary.couponDiscount! > 0)
          _buildSummaryRow(
            context,
            'Coupon (${summary.appliedCouponCode})',
            '-${summary.formattedCouponDiscount}',
            color: Theme.of(context).colorScheme.error,
            subtitle: summary.couponDescription,
          ),

        // Tax
        if (summary.totalTax > 0)
          _buildSummaryRow(
            context,
            'Tax',
            summary.formattedTotalTax,
            subtitle: 'Rate: ${(summary.taxRate * 100).toStringAsFixed(2)}%',
          ),

        // Shipping
        _buildShippingRow(context),
      ],
    );
  }

  Widget _buildShippingRow(BuildContext context) {
    if (summary.isFreeShipping) {
      return _buildSummaryRow(
        context,
        'Shipping',
        'FREE',
        color: Theme.of(context).colorScheme.primary,
        subtitle: summary.shippingStatusMessage,
      );
    } else if (summary.shippingCost > 0) {
      return _buildSummaryRow(
        context,
        'Shipping',
        summary.formattedShippingCost,
        subtitle: summary.estimatedDeliveryMessage,
      );
    } else {
      return _buildSummaryRow(
        context,
        'Shipping',
        'Calculated at checkout',
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
    }
  }

  Widget _buildShippingSection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ShippingOptionsWidget(
          selectedMethod: summary.selectedShippingMethod,
          onMethodChanged: onShippingMethodChanged!,
          currentTotal: summary.subtotal,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
      BuildContext context,
      String label,
      String value, {
        Color? color,
        String? subtitle,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                summary.formattedTotal,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),

          // Savings Summary
          if (summary.totalSavings > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You Save',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  summary.formattedTotalSavings,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          // Quantity Summary
          if (summary.totalQuantity != summary.totalItems) ...[
            const SizedBox(height: 4),
            Text(
              '${summary.totalQuantity} items total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHealthScore(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cart health score: ${summary.cartHealthScore}/100. Some items may need attention.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}