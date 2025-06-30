import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/favorites_collection.dart';

class FavoriteCollectionCard extends StatefulWidget {
  final FavoritesCollection collection;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FavoriteCollectionCard({
    super.key,
    required this.collection,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<FavoriteCollectionCard> createState() => _FavoriteCollectionCardState();
}

class _FavoriteCollectionCardState extends State<FavoriteCollectionCard>
    with TickerProviderStateMixin {

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:28:48Z';
  final AppLogger _logger = AppLogger();

  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _setHovered(true),
            onExit: (_) => _setHovered(false),
            child: GestureDetector(
              onTap: widget.onTap,
              onLongPress: widget.onEdit,
              child: Container(
                decoration: BoxDecoration(
                  color: _getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getBorderColor(context),
                    width: widget.collection.isSmartCollection ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Gradient overlay for smart collections
                    if (widget.collection.isSmartCollection)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary.withOpacity(0.1),
                                colorScheme.tertiary.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row
                          Row(
                            children: [
                              // Collection icon
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getIconBackgroundColor(context),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.collection.displayIcon ?? '📁',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),

                              const Spacer(),

                              // Smart collection indicator
                              if (widget.collection.isSmartCollection)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'SMART',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),

                              // Actions menu
                              if (!widget.collection.isSmartCollection && !widget.collection.isDefault)
                                PopupMenuButton<String>(
                                  onSelected: _handleMenuAction,
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit'),
                                        dense: true,
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete'),
                                        dense: true,
                                      ),
                                    ),
                                  ],
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 16,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Collection name
                          Text(
                            widget.collection.displayName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Description
                          if (widget.collection.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.collection.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          const Spacer(),

                          // Footer
                          Row(
                            children: [
                              // Item count
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${widget.collection.itemCount} items',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Last updated
                              if (widget.collection.age.inDays < 7)
                                Text(
                                  _getAgeText(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tap indicator
                    if (_isHovered)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.collection.color != null) {
      // Parse hex color if provided
      try {
        final colorValue = int.parse(widget.collection.color!.replaceFirst('#', ''), radix: 16);
        return Color(colorValue).withOpacity(0.1);
      } catch (e) {
        // Fallback to default
      }
    }

    return colorScheme.surface;
  }

  Color _getBorderColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.collection.isSmartCollection) {
      return colorScheme.primary.withOpacity(0.3);
    }

    return colorScheme.outline.withOpacity(0.2);
  }

  Color _getIconBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.collection.isSmartCollection) {
      return colorScheme.primaryContainer.withOpacity(0.5);
    }

    return colorScheme.surfaceContainerHighest.withOpacity(0.5);
  }

  String _getAgeText() {
    final age = widget.collection.age;

    if (age.inDays == 0) {
      if (age.inHours == 0) {
        return 'Just now';
      }
      return '${age.inHours}h ago';
    } else if (age.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${age.inDays}d ago';
    }
  }

  void _setHovered(bool hovered) {
    setState(() {
      _isHovered = hovered;
    });

    if (hovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _handleMenuAction(String action) {
    _logger.logUserAction('collection_menu_action', {
      'user': _userContext,
      'action': action,
      'collection_id': widget.collection.id,
      'collection_name': widget.collection.name,
      'timestamp': _currentTimestamp,
    });

    switch (action) {
      case 'edit':
        widget.onEdit?.call();
        break;
      case 'delete':
        widget.onDelete?.call();
        break;
    }
  }
}