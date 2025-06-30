import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/cart_summary_model.dart';

abstract class CartLocalDataSource {
  /// Get current cart
  Future<CartModel?> getCart();

  /// Save cart
  Future<void> saveCart(CartModel cart);

  /// Add item to cart
  Future<void> addCartItem(CartItemModel item);

  /// Update cart item
  Future<void> updateCartItem(CartItemModel item);

  /// Remove cart item
  Future<void> removeCartItem(String itemId);

  /// Clear cart
  Future<void> clearCart();

  /// Get cart items count
  Future<int> getCartItemsCount();

  /// Get cart total
  Future<double> getCartTotal();

  /// Check if item exists in cart
  Future<bool> isItemInCart(String itemId);

  /// Get cart item by product ID and variants
  Future<CartItemModel?> getCartItemByProduct(
      int productId,
      Map<String, String> variants,
      );

  /// Save abandoned cart
  Future<void> saveAbandonedCart(CartModel cart);

  /// Get abandoned carts
  Future<List<CartModel>> getAbandonedCarts();

  /// Clear abandoned carts
  Future<void> clearAbandonedCarts();

  /// Get cart sync timestamp
  Future<DateTime?> getLastSyncTimestamp();

  /// Save cart sync timestamp
  Future<void> saveLastSyncTimestamp(DateTime timestamp);

  /// Get pending cart changes
  Future<List<Map<String, dynamic>>> getPendingChanges();

  /// Save pending cart change
  Future<void> savePendingChange(Map<String, dynamic> change);

  /// Clear pending changes
  Future<void> clearPendingChanges();

  // 🔥 NEW: Simulated coupon methods for roshdology123
  Future<Map<String, dynamic>> validateCoupon(String couponCode);
  Future<CartModel> applyCouponToCart(CartModel cart, String couponCode);
  Future<CartModel> removeCouponFromCart(CartModel cart, String couponCode);
  Future<List<Map<String, dynamic>>> getAvailableCoupons();
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartKey = 'current_cart';
  static const String _cartItemsKey = 'cart_items';
  static const String _abandonedCartsKey = 'abandoned_carts';
  static const String _lastSyncKey = 'cart_last_sync';
  static const String _pendingChangesKey = 'cart_pending_changes';

  final AppLogger _logger = AppLogger();

  // 🔥 SIMULATED COUPON DATABASE for roshdology123 (2025-06-22 13:27:12)
  static const Map<String, Map<String, dynamic>> _mockCoupons = {
    'FREESHIP': {
      'code': 'FREESHIP',
      'type': 'free_shipping',
      'discount_value': 0.0,
      'minimum_amount': 50.0,
      'maximum_discount': null,
      'description': 'Free shipping on orders over \$50',
      'expires_at': '2025-12-31T23:59:59Z',
      'is_active': true,
      'usage_limit': 1000,
      'used_count': 245,
    },
    'SAVE10': {
      'code': 'SAVE10',
      'type': 'percentage',
      'discount_value': 10.0,
      'minimum_amount': 25.0,
      'maximum_discount': 20.0,
      'description': '10% off orders over \$25 (max \$20)',
      'expires_at': '2025-12-31T23:59:59Z',
      'is_active': true,
      'usage_limit': 500,
      'used_count': 123,
    },
    'SAVE20': {
      'code': 'SAVE20',
      'type': 'percentage',
      'discount_value': 20.0,
      'minimum_amount': 100.0,
      'maximum_discount': 50.0,
      'description': '20% off orders over \$100 (max \$50)',
      'expires_at': '2025-12-31T23:59:59Z',
      'is_active': true,
      'usage_limit': 200,
      'used_count': 67,
    },
    'FIXED15': {
      'code': 'FIXED15',
      'type': 'fixed_amount',
      'discount_value': 15.0,
      'minimum_amount': 75.0,
      'maximum_discount': null,
      'description': '\$15 off orders over \$75',
      'expires_at': '2025-12-31T23:59:59Z',
      'is_active': true,
      'usage_limit': 300,
      'used_count': 89,
    },
    'NEWUSER': {
      'code': 'NEWUSER',
      'type': 'percentage',
      'discount_value': 15.0,
      'minimum_amount': 30.0,
      'maximum_discount': 25.0,
      'description': '15% off for new users (max \$25)',
      'expires_at': '2025-12-31T23:59:59Z',
      'is_active': true,
      'usage_limit': 1000,
      'used_count': 456,
    },
    'WELCOME25': {
      'code': 'WELCOME25',
      'type': 'fixed_amount',
      'discount_value': 25.0,
      'minimum_amount': 100.0,
      'maximum_discount': null,
      'description': '\$25 off your first order over \$100',
      'expires_at': '2025-12-31T23:59:59Z',
      'is_active': true,
      'usage_limit': 1000,
      'used_count': 234,
    },
    'EXPIRED10': {
      'code': 'EXPIRED10',
      'type': 'percentage',
      'discount_value': 10.0,
      'minimum_amount': 20.0,
      'maximum_discount': 15.0,
      'description': '10% off (EXPIRED)',
      'expires_at': '2024-12-31T23:59:59Z',
      'is_active': false,
      'usage_limit': 100,
      'used_count': 100,
    },
  };

  @override
  Future<CartModel?> getCart() async {
    try {
      final cartData = LocalStorage.getFromCache(_cartKey);
      if (cartData == null) return null;

      // Safely convert the data to Map<String, dynamic>
      final safeCartData = _ensureStringKeyMap(cartData);

      _logger.logCacheOperation('get_cart', _cartKey, true);
      return CartModel.fromJson(safeCartData);
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.getCart',
        e,
        stackTrace,
        {'user': 'roshdology123'},
      );
      throw CacheException.readError();
    }
  }

  /// Helper method to safely convert Map<dynamic, dynamic> to Map<String, dynamic>
  Map<String, dynamic> _ensureStringKeyMap(dynamic data) {
    if (data == null) return {};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }

  @override
  Future<void> saveCart(CartModel cart) async {
    try {
      await LocalStorage.saveToCache(
        _cartKey,
        cart.toJson(),
        expiry: AppConstants.cacheDurationLong,
      );

      // Also save individual items for quick access
      final itemsData = cart.items.map((item) => item.toJson()).toList();
      await LocalStorage.saveToCache(
        _cartItemsKey,
        {'items': itemsData, 'count': cart.items.length},
        expiry: AppConstants.cacheDurationLong,
      );

      _logger.logCacheOperation('save_cart', _cartKey, true,
          'Items: ${cart.items.length}, Total: \$${cart.summary.total}');

      _logger.logUserAction('cart_saved', {
        'items_count': cart.items.length,
        'total': cart.summary.total,
        'user_id': cart.userId ?? 'roshdology123',
        'timestamp': '2025-06-22 13:27:12',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.saveCart',
        e,
        stackTrace,
        {
          'cart_id': cart.id,
          'items_count': cart.items.length,
          'user': 'roshdology123',
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> addCartItem(CartItemModel item) async {
    try {
      final cart = await getCart();
      CartModel updatedCart;

      if (cart == null) {
        // Create new cart with this item
        final cartSummary = CartSummaryModel.calculateFromItems([item]);
        updatedCart = CartModel.empty().copyWith(
          items: [item],
          summary: cartSummary,
          updatedAt: DateTime.now(),
        );
      } else {
        // Add to existing cart
        final existingIndex = cart.items.indexWhere((i) => i.id == item.id);
        final updatedItems = List<CartItemModel>.from(cart.items);

        if (existingIndex != -1) {
          // Update existing item quantity
          final existingItem = updatedItems[existingIndex];
          updatedItems[existingIndex] = existingItem.copyWith(
            quantity: existingItem.quantity + item.quantity,
            updatedAt: DateTime.now(),
          );
        } else {
          // Add new item
          updatedItems.add(item);
        }

        // Recalculate summary
        final cartSummary = CartSummaryModel.calculateFromItems(updatedItems);

        // Preserve existing coupon if any
        final preservedSummary = cart.summary.appliedCouponCode != null
            ? await _recalculateWithCoupon(cartSummary, cart.summary.appliedCouponCode!)
            : cartSummary;

        updatedCart = cart.copyWith(
          items: updatedItems,
          summary: preservedSummary,
          updatedAt: DateTime.now(),
          hasPendingChanges: true,
        );
      }

      await saveCart(updatedCart);

      _logger.logUserAction('cart_item_added', {
        'product_id': item.productId,
        'quantity': item.quantity,
        'price': item.price,
        'variants': item.selectedVariants,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:27:12',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.addCartItem',
        e,
        stackTrace,
        {
          'product_id': item.productId,
          'user': 'roshdology123',
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    try {
      final cart = await getCart();
      if (cart == null) return;

      final updatedItems = cart.items.map((i) => i.id == item.id ? item : i).toList();

      // Recalculate summary
      final cartSummary = CartSummaryModel.calculateFromItems(updatedItems);

      // Preserve existing coupon if any
      final preservedSummary = cart.summary.appliedCouponCode != null
          ? await _recalculateWithCoupon(cartSummary, cart.summary.appliedCouponCode!)
          : cartSummary;

      final updatedCart = cart.copyWith(
        items: updatedItems,
        summary: preservedSummary,
        updatedAt: DateTime.now(),
        hasPendingChanges: true,
      );

      await saveCart(updatedCart);

      _logger.logUserAction('cart_item_updated', {
        'item_id': item.id,
        'product_id': item.productId,
        'new_quantity': item.quantity,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:27:12',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.updateCartItem',
        e,
        stackTrace,
        {
          'item_id': item.id,
          'user': 'roshdology123',
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> removeCartItem(String itemId) async {
    try {
      final cart = await getCart();
      if (cart == null) return;

      final updatedItems = cart.items.where((i) => i.id != itemId).toList();

      // Recalculate summary
      final cartSummary = CartSummaryModel.calculateFromItems(updatedItems);

      // Preserve existing coupon if any and cart is not empty
      final preservedSummary = updatedItems.isNotEmpty && cart.summary.appliedCouponCode != null
          ? await _recalculateWithCoupon(cartSummary, cart.summary.appliedCouponCode!)
          : cartSummary;

      final updatedCart = cart.copyWith(
        items: updatedItems,
        summary: preservedSummary,
        updatedAt: DateTime.now(),
        hasPendingChanges: true,
      );

      await saveCart(updatedCart);

      _logger.logUserAction('cart_item_removed', {
        'item_id': itemId,
        'remaining_items': updatedItems.length,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:27:12',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.removeCartItem',
        e,
        stackTrace,
        {
          'item_id': itemId,
          'user': 'roshdology123',
        },
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await Future.wait([
        LocalStorage.removeFromCache(_cartKey),
        LocalStorage.removeFromCache(_cartItemsKey),
      ]);

      _logger.logUserAction('cart_cleared', {
        'timestamp': '2025-06-22 13:27:12',
        'user': 'roshdology123',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.clearCart',
        e,
        stackTrace,
        {'user': 'roshdology123'},
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<int> getCartItemsCount() async {
    try {
      final cart = await getCart();
      final count = cart?.summary.totalQuantity ?? 0;

      _logger.logCacheOperation('get_cart_count', _cartKey, true, 'Count: $count');
      return count;
    } catch (e) {
      _logger.w('Failed to get cart items count: $e');
      return 0;
    }
  }

  @override
  Future<double> getCartTotal() async {
    try {
      final cart = await getCart();
      final total = cart?.summary.total ?? 0.0;

      _logger.logCacheOperation('get_cart_total', _cartKey, true, 'Total: \$$total');
      return total;
    } catch (e) {
      _logger.w('Failed to get cart total: $e');
      return 0.0;
    }
  }

  @override
  Future<bool> isItemInCart(String itemId) async {
    try {
      final cart = await getCart();
      final exists = cart?.items.any((item) => item.id == itemId) ?? false;

      _logger.logCacheOperation('check_item_in_cart', itemId, exists);
      return exists;
    } catch (e) {
      _logger.w('Failed to check if item in cart: $e');
      return false;
    }
  }

  @override
  Future<CartItemModel?> getCartItemByProduct(
      int productId,
      Map<String, String> variants,
      ) async {
    try {
      final cart = await getCart();
      if (cart == null) return null;

      for (final item in cart.items) {
        if (item.productId == productId) {
          // Check if variants match
          bool variantsMatch = true;
          for (final entry in variants.entries) {
            if (item.selectedVariants[entry.key] != entry.value) {
              variantsMatch = false;
              break;
            }
          }
          if (variantsMatch && item.selectedVariants.length == variants.length) {
            return item;
          }
        }
      }
      return null;
    } catch (e) {
      _logger.w('Failed to get cart item by product: $e');
      return null;
    }
  }

  @override
  Future<void> saveAbandonedCart(CartModel cart) async {
    try {
      final abandonedCart = cart.copyWith(
        status: 'abandoned',
        abandonedAt: DateTime.now(),
      );

      final existingAbandoned = await getAbandonedCarts();
      final updatedAbandoned = [...existingAbandoned, abandonedCart];

      await LocalStorage.saveToCache(
        _abandonedCartsKey,
        {'carts': updatedAbandoned.map((c) => c.toJson()).toList()},
        expiry: AppConstants.cacheDurationLong,
      );

      _logger.logUserAction('cart_abandoned', {
        'cart_id': cart.id,
        'items_count': cart.items.length,
        'total': cart.summary.total,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:27:12',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.saveAbandonedCart',
        e,
        stackTrace,
        {'cart_id': cart.id, 'user': 'roshdology123'},
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<CartModel>> getAbandonedCarts() async {
    try {
      final data = LocalStorage.getFromCache(_abandonedCartsKey);
      if (data == null || data['carts'] == null) return [];

      final cartsJson = data['carts'] as List<dynamic>;
      return cartsJson
          .map((json) => CartModel.fromJson(_ensureStringKeyMap(json)))
          .toList();
    } catch (e) {
      _logger.w('Failed to get abandoned carts: $e');
      return [];
    }
  }

  @override
  Future<void> clearAbandonedCarts() async {
    try {
      await LocalStorage.removeFromCache(_abandonedCartsKey);
      _logger.logUserAction('abandoned_carts_cleared', {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:27:12',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.clearAbandonedCarts',
        e,
        stackTrace,
        {'user': 'roshdology123'},
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<DateTime?> getLastSyncTimestamp() async {
    try {
      final data = LocalStorage.getFromCache(_lastSyncKey);
      if (data == null || data['timestamp'] == null) return null;

      return DateTime.parse(data['timestamp']);
    } catch (e) {
      _logger.w('Failed to get last sync timestamp: $e');
      return null;
    }
  }

  @override
  Future<void> saveLastSyncTimestamp(DateTime timestamp) async {
    try {
      await LocalStorage.saveToCache(
        _lastSyncKey,
        {'timestamp': timestamp.toIso8601String()},
        expiry: AppConstants.cacheDurationLong,
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.saveLastSyncTimestamp',
        e,
        stackTrace,
        {'timestamp': timestamp.toIso8601String(), 'user': 'roshdology123'},
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingChanges() async {
    try {
      final data = LocalStorage.getFromCache(_pendingChangesKey);
      if (data == null || data['changes'] == null) return [];

      final changes = data['changes'] as List<dynamic>;
      return changes.map((change) => _ensureStringKeyMap(change)).toList();
    } catch (e) {
      _logger.w('Failed to get pending changes: $e');
      return [];
    }
  }

  @override
  Future<void> savePendingChange(Map<String, dynamic> change) async {
    try {
      final existingChanges = await getPendingChanges();
      final updatedChanges = [...existingChanges, change];

      await LocalStorage.saveToCache(
        _pendingChangesKey,
        {'changes': updatedChanges},
        expiry: AppConstants.cacheDurationLong,
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.savePendingChange',
        e,
        stackTrace,
        {'change': change, 'user': 'roshdology123'},
      );
      throw CacheException.writeError();
    }
  }

  @override
  Future<void> clearPendingChanges() async {
    try {
      await LocalStorage.removeFromCache(_pendingChangesKey);
      _logger.logUserAction('cart_pending_changes_cleared', {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 13:27:12',
      });
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartLocalDataSource.clearPendingChanges',
        e,
        stackTrace,
        {'user': 'roshdology123'},
      );
      throw CacheException.writeError();
    }
  }

  // 🔥 SIMULATED COUPON VALIDATION for roshdology123
  @override
  Future<Map<String, dynamic>> validateCoupon(String couponCode) async {
    final startTime = DateTime.now();

    _logger.logUserAction('validate_coupon_started', {
      'coupon_code': couponCode,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 13:27:12',
    });

    // Simulate network delay for realistic experience
    await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 200));

    final couponData = _mockCoupons[couponCode.toUpperCase()];

    if (couponData == null) {
      _logger.logBusinessLogic(
        'coupon_validation_failed',
        'not_found',
        {
          'coupon_code': couponCode,
          'error': 'Coupon not found',
          'user': 'roshdology123',
        },
      );
      throw ApiException.notFound('Invalid coupon code. Please check and try again.');
    }

    // Check if coupon is active
    if (!couponData['is_active']) {
      _logger.logBusinessLogic(
        'coupon_validation_failed',
        'inactive',
        {
          'coupon_code': couponCode,
          'error': 'Coupon is inactive',
          'user': 'roshdology123',
        },
      );
      throw BusinessException(
        message: 'This coupon is no longer active.',
        code: 'COUPON_INACTIVE',
      );
    }

    // Check if coupon has expired
    final expiryDate = DateTime.parse(couponData['expires_at']);
    if (expiryDate.isBefore(DateTime.now())) {
      _logger.logBusinessLogic(
        'coupon_validation_failed',
        'expired',
        {
          'coupon_code': couponCode,
          'expiry_date': couponData['expires_at'],
          'user': 'roshdology123',
        },
      );
      throw BusinessException(
        message: 'This coupon has expired.',
        code: 'COUPON_EXPIRED',
      );
    }

    // Check usage limit
    final usageLimit = couponData['usage_limit'] as int;
    final usedCount = couponData['used_count'] as int;
    if (usedCount >= usageLimit) {
      _logger.logBusinessLogic(
        'coupon_validation_failed',
        'usage_limit_exceeded',
        {
          'coupon_code': couponCode,
          'usage_limit': usageLimit,
          'used_count': usedCount,
          'user': 'roshdology123',
        },
      );
      throw BusinessException(
        message: 'This coupon has reached its usage limit.',
        code: 'COUPON_USAGE_LIMIT_EXCEEDED',
      );
    }

    final duration = DateTime.now().difference(startTime);

    _logger.logBusinessLogic(
      'coupon_validation_success',
      'valid',
      {
        'coupon_code': couponCode,
        'coupon_type': couponData['type'],
        'discount_value': couponData['discount_value'],
        'minimum_amount': couponData['minimum_amount'],
        'duration_ms': duration.inMilliseconds,
        'user': 'roshdology123',
      },
    );

    return Map<String, dynamic>.from(couponData);
  }

  // 🔥 APPLY COUPON TO CART with CartSummaryModel integration
  @override
  Future<CartModel> applyCouponToCart(CartModel cart, String couponCode) async {
    _logger.logUserAction('apply_coupon_to_cart_started', {
      'coupon_code': couponCode,
      'current_subtotal': cart.summary.subtotal,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 13:27:12',
    });

    // Validate the coupon first
    final couponData = await validateCoupon(couponCode);

    // Check minimum amount requirement
    final minimumAmount = couponData['minimum_amount'] as double;
    if (cart.summary.subtotal < minimumAmount) {
      _logger.logBusinessLogic(
        'coupon_application_failed',
        'minimum_amount_not_met',
        {
          'coupon_code': couponCode,
          'required_amount': minimumAmount,
          'current_amount': cart.summary.subtotal,
          'user': 'roshdology123',
        },
      );
      throw ValidationException(
        message: 'Minimum order amount of \$${minimumAmount.toStringAsFixed(2)} required for this coupon.',
        code: 'MINIMUM_AMOUNT_NOT_MET',
      );
    }

    // Calculate coupon discount
    final updatedSummary = await _calculateCouponDiscount(cart.summary, couponData);

    final updatedCart = cart.copyWith(
      summary: updatedSummary,
      updatedAt: DateTime.now(),
      hasPendingChanges: true,
    );

    // Save the updated cart
    await saveCart(updatedCart);

    _logger.logBusinessLogic(
      'coupon_application_success',
      'applied',
      {
        'coupon_code': couponCode,
        'discount_amount': updatedSummary.couponDiscount,
        'free_shipping': updatedSummary.isFreeShipping,
        'new_total': updatedSummary.total,
        'savings': updatedSummary.couponDiscount,
        'user': 'roshdology123',
      },
    );

    return updatedCart;
  }

  // 🔥 REMOVE COUPON FROM CART with CartSummaryModel integration
  @override
  Future<CartModel> removeCouponFromCart(CartModel cart, String couponCode) async {
    _logger.logUserAction('remove_coupon_from_cart_started', {
      'coupon_code': couponCode,
      'current_discount': cart.summary.couponDiscount,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 13:27:12',
    });

    if (cart.summary.appliedCouponCode != couponCode) {
      throw ValidationException(
        message: 'Coupon not found in cart.',
        code: 'COUPON_NOT_APPLIED',
      );
    }

    // Recalculate summary without coupon
    final baseSummary = CartSummaryModel.calculateFromItems(cart.items);

    final updatedCart = cart.copyWith(
      summary: baseSummary,
      updatedAt: DateTime.now(),
      hasPendingChanges: true,
    );

    // Save the updated cart
    await saveCart(updatedCart);

    _logger.logBusinessLogic(
      'coupon_removal_success',
      'removed',
      {
        'coupon_code': couponCode,
        'removed_discount': cart.summary.couponDiscount,
        'new_total': baseSummary.total,
        'user': 'roshdology123',
      },
    );

    return updatedCart;
  }

  // 🔥 GET AVAILABLE COUPONS for roshdology123
  @override
  Future<List<Map<String, dynamic>>> getAvailableCoupons() async {
    _logger.logUserAction('get_available_coupons', {
      'user': 'roshdology123',
      'timestamp': '2025-06-22 13:27:12',
    });

    // Filter out expired and inactive coupons
    final availableCoupons = _mockCoupons.values.where((coupon) {
      final isActive = coupon['is_active'] as bool;
      final expiryDate = DateTime.parse(coupon['expires_at']);
      final isNotExpired = expiryDate.isAfter(DateTime.now());
      final usageLimit = coupon['usage_limit'] as int;
      final usedCount = coupon['used_count'] as int;
      final hasUsageLeft = usedCount < usageLimit;

      return isActive && isNotExpired && hasUsageLeft;
    }).toList();

    _logger.logBusinessLogic(
      'available_coupons_retrieved',
      'success',
      {
        'total_coupons': _mockCoupons.length,
        'available_coupons': availableCoupons.length,
        'user': 'roshdology123',
      },
    );

    return availableCoupons.map((c) => Map<String, dynamic>.from(c)).toList();
  }

  // 🔥 HELPER: Calculate coupon discount and update summary
  Future<CartSummaryModel> _calculateCouponDiscount(
      CartSummaryModel currentSummary,
      Map<String, dynamic> couponData,
      ) async {
    double discountAmount = 0.0;
    bool freeShipping = false;
    double? newShippingCost = currentSummary.shippingCost;

    switch (couponData['type']) {
      case 'percentage':
        discountAmount = currentSummary.subtotal * (couponData['discount_value'] / 100);
        final maxDiscount = couponData['maximum_discount'] as double?;
        if (maxDiscount != null && discountAmount > maxDiscount) {
          discountAmount = maxDiscount;
        }
        break;

      case 'fixed_amount':
        discountAmount = couponData['discount_value'] as double;
        if (discountAmount > currentSummary.subtotal) {
          discountAmount = currentSummary.subtotal; // Can't discount more than subtotal
        }
        break;

      case 'free_shipping':
        freeShipping = true;
        newShippingCost = 0.0;
        discountAmount = currentSummary.shippingCost;
        break;
    }

    final newTotal = currentSummary.subtotal - discountAmount +
        (newShippingCost) + currentSummary.totalTax;

    return currentSummary.copyWith(
      couponDiscount: discountAmount,
      appliedCouponCode: couponData['code'] as String,
      couponDescription: couponData['description'] as String,
      isFreeShipping: freeShipping,
      shippingCost: newShippingCost,
      total: newTotal,
      lastCalculated: DateTime.now(),
    );
  }

  // 🔥 HELPER: Recalculate summary with existing coupon
  Future<CartSummaryModel> _recalculateWithCoupon(
      CartSummaryModel baseSummary,
      String couponCode,
      ) async {
    try {
      final couponData = await validateCoupon(couponCode);
      return await _calculateCouponDiscount(baseSummary, couponData);
    } catch (e) {
      // If coupon is no longer valid, return base summary
      _logger.w('Coupon $couponCode no longer valid during recalculation: $e');
      return baseSummary;
    }
  }
}