import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class RemoveFromFavoritesUseCase implements UseCase<void, RemoveFromFavoritesParams> {
  final FavoritesRepository repository;

  const RemoveFromFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromFavoritesParams params) async {
    try {
      if (params.favoriteId != null) {
        await repository.removeFromFavorites(params.favoriteId!);
      } else if (params.productId != null) {
        await repository.removeFromFavoritesByProductId(params.productId!);
      } else {
        return Left(ValidationFailure.fieldRequired('favoriteId or productId'));
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure.writeError());
    }
  }
}

class RemoveFromFavoritesParams extends Equatable {
  final String? favoriteId;
  final int? productId;

  const RemoveFromFavoritesParams({
    this.favoriteId,
    this.productId,
  });

  @override
  List<Object?> get props => [favoriteId, productId];
}