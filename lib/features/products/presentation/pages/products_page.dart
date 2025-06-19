import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:scalable_ecommerce/features/cart/presentation/cubit/cart_cubit.dart';

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

  void _toggleFavorite(BuildContext context, Product product) {
    // This would be handled by a favorites cubit
    context.showSnackBar('products.favorite_toggle'.tr(args: [product.title]));
  }

  void _addToCart(BuildContext context, Product product) {
    context.read<CartCubit>().addToCart(productId: product.id, productTitle: product.title, productImage: product.image, price: product.price, quantity: 1,



    );
  }
}