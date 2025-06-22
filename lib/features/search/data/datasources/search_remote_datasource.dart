import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../products/data/datasources/products_remote_datasource.dart';
import '../../../products/data/models/product_model.dart';
import '../../domain/entities/search_suggestion.dart';
import '../models/search_result_model.dart';
import '../models/search_suggestion_model.dart';

abstract class SearchRemoteDataSource {
  /// Search products using the products remote datasource
  Future<SearchResultModel> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  });

  /// Get search suggestions from products and categories
  Future<List<SearchSuggestionModel>> getSearchSuggestions({
    required String query,
    int limit = 10,
  });

  /// Get popular search terms (mock implementation)
  Future<List<String>> getPopularSearches({int limit = 10});
}

@LazySingleton(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient _dioClient;
  late final ProductsRemoteDataSource _productsRemoteDataSource;

  SearchRemoteDataSourceImpl(this._dioClient) {
    // Create ProductsRemoteDataSource instance with DioClient
    _productsRemoteDataSource = ProductsRemoteDataSourceImpl(_dioClient);
  }

  @override
  Future<SearchResultModel> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    try {
      // Use the existing products search functionality
      final productModels = await _productsRemoteDataSource.searchProducts(
        query: query,
        page: page,
        limit: limit,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
      );

      // Convert ProductModel list to Product list using the extension method
      final products = productModels.map((productModel) => productModel.toProduct()).toList();

      return SearchResultModel.create(
        query: query,
        products: products,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to search products: ${e.toString()}',
        code: 'SEARCH_PRODUCTS_ERROR',
      );
    }
  }

  @override
  Future<List<SearchSuggestionModel>> getSearchSuggestions({
    required String query,
    int limit = 10,
  }) async {
    try {
      final suggestions = <SearchSuggestionModel>[];

      if (query.isEmpty) {
        // Return popular searches for empty query
        final popularSearches = await getPopularSearches(limit: limit);
        suggestions.addAll(
          popularSearches.map(
                (search) => SearchSuggestionModel.create(
              text: search,
              type: SuggestionType.popular,
            ),
          ),
        );
        return suggestions;
      }

      // Get all products to extract suggestions
      final allProductModels = await _productsRemoteDataSource.getProducts(limit: 100);
      final categoryModels = await _productsRemoteDataSource.getCategories();

      // Filter products that match the query
      final matchingProducts = allProductModels.where((productModel) {
        final queryLower = query.toLowerCase();
        return productModel.title.toLowerCase().contains(queryLower) ||
            productModel.description.toLowerCase().contains(queryLower) ||
            productModel.category.toLowerCase().contains(queryLower) ||
            (productModel.brand?.toLowerCase().contains(queryLower) ?? false);
      }).toList();

      // Add product suggestions
      final productSuggestions = matchingProducts
          .take(limit ~/ 2)
          .map((productModel) => SearchSuggestionModel.fromProductTitle(
        productModel.title,
        category: productModel.category,
        imageUrl: productModel.image,
      ))
          .toList();

      suggestions.addAll(productSuggestions);

      // Add category suggestions
      final matchingCategories = categoryModels.where((categoryModel) =>
          categoryModel.name.toLowerCase().contains(query.toLowerCase())).toList();

      final categorySuggestions = matchingCategories
          .take(limit - suggestions.length)
          .map((categoryModel) => SearchSuggestionModel.fromCategory(categoryModel.name))
          .toList();

      suggestions.addAll(categorySuggestions);

      // Add brand suggestions if there's space
      if (suggestions.length < limit) {
        final brands = allProductModels
            .where((productModel) => productModel.brand != null)
            .map((productModel) => productModel.brand!)
            .toSet()
            .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
            .take(limit - suggestions.length);

        final brandSuggestions = brands
            .map((brand) => SearchSuggestionModel.fromBrand(brand))
            .toList();

        suggestions.addAll(brandSuggestions);
      }

      return suggestions.take(limit).toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get search suggestions: ${e.toString()}',
        code: 'GET_SEARCH_SUGGESTIONS_ERROR',
      );
    }
  }

  @override
  Future<List<String>> getPopularSearches({int limit = 10}) async {
    try {
      // Mock popular searches based on common e-commerce search terms
      // In a real app, this would come from analytics/backend
      final popularSearches = [
        'iPhone',
        'laptop',
        'headphones',
        'watch',
        'shoes',
        'bag',
        'dress',
        'jeans',
        'tablet',
        'camera',
        'book',
        'bluetooth',
        'wireless',
        'gaming',
        'fitness',
        'jacket',
        'sneakers',
        'earbuds',
        'backpack',
        'monitor',
        'keyboard',
        'mouse',
        'charger',
        'phone case',
        'sunglasses',
      ];

      return popularSearches.take(limit).toList();
    } catch (e) {
      throw NetworkException(
        message: 'Failed to get popular searches: ${e.toString()}',
        code: 'GET_POPULAR_SEARCHES_ERROR',
      );
    }
  }
}