import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';

part 'categories_state.freezed.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState.initial() = CategoriesInitial;

  const factory CategoriesState.loading() = CategoriesLoading;

  const factory CategoriesState.loaded(
      List<Category> categories,
      String? selectedCategoryId,
      ) = CategoriesLoaded;

  const factory CategoriesState.empty() = CategoriesEmpty;

  const factory CategoriesState.error(
      String message,
      String? code,
      ) = CategoriesError;
}

// Extension for easier state checking
extension CategoriesStateX on CategoriesState {
  bool get isLoading => this is CategoriesLoading;
  bool get isLoaded => this is CategoriesLoaded;
  bool get isEmpty => this is CategoriesEmpty;
  bool get isError => this is CategoriesError;
  bool get isInitial => this is CategoriesInitial;

  List<Category> get categories => maybeWhen(
    loaded: (categories, _) => categories,
    orElse: () => [],
  );

  String? get selectedCategoryId => maybeWhen(
    loaded: (_, selectedCategoryId) => selectedCategoryId,
    orElse: () => null,
  );

  Category? get selectedCategory => maybeWhen(
    loaded: (categories, selectedCategoryId) => selectedCategoryId != null
        ? categories
        .where((category) => category.id == selectedCategoryId)
        .firstOrNull
        : null,
    orElse: () => null,
  );

  String? get errorMessage => maybeWhen(
    error: (message, _) => message,
    orElse: () => null,
  );

  String? get errorCode => maybeWhen(
    error: (_, code) => code,
    orElse: () => null,
  );
}

// Extension to get first category or null safely
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}