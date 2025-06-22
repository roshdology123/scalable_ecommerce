import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/search_suggestion.dart';

part 'search_suggestions_state.freezed.dart';

@freezed
class SearchSuggestionsState with _$SearchSuggestionsState {
  const factory SearchSuggestionsState.initial() = SearchSuggestionsInitial;

  const factory SearchSuggestionsState.loading() = SearchSuggestionsLoading;

  const factory SearchSuggestionsState.loaded(
      List<SearchSuggestion> suggestions,
      String query,
      ) = SearchSuggestionsLoaded;

  const factory SearchSuggestionsState.empty(String query) = SearchSuggestionsEmpty;

  const factory SearchSuggestionsState.error(
      String message,
      String? code,
      ) = SearchSuggestionsError;
}

// Extension for easier state checking and data access
extension SearchSuggestionsStateX on SearchSuggestionsState {
  bool get isLoading => this is SearchSuggestionsLoading;
  bool get isLoaded => this is SearchSuggestionsLoaded;
  bool get isEmpty => this is SearchSuggestionsEmpty;
  bool get isError => this is SearchSuggestionsError;
  bool get isInitial => this is SearchSuggestionsInitial;

  List<SearchSuggestion> get suggestions => maybeWhen(
    loaded: (suggestions, _) => suggestions,
    orElse: () => [],
  );

  String? get query => maybeWhen(
    loaded: (_, query) => query,
    empty: (query) => query,
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

  // Additional helper getters
  bool get hasData => suggestions.isNotEmpty;

  List<SearchSuggestion> get productSuggestions => suggestions
      .where((suggestion) => suggestion.type == SuggestionType.product)
      .toList();

  List<SearchSuggestion> get categorySuggestions => suggestions
      .where((suggestion) => suggestion.type == SuggestionType.category)
      .toList();

  List<SearchSuggestion> get brandSuggestions => suggestions
      .where((suggestion) => suggestion.type == SuggestionType.brand)
      .toList();

  List<SearchSuggestion> get recentSuggestions => suggestions
      .where((suggestion) => suggestion.type == SuggestionType.recent)
      .toList();

  List<SearchSuggestion> get popularSuggestions => suggestions
      .where((suggestion) => suggestion.type == SuggestionType.popular)
      .toList();

  // Get suggestions by type with limit
  List<SearchSuggestion> getSuggestionsByType(SuggestionType type, {int? limit}) {
    final filtered = suggestions.where((s) => s.type == type).toList();
    return limit != null ? filtered.take(limit).toList() : filtered;
  }

  // Get display text for current state
  String get displayText {
    return maybeWhen(
      loading: () => 'Loading suggestions...',
      empty: (query) => query.isEmpty
          ? 'Start typing to get suggestions'
          : 'No suggestions found for "$query"',
      error: (message, _) => 'Error: $message',
      loaded: (suggestions, query) => query.isEmpty
          ? 'Popular searches'
          : '${suggestions.length} suggestions for "$query"',
      orElse: () => '',
    );
  }

  // Check if we should show suggestions
  bool get shouldShow => isLoaded && hasData;
}