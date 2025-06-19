import '../entities/favorite_item.dart';
import '../entities/favorites_collection.dart';

abstract class FavoritesRepository {
  // Favorite Items
  Future<List<FavoriteItem>> getFavorites({
    String? collectionId,
    String? category,
    String? sortBy,
    String? sortOrder,
    int? limit,
    int? offset,
  });

  Future<FavoriteItem?> getFavoriteById(String id);

  Future<FavoriteItem?> getFavoriteByProductId(int productId);

  Future<void> addToFavorites(FavoriteItem favoriteItem);

  Future<void> removeFromFavorites(String favoriteId);

  Future<void> removeFromFavoritesByProductId(int productId);

  Future<void> updateFavorite(FavoriteItem favoriteItem);

  Future<bool> isFavorite(int productId);

  Future<int> getFavoritesCount();

  Future<void> clearFavorites();

  // Batch Operations
  Future<void> addMultipleToFavorites(List<FavoriteItem> favoriteItems);

  Future<void> removeMultipleFromFavorites(List<String> favoriteIds);

  Future<void> updateMultipleFavorites(List<FavoriteItem> favoriteItems);

  // Collections
  Future<List<FavoritesCollection>> getCollections();

  Future<FavoritesCollection?> getCollectionById(String id);

  Future<void> createCollection(FavoritesCollection collection);

  Future<void> updateCollection(FavoritesCollection collection);

  Future<void> deleteCollection(String id);

  Future<void> addToCollection(String collectionId, List<String> productIds);

  Future<void> removeFromCollection(String collectionId, List<String> productIds);

  // Smart Collections
  Future<List<FavoritesCollection>> getSmartCollections();

  Future<List<FavoriteItem>> getSmartCollectionItems(String collectionId);

  // Search and Filter
  Future<List<FavoriteItem>> searchFavorites(String query);

  Future<List<FavoriteItem>> filterFavorites({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStockOnly,
    bool? onSaleOnly,
    List<String>? tags,
  });

  // Analytics
  Future<Map<String, dynamic>> getFavoritesAnalytics();

  Future<List<String>> getTopCategories();

  Future<List<String>> getTopBrands();

  Future<Map<String, int>> getFavoritesByMonth();

  // Price Tracking
  Future<void> enablePriceTracking(String favoriteId, double targetPrice);

  Future<void> disablePriceTracking(String favoriteId);

  Future<List<FavoriteItem>> getPriceTrackingItems();

  Future<void> updatePrices(List<FavoriteItem> updatedItems);

  // Sync
  Future<DateTime?> getLastSyncTimestamp();

  Future<void> saveLastSyncTimestamp(DateTime timestamp);

  Future<List<FavoriteItem>> getPendingSync();

  Future<void> markAsSynced(List<String> favoriteIds);

  // Export/Import
  Future<Map<String, dynamic>> exportFavorites();

  Future<void> importFavorites(Map<String, dynamic> data);

  // Backup
  Future<void> createBackup();

  Future<void> restoreBackup(String backupData);
}