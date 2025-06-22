import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/favorite_item.dart';
import '../cubit/favorites_collections/favorites_collection_cubit.dart';
import '../cubit/favorites_cubit/favorites_cubit.dart';
import '../cubit/favorites_cubit/favorites_state.dart';
import '../widgets/favorite_search_bar.dart';
import '../widgets/favorites_app_bar.dart';
import '../widgets/favorites_batch_icon.dart';
import '../widgets/favorites_filter_chips.dart';
import '../widgets/favorites_grid.dart';
import '../widgets/favorites_empty_state.dart';
import '../widgets/favorites_shimmer_loading.dart';
import '../widgets/favorites_action_bar.dart';
import '../widgets/favorites_sort_bottom_sheet.dart';
import '../widgets/favorites_filter_bottom_sheet.dart';

class FavoritesPage extends StatefulWidget {
  final String? initialCollectionId;
  final String? initialCategory;

  const FavoritesPage({
    super.key,
    this.initialCollectionId,
    this.initialCategory,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:02:59Z';

  final AppLogger _logger = AppLogger();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _fabAnimationController;
  late AnimationController _selectionAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _selectionSlideAnimation;

  bool _showScrollToTop = false;
  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeAnimations();
    _setupScrollListener();
    _loadInitialData();

    _logger.logUserAction('favorites_page_opened', {
      'user': _userContext,
      'timestamp': _currentTimestamp,
      'initial_collection_id': widget.initialCollectionId,
      'initial_category': widget.initialCategory,
    });
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _selectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _selectionSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _selectionAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final showScrollToTop = _scrollController.offset > 400;
      if (showScrollToTop != _showScrollToTop) {
        setState(() {
          _showScrollToTop = showScrollToTop;
        });

        if (showScrollToTop) {
          _fabAnimationController.forward();
        } else {
          _fabAnimationController.reverse();
        }
      }
    });
  }

  void _loadInitialData() {
    // Load favorites and collections
    context.read<FavoritesCubit>().loadFavorites(
      collectionId: widget.initialCollectionId,
      category: widget.initialCategory,
    );
    context.read<FavoritesCollectionsCubit>().loadCollections();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _searchController.dispose();
    _fabAnimationController.dispose();
    _selectionAnimationController.dispose();

    _logger.logUserAction('favorites_page_closed', {
      'user': _userContext,
      'session_duration': 'calculated_in_real_app',
    });

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Refresh favorites when app comes back to foreground
      context.read<FavoritesCubit>().refresh();

      _logger.logUserAction('favorites_page_resumed', {
        'user': _userContext,
        'timestamp': _currentTimestamp,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesCubit>.value(
          value: getIt<FavoritesCubit>(),
        ),
        BlocProvider<FavoritesCollectionsCubit>.value(
          value: getIt<FavoritesCollectionsCubit>(),
        ),
      ],
      child: Scaffold(
        body: BlocConsumer<FavoritesCubit, FavoritesState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: _getAppBarHeight(state),
                  stretch: true,
                  floating: true,
                  pinned: true,
                  snap: false,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    title: FavoritesAppBar(
                      searchController: _searchController,
                      onSearchChanged: _handleSearchChanged,
                      onFilterTap: _showFilterBottomSheet,
                      onSortTap: _showSortBottomSheet,
                      onViewModeToggle: _handleViewModeToggle,
                      onCollectionsTap: _navigateToCollections,
                    ),
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                ),

                // Search Bar (visible when not in selection mode)
                if (!_isSelectionMode(state))
                  SliverToBoxAdapter(
                    child: FavoritesSearchBar(
                      controller: _searchController,
                      onChanged: _handleSearchChanged,
                      onClear: _clearSearch,
                    ),
                  ),

                // Filter Chips
                if (_hasActiveFilters() || _searchQuery.isNotEmpty)
                  SliverToBoxAdapter(
                    child: FavoritesFilterChips(
                      searchQuery: _searchQuery,
                      filters: _currentFilters,
                      onFilterRemoved: _removeFilter,
                      onClearAll: _clearAllFilters,
                    ),
                  ),

                // Action Bar (selection mode)
                if (_isSelectionMode(state))
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _selectionSlideAnimation,
                      child: FavoritesActionBar(
                        selectedCount: _getSelectedCount(state),
                        onSelectAll: _selectAll,
                        onClearSelection: _clearSelection,
                        onExitSelectionMode: _exitSelectionMode,
                      ),
                    ),
                  ),

                // Content
                _buildContent(context, state),

                // Bottom padding for FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            );
          },
        ),

        // Floating Action Buttons
        floatingActionButton: _buildFloatingActionButtons(context),

        // Batch Actions (selection mode)
        bottomSheet: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (_isSelectionMode(state) && _getSelectedCount(state) > 0) {
              return FavoritesBatchActions(
                selectedCount: _getSelectedCount(state),
                onDelete: _deleteSelected,
                onAddToCollection: _addSelectedToCollection,
                onShare: _shareSelected,
                onExport: _exportSelected,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoritesState state) {
    return state.when(
      initial: () => const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      ),
      loading: () => const SliverToBoxAdapter(
        child: FavoritesShimmerLoading(),
      ),
      loaded: (favorites, totalCount, searchQuery, category, sortBy, sortOrder,
          isGridView, isSelectionMode, selectedIds, filters) {
        return FavoritesGrid(
          favorites: favorites,
          isGridView: isGridView,
          isSelectionMode: isSelectionMode,
          selectedIds: selectedIds,
          onFavoriteToggle: _toggleFavoriteSelection,
          onFavoriteTap: _handleFavoriteTap,
          onFavoriteLongPress: _handleFavoriteLongPress,
          scrollController: _scrollController,
        );
      },
      empty: (searchQuery, category, filters) => SliverToBoxAdapter(
        child: FavoritesEmptyState(
          hasSearch: searchQuery.isNotEmpty,
          hasFilters: filters?.isNotEmpty ?? false,
          onClearFilters: _clearAllFilters,
          onExploreProducts: _navigateToProducts,
        ),
      ),
      error: (message, code, searchQuery, category) => SliverToBoxAdapter(
        child: _buildErrorState(context, message, code),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, String? code) {
    return Container(
      padding: const EdgeInsets.all(32),
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
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (code != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error code: $code',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _retry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scroll to top FAB
        if (_showScrollToTop)
          ScaleTransition(
            scale: _fabScaleAnimation,
            child: FloatingActionButton.small(
              onPressed: _scrollToTop,
              heroTag: 'scroll_to_top',
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),

        if (_showScrollToTop) const SizedBox(height: 16),

        // Main FAB
        FloatingActionButton.extended(
          onPressed: _navigateToProducts,
          icon: const Icon(Icons.add),
          label: const Text('Browse Products'),
          heroTag: 'browse_products',
        ),
      ],
    );
  }

  // Helper methods
  double _getAppBarHeight(FavoritesState state) {
    return state.maybeWhen(
      loaded: (_, __, ___, ____, _____, ______, _______, isSelectionMode, ________, _________) {
        return isSelectionMode ? 120 : 180;
      },
      orElse: () => 180,
    );
  }

  bool _isSelectionMode(FavoritesState state) {
    return state.maybeWhen(
      loaded: (_, __, ___, ____, _____, ______, _______, isSelectionMode, ________, _________) => isSelectionMode,
      orElse: () => false,
    );
  }

  int _getSelectedCount(FavoritesState state) {
    return state.maybeWhen(
      loaded: (_, __, ___, ____, _____, ______, _______, ________, selectedIds, _________) => selectedIds.length,
      orElse: () => 0,
    );
  }

  bool _hasActiveFilters() {
    return _currentFilters.isNotEmpty;
  }

  // Event handlers
  void _handleStateChanges(BuildContext context, FavoritesState state) {
    state.maybeWhen(
      loaded: (_, __, ___, ____, _____, ______, _______, isSelectionMode, ________, _________) {
        if (isSelectionMode) {
          _selectionAnimationController.forward();
        } else {
          _selectionAnimationController.reverse();
        }
      },
      error: (message, code, _, __) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _retry,
            ),
          ),
        );
      },
      orElse: () {},
    );
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchQuery == query && mounted) {
        context.read<FavoritesCubit>().searchFavorites(query);

        _logger.logUserAction('favorites_search', {
          'user': _userContext,
          'query': query,
          'query_length': query.length,
        });
      }
    });
  }

  void _handleViewModeToggle() {
    context.read<FavoritesCubit>().toggleViewMode();

    _logger.logUserAction('favorites_view_mode_toggled', {
      'user': _userContext,
      'timestamp': _currentTimestamp,
    });
  }

  void _handleFavoriteTap(String favoriteId) {
    final cubit = context.read<FavoritesCubit>();

    if (cubit.isSelectionMode) {
      cubit.toggleFavoriteSelection(favoriteId);
    } else {
      // Navigate to product details
      _navigateToProductDetails(favoriteId);
    }
  }

  void _handleFavoriteLongPress(String favoriteId) {
    final cubit = context.read<FavoritesCubit>();

    if (!cubit.isSelectionMode) {
      cubit.toggleSelectionMode();
    }
    cubit.toggleFavoriteSelection(favoriteId);

    // Haptic feedback
    HapticFeedback.selectionClick();

    _logger.logUserAction('favorite_long_pressed', {
      'user': _userContext,
      'favorite_id': favoriteId,
    });
  }

  void _toggleFavoriteSelection(String favoriteId) {
    context.read<FavoritesCubit>().toggleFavoriteSelection(favoriteId);
  }

  void _selectAll() {
    context.read<FavoritesCubit>().selectAllFavorites();
  }

  void _clearSelection() {
    context.read<FavoritesCubit>().clearSelection();
  }

  void _exitSelectionMode() {
    context.read<FavoritesCubit>().toggleSelectionMode();
  }

  void _clearSearch() {
    _searchController.clear();
    _handleSearchChanged('');
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _currentFilters.remove(filterKey);
    });
    context.read<FavoritesCubit>().applyFilters(_currentFilters);
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters.clear();
      _searchQuery = '';
    });
    _searchController.clear();
    context.read<FavoritesCubit>().applyFilters({});
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    _logger.logUserAction('favorites_scroll_to_top', {
      'user': _userContext,
    });
  }

  void _retry() {
    context.read<FavoritesCubit>().refresh();

    _logger.logUserAction('favorites_retry', {
      'user': _userContext,
      'timestamp': _currentTimestamp,
    });
  }

  // Navigation methods
  void _navigateToCollections() {
    context.push('/favorites/collections');

    _logger.logUserAction('navigate_to_collections', {
      'user': _userContext,
      'from_page': 'favorites',
    });
  }

  void _navigateToProducts() {
    context.push('/home');

    _logger.logUserAction('navigate_to_products', {
      'user': _userContext,
      'from_page': 'favorites',
    });
  }

  void _navigateToProductDetails(String favoriteId) {
    // Get the favorite item and navigate to its product details
    final favorite = context.read<FavoritesCubit>().currentFavorites
        .cast<FavoriteItem?>()
        .firstWhere(
          (f) => f?.id == favoriteId,
      orElse: () => null,
    );

    if (favorite != null) {
      Navigator.of(context).pushNamed(
        '/products/${favorite.productId}',
        arguments: {'from_favorites': true},
      );

      _logger.logUserAction('navigate_to_product_details', {
        'user': _userContext,
        'product_id': favorite.productId,
        'favorite_id': favoriteId,
        'from_page': 'favorites',
      });
    }
  }

  // Bottom sheet methods
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FavoritesFilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          context.read<FavoritesCubit>().applyFilters(filters);
        },
      ),
    );

    _logger.logUserAction('favorites_filter_opened', {
      'user': _userContext,
      'current_filters_count': _currentFilters.length,
    });
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FavoritesSortBottomSheet(
        currentSortBy: context.read<FavoritesCubit>().state.maybeWhen(
          loaded: (_, __, ___, ____, sortBy, _____, ______, _______, ________, _________) => sortBy,
          orElse: () => 'date_added',
        ),
        currentSortOrder: context.read<FavoritesCubit>().state.maybeWhen(
          loaded: (_, __, ___, ____, _____, sortOrder, ______, _______, ________, _________) => sortOrder,
          orElse: () => 'desc',
        ),
        onSortChanged: (sortBy, sortOrder) {
          context.read<FavoritesCubit>().changeSortOrder(sortBy, sortOrder);
        },
      ),
    );

    _logger.logUserAction('favorites_sort_opened', {
      'user': _userContext,
    });
  }

  // Batch action methods
  void _deleteSelected() {
    final selectedCount = _getSelectedCount(context.read<FavoritesCubit>().state);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Selected Favorites'),
        content: Text(
          'Are you sure you want to remove $selectedCount selected ${selectedCount == 1 ? 'favorite' : 'favorites'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FavoritesCubit>().removeSelectedFavorites();

              _logger.logUserAction('favorites_batch_delete_confirmed', {
                'user': _userContext,
                'deleted_count': selectedCount,
              });
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _addSelectedToCollection() {
    // Show collection selector bottom sheet
    _logger.logUserAction('favorites_add_to_collection_started', {
      'user': _userContext,
      'selected_count': _getSelectedCount(context.read<FavoritesCubit>().state),
    });
  }

  void _shareSelected() {
    _logger.logUserAction('favorites_share_started', {
      'user': _userContext,
      'selected_count': _getSelectedCount(context.read<FavoritesCubit>().state),
    });
  }

  void _exportSelected() {
    _logger.logUserAction('favorites_export_started', {
      'user': _userContext,
      'selected_count': _getSelectedCount(context.read<FavoritesCubit>().state),
    });
  }
}