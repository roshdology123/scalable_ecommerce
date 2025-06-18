import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'categories_state.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoriesCubit(this._getCategoriesUseCase) : super(const CategoriesState.initial());

  List<Category> _categories = [];
  String? _selectedCategoryId;

  // Getters
  List<Category> get categories => _categories;
  String? get selectedCategoryId => _selectedCategoryId;

  Category? get selectedCategory => _categories
      .where((category) => category.id == _selectedCategoryId)
      .firstOrNull;

  /// Load all categories
  Future<void> loadCategories({bool refresh = false}) async {
    if (!refresh && _categories.isNotEmpty) {
      // Categories already loaded
      emit(CategoriesState.loaded(_categories, _selectedCategoryId));
      return;
    }

    emit(const CategoriesState.loading());

    try {
      final result = await _getCategoriesUseCase(const NoParams());

      result.fold(
            (failure) => emit(CategoriesState.error(failure.message, failure.code)),
            (categories) {
          _categories = categories;

          if (categories.isEmpty) {
            emit(const CategoriesState.empty());
          } else {
            emit(CategoriesState.loaded(categories, _selectedCategoryId));
          }
        },
      );
    } catch (e) {
      emit(CategoriesState.error(
        'An unexpected error occurred: ${e.toString()}',
        'UNKNOWN_ERROR',
      ));
    }
  }

  /// Select a category
  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;

    if (_categories.isNotEmpty) {
      emit(CategoriesState.loaded(_categories, _selectedCategoryId));
    }
  }

  /// Clear category selection
  void clearSelection() {
    selectCategory(null);
  }

  /// Get category by ID
  Category? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get category by name
  Category? getCategoryByName(String categoryName) {
    try {
      return _categories.firstWhere(
            (category) => category.name.toLowerCase() == categoryName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get active categories only
  List<Category> get activeCategories => _categories
      .where((category) => category.isActive)
      .toList();

  /// Get popular categories (with high product count)
  List<Category> get popularCategories => _categories
      .where((category) => category.isPopular)
      .toList();

  /// Search categories by name
  List<Category> searchCategories(String query) {
    if (query.isEmpty) return _categories;

    final lowerQuery = query.toLowerCase();
    return _categories
        .where((category) =>
    category.name.toLowerCase().contains(lowerQuery) ||
        category.displayName.toLowerCase().contains(lowerQuery) ||
        (category.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  /// Sort categories
  void sortCategories(CategorySortBy sortBy, {bool ascending = true}) {
    switch (sortBy) {
      case CategorySortBy.name:
        _categories.sort((a, b) => ascending
            ? a.displayName.compareTo(b.displayName)
            : b.displayName.compareTo(a.displayName));
        break;

      case CategorySortBy.productCount:
        _categories.sort((a, b) => ascending
            ? a.productCount.compareTo(b.productCount)
            : b.productCount.compareTo(a.productCount));
        break;

      case CategorySortBy.sortOrder:
        _categories.sort((a, b) => ascending
            ? a.sortOrder.compareTo(b.sortOrder)
            : b.sortOrder.compareTo(a.sortOrder));
        break;

      case CategorySortBy.createdAt:
        _categories.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return ascending
              ? aDate.compareTo(bDate)
              : bDate.compareTo(aDate);
        });
        break;
    }

    if (_categories.isNotEmpty) {
      emit(CategoriesState.loaded(_categories, _selectedCategoryId));
    }
  }

  /// Refresh categories
  Future<void> refresh() async {
    await loadCategories(refresh: true);
  }

  /// Reset state
  void reset() {
    _categories = [];
    _selectedCategoryId = null;
    emit(const CategoriesState.initial());
  }

  /// Check if category is selected
  bool isCategorySelected(String categoryId) {
    return _selectedCategoryId == categoryId;
  }

  /// Get total product count across all categories
  int get totalProductCount => _categories
      .fold(0, (total, category) => total + category.productCount);

  /// Get category statistics
  Map<String, dynamic> get categoryStats => {
    'total': _categories.length,
    'active': activeCategories.length,
    'popular': popularCategories.length,
    'totalProducts': totalProductCount,
    'averageProducts': _categories.isNotEmpty
        ? (totalProductCount / _categories.length).round()
        : 0,
  };
}

enum CategorySortBy {
  name,
  productCount,
  sortOrder,
  createdAt,
}