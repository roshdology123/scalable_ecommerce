import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

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
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartKey = 'current_cart';
  static const String _cartItemsKey = 'cart_items';
  static const String _abandonedCartsKey = 'abandoned_carts';
  static const String _lastSyncKey = 'cart_last_sync';
  static const String _pendingChangesKey = 'cart_pending_changes';

  final AppLogger _logger = AppLogger();

  @override
  Future<CartModel?> getCart() async {
    try {
      final cartData = LocalStorage.getFromCache(_cartKey);
      if (cartData == null) return null;

      _logger.logCacheOperation('get_cart', _cartKey, true);
      return CartModel.fromJson(cartData);
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
        'user_id': cart.userId ?? 'guest',
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
      if (cart == null) {
        // Create new cart with this item
        final newCart = CartModel.empty().copyWith(
          items: [item],
          updatedAt: DateTime.now(),
        );
        await saveCart(newCart);
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

        final updatedCart = cart.copyWith(
          items: updatedItems,
          updatedAt: DateTime.now(),
          hasPendingChanges: true,
        );
        await saveCart(updatedCart);
      }

      _logger.logUserAction('cart_item_added', {
        'product_id': item.productId,
        'quantity': item.quantity,
        'price': item.price,
        'variants': item.selectedVariants,
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
      final updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
        hasPendingChanges: true,
      );

      await saveCart(updatedCart);

      _logger.logUserAction('cart_item_updated', {
        'item_id': item.id,
        'product_id': item.productId,
        'new_quantity': item.quantity,
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
      final updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
        hasPendingChanges: true,
      );

      await saveCart(updatedCart);

      _logger.logUserAction('cart_item_removed', {
        'item_id': itemId,
        'remaining_items': updatedItems.length,
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
        'timestamp': DateTime.now().toIso8601String(),
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
          .map((json) => CartModel.fromJson(json as Map<String, dynamic>))
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
      _logger.logUserAction('abandoned_carts_cleared');
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

      return List<Map<String, dynamic>>.from(data['changes']);
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
      _logger.logUserAction('cart_pending_changes_cleared');
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
}