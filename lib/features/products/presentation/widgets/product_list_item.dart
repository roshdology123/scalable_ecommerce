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
                  color: context.colorScheme.surfaceVariant,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: context.colorScheme.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: context.colorScheme.surfaceVariant,
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
                    _buildStockInfo(context),
                  ],
                ),
              ),

              // Action buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favorite button
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: onFavoriteTap,
                  ),

                  // Add to cart button
                  if (product.inStock)
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: onAddToCartTap,
                      style: IconButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: context.colorScheme.onPrimary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockInfo(BuildContext context) {
    if (product.outOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: context.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'products.out_of_stock'.tr(),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onErrorContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (product.lowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'products.low_stock'.tr(args: [product.stock.toString()]),
          style: context.textTheme.labelSmall?.copyWith(
            color: Colors.orange.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'products.in_stock'.tr(),
          style: context.textTheme.labelSmall?.copyWith(
            color: Colors.green.shade700,
            fontWeight: FontWeight.w600,
          ),
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