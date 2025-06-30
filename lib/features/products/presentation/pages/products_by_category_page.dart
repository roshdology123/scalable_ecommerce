import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/product.dart';
import '../cubit/categories_state.dart' as categories;
import '../cubit/products_cubit.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_filter_dialog.dart';
import '../widgets/product_sort_bottom_sheet.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/product_shimmer_loading.dart';

class ProductsByCategoryPage extends HookWidget {
  final String categoryName;
  final String? categoryDisplayName;

  const ProductsByCategoryPage({
    super.key,
    required this.categoryName,
    this.categoryDisplayName,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final gridCrossAxisCount = useState(2);

    // Listen to scroll for infinite loading
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          context.read<ProductsCubit>().loadMoreProducts();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    // Load category products
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductsCubit>().loadProductsByCategory(
          category: categoryName,
          refresh: true,
        );
      });
      return null;
    }, [categoryName]);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryDisplayName ?? categoryName.capitalizeWords),
        actions: [
          // View toggle (grid/list)
          IconButton(
            icon: Icon(gridCrossAxisCount.value == 1
                ? Icons.grid_view
                : Icons.view_list),
            onPressed: () {
              gridCrossAxisCount.value = gridCrossAxisCount.value == 1 ? 2 : 1;
            },
          ),

          // Filter button
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              final cubit = context.read<ProductsCubit>();
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showFilterDialog(context),
                  ),
                  if (cubit.hasActiveFilters)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cubit.activeFilterCount.toString(),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onError,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Sort button
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProductsCubit>().refresh();
        },
        child: Column(
          children: [
            // Category info header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              child: BlocBuilder<CategoriesCubit, categories.CategoriesState>(
                builder: (context, state) {
                  final category = state.categories
                      .where((cat) => cat.name.toLowerCase() == categoryName.toLowerCase())
                      .firstOrNull;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category != null && category.description != null) ...[
                        Text(
                          category.description!,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      BlocBuilder<ProductsCubit, ProductsState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            loaded: (products, _, __, ___, ____) => Text(
                              'products.products_count'.tr(args: [products.length.toString()]),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            orElse: () => const SizedBox.shrink(),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            // Active filters row
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                final cubit = context.read<ProductsCubit>();
                if (!cubit.hasActiveFilters) return const SizedBox.shrink();

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Active filters summary
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt,
                              size: 16,
                              color: context.colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'products.filters_active'.tr(args: [cubit.activeFilterCount.toString()]),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Clear filters button
                      GestureDetector(
                        onTap: () => context.read<ProductsCubit>().clearFilters(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: context.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.clear,
                                size: 16,
                                color: context.colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'products.clear_filters'.tr(),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onErrorContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Products grid
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    loading: () => ProductShimmerLoading(
                      crossAxisCount: gridCrossAxisCount.value,
                    ),
                    loaded: (products, hasReachedMax, currentPage, category, sortBy) {
                      if (products.isEmpty) {
                        return EmptyProductsWidget(
                          title: 'products.no_products_in_category'.tr(),
                          subtitle: 'products.no_products_in_category_subtitle'.tr(
                            args: [categoryDisplayName ?? categoryName],
                          ),
                        );
                      }

                      return ProductGrid(
                        products: products,
                        crossAxisCount: gridCrossAxisCount.value,
                        scrollController: scrollController,
                        hasReachedMax: hasReachedMax,
                        onProductTap: (product) => _navigateToProductDetail(context, product),
                        onFavoriteTap: (product) => _toggleFavorite(context, product),
                        onAddToCartTap: (product) => _addToCart(context, product),
                      );
                    },
                    loadingMore: (products, hasReachedMax, currentPage, category, sortBy) {
                      return ProductGrid(
                        products: products,
                        crossAxisCount: gridCrossAxisCount.value,
                        scrollController: scrollController,
                        hasReachedMax: hasReachedMax,
                        isLoadingMore: true,
                        onProductTap: (product) => _navigateToProductDetail(context, product),
                        onFavoriteTap: (product) => _toggleFavorite(context, product),
                        onAddToCartTap: (product) => _addToCart(context, product),
                      );
                    },
                    empty: () => EmptyProductsWidget(
                      title: 'products.no_products_in_category'.tr(),
                      subtitle: 'products.no_products_in_category_subtitle'.tr(
                        args: [categoryDisplayName ?? categoryName],
                      ),
                    ),
                    error: (message, code) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: context.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            message,
                            style: context.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<ProductsCubit>().refresh(),
                            child: Text('common.retry'.tr()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          // Show scroll to top button when products are loaded and user scrolled down
          return state.maybeWhen(
            loaded: (products, _, __, ___, ____) => products.length > 10
                ? FloatingActionButton.small(
              onPressed: () {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_up),
            )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ProductFilterDialog(),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ProductSortBottomSheet(),
      isScrollControlled: true,
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    context.push('/home/product/${product.id}');
  }

  void _toggleFavorite(BuildContext context, Product product) {
    context.showSnackBar('products.favorite_toggle'.tr(args: [product.title]));
  }

  void _addToCart(BuildContext context, Product product) {
    context.showSuccessSnackBar('products.added_to_cart'.tr(args: [product.title]));
  }
}

