import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/search_result.dart';

part 'search_result_model.freezed.dart';

@freezed
class SearchResultModel with _$SearchResultModel {
  const factory SearchResultModel({
    required String query,
    required List<ProductModel> products,
    required List<String> categories,
    required int totalResults,
    required DateTime timestamp,
    @Default({}) Map<String, int> categoryCount,
    double? averagePrice,
    double? averageRating,
  }) = _SearchResultModel;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    final productsList = json['products'] as List<dynamic>? ?? [];
    final products = productsList
        .map((product) => ProductModel.fromJson(product as Map<String, dynamic>))
        .toList();

    final categoriesList = json['categories'] as List<dynamic>? ?? [];
    final categories = categoriesList.map((e) => e.toString()).toList();

    final categoryCountMap = json['categoryCount'] as Map<String, dynamic>? ?? {};
    final categoryCount = categoryCountMap.map(
          (key, value) => MapEntry(key, value as int),
    );

    return SearchResultModel(
      query: json['query']?.toString() ?? '',
      products: products,
      categories: categories,
      totalResults: json['totalResults'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      categoryCount: categoryCount,
      averagePrice: (json['averagePrice'] as num?)?.toDouble(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
    );
  }

  factory SearchResultModel.fromSearchResult(SearchResult searchResult) {
    return SearchResultModel(
      query: searchResult.query,
      products: searchResult.products
          .map((product) => ProductModel.fromProduct(product))
          .toList(),
      categories: searchResult.categories,
      totalResults: searchResult.totalResults,
      timestamp: searchResult.timestamp,
      categoryCount: searchResult.categoryCount,
      averagePrice: searchResult.averagePrice,
      averageRating: searchResult.averageRating,
    );
  }

  factory SearchResultModel.create({
    required String query,
    required List<Product> products,
  }) {
    final productModels = products
        .map((product) => ProductModel.fromProduct(product))
        .toList();

    final categories = products
        .map((product) => product.category)
        .toSet()
        .toList();

    final categoryCount = <String, int>{};
    for (final product in products) {
      categoryCount[product.category] =
          (categoryCount[product.category] ?? 0) + 1;
    }

    final totalPrice = products.fold<double>(
      0.0,
          (sum, product) => sum + product.price,
    );
    final averagePrice = products.isNotEmpty ? totalPrice / products.length : null;

    final totalRating = products.fold<double>(
      0.0,
          (sum, product) => sum + product.rating.rate,
    );
    final averageRating = products.isNotEmpty ? totalRating / products.length : null;

    return SearchResultModel(
      query: query,
      products: productModels,
      categories: categories,
      totalResults: products.length,
      timestamp: DateTime.now(),
      categoryCount: categoryCount,
      averagePrice: averagePrice,
      averageRating: averageRating,
    );
  }
}

extension SearchResultModelExtension on SearchResultModel {
  SearchResult toSearchResult() {
    return SearchResult(
      query: query,
      products: products.map((product) => product.toProduct()).toList(),
      categories: categories,
      totalResults: totalResults,
      timestamp: timestamp,
      categoryCount: categoryCount,
      averagePrice: averagePrice,
      averageRating: averageRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'products': products.map((product) => product.toJson()).toList(),
      'categories': categories,
      'totalResults': totalResults,
      'timestamp': timestamp.toIso8601String(),
      'categoryCount': categoryCount,
      'averagePrice': averagePrice,
      'averageRating': averageRating,
    };
  }
}