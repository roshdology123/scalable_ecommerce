import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/search_history_model.dart';
import '../models/search_query_model.dart';
import '../models/search_result_model.dart';
import '../models/search_suggestion_model.dart';

abstract class SearchLocalDataSource {
  /// Cache search results
  Future<void> cacheSearchResult(SearchResultModel searchResult);

  /// Get cached search results
  Future<SearchResultModel?> getCachedSearchResult(String query);

  /// Save search query to history
  Future<void> saveSearchQuery(SearchQueryModel searchQuery);

  /// Get search history
  Future<SearchHistoryModel> getSearchHistory();

  /// Delete specific search query
  Future<void> deleteSearchQuery(String queryId);

  /// Clear all search history
  Future<void> clearSearchHistory();

  /// Cache search suggestions
  Future<void> cacheSearchSuggestions(String query, List<SearchSuggestionModel> suggestions);

  /// Get cached search suggestions
  Future<List<SearchSuggestionModel>?> getCachedSearchSuggestions(String query);

  /// Update suggestion usage
  Future<void> updateSuggestionUsage(String suggestionId);

  /// Get recent searches
  Future<List<SearchQueryModel>> getRecentSearches({int limit = 10});

  /// Get search analytics
  Future<Map<String, dynamic>> getSearchAnalytics();

  /// Clear search cache
  Future<void> clearSearchCache();
}

@LazySingleton(as: SearchLocalDataSource)
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String _searchHistoryKey = 'search_history_v2';
  static const String _searchResultCachePrefix = 'search_result_';
  static const String _searchSuggestionsCachePrefix = 'search_suggestions_';
  static const String _searchAnalyticsKey = 'search_analytics_v2';

  @override
  Future<void> cacheSearchResult(SearchResultModel searchResult) async {
    try {
      final cacheKey = '$_searchResultCachePrefix${_sanitizeQuery(searchResult.query)}';
      await LocalStorage.saveToCache(
        cacheKey,
        searchResult.toJson(),
        expiry: AppConstants.cacheDurationShort, // 30 minutes
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<SearchResultModel?> getCachedSearchResult(String query) async {
    try {
      final cacheKey = '$_searchResultCachePrefix${_sanitizeQuery(query)}';
      final cachedData = LocalStorage.getFromCache(cacheKey);

      if (cachedData != null) {
        return SearchResultModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      return null; // Don't throw error for cache misses
    }
  }

  @override
  Future<void> saveSearchQuery(SearchQueryModel searchQuery) async {
    try {
      final history = await getSearchHistory();
      final updatedHistory = history.addQuery(searchQuery);

      await LocalStorage.saveToCache(
        _searchHistoryKey,
        updatedHistory.toJson(),
        expiry: AppConstants.cacheDurationLong, // 30 days
      );

      // Update analytics
      await _updateAnalytics(searchQuery.query, searchQuery.resultCount);

      // Also save to the simple search history for backward compatibility
      await LocalStorage.addSearchQuery(searchQuery.query);
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<SearchHistoryModel> getSearchHistory() async {
    try {
      final cachedData = LocalStorage.getFromCache(_searchHistoryKey);

      if (cachedData != null) {
        return SearchHistoryModel.fromJson(cachedData);
      }

      // If no advanced history exists, create from simple search history
      final simpleHistory = LocalStorage.getSearchHistory();
      final queries = simpleHistory.map((query) => SearchQueryModel.create(
        query: query,
        resultCount: 0,
      )).toList();

      return SearchHistoryModel(
        queries: queries,
        suggestions: [],
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      return SearchHistoryModel.empty();
    }
  }

  @override
  Future<void> deleteSearchQuery(String queryId) async {
    try {
      final history = await getSearchHistory();
      final updatedHistory = history.removeQuery(queryId);

      await LocalStorage.saveToCache(
        _searchHistoryKey,
        updatedHistory.toJson(),
        expiry: AppConstants.cacheDurationLong,
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await LocalStorage.removeFromCache(_searchHistoryKey);
      await LocalStorage.removeFromCache(_searchAnalyticsKey);
      await LocalStorage.clearSearchHistory(); // Clear simple history too
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> cacheSearchSuggestions(String query, List<SearchSuggestionModel> suggestions) async {
    try {
      final cacheKey = '$_searchSuggestionsCachePrefix${_sanitizeQuery(query)}';
      final suggestionsData = {
        'query': query,
        'suggestions': suggestions.map((s) => s.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      await LocalStorage.saveToCache(
        cacheKey,
        suggestionsData,
        expiry: AppConstants.cacheDurationShort, // 30 minutes
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<SearchSuggestionModel>?> getCachedSearchSuggestions(String query) async {
    try {
      final cacheKey = '$_searchSuggestionsCachePrefix${_sanitizeQuery(query)}';
      final cachedData = LocalStorage.getFromCache(cacheKey);

      if (cachedData != null && cachedData['suggestions'] != null) {
        final suggestionsList = cachedData['suggestions'] as List<dynamic>;
        return suggestionsList
            .map((suggestion) => SearchSuggestionModel.fromJson(suggestion as Map<String, dynamic>))
            .toList();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateSuggestionUsage(String suggestionId) async {
    try {
      final history = await getSearchHistory();
      final suggestionIndex = history.suggestions.indexWhere((s) => s.id == suggestionId);

      if (suggestionIndex != -1) {
        final updatedSuggestions = List<SearchSuggestionModel>.from(history.suggestions);
        updatedSuggestions[suggestionIndex] = updatedSuggestions[suggestionIndex].incrementUsage();

        final updatedHistory = history.copyWith(
          suggestions: updatedSuggestions,
          lastUpdated: DateTime.now(),
        );

        await LocalStorage.saveToCache(
          _searchHistoryKey,
          updatedHistory.toJson(),
          expiry: AppConstants.cacheDurationLong,
        );
      }
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<SearchQueryModel>> getRecentSearches({int limit = 10}) async {
    try {
      final history = await getSearchHistory();
      return history.queries.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getSearchAnalytics() async {
    try {
      final cachedData = LocalStorage.getFromCache(_searchAnalyticsKey);

      if (cachedData != null) {
        return cachedData;
      }

      return {
        'totalSearches': 0,
        'popularQueries': <String, int>{},
        'averageResultsPerSearch': 0.0,
        'lastSearchDate': null,
        'totalResults': 0,
        'successfulSearches': 0,
        'emptySearches': 0,
      };
    } catch (e) {
      return {
        'totalSearches': 0,
        'popularQueries': <String, int>{},
        'averageResultsPerSearch': 0.0,
        'lastSearchDate': null,
        'totalResults': 0,
        'successfulSearches': 0,
        'emptySearches': 0,
      };
    }
  }

  @override
  Future<void> clearSearchCache() async {
    try {
      // Clear all search-related cache entries by clearing the entire cache
      // and then re-saving non-search related data (this is a simple approach)
      // In a more sophisticated implementation, you would iterate through cache keys
      await LocalStorage.clearCache();
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  // Helper methods
  String _sanitizeQuery(String query) {
    return query.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }

  Future<void> _updateAnalytics(String query, int resultCount) async {
    try {
      final analytics = await getSearchAnalytics();

      final totalSearches = (analytics['totalSearches'] as int? ?? 0) + 1;
      final popularQueries = Map<String, int>.from(analytics['popularQueries'] as Map? ?? {});
      popularQueries[query] = (popularQueries[query] ?? 0) + 1;

      final totalResults = (analytics['totalResults'] as int? ?? 0) + resultCount;
      final successfulSearches = (analytics['successfulSearches'] as int? ?? 0) + (resultCount > 0 ? 1 : 0);
      final emptySearches = (analytics['emptySearches'] as int? ?? 0) + (resultCount == 0 ? 1 : 0);

      final averageResultsPerSearch = totalSearches > 0 ? totalResults / totalSearches : 0.0;

      final updatedAnalytics = {
        'totalSearches': totalSearches,
        'popularQueries': popularQueries,
        'averageResultsPerSearch': averageResultsPerSearch,
        'lastSearchDate': DateTime.now().toIso8601String(),
        'totalResults': totalResults,
        'successfulSearches': successfulSearches,
        'emptySearches': emptySearches,
      };

      await LocalStorage.saveToCache(
        _searchAnalyticsKey,
        updatedAnalytics,
        expiry: AppConstants.cacheDurationLong,
      );
    } catch (e) {
      // Ignore analytics errors
    }
  }
}