import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class ShippingOptionsWidget extends StatelessWidget {
  final String? selectedMethod;
  final Function(String) onMethodChanged;
  final double currentTotal;
  final bool showEstimatedDelivery;
  final bool isOptimistic; // 🔥 ADD THIS FLAG

  const ShippingOptionsWidget({
    super.key,
    this.selectedMethod,
    required this.onMethodChanged,
    required this.currentTotal,
    this.showEstimatedDelivery = true,
    this.isOptimistic = false, // 🔥 ADD THIS FLAG
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    // 🔥 LISTEN TO CART STATE TO REBUILD WHEN NEEDED
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // Get current total from cart state if available, otherwise use parameter
        final effectiveTotal = state.cart?.summary.total ?? currentTotal;
        final effectiveSelectedMethod = selectedMethod ?? state.cart?.summary.selectedShippingMethod;

        // Get shipping options based on current total
        final shippingOptions = _getShippingOptions(effectiveTotal);

        logger.logBusinessLogic(
          'shipping_options_widget_rendered',
          'ui_component',
          {
            'selected_method': effectiveSelectedMethod,
            'current_total': effectiveTotal,
            'available_options_count': shippingOptions.length,
            'is_optimistic': isOptimistic,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 07:05:50', // 🔥 UPDATED TIMESTAMP
          },
        );

        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with optimistic indicator
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Shipping Options',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // 🔥 OPTIMISTIC UPDATE INDICATOR
                    if (isOptimistic || state.isOptimistic) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Shipping Options
                ...shippingOptions.map((option) => _buildShippingOption(
                  context,
                  option,
                  effectiveSelectedMethod,
                  effectiveTotal,
                  state.isOptimistic || isOptimistic,
                  logger,
                )),

                // Free Shipping Progress (if applicable)
                if (effectiveTotal < 50.0)
                  _buildFreeShippingProgress(context, effectiveTotal),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShippingOption(
      BuildContext context,
      Map<String, dynamic> option,
      String? currentSelectedMethod,
      double total,
      bool isOptimisticUpdate,
      AppLogger logger,
      ) {
    final isSelected = currentSelectedMethod == option['id'];
    final cost = option['cost'] as double;
    final isFree = cost == 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: isOptimisticUpdate ? null : () {
          // 🔥 OPTIMISTIC UPDATE: Update immediately in UI
          logger.logUserAction('shipping_method_selected', {
            'method_id': option['id'],
            'method_name': option['name'],
            'cost': cost,
            'delivery_days': option['deliveryDays'],
            'previous_method': currentSelectedMethod,
            'total_before': total,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 07:05:50', // 🔥 UPDATED TIMESTAMP
          });

          onMethodChanged(option['id']);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
                : null,
            // 🔥 VISUAL FEEDBACK FOR OPTIMISTIC UPDATES
            boxShadow: isOptimisticUpdate && isSelected
                ? [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              // Radio Button
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                child: isSelected
                    ? Icon(
                  Icons.check,
                  size: 12,
                  color: Theme.of(context).colorScheme.onPrimary,
                )
                    : null,
              ),

              const SizedBox(width: 12),

              // Shipping Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option['name'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            // 🔥 DIMMED TEXT DURING OPTIMISTIC UPDATES
                            color: isOptimisticUpdate
                                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                                : null,
                          ),
                        ),
                        Row(
                          children: [
                            // 🔥 PENDING INDICATOR FOR SELECTED OPTIMISTIC OPTION
                            if (isOptimisticUpdate && isSelected) ...[
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (isFree) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'FREE',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Text(
                                '\$${cost.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isOptimisticUpdate
                                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                                      : null,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),

                    if (showEstimatedDelivery && option['deliveryDays'] != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getDeliveryText(option['deliveryDays']),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (option['description'] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        option['description'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreeShippingProgress(BuildContext context, double total) {
    final amountNeeded = 50.0 - total;
    final progress = total / 50.0;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping,
                size: 16,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 6),
              Text(
                'Add \$${amountNeeded.toStringAsFixed(2)} more for FREE shipping!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getShippingOptions(double total) {
    return [
      {
        'id': 'standard',
        'name': 'Standard Shipping',
        'cost': total >= 50.0 ? 0.0 : 5.99,
        'deliveryDays': 5,
        'description': 'Free on orders over \$50',
      },
      {
        'id': 'express',
        'name': 'Express Shipping',
        'cost': 12.99,
        'deliveryDays': 2,
        'description': 'Faster delivery',
      },
      {
        'id': 'overnight',
        'name': 'Overnight Delivery',
        'cost': 24.99,
        'deliveryDays': 1,
        'description': 'Next business day',
      },
      {
        'id': 'pickup',
        'name': 'Store Pickup',
        'cost': 0.0,
        'deliveryDays': 0,
        'description': 'Ready in 2 hours',
      },
    ];
  }

  String _getDeliveryText(int days) {
    switch (days) {
      case 0:
        return 'Same day pickup';
      case 1:
        return 'Next business day';
      case 2:
        return '2 business days';
      default:
        return '$days business days';
    }
  }
}