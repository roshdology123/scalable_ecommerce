import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/favorite_item.dart';

class FavoriteProductCard extends StatefulWidget {
  final FavoriteItem favoriteItem;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCartTap;
  final VoidCallback? onToggleSelection;

  const FavoriteProductCard({
    super.key,
    required this.favoriteItem,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onTap,
    this.onLongPress,
    this.onFavoriteTap,
    this.onAddToCartTap,
    this.onToggleSelection,
  });

  @override
  State<FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<FavoriteProductCard>
    with TickerProviderStateMixin {

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-22 12:14:02';

  late AnimationController _pulseController;
  late AnimationController _selectionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _selectionAnimation;
  late Animation<Color?> _selectionColorAnimation;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // 🔥 Initialize controllers without Theme.of() calls
    _initializeControllers();

    debugPrint('[FavoriteProductCard] Initialized for product ${widget.favoriteItem.productId} by $_userContext at $_currentTimestamp');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔥 Initialize animations here when Theme is available
    if (!_isInitialized) {
      _initializeAnimations();
      _isInitialized = true;
    }
  }

  void _initializeControllers() {
    // Initialize animation controllers without theme-dependent values
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Basic animations without colors
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _selectionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeAnimations() {
    // 🔥 Initialize theme-dependent animations in didChangeDependencies
    final theme = Theme.of(context);

    _selectionColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: theme.colorScheme.primary.withOpacity(0.2),
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOut,
    ));

    // Set initial animation states
    if (widget.isSelectionMode) {
      _selectionController.forward();
    }

    // Start pulse animation if item has price tracking
    if (widget.favoriteItem.isPriceTrackingEnabled) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FavoriteProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle selection mode changes
    if (widget.isSelectionMode != oldWidget.isSelectionMode) {
      if (widget.isSelectionMode) {
        _selectionController.forward();
      } else {
        _selectionController.reverse();
      }
    }

    // Handle selection state changes
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _selectionController.forward();
      } else if (!widget.isSelectionMode) {
        _selectionController.reverse();
      }
    }

    // Handle price tracking animation
    if (widget.favoriteItem.isPriceTrackingEnabled != oldWidget.favoriteItem.isPriceTrackingEnabled) {
      if (widget.favoriteItem.isPriceTrackingEnabled) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Return a simple card while waiting for initialization
      return _buildSimpleCard(context);
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _selectionController]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.favoriteItem.isPriceTrackingEnabled ? _pulseAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _selectionColorAnimation.value,
              border: widget.isSelected
                  ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
                  : null,
            ),
            child: Card(
              elevation: widget.isSelected ? 8 : 2,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: widget.isSelectionMode ? widget.onToggleSelection : widget.onTap,
                onLongPress: widget.onLongPress,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image
                        Expanded(
                          flex: 3,
                          child: _buildProductImage(context),
                        ),

                        // Product information
                        Expanded(
                          flex: 2,
                          child: _buildProductInfo(context),
                        ),
                      ],
                    ),

                    // Selection overlay
                    if (widget.isSelectionMode)
                      _buildSelectionOverlay(context),

                    // Selection checkbox
                    if (widget.isSelectionMode)
                      _buildSelectionCheckbox(context),

                    // Price tracking indicator
                    if (widget.favoriteItem.isPriceTrackingEnabled)
                      _buildPriceTrackingIndicator(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimpleCard(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.isSelectionMode ? widget.onToggleSelection : widget.onTap,
        onLongPress: widget.onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple product image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.favoriteItem.productImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            // Simple product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.favoriteItem.productTitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '\$${widget.favoriteItem.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
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

  Widget _buildProductImage(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: widget.favoriteItem.productImage,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: context.colorScheme.surfaceVariant,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: context.colorScheme.surfaceVariant,
            child: Icon(
              Icons.image_not_supported,
              color: context.colorScheme.onSurfaceVariant,
              size: 48,
            ),
          ),
        ),

        // Gradient overlay for badges
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Favorite button (only visible when not in selection mode)
        if (!widget.isSelectionMode)
          Positioned(
            top: 8,
            right: 8,
            child: _buildFavoriteButton(context),
          ),

        // Date added badge
        Positioned(
          top: 8,
          left: 8,
          child: _buildDateBadge(context),
        ),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product title
          Text(
            widget.favoriteItem.productTitle,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Notes (if any)
          if (widget.favoriteItem.notes != null && widget.favoriteItem.notes!.isNotEmpty) ...[
            Text(
              widget.favoriteItem.notes!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
          ],

          const Spacer(),

          // Price and actions
          Row(
            children: [
              Expanded(
                child: _buildPriceInfo(context),
              ),

              if (!widget.isSelectionMode) ...[
                const SizedBox(width: 8),
                _buildAddToCartButton(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$${widget.favoriteItem.price.toStringAsFixed(2)}',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),

        // Price tracking info
        if (widget.favoriteItem.isPriceTrackingEnabled && widget.favoriteItem.targetPrice != null)
          Text(
            'Target: \$${widget.favoriteItem.targetPrice!.toStringAsFixed(2)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.secondary,
            ),
          ),
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 20,
        ),
        onPressed: () {
          debugPrint('[FavoriteProductCard] Favorite button tapped for product ${widget.favoriteItem.productId} by $_userContext at $_currentTimestamp');
          widget.onFavoriteTap?.call();
        },
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        tooltip: 'favorites.remove_from_favorites'.tr(),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(
          Icons.add_shopping_cart,
          color: context.colorScheme.onPrimary,
          size: 16,
        ),
        onPressed: () {
          debugPrint('[FavoriteProductCard] Add to cart button tapped for product ${widget.favoriteItem.productId} by $_userContext at $_currentTimestamp');
          widget.onAddToCartTap?.call();
        },
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minWidth: 28,
          minHeight: 28,
        ),
        tooltip: 'products.add_to_cart'.tr(),
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context) {
    final daysAgo = DateTime.now().difference(widget.favoriteItem.addedAt).inDays;

    if (daysAgo <= 7) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          daysAgo == 0 ? 'Today' : '${daysAgo}d ago',
          style: context.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSelectionOverlay(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _selectionAnimation,
        builder: (context, child) {
          return Container(
            color: Colors.black.withOpacity(0.1 * _selectionAnimation.value),
          );
        },
      ),
    );
  }

  Widget _buildSelectionCheckbox(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: AnimatedBuilder(
        animation: _selectionAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _selectionAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Checkbox(
                value: widget.isSelected,
                onChanged: (_) => widget.onToggleSelection?.call(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceTrackingIndicator(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.track_changes,
              size: 12,
              color: context.colorScheme.onSecondary,
            ),
            const SizedBox(width: 2),
            Text(
              'Price Alert',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}