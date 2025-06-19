import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/entities/favorites_collection.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datastore.dart';
import '../datasources/favorites_remote_datastore.dart';
import '../models/favorite_item_model.dart';
import '../models/favorites_collection_model.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  final FavoritesRemoteDataSource remoteDataSource;

  const FavoritesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<FavoriteItem>> getFavorites({
    String? collectionId,
    String? category,
    String? sortBy,
    String? sortOrder,
    int? limit,
    int? offset,
  }) async {
    try {
      final favoriteModels = await localDataSource.getFavorites(
        collectionId: collectionId,
        category: category,
        sortBy: sortBy,
        sortOrder: sortOrder,
        limit: limit,
        offset: offset,
      );

      return favoriteModels.map((model) => model.toFavoriteItem()).toList();
    } catch (e) {
      throw CacheFailure.readError();
    }
  }

  @override
  Future<FavoriteItem?> getFavoriteById(String id) async {
    try {
      final favoriteModel = await localDataSource.getFavoriteById(id);
      return favoriteModel?.toFavoriteItem();
    } catch (e) {
      throw CacheFailure.readError();
    }
  }

  @override
  Future<FavoriteItem?> getFavoriteByProductId(int productId) async {
    try {
      final favoriteModel = await localDataSource.getFavoriteByProductId(productId);
      return favoriteModel?.toFavoriteItem();
    } catch (e) {
      throw CacheFailure.readError();
    }
  }

  @override
  Future<void> addToFavorites(FavoriteItem favoriteItem) async {
    try {
      final favoriteModel = FavoriteItemModel.fromFavoriteItem(favoriteItem);
      await localDataSource.saveFavorite(favoriteModel);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> removeFromFavorites(String favoriteId) async {
    try {
      await localDataSource.deleteFavorite(favoriteId);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> removeFromFavoritesByProductId(int productId) async {
    try {
      await localDataSource.deleteFavoriteByProductId(productId);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> updateFavorite(FavoriteItem favoriteItem) async {
    try {
      final favoriteModel = FavoriteItemModel.fromFavoriteItem(favoriteItem);
      await localDataSource.saveFavorite(favoriteModel);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<bool> isFavorite(int productId) async {
    try {
      return await localDataSource.isFavorite(productId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      return await localDataSource.getFavoritesCount();
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await localDataSource.clearFavorites();
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> addMultipleToFavorites(List<FavoriteItem> favoriteItems) async {
    try {
      final favoriteModels = favoriteItems
          .map((item) => FavoriteItemModel.fromFavoriteItem(item))
          .toList();
      await localDataSource.saveMultipleFavorites(favoriteModels);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> removeMultipleFromFavorites(List<String> favoriteIds) async {
    try {
      await localDataSource.deleteMultipleFavorites(favoriteIds);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> updateMultipleFavorites(List<FavoriteItem> favoriteItems) async {
    try {
      final favoriteModels = favoriteItems
          .map((item) => FavoriteItemModel.fromFavoriteItem(item))
          .toList();
      await localDataSource.saveMultipleFavorites(favoriteModels);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<List<FavoritesCollection>> getCollections() async {
    try {
      final collectionModels = await localDataSource.getCollections();
      return collectionModels.map((model) => model.toFavoritesCollection()).toList();
    } catch (e) {
      throw CacheFailure.readError();
    }
  }

  @override
  Future<FavoritesCollection?> getCollectionById(String id) async {
    try {
      final collectionModel = await localDataSource.getCollectionById(id);
      return collectionModel?.toFavoritesCollection();
    } catch (e) {
      throw CacheFailure.readError();
    }
  }

  @override
  Future<void> createCollection(FavoritesCollection collection) async {
    try {
      final collectionModel = FavoritesCollectionModel.fromFavoritesCollection(collection);
      await localDataSource.saveCollection(collectionModel);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> updateCollection(FavoritesCollection collection) async {
    try {
      final collectionModel = FavoritesCollectionModel.fromFavoritesCollection(collection);
      await localDataSource.saveCollection(collectionModel);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> deleteCollection(String id) async {
    try {
      await localDataSource.deleteCollection(id);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> addToCollection(String collectionId, List<String> productIds) async {
    try {
      final collection = await localDataSource.getCollectionById(collectionId);
      if (collection == null) {
        throw const ValidationFailure(message: 'Collection not found');
      }

      final updatedProductIds = List<String>.from(collection.productIds);
      for (final productId in productIds) {
        if (!updatedProductIds.contains(productId)) {
          updatedProductIds.add(productId);
        }
      }

      await localDataSource.updateCollectionProductIds(collectionId, updatedProductIds);

      // Also update the favorites to reference this collection
      final favorites = await localDataSource.getFavorites();
      final updatedFavorites = <FavoriteItemModel>[];

      for (final favorite in favorites) {
        if (productIds.contains(favorite.productId.toString())) {
          final updatedFavorite = favorite.copyWith(
            collectionId: collectionId,
            updatedAt: DateTime.now(),
          );
          updatedFavorites.add(updatedFavorite);
        }
      }

      if (updatedFavorites.isNotEmpty) {
        await localDataSource.saveMultipleFavorites(updatedFavorites);
      }
    } catch (e) {
      if (e is ValidationFailure) rethrow;
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> removeFromCollection(String collectionId, List<String> productIds) async {
    try {
      final collection = await localDataSource.getCollectionById(collectionId);
      if (collection == null) return;

      final updatedProductIds = List<String>.from(collection.productIds);
      updatedProductIds.removeWhere((id) => productIds.contains(id));

      await localDataSource.updateCollectionProductIds(collectionId, updatedProductIds);

      // Update favorites to remove collection reference
      final favorites = await localDataSource.getFavorites();
      final updatedFavorites = <FavoriteItemModel>[];

      for (final favorite in favorites) {
        if (productIds.contains(favorite.productId.toString()) &&
            favorite.collectionId == collectionId) {
          final updatedFavorite = favorite.copyWith(
            collectionId: null,
            updatedAt: DateTime.now(),
          );
          updatedFavorites.add(updatedFavorite);
        }
      }

      if (updatedFavorites.isNotEmpty) {
        await localDataSource.saveMultipleFavorites(updatedFavorites);
      }
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<List<FavoritesCollection>> getSmartCollections() async {
    try {
      // Return predefined smart collections
      return [
        FavoritesCollection.createRecentCollection(),
        FavoritesCollection.createSaleCollection(),
        FavoritesCollection.createHighlyRatedCollection(),
        FavoritesCollection.createPriceDropCollection(),
        FavoritesCollection.createCategoryCollection('electronics'),
        FavoritesCollection.createCategoryCollection('jewelery'),
        FavoritesCollection.createCategoryCollection("men's clothing"),
        FavoritesCollection.createCategoryCollection("women's clothing"),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<FavoriteItem>> getSmartCollectionItems(String collectionId) async {
    try {
      final allFavorites = await getFavorites();

      // Get the smart collection
      final smartCollections = await getSmartCollections();
      final smartCollection = smartCollections
          .cast<FavoritesCollection?>()
          .firstWhere(
            (c) => c?.id == collectionId,
        orElse: () => null,
      );

      if (smartCollection == null) return [];

      return smartCollection.filterBySmartRules(allFavorites);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<FavoriteItem>> searchFavorites(String query) async {
    try {
      final favoriteModels = await localDataSource.searchFavorites(query);
      return favoriteModels.map((model) => model.toFavoriteItem()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<FavoriteItem>> filterFavorites({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStockOnly,
    bool? onSaleOnly,
    List<String>? tags,
  }) async {
    try {
      var favorites = await getFavorites();

      if (category != null) {
        favorites = favorites.where((f) => f.category == category).toList();
      }

      if (minPrice != null) {
        favorites = favorites.where((f) => f.price >= minPrice).toList();
      }

      if (maxPrice != null) {
        favorites = favorites.where((f) => f.price <= maxPrice).toList();
      }

      if (minRating != null) {
        favorites = favorites.where((f) => f.rating >= minRating).toList();
      }

      if (inStockOnly == true) {
        favorites = favorites.where((f) => f.inStock).toList();
      }

      if (onSaleOnly == true) {
        favorites = favorites.where((f) => f.isOnSale).toList();
      }

      if (tags != null && tags.isNotEmpty) {
        favorites = favorites.where((f) {
          final itemTags = [...f.tags.values, ...f.getAutoTags()];
          return tags.every((tag) => itemTags.contains(tag));
        }).toList();
      }

      return favorites;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getFavoritesAnalytics() async {
    try {
      return await localDataSource.getFavoritesAnalytics();
    } catch (e) {
      return {
        'total_favorites': 0,
        'total_collections': 0,
        'error': e.toString(),
      };
    }
  }

  @override
  Future<List<String>> getTopCategories() async {
    try {
      final analytics = await getFavoritesAnalytics();
      final categories = analytics['categories'] as Map<String, dynamic>? ?? {};

      final sortedCategories = categories.entries.toList()
        ..sort((a, b) => (b.value as int).compareTo(a.value as int));

      return sortedCategories.map((e) => e.key).take(5).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> getTopBrands() async {
    try {
      final favorites = await getFavorites();
      final brandCount = <String, int>{};

      for (final favorite in favorites) {
        if (favorite.brand != null) {
          brandCount[favorite.brand!] = (brandCount[favorite.brand!] ?? 0) + 1;
        }
      }

      final sortedBrands = brandCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedBrands.map((e) => e.key).take(5).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, int>> getFavoritesByMonth() async {
    try {
      final favorites = await getFavorites();
      final monthCount = <String, int>{};

      for (final favorite in favorites) {
        final monthKey = '${favorite.addedAt.year}-${favorite.addedAt.month.toString().padLeft(2, '0')}';
        monthCount[monthKey] = (monthCount[monthKey] ?? 0) + 1;
      }

      return monthCount;
    } catch (e) {
      return {};
    }
  }

  @override
  Future<void> enablePriceTracking(String favoriteId, double targetPrice) async {
    try {
      final favorite = await getFavoriteById(favoriteId);
      if (favorite == null) {
        throw const ValidationFailure(message: 'Favorite not found');
      }

      final updatedFavorite = favorite.copyWith(
        isPriceTrackingEnabled: true,
        targetPrice: targetPrice,
        updatedAt: DateTime.now(),
      );

      await updateFavorite(updatedFavorite);
    } catch (e) {
      if (e is ValidationFailure) rethrow;
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> disablePriceTracking(String favoriteId) async {
    try {
      final favorite = await getFavoriteById(favoriteId);
      if (favorite == null) return;

      final updatedFavorite = favorite.copyWith(
        isPriceTrackingEnabled: false,
        targetPrice: null,
        updatedAt: DateTime.now(),
      );

      await updateFavorite(updatedFavorite);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<List<FavoriteItem>> getPriceTrackingItems() async {
    try {
      final favorites = await getFavorites();
      return favorites.where((f) => f.isPriceTrackingEnabled).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updatePrices(List<FavoriteItem> updatedItems) async {
    try {
      await updateMultipleFavorites(updatedItems);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    try {
      return await localDataSource.getLastSyncTimestamp();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveLastSyncTimestamp(DateTime timestamp) async {
    try {
      await localDataSource.saveLastSyncTimestamp(timestamp);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<List<FavoriteItem>> getPendingSync() async {
    try {
      // In a real implementation, you would track which items need syncing
      // For now, return items that haven't been synced recently
      final lastSync = await getLastSyncTimestamp();
      if (lastSync == null) {
        return await getFavorites(); // All items need sync
      }

      final favorites = await getFavorites();
      return favorites.where((f) =>
      f.updatedAt?.isAfter(lastSync) ?? f.addedAt.isAfter(lastSync)
      ).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> markAsSynced(List<String> favoriteIds) async {
    try {
      final favorites = await getFavorites();
      final updatedFavorites = <FavoriteItem>[];

      for (final favorite in favorites) {
        if (favoriteIds.contains(favorite.id)) {
          final updatedFavorite = favorite.copyWith(
            updatedAt: DateTime.now(),
          );
          updatedFavorites.add(updatedFavorite);
        }
      }

      if (updatedFavorites.isNotEmpty) {
        await updateMultipleFavorites(updatedFavorites);
      }

      await saveLastSyncTimestamp(DateTime.now());
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<Map<String, dynamic>> exportFavorites() async {
    try {
      return await localDataSource.exportFavorites();
    } catch (e) {
      throw CacheFailure.readError();
    }
  }

  @override
  Future<void> importFavorites(Map<String, dynamic> data) async {
    try {
      await localDataSource.importFavorites(data);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }

  @override
  Future<void> createBackup() async {
    try {
      final favoritesData = await exportFavorites();
      await remoteDataSource.uploadFavoritesBackup(favoritesData);
    } catch (e) {
      throw NetworkFailure.serverError();
    }
  }

  @override
  Future<void> restoreBackup(String backupData) async {
    try {
      final data = Map<String, dynamic>.from(
        // In a real implementation, you would parse the backup data
          {'favorites': [], 'collections': []}
      );
      await importFavorites(data);
    } catch (e) {
      throw CacheFailure.writeError();
    }
  }
}