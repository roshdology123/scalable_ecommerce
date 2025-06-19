import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/app_logger.dart';
import '../../../../products/domain/entities/product.dart';
import '../../../domain/entities/favorite_item.dart';
import '../../../domain/usecases/add_to_favorite_usecase.dart';
import '../../../domain/usecases/clear_favorites_usecase.dart';
import '../../../domain/usecases/get_favorites_count_usecase.dart';
import '../../../domain/usecases/get_favorites_usecase.dart';
import '../../../domain/usecases/is_favorite_usecase.dart';
import '../../../domain/usecases/organize_favorites_usecase.dart';
import '../../../domain/usecases/remove_favorite_usecase.dart';
import 'favorites_state.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddToFavoritesUseCase _addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase _removeFromFavoritesUseCase;
  final IsFavoriteUseCase _isFavoriteUseCase;
  final GetFavoritesCountUseCase _getFavoritesCountUseCase;
  final ClearFavoritesUseCase _clearFavoritesUseCase;
  final OrganizeFavoritesUseCase _organizeFavoritesUseCase;
  final AppLogger _logger = AppLogger();

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T12:53:51Z';

  FavoritesCubit(
      this._getFavoritesUseCase,
      this._addToFavoritesUseCase,
      this._removeFromFavoritesUseCase,
      this._isFavoriteUseCase,
      this._getFavoritesCountUseCase,
      this._clearFavoritesUseCase,
      this._organizeFavoritesUseCase,
      ) : super(const FavoritesState.initial());

  // Current state getters
  List<FavoriteItem> get currentFavorites {
    return state.maybeWhen(
      loaded: (favorites, _, __, ___, ____, _____, ______, _______, ________, _________) => favorites,
      orElse: () => [],
    );
  }

  int get favoritesCount {
    return state.maybeWhen(
      loaded: (_, totalCount, __, ___, ____, _____, ______, _______, ________, _________) => totalCount,
      orElse: () => 0,
    );
  }

  bool get isSelectionMode {
    return state.maybeWhen(
      loaded: (_, __, ___, ____, _____, ______, isSelectionMode, _______, ________, _________) => isSelectionMode,
      orElse: () => false,
    );
  }

  List<String> get selectedFavoriteIds {
    return state.maybeWhen(
      loaded: (_, __, ___, ____, _____, ______, _______,  ________,selectedIds, _________) => selectedIds,
      orElse: () => [],
    );
  }

  // Load favorites
  Future<void> loadFavorites({
    String? collectionId,
    String? category,
    String? searchQuery,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh) {
        emit(const FavoritesState.loading());
      }

      _logger.logUserAction('load_favorites_started', {
        'user': _userContext,
        'collection_id': collectionId,
        'category': category,
        'search_query': searchQuery,
        'timestamp': _currentTimestamp,
      });

      final params = GetFavoritesParams(
        collectionId: collectionId,
        category: category,
        searchQuery: searchQuery,
        sortBy: sortBy ?? 'date_added',
        sortOrder: sortOrder ?? 'desc',
        minPrice: filters?['minPrice'],
        maxPrice: filters?['maxPrice'],
        minRating: filters?['minRating'],
        inStockOnly: filters?['inStockOnly'],
        onSaleOnly: filters?['onSaleOnly'],
        tags: filters?['tags'],
      );

      final result = await _getFavoritesUseCase(params);

      result.fold(
            (failure) {
          _logger.logErrorWithContext(
            'FavoritesCubit.loadFavorites',
            failure,
            StackTrace.current,
            {
              'user': _userContext,
              'failure_message': failure.message,
              'failure_code': failure.code,
            },
          );

          emit(FavoritesState.error(
            message: failure.message,
            code: failure.code,
            searchQuery: searchQuery ?? '',
            selectedCategory: category,
          ));
        },
            (favorites) {
          _logger.logUserAction('load_favorites_success', {
            'user': _userContext,
            'favorites_count': favorites.length,
            'has_search': searchQuery?.isNotEmpty ?? false,
            'has_category_filter': category != null,
          });

          if (favorites.isEmpty) {
            emit(FavoritesState.empty(
              searchQuery: searchQuery ?? '',
              selectedCategory: category,
              filters: filters,
            ));
          } else {
            emit(FavoritesState.loaded(
              favorites: favorites,
              totalCount: favorites.length,
              searchQuery: searchQuery ?? '',
              selectedCategory: category,
              sortBy: sortBy ?? 'date_added',
              sortOrder: sortOrder ?? 'desc',
              filters: filters,
            ));
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesCubit.loadFavorites',
        e,
        stackTrace,
        {'user': _userContext},
      );

      emit(FavoritesState.error(
        message: 'Failed to load favorites. Please try again.',
        searchQuery: searchQuery ?? '',
        selectedCategory: category,
      ));
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(Product product, {
    String? collectionId,
    Map<String, String>? tags,
    String? notes,
    bool enablePriceTracking = false,
    double? targetPrice,
  }) async {
    try {
      _logger.logUserAction('toggle_favorite_started', {
        'user': _userContext,
        'product_id': product.id,
        'product_title': product.title,
        'timestamp': _currentTimestamp,
      });

      // Check if already favorite
      final isFavoriteResult = await _isFavoriteUseCase(product.id);
      final isFavorite = isFavoriteResult.fold(
            (failure) => false,
            (result) => result,
      );

      if (isFavorite) {
        // Remove from favorites
        final removeParams = RemoveFromFavoritesParams(productId: product.id);
        final removeResult = await _removeFromFavoritesUseCase(removeParams);

        removeResult.fold(
              (failure) {
            _logger.logErrorWithContext(
              'FavoritesCubit.toggleFavorite (remove)',
              failure,
              StackTrace.current,
              {
                'user': _userContext,
                'product_id': product.id,
                'failure_message': failure.message,
              },
            );
          },
              (_) {
            _logger.logUserAction('favorite_removed', {
              'user': _userContext,
              'product_id': product.id,
              'product_title': product.title,
            });

            // Refresh favorites if we're in loaded state
            state.maybeWhen(
              loaded: (_, __, searchQuery, category, ____, _____, ______, _______, ________, filters) {
                loadFavorites(
                  searchQuery: searchQuery,
                  category: category,
                  filters: filters,
                  isRefresh: true,
                );
              },
              orElse: () {},
            );
          },
        );

        return !isFavorite;
      } else {
        // Add to favorites
        final addParams = AddToFavoritesParams(
          product: product,
          collectionId: collectionId,
          tags: tags ?? {},
          notes: notes,
          enablePriceTracking: enablePriceTracking,
          targetPrice: targetPrice,
        );
        final addResult = await _addToFavoritesUseCase(addParams);

        addResult.fold(
              (failure) {
            _logger.logErrorWithContext(
              'FavoritesCubit.toggleFavorite (add)',
              failure,
              StackTrace.current,
              {
                'user': _userContext,
                'product_id': product.id,
                'failure_message': failure.message,
              },
            );
          },
              (_) {
            _logger.logUserAction('favorite_added', {
              'user': _userContext,
              'product_id': product.id,
              'product_title': product.title,
              'collection_id': collectionId,
              'price_tracking': enablePriceTracking,
            });

            // Refresh favorites if we're in loaded state
            state.maybeWhen(
              loaded: (_, __, searchQuery, category, ____, _____, ______, _______, ________, filters) {
                loadFavorites(
                  searchQuery: searchQuery,
                  category: category,
                  filters: filters,
                  isRefresh: true,
                );
              },
              orElse: () {},
            );
          },
        );

        return !isFavorite;
      }
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesCubit.toggleFavorite',
        e,
        stackTrace,
        {
          'user': _userContext,
          'product_id': product.id,
        },
      );
      return false;
    }
  }

  // Check if product is favorite
  Future<bool> isFavorite(int productId) async {
    try {
      final result = await _isFavoriteUseCase(productId);
      return result.fold(
            (failure) => false,
            (isFavorite) => isFavorite,
      );
    } catch (e) {
      return false;
    }
  }

  // Search favorites
  Future<void> searchFavorites(String query) async {
    final currentState = state;

    currentState.maybeWhen(
      loaded: (_, __, ___, category, sortBy, sortOrder, isGridView, isSelectionMode, selectedIds, filters) {
        loadFavorites(
          searchQuery: query,
          category: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          filters: filters,
        );
      },
      empty: (_, category, filters) {
        loadFavorites(
          searchQuery: query,
          category: category,
          filters: filters,
        );
      },
      error: (_, __, ___, category) {
        loadFavorites(
          searchQuery: query,
          category: category,
        );
      },
      orElse: () {
        loadFavorites(searchQuery: query);
      },
    );
  }

  // Apply filters
  Future<void> applyFilters(Map<String, dynamic> filters) async {
    final currentState = state;

    currentState.maybeWhen(
      loaded: (_, __, searchQuery, category, sortBy, sortOrder, isGridView, isSelectionMode, selectedIds, ___) {
        loadFavorites(
          searchQuery: searchQuery,
          category: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          filters: filters,
        );
      },
      empty: (searchQuery, category, ___) {
        loadFavorites(
          searchQuery: searchQuery,
          category: category,
          filters: filters,
        );
      },
      orElse: () {
        loadFavorites(filters: filters);
      },
    );
  }

  // Change sort order
  Future<void> changeSortOrder(String sortBy, String sortOrder) async {
    final currentState = state;

    currentState.maybeWhen(
      loaded: (_, __, searchQuery, category, ____, _____, isGridView, isSelectionMode, selectedIds, filters) {
        loadFavorites(
          searchQuery: searchQuery,
          category: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          filters: filters,
        );
      },
      orElse: () {
        loadFavorites(
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
      },
    );
  }

  // Toggle view mode (grid/list)
  void toggleViewMode() {
    state.maybeWhen(
      loaded: (favorites, totalCount, searchQuery, category, sortBy, sortOrder, isGridView, isSelectionMode, selectedIds, filters) {
        emit(FavoritesState.loaded(
          favorites: favorites,
          totalCount: totalCount,
          searchQuery: searchQuery,
          selectedCategory: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          isGridView: !isGridView,
          isSelectionMode: isSelectionMode,
          selectedFavoriteIds: selectedIds,
          filters: filters,
        ));

        _logger.logUserAction('view_mode_toggled', {
          'user': _userContext,
          'new_view_mode': !isGridView ? 'grid' : 'list',
        });
      },
      orElse: () {},
    );
  }

  // Toggle selection mode
  void toggleSelectionMode() {
    state.maybeWhen(
      loaded: (favorites, totalCount, searchQuery, category, sortBy, sortOrder, isGridView, isSelectionMode, selectedIds, filters) {
        emit(FavoritesState.loaded(
          favorites: favorites,
          totalCount: totalCount,
          searchQuery: searchQuery,
          selectedCategory: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          isGridView: isGridView,
          isSelectionMode: !isSelectionMode,
          selectedFavoriteIds: !isSelectionMode ? [] : selectedIds, // Clear selection when entering selection mode
          filters: filters,
        ));

        _logger.logUserAction('selection_mode_toggled', {
          'user': _userContext,
          'selection_mode_enabled': !isSelectionMode,
        });
      },
      orElse: () {},
    );
  }

  // Toggle favorite selection
  void toggleFavoriteSelection(String favoriteId) {
    state.maybeWhen(
      loaded: (favorites, totalCount, searchQuery, category, sortBy, sortOrder, isGridView, isSelectionMode, selectedIds, filters) {
        if (!isSelectionMode) return;

        final updatedSelectedIds = List<String>.from(selectedIds);
        if (updatedSelectedIds.contains(favoriteId)) {
          updatedSelectedIds.remove(favoriteId);
        } else {
          updatedSelectedIds.add(favoriteId);
        }

        emit(FavoritesState.loaded(
          favorites: favorites,
          totalCount: totalCount,
          searchQuery: searchQuery,
          selectedCategory: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          isGridView: isGridView,
          isSelectionMode: isSelectionMode,
          selectedFavoriteIds: updatedSelectedIds,
          filters: filters,
        ));
      },
      orElse: () {},
    );
  }

  // Select all favorites
  void selectAllFavorites() {
    state.maybeWhen(
      loaded: (favorites, totalCount, searchQuery, category, sortBy, sortOrder, isGridView, isSelectionMode, selectedIds, filters) {
        if (!isSelectionMode) return;

        final allFavoriteIds = favorites.map((f) => f.id).toList();

        emit(FavoritesState.loaded(
          favorites: favorites,
          totalCount: totalCount,
          searchQuery: searchQuery,
          selectedCategory: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          isGridView: isGridView,
          isSelectionMode: isSelectionMode,
          selectedFavoriteIds: allFavoriteIds,
          filters: filters,
        ));

        _logger.logUserAction('select_all_favorites', {
          'user': _userContext,
          'selected_count': allFavoriteIds.length,
        });
      },
      orElse: () {},
    );
  }

  // Clear selection
  void clearSelection() {
    state.maybeWhen(
      loaded: (favorites, totalCount, searchQuery, category, sortBy, sortOrder, isGridView, isSelectionMode, selectedIds, filters) {
        emit(FavoritesState.loaded(
          favorites: favorites,
          totalCount: totalCount,
          searchQuery: searchQuery,
          selectedCategory: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          isGridView: isGridView,
          isSelectionMode: isSelectionMode,
          selectedFavoriteIds: [],
          filters: filters,
        ));
      },
      orElse: () {},
    );
  }

  // Remove selected favorites
  Future<void> removeSelectedFavorites() async {
    final selectedIds = selectedFavoriteIds;
    if (selectedIds.isEmpty) return;

    try {
      _logger.logUserAction('remove_selected_favorites_started', {
        'user': _userContext,
        'selected_count': selectedIds.length,
      });

      final params = RemoveFromFavoritesParams();
      for (final favoriteId in selectedIds) {
        final removeParams = RemoveFromFavoritesParams(favoriteId: favoriteId);
        await _removeFromFavoritesUseCase(removeParams);
      }

      _logger.logUserAction('remove_selected_favorites_success', {
        'user': _userContext,
        'removed_count': selectedIds.length,
      });

      // Exit selection mode and refresh
      state.maybeWhen(
        loaded: (_, __, searchQuery, category, sortBy, sortOrder, isGridView, ____, _____, filters) {
          emit(FavoritesState.loaded(
            favorites: currentFavorites,
            totalCount: favoritesCount,
            searchQuery: searchQuery,
            selectedCategory: category,
            sortBy: sortBy,
            sortOrder: sortOrder,
            isGridView: isGridView,
            isSelectionMode: false,
            selectedFavoriteIds: [],
            filters: filters,
          ));

          loadFavorites(
            searchQuery: searchQuery,
            category: category,
            sortBy: sortBy,
            sortOrder: sortOrder,
            filters: filters,
            isRefresh: true,
          );
        },
        orElse: () {},
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesCubit.removeSelectedFavorites',
        e,
        stackTrace,
        {
          'user': _userContext,
          'selected_count': selectedIds.length,
        },
      );
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      _logger.logUserAction('clear_all_favorites_started', {
        'user': _userContext,
        'current_count': favoritesCount,
      });

      final params = ClearFavoritesParams(confirmClearAll: true);
      final result = await _clearFavoritesUseCase(params);

      result.fold(
            (failure) {
          _logger.logErrorWithContext(
            'FavoritesCubit.clearAllFavorites',
            failure,
            StackTrace.current,
            {
              'user': _userContext,
              'failure_message': failure.message,
            },
          );
        },
            (_) {
          _logger.logUserAction('clear_all_favorites_success', {
            'user': _userContext,
          });

          emit(const FavoritesState.empty());
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesCubit.clearAllFavorites',
        e,
        stackTrace,
        {'user': _userContext},
      );
    }
  }

  // Refresh favorites
  Future<void> refresh() async {
    state.maybeWhen(
      loaded: (_, __, searchQuery, category, sortBy, sortOrder, ____, _____, ______, filters) {
        loadFavorites(
          searchQuery: searchQuery,
          category: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
          filters: filters,
          isRefresh: true,
        );
      },
      empty: (searchQuery, category, filters) {
        loadFavorites(
          searchQuery: searchQuery,
          category: category,
          filters: filters,
          isRefresh: true,
        );
      },
      error: (_, __, searchQuery, category) {
        loadFavorites(
          searchQuery: searchQuery,
          category: category,
          isRefresh: true,
        );
      },
      orElse: () {
        loadFavorites(isRefresh: true);
      },
    );
  }

  // Reset to initial state
  void reset() {
    emit(const FavoritesState.initial());
  }

  @override
  void onChange(Change<FavoritesState> change) {
    super.onChange(change);
    _logger.d('FavoritesState changed: ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}');
  }

  @override
  Future<void> close() {
    _logger.d('FavoritesCubit closed for user: $_userContext');
    return super.close();
  }
}