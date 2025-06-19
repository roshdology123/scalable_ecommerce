import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/favorites_collection.dart';
import '../cubit/favorites_collections/favorites_collection_cubit.dart';
import '../cubit/favorites_collections/favorites_collection_state.dart';
import '../widgets/favorite_collection_card.dart';
import '../widgets/create_collection_dialog.dart';

class FavoritesCollectionsPage extends StatefulWidget {
  const FavoritesCollectionsPage({super.key});

  @override
  State<FavoritesCollectionsPage> createState() => _FavoritesCollectionsPageState();
}

class _FavoritesCollectionsPageState extends State<FavoritesCollectionsPage>
    with TickerProviderStateMixin {

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:25:19Z';
  final AppLogger _logger = AppLogger();

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCollections();

    _logger.logUserAction('collections_page_opened', {
      'user': _userContext,
      'timestamp': _currentTimestamp,
    });
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _fabAnimationController.forward();
  }

  void _loadCollections() {
    context.read<FavoritesCollectionsCubit>().loadCollections();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _scrollController.dispose();

    _logger.logUserAction('collections_page_closed', {
      'user': _userContext,
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCollectionsCubit>.value(
      value: getIt<FavoritesCollectionsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Collections'),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _showCreateCollectionDialog,
              icon: const Icon(Icons.add),
              tooltip: 'Create collection',
            ),
          ],
        ),
        body: BlocConsumer<FavoritesCollectionsCubit, FavoritesCollectionsState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: CircularProgressIndicator(),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              loaded: (collections, smartCollections, selectedCollection, isCreating, isEditing) {
                return _buildCollectionsContent(
                  context,
                  collections,
                  smartCollections,
                );
              },
              error: (message, code) => _buildErrorState(context, message, code),
              creating: () => const Center(
                child: CircularProgressIndicator(),
              ),
              editing: (collection) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        floatingActionButton: ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton.extended(
            onPressed: _showCreateCollectionDialog,
            icon: const Icon(Icons.add),
            label: const Text('New Collection'),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionsContent(
      BuildContext context,
      List<FavoritesCollection> collections,
      List<FavoritesCollection> smartCollections,
      ) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Smart Collections Section
        if (smartCollections.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Smart Collections',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final collection = smartCollections[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    index % 2 == 0 ? 16 : 0,
                    0,
                    index % 2 == 1 ? 16 : 0,
                    0,
                  ),
                  child: FavoriteCollectionCard(
                    collection: collection,
                    onTap: () => _navigateToCollection(collection),
                  ),
                );
              },
              childCount: smartCollections.length,
            ),
          ),
        ],

        // User Collections Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                Icon(
                  Icons.folder,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'My Collections',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${collections.length} collections',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // User Collections Grid
        if (collections.isEmpty)
          SliverToBoxAdapter(
            child: _buildEmptyCollections(context),
          )
        else
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final collection = collections[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    index % 2 == 0 ? 16 : 0,
                    0,
                    index % 2 == 1 ? 16 : 0,
                    index == collections.length - 1 ||
                        index == collections.length - 2 ? 100 : 0,
                  ),
                  child: FavoriteCollectionCard(
                    collection: collection,
                    onTap: () => _navigateToCollection(collection),
                    onEdit: () => _editCollection(collection),
                    onDelete: () => _deleteCollection(collection),
                  ),
                );
              },
              childCount: collections.length,
            ),
          ),

        // Bottom spacing for FAB
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildEmptyCollections(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer.withOpacity(0.3),
            ),
            child: Icon(
              Icons.folder_open,
              size: 40,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Collections Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Create collections to organize your favorites by theme, occasion, or any way you like.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _showCreateCollectionDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Collection'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, String? code) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to Load Collections',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (code != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error code: $code',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _loadCollections,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _handleStateChanges(BuildContext context, FavoritesCollectionsState state) {
    state.maybeWhen(
      error: (message, code) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadCollections,
            ),
          ),
        );
      },
      orElse: () {},
    );
  }

  void _showCreateCollectionDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateCollectionDialog(
        onCollectionCreated: (name, description, icon, color) {
          context.read<FavoritesCollectionsCubit>().createCollection(
            name: name,
            description: description,
            icon: icon,
            color: color,
          );

          _logger.logUserAction('collection_create_started', {
            'user': _userContext,
            'collection_name': name,
            'timestamp': _currentTimestamp,
          });
        },
      ),
    );
  }

  void _navigateToCollection(FavoritesCollection collection) {
    Navigator.of(context).pushNamed(
      '/favorites',
      arguments: {'collectionId': collection.id},
    );

    _logger.logUserAction('collection_opened', {
      'user': _userContext,
      'collection_id': collection.id,
      'collection_name': collection.name,
      'is_smart_collection': collection.isSmartCollection,
    });
  }

  void _editCollection(FavoritesCollection collection) {
    context.read<FavoritesCollectionsCubit>().startEditingCollection(collection);

    _logger.logUserAction('collection_edit_started', {
      'user': _userContext,
      'collection_id': collection.id,
      'collection_name': collection.name,
    });
  }

  void _deleteCollection(FavoritesCollection collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text(
          'Are you sure you want to delete "${collection.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete collection

              _logger.logUserAction('collection_delete_confirmed', {
                'user': _userContext,
                'collection_id': collection.id,
                'collection_name': collection.name,
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}