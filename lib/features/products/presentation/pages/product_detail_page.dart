import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_rating_widget.dart';
import '../widgets/product_price_widget.dart';
import '../widgets/product_grid.dart';
import '../widgets/loading_product_card.dart';

class ProductDetailPage extends HookWidget {
  final int productId;
  final Product? product; // Optional cached product for faster loading

  const ProductDetailPage({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final showFloatingActionButton = useState(false);
    final selectedQuantity = useState(1);

    // Listen to scroll to show/hide FAB
    useEffect(() {
      void onScroll() {
        final isScrolled = scrollController.hasClients &&
            scrollController.offset > 200;
        if (showFloatingActionButton.value != isScrolled) {
          showFloatingActionButton.value = isScrolled;
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    // Load product data
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<ProductDetailCubit>();
        if (product != null) {
          cubit.loadProductOptimistic(productId, product);
        } else {
          cubit.loadProduct(productId);
        }

        // Track view
        cubit.updateViewCount();
      });
      return null;
    }, [productId]);

    return Scaffold(
      body: BlocConsumer<ProductDetailCubit, ProductDetailState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message, code) {
              context.showErrorSnackBar(message);
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (product, relatedProducts, isFavorite) => _buildLoadedContent(
              context,
              product,
              relatedProducts,
              isFavorite,
              scrollController,
              selectedQuantity,
            ),
            error: (message, code) => _buildErrorContent(context, message),
          );
        },
      ),
      floatingActionButton: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (product, _, __) => AnimatedSlide(
              offset: showFloatingActionButton.value
                  ? Offset.zero
                  : const Offset(0, 2),
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton.extended(
                onPressed: () => _addToCart(context, product, selectedQuantity.value),
                icon: const Icon(Icons.shopping_cart),
                label: Text('products.add_to_cart'.tr()),
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildLoadedContent(
      BuildContext context,
      Product product,
      List<Product> relatedProducts,
      bool isFavorite,
      ScrollController scrollController,
      ValueNotifier<int> selectedQuantity,
      ) {
    final cubit = context.read<ProductDetailCubit>();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // App Bar with image background
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: ProductImageCarousel(
              images: product.allImages,
              selectedIndex: cubit.selectedImageIndex,
              onImageTap: (index) => cubit.selectImage(index),
            ),
          ),
          actions: [
            // Share button
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareProduct(product),
            ),

            // Favorite button
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () => cubit.toggleFavorite(),
            ),
          ],
        ),

        // Product information
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product badges
                if (product.badges.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: product.badges.take(3).map((badge) => _buildBadge(context, badge)).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Title and brand
                if (product.brand != null) ...[
                  Text(
                    product.brand!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],

                Text(
                  product.title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating and reviews
                ProductRatingWidget(
                  rating: product.rating,
                  showReviewCount: true,
                  onTap: () => _showReviews(context, product),
                ),
                const SizedBox(height: 16),

                // Price
                ProductPriceWidget(
                  price: product.price,
                  originalPrice: product.originalPrice,
                  discountPercentage: product.discountPercentage,
                  large: true,
                ),
                const SizedBox(height: 16),

                // Stock status
                _buildStockStatus(context, product),
                const SizedBox(height: 24),

                // Color selection
                if (product.hasColors) ...[
                  _buildColorSelection(context, product, cubit),
                  const SizedBox(height: 24),
                ],

                // Size selection
                if (product.hasSizes) ...[
                  _buildSizeSelection(context, product, cubit),
                  const SizedBox(height: 24),
                ],

                // Quantity selection
                _buildQuantitySelection(context, product, selectedQuantity),
                const SizedBox(height: 24),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: cubit.canAddToCart
                        ? () => _addToCart(context, product, selectedQuantity.value)
                        : null,
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(product.inStock
                        ? 'products.add_to_cart'.tr()
                        : 'products.out_of_stock'.tr()),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Description
                _buildSection(
                  context,
                  'products.description'.tr(),
                  Text(
                    product.description,
                    style: context.textTheme.bodyLarge,
                  ),
                ),

                // Specifications
                if (product.hasSpecifications) ...[
                  const SizedBox(height: 24),
                  _buildSpecifications(context, product),
                ],

                // Product details
                const SizedBox(height: 24),
                _buildProductDetails(context, product),

                // Related products
                if (relatedProducts.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildRelatedProducts(context, relatedProducts),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
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
              onPressed: () => context.read<ProductDetailCubit>().refresh(),
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String badge) {
    Color? backgroundColor;
    Color? textColor;

    switch (badge.toLowerCase()) {
      case 'new':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case 'sale':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case 'featured':
        backgroundColor = context.colorScheme.primary;
        textColor = context.colorScheme.onPrimary;
        break;
      case 'limited':
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = context.colorScheme.secondary;
        textColor = context.colorScheme.onSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        badge,
        style: context.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStockStatus(BuildContext context, Product product) {
    Color statusColor;
    IconData statusIcon;

    if (product.outOfStock) {
      statusColor = context.colorScheme.error;
      statusIcon = Icons.remove_circle_outline;
    } else if (product.lowStock) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning_amber_outlined;
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_outline;
    }

    return Row(
      children: [
        Icon(statusIcon, color: statusColor, size: 20),
        const SizedBox(width: 8),
        Text(
          product.stockStatus,
          style: context.textTheme.bodyMedium?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (product.stock > 0 && product.stock < 10) ...[
          const SizedBox(width: 8),
          Text(
            '(${product.stock} left)',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildColorSelection(BuildContext context, Product product, ProductDetailCubit cubit) {
    return _buildSection(
      context,
      'products.color'.tr(),
      Wrap(
        spacing: 12,
        runSpacing: 8,
        children: product.colors.map((color) {
          final isSelected = cubit.selectedColor == color;
          return GestureDetector(
            onTap: () => cubit.selectColor(color),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.outline,
                ),
              ),
              child: Text(
                color,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSizeSelection(BuildContext context, Product product, ProductDetailCubit cubit) {
    return _buildSection(
      context,
      'products.size'.tr(),
      Wrap(
        spacing: 12,
        runSpacing: 8,
        children: product.sizes.map((size) {
          final isSelected = cubit.selectedSize == size;
          return GestureDetector(
            onTap: () => cubit.selectSize(size),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.outline,
                ),
              ),
              child: Center(
                child: Text(
                  size,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuantitySelection(BuildContext context, Product product, ValueNotifier<int> selectedQuantity) {
    return _buildSection(
      context,
      'products.quantity'.tr(),
      Row(
        children: [
          IconButton(
            onPressed: selectedQuantity.value > 1
                ? () => selectedQuantity.value--
                : null,
            icon: const Icon(Icons.remove),
            style: IconButton.styleFrom(
              backgroundColor: context.colorScheme.surfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: context.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedQuantity.value.toString(),
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: selectedQuantity.value < product.stock
                ? () => selectedQuantity.value++
                : null,
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: context.colorScheme.surfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            'products.available_stock'.tr(args: [product.stock.toString()]),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildSpecifications(BuildContext context, Product product) {
    return _buildSection(
      context,
      'products.specifications'.tr(),
      Column(
        children: product.specifications!.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    entry.value.toString(),
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    final details = <String, String?>{
      'products.sku'.tr(): product.sku,
      'products.category'.tr(): product.category,
      'products.weight'.tr(): product.weight,
      'products.dimensions'.tr(): product.dimensions,
      'products.material'.tr(): product.material,
      'products.warranty'.tr(): product.warranty,
    };

    final filteredDetails = details.entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .toList();

    if (filteredDetails.isEmpty) return const SizedBox.shrink();

    return _buildSection(
      context,
      'products.product_details'.tr(),
      Column(
        children: filteredDetails.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    entry.value!,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRelatedProducts(BuildContext context, List<Product> relatedProducts) {
    return _buildSection(
      context,
      'products.related_products'.tr(),
      Column(
        children: [
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 16),
                  child: LoadingProductCard(
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _shareProduct(Product product) {
    SharePlus.instance.share(
      ShareParams(
        subject: product.title,
        text:  'products.share_message'.tr(args: [
          product.title,
          product.formattedPrice,
          'Check out this amazing product!'
        ]),
      )

    );
  }

  void _showReviews(BuildContext context, Product product) {
    // Navigate to reviews page or show reviews bottom sheet
    context.showSnackBar('products.reviews_coming_soon'.tr());
  }

  void _addToCart(BuildContext context, Product product, int quantity) {
    final cubit = context.read<ProductDetailCubit>();
    final variant = cubit.selectedVariant;

    // Validate selection
    if (!cubit.canAddToCart) {
      if (product.hasSizes && cubit.selectedSize == null) {
        context.showErrorSnackBar('products.select_size'.tr());
        return;
      }
      if (product.hasColors && cubit.selectedColor == null) {
        context.showErrorSnackBar('products.select_color'.tr());
        return;
      }
      if (!product.inStock) {
        context.showErrorSnackBar('products.out_of_stock'.tr());
        return;
      }
    }

    // Add to cart logic would go here
    context.showSuccessSnackBar(
      'products.added_to_cart_with_quantity'.tr(args: [
        quantity.toString(),
        product.title,
      ]),
    );
  }

  void _toggleFavorite(BuildContext context, Product product) {
    // Handle favorite toggle
    context.showSnackBar('products.favorite_toggle'.tr(args: [product.title]));
  }

  void _navigateToProduct(BuildContext context, Product product) {
    context.push('/product/${product.id}');
  }
}