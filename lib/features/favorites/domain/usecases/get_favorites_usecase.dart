import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_item.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase implements UseCase<List<FavoriteItem>, GetFavoritesParams> {
  final FavoritesRepository repository;

  const GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<FavoriteItem>>> call(GetFavoritesParams params) async {
    try {
      final favorites = await repository.getFavorites(
        collectionId: params.collectionId,
        category: params.category,
        sortBy: params.sortBy,
        sortOrder: params.sortOrder,
        limit: params.limit,
        offset: params.offset,
      );

      // Apply additional filtering if specified
      var filteredFavorites = favorites;

      if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
        final query = params.searchQuery!.toLowerCase();
        filteredFavorites = filteredFavorites.where((item) =>
        item.productTitle.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query) ||
            (item.brand?.toLowerCase().contains(query) ?? false)
        ).toList();
      }

      if (params.minPrice != null) {
        filteredFavorites = filteredFavorites.where((item) => item.price >= params.minPrice!).toList();
      }

      if (params.maxPrice != null) {
        filteredFavorites = filteredFavorites.where((item) => item.price <= params.maxPrice!).toList();
      }

      if (params.minRating != null) {
        filteredFavorites = filteredFavorites.where((item) => item.rating >= params.minRating!).toList();
      }

      if (params.inStockOnly == true) {
        filteredFavorites = filteredFavorites.where((item) => item.inStock).toList();
      }

      if (params.onSaleOnly == true) {
        filteredFavorites = filteredFavorites.where((item) => item.isOnSale).toList();
      }

      if (params.tags != null && params.tags!.isNotEmpty) {
        filteredFavorites = filteredFavorites.where((item) {
          final itemTags = [...item.tags.values, ...item.getAutoTags()];
          return params.tags!.every((tag) => itemTags.contains(tag));
        }).toList();
      }

      return Right(filteredFavorites);
    } catch (e) {
      return Left(CacheFailure.readError());
    }
  }
}

class GetFavoritesParams extends Equatable {
  final String? collectionId;
  final String? category;
  final String? sortBy;
  final String? sortOrder;
  final int? limit;
  final int? offset;
  final String? searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? inStockOnly;
  final bool? onSaleOnly;
  final List<String>? tags;

  const GetFavoritesParams({
    this.collectionId,
    this.category,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
    this.searchQuery,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.inStockOnly,
    this.onSaleOnly,
    this.tags,
  });

  @override
  List<Object?> get props => [
    collectionId,
    category,
    sortBy,
    sortOrder,
    limit,
    offset,
    searchQuery,
    minPrice,
    maxPrice,
    minRating,
    inStockOnly,
    onSaleOnly,
    tags,
  ];
}