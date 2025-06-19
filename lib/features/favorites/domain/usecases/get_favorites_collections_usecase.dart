import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorites_collection.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesCollectionsUseCase implements UseCase<List<FavoritesCollection>, NoParams> {
  final FavoritesRepository repository;

  const GetFavoritesCollectionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FavoritesCollection>>> call(NoParams params) async {
    try {
      final collections = await repository.getCollections();
      final smartCollections = await repository.getSmartCollections();

      // Combine regular and smart collections
      final allCollections = [...collections, ...smartCollections];

      // Sort by sort order, then by name
      allCollections.sort((a, b) {
        if (a.sortOrder != b.sortOrder) {
          return a.sortOrder.compareTo(b.sortOrder);
        }
        return a.name.compareTo(b.name);
      });

      return Right(allCollections);
    } catch (e) {
      return Left(CacheFailure.readError());
    }
  }
}