import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class OrganizeFavoritesUseCase implements UseCase<void, OrganizeFavoritesParams> {
  final FavoritesRepository repository;

  const OrganizeFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(OrganizeFavoritesParams params) async {
    try {
      switch (params.action) {
        case OrganizeAction.moveToCollection:
          await _moveToCollection(params);
          break;
        case OrganizeAction.removeFromCollection:
          await _removeFromCollection(params);
          break;
        case OrganizeAction.addToCollection:
          await _addToCollection(params);
          break;
        case OrganizeAction.copyToCollection:
          await _copyToCollection(params);
          break;
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure.writeError());
    }
  }

  Future<void> _moveToCollection(OrganizeFavoritesParams params) async {
    if (params.targetCollectionId == null) {
      throw ValidationFailure.fieldRequired('targetCollectionId');
    }

    // Remove from current collections
    for (final productId in params.productIds) {
      final favorite = await repository.getFavoriteByProductId(int.parse(productId));
      if (favorite != null && favorite.collectionId != null) {
        await repository.removeFromCollection(favorite.collectionId!, [productId]);
      }
    }

    // Add to target collection
    await repository.addToCollection(params.targetCollectionId!, params.productIds);
  }

  Future<void> _removeFromCollection(OrganizeFavoritesParams params) async {
    if (params.sourceCollectionId == null) {
      throw ValidationFailure.fieldRequired('sourceCollectionId');
    }

    await repository.removeFromCollection(params.sourceCollectionId!, params.productIds);
  }

  Future<void> _addToCollection(OrganizeFavoritesParams params) async {
    if (params.targetCollectionId == null) {
      throw ValidationFailure.fieldRequired('targetCollectionId');
    }

    await repository.addToCollection(params.targetCollectionId!, params.productIds);
  }

  Future<void> _copyToCollection(OrganizeFavoritesParams params) async {
    if (params.targetCollectionId == null) {
      throw ValidationFailure.fieldRequired('targetCollectionId');
    }

    // Simply add to target collection (keeping in source)
    await repository.addToCollection(params.targetCollectionId!, params.productIds);
  }
}

enum OrganizeAction {
  moveToCollection,
  removeFromCollection,
  addToCollection,
  copyToCollection,
}

class OrganizeFavoritesParams extends Equatable {
  final OrganizeAction action;
  final List<String> productIds;
  final String? sourceCollectionId;
  final String? targetCollectionId;

  const OrganizeFavoritesParams({
    required this.action,
    required this.productIds,
    this.sourceCollectionId,
    this.targetCollectionId,
  });

  @override
  List<Object?> get props => [action, productIds, sourceCollectionId, targetCollectionId];
}