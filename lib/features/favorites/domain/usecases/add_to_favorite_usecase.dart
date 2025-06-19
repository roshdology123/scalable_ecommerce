import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_item.dart';
import '../repositories/favorites_repository.dart';
import '../../../products/domain/entities/product.dart';

class AddToFavoritesUseCase implements UseCase<void, AddToFavoritesParams> {
  final FavoritesRepository repository;

  const AddToFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToFavoritesParams params) async {
    try {
      // Check if already in favorites
      final isAlreadyFavorite = await repository.isFavorite(params.product.id);
      if (isAlreadyFavorite) {
        return const Left(ValidationFailure( message: 'Product is already in favorites'));
      }

      // Create favorite item from product
      final favoriteItem = FavoriteItem(
        id: _generateFavoriteId(params.product.id),
        productId: params.product.id,
        productTitle: params.product.title,
        productImage: params.product.image,
        price: params.product.price,
        originalPrice: params.product.originalPrice,
        category: params.product.category,
        brand: params.product.brand,
        rating: params.product.rating.rate,
        isAvailable: params.product.isAvailable,
        inStock: params.product.inStock,
        addedAt: DateTime.now(),
        collectionId: params.collectionId,
        tags: params.tags,
        notes: params.notes,
        isPriceTrackingEnabled: params.enablePriceTracking,
        targetPrice: params.targetPrice,
        metadata: params.metadata,
      );

      await repository.addToFavorites(favoriteItem);

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to add product to favorites: ${e.toString()}',
        code: 'add_to_favorites_error',
        data: '${params.product.id}',
      ));
    }
  }

  String _generateFavoriteId(int productId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'fav_${productId}_$timestamp';
  }
}

class AddToFavoritesParams extends Equatable {
  final Product product;
  final String? collectionId;
  final Map<String, String> tags;
  final String? notes;
  final bool enablePriceTracking;
  final double? targetPrice;
  final Map<String, dynamic> metadata;

  const AddToFavoritesParams({
    required this.product,
    this.collectionId,
    this.tags = const {},
    this.notes,
    this.enablePriceTracking = false,
    this.targetPrice,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    product,
    collectionId,
    tags,
    notes,
    enablePriceTracking,
    targetPrice,
    metadata,
  ];
}