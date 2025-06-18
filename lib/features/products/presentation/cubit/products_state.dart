import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';

part 'products_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = ProductsInitial;

  const factory ProductsState.loading() = ProductsLoading;

  const factory ProductsState.loaded(
      List<Product> products, {
        @Default(false) bool hasReachedMax,
        @Default(1) int currentPage,
        String? category,
        String? sortBy,
      }) = ProductsLoaded;

  const factory ProductsState.loadingMore(
      List<Product> products, {
        @Default(false) bool hasReachedMax,
        @Default(1) int currentPage,
        String? category,
        String? sortBy,
      }) = ProductsLoadingMore;

  const factory ProductsState.empty() = ProductsEmpty;

  const factory ProductsState.error(
      String message,
      String? code,
      ) = ProductsError;
}

// Extension for easier state checking
extension ProductsStateX on ProductsState {
  bool get isLoading => this is ProductsLoading;
  bool get isLoadingMore => this is ProductsLoadingMore;
  bool get isLoaded => this is ProductsLoaded;
  bool get isEmpty => this is ProductsEmpty;
  bool get isError => this is ProductsError;
  bool get isInitial => this is ProductsInitial;

  List<Product> get products => maybeWhen(
    loaded: (products, _, __, ___, ____) => products,
    loadingMore: (products, _, __, ___, ____) => products,
    orElse: () => [],
  );

  bool get hasReachedMax => maybeWhen(
    loaded: (_, hasReachedMax, __, ___, ____) => hasReachedMax,
    loadingMore: (_, hasReachedMax, __, ___, ____) => hasReachedMax,
    orElse: () => false,
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