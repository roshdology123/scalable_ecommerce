import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

@injectable
class GetProductsByCategoryUseCase implements UseCase<List<Product>, GetProductsByCategoryParams> {
  final ProductsRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsByCategoryParams params) async {
    // Validate parameters
    if (params.category.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Category is required',
        code: 'EMPTY_CATEGORY',
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

    if (params.sortBy != null &&
        !['price', 'rating', 'title', 'created_at', 'popularity'].contains(params.sortBy)) {
      return const Left(ValidationFailure(
        message: 'Invalid sort field',
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

    return await repository.getProductsByCategory(
      category: params.category,
      page: params.page,
      limit: params.limit,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

class GetProductsByCategoryParams extends Equatable {
  final String category;
  final int page;
  final int limit;
  final String? sortBy;
  final String? sortOrder;

  const GetProductsByCategoryParams({
    required this.category,
    this.page = 1,
    this.limit = 20,
    this.sortBy,
    this.sortOrder,
  });

  GetProductsByCategoryParams copyWith({
    String? category,
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
  }) {
    return GetProductsByCategoryParams(
      category: category ?? this.category,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [category, page, limit, sortBy, sortOrder];

  @override
  String toString() => 'GetProductsByCategoryParams(category: $category, page: $page)';
}