import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class ProductPriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double? discountPercentage;
  final bool large;
  final bool compact;
  final CrossAxisAlignment alignment;
  final bool showCurrency;

  const ProductPriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.large = false,
    this.compact = false,
    this.alignment = CrossAxisAlignment.start,
    this.showCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;
    final actualDiscountPercentage = hasDiscount
        ? ((originalPrice! - price) / originalPrice!) * 100
        : (discountPercentage ?? 0);

    if (compact) {
      return _buildCompactLayout(context, hasDiscount, actualDiscountPercentage);
    } else {
      return _buildNormalLayout(context, hasDiscount, actualDiscountPercentage);
    }
  }

  Widget _buildNormalLayout(BuildContext context, bool hasDiscount, double discountPerc) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current price
        Text(
          _formatPrice(price),
          style: (large ? context.textTheme.headlineSmall : context.textTheme.bodyLarge)?.copyWith(
            fontWeight: FontWeight.bold,
            color: hasDiscount ? context.colorScheme.error : null,
          ),
        ),

        // Original price and discount
        if (hasDiscount) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Original price (strikethrough)
              Text(
                _formatPrice(originalPrice!),
                style: (large ? context.textTheme.bodyLarge : context.textTheme.bodyMedium)?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 8),

              // Discount badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colorScheme.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-${discountPerc.round()}%',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Savings amount
          if (large) ...[
            const SizedBox(height: 2),
            Text(
              'products.save_amount'.tr(args: [_formatPrice(originalPrice! - price)]),
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, bool hasDiscount, double discountPerc) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Current price
        Text(
          _formatPrice(price),
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: hasDiscount ? context.colorScheme.error : null,
          ),
        ),

        // Original price (if on sale)
        if (hasDiscount) ...[
          const SizedBox(width: 4),
          Text(
            _formatPrice(originalPrice!),
            style: context.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],

        // Discount percentage
        if (hasDiscount && discountPerc > 0) ...[
          const SizedBox(width: 4),
          Text(
            '-${discountPerc.round()}%',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  String _formatPrice(double price) {
    if (showCurrency) {
      return '\$${price.toStringAsFixed(2)}';
    } else {
      return price.toStringAsFixed(2);
    }
  }
}

class PriceRangeWidget extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final bool showCurrency;

  const PriceRangeWidget({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    this.showCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    if (minPrice == maxPrice) {
      return ProductPriceWidget(
        price: minPrice,
        showCurrency: showCurrency,
      );
    }

    return Text(
      showCurrency
          ? '\$${minPrice.toStringAsFixed(2)} - \$${maxPrice.toStringAsFixed(2)}'
          : '${minPrice.toStringAsFixed(2)} - ${maxPrice.toStringAsFixed(2)}',
      style: context.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PriceComparisonWidget extends StatelessWidget {
  final double currentPrice;
  final List<PriceHistory> priceHistory;

  const PriceComparisonWidget({
    super.key,
    required this.currentPrice,
    required this.priceHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (priceHistory.isEmpty) {
      return ProductPriceWidget(price: currentPrice);
    }

    final lowestPrice = priceHistory.map((p) => p.price).reduce((a, b) => a < b ? a : b);
    final highestPrice = priceHistory.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    final isLowest = currentPrice == lowestPrice;
    final isHighest = currentPrice == highestPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductPriceWidget(price: currentPrice, large: true),

        const SizedBox(height: 8),

        // Price comparison
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'products.price_history'.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'products.lowest'.tr(),
                        style: context.textTheme.labelSmall,
                      ),
                      Text(
                        '\$${lowestPrice.toStringAsFixed(2)}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'products.highest'.tr(),
                        style: context.textTheme.labelSmall,
                      ),
                      Text(
                        '\$${highestPrice.toStringAsFixed(2)}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              if (isLowest) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'products.lowest_price_ever'.tr(),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class PriceHistory {
  final double price;
  final DateTime date;

  const PriceHistory({
    required this.price,
    required this.date,
  });
}