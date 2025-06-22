import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/search_query.dart';

part 'search_query_model.freezed.dart';

@freezed
@HiveType(typeId: 10)
class SearchQueryModel with _$SearchQueryModel {
  const factory SearchQueryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String query,
    @HiveField(2) String? category,
    @HiveField(3) double? minPrice,
    @HiveField(4) double? maxPrice,
    @HiveField(5) double? minRating,
    @HiveField(6) required DateTime timestamp,
    @HiveField(7) required int resultCount,
  }) = _SearchQueryModel;

  factory SearchQueryModel.fromJson(Map<String, dynamic> json) {
    return SearchQueryModel(
      id: json['id']?.toString() ?? const Uuid().v4(),
      query: json['query']?.toString() ?? '',
      category: json['category']?.toString(),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      minRating: (json['minRating'] as num?)?.toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      resultCount: json['resultCount'] as int? ?? 0,
    );
  }

  factory SearchQueryModel.fromSearchQuery(SearchQuery searchQuery) {
    return SearchQueryModel(
      id: searchQuery.id,
      query: searchQuery.query,
      category: searchQuery.category,
      minPrice: searchQuery.minPrice,
      maxPrice: searchQuery.maxPrice,
      minRating: searchQuery.minRating,
      timestamp: searchQuery.timestamp,
      resultCount: searchQuery.resultCount,
    );
  }

  factory SearchQueryModel.create({
    required String query,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int resultCount = 0,
  }) {
    return SearchQueryModel(
      id: const Uuid().v4(),
      query: query,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      timestamp: DateTime.now(),
      resultCount: resultCount,
    );
  }
}

extension SearchQueryModelExtension on SearchQueryModel {
  SearchQuery toSearchQuery() {
    return SearchQuery(
      id: id,
      query: query,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      timestamp: timestamp,
      resultCount: resultCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'category': category,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'minRating': minRating,
      'timestamp': timestamp.toIso8601String(),
      'resultCount': resultCount,
    };
  }
}