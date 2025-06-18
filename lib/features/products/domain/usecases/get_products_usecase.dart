import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

@injectable
class GetProductsUseCase implements UseCase<List<Product>, GetProductsParams> {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    // Validate parameters
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

    if (params.sortBy != null &&
        !['price', 'rating', 'title', 'created_at', 'popularity'].contains(params.sortBy)) {
      return const Left(ValidationFailure(
        message: 'Invalid sort field. Allowed: price, rating, title, created_at, popularity',
        code: 'INVALID_SORT_BY',
      ));
    }

    if (params.sortOrder != null &&
        !['asc', 'desc'].contains(params.sortOrder?.toLowerCase())) {
      return const Left(ValidationFailure(
        message: 'Sort order must be either "asc" or "desc"',
        code: 'INVALID_SORT_ORDER',
      ));
    }

    return await repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

class GetProductsParams extends Equatable {
  final int page;
  final int limit;
  final String? category;
  final String? sortBy;
  final String? sortOrder;

  const GetProductsParams({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.sortBy,
    this.sortOrder,
  });

  GetProductsParams copyWith({
    int? page,
    int? limit,
    String? category,
    String? sortBy,
    String? sortOrder,
  }) {
    return GetProductsParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [page, limit, category, sortBy, sortOrder];

  @override
  String toString() => 'GetProductsParams(page: $page, limit: $limit, category: $category)';
}