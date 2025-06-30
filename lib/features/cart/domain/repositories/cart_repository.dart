import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';
import '../entities/cart_summary.dart';

abstract class CartRepository {
  /// Get current cart for user (or guest cart if userId is null)
  Future<Either<Failure, Cart>> getCart([String? userId]);

  /// Add product to cart with variants and quantity
  Future<Either<Failure, Cart>> addToCart({
    required int productId,
    required String productTitle,
    required String productImage,
    required double price,
    required int quantity,
    String? selectedColor,
    String? selectedSize,
    Map<String, String>? additionalVariants,
    String? userId,
    int? maxQuantity,
    String? brand,
    String? category,
    String? sku,
    double? originalPrice,
    double? discountPercentage,
  });

  /// Remove item from cart by item ID
  Future<Either<Failure, Cart>> removeFromCart({
    required String itemId,
    String? userId,
  });

  /// Update cart item (quantity, variants, etc.)
  Future<Either<Failure, Cart>> updateCartItem({
    required String itemId,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    String? userId,
  });

  /// Clear entire cart
  Future<Either<Failure, void>> clearCart([String? userId]);

  /// Get total number of items in cart (quantity sum)
  Future<Either<Failure, int>> getCartItemsCount([String? userId]);

  /// Get cart total amount
  Future<Either<Failure, double>> getCartTotal([String? userId]);

  /// Check if specific product variant is in cart
  Future<Either<Failure, bool>> isItemInCart({
    required int productId,
    required Map<String, String> variants,
    String? userId,
  });

  /// Apply discount coupon to cart
  Future<Either<Failure, Cart>> applyCoupon({
    required String couponCode,
    String? userId,
  });

  /// Remove discount coupon from cart
  Future<Either<Failure, Cart>> removeCoupon({
    required String couponCode,
    String? userId,
  });

  /// Calculate cart totals with shipping and taxes
  Future<Either<Failure, CartSummary>> calculateCartTotals({
    String? shippingMethodId,
    String? couponCode,
    String? userId,
  });

  /// Sync local cart with server (for authenticated users)
  Future<Either<Failure, Cart>> syncCart(String userId);

  /// Merge guest cart with user cart after login
  Future<Either<Failure, Cart>> mergeGuestCart({
    required String userId,
    required Cart guestCart,
  });

  /// Validate cart items (check availability, prices, stock)
  Future<Either<Failure, Cart>> validateCart([String? userId]);
}