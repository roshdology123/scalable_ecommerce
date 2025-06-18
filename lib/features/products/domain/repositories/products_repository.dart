import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../entities/product.dart';

abstract class ProductsRepository {
  /// Get paginated products with optional filtering and sorting
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
    String? sortOrder,
  });

  /// Get a single product by ID
  Future<Either<Failure, Product>> getProductById(int id);

  /// Get all available categories
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get products filtered by category
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  });

  /// Search products with various filters
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  });

  /// Get featured products
  Future<Either<Failure, List<Product>>> getFeaturedProducts({
    int limit = 10,
  });

  /// Get new arrival products
  Future<Either<Failure, List<Product>>> getNewArrivals({
    int limit = 10,
  });

  /// Get products currently on sale
  Future<Either<Failure, List<Product>>> getProductsOnSale({
    int limit = 10,
  });

  /// Get products related to a specific product
  Future<Either<Failure, List<Product>>> getRelatedProducts({
    required int productId,
    int limit = 5,
  });

  /// Get recently viewed products (from local storage)
  Future<Either<Failure, List<Product>>> getRecentlyViewed();

  /// Clear recently viewed products
  Future<Either<Failure, void>> clearRecentlyViewed();

  /// Add product to favorites
  Future<Either<Failure, void>> addToFavorites(int productId);

  /// Remove product from favorites
  Future<Either<Failure, void>> removeFromFavorites(int productId);

  /// Check if product is in favorites
  Future<Either<Failure, bool>> isFavorite(int productId);

  /// Get favorite product IDs
  Future<Either<Failure, List<int>>> getFavoriteProductIds();
}