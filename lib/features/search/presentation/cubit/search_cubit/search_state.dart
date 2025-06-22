import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/search_result.dart';


part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = SearchInitial;

  const factory SearchState.loading() = SearchLoading;

  const factory SearchState.loaded(
      SearchResult searchResult, {
        @Default(false) bool hasReachedMax,
        @Default(1) int currentPage,
        String? category,
        String? sortBy,
      }) = SearchLoaded;

  const factory SearchState.loadingMore(
      SearchResult searchResult, {
        @Default(false) bool hasReachedMax,
        @Default(1) int currentPage,
        String? category,
        String? sortBy,
      }) = SearchLoadingMore;

  const factory SearchState.empty(String query) = SearchEmpty;

  const factory SearchState.error(
      String message,
      String? code,
      ) = SearchError;
}

// Extension for easier state checking and data access
extension SearchStateX on SearchState {
  bool get isLoading => this is SearchLoading;
  bool get isLoadingMore => this is SearchLoadingMore;
  bool get isLoaded => this is SearchLoaded;
  bool get isEmpty => this is SearchEmpty;
  bool get isError => this is SearchError;
  bool get isInitial => this is SearchInitial;

  SearchResult? get searchResult => maybeWhen(
    loaded: (result, _, __, ___, ____) => result,
    loadingMore: (result, _, __, ___, ____) => result,
    orElse: () => null,
  );

  bool get hasReachedMax => maybeWhen(
    loaded: (_, hasReachedMax, __, ___, ____) => hasReachedMax,
    loadingMore: (_, hasReachedMax, __, ___, ____) => hasReachedMax,
    orElse: () => false,
  );

  int get currentPage => maybeWhen(
    loaded: (_, __, currentPage, ___, ____) => currentPage,
    loadingMore: (_, __, currentPage, ___, ____) => currentPage,
    orElse: () => 1,
  );

  String? get category => maybeWhen(
    loaded: (_, __, ___, category, ____) => category,
    loadingMore: (_, __, ___, category, ____) => category,
    orElse: () => null,
  );

  String? get sortBy => maybeWhen(
    loaded: (_, __, ___, ____, sortBy) => sortBy,
    loadingMore: (_, __, ___, ____, sortBy) => sortBy,
    orElse: () => null,
  );

  String? get errorMessage => maybeWhen(
    error: (message, _) => message,
    orElse: () => null,
  );

  String? get errorCode => maybeWhen(
    error: (_, code) => code,
    orElse: () => null,
  );

  String? get emptyQuery => maybeWhen(
    empty: (query) => query,
    orElse: () => null,
  );

  // Additional helper getters for easier UI access
  String? get query => searchResult?.query;

  List<String> get categories => searchResult?.categories ?? [];

  int get totalResults => searchResult?.totalResults ?? 0;

  DateTime? get timestamp => searchResult?.timestamp;

  Map<String, int> get categoryCount => searchResult?.categoryCount ?? {};

  double? get averagePrice => searchResult?.averagePrice;

  double? get averageRating => searchResult?.averageRating;

  // State validation helpers
  bool get hasData => searchResult != null && searchResult!.isNotEmpty;

  bool get hasProducts => searchResult?.products.isNotEmpty ?? false;

  bool get canLoadMore => hasProducts && !hasReachedMax && !isLoading;

  bool get hasError => isError;

  bool get isLoadingData => isLoading || isLoadingMore;

  // Search context helpers
  bool get hasFilters => category != null || sortBy != null;

  String get searchSummary {
    if (searchResult == null) return '';

    final result = searchResult!;
    return '${result.totalResults} results for "${result.query}"';
  }

  String get filterSummary {
    final filters = <String>[];

    if (category != null) {
      filters.add('Category: $category');
    }

    if (sortBy != null) {
      filters.add('Sort: $sortBy');
    }

    return filters.isNotEmpty ? filters.join(', ') : '';
  }
}