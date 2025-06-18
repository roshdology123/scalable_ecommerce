import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

@injectable
class GetProductByIdUseCase implements UseCase<Product, GetProductByIdParams> {
  final ProductsRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductByIdParams params) async {
    // Validate product ID
    if (params.productId <= 0) {
      return const Left(ValidationFailure(
        message: 'Product ID must be greater than 0',
        code: 'INVALID_PRODUCT_ID',
      ));
    }

    return await repository.getProductById(params.productId);
  }
}

class GetProductByIdParams extends Equatable {
  final int productId;

  const GetProductByIdParams({required this.productId});

  @override
  List<Object?> get props => [productId];

  @override
  String toString() => 'GetProductByIdParams(productId: $productId)';
}