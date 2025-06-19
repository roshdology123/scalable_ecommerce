import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../domain/entities/product.dart';
import 'product_card.dart';
import 'product_list_item.dart';
import 'loading_product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final int crossAxisCount;
  final ScrollController? scrollController;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final Function(Product)? onProductTap;
  final Function(Product)? onFavoriteTap;
  final Function(Product)? onAddToCartTap;
  final EdgeInsets? padding;
  final double? childAspectRatio;
  final bool useStaggeredGrid;

  const ProductGrid({
    super.key,
    required this.products,
    this.crossAxisCount = 2,
    this.scrollController,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.onProductTap,
    this.onFavoriteTap,
    this.onAddToCartTap,
    this.padding,
    this.childAspectRatio,
    this.useStaggeredGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount == 1) {
      // List view
      return _buildListView();
    } else if (useStaggeredGrid) {
      // Staggered grid view
      return _buildStaggeredGrid();
    } else {
      // Regular grid view
      return _buildGridView();
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: scrollController,
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: products.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final product = products[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ProductListItem(
            product: product,
            onTap: () => onProductTap?.call(product),
            onFavoriteTap: () => onFavoriteTap?.call(product),
            onAddToCartTap: () => onAddToCartTap?.call(product),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: scrollController,
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio ?? 0.48,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length + (isLoadingMore ? crossAxisCount : 0),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const LoadingProductCard();
        }

        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap?.call(product),
          onFavoriteTap: () => onFavoriteTap?.call(product),
          onAddToCartTap: () => onAddToCartTap?.call(product),
        );
      },
    );
  }

  Widget _buildStaggeredGrid() {
    return MasonryGridView.builder(
      controller: scrollController,
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: products.length + (isLoadingMore ? crossAxisCount : 0),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const LoadingProductCard();
        }

        final product = products[index];

        // Calculate dynamic height based on product info
        double height = 280; // Base height

        if (product.brand != null) height += 20;
        if (product.title.length > 50) height += 20;
        if (product.isOnSale) height += 10;

        return ProductCard(
          product: product,
          height: height,
          onTap: () => onProductTap?.call(product),
          onFavoriteTap: () => onFavoriteTap?.call(product),
          onAddToCartTap: () => onAddToCartTap?.call(product),
        );
      },
    );
  }
}