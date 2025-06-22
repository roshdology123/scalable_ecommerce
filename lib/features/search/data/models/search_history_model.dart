import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/search_history.dart';
import 'search_query_model.dart';
import 'search_suggestion_model.dart';

part 'search_history_model.freezed.dart';

@freezed
class SearchHistoryModel with _$SearchHistoryModel {
  const factory SearchHistoryModel({
    required List<SearchQueryModel> queries,
    required List<SearchSuggestionModel> suggestions,
    required DateTime lastUpdated,
  }) = _SearchHistoryModel;

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    final queriesList = json['queries'] as List<dynamic>? ?? [];
    final queries = queriesList
        .map((query) => SearchQueryModel.fromJson(query as Map<String, dynamic>))
        .toList();

    final suggestionsList = json['suggestions'] as List<dynamic>? ?? [];
    final suggestions = suggestionsList
        .map((suggestion) => SearchSuggestionModel.fromJson(suggestion as Map<String, dynamic>))
        .toList();

    return SearchHistoryModel(
      queries: queries,
      suggestions: suggestions,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'].toString())
          : DateTime.now(),
    );
  }

  factory SearchHistoryModel.fromSearchHistory(SearchHistory searchHistory) {
    return SearchHistoryModel(
      queries: searchHistory.queries
          .map((query) => SearchQueryModel.fromSearchQuery(query))
          .toList(),
      suggestions: searchHistory.suggestions
          .map((suggestion) => SearchSuggestionModel.fromSearchSuggestion(suggestion))
          .toList(),
      lastUpdated: searchHistory.lastUpdated,
    );
  }

  factory SearchHistoryModel.empty() {
    return SearchHistoryModel(
      queries: [],
      suggestions: [],
      lastUpdated: DateTime.now(),
    );
  }
}

extension SearchHistoryModelExtension on SearchHistoryModel {
  SearchHistory toSearchHistory() {
    return SearchHistory(
      queries: queries.map((query) => query.toSearchQuery()).toList(),
      suggestions: suggestions.map((suggestion) => suggestion.toSearchSuggestion()).toList(),
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'queries': queries.map((query) => query.toJson()).toList(),
      'suggestions': suggestions.map((suggestion) => suggestion.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  SearchHistoryModel addQuery(SearchQueryModel query) {
    final updatedQueries = [query, ...queries];

    // Keep only last 50 queries
    final limitedQueries = updatedQueries.take(50).toList();

    return copyWith(
      queries: limitedQueries,
      lastUpdated: DateTime.now(),
    );
  }

  SearchHistoryModel removeQuery(String queryId) {
    final updatedQueries = queries.where((query) => query.id != queryId).toList();

    return copyWith(
      queries: updatedQueries,
      lastUpdated: DateTime.now(),
    );
  }

  SearchHistoryModel addSuggestion(SearchSuggestionModel suggestion) {
    final existingIndex = suggestions.indexWhere((s) => s.text == suggestion.text);

    List<SearchSuggestionModel> updatedSuggestions;
    if (existingIndex != -1) {
      // Update existing suggestion
      updatedSuggestions = List.from(suggestions);
      updatedSuggestions[existingIndex] = suggestions[existingIndex].incrementUsage();
    } else {
      // Add new suggestion
      updatedSuggestions = [suggestion, ...suggestions];
    }

    // Keep only last 100 suggestions
    final limitedSuggestions = updatedSuggestions.take(100).toList();

    return copyWith(
      suggestions: limitedSuggestions,
      lastUpdated: DateTime.now(),
    );
  }

  SearchHistoryModel clear() {
    return SearchHistoryModel(
      queries: [],
      suggestions: [],
      lastUpdated: DateTime.now(),
    );
  }
}