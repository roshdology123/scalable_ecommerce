import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart_summary.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../cubit/cart_summary_cubit.dart';
import '../cubit/cart_summary_state.dart';
import 'shipping_options_widget.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartSummary? initialSummary; // 🔥 CHANGED: Make optional
  final Function(String)? onShippingMethodChanged;
  final bool showShippingOptions;
  final bool showPromotionalMessages;
  final bool isExpanded;
  final bool isOptimistic;

  const CartSummaryWidget({
    super.key,
    this.initialSummary, // 🔥 CHANGED: Make optional
    this.onShippingMethodChanged,
    this.showShippingOptions = true,
    this.showPromotionalMessages = true,
    this.isExpanded = true,
    this.isOptimistic = false,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    // 🔥 LISTEN TO BOTH CART STATE AND CART SUMMARY STATE
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return BlocBuilder<CartSummaryCubit, CartSummaryState>(
          builder: (context, summaryState) {
            // 🔥 GET SUMMARY FROM STATE OR CART STATE OR INITIAL
            final summary = _getEffectiveSummary(cartState, summaryState);

            if (summary == null) {
              return const SizedBox.shrink(); // Nothing to show
            }

            final effectiveIsOptimistic = isOptimistic ||
                _getOptimisticState(cartState) ||
                _getSummaryOptimisticState(summaryState);

            logger.logBusinessLogic(
              'cart_summary_widget_rendered',
              'ui_update',
              {
                'subtotal': summary.subtotal,
                'total': summary.total,
                'items_count': summary.totalItems,
                'has_coupon': summary.hasCouponApplied,
                'is_free_shipping': summary.isFreeShipping,
                'selected_shipping_method': summary.selectedShippingMethod,
                'is_optimistic': effectiveIsOptimistic,
                'user': 'roshdology123',
                'timestamp': '2025-06-23 07:20:12', // 🔥 UPDATED TO CURRENT TIME
              },
            );

            return Card(
              elevation: 2,
              // 🔥 VISUAL FEEDBACK FOR OPTIMISTIC UPDATES
              color: effectiveIsOptimistic
                  ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.8)
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with optimistic indicator
                    _buildHeader(context, effectiveIsOptimistic, summary),

                    const SizedBox(height: 16),

                    // Promotional Messages
                    if (showPromotionalMessages &&
                        summary.promotionalMessages.isNotEmpty)
                      _buildPromotionalMessages(context, effectiveIsOptimistic, summary),

                    // Order Summary
                    _buildOrderSummary(context, effectiveIsOptimistic, summary),

                    // Shipping Options
                    if (showShippingOptions && onShippingMethodChanged != null)
                      _buildShippingSection(context, effectiveIsOptimistic, summary),

                    const Divider(height: 24),

                    // Total
                    _buildTotal(context, effectiveIsOptimistic, summary),

                    // Cart Health Score (for debugging/admin)
                    if (summary.cartHealthScore < 80) _buildHealthScore(context, summary),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🔥 GET EFFECTIVE SUMMARY FROM MULTIPLE SOURCES
  CartSummary? _getEffectiveSummary(CartState cartState, CartSummaryState summaryState) {
    // Priority: Summary state > Cart state > Initial summary
    final summaryFromState = summaryState.summary;
    if (summaryFromState != null) {
      return summaryFromState;
    }

    final cartFromState = cartState.cart;
    if (cartFromState != null) {
      return cartFromState.summary;
    }

    return initialSummary;
  }

  // 🔥 HELPER METHOD: Extract optimistic state from CartState
  bool _getOptimisticState(CartState state) {
    return state.whenOrNull(
      loaded: (cart, _, __, ___, isOptimistic, ____, _____, ______) =>
      isOptimistic,
      empty: (_, isOptimistic, __) => isOptimistic,
    ) ??
        false;
  }

  // 🔥 HELPER METHOD: Extract optimistic state from CartSummaryState
  bool _getSummaryOptimisticState(CartSummaryState state) {
    return state.whenOrNull(
      loaded: (_, isCalculating, __, isOptimistic, ___, ____, _____, ______) =>
      isCalculating || isOptimistic,
      calculating: (_, __, ___) => true,
    ) ??
        false;
  }

  Widget _buildHeader(BuildContext context, bool isOptimisticUpdate, CartSummary summary) {
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
            color: isOptimisticUpdate
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                : null,
          ),
        ),
        if (isOptimisticUpdate) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (summary.totalItems > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOptimisticUpdate
                  ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7)
                  : Theme.of(context).colorScheme.primaryContainer,
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

  Widget _buildPromotionalMessages(
      BuildContext context, bool isOptimisticUpdate, CartSummary summary) {
    return Column(
      children: summary.promotionalMessages.map((message) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isOptimisticUpdate
                ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7)
                : Theme.of(context).colorScheme.primaryContainer,
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

  Widget _buildOrderSummary(BuildContext context, bool isOptimisticUpdate, CartSummary summary) {
    return Column(
      children: [
        // Subtotal
        _buildSummaryRow(
          context,
          'Subtotal',
          summary.formattedSubtotal,
          isOptimisticUpdate: isOptimisticUpdate,
        ),

        // Discounts
        if (summary.totalDiscount > 0)
          _buildSummaryRow(
            context,
            'Item Discounts',
            '-${summary.formatCurrency(summary.totalDiscount)}',
            color: Theme.of(context).colorScheme.error,
            isOptimisticUpdate: isOptimisticUpdate,
          ),

        // Coupon Discount
        if (summary.hasCouponApplied && summary.couponDiscount! > 0)
          _buildSummaryRow(
            context,
            'Coupon (${summary.appliedCouponCode})',
            '-${summary.formattedCouponDiscount}',
            color: Theme.of(context).colorScheme.error,
            subtitle: summary.couponDescription,
            isOptimisticUpdate: isOptimisticUpdate,
          ),

        // Tax
        if (summary.totalTax > 0)
          _buildSummaryRow(
            context,
            'Tax',
            summary.formattedTotalTax,
            subtitle: 'Rate: ${(summary.taxRate * 100).toStringAsFixed(2)}%',
            isOptimisticUpdate: isOptimisticUpdate,
          ),

        // Shipping
        _buildShippingRow(context, isOptimisticUpdate, summary),
      ],
    );
  }

  Widget _buildShippingRow(BuildContext context, bool isOptimisticUpdate, CartSummary summary) {
    if (summary.isFreeShipping) {
      return _buildSummaryRow(
        context,
        'Shipping',
        'FREE',
        color: Theme.of(context).colorScheme.primary,
        subtitle: summary.shippingStatusMessage,
        isOptimisticUpdate: isOptimisticUpdate,
      );
    } else if (summary.shippingCost > 0) {
      return _buildSummaryRow(
        context,
        'Shipping',
        summary.formattedShippingCost,
        subtitle: summary.estimatedDeliveryMessage,
        isOptimisticUpdate: isOptimisticUpdate,
      );
    } else {
      return _buildSummaryRow(
        context,
        'Shipping',
        'Calculated at checkout',
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        isOptimisticUpdate: isOptimisticUpdate,
      );
    }
  }

  Widget _buildShippingSection(BuildContext context, bool isOptimisticUpdate, CartSummary summary) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ShippingOptionsWidget(
          selectedMethod: summary.selectedShippingMethod, // 🔥 USE CURRENT SUMMARY
          onMethodChanged: onShippingMethodChanged!,
          currentTotal: summary.subtotal,
          isOptimistic: isOptimisticUpdate,
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
        bool isOptimisticUpdate = false,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isOptimisticUpdate
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                      : null,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isOptimisticUpdate && color != null
                      ? color.withOpacity(0.7)
                      : color,
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

  Widget _buildTotal(BuildContext context, bool isOptimisticUpdate, CartSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOptimisticUpdate
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7)
            : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: isOptimisticUpdate
            ? Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          width: 1,
        )
            : null,
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
              Row(
                children: [
                  Text(
                    summary.formattedTotal,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  if (isOptimisticUpdate) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ],
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

  Widget _buildHealthScore(BuildContext context, CartSummary summary) {
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