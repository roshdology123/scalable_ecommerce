import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/product.dart';
import 'product_rating_widget.dart';
import 'product_price_widget.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCartTap;
  final bool isFavorite;

  const ProductListItem({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCartTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[ProductListItem] Building list item for product ${product.id} (favorite: $isFavorite) for roshdology123 at 2025-06-22 11:58:45');

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: context.colorScheme.surfaceContainerHighest,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: context.colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: context.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    // Badge
                    if (product.primaryBadge != null)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getBadgeColor(product.primaryBadge!),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            product.primaryBadge!,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),

                    // Out of stock overlay
                    if (product.outOfStock)
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: Text(
                            'products.out_of_stock'.tr(),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Product information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    if (product.brand != null) ...[
                      Text(
                        product.brand!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],

                    // Title
                    Text(
                      product.title,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      product.getShortDescription(80),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Rating
                    ProductRatingWidget(
                      rating: product.rating,
                      size: 14,
                      showReviewCount: true,
                    ),
                    const SizedBox(height: 8),

                    // Price and stock
                    Row(
                      children: [
                        Expanded(
                          child: ProductPriceWidget(
                            price: product.price,
                            originalPrice: product.originalPrice,
                            discountPercentage: product.discountPercentage,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Stock info
                    _buildStockInfo(context),
                  ],
                ),
              ),

              // Action buttons - Enhanced with better styling and animations
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Enhanced Favorite button with animation and better styling
        Container(
          decoration: BoxDecoration(
            color: isFavorite
                ? Colors.red.withOpacity(0.1)
                : context.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isFavorite
                  ? Colors.red.withOpacity(0.3)
                  : context.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: isFavorite ? [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isFavorite),
                color: isFavorite ? Colors.red : context.colorScheme.onSurface,
                size: 22,
              ),
            ),
            onPressed: () {
              debugPrint('[ProductListItem] Favorite button tapped for product ${product.id} by roshdology123 at 2025-06-22 11:58:45');
              onFavoriteTap?.call();
            },
            tooltip: isFavorite
                ? 'products.remove_from_favorites'.tr()
                : 'products.add_to_favorites'.tr(),
            padding: const EdgeInsets.all(8),
          ),
        ),

        const SizedBox(height: 12),

        // Enhanced Add to cart button
        if (product.inStock)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.add_shopping_cart,
                size: 20,
              ),
              onPressed: () {
                debugPrint('[ProductListItem] Add to cart button tapped for product ${product.id} by roshdology123 at 2025-06-22 11:58:45');
                onAddToCartTap?.call();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: context.colorScheme.onPrimary,
                padding: const EdgeInsets.all(12),
              ),
              tooltip: 'products.add_to_cart'.tr(),
            ),
          )
        else
        // Out of stock button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.colorScheme.errorContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colorScheme.error.withOpacity(0.3),
              ),
            ),
            child: Icon(
              Icons.not_interested,
              color: context.colorScheme.error,
              size: 20,
            ),
          ),
      ],
    );
  }

  Widget _buildStockInfo(BuildContext context) {
    if (product.outOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: context.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 12,
              color: context.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 4),
            Text(
              'products.out_of_stock'.tr(),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (product.lowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_outlined,
              size: 12,
              color: Colors.orange.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              'products.low_stock'.tr(args: [product.stock.toString()]),
              style: context.textTheme.labelSmall?.copyWith(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 12,
              color: Colors.green.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              'products.in_stock'.tr(),
              style: context.textTheme.labelSmall?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'new':
        return Colors.green;
      case 'sale':
        return Colors.red;
      case 'featured':
        return Colors.blue;
      case 'limited':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}