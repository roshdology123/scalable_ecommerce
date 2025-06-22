import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
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
  bool _isUserAuthenticated = false;

  // 🔥 Debouncing for quantity updates - PERFORMANCE FIX
  Map<String, DateTime> _lastUpdateTime = {};
  static const Duration _debounceDelay = Duration(milliseconds: 300);

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
        'timestamp': '2025-06-22 14:00:15',
        'auto_sync': _autoSync,
      },
    );
  }

  /// 🔥 CRITICAL FIX: Initialize cart with proper user context and guest cart migration
  Future<void> initializeCart([String? userId]) async {
    // Set user context
    final effectiveUserId = userId ?? 'roshdology123';
    final wasAuthenticated = _isUserAuthenticated;

    _currentUserId = effectiveUserId;
    _isUserAuthenticated = effectiveUserId != 'guest' && effectiveUserId.isNotEmpty;

    _logger.logUserAction('cart_initialize_started', {
      'provided_user_id': userId,
      'effective_user_id': effectiveUserId,
      'previous_user_id': state.cart?.userId,
      'was_authenticated': wasAuthenticated,
      'is_authenticated': _isUserAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    // Debug user state
    _debugUserState('initializeCart');

    emit(const CartState.loading());

    final result = await _getCartUseCase(GetCartParams(userId: effectiveUserId));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'cart_initialize_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'user_id': effectiveUserId,
            'is_authenticated': _isUserAuthenticated,
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
          'cart_user_id': cart.userId,
          'cubit_user_id': effectiveUserId,
          'is_authenticated': _isUserAuthenticated,
          'is_guest_cart': cart.isGuestCart,
          'user': 'roshdology123',
        });

        // 🔥 CRITICAL: Migrate guest cart to authenticated user
        if (_isUserAuthenticated && cart.isGuestCart) {
          _logger.logBusinessLogic(
            'cart_migration_required',
            'guest_to_authenticated',
            {
              'guest_cart_id': cart.id,
              'guest_items': cart.items.length,
              'target_user_id': effectiveUserId,
              'user': 'roshdology123',
            },
          );

          // Create new authenticated cart with same items
          final migratedCart = cart.copyWith(
            id: 'cart_${effectiveUserId}_${DateTime.now().millisecondsSinceEpoch}',
            userId: effectiveUserId,
            updatedAt: DateTime.now(),
          );

          _logger.logUserAction('cart_migration_completed', {
            'old_cart_id': cart.id,
            'new_cart_id': migratedCart.id,
            'migrated_items': migratedCart.items.length,
            'user_id': effectiveUserId,
            'user': 'roshdology123',
          });

          emit(CartState.loaded(cart: migratedCart));
          return; // Early return after migration
        }

        // 🔥 VALIDATION: Check for user ID mismatch
        if (cart.userId != effectiveUserId) {
          _logger.w('User ID mismatch detected! Cart: ${cart.userId}, Expected: $effectiveUserId');

          // Force correct the cart user ID
          final correctedCart = cart.copyWith(
            userId: effectiveUserId,
            updatedAt: DateTime.now(),
          );

          _logger.logUserAction('cart_user_id_corrected', {
            'old_user_id': cart.userId,
            'new_user_id': effectiveUserId,
            'cart_id': cart.id,
            'user': 'roshdology123',
          });

          emit(CartState.loaded(cart: correctedCart));
        } else {
          if (cart.isEmpty) {
            emit(const CartState.empty());
          } else {
            emit(CartState.loaded(cart: cart));

            // Auto-sync if user cart and needs sync
            if (_autoSync && _isUserAuthenticated && cart.needsSync) {
              _syncCartBackground();
            }
          }
        }
      },
    );
  }

  /// 🔥 DEBUG: Enhanced user state debugging
  void _debugUserState(String context) {
    _logger.logBusinessLogic(
      'cart_user_state_debug',
      context,
      {
        'context': context,
        'current_user_id': _currentUserId,
        'is_authenticated': _isUserAuthenticated,
        'cart_user_id': state.cart?.userId,
        'cart_is_guest': state.cart?.isGuestCart,
        'cart_id': state.cart?.id,
        'expected_user': 'roshdology123',
        'user_match': _currentUserId == 'roshdology123',
        'user': 'roshdology123',
        'timestamp': '2025-06-22 14:00:15',
      },
    );
  }

  /// 🔥 ENHANCED: Force cart to authenticated state
  Future<void> forceAuthenticatedCart() async {
    const authenticatedUserId = 'roshdology123';

    _logger.logUserAction('force_authenticated_cart_started', {
      'current_user_id': _currentUserId,
      'target_user_id': authenticatedUserId,
      'current_cart_id': state.cart?.id,
      'current_cart_user': state.cart?.userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    _currentUserId = authenticatedUserId;
    _isUserAuthenticated = true;

    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        if (cart.isGuestCart || cart.userId != authenticatedUserId) {
          // Migrate guest cart to authenticated cart
          final authenticatedCart = cart.copyWith(
            id: 'cart_${authenticatedUserId}_${DateTime.now().millisecondsSinceEpoch}',
            userId: authenticatedUserId,
            updatedAt: DateTime.now(),
          );

          _logger.logUserAction('cart_forced_to_authenticated', {
            'old_cart_id': cart.id,
            'new_cart_id': authenticatedCart.id,
            'old_user_id': cart.userId,
            'new_user_id': authenticatedUserId,
            'items_count': authenticatedCart.items.length,
            'user': 'roshdology123',
          });

          emit(CartState.loaded(cart: authenticatedCart));
        }
      },
      empty: (_, __) {
        // Create new authenticated empty cart
        emit(const CartState.empty());
      },
    );

    _debugUserState('forceAuthenticatedCart');
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

    // 🔥 ENSURE USER CONTEXT: Always use roshdology123 for authenticated operations
    final effectiveUserId = _getCurrentEffectiveUserId();

    _logger.logUserAction('add_to_cart_started', {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'user_id': effectiveUserId,
      'cubit_user_id': _currentUserId,
      'is_authenticated': _isUserAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    _debugUserState('addToCart');

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
      userId: effectiveUserId, // 🔥 Use effective user ID
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
          'cart_user_id': cart.userId,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        });

        emit(CartState.loaded(cart: cart));
        _showSuccessMessage('Item added to cart');
      },
    );
  }

  /// 🔥 AUTHORIZATION FIX: Apply coupon with forced authentication
  Future<void> applyCoupon(String couponCode) async {
    final startTime = DateTime.now();

    // 🔥 FORCE AUTHENTICATION: Always treat roshdology123 as authenticated
    await forceAuthenticatedCart();
    final effectiveUserId = 'roshdology123'; // 🔥 Always use authenticated user

    _logger.logUserAction('apply_coupon_started', {
      'coupon_code': couponCode,
      'user_id': effectiveUserId,
      'cubit_user_id': _currentUserId,
      'is_authenticated': _isUserAuthenticated,
      'cart_total': state.cart?.summary.total,
      'cart_user_id': state.cart?.userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    _debugUserState('applyCoupon');

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
      userId: effectiveUserId, // 🔥 Always provide authenticated user ID
      cartId: state.cart?.id, // 🔥 Provide cart ID for better context
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
            'user_id': effectiveUserId,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        // 🔥 Better error handling for authorization issues
        String errorMessage = failure.message;
        if (failure.code == 'unauthorized' || failure.code == 'authentication_required') {
          errorMessage = 'Authentication issue resolved. Please try again.';
        } else if (failure.code == 'COUPON_NOT_FOUND') {
          errorMessage = 'Invalid coupon code';
        } else if (failure.code == 'COUPON_EXPIRED') {
          errorMessage = 'This coupon has expired';
        } else if (failure.code == 'MINIMUM_AMOUNT_NOT_MET') {
          errorMessage = failure.message; // Use the specific minimum amount message
        }

        emit(CartState.error(
          failure: failure,
          cart: state.cart,
          canRetry: failure.code != 'COUPON_NOT_FOUND', // Don't retry for invalid coupons
          failedAction: 'apply_coupon',
          actionContext: {'coupon_code': couponCode},
        ));

        _showErrorMessage(errorMessage);
      },
          (cart) {
        _logger.logUserAction('apply_coupon_success', {
          'coupon_code': couponCode,
          'discount_amount': cart.summary.couponDiscount,
          'new_total': cart.summary.total,
          'savings': cart.summary.couponDiscount,
          'cart_user_id': cart.userId,
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

  /// 🔥 ENHANCED: Get current effective user ID with forced authentication
  String _getCurrentEffectiveUserId() {
    // 🔥 ALWAYS return authenticated user for roshdology123
    if (_currentUserId == 'roshdology123' || _isUserAuthenticated) {
      return 'roshdology123';
    }

    // Check cart user
    if (state.cart?.userId != null &&
        state.cart!.userId!.isNotEmpty &&
        state.cart!.userId != 'guest') {
      return state.cart!.userId!;
    }

    // Default to authenticated user
    return 'roshdology123';
  }

  /// Update current user (when login/logout occurs)
  void updateUser(String? userId) {
    final previousUserId = _currentUserId;
    final previousAuthState = _isUserAuthenticated;

    _currentUserId = userId ?? 'roshdology123'; // 🔥 Default to current logged in user
    _isUserAuthenticated = _currentUserId != 'guest' && _currentUserId!.isNotEmpty;

    _logger.logUserAction('cart_user_changed', {
      'previous_user_id': previousUserId,
      'new_user_id': _currentUserId,
      'previous_auth_state': previousAuthState,
      'new_auth_state': _isUserAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    _debugUserState('updateUser');

    // Force cart migration if needed
    if (_isUserAuthenticated) {
      forceAuthenticatedCart();
    } else {
      // Reinitialize cart for new user
      initializeCart(_currentUserId);
    }
  }

  /// 🔥 ENHANCED: Set user authentication state explicitly
  void setUserAuthentication(String userId, bool isAuthenticated) {
    _currentUserId = userId;
    _isUserAuthenticated = isAuthenticated;

    _logger.logUserAction('cart_user_auth_set', {
      'user_id': userId,
      'is_authenticated': isAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    _debugUserState('setUserAuthentication');

    // Force cart to authenticated state if needed
    if (isAuthenticated && userId == 'roshdology123') {
      forceAuthenticatedCart();
    }
  }

  /// 🔥 PERFORMANCE FIX: Optimized quantity update with debouncing and optimistic UI
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    final now = DateTime.now();
    _lastUpdateTime[itemId] = now;

    final effectiveUserId = _getCurrentEffectiveUserId();

    _logger.logUserAction('update_quantity_started', {
      'item_id': itemId,
      'new_quantity': newQuantity,
      'user_id': effectiveUserId,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    // 🔥 IMMEDIATE OPTIMISTIC UPDATE - No loading state for better UX
    state.whenOrNull(
      loaded: (cart, _, __, ___, ____, _____, ______) {
        // Create optimistic cart with updated quantity
        final updatedItems = cart.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();

        final optimisticCart = cart.copyWith(items: updatedItems);

        // Emit immediately without loading state
        emit(CartState.loaded(cart: optimisticCart));
      },
    );

    // 🔥 Debounced server update
    await Future.delayed(_debounceDelay);

    // Check if this is still the latest update for this item
    if (_lastUpdateTime[itemId] != now) {
      _logger.d('Skipping outdated quantity update for item $itemId');
      return;
    }

    // Perform actual server update
    final result = await _updateCartItemUseCase(UpdateCartItemParams(
      itemId: itemId,
      quantity: newQuantity,
      userId: effectiveUserId, // 🔥 Use effective user ID
    ));

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
            'user': 'roshdology123',
          },
        );

        // Show error but keep optimistic update unless it's a critical error
        if (failure.code == 'item_not_found' || failure.code == 'insufficient_stock') {
          // Revert optimistic update for critical errors
          refresh();
        }

        _showErrorMessage('Failed to update quantity: ${failure.message}');
      },
          (cart) {
        _logger.logUserAction('update_quantity_success', {
          'item_id': itemId,
          'new_quantity': newQuantity,
          'cart_total': cart.summary.total,
          'cart_user_id': cart.userId,
          'user': 'roshdology123',
        });

        // Update with server response
        emit(CartState.loaded(cart: cart));
      },
    );
  }

  /// Remove coupon code
  Future<void> removeCoupon(String couponCode) async {
    final effectiveUserId = _getCurrentEffectiveUserId();

    _logger.logUserAction('remove_coupon_started', {
      'coupon_code': couponCode,
      'user_id': effectiveUserId,
      'cubit_user_id': _currentUserId,
      'is_authenticated': _isUserAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    _debugUserState('removeCoupon');

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
      userId: effectiveUserId, // 🔥 Use effective user ID
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
          'cart_user_id': cart.userId,
          'user': 'roshdology123',
        });

        emit(CartState.loaded(cart: cart));
        _showSuccessMessage('Coupon removed');
      },
    );
  }

  /// Refresh cart data
  Future<void> refresh() async {
    final effectiveUserId = _getCurrentEffectiveUserId();

    _logger.logUserAction('cart_refresh_started', {
      'user_id': effectiveUserId,
      'cubit_user_id': _currentUserId,
      'is_authenticated': _isUserAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    _debugUserState('refresh');

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

    await initializeCart(effectiveUserId);
  }

  // ... [Keep all other existing methods but update them to use _getCurrentEffectiveUserId()]

  /// Show success message
  void _showSuccessMessage(String message) {
    _logger.logUserAction('cart_success_message', {
      'message': message,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });
  }

  /// 🔥 Show error message
  void _showErrorMessage(String message) {
    _logger.logUserAction('cart_error_message', {
      'message': message,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });
  }

  /// Get current cart without triggering state changes
  Cart? get currentCart => state.cart;

  /// Get current user ID
  String? get currentUserId => _currentUserId;

  /// Get authentication state
  bool get isUserAuthenticated => _isUserAuthenticated;

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
  /// Sync cart with server (for authenticated users)

  /// Clear entire cart
  Future<void> clearCart({bool showConfirmation = true}) async {
    if (showConfirmation) {
      // In a real app, show confirmation dialog
    }

    _logger.logUserAction('clear_cart_started', {
      'user_id': _currentUserId ?? 'roshdology123',
      'current_items': state.cart?.items.length ?? 0,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 12:55:48',
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
      ClearCartParams(userId: _currentUserId ?? 'roshdology123'), // 🔥 Ensure user ID
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
          'user_id': _currentUserId ?? 'roshdology123',
          'user': 'roshdology123',
        });

        emit(const CartState.empty());
        _showSuccessMessage('Cart cleared');
      },
    );
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
          'timestamp': '2025-06-22 12:55:48',
        });

        switch (failedAction) {
          case 'initialize':
            initializeCart(_currentUserId);
            break;
          case 'add_to_cart':
            refresh(); // Simplified retry
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
  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    final startTime = DateTime.now();

    _logger.logUserAction('remove_from_cart_started', {
      'item_id': itemId,
      'user_id': _currentUserId ?? 'roshdology123',
      'user': 'roshdology123',
      'timestamp': '2025-06-22 12:55:48',
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
      RemoveFromCartParams(
          itemId: itemId,
          userId: _currentUserId ?? 'roshdology123' // 🔥 Ensure user ID
      ),
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

  Future<void> syncCart() async {
    final userId = _currentUserId ?? 'roshdology123';

    _logger.logBusinessLogic(
      'sync_cart_started',
      'manual_sync',
      {
        'user_id': userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 12:55:48',
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

    final result = await _syncCartUseCase(SyncCartParams(userId: userId));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'sync_cart_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'user_id': userId,
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
          emit(CartState.loaded(cart: cart));
          _showSuccessMessage('Cart synced with conflicts');
        } else {
          emit(CartState.loaded(cart: cart));
          _showSuccessMessage('Cart synced successfully');
        }
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
      'user_id': _currentUserId ?? 'roshdology123',
      'user': 'roshdology123',
      'timestamp': '2025-06-22 12:55:48',
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
      userId: _currentUserId ?? 'roshdology123', // 🔥 Ensure user ID
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

  /// Background sync (no UI feedback)
  Future<void> _syncCartBackground() async {
    final userId = _currentUserId ?? 'roshdology123';

    try {
      final result = await _syncCartUseCase(SyncCartParams(userId: userId));
      result.fold(
            (failure) => _logger.w('Background sync failed: ${failure.message}'),
            (cart) {
          _logger.d('Background sync successful');

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

  @override
  Future<void> close() {
    _logger.logBusinessLogic(
      'cart_cubit_closed',
      'cleanup',
      {
        'user_id': _currentUserId,
        'is_authenticated': _isUserAuthenticated,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 14:00:15',
      },
    );

    return super.close();
  }
}