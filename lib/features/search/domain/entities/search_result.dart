import 'package:equatable/equatable.dart';

import '../../../products/domain/entities/product.dart';

class SearchResult extends Equatable {
  final String query;
  final List<Product> products;
  final List<String> categories;
  final int totalResults;
  final DateTime timestamp;
  final Map<String, int> categoryCount;
  final double? averagePrice;
  final double? averageRating;

  const SearchResult({
    required this.query,
    required this.products,
    required this.categories,
    required this.totalResults,
    required this.timestamp,
    this.categoryCount = const {},
    this.averagePrice,
    this.averageRating,
  });

  @override
  List<Object?> get props => [
    query,
    products,
    categories,
    totalResults,
    timestamp,
    categoryCount,
    averagePrice,
    averageRating,
  ];

  SearchResult copyWith({
    String? query,
    List<Product>? products,
    List<String>? categories,
    int? totalResults,
    DateTime? timestamp,
    Map<String, int>? categoryCount,
    double? averagePrice,
    double? averageRating,
  }) {
    return SearchResult(
      query: query ?? this.query,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      totalResults: totalResults ?? this.totalResults,
      timestamp: timestamp ?? this.timestamp,
      categoryCount: categoryCount ?? this.categoryCount,
      averagePrice: averagePrice ?? this.averagePrice,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  bool get isEmpty => products.isEmpty;
  bool get isNotEmpty => products.isNotEmpty;

  @override
  String toString() {
    return 'SearchResult(query: $query, totalResults: $totalResults, timestamp: $timestamp)';
  }
}