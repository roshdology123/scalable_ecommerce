import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_item_card.dart';

class CartItemList extends StatelessWidget {
  final Cart cart;
  final bool isUpdating;
  final Map<String, bool> itemsLoading;
  final Function(String itemId, int newQuantity) onQuantityChanged;
  final Function(String itemId, {String? color, String? size}) onVariantChanged;
  final Function(String itemId) onRemoveItem;
  final Function(CartItem item)? onItemTap;
  final bool showSectionHeaders;

  const CartItemList({
    super.key,
    required this.cart,
    required this.onQuantityChanged,
    required this.onVariantChanged,
    required this.onRemoveItem,
    this.isUpdating = false,
    this.itemsLoading = const {},
    this.onItemTap,
    this.showSectionHeaders = true,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    logger.logBusinessLogic(
      'cart_item_list_rendered',
      'ui_update',
      {
        'items_count': cart.items.length,
        'total_quantity': cart.summary.totalQuantity,
        'is_updating': isUpdating,
        'loading_items_count': itemsLoading.length,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:14:05',
      },
    );

    if (cart.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group items by status for better organization
    final availableItems = cart.availableItems;
    final unavailableItems = cart.unavailableItems;
    final outOfStockItems = cart.outOfStockItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available Items Section
        if (availableItems.isNotEmpty) ...[
          if (showSectionHeaders && (unavailableItems.isNotEmpty || outOfStockItems.isNotEmpty))
            _buildSectionHeader(context, 'Available Items', availableItems.length),

          ...availableItems.map((item) => _buildCartItemCard(context, item)),
        ],

        // Out of Stock Items Section
        if (outOfStockItems.isNotEmpty) ...[
          if (showSectionHeaders)
            _buildSectionHeader(context, 'Out of Stock', outOfStockItems.length),

          ...outOfStockItems.map((item) => _buildCartItemCard(context, item)),
        ],

        // Unavailable Items Section
        if (unavailableItems.isNotEmpty) ...[
          if (showSectionHeaders)
            _buildSectionHeader(context, 'No Longer Available', unavailableItems.length),

          ...unavailableItems.map((item) => _buildCartItemCard(context, item)),
        ],

        // Recently Added Items Highlight
        if (cart.recentlyAddedItems.isNotEmpty && showSectionHeaders) ...[
          const SizedBox(height: 16),
          _buildRecentlyAddedBanner(context, cart.recentlyAddedItems.length),
        ],

        // Price Changed Items Warning
        if (cart.priceChangedItems.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildPriceChangedBanner(context, cart.priceChangedItems.length),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    final isItemLoading = itemsLoading[item.id] ?? false;

    return CartItemCard(
      item: item,
      isLoading: isUpdating || isItemLoading,
      onQuantityChanged: (newQuantity) => onQuantityChanged(item.id, newQuantity),
      onVariantChanged: ({color, size}) => onVariantChanged(
        item.id,
        color: color,
        size: size,
      ),
      onRemove: () => onRemoveItem(item.id),
      onTap: onItemTap != null ? () => onItemTap!(item) : null,
      showVariantSelector: item.isAvailable && item.inStock,
      showRemoveButton: true,
    );
  }

  Widget _buildRecentlyAddedBanner(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.new_releases,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$count item${count == 1 ? '' : 's'} recently added to your cart',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChangedBanner(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.price_change,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$count item${count == 1 ? '' : 's'} ${count == 1 ? 'has' : 'have'} updated prices',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              AppLogger().logUserAction('price_changed_banner_refresh_pressed', {
                'changed_items_count': count,
                'user': 'roshdology123',
                'timestamp': '2025-06-18 14:14:05',
              });
              // In real app, trigger price validation
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}