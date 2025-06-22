import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/storage/local_storage.dart';
import '../../../domain/entities/search_history.dart';
import '../../../domain/entities/search_query.dart';
import 'search_history_state.dart';

@injectable
class SearchHistoryCubit extends Cubit<SearchHistoryState> {
  SearchHistoryCubit() : super(const SearchHistoryState.initial());

  /// Load search history from local storage
  Future<void> loadSearchHistory() async {
    emit(const SearchHistoryState.loading());

    try {
      // Get simple search history from LocalStorage
      final simpleHistory = LocalStorage.getSearchHistory();

      if (simpleHistory.isEmpty) {
        emit(const SearchHistoryState.empty());
        return;
      }

      // Convert to SearchQuery objects
      final queries = simpleHistory.asMap().entries.map((entry) {
        final index = entry.key;
        final query = entry.value;

        return SearchQuery(
          id: 'query_$index',
          query: query,
          timestamp: DateTime.now().subtract(Duration(days: index)),
          resultCount: 0, // We don't have this data from simple history
        );
      }).toList();

      final searchHistory = SearchHistory(
        queries: queries,
        suggestions: const [],
        lastUpdated: DateTime.now(),
      );

      emit(SearchHistoryState.loaded(searchHistory));
    } catch (e) {
      emit(SearchHistoryState.error(
        'Failed to load search history: ${e.toString()}',
        'LOAD_HISTORY_ERROR',
      ));
    }
  }

  /// Add a search query to history
  Future<void> addSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    try {
      // Add to simple history
      await LocalStorage.addSearchQuery(query);

      // Reload to update the state
      await loadSearchHistory();
    } catch (e) {
      // Handle error silently for now, or show a toast
    }
  }

  /// Delete a specific search query
  Future<void> deleteSearchQuery(String queryText) async {
    try {
      // Get current history
      final currentHistory = LocalStorage.getSearchHistory();

      // Remove the query
      currentHistory.remove(queryText);

      // Clear and re-add all queries
      await LocalStorage.clearSearchHistory();
      for (final historyQuery in currentHistory) {
        await LocalStorage.addSearchQuery(historyQuery);
      }

      // Reload to update the state
      await loadSearchHistory();
    } catch (e) {
      emit(SearchHistoryState.error(
        'Failed to delete search query: ${e.toString()}',
        'DELETE_QUERY_ERROR',
      ));
    }
  }

  /// Clear all search history
  Future<void> clearSearchHistory() async {
    try {
      await LocalStorage.clearSearchHistory();
      emit(const SearchHistoryState.empty());
    } catch (e) {
      emit(SearchHistoryState.error(
        'Failed to clear search history: ${e.toString()}',
        'CLEAR_HISTORY_ERROR',
      ));
    }
  }

  /// Get recent searches (convenience method)
  List<String> getRecentSearches({int limit = 10}) {
    return state.searchHistory?.queries
        .take(limit)
        .map((query) => query.query)
        .toList() ?? [];
  }

  /// Check if query exists in history
  bool hasQuery(String query) {
    return state.searchHistory?.queries
        .any((q) => q.query.toLowerCase() == query.toLowerCase()) ?? false;
  }

  /// Get search frequency for analytics
  Map<String, int> getSearchFrequency() {
    final history = state.searchHistory;
    if (history == null) return {};

    final frequency = <String, int>{};
    for (final query in history.queries) {
      frequency[query.query] = (frequency[query.query] ?? 0) + 1;
    }

    return frequency;
  }

  /// Get most searched terms
  List<String> getMostSearchedTerms({int limit = 5}) {
    final frequency = getSearchFrequency();
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  /// Search within history
  List<SearchQuery> searchInHistory(String searchTerm) {
    return state.searchInHistory(searchTerm);
  }

  /// Refresh search history
  Future<void> refresh() async {
    await loadSearchHistory();
  }
}