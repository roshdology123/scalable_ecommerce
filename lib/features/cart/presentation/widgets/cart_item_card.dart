import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart_item.dart';
import 'quantity_selector.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isLoading;
  final Function(int) onQuantityChanged;
  final Function({String? color, String? size}) onVariantChanged;
  final VoidCallback onRemove;
  final VoidCallback? onTap;
  final bool showVariantSelector;
  final bool showRemoveButton;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onVariantChanged,
    required this.onRemove,
    this.isLoading = false,
    this.onTap,
    this.showVariantSelector = true,
    this.showRemoveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            logger.logUserAction('cart_item_tapped', {
              'item_id': item.id,
              'product_id': item.productId,
              'user': 'roshdology123',
              'timestamp': '2025-06-18 14:14:05',
            });
            onTap!();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  _buildProductImage(context),

                  const SizedBox(width: 16),

                  // Product Details
                  Expanded(
                    child: _buildProductDetails(context),
                  ),

                  // Remove Button
                  if (showRemoveButton)
                    _buildRemoveButton(context, logger),
                ],
              ),

              const SizedBox(height: 16),

              // Variants and Quantity Controls
              _buildControlsSection(context, logger),

              // Price and Savings
              _buildPriceSection(context),

              // Status Indicators
              if (!item.isAvailable || !item.inStock || item.priceChanged)
                _buildStatusIndicators(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: item.productImage,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.broken_image,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Title
        Text(
          item.productTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Brand
        if (item.brand != null)
          Text(
            item.brand!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

        const SizedBox(height: 4),

        // SKU
        if (item.sku != null)
          Text(
            'SKU: ${item.sku}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),

        // Variants Display
        if (item.hasVariantsSelected) ...[
          const SizedBox(height: 8),
          _buildVariantsDisplay(context),
        ],
      ],
    );
  }

  Widget _buildVariantsDisplay(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: item.selectedVariants.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${_capitalizeFirst(entry.key)}: ${entry.value}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRemoveButton(BuildContext context, AppLogger logger) {
    return IconButton(
      onPressed: isLoading ? null : () {
        logger.logUserAction('cart_item_remove_button_pressed', {
          'item_id': item.id,
          'product_id': item.productId,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:14:05',
        });
        onRemove();
      },
      icon: Icon(
        Icons.close,
        color: Theme.of(context).colorScheme.error,
        size: 20,
      ),
      constraints: const BoxConstraints(
        minWidth: 24,
        minHeight: 24,
      ),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildControlsSection(BuildContext context, AppLogger logger) {
    return Row(
      children: [
        // Quantity Selector
        QuantitySelector(
          quantity: item.quantity,
          maxQuantity: item.maxQuantity,
          onQuantityChanged: (newQuantity) {
            logger.logUserAction('cart_item_quantity_changed', {
              'item_id': item.id,
              'old_quantity': item.quantity,
              'new_quantity': newQuantity,
              'user': 'roshdology123',
              'timestamp': '2025-06-18 14:14:05',
            });
            onQuantityChanged(newQuantity);
          },
          isEnabled: !isLoading && item.isAvailable && item.inStock,
        ),

        const Spacer(),

        // Variant Selectors
        if (showVariantSelector && item.hasVariantsSelected)
          _buildVariantSelectors(context, logger),
      ],
    );
  }

  Widget _buildVariantSelectors(BuildContext context, AppLogger logger) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color Selector
        if (item.selectedColor != null)
          _buildColorSelector(context, logger),

        if (item.selectedColor != null && item.selectedSize != null)
          const SizedBox(width: 8),

        // Size Selector
        if (item.selectedSize != null)
          _buildSizeSelector(context, logger),
      ],
    );
  }

  Widget _buildColorSelector(BuildContext context, AppLogger logger) {
    return InkWell(
      onTap: isLoading ? null : () {
        logger.logUserAction('cart_item_color_selector_tapped', {
          'item_id': item.id,
          'current_color': item.selectedColor,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:14:05',
        });
        _showColorPicker(context, logger);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getColorFromName(item.selectedColor!),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.selectedColor!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelector(BuildContext context, AppLogger logger) {
    return InkWell(
      onTap: isLoading ? null : () {
        logger.logUserAction('cart_item_size_selector_tapped', {
          'item_id': item.id,
          'current_size': item.selectedSize,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:14:05',
        });
        _showSizePicker(context, logger);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Size: ${item.selectedSize}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        Row(
          children: [
            // Current Price
            Text(
              item.formattedPrice,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            // Original Price (if different)
            if (item.isOnSale) ...[
              const SizedBox(width: 8),
              Text(
                item.formattedOriginalPrice,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],

            const Spacer(),

            // Total Price for Quantity
            Text(
              item.formattedTotalPrice,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // Savings Display
        if (item.isOnSale) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item.effectiveDiscountPercentage.toStringAsFixed(0)}% OFF',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Save ${item.totalSavings.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicators(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        if (!item.isAvailable)
          _buildStatusChip(
            context,
            'Not Available',
            Icons.error_outline,
            Theme.of(context).colorScheme.error,
          ),

        if (!item.inStock)
          _buildStatusChip(
            context,
            'Out of Stock',
            Icons.inventory_2_outlined,
            Theme.of(context).colorScheme.error,
          ),

        if (item.priceChanged)
          _buildStatusChip(
            context,
            'Price Updated',
            Icons.price_change_outlined,
            Theme.of(context).colorScheme.tertiary,
          ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String label, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, AppLogger logger) {
    // Mock color options - in real app, get from product data
    final colors = ['Red', 'Blue', 'Black', 'White', 'Green'];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Color',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((color) {
                final isSelected = color == item.selectedColor;
                return GestureDetector(
                  onTap: () {
                    logger.logUserAction('cart_item_color_changed', {
                      'item_id': item.id,
                      'old_color': item.selectedColor,
                      'new_color': color,
                      'user': 'roshdology123',
                      'timestamp': '2025-06-18 14:14:05',
                    });
                    Navigator.pop(context);
                    onVariantChanged(color: color);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getColorFromName(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                      Icons.check,
                      color: _getContrastColor(_getColorFromName(color)),
                    )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSizePicker(BuildContext context, AppLogger logger) {
    // Mock size options - in real app, get from product data
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Size',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sizes.map((size) {
                final isSelected = size == item.selectedSize;
                return GestureDetector(
                  onTap: () {
                    logger.logUserAction('cart_item_size_changed', {
                      'item_id': item.id,
                      'old_size': item.selectedSize,
                      'new_size': size,
                      'user': 'roshdology123',
                      'timestamp': '2025-06-18 14:14:05',
                    });
                    Navigator.pop(context);
                    onVariantChanged(size: size);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      size,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if white or black text should be used
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}