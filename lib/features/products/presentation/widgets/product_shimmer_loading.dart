import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/extensions.dart';
import 'loading_product_card.dart';

class ProductShimmerLoading extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final EdgeInsets? padding;
  final double? childAspectRatio;

  const ProductShimmerLoading({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.padding,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      return _buildListLoading(context);
    } else {
      return _buildGridLoading(context);
    }
  }

  Widget _buildGridLoading(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio ?? 0.48,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const LoadingProductCard(),
    );
  }

  Widget _buildListLoading(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _LoadingProductListItem(),
      ),
    );
  }
}

class _LoadingProductListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: context.colorScheme.surfaceVariant,
        highlightColor: context.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(width: 16),

              // Content placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    Container(
                      width: 60,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 150,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 120,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),

                    // Rating
                    Container(
                      width: 100,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Container(
                      width: 80,
                      height: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // Action buttons placeholder
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
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
}

class CategoryShimmerLoading extends StatelessWidget {
  final int itemCount;

  const CategoryShimmerLoading({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Shimmer.fromColors(
            baseColor: context.colorScheme.surfaceVariant,
            highlightColor: context.colorScheme.surface,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const SizedBox(width: 80),
            ),
          ),
        ),
      ),
    );
  }
}