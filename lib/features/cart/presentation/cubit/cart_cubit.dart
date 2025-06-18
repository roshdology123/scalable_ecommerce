import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/apply_coupon_usecase.dart';
import '../../domain/usecases/calculate_cart_totals_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_coupon_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/sync_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final ApplyCouponUseCase _applyCouponUseCase;
  final RemoveCouponUseCase _removeCouponUseCase;
  final CalculateCartTotalsUseCase _calculateCartTotalsUseCase;
  final SyncCartUseCase _syncCartUseCase;

  final AppLogger _logger = AppLogger();

  String? _currentUserId;
  bool _autoSync = true;

  CartCubit(
      this._getCartUseCase,
      this._addToCartUseCase,
      this._removeFromCartUseCase,
      this._updateCartItemUseCase,
      this._clearCartUseCase,
      this._applyCouponUseCase,
      this._removeCouponUseCase,
      this._calculateCartTotalsUseCase,
      this._syncCartUseCase,
      ) : super(const CartState.initial()) {
    _logger.logBusinessLogic(
      'cart_cubit_initialized',
      'success',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:04:11',
        'auto_sync': _autoSync,
      },
    );
  }

  /// Initialize cart for user (or guest)
  Future<void> initializeCart([String? userId]) async {
    _currentUserId = userId;

    _logger.logUserAction('cart_initialize_started', {
      'user_id': userId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    emit(const CartState.loading());

    final result = await _getCartUseCase(GetCartParams(userId: userId));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'cart_initialize_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'user_id': userId ?? 'guest',
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          canRetry: true,
          failedAction: 'initialize',
        ));
      },
          (cart) {
        _logger.logUserAction('cart_initialize_success', {
          'cart_id': cart.id,
          'items_count': cart.items.length,
          'total': cart.summary.total,
          'is_guest': cart.isGuestCart,
          'user': 'roshdology123',
        });

        if (cart.isEmpty) {
          emit(const CartState.empty());
        } else {
          emit(CartState.loaded(cart: cart));

          // Auto-sync if user cart and needs sync
          if (_autoSync && cart.isUserCart && cart.needsSync) {
            _syncCartBackground();
          }
        }
      },
    );
  }

  /// Add product to cart
  Future<void> addToCart({
    required int productId,
    required String productTitle,
    required String productImage,
    required double price,
    required int quantity,
    String? selectedColor,
    String? selectedSize,
    Map<String, String>? additionalVariants,
    int? maxQuantity,
    String? brand,
    String? category,
    String? sku,
    double? originalPrice,
    double? discountPercentage,
  }) async {
    final startTime = DateTime.now();

    _logger.logUserAction('add_to_cart_started', {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    // Optimistic update
    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        emit(CartState.loaded(
          cart: cart,
          isUpdating: true,
          pendingAction: 'add_item',
        ));
      },
      empty: (_, __) {
        emit(const CartState.empty(isLoading: true));
      },
    );

    final result = await _addToCartUseCase(AddToCartParams(
      productId: productId,
      productTitle: productTitle,
      productImage: productImage,
      price: price,
      quantity: quantity,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      additionalVariants: additionalVariants,
      userId: _currentUserId,
      maxQuantity: maxQuantity,
      brand: brand,
      category: category,
      sku: sku,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
    ));

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'add_to_cart_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'product_id': productId,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'add_to_cart',
          actionContext: {
            'product_id': productId,
            'quantity': quantity,
            'price': price,
          },
        ));
      },
          (cart) {
        _logger.logUserAction('add_to_cart_success', {
          'product_id': productId,
          'cart_items': cart.items.length,
          'cart_total': cart.summary.total,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        });

        emit(CartState.loaded(cart: cart));

        // Show success feedback
        _showSuccessMessage('Item added to cart');
      },
    );
  }

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    final startTime = DateTime.now();

    _logger.logUserAction('remove_from_cart_started', {
      'item_id': itemId,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    // Optimistic update
    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        final itemsLoading = <String, bool>{itemId: true};
        emit(CartState.loaded(
          cart: cart,
          isUpdating: true,
          pendingAction: 'remove_item',
          itemsLoading: itemsLoading,
        ));
      },
    );

    final result = await _removeFromCartUseCase(
      RemoveFromCartParams(itemId: itemId, userId: _currentUserId),
    );

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'remove_from_cart_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'item_id': itemId,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'remove_from_cart',
          actionContext: {'item_id': itemId},
        ));
      },
          (cart) {
        _logger.logUserAction('remove_from_cart_success', {
          'item_id': itemId,
          'remaining_items': cart.items.length,
          'cart_total': cart.summary.total,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        });

        if (cart.isEmpty) {
          emit(const CartState.empty());
        } else {
          emit(CartState.loaded(cart: cart));
        }

        _showSuccessMessage('Item removed from cart');
      },
    );
  }

  /// Update cart item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    final startTime = DateTime.now();

    _logger.logUserAction('update_quantity_started', {
      'item_id': itemId,
      'new_quantity': newQuantity,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    // Optimistic update
    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        final itemsLoading = <String, bool>{itemId: true};
        emit(CartState.loaded(
          cart: cart,
          isUpdating: true,
          pendingAction: 'update_quantity',
          itemsLoading: itemsLoading,
        ));
      },
    );

    final result = await _updateCartItemUseCase(UpdateCartItemParams(
      itemId: itemId,
      quantity: newQuantity,
      userId: _currentUserId,
    ));

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'update_quantity_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'item_id': itemId,
            'new_quantity': newQuantity,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'update_quantity',
          actionContext: {
            'item_id': itemId,
            'new_quantity': newQuantity,
          },
        ));
      },
          (cart) {
        _logger.logUserAction('update_quantity_success', {
          'item_id': itemId,
          'new_quantity': newQuantity,
          'cart_total': cart.summary.total,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        });

        emit(CartState.loaded(cart: cart));
      },
    );
  }

  /// Update cart item variants (color, size)
  Future<void> updateVariants(
      String itemId, {
        String? selectedColor,
        String? selectedSize,
      }) async {
    _logger.logUserAction('update_variants_started', {
      'item_id': itemId,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    // Optimistic update
    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        final itemsLoading = <String, bool>{itemId: true};
        emit(CartState.loaded(
          cart: cart,
          isUpdating: true,
          pendingAction: 'update_variants',
          itemsLoading: itemsLoading,
        ));
      },
    );

    final result = await _updateCartItemUseCase(UpdateCartItemParams(
      itemId: itemId,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      userId: _currentUserId,
    ));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'update_variants_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'item_id': itemId,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'update_variants',
          actionContext: {
            'item_id': itemId,
            'selected_color': selectedColor,
            'selected_size': selectedSize,
          },
        ));
      },
          (cart) {
        _logger.logUserAction('update_variants_success', {
          'item_id': itemId,
          'selected_color': selectedColor,
          'selected_size': selectedSize,
          'user': 'roshdology123',
        });

        emit(CartState.loaded(cart: cart));
        _showSuccessMessage('Item updated');
      },
    );
  }

  /// Clear entire cart
  Future<void> clearCart({bool showConfirmation = true}) async {
    if (showConfirmation) {
      // In a real app, show confirmation dialog
      // For now, proceed directly
    }

    _logger.logUserAction('clear_cart_started', {
      'user_id': _currentUserId ?? 'guest',
      'current_items': state.cart?.items.length ?? 0,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        emit(CartState.loaded(
          cart: cart,
          isUpdating: true,
          pendingAction: 'clear_cart',
        ));
      },
    );

    final result = await _clearCartUseCase(
      ClearCartParams(userId: _currentUserId),
    );

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'clear_cart_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'clear_cart',
        ));
      },
          (_) {
        _logger.logUserAction('clear_cart_success', {
          'user_id': _currentUserId ?? 'guest',
          'user': 'roshdology123',
        });

        emit(const CartState.empty());
        _showSuccessMessage('Cart cleared');
      },
    );
  }

  /// Apply coupon code
  Future<void> applyCoupon(String couponCode) async {
    final startTime = DateTime.now();

    _logger.logUserAction('apply_coupon_started', {
      'coupon_code': couponCode,
      'user_id': _currentUserId,
      'cart_total': state.cart?.summary.total,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        emit(CartState.loaded(
          cart: cart,
          isUpdating: true,
          pendingAction: 'apply_coupon',
        ));
      },
    );

    final result = await _applyCouponUseCase(ApplyCouponParams(
      couponCode: couponCode,
      userId: _currentUserId,
    ));

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'apply_coupon_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'coupon_code': couponCode,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'apply_coupon',
          actionContext: {'coupon_code': couponCode},
        ));
      },
          (cart) {
        _logger.logUserAction('apply_coupon_success', {
          'coupon_code': couponCode,
          'discount_amount': cart.summary.couponDiscount,
          'new_total': cart.summary.total,
          'savings': cart.summary.totalSavings,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        });

        emit(CartState.loaded(cart: cart));

        final discountAmount = cart.summary.couponDiscount ?? 0.0;
        _showSuccessMessage(
          'Coupon applied! You saved \$${discountAmount.toStringAsFixed(2)}',
        );
      },
    );
  }

  /// Remove coupon code
  Future<void> removeCoupon(String couponCode) async {
    _logger.logUserAction('remove_coupon_started', {
      'coupon_code': couponCode,
      'user_id': _currentUserId,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        emit(CartState.loaded(
          cart: cart,
          isUpdating: true,
          pendingAction: 'remove_coupon',
        ));
      },
    );

    final result = await _removeCouponUseCase(RemoveCouponParams(
      couponCode: couponCode,
      userId: _currentUserId,
    ));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'remove_coupon_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'coupon_code': couponCode,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'remove_coupon',
          actionContext: {'coupon_code': couponCode},
        ));
      },
          (cart) {
        _logger.logUserAction('remove_coupon_success', {
          'coupon_code': couponCode,
          'new_total': cart.summary.total,
          'user': 'roshdology123',
        });

        emit(CartState.loaded(cart: cart));
        _showSuccessMessage('Coupon removed');
      },
    );
  }

  /// Refresh cart data
  Future<void> refresh() async {
    _logger.logUserAction('cart_refresh_started', {
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        emit(CartState.loaded(
          cart: cart,
          isRefreshing: true,
        ));
      },
      empty: (_, __) {
        emit(const CartState.empty(isLoading: true));
      },
      error: (_, cart, __, ___, ____) {
        if (cart != null) {
          emit(CartState.loaded(
            cart: cart,
            isRefreshing: true,
          ));
        } else {
          emit(const CartState.loading());
        }
      },
    );

    await initializeCart(_currentUserId);
  }

  /// Sync cart with server (for authenticated users)
  Future<void> syncCart() async {
    if (_currentUserId == null) {
      _logger.w('Cannot sync cart for guest user');
      return;
    }

    _logger.logBusinessLogic(
      'sync_cart_started',
      'manual_sync',
      {
        'user_id': _currentUserId,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:04:11',
      },
    );

    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        emit(CartState.syncing(
          cart: cart,
          message: 'Syncing cart...',
          progress: 0.0,
        ));
      },
    );

    final result = await _syncCartUseCase(SyncCartParams(userId: _currentUserId!));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'sync_cart_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'user_id': _currentUserId,
            'user': 'roshdology123',
          },
        );

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: true,
          failedAction: 'sync_cart',
        ));
      },
          (cart) {
        _logger.logBusinessLogic(
          'sync_cart_success',
          'completed',
          {
            'cart_id': cart.id,
            'items_count': cart.items.length,
            'is_synced': cart.isSynced,
            'has_conflicts': cart.hasConflicts,
            'user': 'roshdology123',
          },
        );

        if (cart.hasConflicts) {
          // Handle conflicts - for now, use local cart
          emit(CartState.loaded(cart: cart));
          _showSuccessMessage('Cart synced with conflicts');
        } else {
          emit(CartState.loaded(cart: cart));
          _showSuccessMessage('Cart synced successfully');
        }
      },
    );
  }

  /// Background sync (no UI feedback)
  Future<void> _syncCartBackground() async {
    if (_currentUserId == null) return;

    try {
      final result = await _syncCartUseCase(SyncCartParams(userId: _currentUserId!));
      result.fold(
            (failure) => _logger.w('Background sync failed: ${failure.message}'),
            (cart) {
          _logger.d('Background sync successful');

          // Update state only if current state is loaded
          state.whenOrNull(
            loaded: (_, __, ___, ____, _____, ______, _______) {
              emit(CartState.loaded(cart: cart));
            },
          );
        },
      );
    } catch (e) {
      _logger.w('Background sync exception: $e');
    }
  }

  /// Retry failed action
  Future<void> retryFailedAction() async {
    state.whenOrNull(
      error: (failure, cart, canRetry, failedAction, actionContext) {
        if (!canRetry || failedAction == null) return;

        _logger.logUserAction('retry_failed_action', {
          'failed_action': failedAction,
          'error_code': failure.code,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:04:11',
        });

        switch (failedAction) {
          case 'initialize':
            initializeCart(_currentUserId);
            break;
          case 'add_to_cart':
            if (actionContext != null) {
              // Would need to reconstruct add to cart params
              // For now, just refresh
              refresh();
            }
            break;
          case 'remove_from_cart':
            if (actionContext?['item_id'] != null) {
              removeFromCart(actionContext!['item_id']);
            }
            break;
          case 'update_quantity':
            if (actionContext?['item_id'] != null &&
                actionContext?['new_quantity'] != null) {
              updateQuantity(
                actionContext!['item_id'],
                actionContext['new_quantity'],
              );
            }
            break;
          case 'clear_cart':
            clearCart(showConfirmation: false);
            break;
          case 'apply_coupon':
            if (actionContext?['coupon_code'] != null) {
              applyCoupon(actionContext!['coupon_code']);
            }
            break;
          case 'sync_cart':
            syncCart();
            break;
          default:
            refresh();
            break;
        }
      },
    );
  }

  /// Set auto-sync preference
  void setAutoSync(bool enabled) {
    _autoSync = enabled;

    _logger.logUserAction('cart_auto_sync_changed', {
      'enabled': enabled,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });
  }

  /// Update current user (when login/logout occurs)
  void updateUser(String? userId) {
    final previousUserId = _currentUserId;
    _currentUserId = userId;

    _logger.logUserAction('cart_user_changed', {
      'previous_user_id': previousUserId,
      'new_user_id': userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    // Reinitialize cart for new user
    initializeCart(userId);
  }

  /// Show success message (to be implemented with actual UI feedback)
  void _showSuccessMessage(String message) {
    _logger.logUserAction('cart_success_message', {
      'message': message,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:04:11',
    });

    // In a real app, this would trigger a snackbar or toast
    // For now, just log the message
  }

  /// Get current cart without triggering state changes
  Cart? get currentCart => state.cart;

  /// Check if item is in cart
  bool isItemInCart(int productId, Map<String, String> variants) {
    final cart = state.cart;
    if (cart == null) return false;

    return cart.containsProduct(productId, variants);
  }

  /// Get cart item by product and variants
  CartItem? getCartItem(int productId, Map<String, String> variants) {
    final cart = state.cart;
    if (cart == null) return null;

    return cart.findItemByProductAndVariants(productId, variants);
  }

  @override
  Future<void> close() {
    _logger.logBusinessLogic(
      'cart_cubit_closed',
      'cleanup',
      {
        'user_id': _currentUserId,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:04:11',
      },
    );

    return super.close();
  }
}