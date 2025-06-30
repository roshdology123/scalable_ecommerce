import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/rating.dart';

class ProductRatingWidget extends StatelessWidget {
  final Rating rating;
  final double size;
  final bool showReviewCount;
  final bool showRatingValue;
  final VoidCallback? onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final MainAxisAlignment alignment;

  const ProductRatingWidget({
    super.key,
    required this.rating,
    this.size = 16,
    this.showReviewCount = true,
    this.showRatingValue = false,
    this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? Colors.amber;
    final inactive = inactiveColor ?? context.colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Star rating
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final ratingValue = rating.rate;

              IconData iconData;
              Color iconColor;

              if (ratingValue >= starValue) {
                // Full star
                iconData = Icons.star;
                iconColor = active;
              } else if (ratingValue >= starValue - 0.5) {
                // Half star
                iconData = Icons.star_half;
                iconColor = active;
              } else {
                // Empty star
                iconData = Icons.star_border;
                iconColor = inactive;
              }

              return Icon(
                iconData,
                size: size,
                color: iconColor,
              );
            }),
          ),

          // Rating value
          if (showRatingValue) ...[
            const SizedBox(width: 4),
            Text(
              rating.rate.toStringAsFixed(1),
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: size * 0.75,
              ),
            ),
          ],

          // Review count
          if (showReviewCount && rating.count > 0) ...[
            const SizedBox(width: 4),
            Text(
              '(${rating.count})',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                fontSize: size * 0.75,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RatingBreakdown extends StatelessWidget {
  final Rating rating;
  final Map<int, int>? ratingBreakdown; // star -> count

  const RatingBreakdown({
    super.key,
    required this.rating,
    this.ratingBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    // Mock rating breakdown if not provided
    final breakdown = ratingBreakdown ?? _generateMockBreakdown();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall rating
        Row(
          children: [
            Text(
              rating.rate.toStringAsFixed(1),
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            ProductRatingWidget(
              rating: rating,
              size: 20,
              showReviewCount: false,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'products.reviews_count'.tr(args: [rating.count.toString()]),
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),

        // Rating breakdown
        ...List.generate(5, (index) {
          final star = 5 - index;
          final count = breakdown[star] ?? 0;
          final percentage = rating.count > 0 ? count / rating.count : 0.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  '$star',
                  style: context.textTheme.bodySmall,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.star,
                  size: 12,
                  color: Colors.amber,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: context.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: Text(
                    count.toString(),
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Map<int, int> _generateMockBreakdown() {
    // Generate mock breakdown based on overall rating
    final total = rating.count;
    if (total == 0) return {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    final rate = rating.rate;
    final breakdown = <int, int>{};

    // Simple algorithm to distribute ratings
    if (rate >= 4.5) {
      breakdown[5] = (total * 0.7).round();
      breakdown[4] = (total * 0.25).round();
      breakdown[3] = (total * 0.05).round();
      breakdown[2] = 0;
      breakdown[1] = 0;
    } else if (rate >= 4.0) {
      breakdown[5] = (total * 0.5).round();
      breakdown[4] = (total * 0.35).round();
      breakdown[3] = (total * 0.15).round();
      breakdown[2] = 0;
      breakdown[1] = 0;
    } else if (rate >= 3.5) {
      breakdown[5] = (total * 0.3).round();
      breakdown[4] = (total * 0.4).round();
      breakdown[3] = (total * 0.25).round();
      breakdown[2] = (total * 0.05).round();
      breakdown[1] = 0;
    } else {
      breakdown[5] = (total * 0.2).round();
      breakdown[4] = (total * 0.3).round();
      breakdown[3] = (total * 0.3).round();
      breakdown[2] = (total * 0.15).round();
      breakdown[1] = (total * 0.05).round();
    }

    // Ensure total matches
    final sum = breakdown.values.fold(0, (a, b) => a + b);
    if (sum != total && breakdown[5]! > 0) {
      breakdown[5] = breakdown[5]! + (total - sum);
    }

    return breakdown;
  }
}