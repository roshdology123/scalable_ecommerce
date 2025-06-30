import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/repositories/products_repository.dart';
import 'product_detail_state.dart';

@injectable
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductByIdUseCase _getProductByIdUseCase;
  final ProductsRepository _productsRepository;

  ProductDetailCubit(
      this._getProductByIdUseCase,
      this._productsRepository,
      ) : super(const ProductDetailState.initial());

  Product? _currentProduct;
  List<Product> _relatedProducts = [];
  bool _isFavorite = false;

  // Getters
  Product? get currentProduct => _currentProduct;
  List<Product> get relatedProducts => _relatedProducts;
  bool get isFavorite => _isFavorite;

  /// Load product details by ID
  Future<void> loadProduct(int productId) async {
    if (_currentProduct?.id == productId) {
      // Product already loaded
      return;
    }

    emit(const ProductDetailState.loading());

    try {
      // Load product details
      final productResult = await _getProductByIdUseCase(
        GetProductByIdParams(productId: productId),
      );

      await productResult.fold(
            (failure) async {
          emit(ProductDetailState.error(failure.message, failure.code));
        },
            (product) async {
          _currentProduct = product;

          // Check if product is favorite
          final favoriteResult = await _productsRepository.isFavorite(productId);
          favoriteResult.fold(
                (_) => _isFavorite = false,
                (isFav) => _isFavorite = isFav,
          );

          // Load related products
          await _loadRelatedProducts(productId);

          emit(ProductDetailState.loaded(
            product: product,
            relatedProducts: _relatedProducts,
            isFavorite: _isFavorite,
          ));
        },
      );
    } catch (e) {
      emit(ProductDetailState.error(
        'An unexpected error occurred: ${e.toString()}',
        'UNKNOWN_ERROR',
      ));
    }
  }

  /// Load related products
  Future<void> _loadRelatedProducts(int productId) async {
    try {
      final result = await _productsRepository.getRelatedProducts(
        productId: productId,
        limit: 10,
      );

      result.fold(
            (_) => _relatedProducts = [],
            (products) => _relatedProducts = products,
      );
    } catch (e) {
      _relatedProducts = [];
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite() async {
    if (_currentProduct == null) return;

    final productId = _currentProduct!.id;
    final wasError = state.isError;

    // Optimistic update
    _isFavorite = !_isFavorite;

    if (!wasError) {
      emit(ProductDetailState.loaded(
        product: _currentProduct!,
        relatedProducts: _relatedProducts,
        isFavorite: _isFavorite,
      ));
    }

    try {
      if (_isFavorite) {
        final result = await _productsRepository.addToFavorites(productId);
        result.fold(
              (failure) {
            // Revert optimistic update
            _isFavorite = !_isFavorite;
            if (!wasError) {
              emit(ProductDetailState.loaded(
                product: _currentProduct!,
                relatedProducts: _relatedProducts,
                isFavorite: _isFavorite,
              ));
            }
          },
              (_) {
            // Success - keep the optimistic update
          },
        );
      } else {
        final result = await _productsRepository.removeFromFavorites(productId);
        result.fold(
              (failure) {
            // Revert optimistic update
            _isFavorite = !_isFavorite;
            if (!wasError) {
              emit(ProductDetailState.loaded(
                product: _currentProduct!,
                relatedProducts: _relatedProducts,
                isFavorite: _isFavorite,
              ));
            }
          },
              (_) {
            // Success - keep the optimistic update
          },
        );
      }
    } catch (e) {
      // Revert optimistic update on error
      _isFavorite = !_isFavorite;
      if (!wasError) {
        emit(ProductDetailState.loaded(
          product: _currentProduct!,
          relatedProducts: _relatedProducts,
          isFavorite: _isFavorite,
        ));
      }
    }
  }

  /// Refresh product details
  Future<void> refresh() async {
    if (_currentProduct == null) return;
    await loadProduct(_currentProduct!.id);
  }

  /// Update view count (track product views)
  Future<void> updateViewCount() async {
    if (_currentProduct == null) return;

    // Update the product's last viewed timestamp
    _currentProduct = _currentProduct!.copyWith(
      lastViewedAt: DateTime.now(),
      viewCount: _currentProduct!.viewCount + 1,
    );
  }

  /// Select image index (for image carousel)
  int _selectedImageIndex = 0;
  int get selectedImageIndex => _selectedImageIndex;

  void selectImage(int index) {
    if (_currentProduct != null &&
        index >= 0 &&
        index < _currentProduct!.allImages.length) {
      _selectedImageIndex = index;

      // Emit the same state to trigger UI update
      if (state is ProductDetailLoaded) {
        emit(ProductDetailState.loaded(
          product: _currentProduct!,
          relatedProducts: _relatedProducts,
          isFavorite: _isFavorite,
        ));
      }
    }
  }

  /// Selected color and size for products with variants
  String? _selectedColor;
  String? _selectedSize;

  String? get selectedColor => _selectedColor;
  String? get selectedSize => _selectedSize;

  void selectColor(String color) {
    if (_currentProduct?.colors.contains(color) == true) {
      _selectedColor = color;

      if (state is ProductDetailLoaded) {
        emit(ProductDetailState.loaded(
          product: _currentProduct!,
          relatedProducts: _relatedProducts,
          isFavorite: _isFavorite,
        ));
      }
    }
  }

  void selectSize(String size) {
    if (_currentProduct?.sizes.contains(size) == true) {
      _selectedSize = size;

      if (state is ProductDetailLoaded) {
        emit(ProductDetailState.loaded(
          product: _currentProduct!,
          relatedProducts: _relatedProducts,
          isFavorite: _isFavorite,
        ));
      }
    }
  }

  /// Check if product can be added to cart
  bool get canAddToCart {
    if (_currentProduct == null) return false;

    // Check stock
    if (!_currentProduct!.inStock) return false;

    // Check if size is required but not selected
    if (_currentProduct!.hasSizes && _selectedSize == null) return false;

    // Check if color is required but not selected
    if (_currentProduct!.hasColors && _selectedColor == null) return false;

    return true;
  }

  /// Get selected variant info
  Map<String, String> get selectedVariant {
    final variant = <String, String>{};

    if (_selectedColor != null) {
      variant['color'] = _selectedColor!;
    }

    if (_selectedSize != null) {
      variant['size'] = _selectedSize!;
    }

    return variant;
  }

  /// Reset state
  void reset() {
    _currentProduct = null;
    _relatedProducts = [];
    _isFavorite = false;
    _selectedImageIndex = 0;
    _selectedColor = null;
    _selectedSize = null;
    emit(const ProductDetailState.initial());
  }

  /// Load product with optimistic loading (show cached data first)
  Future<void> loadProductOptimistic(int productId, Product? cachedProduct) async {
    if (cachedProduct != null) {
      _currentProduct = cachedProduct;

      // Check favorite status
      final favoriteResult = await _productsRepository.isFavorite(productId);
      favoriteResult.fold(
            (_) => _isFavorite = false,
            (isFav) => _isFavorite = isFav,
      );

      // Emit loaded state with cached data
      emit(ProductDetailState.loaded(
        product: cachedProduct,
        relatedProducts: _relatedProducts,
        isFavorite: _isFavorite,
      ));

      // Then load fresh data in background
      await _loadRelatedProducts(productId);

      // Update with related products
      emit(ProductDetailState.loaded(
        product: cachedProduct,
        relatedProducts: _relatedProducts,
        isFavorite: _isFavorite,
      ));
    } else {
      // No cached data, load normally
      await loadProduct(productId);
    }
  }
}