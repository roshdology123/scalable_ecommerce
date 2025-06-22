import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:scalable_ecommerce/core/usecases/usecase.dart';

import '../../../../products/domain/usecases/get_categories_usecase.dart';
import 'search_filter_state.dart';

@injectable
class SearchFilterCubit extends Cubit<SearchFilterState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  SearchFilterCubit(this._getCategoriesUseCase)
      : super(const SearchFilterState.initial());

  /// Load available filter options
  Future<void> loadFilterOptions() async {
    emit(const SearchFilterState.loading());

    try {
      final result = await _getCategoriesUseCase(const NoParams());

      result.fold(
            (failure) => emit(SearchFilterState.error(failure.message, failure.code)),
            (categories) {
          // Filter only active categories and sort by product count
          final activeCategories = categories
              .where((category) => category.isActive)
              .toList()
            ..sort((a, b) => b.productCount.compareTo(a.productCount));

          emit(SearchFilterState.loaded(
            categories: activeCategories.map((c) => c.displayName).toList(),
            selectedCategory: null,
            minPrice: null,
            maxPrice: null,
            minRating: null,
            sortBy: null,
            sortOrder: 'asc',
          ));
        },
      );
    } catch (e) {
      emit(SearchFilterState.error(
        'Failed to load filter options: ${e.toString()}',
        'LOAD_FILTERS_ERROR',
      ));
    }
  }

  /// Update selected category
  void updateCategory(String? category) {
    state.maybeWhen(
      loaded: (categories, _, minPrice, maxPrice, minRating, sortBy, sortOrder) {
        emit(SearchFilterState.loaded(
          categories: categories,
          selectedCategory: category,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
          sortBy: sortBy,
          sortOrder: sortOrder,
        ));
      },
      orElse: () {},
    );
  }

  /// Update price range
  void updatePriceRange(double? minPrice, double? maxPrice) {
    state.maybeWhen(
      loaded: (categories, selectedCategory, _, __, minRating, sortBy, sortOrder) {
        emit(SearchFilterState.loaded(
          categories: categories,
          selectedCategory: selectedCategory,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
          sortBy: sortBy,
          sortOrder: sortOrder,
        ));
      },
      orElse: () {},
    );
  }

  /// Update minimum rating
  void updateMinRating(double? minRating) {
    state.maybeWhen(
      loaded: (categories, selectedCategory, minPrice, maxPrice, _, sortBy, sortOrder) {
        emit(SearchFilterState.loaded(
          categories: categories,
          selectedCategory: selectedCategory,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
          sortBy: sortBy,
          sortOrder: sortOrder,
        ));
      },
      orElse: () {},
    );
  }

  /// Update sort options
  void updateSort(String? sortBy, String? sortOrder) {
    state.maybeWhen(
      loaded: (categories, selectedCategory, minPrice, maxPrice, minRating, _, __) {
        emit(SearchFilterState.loaded(
          categories: categories,
          selectedCategory: selectedCategory,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
          sortBy: sortBy,
          sortOrder: sortOrder ?? 'asc',
        ));
      },
      orElse: () {},
    );
  }

  /// Clear all filters
  void clearFilters() {
    state.maybeWhen(
      loaded: (categories, _, __, ___, ____, _____, ______) {
        emit(SearchFilterState.loaded(
          categories: categories,
          selectedCategory: null,
          minPrice: null,
          maxPrice: null,
          minRating: null,
          sortBy: null,
          sortOrder: 'asc',
        ));
      },
      orElse: () {},
    );
  }

  /// Check if any filters are active
  bool get hasActiveFilters {
    return state.hasActiveFilters;
  }

  /// Get active filter count
  int get activeFilterCount {
    return state.activeFilterCount;
  }
}