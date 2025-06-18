import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final int minQuantity;
  final Function(int) onQuantityChanged;
  final bool isEnabled;
  final bool showLabel;
  final EdgeInsets? padding;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.maxQuantity = 999,
    this.minQuantity = 1,
    this.isEnabled = true,
    this.showLabel = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    return Container(
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Button
          _buildQuantityButton(
            context,
            icon: Icons.remove,
            onPressed: quantity > minQuantity && isEnabled
                ? () {
              final newQuantity = quantity - 1;
              logger.logUserAction('quantity_decreased', {
                'old_quantity': quantity,
                'new_quantity': newQuantity,
                'user': 'roshdology123',
                'timestamp': '2025-06-18 14:14:05',
              });
              onQuantityChanged(newQuantity);
            }
                : null,
          ),

          // Quantity Display
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  quantity.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (showLabel)
                  Text(
                    'qty',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Increase Button
          _buildQuantityButton(
            context,
            icon: Icons.add,
            onPressed: quantity < maxQuantity && isEnabled
                ? () {
              final newQuantity = quantity + 1;
              logger.logUserAction('quantity_increased', {
                'old_quantity': quantity,
                'new_quantity': newQuantity,
                'max_quantity': maxQuantity,
                'user': 'roshdology123',
                'timestamp': '2025-06-18 14:14:05',
              });
              onQuantityChanged(newQuantity);
            }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
      BuildContext context, {
        required IconData icon,
        required VoidCallback? onPressed,
      }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed != null
              ? Theme.of(context).colorScheme.surfaceVariant
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed != null
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
        ),
      ),
    );
  }
}