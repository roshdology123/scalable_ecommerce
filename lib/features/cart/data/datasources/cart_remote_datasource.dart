import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  /// Get user's cart from server
  Future<CartModel> getCart(String userId);

  /// Save cart to server
  Future<CartModel> saveCart(CartModel cart);

  /// Add item to cart on server
  Future<CartModel> addCartItem(String userId, CartItemModel item);

  /// Update cart item on server
  Future<CartModel> updateCartItem(String userId, CartItemModel item);

  /// Remove cart item from server
  Future<CartModel> removeCartItem(String userId, String itemId);

  /// Clear cart on server
  Future<void> clearCart(String userId);

  /// Sync cart with server
  Future<CartModel> syncCart(CartModel localCart);

  /// Apply coupon code
  Future<CartModel> applyCoupon(String userId, String couponCode);

  /// Remove coupon
  Future<CartModel> removeCoupon(String userId, String couponCode);

  /// Validate cart items (check prices, availability)
  Future<CartModel> validateCart(String userId);

  /// Get available shipping methods
  Future<List<Map<String, dynamic>>> getShippingMethods(String userId);

  /// Calculate cart totals with shipping
  Future<Map<String, dynamic>> calculateCartTotals(
      String userId,
      String? shippingMethodId,
      String? couponCode,
      );

  /// Merge guest cart with user cart
  Future<CartModel> mergeGuestCart(String userId, CartModel guestCart);

  /// Get abandoned carts for user
  Future<List<CartModel>> getAbandonedCarts(String userId);

  /// Restore abandoned cart
  Future<CartModel> restoreAbandonedCart(String userId, String cartId);
}

@LazySingleton(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioClient _dioClient;
  final AppLogger _logger = AppLogger();

  CartRemoteDataSourceImpl(this._dioClient);

  @override
  Future<CartModel> getCart(String userId) async {
    try {
      _logger.logNetworkRequest(
        method: 'GET',
        url: '${ApiConstants.baseUrl}/cart/$userId',
      );

      final response = await _dioClient.get('/cart/$userId');

      if (response.statusCode == 200) {
        final cartModel = CartModel.fromJson(response.data);

        _logger.logNetworkRequest(
          method: 'GET',
          url: '${ApiConstants.baseUrl}/cart/$userId',
          statusCode: response.statusCode,
          duration: const Duration(milliseconds: 200),
        );

        return cartModel;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.getCart',
        e,
        StackTrace.current,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      throw NetworkException(
        message: 'Failed to get cart: ${e.toString()}',
        code: 'GET_CART_ERROR',
      );
    }
  }

  @override
  Future<CartModel> saveCart(CartModel cart) async {
    try {
      _logger.logNetworkRequest(
        method: 'PUT',
        url: '${ApiConstants.baseUrl}/cart/${cart.userId}',
        body: cart.toJson(),
      );

      final response = await _dioClient.put(
        '/cart/${cart.userId}',
        data: cart.toJson(),
      );

      if (response.statusCode == 200) {
        final updatedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('cart_synced_to_server', {
          'cart_id': cart.id,
          'items_count': cart.items.length,
          'total': cart.summary.total,
        });

        return updatedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.saveCart',
        e,
        StackTrace.current,
        {
          'cart_id': cart.id,
          'user_id': cart.userId,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to save cart: ${e.toString()}',
        code: 'SAVE_CART_ERROR',
      );
    }
  }

  @override
  Future<CartModel> addCartItem(String userId, CartItemModel item) async {
    try {
      final response = await _dioClient.post(
        '/cart/$userId/items',
        data: item.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final updatedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('cart_item_added_server', {
          'user_id': userId,
          'product_id': item.productId,
          'quantity': item.quantity,
        });

        return updatedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.addCartItem',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'product_id': item.productId,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to add cart item: ${e.toString()}',
        code: 'ADD_CART_ITEM_ERROR',
      );
    }
  }

  @override
  Future<CartModel> updateCartItem(String userId, CartItemModel item) async {
    try {
      final response = await _dioClient.put(
        '/cart/$userId/items/${item.id}',
        data: item.toJson(),
      );

      if (response.statusCode == 200) {
        final updatedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('cart_item_updated_server', {
          'user_id': userId,
          'item_id': item.id,
          'new_quantity': item.quantity,
        });

        return updatedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.updateCartItem',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'item_id': item.id,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to update cart item: ${e.toString()}',
        code: 'UPDATE_CART_ITEM_ERROR',
      );
    }
  }

  @override
  Future<CartModel> removeCartItem(String userId, String itemId) async {
    try {
      final response = await _dioClient.delete('/cart/$userId/items/$itemId');

      if (response.statusCode == 200) {
        final updatedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('cart_item_removed_server', {
          'user_id': userId,
          'item_id': itemId,
        });

        return updatedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.removeCartItem',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'item_id': itemId,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to remove cart item: ${e.toString()}',
        code: 'REMOVE_CART_ITEM_ERROR',
      );
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      final response = await _dioClient.delete('/cart/$userId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _logger.logUserAction('cart_cleared_server', {
          'user_id': userId,
        });
        return;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.clearCart',
        e,
        StackTrace.current,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      throw NetworkException(
        message: 'Failed to clear cart: ${e.toString()}',
        code: 'CLEAR_CART_ERROR',
      );
    }
  }

  @override
  Future<CartModel> syncCart(CartModel localCart) async {
    try {
      final response = await _dioClient.post(
        '/cart/${localCart.userId}/sync',
        data: {
          'local_cart': localCart.toJson(),
          'last_synced': localCart.lastSyncedAt?.toIso8601String(),
          'version': localCart.version,
        },
      );

      if (response.statusCode == 200) {
        final syncedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('cart_synced', {
          'user_id': localCart.userId,
          'local_version': localCart.version,
          'server_version': syncedCart.version,
        });

        return syncedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.syncCart',
        e,
        StackTrace.current,
        {
          'cart_id': localCart.id,
          'user_id': localCart.userId,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to sync cart: ${e.toString()}',
        code: 'SYNC_CART_ERROR',
      );
    }
  }

  @override
  Future<CartModel> applyCoupon(String userId, String couponCode) async {
    try {
      final response = await _dioClient.post(
        '/cart/$userId/coupons',
        data: {'coupon_code': couponCode},
      );

      if (response.statusCode == 200) {
        final updatedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('coupon_applied', {
          'user_id': userId,
          'coupon_code': couponCode,
          'discount_amount': updatedCart.summary.couponDiscount,
        });

        return updatedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.applyCoupon',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'coupon_code': couponCode,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to apply coupon: ${e.toString()}',
        code: 'APPLY_COUPON_ERROR',
      );
    }
  }

  @override
  Future<CartModel> removeCoupon(String userId, String couponCode) async {
    try {
      final response = await _dioClient.delete('/cart/$userId/coupons/$couponCode');

      if (response.statusCode == 200) {
        final updatedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('coupon_removed', {
          'user_id': userId,
          'coupon_code': couponCode,
        });

        return updatedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.removeCoupon',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'coupon_code': couponCode,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to remove coupon: ${e.toString()}',
        code: 'REMOVE_COUPON_ERROR',
      );
    }
  }

  @override
  Future<CartModel> validateCart(String userId) async {
    try {
      final response = await _dioClient.post('/cart/$userId/validate');

      if (response.statusCode == 200) {
        final validatedCart = CartModel.fromJson(response.data);

        _logger.logBusinessLogic(
          'cart_validation',
          'completed',
          {
            'user_id': userId,
            'items_count': validatedCart.items.length,
            'total': validatedCart.summary.total,
          },
        );

        return validatedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.validateCart',
        e,
        StackTrace.current,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      throw NetworkException(
        message: 'Failed to validate cart: ${e.toString()}',
        code: 'VALIDATE_CART_ERROR',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getShippingMethods(String userId) async {
    try {
      final response = await _dioClient.get('/cart/$userId/shipping-methods');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['shipping_methods']);
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.getShippingMethods',
        e,
        StackTrace.current,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      throw NetworkException(
        message: 'Failed to get shipping methods: ${e.toString()}',
        code: 'GET_SHIPPING_METHODS_ERROR',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> calculateCartTotals(
      String userId,
      String? shippingMethodId,
      String? couponCode,
      ) async {
    try {
      final response = await _dioClient.post(
        '/cart/$userId/calculate',
        data: {
          'shipping_method_id': shippingMethodId,
          'coupon_code': couponCode,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.calculateCartTotals',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'shipping_method_id': shippingMethodId,
          'coupon_code': couponCode,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to calculate cart totals: ${e.toString()}',
        code: 'CALCULATE_TOTALS_ERROR',
      );
    }
  }

  @override
  Future<CartModel> mergeGuestCart(String userId, CartModel guestCart) async {
    try {
      final response = await _dioClient.post(
        '/cart/$userId/merge',
        data: {'guest_cart': guestCart.toJson()},
      );

      if (response.statusCode == 200) {
        final mergedCart = CartModel.fromJson(response.data);

        _logger.logUserAction('cart_merged', {
          'user_id': userId,
          'guest_items': guestCart.items.length,
          'merged_items': mergedCart.items.length,
        });

        return mergedCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.mergeGuestCart',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'guest_cart_id': guestCart.id,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to merge guest cart: ${e.toString()}',
        code: 'MERGE_CART_ERROR',
      );
    }
  }

  @override
  Future<List<CartModel>> getAbandonedCarts(String userId) async {
    try {
      final response = await _dioClient.get('/cart/$userId/abandoned');

      if (response.statusCode == 200) {
        final cartsJson = response.data['abandoned_carts'] as List<dynamic>;
        return cartsJson
            .map((json) => CartModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.getAbandonedCarts',
        e,
        StackTrace.current,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      throw NetworkException(
        message: 'Failed to get abandoned carts: ${e.toString()}',
        code: 'GET_ABANDONED_CARTS_ERROR',
      );
    }
  }

  @override
  Future<CartModel> restoreAbandonedCart(String userId, String cartId) async {
    try {
      final response = await _dioClient.post('/cart/$userId/restore/$cartId');

      if (response.statusCode == 200) {
        final restoredCart = CartModel.fromJson(response.data);

        _logger.logUserAction('cart_restored', {
          'user_id': userId,
          'cart_id': cartId,
          'items_count': restoredCart.items.length,
        });

        return restoredCart;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;

      _logger.logErrorWithContext(
        'CartRemoteDataSource.restoreAbandonedCart',
        e,
        StackTrace.current,
        {
          'user_id': userId,
          'cart_id': cartId,
          'user': 'roshdology123',
        },
      );

      throw NetworkException(
        message: 'Failed to restore abandoned cart: ${e.toString()}',
        code: 'RESTORE_CART_ERROR',
      );
    }
  }
}