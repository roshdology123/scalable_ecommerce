import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../products/domain/entities/product.dart';

class ProductSearchItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductSearchItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = context.locale.languageCode == 'ar';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Expanded(
                      child: Text(
                        product.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      mainAxisAlignment: isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.rate.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.rating.count})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}