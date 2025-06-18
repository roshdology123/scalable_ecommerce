import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

@injectable
class SearchProductsUseCase implements UseCase<List<Product>, SearchProductsParams> {
  final ProductsRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchProductsParams params) async {
    // Validate parameters
    if (params.query.length < 2 && params.query.isNotEmpty) {
      return const Left(ValidationFailure(
        message: 'Search query must be at least 2 characters long',
        code: 'QUERY_TOO_SHORT',
      ));
    }

    if (params.page < 1) {
      return const Left(ValidationFailure(
        message: 'Page number must be greater than 0',
        code: 'INVALID_PAGE',
      ));
    }

    if (params.limit < 1 || params.limit > 100) {
      return const Left(ValidationFailure(
        message: 'Limit must be between 1 and 100',
        code: 'INVALID_LIMIT',
      ));
    }

    if (params.minPrice != null && params.minPrice! < 0) {
      return const Left(ValidationFailure(
        message: 'Minimum price cannot be negative',
        code: 'INVALID_MIN_PRICE',
      ));
    }

    if (params.maxPrice != null && params.maxPrice! < 0) {
      return const Left(ValidationFailure(
        message: 'Maximum price cannot be negative',
        code: 'INVALID_MAX_PRICE',
      ));
    }

    if (params.minPrice != null &&
        params.maxPrice != null &&
        params.minPrice! > params.maxPrice!) {
      return const Left(ValidationFailure(
        message: 'Minimum price cannot be greater than maximum price',
        code: 'INVALID_PRICE_RANGE',
      ));
    }

    if (params.minRating != null &&
        (params.minRating! < 0 || params.minRating! > 5)) {
      return const Left(ValidationFailure(
        message: 'Minimum rating must be between 0 and 5',
        code: 'INVALID_MIN_RATING',
      ));
    }

    return await repository.searchProducts(
      query: params.query,
      page: params.page,
      limit: params.limit,
      category: params.category,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      minRating: params.minRating,
    );
  }
}

class SearchProductsParams extends Equatable {
  final String query;
  final int page;
  final int limit;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;

  const SearchProductsParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
  });

  SearchProductsParams copyWith({
    String? query,
    int? page,
    int? limit,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) {
    return SearchProductsParams(
      query: query ?? this.query,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
    );
  }

  /// Get filters as a map for easy display
  Map<String, dynamic> get activeFilters {
    final filters = <String, dynamic>{};

    if (category != null && category!.isNotEmpty) {
      filters['category'] = category;
    }
    if (minPrice != null) {
      filters['minPrice'] = minPrice;
    }
    if (maxPrice != null) {
      filters['maxPrice'] = maxPrice;
    }
    if (minRating != null) {
      filters['minRating'] = minRating;
    }

    return filters;
  }

  /// Check if any filters are active
  bool get hasActiveFilters => activeFilters.isNotEmpty;

  /// Get price range as string
  String? get priceRangeString {
    if (minPrice == null && maxPrice == null) return null;
    if (minPrice != null && maxPrice != null) {
      return '\$${minPrice!.toStringAsFixed(0)} - \$${maxPrice!.toStringAsFixed(0)}';
    }
    if (minPrice != null) {
      return 'From \$${minPrice!.toStringAsFixed(0)}';
    }
    if (maxPrice != null) {
      return 'Up to \$${maxPrice!.toStringAsFixed(0)}';
    }
    return null;
  }

  @override
  List<Object?> get props => [
    query,
    page,
    limit,
    category,
    minPrice,
    maxPrice,
    minRating,
  ];

  @override
  String toString() => 'SearchProductsParams(query: "$query", filters: $activeFilters)';
}