import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

@injectable
class SearchProductsUseCase extends UseCase<SearchResult, SearchProductsParams> {
  final SearchRepository _repository;

  SearchProductsUseCase(this._repository);

  @override
  Future<Either<Failure, SearchResult>> call(SearchProductsParams params) async {
    return await _repository.searchProducts(
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
  String toString() {
    return 'SearchProductsParams(query: $query, page: $page, limit: $limit)';
  }
}