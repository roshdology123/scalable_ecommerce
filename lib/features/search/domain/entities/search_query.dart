import 'package:equatable/equatable.dart';

class SearchQuery extends Equatable {
  final String id;
  final String query;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final DateTime timestamp;
  final int resultCount;

  const SearchQuery({
    required this.id,
    required this.query,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    required this.timestamp,
    required this.resultCount,
  });

  @override
  List<Object?> get props => [
    id,
    query,
    category,
    minPrice,
    maxPrice,
    minRating,
    timestamp,
    resultCount,
  ];

  SearchQuery copyWith({
    String? id,
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    DateTime? timestamp,
    int? resultCount,
  }) {
    return SearchQuery(
      id: id ?? this.id,
      query: query ?? this.query,
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      timestamp: timestamp ?? this.timestamp,
      resultCount: resultCount ?? this.resultCount,
    );
  }

  @override
  String toString() {
    return 'SearchQuery(id: $id, query: $query, category: $category, timestamp: $timestamp)';
  }
}