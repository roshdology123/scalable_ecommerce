import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/favorite_item_model.dart';
import '../models/favorites_collection_model.dart';

abstract class FavoritesLocalDataSource {
  // Favorite Items
  Future<List<FavoriteItemModel>> getFavorites({
    String? collectionId,
    String? category,
    String? sortBy,
    String? sortOrder,
    int? limit,
    int? offset,
  });

  Future<FavoriteItemModel?> getFavoriteById(String id);

  Future<FavoriteItemModel?> getFavoriteByProductId(int productId);

  Future<void> saveFavorite(FavoriteItemModel favoriteItem);

  Future<void> deleteFavorite(String favoriteId);

  Future<void> deleteFavoriteByProductId(int productId);

  Future<bool> isFavorite(int productId);

  Future<int> getFavoritesCount();

  Future<void> clearFavorites();

  // Batch Operations
  Future<void> saveMultipleFavorites(List<FavoriteItemModel> favoriteItems);

  Future<void> deleteMultipleFavorites(List<String> favoriteIds);

  // Collections
  Future<List<FavoritesCollectionModel>> getCollections();

  Future<FavoritesCollectionModel?> getCollectionById(String id);

  Future<void> saveCollection(FavoritesCollectionModel collection);

  Future<void> deleteCollection(String id);

  Future<void> updateCollectionProductIds(String collectionId, List<String> productIds);

  // Analytics & Search
  Future<List<FavoriteItemModel>> searchFavorites(String query);

  Future<Map<String, dynamic>> getFavoritesAnalytics();

  // Sync & Backup
  Future<DateTime?> getLastSyncTimestamp();

  Future<void> saveLastSyncTimestamp(DateTime timestamp);

  Future<Map<String, dynamic>> exportFavorites();

  Future<void> importFavorites(Map<String, dynamic> data);
}

@LazySingleton(as: FavoritesLocalDataSource)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _favoritesKey = 'favorites_roshdology123';
  static const String _collectionsKey = 'favorites_collections_roshdology123';
  static const String _analyticsKey = 'favorites_analytics_roshdology123';
  static const String _lastSyncKey = 'favorites_last_sync_roshdology123';
  static const String _userContext = 'roshdology123';

  final AppLogger _logger = AppLogger();

  @override
  Future<List<FavoriteItemModel>> getFavorites({
    String? collectionId,
    String? category,
    String? sortBy,
    String? sortOrder,
    int? limit,
    int? offset,
  }) async {
    try {
      final favoritesData = LocalStorage.getFromCache(_favoritesKey);
      if (favoritesData == null || favoritesData['items'] == null) {
        return [];
      }

      final itemsJson = favoritesData['items'] as List<dynamic>;
      var favorites = itemsJson
          .map((item) => FavoriteItemModel.fromJson(_ensureStringKeyMap(item)))
          .toList();

      // Apply filters
      if (collectionId != null) {
        favorites = favorites.where((item) => item.collectionId == collectionId).toList();
      }

      if (category != null) {
        favorites = favorites.where((item) => item.category == category).toList();
      }

      // Apply sorting
      _applySorting(favorites, sortBy, sortOrder);

      // Apply pagination
      if (offset != null && offset > 0) {
        favorites = favorites.skip(offset).toList();
      }

      if (limit != null && limit > 0) {
        favorites = favorites.take(limit).toList();
      }

      _logger.logCacheOperation('get_favorites', _favoritesKey, true,
          'Count: ${favorites.length}, Collection: $collectionId');

      return favorites;
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.getFavorites',
        e,
        stackTrace,
        {
          'collection_id': collectionId,
          'category': category,
          'user': _userContext,
        },
      );
      throw CacheException.readError();
    }
  }

  @override
  Future<FavoriteItemModel?> getFavoriteById(String id) async {
    try {
      final favorites = await getFavorites();
      return favorites.cast<FavoriteItemModel?>().firstWhere(
            (item) => item?.id == id,
        orElse: () => null,
      );
    } catch (e) {
      _logger.w('Failed to get favorite by id: $e');
      return null;
    }
  }

  @override
  Future<FavoriteItemModel?> getFavoriteByProductId(int productId) async {
    try {
      final favorites = await getFavorites();
      return favorites.cast<FavoriteItemModel?>().firstWhere(
            (item) => item?.productId == productId,
        orElse: () => null,
      );
    } catch (e) {
      _logger.w('Failed to get favorite by product id: $e');
      return null;
    }
  }

  @override
  Future<void> saveFavorite(FavoriteItemModel favoriteItem) async {
    try {
      final favorites = await getFavorites();

      // Remove existing if updating
      favorites.removeWhere((item) => item.id == favoriteItem.id);

      // Add the new/updated item
      favorites.add(favoriteItem);

      await _saveFavoritesList(favorites);

      _logger.logUserAction('favorite_saved', {
        'product_id': favoriteItem.productId,
        'product_title': favoriteItem.productTitle,
        'collection_id': favoriteItem.collectionId,
        'user': _userContext,
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.saveFavorite',
        e,
        stackTrace,
        {
          'favorite_id': favoriteItem.id,
          'product_id': favoriteItem.productId,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> deleteFavorite(String favoriteId) async {
    try {
      final favorites = await getFavorites();
      final originalCount = favorites.length;

      favorites.removeWhere((item) => item.id == favoriteId);

      if (favorites.length < originalCount) {
        await _saveFavoritesList(favorites);

        _logger.logUserAction('favorite_deleted', {
          'favorite_id': favoriteId,
          'user': _userContext,
        });
      }
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.deleteFavorite',
        e,
        stackTrace,
        {
          'favorite_id': favoriteId,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> deleteFavoriteByProductId(int productId) async {
    try {
      final favorites = await getFavorites();
      final originalCount = favorites.length;

      favorites.removeWhere((item) => item.productId == productId);

      if (favorites.length < originalCount) {
        await _saveFavoritesList(favorites);

        _logger.logUserAction('favorite_deleted_by_product', {
          'product_id': productId,
          'user': _userContext,
        });
      }
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.deleteFavoriteByProductId',
        e,
        stackTrace,
        {
          'product_id': productId,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<bool> isFavorite(int productId) async {
    try {
      final favorite = await getFavoriteByProductId(productId);
      return favorite != null;
    } catch (e) {
      _logger.w('Failed to check if favorite: $e');
      return false;
    }
  }

  @override
  Future<int> getFavoritesCount() async {
    try {
      final favorites = await getFavorites();
      return favorites.length;
    } catch (e) {
      _logger.w('Failed to get favorites count: $e');
      return 0;
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await LocalStorage.removeFromCache(_favoritesKey);

      _logger.logUserAction('favorites_cleared', {
        'user': _userContext,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.clearFavorites',
        e,
        stackTrace,
        {'user': _userContext},
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> saveMultipleFavorites(List<FavoriteItemModel> favoriteItems) async {
    try {
      final existingFavorites = await getFavorites();

      // Remove duplicates and add new items
      for (final newItem in favoriteItems) {
        existingFavorites.removeWhere((item) => item.id == newItem.id);
        existingFavorites.add(newItem);
      }

      await _saveFavoritesList(existingFavorites);

      _logger.logUserAction('multiple_favorites_saved', {
        'count': favoriteItems.length,
        'user': _userContext,
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.saveMultipleFavorites',
        e,
        stackTrace,
        {
          'count': favoriteItems.length,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> deleteMultipleFavorites(List<String> favoriteIds) async {
    try {
      final favorites = await getFavorites();
      final originalCount = favorites.length;

      favorites.removeWhere((item) => favoriteIds.contains(item.id));

      if (favorites.length < originalCount) {
        await _saveFavoritesList(favorites);

        _logger.logUserAction('multiple_favorites_deleted', {
          'count': originalCount - favorites.length,
          'user': _userContext,
        });
      }
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.deleteMultipleFavorites',
        e,
        stackTrace,
        {
          'ids_count': favoriteIds.length,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<FavoritesCollectionModel>> getCollections() async {
    try {
      final collectionsData = LocalStorage.getFromCache(_collectionsKey);
      if (collectionsData == null || collectionsData['collections'] == null) {
        return _getDefaultCollections();
      }

      final collectionsJson = collectionsData['collections'] as List<dynamic>;
      final collections = collectionsJson
          .map((item) => FavoritesCollectionModel.fromJson(_ensureStringKeyMap(item)))
          .toList();

      // Ensure default collection exists
      if (!collections.any((c) => c.isDefault)) {
        collections.insert(0, _createDefaultCollection());
      }

      _logger.logCacheOperation('get_collections', _collectionsKey, true,
          'Count: ${collections.length}');

      return collections;
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.getCollections',
        e,
        stackTrace,
        {'user': _userContext},
      );
      return _getDefaultCollections();
    }
  }

  @override
  Future<FavoritesCollectionModel?> getCollectionById(String id) async {
    try {
      final collections = await getCollections();
      return collections.cast<FavoritesCollectionModel?>().firstWhere(
            (collection) => collection?.id == id,
        orElse: () => null,
      );
    } catch (e) {
      _logger.w('Failed to get collection by id: $e');
      return null;
    }
  }

  @override
  Future<void> saveCollection(FavoritesCollectionModel collection) async {
    try {
      final collections = await getCollections();

      // Remove existing if updating
      collections.removeWhere((item) => item.id == collection.id);

      // Add the new/updated collection
      collections.add(collection);

      await _saveCollectionsList(collections);

      _logger.logUserAction('collection_saved', {
        'collection_id': collection.id,
        'collection_name': collection.name,
        'is_smart': collection.isSmartCollection,
        'user': _userContext,
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.saveCollection',
        e,
        stackTrace,
        {
          'collection_id': collection.id,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> deleteCollection(String id) async {
    try {
      final collections = await getCollections();
      final originalCount = collections.length;

      // Don't allow deleting default collection
      collections.removeWhere((item) => item.id == id && !item.isDefault);

      if (collections.length < originalCount) {
        await _saveCollectionsList(collections);

        // Remove collection reference from favorites
        final favorites = await getFavorites();
        var updatedFavorites = false;

        for (final favorite in favorites) {
          if (favorite.collectionId == id) {
            final updatedFavorite = favorite.copyWith(collectionId: null);
            favorites[favorites.indexOf(favorite)] = updatedFavorite;
            updatedFavorites = true;
          }
        }

        if (updatedFavorites) {
          await _saveFavoritesList(favorites);
        }

        _logger.logUserAction('collection_deleted', {
          'collection_id': id,
          'user': _userContext,
        });
      }
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.deleteCollection',
        e,
        stackTrace,
        {
          'collection_id': id,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> updateCollectionProductIds(String collectionId, List<String> productIds) async {
    try {
      final collection = await getCollectionById(collectionId);
      if (collection == null) return;

      final updatedCollection = collection.copyWith(
        productIds: productIds,
        updatedAt: DateTime.now(),
      );

      await saveCollection(updatedCollection);
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.updateCollectionProductIds',
        e,
        stackTrace,
        {
          'collection_id': collectionId,
          'product_ids_count': productIds.length,
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<FavoriteItemModel>> searchFavorites(String query) async {
    try {
      final favorites = await getFavorites();
      final searchQuery = query.toLowerCase().trim();

      if (searchQuery.isEmpty) return favorites;

      return favorites.where((item) =>
      item.productTitle.toLowerCase().contains(searchQuery) ||
          item.category.toLowerCase().contains(searchQuery) ||
          (item.brand?.toLowerCase().contains(searchQuery) ?? false) ||
          item.tags.values.any((tag) => tag.toLowerCase().contains(searchQuery))
      ).toList();
    } catch (e) {
      _logger.w('Failed to search favorites: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getFavoritesAnalytics() async {
    try {
      final favorites = await getFavorites();
      final collections = await getCollections();

      // Basic analytics
      final analytics = {
        'total_favorites': favorites.length,
        'total_collections': collections.length,
        'last_updated': DateTime.now().toIso8601String(),
        'user': _userContext,
      };

      // Category breakdown
      final categoryCount = <String, int>{};
      for (final item in favorites) {
        categoryCount[item.category] = (categoryCount[item.category] ?? 0) + 1;
      }
      analytics['categories'] = categoryCount;

      // Price analytics
      if (favorites.isNotEmpty) {
        final prices = favorites.map((f) => f.price).toList()..sort();
        analytics['price_stats'] = {
          'min': prices.first,
          'max': prices.last,
          'average': prices.reduce((a, b) => a + b) / prices.length,
          'median': prices[prices.length ~/ 2],
        };
      }

      // Recent additions (last 7 days)
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      final recentCount = favorites.where((f) => f.addedAt.isAfter(weekAgo)).length;
      analytics['recent_additions'] = recentCount;

      // Sale items
      final saleCount = favorites.where((f) => f.originalPrice != null && f.originalPrice! > f.price).length;
      analytics['sale_items'] = saleCount;

      // Price tracking
      final priceTrackingCount = favorites.where((f) => f.isPriceTrackingEnabled).length;
      analytics['price_tracking_enabled'] = priceTrackingCount;

      // Save analytics to cache
      await LocalStorage.saveToCache(
        _analyticsKey,
        analytics,
        expiry: AppConstants.cacheDurationMedium,
      );

      return analytics;
    } catch (e) {
      _logger.w('Failed to get favorites analytics: $e');
      return {
        'total_favorites': 0,
        'total_collections': 0,
        'last_updated': DateTime.now().toIso8601String(),
        'user': _userContext,
        'error': e.toString(),
      };
    }
  }

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    try {
      final data = LocalStorage.getFromCache(_lastSyncKey);
      if (data == null || data['timestamp'] == null) return null;

      return DateTime.parse(data['timestamp']);
    } catch (e) {
      _logger.w('Failed to get last sync timestamp: $e');
      return null;
    }
  }

  @override
  Future<void> saveLastSyncTimestamp(DateTime timestamp) async {
    try {
      await LocalStorage.saveToCache(
        _lastSyncKey,
        {'timestamp': timestamp.toIso8601String()},
        expiry: AppConstants.cacheDurationLong,
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.saveLastSyncTimestamp',
        e,
        stackTrace,
        {
          'timestamp': timestamp.toIso8601String(),
          'user': _userContext,
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<Map<String, dynamic>> exportFavorites() async {
    try {
      final favorites = await getFavorites();
      final collections = await getCollections();
      final analytics = await getFavoritesAnalytics();

      return {
        'version': '1.0',
        'exported_at': DateTime.now().toIso8601String(),
        'user': _userContext,
        'favorites': favorites.map((f) => f.toJson()).toList(),
        'collections': collections.map((c) => c.toJson()).toList(),
        'analytics': analytics,
      };
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.exportFavorites',
        e,
        stackTrace,
        {'user': _userContext},
      );
      throw CacheException.readError();
    }
  }

  @override
  Future<void> importFavorites(Map<String, dynamic> data) async {
    try {
      final safeData = _ensureStringKeyMap(data);

      // Import favorites
      if (safeData['favorites'] != null) {
        final favoritesJson = safeData['favorites'] as List<dynamic>;
        final favorites = favoritesJson
            .map((item) => FavoriteItemModel.fromJson(_ensureStringKeyMap(item)))
            .toList();

        await _saveFavoritesList(favorites);
      }

      // Import collections
      if (safeData['collections'] != null) {
        final collectionsJson = safeData['collections'] as List<dynamic>;
        final collections = collectionsJson
            .map((item) => FavoritesCollectionModel.fromJson(_ensureStringKeyMap(item)))
            .toList();

        await _saveCollectionsList(collections);
      }

      _logger.logUserAction('favorites_imported', {
        'version': safeData['version'],
        'user': _userContext,
        'imported_at': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'FavoritesLocalDataSource.importFavorites',
        e,
        stackTrace,
        {'user': _userContext},
      );
      throw CacheException.writeError();
    }
  }

  // Helper Methods
  Future<void> _saveFavoritesList(List<FavoriteItemModel> favorites) async {
    await LocalStorage.saveToCache(
      _favoritesKey,
      {
        'items': favorites.map((f) => f.toJson()).toList(),
        'count': favorites.length,
        'last_updated': DateTime.now().toIso8601String(),
        'user': _userContext,
      },
      expiry: AppConstants.cacheDurationLong,
    );
  }

  Future<void> _saveCollectionsList(List<FavoritesCollectionModel> collections) async {
    await LocalStorage.saveToCache(
      _collectionsKey,
      {
        'collections': collections.map((c) => c.toJson()).toList(),
        'count': collections.length,
        'last_updated': DateTime.now().toIso8601String(),
        'user': _userContext,
      },
      expiry: AppConstants.cacheDurationLong,
    );
  }

  void _applySorting(List<FavoriteItemModel> favorites, String? sortBy, String? sortOrder) {
    if (sortBy == null) return;

    final ascending = sortOrder?.toLowerCase() != 'desc';

    switch (sortBy.toLowerCase()) {
      case 'name':
      case 'title':
        favorites.sort((a, b) => ascending
            ? a.productTitle.compareTo(b.productTitle)
            : b.productTitle.compareTo(a.productTitle));
        break;
      case 'price':
        favorites.sort((a, b) => ascending
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price));
        break;
      case 'rating':
        favorites.sort((a, b) => ascending
            ? a.rating.compareTo(b.rating)
            : b.rating.compareTo(a.rating));
        break;
      case 'date_added':
      case 'added':
        favorites.sort((a, b) => ascending
            ? a.addedAt.compareTo(b.addedAt)
            : b.addedAt.compareTo(a.addedAt));
        break;
      case 'category':
        favorites.sort((a, b) => ascending
            ? a.category.compareTo(b.category)
            : b.category.compareTo(a.category));
        break;
      case 'brand':
        favorites.sort((a, b) {
          final brandA = a.brand ?? '';
          final brandB = b.brand ?? '';
          return ascending
              ? brandA.compareTo(brandB)
              : brandB.compareTo(brandA);
        });
        break;
    }
  }

  List<FavoritesCollectionModel> _getDefaultCollections() {
    return [_createDefaultCollection()];
  }

  FavoritesCollectionModel _createDefaultCollection() {
    return FavoritesCollectionModel(
      id: 'default',
      name: 'All Favorites',
      description: 'All your favorite items',
      icon: '❤️',
      isDefault: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Map<String, dynamic> _ensureStringKeyMap(dynamic map) {
    if (map == null) return {};
    if (map is Map<String, dynamic>) return map;
    if (map is Map) {
      return Map<String, dynamic>.from(map);
    }
    return {};
  }
}