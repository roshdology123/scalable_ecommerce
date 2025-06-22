import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/debouncer.dart';
import '../../../../products/domain/entities/product.dart';
import '../../../../products/domain/usecases/search_products_usecase.dart';
import '../../../domain/entities/search_result.dart';
import 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchProductsUseCase _searchProductsUseCase;
  final SearchDebouncer _debouncer = SearchDebouncer();

  // Current state variables
  int _currentPage = 1;
  bool _hasReachedMax = false;
  String _currentQuery = '';
  String? _currentCategory;
  double? _currentMinPrice;
  double? _currentMaxPrice;
  double? _currentMinRating;
  String? _currentSortBy;
  String? _currentSortOrder;

  SearchCubit(this._searchProductsUseCase) : super(const SearchState.initial());

  // Getters for current state
  int get currentPage => _currentPage;
  bool get hasReachedMax => _hasReachedMax;
  String get currentQuery => _currentQuery;
  String? get currentCategory => _currentCategory;
  double? get currentMinPrice => _currentMinPrice;
  double? get currentMaxPrice => _currentMaxPrice;
  double? get currentMinRating => _currentMinRating;
  String? get currentSortBy => _currentSortBy;
  String? get currentSortOrder => _currentSortOrder;

  List<Product> get products {
    return state.searchResult?.products ?? [];
  }

  SearchResult? get searchResult => state.searchResult;

  bool get isLoading {
    return state.maybeWhen(
      loading: () => true,
      loadingMore: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );
  }

  /// Search products with debouncing
  void searchProducts({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    String? sortOrder,
    bool immediate = false,
    bool refresh = false,
  }) {
    if (immediate || refresh) {
      _performSearch(
        query: query,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        sortBy: sortBy,
        sortOrder: sortOrder,
        refresh: refresh,
      );
    } else {
      _debouncer.search(query, (debouncedQuery) {
        if (debouncedQuery == query) {
          _performSearch(
            query: query,
            category: category,
            minPrice: minPrice,
            maxPrice: maxPrice,
            minRating: minRating,
            sortBy: sortBy,
            sortOrder: sortOrder,
            refresh: refresh,
          );
        }
      });
    }
  }

  /// Perform the actual search
  Future<void> _performSearch({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    String? sortOrder,
    bool refresh = false,
  }) async {
    // Update current search parameters
    if (refresh || query != _currentQuery || category != _currentCategory) {
      _resetPagination();
      emit(const SearchState.loading());
    } else if (products.isEmpty) {
      emit(const SearchState.loading());
    }

    _currentQuery = query;
    _currentCategory = category;
    _currentMinPrice = minPrice;
    _currentMaxPrice = maxPrice;
    _currentMinRating = minRating;
    _currentSortBy = sortBy;
    _currentSortOrder = sortOrder;

    // Handle empty query
    if (query.trim().isEmpty) {
      emit(const SearchState.initial());
      return;
    }

    try {
      final result = await _searchProductsUseCase(SearchProductsParams(
        query: query,
        page: _currentPage,
        limit: 20,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
      ));

      result.fold(
            (failure) => emit(SearchState.error(failure.message, failure.code)),
            (productsList) {
          // Convert List<Product> to SearchResult
          final searchResult = _createSearchResultFromProducts(
            query: query,
            products: productsList,
            category: category,
          );

          if (searchResult.products.isEmpty) {
            _hasReachedMax = true;
            if (products.isEmpty) {
              emit(SearchState.empty(query));
            } else {
              // Keep existing results but mark as reached max
              final currentResult = this.searchResult;
              if (currentResult != null) {
                emit(SearchState.loaded(
                  currentResult,
                  hasReachedMax: true,
                  currentPage: _currentPage,
                  category: _currentCategory,
                  sortBy: _currentSortBy,
                ));
              }
            }
          } else {
            final SearchResult updatedResult;

            if (refresh || _currentPage == 1) {
              // First page or refresh - use new search result as-is
              updatedResult = searchResult;
            } else {
              // Append new products to existing ones
              final allProducts = [...products, ...searchResult.products];
              updatedResult = searchResult.copyWith(
                products: allProducts,
                totalResults: allProducts.length,
              );
            }

            _currentPage++;
            _hasReachedMax = searchResult.products.length < 20;

            emit(SearchState.loaded(
              updatedResult,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage,
              category: _currentCategory,
              sortBy: _currentSortBy,
            ));
          }
        },
      );
    } catch (e) {
      emit(SearchState.error(
        'An unexpected error occurred: ${e.toString()}',
        'UNKNOWN_ERROR',
      ));
    }
  }

  /// Convert List<Product> to SearchResult
  SearchResult _createSearchResultFromProducts({
    required String query,
    required List<Product> products,
    String? category,
  }) {
    final categories = products
        .map((product) => product.category)
        .toSet()
        .toList();

    final categoryCount = <String, int>{};
    for (final product in products) {
      categoryCount[product.category] =
          (categoryCount[product.category] ?? 0) + 1;
    }

    final totalPrice = products.fold<double>(
      0.0,
          (sum, product) => sum + product.price,
    );
    final averagePrice = products.isNotEmpty ? totalPrice / products.length : null;

    final totalRating = products.fold<double>(
      0.0,
          (sum, product) => sum + product.rating.rate,
    );
    final averageRating = products.isNotEmpty ? totalRating / products.length : null;

    return SearchResult(
      query: query,
      products: products,
      categories: categories,
      totalResults: products.length,
      timestamp: DateTime.now(),
      categoryCount: categoryCount,
      averagePrice: averagePrice,
      averageRating: averageRating,
    );
  }

  /// Load more search results (pagination)
  Future<void> loadMoreResults() async {
    if (_hasReachedMax || isLoading || _currentQuery.isEmpty) return;

    // Emit loading more state
    final currentResult = searchResult;
    if (currentResult != null) {
      emit(SearchState.loadingMore(
        currentResult,
        hasReachedMax: _hasReachedMax,
        currentPage: _currentPage,
        category: _currentCategory,
        sortBy: _currentSortBy,
      ));
    }

    try {
      final result = await _searchProductsUseCase(SearchProductsParams(
        query: _currentQuery,
        page: _currentPage,
        limit: 20,
        category: _currentCategory,
        minPrice: _currentMinPrice,
        maxPrice: _currentMaxPrice,
        minRating: _currentMinRating,
      ));

      result.fold(
            (failure) {
          // Revert to loaded state on error
          if (currentResult != null) {
            emit(SearchState.loaded(
              currentResult,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage - 1,
              category: _currentCategory,
              sortBy: _currentSortBy,
            ));
          }
        },
            (productsList) {
          // Convert List<Product> to SearchResult
          final searchResult = _createSearchResultFromProducts(
            query: _currentQuery,
            products: productsList,
            category: _currentCategory,
          );

          if (searchResult.products.isEmpty) {
            _hasReachedMax = true;
            // Keep current state but mark as reached max
            if (currentResult != null) {
              emit(SearchState.loaded(
                currentResult,
                hasReachedMax: true,
                currentPage: _currentPage,
                category: _currentCategory,
                sortBy: _currentSortBy,
              ));
            }
          } else {
            final allProducts = [...products, ...searchResult.products];
            final updatedResult = currentResult!.copyWith(
              products: allProducts,
              totalResults: allProducts.length,
            );

            _currentPage++;
            _hasReachedMax = searchResult.products.length < 20;

            emit(SearchState.loaded(
              updatedResult,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage,
              category: _currentCategory,
              sortBy: _currentSortBy,
            ));
          }
        },
      );
    } catch (e) {
      // Keep current products but show in loaded state
      if (currentResult != null) {
        emit(SearchState.loaded(
          currentResult,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage - 1,
          category: _currentCategory,
          sortBy: _currentSortBy,
        ));
      }
    }
  }

  /// Apply filters to current search
  void applyFilters({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    String? sortOrder,
  }) {
    if (_currentQuery.isNotEmpty) {
      searchProducts(
        query: _currentQuery,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        sortBy: sortBy,
        sortOrder: sortOrder,
        immediate: true,
        refresh: true,
      );
    }
  }

  /// Clear search results and query
  void clearSearch() {
    _debouncer.cancel();
    _resetPagination();
    _currentQuery = '';
    _currentCategory = null;
    _currentMinPrice = null;
    _currentMaxPrice = null;
    _currentMinRating = null;
    _currentSortBy = null;
    _currentSortOrder = null;
    emit(const SearchState.initial());
  }

  /// Refresh current search
  Future<void> refresh() async {
    if (_currentQuery.isNotEmpty) {
      searchProducts(
        query: _currentQuery,
        category: _currentCategory,
        minPrice: _currentMinPrice,
        maxPrice: _currentMaxPrice,
        minRating: _currentMinRating,
        sortBy: _currentSortBy,
        sortOrder: _currentSortOrder,
        immediate: true,
        refresh: true,
      );
    }
  }

  /// Reset pagination state
  void _resetPagination() {
    _currentPage = 1;
    _hasReachedMax = false;
  }

  /// Check if filters are active
  bool get hasActiveFilters =>
      _currentCategory != null ||
          _currentMinPrice != null ||
          _currentMaxPrice != null ||
          _currentMinRating != null;

  /// Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (_currentCategory != null) count++;
    if (_currentMinPrice != null || _currentMaxPrice != null) count++;
    if (_currentMinRating != null) count++;
    return count;
  }

  /// Get filter summary
  String get filterSummary {
    final filters = <String>[];

    if (_currentCategory != null) {
      filters.add('Category: $_currentCategory');
    }

    if (_currentMinPrice != null || _currentMaxPrice != null) {
      final min = _currentMinPrice?.toString() ?? '0';
      final max = _currentMaxPrice?.toString() ?? '∞';
      filters.add('Price: \$$min - \$$max');
    }

    if (_currentMinRating != null) {
      filters.add('Rating: $_currentMinRating+');
    }

    return filters.join(', ');
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}