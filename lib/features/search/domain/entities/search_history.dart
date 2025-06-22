import 'package:equatable/equatable.dart';
import 'package:scalable_ecommerce/features/search/domain/entities/search_query.dart';
import 'package:scalable_ecommerce/features/search/domain/entities/search_suggestion.dart';

class SearchHistory extends Equatable {
  final List<SearchQuery> queries;
  final List<SearchSuggestion> suggestions;
  final DateTime lastUpdated;

  const SearchHistory({
    required this.queries,
    required this.suggestions,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [queries, suggestions, lastUpdated];

  SearchHistory copyWith({
    List<SearchQuery>? queries,
    List<SearchSuggestion>? suggestions,
    DateTime? lastUpdated,
  }) {
    return SearchHistory(
      queries: queries ?? this.queries,
      suggestions: suggestions ?? this.suggestions,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get isEmpty => queries.isEmpty && suggestions.isEmpty;
  bool get isNotEmpty => queries.isNotEmpty || suggestions.isNotEmpty;

  @override
  String toString() {
    return 'SearchHistory(queries: ${queries.length}, suggestions: ${suggestions.length})';
  }
}