import 'package:equatable/equatable.dart';

enum SuggestionType {
  product,
  category,
  brand,
  recent,
  popular,
}

class SearchSuggestion extends Equatable {
  final String id;
  final String text;
  final SuggestionType type;
  final int searchCount;
  final DateTime lastUsed;
  final String? category;
  final String? imageUrl;

  const SearchSuggestion({
    required this.id,
    required this.text,
    required this.type,
    this.searchCount = 0,
    required this.lastUsed,
    this.category,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    type,
    searchCount,
    lastUsed,
    category,
    imageUrl,
  ];

  SearchSuggestion copyWith({
    String? id,
    String? text,
    SuggestionType? type,
    int? searchCount,
    DateTime? lastUsed,
    String? category,
    String? imageUrl,
  }) {
    return SearchSuggestion(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      searchCount: searchCount ?? this.searchCount,
      lastUsed: lastUsed ?? this.lastUsed,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'SearchSuggestion(text: $text, type: $type, searchCount: $searchCount)';
  }
}