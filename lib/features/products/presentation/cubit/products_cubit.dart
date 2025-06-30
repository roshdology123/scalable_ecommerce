import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_by_category_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import '../../domain/usecases/filter_products_usecase.dart';
import 'products_state.dart';

@injectable
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final FilterProductsUseCase _filterProductsUseCase;

  // Current state variables
  int _currentPage = 1;
  bool _hasReachedMax = false;
  String? _currentCategory;
  String? _currentQuery;
  String? _currentSortBy;
  String? _currentSortOrder;
  Map<String, dynamic> _currentFilters = {};

  ProductsCubit(
      this._getProductsUseCase,
      this._getProductsByCategoryUseCase,
      this._searchProductsUseCase,
      this._filterProductsUseCase,
      ) : super(const ProductsState.initial());

  // Getters for current state
  int get currentPage => _currentPage;
  bool get hasReachedMax => _hasReachedMax;
  String? get currentCategory => _currentCategory;
  String? get currentQuery => _currentQuery;
  String? get currentSortBy => _currentSortBy;
  String? get currentSortOrder => _currentSortOrder;
  Map<String, dynamic> get currentFilters => Map.from(_currentFilters);

  List<Product> get products {
    return state.maybeWhen(
      loaded: (products, _, __, ___, ____) => products,
      loadingMore: (products, _, __, ___, ____) => products,
      orElse: () => [],
    );
  }

  bool get isLoading {
    return state.maybeWhen(
      loading: () => true,
      loadingMore: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );
  }

  /// Load initial products
  Future<void> loadProducts({
    String? category,
    String? sortBy,
    String? sortOrder,
    bool refresh = false,
  }) async {
    if (refresh) {
      _resetPagination();
      emit(const ProductsState.loading());
    } else if (products.isEmpty) {
      emit(const ProductsState.loading());
    }

    _currentCategory = category;
    _currentSortBy = sortBy;
    _currentSortOrder = sortOrder;

    try {
      final result = await _getProductsUseCase(GetProductsParams(
        page: _currentPage,
        limit: 20,
        category: category,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ));

      result.fold(
            (failure) => emit(ProductsState.error(failure.message, failure.code)),
            (newProducts) {
          if (newProducts.isEmpty) {
            _hasReachedMax = true;
            if (products.isEmpty) {
              emit(const ProductsState.empty());
            } else {
              emit(ProductsState.loaded(
                products,
                hasReachedMax: true,
                currentPage: _currentPage,
                category: _currentCategory,
                sortBy: _currentSortBy,
              ));
            }
          } else {
            final allProducts = refresh ? newProducts : [...products, ...newProducts];
            _currentPage++;
            _hasReachedMax = newProducts.length < 20;

            emit(ProductsState.loaded(
              allProducts,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage,
              category: _currentCategory,
              sortBy: _currentSortBy,
            ));
          }
        },
      );
    } catch (e) {
      emit(ProductsState.error(
        'An unexpected error occurred: ${e.toString()}',
        'UNKNOWN_ERROR',
      ));
    }
  }

  /// Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (_hasReachedMax || isLoading) return;

    // Emit loading more state
    emit(ProductsState.loadingMore(
      products,
      hasReachedMax: _hasReachedMax,
      currentPage: _currentPage,
      category: _currentCategory,
      sortBy: _currentSortBy,
    ));

    try {
      final result = await _getProductsUseCase(GetProductsParams(
        page: _currentPage,
        limit: 20,
        category: _currentCategory,
        sortBy: _currentSortBy,
        sortOrder: _currentSortOrder,
      ));

      result.fold(
            (failure) => emit(ProductsState.loaded(
          products,
          hasReachedMax: _hasReachedMax,
          currentPage: _currentPage - 1, // Revert page increment
          category: _currentCategory,
          sortBy: _currentSortBy,
        )),
            (newProducts) {
          if (newProducts.isEmpty) {
            _hasReachedMax = true;
          } else {
            final allProducts = [...products, ...newProducts];
            _currentPage++;
            _hasReachedMax = newProducts.length < 20;

            emit(ProductsState.loaded(
              allProducts,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage,
              category: _currentCategory,
              sortBy: _currentSortBy,
            ));
          }
        },
      );
    } catch (e) {
      // Keep current products but show error
      emit(ProductsState.loaded(
        products,
        hasReachedMax: _hasReachedMax,
        currentPage: _currentPage - 1,
        category: _currentCategory,
        sortBy: _currentSortBy,
      ));
    }
  }

  /// Load products by category
  Future<void> loadProductsByCategory({
    required String category,
    String? sortBy,
    String? sortOrder,
    bool refresh = false,
  }) async {
    if (refresh || _currentCategory != category) {
      _resetPagination();
      emit(const ProductsState.loading());
    }

    _currentCategory = category;
    _currentSortBy = sortBy;
    _currentSortOrder = sortOrder;

    try {
      final result = await _getProductsByCategoryUseCase(GetProductsByCategoryParams(
        category: category,
        page: _currentPage,
        limit: 20,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ));

      result.fold(
            (failure) => emit(ProductsState.error(failure.message, failure.code)),
            (newProducts) {
          if (newProducts.isEmpty) {
            _hasReachedMax = true;
            if (products.isEmpty) {
              emit(const ProductsState.empty());
            } else {
              emit(ProductsState.loaded(
                products,
                hasReachedMax: true,
                currentPage: _currentPage,
                category: _currentCategory,
                sortBy: _currentSortBy,
              ));
            }
          } else {
            final allProducts = refresh || _currentPage == 1
                ? newProducts
                : [...products, ...newProducts];
            _currentPage++;
            _hasReachedMax = newProducts.length < 20;

            emit(ProductsState.loaded(
              allProducts,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage,
              category: _currentCategory,
              sortBy: _currentSortBy,
            ));
          }
        },
      );
    } catch (e) {
      emit(ProductsState.error(
        'An unexpected error occurred: ${e.toString()}',
        'UNKNOWN_ERROR',
      ));
    }
  }

  /// Search products
  Future<void> searchProducts({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool refresh = false,
  }) async {
    if (refresh || _currentQuery != query) {
      _resetPagination();
      emit(const ProductsState.loading());
    }

    _currentQuery = query;
    _currentCategory = category;
    _currentFilters = {
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (minRating != null) 'minRating': minRating,
    };

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
            (failure) => emit(ProductsState.error(failure.message, failure.code)),
            (newProducts) {
          if (newProducts.isEmpty) {
            _hasReachedMax = true;
            if (products.isEmpty) {
              emit(const ProductsState.empty());
            } else {
              emit(ProductsState.loaded(
                products,
                hasReachedMax: true,
                currentPage: _currentPage,
                category: _currentCategory,
                sortBy: _currentSortBy,
              ));
            }
          } else {
            final allProducts = refresh || _currentPage == 1
                ? newProducts
                : [...products, ...newProducts];
            _currentPage++;
            _hasReachedMax = newProducts.length < 20;

            emit(ProductsState.loaded(
              allProducts,
              hasReachedMax: _hasReachedMax,
              currentPage: _currentPage,
              category: _currentCategory,
              sortBy: _currentSortBy,
            ));
          }
        },
      );
    } catch (e) {
      emit(ProductsState.error(
        'An unexpected error occurred: ${e.toString()}',
        'UNKNOWN_ERROR',
      ));
    }
  }

  /// Apply filters to current products
  Future<void> applyFilters({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? brands,
    List<String>? colors,
    List<String>? sizes,
    bool? inStockOnly,
    bool? onSaleOnly,
    bool? featuredOnly,
    bool? newArrivalsOnly,
    String? sortBy,
    String? sortOrder,
  }) async {
    final currentProducts = products;
    if (currentProducts.isEmpty) return;

    emit(const ProductsState.loading());

    _currentFilters = {
      if (category != null) 'category': category,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (minRating != null) 'minRating': minRating,
      if (brands != null && brands.isNotEmpty) 'brands': brands,
      if (colors != null && colors.isNotEmpty) 'colors': colors,
      if (sizes != null && sizes.isNotEmpty) 'sizes': sizes,
      if (inStockOnly == true) 'inStockOnly': true,
      if (onSaleOnly == true) 'onSaleOnly': true,
      if (featuredOnly == true) 'featuredOnly': true,
      if (newArrivalsOnly == true) 'newArrivalsOnly': true,
    };

    _currentSortBy = sortBy;
    _currentSortOrder = sortOrder;

    try {
      final result = await _filterProductsUseCase(FilterProductsParams(
        products: currentProducts,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        brands: brands,
        colors: colors,
        sizes: sizes,
        inStockOnly: inStockOnly,
        onSaleOnly: onSaleOnly,
        featuredOnly: featuredOnly,
        newArrivalsOnly: newArrivalsOnly,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ));

      result.fold(
            (failure) => emit(ProductsState.error(failure.message, failure.code)),
            (filteredProducts) {
          if (filteredProducts.isEmpty) {
            emit(const ProductsState.empty());
          } else {
            emit(ProductsState.loaded(
              filteredProducts,
              hasReachedMax: true, // Filtered results don't support pagination
              currentPage: 1,
              category: category,
              sortBy: sortBy,
            ));
          }
        },
      );
    } catch (e) {
      emit(ProductsState.error(
        'An unexpected error occurred: ${e.toString()}',
        'UNKNOWN_ERROR',
      ));
    }
  }

  /// Clear all filters and reload
  Future<void> clearFilters() async {
    _currentFilters.clear();
    _currentQuery = null;
    await loadProducts(
      category: _currentCategory,
      sortBy: _currentSortBy,
      sortOrder: _currentSortOrder,
      refresh: true,
    );
  }

  /// Sort products
  Future<void> sortProducts(String sortBy, [String? sortOrder]) async {
    if (products.isEmpty) return;

    _currentSortBy = sortBy;
    _currentSortOrder = sortOrder ?? 'asc';

    await applyFilters(
      category: _currentFilters['category'],
      minPrice: _currentFilters['minPrice'],
      maxPrice: _currentFilters['maxPrice'],
      minRating: _currentFilters['minRating'],
      brands: _currentFilters['brands'],
      colors: _currentFilters['colors'],
      sizes: _currentFilters['sizes'],
      inStockOnly: _currentFilters['inStockOnly'],
      onSaleOnly: _currentFilters['onSaleOnly'],
      featuredOnly: _currentFilters['featuredOnly'],
      newArrivalsOnly: _currentFilters['newArrivalsOnly'],
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  /// Refresh products
  Future<void> refresh() async {
    if (_currentQuery?.isNotEmpty == true) {
      await searchProducts(
        query: _currentQuery!,
        category: _currentCategory,
        minPrice: _currentFilters['minPrice'],
        maxPrice: _currentFilters['maxPrice'],
        minRating: _currentFilters['minRating'],
        refresh: true,
      );
    } else if (_currentCategory != null) {
      await loadProductsByCategory(
        category: _currentCategory!,
        sortBy: _currentSortBy,
        sortOrder: _currentSortOrder,
        refresh: true,
      );
    } else {
      await loadProducts(
        category: _currentCategory,
        sortBy: _currentSortBy,
        sortOrder: _currentSortOrder,
        refresh: true,
      );
    }
  }

  /// Reset pagination state
  void _resetPagination() {
    _currentPage = 1;
    _hasReachedMax = false;
  }

  /// Reset all state
  void reset() {
    _resetPagination();
    _currentCategory = null;
    _currentQuery = null;
    _currentSortBy = null;
    _currentSortOrder = null;
    _currentFilters.clear();
    emit(const ProductsState.initial());
  }

  /// Check if filters are active
  bool get hasActiveFilters => _currentFilters.isNotEmpty || _currentQuery?.isNotEmpty == true;

  /// Get active filter count
  int get activeFilterCount => _currentFilters.length + (_currentQuery?.isNotEmpty == true ? 1 : 0);

  /// Get filter summary
  String get filterSummary {
    final filters = <String>[];

    if (_currentQuery?.isNotEmpty == true) {
      filters.add('Search: "$_currentQuery"');
    }

    if (_currentCategory != null) {
      filters.add('Category: $_currentCategory');
    }

    if (_currentFilters['minPrice'] != null || _currentFilters['maxPrice'] != null) {
      final min = _currentFilters['minPrice']?.toString() ?? '0';
      final max = _currentFilters['maxPrice']?.toString() ?? '∞';
      filters.add('Price: \$$min - \$$max');
    }

    if (_currentFilters['minRating'] != null) {
      filters.add('Rating: ${_currentFilters['minRating']}+');
    }

    return filters.join(', ');
  }
}