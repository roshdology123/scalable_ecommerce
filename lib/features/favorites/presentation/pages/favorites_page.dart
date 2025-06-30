import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/favorite_item.dart';
import '../cubit/favorites_collections/favorites_collection_cubit.dart';
import '../cubit/favorites_cubit/favorites_cubit.dart';
import '../cubit/favorites_cubit/favorites_state.dart';

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
  static const String _currentTimestamp = '2025-06-22 12:29:28';

  final AppLogger _logger = AppLogger();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _fabAnimationController;
  late AnimationController _selectionAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _selectionSlideAnimation;

  bool _showScrollToTop = false;
  String _searchQuery = '';
  final Map<String, dynamic> _currentFilters = {};

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
    debugPrint('[FavoritesPage] Loading initial data for roshdology123 at $_currentTimestamp');

    try {
      // Load favorites and collections with error handling
      final favoritesCubit = context.read<FavoritesCubit>();
      final collectionsCubit = context.read<FavoritesCollectionsCubit>();

      favoritesCubit.loadFavorites(
        collectionId: widget.initialCollectionId,
        category: widget.initialCategory,
      );
      collectionsCubit.loadCollections();

      _logger.logUserAction('favorites_initial_load_started', {
        'user': _userContext,
        'timestamp': _currentTimestamp,
        'favorites_count': favoritesCubit.currentFavorites.length,
      });
    } catch (e) {
      debugPrint('[FavoritesPage] Error loading initial data: $e');
      _logger.logErrorWithContext(
        'FavoritesPage._loadInitialData',
        e,
        StackTrace.current,
        {'user': _userContext},
      );
    }
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
      try {
        context.read<FavoritesCubit>().refresh();
        _logger.logUserAction('favorites_page_resumed', {
          'user': _userContext,
          'timestamp': _currentTimestamp,
        });
      } catch (e) {
        debugPrint('[FavoritesPage] Error on resume: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[FavoritesPage] Building favorites page for roshdology123 at $_currentTimestamp');

    return Scaffold(
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          debugPrint('[FavoritesPage] Current favorites state: ${state.runtimeType} for roshdology123');

          return SafeArea(
            top: false,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Simple App Bar (avoiding complex custom widgets that might cause null errors)
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  title: const Text(
                    'Favorites',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: _navigateToProducts,
                      icon: const Icon(Icons.add, color: Colors.white),
                      tooltip: 'Browse Products',
                    ),
                    IconButton(
                      onPressed: _navigateToCollections,
                      icon: const Icon(Icons.folder, color: Colors.white),
                      tooltip: 'Collections',
                    ),
                  ],
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search favorites...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      onChanged: _handleSearchChanged,
                    ),
                  ),
                ),

                // Content based on state
                _buildContent(context, state),

                // Bottom padding for FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          );
        },
      ),

      // Floating Action Button
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildContent(BuildContext context, FavoritesState state) {
    return state.when(
      initial: () {
        debugPrint('[FavoritesPage] State: initial - loading favorites for roshdology123');
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(64),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your favorites...'),
                ],
              ),
            ),
          ),
        );
      },
      loading: () {
        debugPrint('[FavoritesPage] State: loading for roshdology123');
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(64),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading favorites...'),
                ],
              ),
            ),
          ),
        );
      },
      loaded: (favorites, totalCount, searchQuery, category, sortBy, sortOrder,
          isGridView, isSelectionMode, selectedIds, filters) {
        debugPrint('[FavoritesPage] State: loaded with ${favorites.length} favorites for roshdology123');

        if (favorites.isEmpty) {
          return _buildEmptyState(context, searchQuery, filters);
        }

        return _buildFavoritesList(context, favorites, isGridView ?? true);
      },
      empty: (searchQuery, category, filters) {
        debugPrint('[FavoritesPage] State: empty for roshdology123');
        return _buildEmptyState(context, searchQuery, filters);
      },
      error: (message, code, searchQuery, category) {
        debugPrint('[FavoritesPage] State: error - $message for roshdology123');
        return _buildErrorState(context, message, code);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String? searchQuery, Map<String, dynamic>? filters) {
    final hasSearch = searchQuery?.isNotEmpty ?? false;
    final hasFilters = filters?.isNotEmpty ?? false;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearch || hasFilters ? Icons.search_off : Icons.favorite_border,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch || hasFilters
                  ? 'No favorites found'
                  : 'No favorites yet',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch || hasFilters
                  ? 'Try adjusting your search or filters'
                  : 'Start adding products to your favorites',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (hasSearch || hasFilters)
              FilledButton.icon(
                onPressed: _clearAllFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Clear Filters'),
              )
            else
              FilledButton.icon(
                onPressed: _navigateToProducts,
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Browse Products'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, String? code) {
    return SliverToBoxAdapter(
      child: Container(
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
              'Something went wrong',
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
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, List<FavoriteItem> favorites, bool isGridView) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: isGridView
          ? SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final favorite = favorites[index];
            return _buildFavoriteCard(context, favorite);
          },
          childCount: favorites.length,
        ),
      )
          : SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final favorite = favorites[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildFavoriteListItem(context, favorite),
            );
          },
          childCount: favorites.length,
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, FavoriteItem favorite) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToProductDetails(favorite.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: favorite.productImage.isNotEmpty == true
                    ? Image.network(
                  favorite.productImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    );
                  },
                )
                    : Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.productTitle ?? 'Unknown Product',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '\$${favorite.price!.toStringAsFixed(2)}',
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

  Widget _buildFavoriteListItem(BuildContext context, FavoriteItem favorite) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: favorite.productImage.isNotEmpty == true
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              favorite.productImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                );
              },
            ),
          )
              : Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          favorite.productTitle ?? 'Unknown Product',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: favorite.price != null
            ? Text('\$${favorite.price.toStringAsFixed(2)}')
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _navigateToProductDetails(favorite.id),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _navigateToProducts,
      icon: const Icon(Icons.add),
      label: const Text('Browse Products'),
    );
  }

  // Helper methods
  void _handleStateChanges(BuildContext context, FavoritesState state) {
    state.maybeWhen(
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
        try {
          context.read<FavoritesCubit>().searchFavorites(query);
          _logger.logUserAction('favorites_search', {
            'user': _userContext,
            'query': query,
            'query_length': query.length,
          });
        } catch (e) {
          debugPrint('[FavoritesPage] Error searching: $e');
        }
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _handleSearchChanged('');
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters.clear();
      _searchQuery = '';
    });
    _searchController.clear();
    try {
      context.read<FavoritesCubit>().applyFilters({});
    } catch (e) {
      debugPrint('[FavoritesPage] Error clearing filters: $e');
    }
  }

  void _retry() {
    debugPrint('[FavoritesPage] Retrying favorites load for roshdology123 at $_currentTimestamp');
    try {
      context.read<FavoritesCubit>().refresh();
      _logger.logUserAction('favorites_retry', {
        'user': _userContext,
        'timestamp': _currentTimestamp,
      });
    } catch (e) {
      debugPrint('[FavoritesPage] Error on retry: $e');
    }
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
    try {
      final favorite = context.read<FavoritesCubit>().currentFavorites
          .cast<FavoriteItem?>()
          .firstWhere(
            (f) => f?.id == favoriteId,
        orElse: () => null,
      );

      if (favorite?.productId != null) {
        context.push('/home/product/${favorite!.productId}');
        _logger.logUserAction('navigate_to_product_details', {
          'user': _userContext,
          'product_id': favorite.productId,
          'favorite_id': favoriteId,
          'from_page': 'favorites',
        });
      }
    } catch (e) {
      debugPrint('[FavoritesPage] Error navigating to product details: $e');
    }
  }
}