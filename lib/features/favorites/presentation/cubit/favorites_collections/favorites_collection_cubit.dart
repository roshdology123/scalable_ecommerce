import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/entities/favorites_collection.dart';
import '../../../domain/usecases/create_favorites_collection_usecase.dart';
import '../../../domain/usecases/get_favorites_collections_usecase.dart';
import '../../../domain/usecases/organize_favorites_usecase.dart';
import 'favorites_collection_state.dart';


@injectable
class FavoritesCollectionsCubit extends Cubit<FavoritesCollectionsState> {
  final GetFavoritesCollectionsUseCase _getCollectionsUseCase;
  final CreateFavoritesCollectionUseCase _createCollectionUseCase;
  final OrganizeFavoritesUseCase _organizeFavoritesUseCase;
  final AppLogger _logger = AppLogger();

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T12:53:51Z';

  FavoritesCollectionsCubit(
      this._getCollectionsUseCase,
      this._createCollectionUseCase,
      this._organizeFavoritesUseCase,
      ) : super(const FavoritesCollectionsState.initial());

  // Load collections
  Future<void> loadCollections() async {
    try {
      emit(const FavoritesCollectionsState.loading());

      _logger.logUserAction('load_collections_started', {
        'user': _userContext,
        'timestamp': _currentTimestamp,
      });

      final result = await _getCollectionsUseCase(const NoParams());

      result.fold(
            (failure) {
          _logger.logErrorWithContext(
            'FavoritesCollectionsCubit.loadCollections',
            failure,
            StackTrace.current,
            {
              'user': _userContext,
              'failure_message': failure.message,
            },
          );

          emit(FavoritesCollectionsState.error(
            message: failure.message,
            code: failure.code,
          ));
        },
            (allCollections) {
          // Separate regular and smart collections
          final regularCollections = allCollections.where((c) => !c.isSmartCollection).toList();
          final smartCollections = allCollections.where((c) => c.isSmartCollection).toList();

          _logger.logUserAction('load_collections_success', {
            'user': _userContext,
            'regular_collections_count': regularCollections.length,
            'smart_collections_count': smartCollections.length,
          });

          emit(FavoritesCollectionsState.loaded(
            collections: regularCollections,
            smartCollections: smartCollections,
          ));
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesCollectionsCubit.loadCollections',
        e,
        stackTrace,
        {'user': _userContext},
      );

      emit(const FavoritesCollectionsState.error(
        message: 'Failed to load collections. Please try again.',
      ));
    }
  }

  // Create new collection
  Future<void> createCollection({
    required String name,
    String? description,
    String? icon,
    String? color,
    Map<String, String>? tags,
  }) async {
    try {
      emit(const FavoritesCollectionsState.creating());

      _logger.logUserAction('create_collection_started', {
        'user': _userContext,
        'collection_name': name,
        'timestamp': _currentTimestamp,
      });

      final params = CreateFavoritesCollectionParams(
        name: name,
        description: description,
        icon: icon,
        color: color,
        tags: tags ?? {},
      );

      final result = await _createCollectionUseCase(params);

      result.fold(
            (failure) {
          _logger.logErrorWithContext(
            'FavoritesCollectionsCubit.createCollection',
            failure,
            StackTrace.current,
            {
              'user': _userContext,
              'collection_name': name,
              'failure_message': failure.message,
            },
          );

          emit(FavoritesCollectionsState.error(
            message: failure.message,
            code: failure.code,
          ));
        },
            (newCollection) {
          _logger.logUserAction('create_collection_success', {
            'user': _userContext,
            'collection_id': newCollection.id,
            'collection_name': newCollection.name,
          });

          // Reload collections to show the new one
          loadCollections();
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesCollectionsCubit.createCollection',
        e,
        stackTrace,
        {
          'user': _userContext,
          'collection_name': name,
        },
      );

      emit(const FavoritesCollectionsState.error(
        message: 'Failed to create collection. Please try again.',
      ));
    }
  }

  // Select collection
  void selectCollection(FavoritesCollection collection) {
    state.maybeWhen(
      loaded: (collections, smartCollections, _, isCreating, isEditing) {
        emit(FavoritesCollectionsState.loaded(
          collections: collections,
          smartCollections: smartCollections,
          selectedCollection: collection,
          isCreating: isCreating,
          isEditing: isEditing,
        ));

        _logger.logUserAction('collection_selected', {
          'user': _userContext,
          'collection_id': collection.id,
          'collection_name': collection.name,
          'is_smart_collection': collection.isSmartCollection,
        });
      },
      orElse: () {},
    );
  }

  // Start editing collection
  void startEditingCollection(FavoritesCollection collection) {
    emit(FavoritesCollectionsState.editing(collection: collection));

    _logger.logUserAction('start_editing_collection', {
      'user': _userContext,
      'collection_id': collection.id,
      'collection_name': collection.name,
    });
  }

  // Cancel editing/creating
  void cancelEditing() {
    // Return to loaded state
    loadCollections();
  }

  // Move favorites to collection
  Future<void> moveFavoritesToCollection({
    required List<String> productIds,
    required String targetCollectionId,
    String? sourceCollectionId,
  }) async {
    try {
      _logger.logUserAction('move_favorites_to_collection_started', {
        'user': _userContext,
        'product_ids_count': productIds.length,
        'target_collection_id': targetCollectionId,
        'source_collection_id': sourceCollectionId,
      });

      final params = OrganizeFavoritesParams(
        action: OrganizeAction.moveToCollection,
        productIds: productIds,
        sourceCollectionId: sourceCollectionId,
        targetCollectionId: targetCollectionId,
      );

      final result = await _organizeFavoritesUseCase(params);

      result.fold(
            (failure) {
          _logger.logErrorWithContext(
            'FavoritesCollectionsCubit.moveFavoritesToCollection',
            failure,
            StackTrace.current,
            {
              'user': _userContext,
              'failure_message': failure.message,
            },
          );
        },
            (_) {
          _logger.logUserAction('move_favorites_to_collection_success', {
            'user': _userContext,
            'moved_count': productIds.length,
            'target_collection_id': targetCollectionId,
          });

          // Reload collections to update counts
          loadCollections();
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesCollectionsCubit.moveFavoritesToCollection',
        e,
        stackTrace,
        {
          'user': _userContext,
          'product_ids_count': productIds.length,
        },
      );
    }
  }

  // Get current collections
  List<FavoritesCollection> get currentCollections {
    return state.maybeWhen(
      loaded: (collections, _, __, ___, ____) => collections,
      orElse: () => [],
    );
  }

  List<FavoritesCollection> get currentSmartCollections {
    return state.maybeWhen(
      loaded: (_, smartCollections, __, ___, ____) => smartCollections,
      orElse: () => [],
    );
  }

  FavoritesCollection? get selectedCollection {
    return state.maybeWhen(
      loaded: (_, __, selectedCollection, ___, ____) => selectedCollection,
      orElse: () => null,
    );
  }

  @override
  void onChange(Change<FavoritesCollectionsState> change) {
    super.onChange(change);
    _logger.d('FavoritesCollectionsState changed: ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}');
  }

  @override
  Future<void> close() {
    _logger.d('FavoritesCollectionsCubit closed for user: $_userContext');
    return super.close();
  }
}