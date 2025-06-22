import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/search_history.dart';
import '../../../domain/entities/search_query.dart';

part 'search_history_state.freezed.dart';

@freezed
class SearchHistoryState with _$SearchHistoryState {
  const factory SearchHistoryState.initial() = SearchHistoryInitial;

  const factory SearchHistoryState.loading() = SearchHistoryLoading;

  const factory SearchHistoryState.loaded(SearchHistory history) = SearchHistoryLoaded;

  const factory SearchHistoryState.empty() = SearchHistoryEmpty;

  const factory SearchHistoryState.error(
      String message,
      String? code,
      ) = SearchHistoryError;
}

// Extension for easier state checking and data access
extension SearchHistoryStateX on SearchHistoryState {
  bool get isLoading => this is SearchHistoryLoading;
  bool get isLoaded => this is SearchHistoryLoaded;
  bool get isEmpty => this is SearchHistoryEmpty;
  bool get isError => this is SearchHistoryError;
  bool get isInitial => this is SearchHistoryInitial;

  SearchHistory? get searchHistory => maybeWhen(
    loaded: (history) => history,
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
  List<SearchQuery> get queries => searchHistory?.queries ?? [];

  bool get hasData => queries.isNotEmpty;

  int get queryCount => queries.length;

  DateTime? get lastUpdated => searchHistory?.lastUpdated;

  // Get recent queries with limit
  List<SearchQuery> getRecentQueries({int limit = 10}) {
    return queries.take(limit).toList();
  }

  // Get queries from specific time period
  List<SearchQuery> getQueriesFromPeriod(Duration period) {
    final cutoff = DateTime.now().subtract(period);
    return queries.where((query) => query.timestamp.isAfter(cutoff)).toList();
  }

  // Get queries from today
  List<SearchQuery> get todayQueries {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return queries.where((query) => query.timestamp.isAfter(startOfDay)).toList();
  }

  // Get queries from this week
  List<SearchQuery> get weekQueries => getQueriesFromPeriod(const Duration(days: 7));

  // Get most frequent queries
  Map<String, int> get queryFrequency {
    final frequency = <String, int>{};
    for (final query in queries) {
      frequency[query.query] = (frequency[query.query] ?? 0) + 1;
    }
    return frequency;
  }

  // Get top searched terms
  List<String> getTopSearchTerms({int limit = 5}) {
    final frequency = queryFrequency;
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  // Search within history - renamed to avoid conflict
  List<SearchQuery> searchInHistory(String searchTerm) {
    if (searchTerm.isEmpty) return queries;

    final lowerSearchTerm = searchTerm.toLowerCase();
    return queries.where((query) =>
        query.query.toLowerCase().contains(lowerSearchTerm)).toList();
  }

  // Get display text for current state
  String get displayText {
    return maybeWhen(
      loading: () => 'Loading search history...',
      empty: () => 'No search history found',
      error: (message, _) => 'Error: $message',
      loaded: (history) => '${history.queries.length} searches',
      orElse: () => '',
    );
  }

  // Get summary statistics
  Map<String, dynamic> get statistics {
    return {
      'totalQueries': queryCount,
      'uniqueQueries': queryFrequency.keys.length,
      'todayQueries': todayQueries.length,
      'weekQueries': weekQueries.length,
      'lastSearched': queries.isNotEmpty ? queries.first.timestamp : null,
      'firstSearched': queries.isNotEmpty ? queries.last.timestamp : null,
    };
  }
}