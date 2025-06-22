import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/search_suggestion.dart';

part 'search_suggestion_model.freezed.dart';

@freezed
@HiveType(typeId: 11)
class SearchSuggestionModel with _$SearchSuggestionModel {
  const factory SearchSuggestionModel({
    @HiveField(0) required String id,
    @HiveField(1) required String text,
    @HiveField(2) required SuggestionType type,
    @HiveField(3) @Default(0) int searchCount,
    @HiveField(4) required DateTime lastUsed,
    @HiveField(5) String? category,
    @HiveField(6) String? imageUrl,
  }) = _SearchSuggestionModel;

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    final typeString = json['type']?.toString() ?? 'product';
    final type = SuggestionType.values.firstWhere(
          (e) => e.name == typeString,
      orElse: () => SuggestionType.product,
    );

    return SearchSuggestionModel(
      id: json['id']?.toString() ?? const Uuid().v4(),
      text: json['text']?.toString() ?? '',
      type: type,
      searchCount: json['searchCount'] as int? ?? 0,
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'].toString())
          : DateTime.now(),
      category: json['category']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  factory SearchSuggestionModel.fromSearchSuggestion(SearchSuggestion suggestion) {
    return SearchSuggestionModel(
      id: suggestion.id,
      text: suggestion.text,
      type: suggestion.type,
      searchCount: suggestion.searchCount,
      lastUsed: suggestion.lastUsed,
      category: suggestion.category,
      imageUrl: suggestion.imageUrl,
    );
  }

  factory SearchSuggestionModel.create({
    required String text,
    required SuggestionType type,
    String? category,
    String? imageUrl,
  }) {
    return SearchSuggestionModel(
      id: const Uuid().v4(),
      text: text,
      type: type,
      searchCount: 0,
      lastUsed: DateTime.now(),
      category: category,
      imageUrl: imageUrl,
    );
  }

  factory SearchSuggestionModel.fromProductTitle(String title, {String? category, String? imageUrl}) {
    return SearchSuggestionModel.create(
      text: title,
      type: SuggestionType.product,
      category: category,
      imageUrl: imageUrl,
    );
  }

  factory SearchSuggestionModel.fromCategory(String categoryName) {
    return SearchSuggestionModel.create(
      text: categoryName,
      type: SuggestionType.category,
      category: categoryName,
    );
  }

  factory SearchSuggestionModel.fromBrand(String brandName) {
    return SearchSuggestionModel.create(
      text: brandName,
      type: SuggestionType.brand,
    );
  }
}

extension SearchSuggestionModelExtension on SearchSuggestionModel {
  SearchSuggestion toSearchSuggestion() {
    return SearchSuggestion(
      id: id,
      text: text,
      type: type,
      searchCount: searchCount,
      lastUsed: lastUsed,
      category: category,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'searchCount': searchCount,
      'lastUsed': lastUsed.toIso8601String(),
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  SearchSuggestionModel incrementUsage() {
    return copyWith(
      searchCount: searchCount + 1,
      lastUsed: DateTime.now(),
    );
  }
}