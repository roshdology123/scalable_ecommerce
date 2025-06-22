import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:scalable_ecommerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:scalable_ecommerce/features/favorites/presentation/cubit/favorites_cubit/favorites_cubit.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/debouncer.dart';
import '../../domain/entities/product.dart';
import '../cubit/categories_state.dart';
import '../cubit/products_cubit.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_filter_dialog.dart';
import '../widgets/product_sort_bottom_sheet.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/product_shimmer_loading.dart';

class ProductsPage extends HookWidget {
  final String? initialCategory;
  final String? initialQuery;

  const ProductsPage({
    super.key,
    this.initialCategory,
    this.initialQuery,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController(text: initialQuery ?? '');
    final scrollController = useScrollController();
    final searchDebouncer = useMemoized(() => SearchDebouncer());
    final searchFocusNode = useFocusNode();
    final isSearchExpanded = useState(initialQuery?.isNotEmpty == true);
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

    // Load initial data
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CategoriesCubit>().loadCategories();

        if (initialQuery?.isNotEmpty == true) {
          context.read<ProductsCubit>().searchProducts(query: initialQuery!);
        } else if (initialCategory != null) {
          context.read<ProductsCubit>().loadProductsByCategory(category: initialCategory!);
        } else {
          context.read<ProductsCubit>().loadProducts();
        }
      });
      return null;
    }, []);

    // Handle search
    void handleSearch(String query) {
      if (query.trim().isEmpty) {
        context.read<ProductsCubit>().loadProducts(refresh: true);
      } else {
        searchDebouncer.search(query.trim(), (searchQuery) {
          context.read<ProductsCubit>().searchProducts(
            query: searchQuery,
            refresh: true,
          );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearchExpanded.value
              ? TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            decoration: InputDecoration(
              hintText: 'products.search_hint'.tr(),
              border: InputBorder.none,
              hintStyle: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            style: context.textTheme.bodyLarge,
            onChanged: handleSearch,
            onSubmitted: (query) => handleSearch(query),
          )
              : Text('products.title'.tr()),
        ),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(isSearchExpanded.value ? Icons.close : Icons.search),
            onPressed: () {
              if (isSearchExpanded.value) {
                isSearchExpanded.value = false;
                searchController.clear();
                searchFocusNode.unfocus();
                context.read<ProductsCubit>().loadProducts(refresh: true);
              } else {
                isSearchExpanded.value = true;
                searchFocusNode.requestFocus();
              }
            },
          ),

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
            // Categories horizontal list
            BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  loaded: (categories, selectedCategoryId) {
                    if (categories.isEmpty) return const SizedBox.shrink();

                    return Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length + 1, // +1 for "All" chip
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // "All" category chip
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CategoryChip(
                                label: 'products.all_categories'.tr(),
                                isSelected: selectedCategoryId == null,
                                onTap: () {
                                  context.read<CategoriesCubit>().clearSelection();
                                  context.read<ProductsCubit>().loadProducts(refresh: true);
                                },
                              ),
                            );
                          }

                          final category = categories[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: CategoryChip(
                              label: category.displayName,
                              count: category.productCount,
                              isSelected: selectedCategoryId == category.id,
                              onTap: () {
                                context.read<CategoriesCubit>().selectCategory(category.id);
                                context.read<ProductsCubit>().loadProductsByCategory(
                                  category: category.name,
                                  refresh: true,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                  empty: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),

            // Active filters row
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                final cubit = context.read<ProductsCubit>();
                if (!cubit.hasActiveFilters) return const SizedBox.shrink();

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: context.colorScheme.surfaceVariant.withOpacity(0.5),
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

            // Products list/grid
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(
                      child: Text('Start exploring our products!'),
                    ),
                    loading: () => ProductShimmerLoading(
                      crossAxisCount: gridCrossAxisCount.value,
                    ),
                    loaded: (products, hasReachedMax, currentPage, category, sortBy) {
                      if (products.isEmpty) {
                        return const EmptyProductsWidget();
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
                    empty: () => const EmptyProductsWidget(),
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

  Future<void> _toggleFavorite(BuildContext context, Product product) async {
    debugPrint('[ProductsPage] Toggling favorite for product ${product.id} by roshdology123 at 2025-06-22 12:02:22');

    final favoritesCubit = context.read<FavoritesCubit>();

    // 🔥 Get current state BEFORE the toggle
    final wasAlreadyFavorite = favoritesCubit.currentFavorites.any(
            (favorite) => favorite.productId == product.id
    );

    try {
      // 🔥 Show immediate feedback based on current state
      _showImmediateFeedback(context, product, !wasAlreadyFavorite);

      // 🔥 Perform the toggle operation
      final isNowFavorite = await favoritesCubit.toggleFavorite(
        product,
        enablePriceTracking: false,
      );

      // 🔥 If the result doesn't match our optimistic update, show correction
      if (isNowFavorite != !wasAlreadyFavorite) {
        _showCorrectionFeedback(context, product, isNowFavorite);
      }

    } catch (e) {
      debugPrint('[ProductsPage] Error toggling favorite for roshdology123: $e');

      // 🔥 Show error and suggest retry
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to update favorites. Please try again.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _toggleFavorite(context, product),
          ),
        ),
      );
    }
  }
  void _showImmediateFeedback(BuildContext context, Product product, bool isBeingAdded) {
    if (isBeingAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${product.title} added to favorites!',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () => context.push('/favorites'),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.heart_broken, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${product.title} removed from favorites',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.white,
            onPressed: () async {
              await context.read<FavoritesCubit>().toggleFavorite(product);
            },
          ),
        ),
      );
    }
  }

  void _showCorrectionFeedback(BuildContext context, Product product, bool actualState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          actualState
              ? '${product.title} is now in favorites'
              : '${product.title} removed from favorites',
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
      ),
    );
  }
  // 🔥 PROPER ADD TO CART IMPLEMENTATION using your CartCubit signature
  void _addToCart(BuildContext context, Product product) {
    debugPrint('[ProductsPage] Adding product ${product.id} to cart for roshdology123 at 2025-06-22 11:50:08');

    final cartCubit = context.read<CartCubit>();

    try {
      // Use your exact CartCubit.addToCart method signature
      cartCubit.addToCart(
        productId: product.id,
        productTitle: product.title,
        productImage: product.image,
        price: product.price,
        quantity: 1, // Default quantity
        selectedColor: product.colors.isNotEmpty == true
            ? product.colors.first
            : null,
        selectedSize: product.colors.isNotEmpty == true
            ? product.colors.first
            : null,
        additionalVariants: null, // Can be extended later
        maxQuantity: product.stock > 0 ? product.stock : 999,
        brand: product.brand,
        category: product.category,
        sku: product.sku,
        originalPrice: product.originalPrice ?? product.price,
        discountPercentage: product.discountPercentage,
      );

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.shopping_cart, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${product.title} added to cart!',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () => context.push('/cart'),
          ),
        ),
      );
    } catch (e) {
      debugPrint('[ProductsPage] Error adding to cart for roshdology123: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}