import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

@injectable
class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  final CartRepository _repository;
  final AppLogger _logger = AppLogger();

  AddToCartUseCase(this._repository);

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    final startTime = DateTime.now();

    _logger.logBusinessLogic(
      'add_to_cart_usecase',
      'started',
      {
        'product_id': params.productId,
        'quantity': params.quantity,
        'user_id': params.userId ?? 'guest',
        'selected_color': params.selectedColor,
        'selected_size': params.selectedSize,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:01:31',
      },
    );

    // Validate business rules
    final validation = _validateAddToCart(params);
    if (validation != null) {
      _logger.logBusinessLogic(
        'add_to_cart_usecase',
        'validation_failed',
        {'error': validation.message, 'code': validation.code},
      );
      return Left(validation);
    }

    final result = await _repository.addToCart(
      productId: params.productId,
      productTitle: params.productTitle,
      productImage: params.productImage,
      price: params.price,
      quantity: params.quantity,
      selectedColor: params.selectedColor,
      selectedSize: params.selectedSize,
      additionalVariants: params.additionalVariants,
      userId: params.userId,
      maxQuantity: params.maxQuantity,
      brand: params.brand,
      category: params.category,
      sku: params.sku,
      originalPrice: params.originalPrice,
      discountPercentage: params.discountPercentage,
    );

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) => _logger.logBusinessLogic(
        'add_to_cart_usecase',
        'failed',
        {
          'error': failure.message,
          'code': failure.code,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
          (cart) => _logger.logBusinessLogic(
        'add_to_cart_usecase',
        'success',
        {
          'cart_items': cart.items.length,
          'cart_total': cart.summary.total,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        },
      ),
    );

    return result;
  }

  Failure? _validateAddToCart(AddToCartParams params) {
    // Validate required fields
    if (params.productTitle.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Product title cannot be empty',
        code: 'INVALID_PRODUCT_TITLE',
      );
    }

    if (params.productImage.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Product image is required',
        code: 'INVALID_PRODUCT_IMAGE',
      );
    }

    if (params.price < 0) {
      return const BusinessFailure(
        message: 'Product price cannot be negative',
        code: 'INVALID_PRICE',
      );
    }

    if (params.quantity <= 0) {
      return BusinessFailure.invalidQuantity();
    }

    if (params.quantity > 999) {
      return const BusinessFailure(
        message: 'Quantity cannot exceed 999 items',
        code: 'QUANTITY_TOO_HIGH',
      );
    }

    if (params.maxQuantity != null && params.quantity > params.maxQuantity!) {
      return BusinessFailure(
        message: 'Quantity cannot exceed maximum of ${params.maxQuantity}',
        code: 'QUANTITY_EXCEEDS_MAX',
      );
    }

    // Validate price consistency
    if (params.originalPrice != null && params.originalPrice! < params.price) {
      return const BusinessFailure(
        message: 'Original price cannot be less than current price',
        code: 'INVALID_ORIGINAL_PRICE',
      );
    }

    // Validate discount percentage
    if (params.discountPercentage != null) {
      if (params.discountPercentage! < 0 || params.discountPercentage! > 100) {
        return const ValidationFailure(
          message: 'Discount percentage must be between 0 and 100',
          code: 'INVALID_DISCOUNT_PERCENTAGE',
        );
      }
    }

    // Validate product ID
    if (params.productId <= 0) {
      return const ValidationFailure(
        message: 'Invalid product ID',
        code: 'INVALID_PRODUCT_ID',
      );
    }

    return null;
  }
}

class AddToCartParams extends Equatable {
  final int productId;
  final String productTitle;
  final String productImage;
  final double price;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final Map<String, String>? additionalVariants;
  final String? userId;
  final int? maxQuantity;
  final String? brand;
  final String? category;
  final String? sku;
  final double? originalPrice;
  final double? discountPercentage;

  const AddToCartParams({
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    this.additionalVariants,
    this.userId,
    this.maxQuantity,
    this.brand,
    this.category,
    this.sku,
    this.originalPrice,
    this.discountPercentage,
  });

  @override
  List<Object?> get props => [
    productId,
    productTitle,
    productImage,
    price,
    quantity,
    selectedColor,
    selectedSize,
    additionalVariants,
    userId,
    maxQuantity,
    brand,
    category,
    sku,
    originalPrice,
    discountPercentage,
  ];
}