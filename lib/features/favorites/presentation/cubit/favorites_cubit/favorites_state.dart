import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/favorite_item.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = Initial;

  const factory FavoritesState.loading() = Loading;

  const factory FavoritesState.loaded({
    required List<FavoriteItem> favorites,
    required int totalCount,
    @Default('') String searchQuery,
    String? selectedCategory,
    @Default('date_added') String sortBy,
    @Default('desc') String sortOrder,
    @Default(false) bool isGridView,
    @Default(false) bool isSelectionMode,
    @Default([]) List<String> selectedFavoriteIds,
    Map<String, dynamic>? filters,
  }) = Loaded;

  const factory FavoritesState.empty({
    @Default('') String searchQuery,
    String? selectedCategory,
    Map<String, dynamic>? filters,
  }) = Empty;

  const factory FavoritesState.error({
    required String message,
    String? code,
    @Default('') String searchQuery,
    String? selectedCategory,
  }) = Error;
}