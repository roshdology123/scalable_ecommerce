import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class IsFavoriteUseCase implements UseCase<bool, int> {
  final FavoritesRepository repository;

  const IsFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(int productId) async {
    try {
      final isFavorite = await repository.isFavorite(productId);
      return Right(isFavorite);
    } catch (e) {
      return Left(CacheFailure.readError());
    }
  }
}