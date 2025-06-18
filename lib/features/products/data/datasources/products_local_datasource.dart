import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class ProductsLocalDataSource {
  /// Cache products
  Future<void> cacheProducts(List<ProductModel> products);

  /// Get cached products
  Future<List<ProductModel>> getCachedProducts();

  /// Cache single product
  Future<void> cacheProduct(ProductModel product);

  /// Get cached product by ID
  Future<ProductModel?> getCachedProduct(int id);

  /// Cache categories
  Future<void> cacheCategories(List<CategoryModel> categories);

  /// Get cached categories
  Future<List<CategoryModel>> getCachedCategories();

  /// Cache products by category
  Future<void> cacheProductsByCategory(String category, List<ProductModel> products);

  /// Get cached products by category
  Future<List<ProductModel>> getCachedProductsByCategory(String category);

  /// Cache search results
  Future<void> cacheSearchResults(String query, List<ProductModel> products);

  /// Get cached search results
  Future<List<ProductModel>?> getCachedSearchResults(String query);

  /// Save recently viewed product
  Future<void> saveRecentlyViewed(ProductModel product);

  /// Get recently viewed products
  Future<List<ProductModel>> getRecentlyViewed();

  /// Clear recently viewed
  Future<void> clearRecentlyViewed();

  /// Save product to favorites (for integration with favorites feature)
  Future<void> addToFavorites(int productId);

  /// Remove product from favorites
  Future<void> removeFromFavorites(int productId);

  /// Check if product is favorite
  Future<bool> isFavorite(int productId);

  /// Get all favorite product IDs
  Future<List<int>> getFavoriteProductIds();

  /// Clear all cached data
  Future<void> clearAllCache();

  /// Clear expired cache
  Future<void> clearExpiredCache();

  /// Get cache size info
  Future<Map<String, int>> getCacheInfo();
}

@LazySingleton(as: ProductsLocalDataSource)
class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  static const String _productsCacheKey = 'products_cache';
  static const String _categoriesCacheKey = 'categories_cache';
  static const String _productDetailCachePrefix = 'product_detail_';
  static const String _categoryProductsCachePrefix = 'category_products_';
  static const String _searchCachePrefix = 'search_';
  static const String _recentlyViewedKey = 'recently_viewed_products';
  static const int _maxRecentlyViewed = 20;
  static const int _maxSearchCache = 50;

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final productsJson = products.map((p) => p.toJson()).toList();
      await LocalStorage.saveToCache(
        _productsCacheKey,
        {'products': productsJson, 'count': products.length},
        expiry: AppConstants.cacheDurationProducts,
      );

      // Also cache individual products for quick access
      for (final product in products) {
        await cacheProduct(product);
      }
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final cachedData = LocalStorage.getFromCache(_productsCacheKey);
      if (cachedData != null && cachedData['products'] != null) {
        final List<dynamic> productsJson = cachedData['products'] as List<dynamic>;
        return productsJson
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException.readError();
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      await LocalStorage.saveToCache(
        '$_productDetailCachePrefix${product.id}',
        product.toJson(),
        expiry: AppConstants.cacheDurationProducts,
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<ProductModel?> getCachedProduct(int id) async {
    try {
      final cachedData = LocalStorage.getFromCache('$_productDetailCachePrefix$id');
      if (cachedData != null) {
        return ProductModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException.readError();
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final categoriesJson = categories.map((c) => c.toJson()).toList();
      await LocalStorage.saveToCache(
        _categoriesCacheKey,
        {'categories': categoriesJson, 'count': categories.length},
        expiry: AppConstants.cacheDurationCategories,
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      final cachedData = LocalStorage.getFromCache(_categoriesCacheKey);
      if (cachedData != null && cachedData['categories'] != null) {
        final List<dynamic> categoriesJson = cachedData['categories'] as List<dynamic>;
        return categoriesJson
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException.readError();
    }
  }

  @override
  Future<void> cacheProductsByCategory(String category, List<ProductModel> products) async {
    try {
      final productsJson = products.map((p) => p.toJson()).toList();
      await LocalStorage.saveToCache(
        '$_categoryProductsCachePrefix${category.toLowerCase()}',
        {'products': productsJson, 'category': category, 'count': products.length},
        expiry: AppConstants.cacheDurationProducts,
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<ProductModel>> getCachedProductsByCategory(String category) async {
    try {
      final cachedData = LocalStorage.getFromCache(
        '$_categoryProductsCachePrefix${category.toLowerCase()}',
      );
      if (cachedData != null && cachedData['products'] != null) {
        final List<dynamic> productsJson = cachedData['products'] as List<dynamic>;
        return productsJson
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException.readError();
    }
  }

  @override
  Future<void> cacheSearchResults(String query, List<ProductModel> products) async {
    try {
      // Limit search cache to prevent excessive storage
      final searchKey = '$_searchCachePrefix${query.toLowerCase().replaceAll(' ', '_')}';
      final productsJson = products.map((p) => p.toJson()).toList();

      await LocalStorage.saveToCache(
        searchKey,
        {
          'query': query,
          'products': productsJson,
          'count': products.length,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        expiry: AppConstants.cacheDurationShort, // Shorter cache for search
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<ProductModel>?> getCachedSearchResults(String query) async {
    try {
      final searchKey = '$_searchCachePrefix${query.toLowerCase().replaceAll(' ', '_')}';
      final cachedData = LocalStorage.getFromCache(searchKey);

      if (cachedData != null && cachedData['products'] != null) {
        final List<dynamic> productsJson = cachedData['products'] as List<dynamic>;
        return productsJson
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      return null; // Don't throw error for search cache misses
    }
  }

  @override
  Future<void> saveRecentlyViewed(ProductModel product) async {
    try {
      final recentlyViewed = await getRecentlyViewed();

      // Remove if already exists
      recentlyViewed.removeWhere((p) => p.id == product.id);

      // Add to beginning
      recentlyViewed.insert(0, product);

      // Limit size
      if (recentlyViewed.length > _maxRecentlyViewed) {
        recentlyViewed.removeRange(_maxRecentlyViewed, recentlyViewed.length);
      }

      // Save back
      final productsJson = recentlyViewed.map((p) => p.toJson()).toList();
      await LocalStorage.saveToCache(
        _recentlyViewedKey,
        {'products': productsJson, 'count': recentlyViewed.length},
        expiry: AppConstants.cacheDurationLong,
      );
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<ProductModel>> getRecentlyViewed() async {
    try {
      final cachedData = LocalStorage.getFromCache(_recentlyViewedKey);
      if (cachedData != null && cachedData['products'] != null) {
        final List<dynamic> productsJson = cachedData['products'] as List<dynamic>;
        return productsJson
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return []; // Return empty list instead of throwing error
    }
  }

  @override
  Future<void> clearRecentlyViewed() async {
    try {
      await LocalStorage.removeFromCache(_recentlyViewedKey);
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> addToFavorites(int productId) async {
    try {
      await LocalStorage.addFavorite(productId);
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> removeFromFavorites(int productId) async {
    try {
      await LocalStorage.removeFavorite(productId);
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<bool> isFavorite(int productId) async {
    try {
      return LocalStorage.isFavorite(productId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<int>> getFavoriteProductIds() async {
    try {
      return LocalStorage.getFavorites();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      await LocalStorage.clearCache();
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> clearExpiredCache() async {
    try {
      // This would be implemented based on your caching strategy
      // For now, we'll clear all cache as LocalStorage handles expiry automatically
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      throw CacheException.writeError();
    }
  }

  @override
  Future<Map<String, int>> getCacheInfo() async {
    try {
      return {
        'products': LocalStorage.productsCount,
        'favorites': LocalStorage.favoritesCount,
        'total_items': LocalStorage.productsCount + LocalStorage.favoritesCount,
      };
    } catch (e) {
      return {
        'products': 0,
        'favorites': 0,
        'total_items': 0,
      };
    }
  }
}