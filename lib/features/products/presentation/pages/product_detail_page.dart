import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/extensions.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit/favorites_state.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_rating_widget.dart';
import '../widgets/product_price_widget.dart';

class ProductDetailPage extends HookWidget {
  final int productId;
  final Product? product;

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
        if (scrollController.hasClients) {
          final isScrolled = scrollController.offset > 200;
          if (showFloatingActionButton.value != isScrolled) {
            showFloatingActionButton.value = isScrolled;
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    // Load product data
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final cubit = context.read<ProductDetailCubit>();
          if (product != null) {
            cubit.loadProductOptimistic(productId, product);
          } else {
            cubit.loadProduct(productId);
          }
          cubit.updateViewCount();
          debugPrint('[ProductDetailPage] Loading product $productId for roshdology123 at 2025-06-22 12:49:05');
        } catch (e) {
          debugPrint('[ProductDetailPage] Error in useEffect: $e');
        }
      });
      return null;
    }, [productId]);

    return Scaffold(
      body: BlocConsumer<ProductDetailCubit, ProductDetailState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message, code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => _buildLoadingScreen(context),
            loading: () => _buildLoadingScreen(context),
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
                label: const Text('Add to Cart'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading product...'),
          ],
        ),
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
    debugPrint('[ProductDetailPage] Building loaded content for product ${product.id} for roshdology123');

    return SafeArea(
      top: false  ,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          // Safe App Bar with image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProductImage(context, product),
            ),
            actions: [
              // Share button
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareProduct(product),
                tooltip: 'Share product',
              ),
              // Favorite button with safe state management
              _buildSafeFavoriteButton(context, product),
            ],
          ),

          // Product information with safe rendering
          SliverToBoxAdapter(
            child: _buildProductInformation(context, product, selectedQuantity),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, Product product) {
    if (product.image.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported,
          size: 64,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.network(
        product.image,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSafeFavoriteButton(BuildContext context, Product product) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        try {
          final favoritesCubit = context.read<FavoritesCubit>();
          final isProductFavorite = favoritesCubit.currentFavorites.any(
                (favorite) => favorite.productId == product.id,
          );

          return Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: isProductFavorite ? [
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
                  isProductFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isProductFavorite),
                  color: isProductFavorite ? Colors.red : Colors.grey.shade700,
                  size: 24,
                ),
              ),
              onPressed: () => _toggleFavorite(context, product),
              tooltip: isProductFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
          );
        } catch (e) {
          debugPrint('[ProductDetailPage] Error in favorite button: $e');
          // Fallback favorite button
          return IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => _toggleFavorite(context, product),
            tooltip: 'Add to favorites',
          );
        }
      },
    );
  }

  Widget _buildProductInformation(
      BuildContext context,
      Product product,
      ValueNotifier<int> selectedQuantity
      ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 🔥 Fixed: Prevent infinite height
        children: [
          // Product badges (safe)
          if (product.badges.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: product.badges
                  .take(3)
                  .map((badge) => _buildBadge(context, badge))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Brand (safe)
          if (product.brand?.isNotEmpty == true) ...[
            Text(
              product.brand!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
          ],

          // Title (safe)
          Text(
            product.title.isNotEmpty ? product.title : 'Unknown Product',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Rating (safe)
          _buildSafeRating(context, product),
          const SizedBox(height: 16),

          // Price (safe)
          _buildSafePrice(context, product),
          const SizedBox(height: 16),

          // Stock status (safe)
          _buildSafeStockStatus(context, product),
          const SizedBox(height: 24),

          // Favorite actions row (safe)
          _buildSafeFavoriteActionsRow(context, product),
          const SizedBox(height: 24),

          // Quantity selection (safe)
          _buildSafeQuantitySelection(context, product, selectedQuantity),
          const SizedBox(height: 24),

          // Action buttons (🔥 FIXED - No more infinite width)
          _buildSafeActionButtons(context, product, selectedQuantity),
          const SizedBox(height: 32),

          // Description (safe)
          _buildSafeDescription(context, product),
          const SizedBox(height: 24),

          // Product details (safe)
          _buildSafeProductDetails(context, product),
          const SizedBox(height: 80), // Extra padding for FAB
        ],
      ),
    );
  }

  Widget _buildSafeRating(BuildContext context, Product product) {
    try {
      return ProductRatingWidget(
        rating: product.rating,
        showReviewCount: true,
        onTap: () => _showReviews(context, product),
      );
    } catch (e) {
      debugPrint('[ProductDetailPage] Error building rating: $e');
      return Row(
        mainAxisSize: MainAxisSize.min, // 🔥 Fixed: Prevent infinite width
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            product.rating.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }
  }

  Widget _buildSafePrice(BuildContext context, Product product) {
    try {
      return ProductPriceWidget(
        price: product.price,
        originalPrice: product.originalPrice,
        discountPercentage: product.discountPercentage,
        large: true,
      );
    } catch (e) {
      debugPrint('[ProductDetailPage] Error building price: $e');
      return Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  Widget _buildSafeStockStatus(BuildContext context, Product product) {
    try {
      Color statusColor;
      IconData statusIcon;
      String statusText;

      if (product.outOfStock) {
        statusColor = Theme.of(context).colorScheme.error;
        statusIcon = Icons.remove_circle_outline;
        statusText = 'Out of Stock';
      } else if (product.lowStock) {
        statusColor = Colors.orange;
        statusIcon = Icons.warning_amber_outlined;
        statusText = 'Low Stock';
      } else {
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        statusText = 'In Stock';
      }

      return Row(
        mainAxisSize: MainAxisSize.min, // 🔥 Fixed: Prevent infinite width
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (product.stock > 0 && product.stock < 10) ...[
            const SizedBox(width: 8),
            Text(
              '(${product.stock} left)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      );
    } catch (e) {
      debugPrint('[ProductDetailPage] Error building stock status: $e');
      return const SizedBox.shrink();
    }
  }

  Widget _buildSafeFavoriteActionsRow(BuildContext context, Product product) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        try {
          final favoritesCubit = context.read<FavoritesCubit>();
          final isProductFavorite = favoritesCubit.currentFavorites.any(
                (favorite) => favorite.productId == product.id,
          );

          return Container(
            width: double.infinity, // 🔥 Fixed: Explicit width constraint
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max, // 🔥 Fixed: Explicit main axis size
              children: [
                Icon(
                  isProductFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isProductFavorite
                      ? Colors.red
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 🔥 Fixed: Prevent infinite height
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isProductFavorite
                            ? 'Added to favorites'
                            : 'Add to favorites',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        isProductFavorite
                            ? 'You can find this in your favorites list'
                            : 'Save this product for later',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // 🔥 Fixed: Constrained button size
                if (isProductFavorite)
                  SizedBox(
                    width: 100, // Fixed width
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/favorites'),
                      icon: const Icon(Icons.list, size: 16),
                      label: const Text('View'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: 80, // Fixed width
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleFavorite(context, product),
                      icon: const Icon(Icons.favorite_border, size: 16),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                  ),
              ],
            ),
          );
        } catch (e) {
          debugPrint('[ProductDetailPage] Error building favorite actions row: $e');
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSafeQuantitySelection(
      BuildContext context,
      Product product,
      ValueNotifier<int> selectedQuantity
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 🔥 Fixed: Prevent infinite height
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max, // 🔥 Fixed: Explicit size
          children: [
            IconButton(
              onPressed: selectedQuantity.value > 1
                  ? () => selectedQuantity.value--
                  : null,
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedQuantity.value.toString(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: selectedQuantity.value < (product.stock > 0 ? product.stock : 999)
                  ? () => selectedQuantity.value++
                  : null,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            const Spacer(),
            Flexible( // 🔥 Fixed: Use Flexible instead of direct Text
              child: Text(
                'Available: ${product.stock > 0 ? product.stock : 'Many'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 🔥 COMPLETELY FIXED ACTION BUTTONS - No more infinite width constraints
  Widget _buildSafeActionButtons(
      BuildContext context,
      Product product,
      ValueNotifier<int> selectedQuantity
      ) {
    return SizedBox(
      width: double.infinity, // 🔥 Fixed: Explicit width constraint
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Add to cart button with constrained width
          Flexible( // 🔥 Changed from Expanded to Flexible
            flex: 3,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: product.inStock
                    ? () => _addToCart(context, product, selectedQuantity.value)
                    : null,
                icon: const Icon(Icons.shopping_cart),
                label: Text(product.inStock ? 'Add to Cart' : 'Out of Stock'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Quick favorite toggle with fixed size
          SizedBox(
            width: 56, // 🔥 Fixed: Explicit width
            height: 56, // 🔥 Fixed: Explicit height
            child: _buildQuickFavoriteButton(context, product),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFavoriteButton(BuildContext context, Product product) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        try {
          final favoritesCubit = context.read<FavoritesCubit>();
          final isProductFavorite = favoritesCubit.currentFavorites.any(
                (favorite) => favorite.productId == product.id,
          );

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isProductFavorite
                    ? Colors.red.withOpacity(0.3)
                    : Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isProductFavorite
                  ? Colors.red.withOpacity(0.1)
                  : null,
            ),
            child: IconButton(
              onPressed: () => _toggleFavorite(context, product),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isProductFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isProductFavorite),
                  color: isProductFavorite
                      ? Colors.red
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              tooltip: isProductFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
          );
        } catch (e) {
          debugPrint('[ProductDetailPage] Error building quick favorite button: $e');
          return IconButton(
            onPressed: () => _toggleFavorite(context, product),
            icon: const Icon(Icons.favorite_border),
          );
        }
      },
    );
  }

  Widget _buildSafeDescription(BuildContext context, Product product) {
    if (product.description.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min, // 🔥 Fixed: Prevent infinite height
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildSafeProductDetails(BuildContext context, Product product) {
    final details = <String, String?>{
      'SKU': product.sku,
      'Category': product.category,
    };

    final filteredDetails = details.entries
        .where((entry) => entry.value?.isNotEmpty == true)
        .toList();

    if (filteredDetails.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min, // 🔥 Fixed: Prevent infinite height
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...filteredDetails.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.max, // 🔥 Fixed: Explicit size
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    entry.value!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, String badge) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (badge.toLowerCase()) {
      case 'new':
        backgroundColor = Colors.green;
        break;
      case 'sale':
        backgroundColor = Colors.red;
        break;
      case 'featured':
        backgroundColor = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case 'limited':
        backgroundColor = Colors.orange;
        break;
      default:
        backgroundColor = Theme.of(context).colorScheme.secondary;
        textColor = Theme.of(context).colorScheme.onSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        badge,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ProductDetailCubit>().refresh(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // Action methods with enhanced error handling

  void _shareProduct(Product product) {
    try {
      SharePlus.instance.share(
        ShareParams(
          subject: product.title,
          text: 'Check out ${product.title} for \$${product.price.toStringAsFixed(2)}!',
        ),
      );
    } catch (e) {
      debugPrint('[ProductDetailPage] Error sharing product: $e');
    }
  }

  void _showReviews(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reviews coming soon!')),
    );
  }

  void _addToCart(BuildContext context, Product product, int quantity) {
    debugPrint('[ProductDetailPage] Adding product ${product.id} to cart for roshdology123 at 2025-06-22 12:49:05');

    try {
      final cartCubit = context.read<CartCubit>();

      cartCubit.addToCart(
        productId: product.id,
        productTitle: product.title,
        productImage: product.image,
        price: product.price,
        quantity: quantity,
        maxQuantity: product.stock > 0 ? product.stock : 999,
        brand: product.brand,
        category: product.category,
        sku: product.sku,
        originalPrice: product.originalPrice ?? product.price,
        discountPercentage: product.discountPercentage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.shopping_cart, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$quantity ${product.title} added to cart!',
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
      debugPrint('[ProductDetailPage] Error adding to cart for roshdology123: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add to cart. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleFavorite(BuildContext context, Product product) async {
    debugPrint('[ProductDetailPage] Toggling favorite for product ${product.id} by roshdology123 at 2025-06-22 12:49:05');

    try {
      final favoritesCubit = context.read<FavoritesCubit>();

      final wasAlreadyFavorite = favoritesCubit.currentFavorites.any(
              (favorite) => favorite.productId == product.id
      );

      _showImmediateFavoriteFeedback(context, product, !wasAlreadyFavorite);

      final isNowFavorite = await favoritesCubit.toggleFavorite(
        product,
        enablePriceTracking: false,
      );

      if (isNowFavorite != !wasAlreadyFavorite) {
        _showCorrectionFavoriteFeedback(context, product, isNowFavorite);
      }

    } catch (e) {
      debugPrint('[ProductDetailPage] Error toggling favorite for roshdology123: $e');

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

  void _showImmediateFavoriteFeedback(BuildContext context, Product product, bool isBeingAdded) {
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

  void _showCorrectionFavoriteFeedback(BuildContext context, Product product, bool actualState) {
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
}