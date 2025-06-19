import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/favorite_item.dart';

class FavoriteProductCard extends StatefulWidget {
  final FavoriteItem favorite;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isListView;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onToggleSelection;

  const FavoriteProductCard({
    super.key,
    required this.favorite,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.isListView = false,
    this.onTap,
    this.onLongPress,
    this.onToggleSelection,
  });

  @override
  State<FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<FavoriteProductCard>
    with TickerProviderStateMixin {

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:06:23Z';
  final AppLogger _logger = AppLogger();

  late AnimationController _selectionController;
  late AnimationController _pressController;
  late Animation<double> _selectionAnimation;
  late Animation<double> _pressAnimation;
  late Animation<Color?> _backgroundAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _selectionAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOut,
    ));

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _backgroundAnimation = ColorTween(
      begin: Colors.transparent,
      end: Theme.of(context).primaryColor.withOpacity(0.1),
    ).animate(_selectionController);
  }

  @override
  void didUpdateWidget(FavoriteProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _selectionController.forward();
      } else {
        _selectionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _selectionController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_selectionAnimation, _pressAnimation, _backgroundAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed ? _pressAnimation.value : _selectionAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),
            onTapCancel: _handleTapUp,
            child: Container(
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? colorScheme.primaryContainer.withOpacity(0.3)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.2),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: widget.isListView
                  ? _buildListCard(context)
                  : _buildGridCard(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image and selection indicator
        Stack(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: CachedNetworkImage(
                  imageUrl: widget.favorite.productImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: colorScheme.errorContainer.withOpacity(0.3),
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Selection Mode Overlay
            if (widget.isSelectionMode)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? colorScheme.primary.withOpacity(0.3)
                        : Colors.black.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Icon(
                      widget.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 32,
                      color: widget.isSelected ? colorScheme.primary : Colors.white,
                    ),
                  ),
                ),
              ),

            // Status badges
            Positioned(
              top: 8,
              left: 8,
              child: _buildStatusBadges(context),
            ),

            // Price change indicator
            if (widget.favorite.priceChangeIndicator.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: _buildPriceChangeIndicator(context),
              ),
          ],
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.favorite.productTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Category and Brand
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.favorite.category.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.favorite.brand != null) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.verified,
                      size: 12,
                      color: colorScheme.primary,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.favorite.rating.toStringAsFixed(1),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Price
              Row(
                children: [
                  Expanded(
                    child: _buildPriceSection(context),
                  ),
                  // Quick action button
                  IconButton(
                    onPressed: widget.isSelectionMode ? widget.onToggleSelection : null,
                    icon: Icon(
                      widget.isSelectionMode
                          ? (widget.isSelected ? Icons.check_circle : Icons.add_circle_outline)
                          : Icons.shopping_cart_outlined,
                      color: colorScheme.primary,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 120,
      child: Row(
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SizedBox(
                  width: 120,
                  height: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.favorite.productImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 32,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: colorScheme.errorContainer.withOpacity(0.3),
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 32,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Selection overlay
              if (widget.isSelectionMode)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? colorScheme.primary.withOpacity(0.3)
                          : Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(
                        widget.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 24,
                        color: widget.isSelected ? colorScheme.primary : Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.favorite.productTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Category and rating
                  Row(
                    children: [
                      Text(
                        widget.favorite.category.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.favorite.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Price and actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildPriceSection(context),
                      ),
                      if (widget.isSelectionMode)
                        IconButton(
                          onPressed: widget.onToggleSelection,
                          icon: Icon(
                            widget.isSelected ? Icons.check_circle : Icons.add_circle_outline,
                            color: colorScheme.primary,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadges(BuildContext context) {
    final theme = Theme.of(context);
    final badges = <Widget>[];

    if (!widget.favorite.inStock) {
      badges.add(_buildBadge(
        context,
        'OUT OF STOCK',
        theme.colorScheme.error,
        Colors.white,
      ));
    } else if (widget.favorite.isOnSale) {
      badges.add(_buildBadge(
        context,
        'SALE',
        theme.colorScheme.error,
        Colors.white,
      ));
    }

    if (widget.favorite.isNewFavorite) {
      badges.add(_buildBadge(
        context,
        'NEW',
        theme.colorScheme.tertiary,
        Colors.white,
      ));
    }

    if (badges.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: badges.map((badge) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: badge,
          )
      ).toList(),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildPriceChangeIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final indicator = widget.favorite.priceChangeIndicator;

    Color color;
    if (indicator == '↓') {
      color = Colors.green;
    } else if (indicator == '↑') {
      color = Colors.red;
    } else {
      color = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Text(
        indicator,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.favorite.isOnSale) ...[
          Text(
            widget.favorite.getFormattedOriginalPrice() ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Row(
          children: [
            Text(
              widget.favorite.getFormattedPrice(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.favorite.isOnSale ? colorScheme.error : colorScheme.onSurface,
              ),
            ),
            if (widget.favorite.isOnSale) ...[
              const SizedBox(width: 4),
              Text(
                widget.favorite.getFormattedDiscount(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _handleTapDown() {
    setState(() {
      _isPressed = true;
    });
    _pressController.forward();

    // Log interaction
    _logger.logUserAction('favorite_card_tap_down', {
      'user': _userContext,
      'favorite_id': widget.favorite.id,
      'product_id': widget.favorite.productId,
      'timestamp': _currentTimestamp,
    });
  }

  void _handleTapUp() {
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }
}