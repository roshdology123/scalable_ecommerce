import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/product.dart';
import 'product_rating_widget.dart';
import 'product_price_widget.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCartTap;
  final bool isFavorite;
  final bool showFavoriteButton;
  final bool showAddToCartButton;
  final double? width;
  final double? height;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCartTap,
    this.isFavorite = false,
    this.showFavoriteButton = true,
    this.showAddToCartButton = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[ProductCard] Building card for product ${product.id} (favorite: $isFavorite) for roshdology123 at 2025-06-22 11:57:28');

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with badges
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Product image
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
                          size: 48,
                        ),
                      ),
                    ),

                    // Gradient overlay for badges
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Badges
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildBadges(context),
                    ),

                    // Favorite button with enhanced animation
                    if (showFavoriteButton)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildFavoriteButton(context),
                      ),

                    // Stock overlay
                    if (product.outOfStock)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: context.colorScheme.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'products.out_of_stock'.tr(),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onError,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Product information
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                      ],

                      // Product title
                      Text(
                        product.title,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Rating
                      ProductRatingWidget(
                        rating: product.rating,
                        size: 12,
                        showReviewCount: false,
                      ),
                      const Spacer(),

                      // Price and add to cart
                      Row(
                        children: [
                          Expanded(
                            child: ProductPriceWidget(
                              price: product.price,
                              originalPrice: product.originalPrice,
                              discountPercentage: product.discountPercentage,
                              compact: true,
                            ),
                          ),
                          if (showAddToCartButton && product.inStock) ...[
                            const SizedBox(width: 8),
                            _buildAddToCartButton(context),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadges(BuildContext context) {
    final primaryBadge = product.primaryBadge;
    if (primaryBadge == null) return const SizedBox.shrink();

    Color badgeColor;
    switch (primaryBadge.toLowerCase()) {
      case 'new':
        badgeColor = Colors.green;
        break;
      case 'sale':
        badgeColor = Colors.red;
        break;
      case 'featured':
        badgeColor = context.colorScheme.primary;
        break;
      case 'limited':
        badgeColor = Colors.orange;
        break;
      default:
        badgeColor = context.colorScheme.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        primaryBadge,
        style: context.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: isFavorite ? [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
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
            size: 20,
          ),
        ),
        onPressed: () {
          debugPrint('[ProductCard] Favorite button tapped for product ${product.id} by roshdology123 at 2025-06-22 11:57:28');
          onFavoriteTap?.call();
        },
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        tooltip: isFavorite
            ? 'products.remove_from_favorites'.tr()
            : 'products.add_to_favorites'.tr(),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(
          Icons.add_shopping_cart,
          color: context.colorScheme.onPrimary,
          size: 16,
        ),
        onPressed: () {
          debugPrint('[ProductCard] Add to cart button tapped for product ${product.id} by roshdology123 at 2025-06-22 11:57:28');
          onAddToCartTap?.call();
        },
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minWidth: 28,
          minHeight: 28,
        ),
        tooltip: 'products.add_to_cart'.tr(),
      ),
    );
  }
}