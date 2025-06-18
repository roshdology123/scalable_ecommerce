import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';

class ShippingOptionsWidget extends StatelessWidget {
  final String? selectedMethod;
  final Function(String) onMethodChanged;
  final double currentTotal;
  final bool showEstimatedDelivery;

  const ShippingOptionsWidget({
    super.key,
    this.selectedMethod,
    required this.onMethodChanged,
    required this.currentTotal,
    this.showEstimatedDelivery = true,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    // Mock shipping options - in real app, get from API
    final shippingOptions = _getShippingOptions(currentTotal);

    logger.logBusinessLogic(
      'shipping_options_widget_rendered',
      'ui_component',
      {
        'selected_method': selectedMethod,
        'current_total': currentTotal,
        'available_options_count': shippingOptions.length,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:18:15',
      },
    );

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
              ],
            ),

            const SizedBox(height: 16),

            // Shipping Options
            ...shippingOptions.map((option) => _buildShippingOption(
              context,
              option,
              logger,
            )),

            // Free Shipping Progress (if applicable)
            if (currentTotal < 50.0)
              _buildFreeShippingProgress(context),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingOption(
      BuildContext context,
      Map<String, dynamic> option,
      AppLogger logger,
      ) {
    final isSelected = selectedMethod == option['id'];
    final cost = option['cost'] as double;
    final isFree = cost == 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          logger.logUserAction('shipping_method_selected', {
            'method_id': option['id'],
            'method_name': option['name'],
            'cost': cost,
            'delivery_days': option['deliveryDays'],
            'user': 'roshdology123',
            'timestamp': '2025-06-18 14:18:15',
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
                          ),
                        ),
                        Row(
                          children: [
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

  Widget _buildFreeShippingProgress(BuildContext context) {
    final amountNeeded = 50.0 - currentTotal;
    final progress = currentTotal / 50.0;

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