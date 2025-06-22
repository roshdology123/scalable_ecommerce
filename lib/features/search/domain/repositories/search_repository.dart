import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/search_history.dart';
import '../entities/search_query.dart';
import '../entities/search_result.dart';
import '../entities/search_suggestion.dart';

abstract class SearchRepository {
  /// Search products with filters
  Future<Either<Failure, SearchResult>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  });

  /// Get search suggestions based on query
  Future<Either<Failure, List<SearchSuggestion>>> getSearchSuggestions({
    required String query,
    int limit = 10,
  });

  /// Save search query to history
  Future<Either<Failure, void>> saveSearchQuery(SearchQuery searchQuery);

  /// Get search history
  Future<Either<Failure, SearchHistory>> getSearchHistory();

  /// Delete specific search query from history
  Future<Either<Failure, void>> deleteSearchQuery(String queryId);

  /// Clear all search history
  Future<Either<Failure, void>> clearSearchHistory();

  /// Get popular search terms
  Future<Either<Failure, List<String>>> getPopularSearches({int limit = 10});

  /// Get recent search queries
  Future<Either<Failure, List<SearchQuery>>> getRecentSearches({int limit = 10});

  /// Update search suggestion usage
  Future<Either<Failure, void>> updateSuggestionUsage(String suggestionId);

  /// Get search analytics
  Future<Either<Failure, Map<String, dynamic>>> getSearchAnalytics();
}