import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/favorites_collection.dart';

part 'favorites_collection_state.freezed.dart';


@freezed
class FavoritesCollectionsState with _$FavoritesCollectionsState {
  const factory FavoritesCollectionsState.initial() = Initial;

  const factory FavoritesCollectionsState.loading() = Loading;

  const factory FavoritesCollectionsState.loaded({
    required List<FavoritesCollection> collections,
    required List<FavoritesCollection> smartCollections,
    FavoritesCollection? selectedCollection,
    @Default(false) bool isCreating,
    @Default(false) bool isEditing,
  }) = Loaded;

  const factory FavoritesCollectionsState.error({
    required String message,
    String? code,
  }) = Error;

  const factory FavoritesCollectionsState.creating() = Creating;

  const factory FavoritesCollectionsState.editing({
    required FavoritesCollection collection,
  }) = Editing;
}