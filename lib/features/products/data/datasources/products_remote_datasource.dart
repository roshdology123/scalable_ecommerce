import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  /// Get paginated products
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
    String? sortOrder,
  });

  /// Get product by ID
  Future<ProductModel> getProductById(int id);

  /// Get all categories
  Future<List<CategoryModel>> getCategories();

  /// Get products by category
  Future<List<ProductModel>> getProductsByCategory({
    required String category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  });

  /// Search products
  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  });

  /// Get featured products
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10});

  /// Get new arrivals
  Future<List<ProductModel>> getNewArrivals({int limit = 10});

  /// Get products on sale
  Future<List<ProductModel>> getProductsOnSale({int limit = 10});

  /// Get related products
  Future<List<ProductModel>> getRelatedProducts({
    required int productId,
    int limit = 5,
  });
}

@LazySingleton(as: ProductsRemoteDataSource)
class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final DioClient _dioClient;

  ProductsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      String endpoint = ApiConstants.products;

      // Build query parameters
      final queryParams = <String, dynamic>{};

      // Handle pagination (Fake Store API uses limit and skip)
      if (limit > 0) {
        queryParams['limit'] = limit;
        if (page > 1) {
          queryParams['skip'] = (page - 1) * limit;
        }
      }

      // Handle sorting
      if (sortBy != null || sortOrder != null) {
        queryParams['sort'] = sortOrder?.toLowerCase() ?? 'asc';
      }

      // Handle category filter
      if (category != null && category.isNotEmpty) {
        endpoint = ApiConstants.productsByCategory(category);
      }

      final response = await _dioClient.get(
        endpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get products: ${e.toString()}',
        code: 'GET_PRODUCTS_ERROR',
      );
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.productById(id),
      );

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get product: ${e.toString()}',
        code: 'GET_PRODUCT_ERROR',
      );
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle the FakeStore API response which returns simple string array
        if (data is List) {
          return (data).asMap().entries.map((entry) {
            final index = entry.key;
            final categoryName = entry.value.toString();

            return CategoryModel.fromString(categoryName, index: index);
          }).toList();
        }

        // Fallback for other API formats that return objects
        if (data is Map && data['categories'] is List) {
          final List<dynamic> categoriesData = data['categories'];
          return categoriesData
              .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw const ApiException(
          message: 'Unexpected categories response format',
          code: 'CATEGORIES_FORMAT_ERROR',
        );
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get categories: ${e.toString()}',
        code: 'GET_CATEGORIES_ERROR',
      );
    }
  }

// Helper methods for the ProductsRemoteDataSource class
  String _formatCategoryName(String name) {
    if (name.isEmpty) return name;
    return name.split(' ').map((word) =>
    word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : word
    ).join(' ');
  }

  String _getCategoryImage(String categoryName) {
    final category = categoryName.toLowerCase();
    switch (category) {
      case 'electronics':
        return 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400';
      case 'jewelery':
      case 'jewelry':
        return 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400';
      case "men's clothing":
      case 'mens clothing':
        return 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400';
      case "women's clothing":
      case 'womens clothing':
        return 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400';
      default:
        return 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400';
    }
  }

  String _getCategoryIcon(String categoryName) {
    final category = categoryName.toLowerCase();
    switch (category) {
      case 'electronics':
        return 'electronics';
      case 'jewelery':
      case 'jewelry':
        return 'diamond';
      case "men's clothing":
      case 'mens clothing':
        return 'man';
      case "women's clothing":
      case 'womens clothing':
        return 'woman';
      default:
        return 'category';
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String category,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (limit > 0) {
        queryParams['limit'] = limit;
        if (page > 1) {
          queryParams['skip'] = (page - 1) * limit;
        }
      }

      if (sortBy != null || sortOrder != null) {
        queryParams['sort'] = sortOrder?.toLowerCase() ?? 'asc';
      }

      final response = await _dioClient.get(
        ApiConstants.productsByCategory(category),
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get products by category: ${e.toString()}',
        code: 'GET_PRODUCTS_BY_CATEGORY_ERROR',
      );
    }
  }

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      // Fake Store API doesn't have search, so we'll get all products and filter
      final allProducts = await getProducts(limit: 100); // Get more products for filtering

      final filteredProducts = allProducts.where((product) {
        // Text search in title and description
        final matchesQuery = query.isEmpty ||
            product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());

        // Category filter
        final matchesCategory = category == null ||
            category.isEmpty ||
            product.category.toLowerCase() == category.toLowerCase();

        // Price filter
        final matchesMinPrice = minPrice == null || product.price >= minPrice;
        final matchesMaxPrice = maxPrice == null || product.price <= maxPrice;

        // Rating filter
        final matchesMinRating = minRating == null || product.rating.rate >= minRating;

        return matchesQuery &&
            matchesCategory &&
            matchesMinPrice &&
            matchesMaxPrice &&
            matchesMinRating;
      }).toList();

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = (startIndex + limit).clamp(0, filteredProducts.length);

      if (startIndex >= filteredProducts.length) {
        return [];
      }

      return filteredProducts.sublist(startIndex, endIndex);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to search products: ${e.toString()}',
        code: 'SEARCH_PRODUCTS_ERROR',
      );
    }
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    try {
      final products = await getProducts(limit: 20);

      // Filter featured products (products with ID divisible by 7)
      final featuredProducts = products
          .where((product) => product.isFeatured)
          .take(limit)
          .toList();

      return featuredProducts;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get featured products: ${e.toString()}',
        code: 'GET_FEATURED_PRODUCTS_ERROR',
      );
    }
  }

  @override
  Future<List<ProductModel>> getNewArrivals({int limit = 10}) async {
    try {
      final products = await getProducts(limit: 20);

      // Filter new products (products with ID > 15)
      final newProducts = products
          .where((product) => product.isNew)
          .take(limit)
          .toList();

      return newProducts;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get new arrivals: ${e.toString()}',
        code: 'GET_NEW_ARRIVALS_ERROR',
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductsOnSale({int limit = 10}) async {
    try {
      final products = await getProducts(limit: 20);

      // Filter products on sale
      final saleProducts = products
          .where((product) => product.isOnSale)
          .take(limit)
          .toList();

      return saleProducts;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get products on sale: ${e.toString()}',
        code: 'GET_SALE_PRODUCTS_ERROR',
      );
    }
  }

  @override
  Future<List<ProductModel>> getRelatedProducts({
    required int productId,
    int limit = 5,
  }) async {
    try {
      // Get the main product to find its category
      final mainProduct = await getProductById(productId);

      // Get products from the same category
      final categoryProducts = await getProductsByCategory(
        category: mainProduct.category,
        limit: limit + 5, // Get extra in case some are filtered out
      );

      // Filter out the main product and limit results
      final relatedProducts = categoryProducts
          .where((product) => product.id != productId)
          .take(limit)
          .toList();

      return relatedProducts;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get related products: ${e.toString()}',
        code: 'GET_RELATED_PRODUCTS_ERROR',
      );
    }
  }
}