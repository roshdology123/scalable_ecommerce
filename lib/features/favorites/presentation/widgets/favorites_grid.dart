import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/favorite_item.dart';
import 'favorite_product_card.dart';

class FavoritesGrid extends StatefulWidget {
  final List<FavoriteItem> favorites;
  final bool isGridView;
  final bool isSelectionMode;
  final List<String> selectedIds;
  final Function(String) onFavoriteToggle;
  final Function(String) onFavoriteTap;
  final Function(String) onFavoriteLongPress;
  final ScrollController? scrollController;

  const FavoritesGrid({
    super.key,
    required this.favorites,
    required this.isGridView,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.onFavoriteToggle,
    required this.onFavoriteTap,
    required this.onFavoriteLongPress,
    this.scrollController,
  });

  @override
  State<FavoritesGrid> createState() => _FavoritesGridState();
}

class _FavoritesGridState extends State<FavoritesGrid>
    with TickerProviderStateMixin {

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:06:23Z';
  final AppLogger _logger = AppLogger();

  late AnimationController _staggerController;
  List<Animation<double>> _itemAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _staggerController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.favorites.length * 50)),
      vsync: this,
    );

    _createItemAnimations();
    _staggerController.forward();
  }

  void _createItemAnimations() {
    _itemAnimations.clear();

    for (int i = 0; i < widget.favorites.length; i++) {
      final start = (i * 0.1).clamp(0.0, 1.0);
      final end = ((i * 0.1) + 0.3).clamp(0.0, 1.0);

      _itemAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(FavoritesGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.favorites.length != widget.favorites.length) {
      _createItemAnimations();
      _staggerController.reset();
      _staggerController.forward();
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.favorites.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return widget.isGridView
        ? _buildStaggeredGrid()
        : _buildListView();
  }

  Widget _buildStaggeredGrid() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: _getCrossAxisCount(context),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: widget.favorites.length,
          itemBuilder: (context, index) {
            final favorite = widget.favorites[index];
            final isSelected = widget.selectedIds.contains(favorite.id);

            return AnimatedBuilder(
              animation: index < _itemAnimations.length
                  ? _itemAnimations[index]
                  : AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                final animation = index < _itemAnimations.length
                    ? _itemAnimations[index]
                    : AlwaysStoppedAnimation(1.0);

                return Transform.translate(
                  offset: Offset(0, 50 * (1 - animation.value)),
                  child: Opacity(
                    opacity: animation.value,
                    child: FavoriteProductCard(
                      favorite: favorite,
                      isSelected: isSelected,
                      isSelectionMode: widget.isSelectionMode,
                      onTap: () => widget.onFavoriteTap(favorite.id),
                      onLongPress: () => widget.onFavoriteLongPress(favorite.id),
                      onToggleSelection: () => widget.onFavoriteToggle(favorite.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final favorite = widget.favorites[index];
          final isSelected = widget.selectedIds.contains(favorite.id);

          return AnimatedBuilder(
            animation: index < _itemAnimations.length
                ? _itemAnimations[index]
                : const AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              final animation = index < _itemAnimations.length
                  ? _itemAnimations[index]
                  : const AlwaysStoppedAnimation(1.0);

              return Transform.translate(
                offset: Offset(100 * (1 - animation.value), 0),
                child: Opacity(
                  opacity: animation.value,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      index == widget.favorites.length - 1 ? 16 : 8,
                    ),
                    child: FavoriteProductCard(
                      favorite: favorite,
                      isSelected: isSelected,
                      isSelectionMode: widget.isSelectionMode,
                      isListView: true,
                      onTap: () => widget.onFavoriteTap(favorite.id),
                      onLongPress: () => widget.onFavoriteLongPress(favorite.id),
                      onToggleSelection: () => widget.onFavoriteToggle(favorite.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
        childCount: widget.favorites.length,
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }
}