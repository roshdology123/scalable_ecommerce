import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class ClearFavoritesUseCase implements UseCase<void, ClearFavoritesParams> {
  final FavoritesRepository repository;

  const ClearFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ClearFavoritesParams params) async {
    try {
      if (params.collectionId != null) {
        // Clear specific collection
        final collection = await repository.getCollectionById(params.collectionId!);
        if (collection == null) {
          return const Left(ValidationFailure(message: 'Collection not found'));
        }

        await repository.removeFromCollection(
          params.collectionId!,
          collection.productIds,
        );
      } else {
        // Clear all favorites
        if (params.confirmClearAll != true) {
          return const Left(ValidationFailure(message: 'Confirmation required to clear all favorites'));
        }
        await repository.clearFavorites();
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure.writeError());
    }
  }
}

class ClearFavoritesParams extends Equatable {
  final String? collectionId;
  final bool confirmClearAll;

  const ClearFavoritesParams({
    this.collectionId,
    this.confirmClearAll = false,
  });

  @override
  List<Object?> get props => [collectionId, confirmClearAll];
}