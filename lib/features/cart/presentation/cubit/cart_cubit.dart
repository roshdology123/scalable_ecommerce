import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/models/cart_item_model.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_summary.dart';
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
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
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
        'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
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
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    _currentUserId = authenticatedUserId;
    _isUserAuthenticated = true;

    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
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
      empty: (_, __,___) {
        // Create new authenticated empty cart
        emit(const CartState.empty());
      },
    );

    _debugUserState('forceAuthenticatedCart');
  }

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
      'timestamp': '2025-06-23 06:59:26', // 🔥 UPDATED TO CURRENT TIME
    });

    _debugUserState('addToCart');

    // 🔥 OPTIMISTIC UPDATE: Add item immediately
    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
        // Build selected variants map
        final variants = <String, String>{};
        if (selectedColor != null) variants['color'] = selectedColor;
        if (selectedSize != null) variants['size'] = selectedSize;
        if (additionalVariants != null) variants.addAll(additionalVariants);

        // Calculate discount amount if discount percentage is provided
        final effectiveOriginalPrice = originalPrice ?? price;
        final calculatedDiscountAmount = discountPercentage != null
            ? (effectiveOriginalPrice * discountPercentage / 100)
            : (effectiveOriginalPrice > price ? effectiveOriginalPrice - price : null);

        // Create new cart item with all required fields
        final newItem = CartItem(
          id: 'temp_${productId}_${DateTime.now().millisecondsSinceEpoch}',
          productId: productId,
          productTitle: productTitle,
          productImage: productImage,
          price: price,
          originalPrice: effectiveOriginalPrice,
          quantity: quantity,
          maxQuantity: maxQuantity ?? 999, // Default max quantity
          selectedColor: selectedColor,
          selectedSize: selectedSize,
          selectedVariants: variants,
          isAvailable: true, // Assume available for optimistic update
          inStock: true, // Assume in stock for optimistic update
          brand: brand,
          category: category,
          sku: sku,
          discountPercentage: discountPercentage,
          discountAmount: calculatedDiscountAmount,
          addedAt: DateTime.parse('2025-06-23 06:59:26'),
          updatedAt: DateTime.parse('2025-06-23 06:59:26'),
          lastPriceCheck: DateTime.parse('2025-06-23 06:59:26'),
          priceChanged: false,
          previousPrice: null,
          isSelected: false,
          specialOfferId: null,
          metadata: null,
        );

        final updatedItems = [...cart.items, newItem];
        final optimisticCart = cart.copyWith(
          items: updatedItems,
          updatedAt: DateTime.parse('2025-06-23 06:59:26'),
        );

        // Recalculate totals optimistically
        final optimisticSummary = _calculateOptimisticSummary(optimisticCart);
        final finalCart = optimisticCart.copyWith(summary: optimisticSummary);

        emit(CartState.loaded(
          cart: finalCart,
          isOptimistic: true,
        ));

        _showSuccessMessage('Item added to cart');
      },
      empty: (_, __,___) {
        // Build selected variants map
        final variants = <String, String>{};
        if (selectedColor != null) variants['color'] = selectedColor;
        if (selectedSize != null) variants['size'] = selectedSize;
        if (additionalVariants != null) variants.addAll(additionalVariants);

        // Calculate discount amount if discount percentage is provided
        final effectiveOriginalPrice = originalPrice ?? price;
        final calculatedDiscountAmount = discountPercentage != null
            ? (effectiveOriginalPrice * discountPercentage / 100)
            : (effectiveOriginalPrice > price ? effectiveOriginalPrice - price : null);

        // Create new cart with the item
        final newItem = CartItem(
          id: 'temp_${productId}_${DateTime.now().millisecondsSinceEpoch}',
          productId: productId,
          productTitle: productTitle,
          productImage: productImage,
          price: price,
          originalPrice: effectiveOriginalPrice,
          quantity: quantity,
          maxQuantity: maxQuantity ?? 999,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
          selectedVariants: variants,
          isAvailable: true,
          inStock: true,
          brand: brand,
          category: category,
          sku: sku,
          discountPercentage: discountPercentage,
          discountAmount: calculatedDiscountAmount,
          addedAt: DateTime.parse('2025-06-23 06:59:26'),
          updatedAt: DateTime.parse('2025-06-23 06:59:26'),
          lastPriceCheck: DateTime.parse('2025-06-23 06:59:26'),
          priceChanged: false,
          previousPrice: null,
          isSelected: false,
          specialOfferId: null,
          metadata: null,
        );

        // Create initial cart summary
        final itemTotal = price * quantity;
        final estimatedTax = itemTotal * 0.08; // 8% tax estimation

        final newCart = Cart(
          id: 'cart_${effectiveUserId}_${DateTime.now().millisecondsSinceEpoch}',
          userId: effectiveUserId,
          items: [newItem],
          summary: CartSummary.empty().copyWith(
            subtotal: itemTotal,
            totalTax: estimatedTax,
            total: itemTotal + estimatedTax,
            totalItems: quantity,
            totalQuantity: quantity, // Assuming this field exists
            lastCalculated: DateTime.parse('2025-06-23 06:59:26'),
          ),
          createdAt: DateTime.parse('2025-06-23 06:59:26'),
          updatedAt: DateTime.parse('2025-06-23 06:59:26'),
        );

        emit(CartState.loaded(
          cart: newCart,
          isOptimistic: true,
        ));

        _showSuccessMessage('Item added to cart');
      },
    );

    // Background server update
    final result = await _addToCartUseCase(AddToCartParams(
      productId: productId,
      productTitle: productTitle,
      productImage: productImage,
      price: price,
      quantity: quantity,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      additionalVariants: additionalVariants,
      userId: effectiveUserId,
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

        // Revert optimistic update on failure
        refresh();
        _showErrorMessage('Failed to add item: ${failure.message}');
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

        emit(CartState.loaded(
          cart: cart,
          isOptimistic: false, // Confirmed by server
        ));
      },
    );
  }

  /// 🔥 OPTIMISTIC UPDATE: Apply coupon with immediate UI response
  Future<void> applyCoupon(String couponCode) async {
    final startTime = DateTime.now();

    await forceAuthenticatedCart();
    final effectiveUserId = 'roshdology123';

    _logger.logUserAction('apply_coupon_started', {
      'coupon_code': couponCode,
      'user_id': effectiveUserId,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    // 🔥 OPTIMISTIC UPDATE: Apply coupon immediately with estimated discount
    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
        final optimisticDiscount = _estimateCouponDiscount(cart, couponCode);

        final optimisticSummary = cart.summary.copyWith(
          appliedCouponCode: couponCode,
          couponDiscount: optimisticDiscount,
          total: (cart.summary.subtotal + cart.summary.totalTax + cart.summary.shippingCost - optimisticDiscount).clamp(0.0, double.infinity),
          lastCalculated: DateTime.now(),
        );

        final optimisticCart = cart.copyWith(summary: optimisticSummary);

        emit(CartState.loaded(
          cart: optimisticCart,
          isOptimistic: true,
        ));

        _showSuccessMessage('Coupon applied! Verifying discount...');
      },
    );

    // Background server verification
    final result = await _applyCouponUseCase(ApplyCouponParams(
      couponCode: couponCode,
      userId: effectiveUserId,
      cartId: state.cart?.id,
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

        // Revert optimistic update
        refresh();

        String errorMessage = failure.message;
        if (failure.code == 'COUPON_NOT_FOUND') {
          errorMessage = 'Invalid coupon code';
        } else if (failure.code == 'COUPON_EXPIRED') {
          errorMessage = 'This coupon has expired';
        } else if (failure.code == 'MINIMUM_AMOUNT_NOT_MET') {
          errorMessage = failure.message;
        }

        _showErrorMessage(errorMessage);
      },
          (cart) {
        _logger.logUserAction('apply_coupon_success', {
          'coupon_code': couponCode,
          'discount_amount': cart.summary.couponDiscount,
          'new_total': cart.summary.total,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        });

        // Confirm with actual server discount
        emit(CartState.loaded(
          cart: cart,
          isOptimistic: false,
        ));

        final discountAmount = cart.summary.couponDiscount ?? 0.0;
        _showSuccessMessage(
          'Coupon confirmed! You saved \$${discountAmount.toStringAsFixed(2)}',
        );
      },
    );
  }

  /// 🔥 OPTIMISTIC UPDATE: Update quantity with immediate UI response
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    final now = DateTime.now();
    _lastUpdateTime[itemId] = now;

    final effectiveUserId = _getCurrentEffectiveUserId();

    _logger.logUserAction('update_quantity_started', {
      'item_id': itemId,
      'new_quantity': newQuantity,
      'user_id': effectiveUserId,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    // 🔥 IMMEDIATE OPTIMISTIC UPDATE
    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
        final updatedItems = cart.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();

        // Remove item if quantity is 0
        if (newQuantity == 0) {
          updatedItems.removeWhere((item) => item.id == itemId);
        }

        final optimisticCart = cart.copyWith(
          items: updatedItems,
          updatedAt: DateTime.now(),
        );

        // Recalculate totals optimistically
        final optimisticSummary = _calculateOptimisticSummary(optimisticCart);
        final finalCart = optimisticCart.copyWith(summary: optimisticSummary);

        // Emit immediately - no loading state
        emit(CartState.loaded(
          cart: finalCart,
          isOptimistic: true,
        ));
      },
    );

    // 🔥 Debounced server update
    await Future.delayed(_debounceDelay);

    // Check if this is still the latest update
    if (_lastUpdateTime[itemId] != now) {
      _logger.d('Skipping outdated quantity update for item $itemId');
      return;
    }

    // Perform actual server update
    final result = await _updateCartItemUseCase(UpdateCartItemParams(
      itemId: itemId,
      quantity: newQuantity,
      userId: effectiveUserId,
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

        // Show error but keep optimistic update unless critical
        if (failure.code == 'item_not_found' || failure.code == 'insufficient_stock') {
          // Revert optimistic update for critical errors
          refresh();
          _showErrorMessage('Failed to update quantity: ${failure.message}');
        } else {
          // Keep optimistic update, just show error
          _showErrorMessage('Update may not be saved: ${failure.message}');
        }
      },
          (cart) {
        _logger.logUserAction('update_quantity_success', {
          'item_id': itemId,
          'new_quantity': newQuantity,
          'cart_total': cart.summary.total,
          'user': 'roshdology123',
        });

        // Update with server response
        emit(CartState.loaded(
          cart: cart,
          isOptimistic: false, // Confirmed by server
        ));
      },
    );
  }

  /// 🔥 OPTIMISTIC UPDATE: Remove coupon immediately
  Future<void> removeCoupon(String couponCode) async {
    final effectiveUserId = _getCurrentEffectiveUserId();

    _logger.logUserAction('remove_coupon_started', {
      'coupon_code': couponCode,
      'user_id': effectiveUserId,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    // 🔥 IMMEDIATE OPTIMISTIC UPDATE
    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
        final optimisticSummary = cart.summary.copyWith(
          appliedCouponCode: null,
          couponDiscount: 0.0,
          total: cart.summary.subtotal + cart.summary.totalTax + cart.summary.shippingCost,
          lastCalculated: DateTime.now(),
        );

        final optimisticCart = cart.copyWith(summary: optimisticSummary);

        emit(CartState.loaded(
          cart: optimisticCart,
          isOptimistic: true,
        ));

        _showSuccessMessage('Coupon removed');
      },
    );

    // Background server update
    final result = await _removeCouponUseCase(RemoveCouponParams(
      couponCode: couponCode,
      userId: effectiveUserId,
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

        // Revert on failure
        refresh();
        _showErrorMessage('Failed to remove coupon: ${failure.message}');
      },
          (cart) {
        _logger.logUserAction('remove_coupon_success', {
          'coupon_code': couponCode,
          'new_total': cart.summary.total,
          'user': 'roshdology123',
        });

        // Confirm with server response
        emit(CartState.loaded(
          cart: cart,
          isOptimistic: false,
        ));
      },
    );
  }

  /// 🔥 OPTIMISTIC UPDATE: Remove item with immediate UI response
  Future<void> removeFromCart(String itemId) async {
    final startTime = DateTime.now();

    _logger.logUserAction('remove_from_cart_started', {
      'item_id': itemId,
      'user_id': _currentUserId ?? 'roshdology123',
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    // 🔥 IMMEDIATE OPTIMISTIC UPDATE
    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
        final updatedItems = cart.items.where((item) => item.id != itemId).toList();

        final optimisticCart = cart.copyWith(
          items: updatedItems,
          updatedAt: DateTime.now(),
        );

        // Recalculate totals
        final optimisticSummary = _calculateOptimisticSummary(optimisticCart);
        final finalCart = optimisticCart.copyWith(summary: optimisticSummary);

        if (finalCart.isEmpty) {
          emit(const CartState.empty(isOptimistic: true));
        } else {
          emit(CartState.loaded(
            cart: finalCart,
            isOptimistic: true,
          ));
        }

        _showSuccessMessage('Item removed from cart');
      },
    );

    // Background server update
    final result = await _removeFromCartUseCase(
      RemoveFromCartParams(
        itemId: itemId,
        userId: _currentUserId ?? 'roshdology123',
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

        // Revert optimistic update on failure
        refresh();
        _showErrorMessage('Failed to remove item: ${failure.message}');
      },
          (cart) {
        _logger.logUserAction('remove_from_cart_success', {
          'item_id': itemId,
          'remaining_items': cart.items.length,
          'cart_total': cart.summary.total,
          'duration_ms': duration.inMilliseconds,
          'user': 'roshdology123',
        });

        // Confirm with server response
        if (cart.isEmpty) {
          emit(const CartState.empty(isOptimistic: false));
        } else {
          emit(CartState.loaded(
            cart: cart,
            isOptimistic: false,
          ));
        }
      },
    );
  }

  /// 🔥 OPTIMISTIC UPDATE: Update variants immediately
  Future<void> updateVariants(
      String itemId, {
        String? selectedColor,
        String? selectedSize,
      }) async {
    _logger.logUserAction('update_variants_started', {
      'item_id': itemId,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    // 🔥 IMMEDIATE OPTIMISTIC UPDATE
    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
        final updatedItems = cart.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(
              selectedColor: selectedColor ?? item.selectedColor,
              selectedSize: selectedSize ?? item.selectedSize,
            );
          }
          return item;
        }).toList();

        final optimisticCart = cart.copyWith(
          items: updatedItems,
          updatedAt: DateTime.now(),
        );

        emit(CartState.loaded(
          cart: optimisticCart,
          isOptimistic: true,
        ));

        _showSuccessMessage('Item updated');
      },
    );

    // Background server update
    final result = await _updateCartItemUseCase(UpdateCartItemParams(
      itemId: itemId,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      userId: _currentUserId ?? 'roshdology123',
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

        // Revert on failure
        refresh();
        _showErrorMessage('Failed to update item: ${failure.message}');
      },
          (cart) {
        _logger.logUserAction('update_variants_success', {
          'item_id': itemId,
          'selected_color': selectedColor,
          'selected_size': selectedSize,
          'user': 'roshdology123',
        });

        // Confirm with server response
        emit(CartState.loaded(
          cart: cart,
          isOptimistic: false,
        ));
      },
    );
  }

  /// Update refresh method to fix parameter count
  Future<void> refresh() async {
    final effectiveUserId = _getCurrentEffectiveUserId();

    _logger.logUserAction('cart_refresh_started', {
      'user_id': effectiveUserId,
      'cubit_user_id': _currentUserId,
      'is_authenticated': _isUserAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    _debugUserState('refresh');

    state.whenOrNull(
      // 🔥 FIXED: Correct number of parameters (8 parameters)
      loaded: (cart, _, __, ___, ____, _____, ______, _______) {
        emit(CartState.loaded(
          cart: cart,
          isRefreshing: true,
        ));
      },
      empty: (_, __,___) {
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

  /// Update all other methods to fix parameter count and timestamps
  void updateUser(String? userId) {
    final previousUserId = _currentUserId;
    final previousAuthState = _isUserAuthenticated;

    _currentUserId = userId ?? 'roshdology123';
    _isUserAuthenticated = _currentUserId != 'guest' && _currentUserId!.isNotEmpty;

    _logger.logUserAction('cart_user_changed', {
      'previous_user_id': previousUserId,
      'new_user_id': _currentUserId,
      'previous_auth_state': previousAuthState,
      'new_auth_state': _isUserAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    _debugUserState('updateUser');

    if (_isUserAuthenticated) {
      forceAuthenticatedCart();
    } else {
      initializeCart(_currentUserId);
    }
  }

  void setUserAuthentication(String userId, bool isAuthenticated) {
    _currentUserId = userId;
    _isUserAuthenticated = isAuthenticated;

    _logger.logUserAction('cart_user_auth_set', {
      'user_id': userId,
      'is_authenticated': isAuthenticated,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });

    _debugUserState('setUserAuthentication');

    if (isAuthenticated && userId == 'roshdology123') {
      forceAuthenticatedCart();
    }
  }

  void _showSuccessMessage(String message) {
    _logger.logUserAction('cart_success_message', {
      'message': message,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });
  }

  void _showErrorMessage(String message) {
    _logger.logUserAction('cart_error_message', {
      'message': message,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
    });
  }

  // ... continue updating other methods with correct parameter counts and timestamps

  @override
  Future<void> close() {
    _logger.logBusinessLogic(
      'cart_cubit_closed',
      'cleanup',
      {
        'user_id': _currentUserId,
        'is_authenticated': _isUserAuthenticated,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 06:48:38', // 🔥 UPDATED
      },
    );

    return super.close();
  }

  // Keep existing helper methods
  double _estimateCouponDiscount(Cart cart, String couponCode) {
    final subtotal = cart.summary.subtotal;

    if (couponCode.toLowerCase().contains('10')) {
      return subtotal * 0.10;
    } else if (couponCode.toLowerCase().contains('20')) {
      return subtotal * 0.20;
    } else if (couponCode.toLowerCase().contains('free')) {
      return 10.0;
    }

    return subtotal * 0.05;
  }

  String _getCurrentEffectiveUserId() {
    if (_currentUserId == 'roshdology123' || _isUserAuthenticated) {
      return 'roshdology123';
    }

    if (state.cart?.userId != null &&
        state.cart!.userId!.isNotEmpty &&
        state.cart!.userId != 'guest') {
      return state.cart!.userId!;
    }

    return 'roshdology123';
  }

  CartSummary _calculateOptimisticSummary(Cart cart) {
    final subtotal = cart.items.fold<double>(
      0.0,
          (sum, item) => sum + (item.price * item.quantity),
    );

    final tax = subtotal * 0.08;
    final shippingCost = cart.summary.shippingCost;
    final couponDiscount = cart.summary.couponDiscount ?? 0.0;

    return cart.summary.copyWith(
      subtotal: subtotal,
      totalTax: tax,
      total: (subtotal + tax + shippingCost - couponDiscount).clamp(0.0, double.infinity),
      totalItems: cart.items.fold<int>(0, (sum, item) => sum + item.quantity),
      lastCalculated: DateTime.now(),
    );
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
      loaded: (cart, _, __, ___, ____, _____, ______,_________) {
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
      loaded: (cart, _, __, ___, ____, _____, ______,_______) {
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
            loaded: (_, __, ___, ____, _____, ______, _______,________) {
              emit(CartState.loaded(cart: cart));
            },
          );
        },
      );
    } catch (e) {
      _logger.w('Background sync exception: $e');
    }
  }

}