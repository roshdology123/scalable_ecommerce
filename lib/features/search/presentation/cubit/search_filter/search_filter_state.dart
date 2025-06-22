import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter_state.freezed.dart';

@freezed
class SearchFilterState with _$SearchFilterState {
  const factory SearchFilterState.initial() = SearchFilterInitial;

  const factory SearchFilterState.loading() = SearchFilterLoading;

  const factory SearchFilterState.loaded({
    required List<String> categories,
    String? selectedCategory,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    @Default('asc') String sortOrder,
  }) = SearchFilterLoaded;

  const factory SearchFilterState.error(
      String message,
      String? code,
      ) = SearchFilterError;
}

// Extension for easier state checking
extension SearchFilterStateX on SearchFilterState {
  bool get isLoading => this is SearchFilterLoading;
  bool get isLoaded => this is SearchFilterLoaded;
  bool get isError => this is SearchFilterError;
  bool get isInitial => this is SearchFilterInitial;

  List<String> get categories => maybeWhen(
    loaded: (categories, _, __, ___, ____, _____, ______) => categories,
    orElse: () => [],
  );

  String? get selectedCategory => maybeWhen(
    loaded: (_, selectedCategory, __, ___, ____, _____, ______) => selectedCategory,
    orElse: () => null,
  );

  double? get minPrice => maybeWhen(
    loaded: (_, __, minPrice, ___, ____, _____, ______) => minPrice,
    orElse: () => null,
  );

  double? get maxPrice => maybeWhen(
    loaded: (_, __, ___, maxPrice, ____, _____, ______) => maxPrice,
    orElse: () => null,
  );

  double? get minRating => maybeWhen(
    loaded: (_, __, ___, ____, minRating, _____, ______) => minRating,
    orElse: () => null,
  );

  String? get sortBy => maybeWhen(
    loaded: (_, __, ___, ____, _____, sortBy, ______) => sortBy,
    orElse: () => null,
  );

  String get sortOrder => maybeWhen(
    loaded: (_, __, ___, ____, _____, ______, sortOrder) => sortOrder,
    orElse: () => 'asc',
  );

  String? get errorMessage => maybeWhen(
    error: (message, _) => message,
    orElse: () => null,
  );

  String? get errorCode => maybeWhen(
    error: (_, code) => code,
    orElse: () => null,
  );

  // Additional helper getters
  bool get hasActiveFilters => maybeWhen(
    loaded: (_, selectedCategory, minPrice, maxPrice, minRating, sortBy, __) {
      return selectedCategory != null ||
          minPrice != null ||
          maxPrice != null ||
          minRating != null ||
          sortBy != null;
    },
    orElse: () => false,
  );

  int get activeFilterCount => maybeWhen(
    loaded: (_, selectedCategory, minPrice, maxPrice, minRating, sortBy, __) {
      int count = 0;
      if (selectedCategory != null) count++;
      if (minPrice != null || maxPrice != null) count++;
      if (minRating != null) count++;
      if (sortBy != null) count++;
      return count;
    },
    orElse: () => 0,
  );

  bool get hasPriceFilter => minPrice != null || maxPrice != null;

  bool get hasCategoryFilter => selectedCategory != null;

  bool get hasRatingFilter => minRating != null;

  bool get hasSortFilter => sortBy != null;

  // Get price range display text
  String get priceRangeText {
    if (!hasPriceFilter) return '';

    final min = minPrice?.toStringAsFixed(0) ?? '0';
    final max = maxPrice?.toStringAsFixed(0) ?? '∞';
    return '\$$min - \$$max';
  }

  // Get rating display text
  String get ratingText {
    if (!hasRatingFilter) return '';
    return '${minRating!.toStringAsFixed(1)}+ stars';
  }

  // Get sort display text
  String get sortText {
    if (!hasSortFilter) return '';

    final sortName = {
      'price': 'Price',
      'rating': 'Rating',
      'name': 'Name',
      'date': 'Date',
      'popularity': 'Popularity',
    }[sortBy] ?? sortBy!;

    final orderText = sortOrder == 'desc' ? 'High to Low' : 'Low to High';
    return '$sortName ($orderText)';
  }

  // Get all active filters as list of strings
  List<String> get activeFiltersList {
    final filters = <String>[];

    if (hasCategoryFilter) {
      filters.add('Category: $selectedCategory');
    }

    if (hasPriceFilter) {
      filters.add('Price: $priceRangeText');
    }

    if (hasRatingFilter) {
      filters.add('Rating: $ratingText');
    }

    if (hasSortFilter) {
      filters.add('Sort: $sortText');
    }

    return filters;
  }

  // Get filter summary text
  String get filterSummary {
    if (!hasActiveFilters) return 'No filters applied';

    final count = activeFilterCount;
    return count == 1 ? '1 filter applied' : '$count filters applied';
  }

  // Available sort options
  static const List<Map<String, String>> sortOptions = [
    {'value': 'price', 'label': 'Price'},
    {'value': 'rating', 'label': 'Rating'},
    {'value': 'name', 'label': 'Name'},
    {'value': 'date', 'label': 'Date Added'},
    {'value': 'popularity', 'label': 'Popularity'},
  ];

  // Available rating options
  static const List<double> ratingOptions = [1.0, 2.0, 3.0, 4.0, 4.5];

  // Check if category is available
  bool isCategoryAvailable(String category) {
    return categories.contains(category);
  }

  // Get display text for current state
  String get displayText {
    return maybeWhen(
      loading: () => 'Loading filters...',
      error: (message, _) => 'Error: $message',
      loaded: (categories, _, __, ___, ____, _____, ______) =>
      '${categories.length} categories available',
      orElse: () => '',
    );
  }
}