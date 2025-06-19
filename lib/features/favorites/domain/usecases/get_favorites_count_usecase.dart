import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesCountUseCase implements UseCase<int, NoParams> {
  final FavoritesRepository repository;

  const GetFavoritesCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    try {
      final count = await repository.getFavoritesCount();
      return Right(count);
    } catch (e) {
      return Left(CacheFailure.readError());
    }
  }
}