import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_summary.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/cart_summary_model.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;
  final CartLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final AppLogger _logger = AppLogger();

  CartRepositoryImpl(
      this._remoteDataSource,
      this._localDataSource,
      this._networkInfo,
      );

  @override
  Future<Either<Failure, Cart>> getCart([String? userId]) async {
    final startTime = DateTime.now();

    try {
      _logger.logBusinessLogic(
        'get_cart',
        'started',
        {'user_id': userId ?? 'guest', 'user': 'roshdology123'},
      );

      // Always try to get local cart first for faster response
      final localCart = await _localDataSource.getCart();

      if (userId == null) {
        // Guest user - only local cart
        if (localCart != null) {
          _logger.logPerformance(
            'get_cart_local',
            DateTime.now().difference(startTime),
            {'source': 'local_only', 'items': localCart.items.length},
          );
          return Right(localCart);
        } else {
          // Create empty guest cart
          final emptyCart = CartModel.empty();
          await _localDataSource.saveCart(emptyCart);

          _logger.logBusinessLogic(
            'get_cart',
            'created_empty_guest_cart',
            {'cart_id': emptyCart.id},
          );

          return Right(emptyCart);
        }
      }

      // Authenticated user - sync with server if connected
      if (await _networkInfo.isConnected) {
        try {
          final remoteCart = await _remoteDataSource.getCart(userId);

          // Compare versions and merge if needed
          if (localCart != null) {
            final mergedCart = await _mergeCartVersions(localCart, remoteCart);
            await _localDataSource.saveCart(mergedCart);

            _logger.logBusinessLogic(
              'get_cart',
              'merged_local_remote',
              {
                'local_version': localCart.version,
                'remote_version': remoteCart.version,
                'final_version': mergedCart.version,
              },
            );

            _logger.logPerformance(
              'get_cart_merged',
              DateTime.now().difference(startTime),
              {'items': mergedCart.items.length, 'total': mergedCart.summary.total},
            );

            return Right(mergedCart);
          } else {
            // Save remote cart locally
            await _localDataSource.saveCart(remoteCart);

            _logger.logPerformance(
              'get_cart_remote',
              DateTime.now().difference(startTime),
              {'source': 'remote', 'items': remoteCart.items.length},
            );

            return Right(remoteCart);
          }
        } catch (e) {
          _logger.w('Failed to get remote cart, using local: $e');

          if (localCart != null) {
            return Right(localCart);
          } else {
            // Create empty cart for authenticated user
            final emptyCart = CartModel.empty(userId: userId);
            await _localDataSource.saveCart(emptyCart);
            return Right(emptyCart);
          }
        }
      } else {
        // Offline - use local cart
        if (localCart != null) {
          _logger.logPerformance(
            'get_cart_offline',
            DateTime.now().difference(startTime),
            {'source': 'local_offline', 'items': localCart.items.length},
          );

          return Right(localCart);
        } else {
          // Create empty cart
          final emptyCart = CartModel.empty(userId: userId);
          await _localDataSource.saveCart(emptyCart);
          return Right(emptyCart);
        }
      }
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.getCart',
        e,
        stackTrace,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      if (e is ApiException) {
        return Left(ServerFailure(e.message, e.code));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message, e.code));
      } else if (e is CacheException) {
        return Left(CacheFailure(e.message, e.code));
      } else {
        return Left(UnknownFailure(
          'Failed to get cart: ${e.toString()}',
          'GET_CART_ERROR',
        ));
      }
    }
  }

  @override
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
  }) async {
    final startTime = DateTime.now();

    try {
      _logger.logUserAction('add_to_cart_started', {
        'product_id': productId,
        'quantity': quantity,
        'user_id': userId ?? 'guest',
        'price': price,
        'selected_color': selectedColor,
        'selected_size': selectedSize,
      });

      // Validate input
      if (quantity <= 0) {
        return const Left(ValidationFailure(
          'Quantity must be greater than 0',
          'INVALID_QUANTITY',
        ));
      }

      if (maxQuantity != null && quantity > maxQuantity) {
        return Left(ValidationFailure(
          'Quantity cannot exceed maximum of $maxQuantity',
          'QUANTITY_EXCEEDS_MAX',
        ));
      }

      // Build variants map
      final variants = <String, String>{};
      if (selectedColor != null) variants['color'] = selectedColor;
      if (selectedSize != null) variants['size'] = selectedSize;
      if (additionalVariants != null) variants.addAll(additionalVariants);

      // Create cart item
      final cartItem = CartItemModel(
        id: _generateCartItemId(productId, variants),
        productId: productId,
        productTitle: productTitle,
        productImage: productImage,
        price: price,
        originalPrice: originalPrice ?? price,
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
        discountAmount: originalPrice != null && originalPrice > price
            ? originalPrice - price
            : null,
        addedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastPriceCheck: DateTime.now(),
      );

      // Check if item already exists in cart
      final existingItem = await _localDataSource.getCartItemByProduct(
        productId,
        variants,
      );

      if (existingItem != null) {
        // Update existing item quantity
        final newQuantity = existingItem.quantity + quantity;

        if (maxQuantity != null && newQuantity > maxQuantity) {
          return Left(ValidationFailure(
            'Cannot add $quantity items. Maximum quantity of $maxQuantity would be exceeded.',
            'QUANTITY_EXCEEDS_MAX',
          ));
        }

        final updatedItem = existingItem.copyWith(
          quantity: newQuantity,
          updatedAt: DateTime.now(),
        );

        return await _updateCartItemInternal(updatedItem, userId);
      } else {
        // Add new item
        return await _addNewCartItem(cartItem, userId);
      }
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.addToCart',
        e,
        stackTrace,
        {
          'product_id': productId,
          'user_id': userId,
          'user': 'roshdology123',
        },
      );

      return Left(UnknownFailure(
        'Failed to add item to cart: ${e.toString()}',
        'ADD_TO_CART_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeFromCart({
    required String itemId,
    String? userId,
  }) async {
    try {
      _logger.logUserAction('remove_from_cart_started', {
        'item_id': itemId,
        'user_id': userId ?? 'guest',
      });

      // Remove from local storage
      await _localDataSource.removeCartItem(itemId);

      // Try to remove from remote if user is authenticated and online
      if (userId != null && await _networkInfo.isConnected) {
        try {
          final updatedCart = await _remoteDataSource.removeCartItem(userId, itemId);
          await _localDataSource.saveCart(updatedCart);

          _logger.logUserAction('remove_from_cart_success_remote', {
            'item_id': itemId,
            'user_id': userId,
            'remaining_items': updatedCart.items.length,
          });

          return Right(updatedCart);
        } catch (e) {
          _logger.w('Failed to remove from remote cart, removed locally: $e');

          // Mark as having pending changes
          await _markPendingChange('remove_item', {'item_id': itemId});
        }
      }

      // Get updated local cart
      final cartResult = await getCart(userId);
      return cartResult.fold(
            (failure) => Left(failure),
            (cart) {
          _logger.logUserAction('remove_from_cart_success_local', {
            'item_id': itemId,
            'remaining_items': cart.items.length,
          });
          return Right(cart);
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.removeFromCart',
        e,
        stackTrace,
        {
          'item_id': itemId,
          'user_id': userId,
          'user': 'roshdology123',
        },
      );

      if (e is CacheException) {
        return Left(CacheFailure(e.message, e.code));
      } else {
        return Left(UnknownFailure(
          'Failed to remove item from cart: ${e.toString()}',
          'REMOVE_FROM_CART_ERROR',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Cart>> updateCartItem({
    required String itemId,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    String? userId,
  }) async {
    try {
      _logger.logUserAction('update_cart_item_started', {
        'item_id': itemId,
        'new_quantity': quantity,
        'user_id': userId ?? 'guest',
      });

      // Get current cart
      final cartResult = await getCart(userId);
      return await cartResult.fold(
            (failure) async => Left(failure),
            (cart) async {
          // Find the item to update
          final itemIndex = cart.items.indexWhere((item) => item.id == itemId);
          if (itemIndex == -1) {
            return const Left(ValidationFailure(
              'Item not found in cart',
              'ITEM_NOT_FOUND',
            ));
          }

          final currentItem = cart.items[itemIndex];

          // Validate quantity
          if (quantity != null) {
            if (quantity <= 0) {
              return const Left(ValidationFailure(
                'Quantity must be greater than 0',
                'INVALID_QUANTITY',
              ));
            }

            if (quantity > currentItem.maxQuantity) {
              return Left(ValidationFailure(
                'Quantity cannot exceed maximum of ${currentItem.maxQuantity}',
                'QUANTITY_EXCEEDS_MAX',
              ));
            }
          }

          // Create updated item
          final updatedVariants = Map<String, String>.from(currentItem.selectedVariants);
          if (selectedColor != null) updatedVariants['color'] = selectedColor;
          if (selectedSize != null) updatedVariants['size'] = selectedSize;

          final updatedItem = CartItemModel.fromCartItem(currentItem).copyWith(
            quantity: quantity ?? currentItem.quantity,
            selectedColor: selectedColor ?? currentItem.selectedColor,
            selectedSize: selectedSize ?? currentItem.selectedSize,
            selectedVariants: updatedVariants,
            updatedAt: DateTime.now(),
          );

          return await _updateCartItemInternal(updatedItem, userId);
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.updateCartItem',
        e,
        stackTrace,
        {
          'item_id': itemId,
          'user_id': userId,
          'user': 'roshdology123',
        },
      );

      return Left(UnknownFailure(
        'Failed to update cart item: ${e.toString()}',
        'UPDATE_CART_ITEM_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart([String? userId]) async {
    try {
      _logger.logUserAction('clear_cart_started', {
        'user_id': userId ?? 'guest',
      });

      // Clear local cart
      await _localDataSource.clearCart();

      // Try to clear remote cart if user is authenticated and online
      if (userId != null && await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.clearCart(userId);

          _logger.logUserAction('clear_cart_success_remote', {
            'user_id': userId,
          });
        } catch (e) {
          _logger.w('Failed to clear remote cart, cleared locally: $e');
          await _markPendingChange('clear_cart', {});
        }
      } else {
        _logger.logUserAction('clear_cart_success_local', {
          'user_id': userId ?? 'guest',
        });
      }

      return const Right(null);
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.clearCart',
        e,
        stackTrace,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      if (e is CacheException) {
        return Left(CacheFailure(e.message, e.code));
      } else {
        return Left(UnknownFailure(
          'Failed to clear cart: ${e.toString()}',
          'CLEAR_CART_ERROR',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, int>> getCartItemsCount([String? userId]) async {
    try {
      final count = await _localDataSource.getCartItemsCount();

      _logger.logCacheOperation('get_cart_count', 'cart_count', true, 'Count: $count');

      return Right(count);
    } catch (e) {
      _logger.w('Failed to get cart items count: $e');
      return const Right(0);
    }
  }

  @override
  Future<Either<Failure, double>> getCartTotal([String? userId]) async {
    try {
      final total = await _localDataSource.getCartTotal();

      _logger.logCacheOperation('get_cart_total', 'cart_total', true, 'Total: \$$total');

      return Right(total);
    } catch (e) {
      _logger.w('Failed to get cart total: $e');
      return const Right(0.0);
    }
  }

  @override
  Future<Either<Failure, bool>> isItemInCart({
    required int productId,
    required Map<String, String> variants,
    String? userId,
  }) async {
    try {
      final item = await _localDataSource.getCartItemByProduct(productId, variants);
      return Right(item != null);
    } catch (e) {
      _logger.w('Failed to check if item in cart: $e');
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, Cart>> applyCoupon({
    required String couponCode,
    String? userId,
  }) async {
    try {
      _logger.logUserAction('apply_coupon_started', {
        'coupon_code': couponCode,
        'user_id': userId ?? 'guest',
      });

      if (userId == null) {
        return const Left(ValidationFailure(
          'User must be logged in to apply coupons',
          'USER_NOT_AUTHENTICATED',
        ));
      }

      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          'Internet connection required to apply coupons',
          'NO_INTERNET_CONNECTION',
        ));
      }

      final updatedCart = await _remoteDataSource.applyCoupon(userId, couponCode);
      await _localDataSource.saveCart(updatedCart);

      _logger.logUserAction('apply_coupon_success', {
        'coupon_code': couponCode,
        'user_id': userId,
        'discount_amount': updatedCart.summary.couponDiscount,
      });

      return Right(updatedCart);
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.applyCoupon',
        e,
        stackTrace,
        {
          'coupon_code': couponCode,
          'user_id': userId,
          'user': 'roshdology123',
        },
      );

      if (e is ApiException) {
        if (e.code == 'INVALID_COUPON') {
          return Left(ValidationFailure(
            'Invalid or expired coupon code',
            'INVALID_COUPON',
          ));
        } else if (e.code == 'COUPON_ALREADY_USED') {
          return Left(ValidationFailure(
            'Coupon has already been used',
            'COUPON_ALREADY_USED',
          ));
        } else if (e.code == 'MINIMUM_ORDER_NOT_MET') {
          return Left(ValidationFailure(
            'Minimum order amount not met for this coupon',
            'MINIMUM_ORDER_NOT_MET',
          ));
        }
        return Left(ServerFailure(e.message, e.code));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message, e.code));
      } else {
        return Left(UnknownFailure(
          'Failed to apply coupon: ${e.toString()}',
          'APPLY_COUPON_ERROR',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Cart>> removeCoupon({
    required String couponCode,
    String? userId,
  }) async {
    try {
      _logger.logUserAction('remove_coupon_started', {
        'coupon_code': couponCode,
        'user_id': userId ?? 'guest',
      });

      if (userId == null) {
        return const Left(ValidationFailure(
          'User must be logged in to remove coupons',
          'USER_NOT_AUTHENTICATED',
        ));
      }

      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          'Internet connection required to remove coupons',
          'NO_INTERNET_CONNECTION',
        ));
      }

      final updatedCart = await _remoteDataSource.removeCoupon(userId, couponCode);
      await _localDataSource.saveCart(updatedCart);

      _logger.logUserAction('remove_coupon_success', {
        'coupon_code': couponCode,
        'user_id': userId,
      });

      return Right(updatedCart);
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.removeCoupon',
        e,
        stackTrace,
        {
          'coupon_code': couponCode,
          'user_id': userId,
          'user': 'roshdology123',
        },
      );

      if (e is ApiException) {
        return Left(ServerFailure(e.message, e.code));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message, e.code));
      } else {
        return Left(UnknownFailure(
          'Failed to remove coupon: ${e.toString()}',
          'REMOVE_COUPON_ERROR',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, CartSummary>> calculateCartTotals({
    String? shippingMethodId,
    String? couponCode,
    String? userId,
  }) async {
    try {
      _logger.logBusinessLogic(
        'calculate_cart_totals',
        'started',
        {
          'shipping_method_id': shippingMethodId,
          'coupon_code': couponCode,
          'user_id': userId ?? 'guest',
        },
      );

      if (userId != null && await _networkInfo.isConnected) {
        try {
          final totalsData = await _remoteDataSource.calculateCartTotals(
            userId,
            shippingMethodId,
            couponCode,
          );

          final summary = CartSummaryModel.fromJson(totalsData);

          _logger.logBusinessLogic(
            'calculate_cart_totals',
            'success_remote',
            {
              'subtotal': summary.subtotal,
              'total': summary.total,
              'shipping_cost': summary.shippingCost,
            },
          );

          return Right(summary);
        } catch (e) {
          _logger.w('Failed to calculate totals remotely, using local: $e');
        }
      }

      // Fallback to local calculation
      final cartResult = await getCart(userId);
      return cartResult.fold(
            (failure) => Left(failure),
            (cart) {
          final localSummary = _calculateLocalCartTotals(
            cart,
            shippingMethodId,
            couponCode,
          );

          _logger.logBusinessLogic(
            'calculate_cart_totals',
            'success_local',
            {
              'subtotal': localSummary.subtotal,
              'total': localSummary.total,
            },
          );

          return Right(localSummary);
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.calculateCartTotals',
        e,
        stackTrace,
        {
          'shipping_method_id': shippingMethodId,
          'user_id': userId,
          'user': 'roshdology123',
        },
      );

      return Left(UnknownFailure(
        'Failed to calculate cart totals: ${e.toString()}',
        'CALCULATE_TOTALS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, Cart>> syncCart(String userId) async {
    try {
      _logger.logBusinessLogic('sync_cart', 'started', {'user_id': userId});

      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          'Internet connection required to sync cart',
          'NO_INTERNET_CONNECTION',
        ));
      }

      final localCart = await _localDataSource.getCart();
      if (localCart == null) {
        // No local cart to sync, just get remote cart
        final remoteCart = await _remoteDataSource.getCart(userId);
        await _localDataSource.saveCart(remoteCart);
        return Right(remoteCart);
      }

      final syncedCart = await _remoteDataSource.syncCart(localCart);
      await _localDataSource.saveCart(syncedCart);

      // Clear pending changes
      await _localDataSource.clearPendingChanges();

      _logger.logBusinessLogic('sync_cart', 'success', {
        'user_id': userId,
        'local_version': localCart.version,
        'synced_version': syncedCart.version,
      });

      return Right(syncedCart);
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.syncCart',
        e,
        stackTrace,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      if (e is ApiException) {
        return Left(ServerFailure(e.message, e.code));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message, e.code));
      } else {
        return Left(UnknownFailure(
          'Failed to sync cart: ${e.toString()}',
          'SYNC_CART_ERROR',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Cart>> mergeGuestCart({
    required String userId,
    required Cart guestCart,
  }) async {
    try {
      _logger.logBusinessLogic('merge_guest_cart', 'started', {
        'user_id': userId,
        'guest_cart_items': guestCart.items.length,
      });

      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          'Internet connection required to merge cart',
          'NO_INTERNET_CONNECTION',
        ));
      }

      final guestCartModel = CartModel.fromCart(guestCart);
      final mergedCart = await _remoteDataSource.mergeGuestCart(userId, guestCartModel);
      await _localDataSource.saveCart(mergedCart);

      _logger.logBusinessLogic('merge_guest_cart', 'success', {
        'user_id': userId,
        'guest_items': guestCart.items.length,
        'merged_items': mergedCart.items.length,
      });

      return Right(mergedCart);
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.mergeGuestCart',
        e,
        stackTrace,
        {
          'user_id': userId,
          'guest_cart_id': guestCart.id,
          'user': 'roshdology123',
        },
      );

      if (e is ApiException) {
        return Left(ServerFailure(e.message, e.code));
      } else if (e is NetworkException) {
        return Left(NetworkFailure(e.message, e.code));
      } else {
        return Left(UnknownFailure(
          'Failed to merge guest cart: ${e.toString()}',
          'MERGE_CART_ERROR',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, Cart>> validateCart([String? userId]) async {
    try {
      _logger.logBusinessLogic('validate_cart', 'started', {
        'user_id': userId ?? 'guest',
      });

      if (userId != null && await _networkInfo.isConnected) {
        try {
          final validatedCart = await _remoteDataSource.validateCart(userId);
          await _localDataSource.saveCart(validatedCart);

          _logger.logBusinessLogic('validate_cart', 'success_remote', {
            'user_id': userId,
            'items_count': validatedCart.items.length,
          });

          return Right(validatedCart);
        } catch (e) {
          _logger.w('Failed to validate cart remotely, using local: $e');
        }
      }

      // Local validation
      final cartResult = await getCart(userId);
      return cartResult.fold(
            (failure) => Left(failure),
            (cart) {
          // TODO: Implement local validation logic
          // For now, just return the cart as-is

          _logger.logBusinessLogic('validate_cart', 'success_local', {
            'user_id': userId ?? 'guest',
            'items_count': cart.items.length,
          });

          return Right(cart);
        },
      );
    } catch (e, stackTrace) {
      _logger.logErrorWithContext(
        'CartRepository.validateCart',
        e,
        stackTrace,
        {'user_id': userId, 'user': 'roshdology123'},
      );

      return Left(UnknownFailure(
        'Failed to validate cart: ${e.toString()}',
        'VALIDATE_CART_ERROR',
      ));
    }
  }

  // Private helper methods

  Future<Either<Failure, Cart>> _addNewCartItem(
      CartItemModel item,
      String? userId,
      ) async {
    // Add to local storage
    await _localDataSource.addCartItem(item);

    // Try to add to remote if user is authenticated and online
    if (userId != null && await _networkInfo.isConnected) {
      try {
        final updatedCart = await _remoteDataSource.addCartItem(userId, item);
        await _localDataSource.saveCart(updatedCart);

        _logger.logUserAction('add_to_cart_success_remote', {
          'product_id': item.productId,
          'quantity': item.quantity,
          'user_id': userId,
        });

        return Right(updatedCart);
      } catch (e) {
        _logger.w('Failed to add to remote cart, added locally: $e');
        await _markPendingChange('add_item', item.toJson());
      }
    }

    // Get updated local cart
    final cartResult = await getCart(userId);
    return cartResult.fold(
          (failure) => Left(failure),
          (cart) {
        _logger.logUserAction('add_to_cart_success_local', {
          'product_id': item.productId,
          'quantity': item.quantity,
          'total_items': cart.items.length,
        });
        return Right(cart);
      },
    );
  }

  Future<Either<Failure, Cart>> _updateCartItemInternal(
      CartItemModel item,
      String? userId,
      ) async {
    // Update local storage
    await _localDataSource.updateCartItem(item);

    // Try to update remote if user is authenticated and online
    if (userId != null && await _networkInfo.isConnected) {
      try {
        final updatedCart = await _remoteDataSource.updateCartItem(userId, item);
        await _localDataSource.saveCart(updatedCart);

        _logger.logUserAction('update_cart_item_success_remote', {
          'item_id': item.id,
          'new_quantity': item.quantity,
          'user_id': userId,
        });

        return Right(updatedCart);
      } catch (e) {
        _logger.w('Failed to update remote cart item, updated locally: $e');
        await _markPendingChange('update_item', item.toJson());
      }
    }

    // Get updated local cart
    final cartResult = await getCart(userId);
    return cartResult.fold(
          (failure) => Left(failure),
          (cart) {
        _logger.logUserAction('update_cart_item_success_local', {
          'item_id': item.id,
          'new_quantity': item.quantity,
        });
        return Right(cart);
      },
    );
  }

  Future<CartModel> _mergeCartVersions(CartModel localCart, CartModel remoteCart) async {
    // Simple merge strategy: use remote cart as base, but keep local changes
    // In a production app, you'd implement more sophisticated conflict resolution

    if (localCart.version >= remoteCart.version) {
      // Local cart is newer or same version, keep local
      return localCart.copyWith(
        lastSyncedAt: DateTime.now(),
        isSynced: true,
        hasPendingChanges: false,
      );
    } else {
      // Remote cart is newer, use remote but flag any conflicts
      final conflicts = <String>[];

      // Check for conflicting items
      for (final localItem in localCart.items) {
        final remoteItem = remoteCart.items
            .where((item) => item.id == localItem.id)
            .firstOrNull;

        if (remoteItem != null && localItem.updatedAt != remoteItem.updatedAt) {
          conflicts.add(localItem.id);
        }
      }

      return remoteCart.copyWith(
        lastSyncedAt: DateTime.now(),
        isSynced: true,
        hasPendingChanges: false,
        conflictingFields: conflicts.isNotEmpty ? conflicts : null,
      );
    }
  }

  CartSummaryModel _calculateLocalCartTotals(
      Cart cart,
      String? shippingMethodId,
      String? couponCode,
      ) {
    double subtotal = 0.0;
    double totalDiscount = 0.0;
    int totalItems = cart.items.length;
    int totalQuantity = 0;

    for (final item in cart.items) {
      subtotal += item.price * item.quantity;
      totalQuantity += item.quantity;

      if (item.discountAmount != null) {
        totalDiscount += item.discountAmount! * item.quantity;
      }
    }

    // Simple tax calculation (8.25% for example)
    const taxRate = 0.0825;
    final totalTax = subtotal * taxRate;

    // Simple shipping calculation
    double shippingCost = 0.0;
    if (shippingMethodId != null) {
      // Mock shipping costs
      switch (shippingMethodId) {
        case 'standard':
          shippingCost = subtotal >= 50 ? 0.0 : 5.99;
          break;
        case 'express':
          shippingCost = 12.99;
          break;
        case 'overnight':
          shippingCost = 24.99;
          break;
      }
    }

    final total = subtotal + totalTax + shippingCost - totalDiscount;

    return CartSummaryModel(
      subtotal: subtotal,
      totalDiscount: totalDiscount,
      totalTax: totalTax,
      shippingCost: shippingCost,
      total: total,
      totalItems: totalItems,
      totalQuantity: totalQuantity,
      taxRate: taxRate,
      selectedShippingMethod: shippingMethodId,
      isFreeShipping: shippingCost == 0.0 && subtotal >= 50,
      freeShippingThreshold: 50.0,
      amountToFreeShipping: subtotal < 50 ? 50 - subtotal : 0.0,
      lastCalculated: DateTime.now(),
    );
  }

  Future<void> _markPendingChange(String action, Map<String, dynamic> data) async {
    final change = {
      'action': action,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'user': 'roshdology123',
    };

    await _localDataSource.savePendingChange(change);
  }

  String _generateCartItemId(int productId, Map<String, String> variants) {
    final variantString = variants.entries
        .map((e) => '${e.key}:${e.value}')
        .join('|');
    return '${productId}_${variantString.hashCode}';
  }
}

// Helper extension
extension on Iterable {
  T? get firstOrNull => isEmpty ? null : first;
}