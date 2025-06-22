import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:scalable_ecommerce/features/search/data/models/search_history_model.dart';
import 'package:scalable_ecommerce/features/search/data/models/search_result_model.dart';
import 'package:scalable_ecommerce/features/search/data/models/search_suggestion_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/search_history.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datastore.dart';
import '../datasources/search_remote_datasource.dart';
import '../models/search_query_model.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final SearchLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  SearchRepositoryImpl(
      this._remoteDataSource,
      this._localDataSource,
      this._networkInfo,
      );

  @override
  Future<Either<Failure, SearchResult>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final searchResult = await _remoteDataSource.searchProducts(
          query: query,
          page: page,
          limit: limit,
          category: category,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
        );

        // Cache the results (only first page)
        if (page == 1 && query.isNotEmpty) {
          await _localDataSource.cacheSearchResult(searchResult);
        }

        // Save search query to history
        if (query.isNotEmpty) {
          final searchQuery = SearchQueryModel.create(
            query: query,
            category: category,
            minPrice: minPrice,
            maxPrice: maxPrice,
            minRating: minRating,
            resultCount: searchResult.products.length,
          );
          await _localDataSource.saveSearchQuery(searchQuery);
        }

        return Right(searchResult.toSearchResult());
      } else {
        // Try to get from cache
        if (query.isNotEmpty && page == 1) {
          final cachedResult = await _localDataSource.getCachedSearchResult(query);
          if (cachedResult != null) {
            return Right(cachedResult.toSearchResult());
          }
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to search products: ${e.toString()}',
        code: 'SEARCH_PRODUCTS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<SearchSuggestion>>> getSearchSuggestions({
    required String query,
    int limit = 10,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final suggestions = await _remoteDataSource.getSearchSuggestions(
          query: query,
          limit: limit,
        );

        // Cache the suggestions
        if (query.isNotEmpty) {
          await _localDataSource.cacheSearchSuggestions(query, suggestions);
        }

        return Right(
          suggestions.map((suggestion) => suggestion.toSearchSuggestion()).toList(),
        );
      } else {
        // Try to get from cache
        if (query.isNotEmpty) {
          final cachedSuggestions = await _localDataSource.getCachedSearchSuggestions(query);
          if (cachedSuggestions != null) {
            return Right(
              cachedSuggestions.map((suggestion) => suggestion.toSearchSuggestion()).toList(),
            );
          }
        }

        // Return recent searches as fallback
        final recentSearches = await _localDataSource.getRecentSearches(limit: limit);
        final suggestions = recentSearches
            .where((searchQuery) => searchQuery.query.toLowerCase().contains(query.toLowerCase()))
            .map((searchQuery) => SearchSuggestion(
          id: searchQuery.id,
          text: searchQuery.query,
          type: SuggestionType.recent,
          searchCount: 0,
          lastUsed: searchQuery.timestamp,
          category: searchQuery.category,
        ))
            .toList();

        return Right(suggestions);
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get search suggestions: ${e.toString()}',
        code: 'GET_SEARCH_SUGGESTIONS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchQuery(SearchQuery searchQuery) async {
    try {
      final searchQueryModel = SearchQueryModel.fromSearchQuery(searchQuery);
      await _localDataSource.saveSearchQuery(searchQueryModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to save search query: ${e.toString()}',
        code: 'SAVE_SEARCH_QUERY_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, SearchHistory>> getSearchHistory() async {
    try {
      final searchHistory = await _localDataSource.getSearchHistory();
      return Right(searchHistory.toSearchHistory());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get search history: ${e.toString()}',
        code: 'GET_SEARCH_HISTORY_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchQuery(String queryId) async {
    try {
      await _localDataSource.deleteSearchQuery(queryId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to delete search query: ${e.toString()}',
        code: 'DELETE_SEARCH_QUERY_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      await _localDataSource.clearSearchHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to clear search history: ${e.toString()}',
        code: 'CLEAR_SEARCH_HISTORY_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPopularSearches({int limit = 10}) async {
    try {
      if (await _networkInfo.isConnected) {
        final popularSearches = await _remoteDataSource.getPopularSearches(limit: limit);
        return Right(popularSearches);
      } else {
        // Get from analytics
        final analytics = await _localDataSource.getSearchAnalytics();
        final popularQueries = analytics['popularQueries'] as Map<String, dynamic>? ?? {};

        final sortedQueries = popularQueries.entries.toList()
          ..sort((a, b) => (b.value as int).compareTo(a.value as int));

        final popularSearches = sortedQueries
            .take(limit)
            .map((entry) => entry.key)
            .toList();

        return Right(popularSearches);
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get popular searches: ${e.toString()}',
        code: 'GET_POPULAR_SEARCHES_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<SearchQuery>>> getRecentSearches({int limit = 10}) async {
    try {
      final recentSearches = await _localDataSource.getRecentSearches(limit: limit);
      return Right(
        recentSearches.map((searchQuery) => searchQuery.toSearchQuery()).toList(),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get recent searches: ${e.toString()}',
        code: 'GET_RECENT_SEARCHES_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateSuggestionUsage(String suggestionId) async {
    try {
      await _localDataSource.updateSuggestionUsage(suggestionId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to update suggestion usage: ${e.toString()}',
        code: 'UPDATE_SUGGESTION_USAGE_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSearchAnalytics() async {
    try {
      final analytics = await _localDataSource.getSearchAnalytics();
      return Right(analytics);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get search analytics: ${e.toString()}',
        code: 'GET_SEARCH_ANALYTICS_ERROR',
      ));
    }
  }
}