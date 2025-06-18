import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_local_datasource.dart';
import '../datasources/products_remote_datasource.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

@LazySingleton(as: ProductsRepository)
class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;
  final ProductsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ProductsRepositoryImpl(
      this._remoteDataSource,
      this._localDataSource,
      this._networkInfo,
      );

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getProducts(
          page: page,
          limit: limit,
          category: category,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );

        // Cache the results
        if (page == 1) {
          // Only cache first page to avoid cache conflicts
          if (category != null) {
            await _localDataSource.cacheProductsByCategory(category, products);
          } else {
            await _localDataSource.cacheProducts(products);
          }
        }

        return Right(
          products.map(
            (product) => product.toProduct(),
          ).toList(
          ),
        );
      } else {
        // Try to get from cache
        List<ProductModel> cachedProducts;
        if (category != null) {
          cachedProducts = await _localDataSource.getCachedProductsByCategory(category);
        } else {
          cachedProducts = await _localDataSource.getCachedProducts();
        }

        if (cachedProducts.isNotEmpty) {
          // Apply pagination to cached results
          final startIndex = (page - 1) * limit;
          final endIndex = (startIndex + limit).clamp(0, cachedProducts.length);

          if (startIndex < cachedProducts.length) {
            final paginatedProducts = cachedProducts.sublist(startIndex, endIndex);
            return Right(
              paginatedProducts.map(
                (product) => product.toProduct(),
              ).toList(),
            );
          }
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get products: ${e.toString()}',
        code: 'GET_PRODUCTS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      if (await _networkInfo.isConnected) {
        final product = await _remoteDataSource.getProductById(id);

        // Cache the product
        await _localDataSource.cacheProduct(product);

        // Save to recently viewed
        await _localDataSource.saveRecentlyViewed(product);

        return Right(
          product.toProduct(),
        );
      } else {
        // Try to get from cache
        final cachedProduct = await _localDataSource.getCachedProduct(id);
        if (cachedProduct != null) {
          return Right(
            cachedProduct.toProduct(),
          );
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return Left(NetworkFailure.notFound());
      }
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get product: ${e.toString()}',
        code: 'GET_PRODUCT_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      if (await _networkInfo.isConnected) {
        final categories = await _remoteDataSource.getCategories();

        // Cache the categories
        await _localDataSource.cacheCategories(categories);

        return Right(
          categories.map(
            (category) => category.toCategory(),
          ).toList(),
        );
      } else {
        // Try to get from cache
        final cachedCategories = await _localDataSource.getCachedCategories();
        if (cachedCategories.isNotEmpty) {
          return Right(
            cachedCategories.map(
              (category) => category.toCategory(),
            ).toList(),
          );
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get categories: ${e.toString()}',
        code: 'GET_CATEGORIES_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getProductsByCategory(
          category: category,
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );

        // Cache the results (only first page)
        if (page == 1) {
          await _localDataSource.cacheProductsByCategory(category, products);
        }

        return Right(
          products.map(
            (product) => product.toProduct(),
          ).toList(),
        );
      } else {
        // Try to get from cache
        final cachedProducts = await _localDataSource.getCachedProductsByCategory(category);
        if (cachedProducts.isNotEmpty) {
          // Apply pagination
          final startIndex = (page - 1) * limit;
          final endIndex = (startIndex + limit).clamp(0, cachedProducts.length);

          if (startIndex < cachedProducts.length) {
            final paginatedProducts = cachedProducts.sublist(startIndex, endIndex);
            return Right(
              paginatedProducts.map(
                (product) => product.toProduct(),
              ).toList(),
            );
          }
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get products by category: ${e.toString()}',
        code: 'GET_PRODUCTS_BY_CATEGORY_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.searchProducts(
          query: query,
          page: page,
          limit: limit,
          category: category,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
        );

        // Cache search results (only first page)
        if (page == 1 && query.isNotEmpty) {
          await _localDataSource.cacheSearchResults(query, products);
        }

        return Right(
          products.map(
            (product) => product.toProduct(),
          ).toList(),
        );
      } else {
        // Try to get from cache
        if (query.isNotEmpty) {
          final cachedResults = await _localDataSource.getCachedSearchResults(query);
          if (cachedResults != null) {
            // Apply pagination
            final startIndex = (page - 1) * limit;
            final endIndex = (startIndex + limit).clamp(0, cachedResults.length);

            if (startIndex < cachedResults.length) {
              final paginatedResults = cachedResults.sublist(startIndex, endIndex);
              return Right(
                paginatedResults.map(
                  (product) => product.toProduct(),
                ).toList(),
              );
            }
          }
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to search products: ${e.toString()}',
        code: 'SEARCH_PRODUCTS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getFeaturedProducts({int limit = 10}) async {
    try {
      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getFeaturedProducts(limit: limit);
        return Right(
          products.map(
            (product) => product.toProduct(),
          ).toList(),
        );
      } else {
        // Get from cached products and filter featured
        final cachedProducts = await _localDataSource.getCachedProducts();
        final featuredProducts = cachedProducts
            .where((product) => product.isFeatured)
            .take(limit)
            .toList();

        if (featuredProducts.isNotEmpty) {
          return Right(
            featuredProducts.map(
              (product) => product.toProduct(),
            ).toList(),
          );
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get featured products: ${e.toString()}',
        code: 'GET_FEATURED_PRODUCTS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getNewArrivals({int limit = 10}) async {
    try {
      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getNewArrivals(limit: limit);
        return Right(
          products.map(
            (product) => product.toProduct(),
          ).toList(),
        );
      } else {
        // Get from cached products and filter new
        final cachedProducts = await _localDataSource.getCachedProducts();
        final newProducts = cachedProducts
            .where((product) => product.isNew)
            .take(limit)
            .toList();

        if (newProducts.isNotEmpty) {
          return Right(
            newProducts.map(
              (product) => product.toProduct(),
            ).toList(),
          );
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get new arrivals: ${e.toString()}',
        code: 'GET_NEW_ARRIVALS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsOnSale({int limit = 10}) async {
    try {
      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getProductsOnSale(limit: limit);
        return Right(
          products.map(
            (product) => product.toProduct(),
          ).toList(),
        );
      } else {
        // Get from cached products and filter on sale
        final cachedProducts = await _localDataSource.getCachedProducts();
        final saleProducts = cachedProducts
            .where((product) => product.isOnSale)
            .take(limit)
            .toList();

        if (saleProducts.isNotEmpty) {
          return Right(
            saleProducts.map(
              (product) => product.toProduct(),
            ).toList(),
          );
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get products on sale: ${e.toString()}',
        code: 'GET_SALE_PRODUCTS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getRelatedProducts({
    required int productId,
    int limit = 5,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final products = await _remoteDataSource.getRelatedProducts(
          productId: productId,
          limit: limit,
        );
        return Right(
          products.map(
            (product) => product.toProduct(),
          ).toList(),
        );
      } else {
        // Try to get related products from cache
        final cachedProduct = await _localDataSource.getCachedProduct(productId);
        if (cachedProduct != null) {
          final categoryProducts = await _localDataSource.getCachedProductsByCategory(
            cachedProduct.category,
          );

          final relatedProducts = categoryProducts
              .where((product) => product.id != productId)
              .take(limit)
              .toList();

          return Right(
            relatedProducts.map(
              (product) => product.toProduct(),
            ).toList(),
          );
        }

        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Failed to get related products: ${e.toString()}',
        code: 'GET_RELATED_PRODUCTS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getRecentlyViewed() async {
    try {
      final recentlyViewed = await _localDataSource.getRecentlyViewed();
      return Right(
        recentlyViewed.map(
          (product) => product.toProduct(),
        ).toList(),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get recently viewed products: ${e.toString()}',
        code: 'GET_RECENTLY_VIEWED_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentlyViewed() async {
    try {
      await _localDataSource.clearRecentlyViewed();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to clear recently viewed: ${e.toString()}',
        code: 'CLEAR_RECENTLY_VIEWED_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(int productId) async {
    try {
      await _localDataSource.addToFavorites(productId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to add to favorites: ${e.toString()}',
        code: 'ADD_TO_FAVORITES_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(int productId) async {
    try {
      await _localDataSource.removeFromFavorites(productId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to remove from favorites: ${e.toString()}',
        code: 'REMOVE_FROM_FAVORITES_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int productId) async {
    try {
      final isFav = await _localDataSource.isFavorite(productId);
      return Right(isFav);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return const Right(false); // Default to false if error
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteProductIds() async {
    try {
      final favoriteIds = await _localDataSource.getFavoriteProductIds();
      return Right(favoriteIds);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return const Right([]); // Default to empty list if error
    }
  }
}