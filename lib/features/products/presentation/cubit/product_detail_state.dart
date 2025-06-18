import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.dart';

part 'product_detail_state.freezed.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.initial() = ProductDetailInitial;

  const factory ProductDetailState.loading() = ProductDetailLoading;

  const factory ProductDetailState.loaded({
    required Product product,
    @Default([]) List<Product> relatedProducts,
    @Default(false) bool isFavorite,
  }) = ProductDetailLoaded;

  const factory ProductDetailState.error(
      String message,
      String? code,
      ) = ProductDetailError;
}

// Extension for easier state checking
extension ProductDetailStateX on ProductDetailState {
  bool get isLoading => this is ProductDetailLoading;
  bool get isLoaded => this is ProductDetailLoaded;
  bool get isError => this is ProductDetailError;
  bool get isInitial => this is ProductDetailInitial;

  Product? get product => maybeWhen(
    loaded: (product, _, __) => product,
    orElse: () => null,
  );

  List<Product> get relatedProducts => maybeWhen(
    loaded: (_, relatedProducts, __) => relatedProducts,
    orElse: () => [],
  );

  bool get isFavorite => maybeWhen(
    loaded: (_, __, isFavorite) => isFavorite,
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