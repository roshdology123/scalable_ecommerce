import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:scalable_ecommerce/core/errors/failures.dart';
import 'package:scalable_ecommerce/core/utils/app_logger.dart';
import 'package:scalable_ecommerce/features/cart/domain/entities/cart.dart';
import 'package:scalable_ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:scalable_ecommerce/features/cart/domain/entities/cart_summary.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/apply_coupon_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/calculate_cart_totals_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/remove_coupon_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/sync_cart_usecase.dart';
import 'package:scalable_ecommerce/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:scalable_ecommerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:scalable_ecommerce/features/cart/presentation/cubit/cart_state.dart';
import 'cart_cubit_test.mocks.dart';

@GenerateMocks([
  GetCartUseCase,
  AddToCartUseCase,
  RemoveFromCartUseCase,
  UpdateCartItemUseCase,
  ClearCartUseCase,
  ApplyCouponUseCase,
  RemoveCouponUseCase,
  CalculateCartTotalsUseCase,
  SyncCartUseCase,
  AppLogger,
])
void main() {
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockRemoveFromCartUseCase mockRemoveFromCartUseCase;
  late MockUpdateCartItemUseCase mockUpdateCartItemUseCase;
  late MockClearCartUseCase mockClearCartUseCase;
  late MockApplyCouponUseCase mockApplyCouponUseCase;
  late MockRemoveCouponUseCase mockRemoveCouponUseCase;
  late MockCalculateCartTotalsUseCase mockCalculateCartTotalsUseCase;
  late MockSyncCartUseCase mockSyncCartUseCase;
  late CartCubit cartCubit;

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockRemoveFromCartUseCase = MockRemoveFromCartUseCase();
    mockUpdateCartItemUseCase = MockUpdateCartItemUseCase();
    mockClearCartUseCase = MockClearCartUseCase();
    mockApplyCouponUseCase = MockApplyCouponUseCase();
    mockRemoveCouponUseCase = MockRemoveCouponUseCase();
    mockCalculateCartTotalsUseCase = MockCalculateCartTotalsUseCase();
    mockSyncCartUseCase = MockSyncCartUseCase();

    cartCubit = CartCubit(
      mockGetCartUseCase,
      mockAddToCartUseCase,
      mockRemoveFromCartUseCase,
      mockUpdateCartItemUseCase,
      mockClearCartUseCase,
      mockApplyCouponUseCase,
      mockRemoveCouponUseCase,
      mockCalculateCartTotalsUseCase,
      mockSyncCartUseCase,
    );
  });

  tearDown(() {
    cartCubit.close();
  });

  group('CartCubit', () {
    test('initial state is CartState.initial', () {
      expect(cartCubit.state, equals(const CartState.initial()));
    });

    group('initializeCart', () {
      final userId = 'roshdology123';
      final cart = Cart(
        id: 'cart_1',
        userId: userId,
        items: [],
        summary: CartSummary.empty(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      blocTest<CartCubit, CartState>(
        'emits [loading, empty] when cart initialization succeeds with empty cart',
        build: () {
          when(mockGetCartUseCase(any))
              .thenAnswer((_) async => Right(cart));
          return cartCubit;
        },
        act: (cubit) => cubit.initializeCart(userId),
        expect: () => [
          const CartState.loading(),
          const CartState.empty(),
        ],
      );

      blocTest<CartCubit, CartState>(
        'emits [loading, error] when cart initialization fails',
        build: () {
          when(mockGetCartUseCase(any)).thenAnswer((_) async =>
              Left(ServerFailure(message: 'Failed to load cart', code: '500')));
          return cartCubit;
        },
        act: (cubit) => cubit.initializeCart(userId),
        expect: () => [
          const CartState.loading(),
          isA<CartState>()
              .having((state) => state.isError, 'isError', isNotNull)
              .having((state) => state.error?.message, 'failure message', 'Failed to load cart')
              .having((state) => state.error?.code, 'failure code', '500')
              .having((state) => state.canRetry, 'canRetry', true)
              .having((state) => state.cart, 'cart', isNull),

        ],
      );

      blocTest<CartCubit, CartState>(
        'emits [loading, loaded] with migrated cart for guest cart with authenticated user',
        build: () {
          final guestCart = Cart(
            id: 'guest_cart',
            userId: 'guest',
            items: [],
            summary: CartSummary.empty(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          when(mockGetCartUseCase(any))
              .thenAnswer((_) async => Right(guestCart));
          return cartCubit;
        },
        act: (cubit) => cubit.initializeCart(userId),
        expect: () => [
          const CartState.loading(),
          isA<CartState>()
              .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
              .having((state) => state.cart?.userId, 'cart userId', userId),
        ],
      );
    });

group('addToCart', () {
  final userId = 'roshdology123';
  
  blocTest<CartCubit, CartState>(
    'emits optimistic loaded state when adding item to empty cart',
    build: () {
      // Mock should return a cart with the added item
      final cartWithItem = Cart(
        id: 'cart_1',
        userId: userId,
        items: [
          CartItem(
            id: 'cart_item_1',
            productId: 1,
            productTitle: 'Test Product',
            productImage: 'image_url',
            price: 10.0,
            quantity: 1,
            addedAt: DateTime.now(),
            updatedAt: DateTime.now(),
            lastPriceCheck: DateTime.now(),
            originalPrice: 10.0,
            maxQuantity: 999,
            selectedVariants: {},
            isAvailable: true,
            inStock: true,
          ),
        ],
        summary: CartSummary(
          subtotal: 10.0,
          totalTax: 0.8,
          total: 10.8,
          shippingCost: 0.0,
          totalItems: 1,
          totalQuantity: 1,
          lastCalculated: DateTime.now(),
          totalDiscount: 0.0,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      when(mockAddToCartUseCase(any))
          .thenAnswer((_) async => Right(cartWithItem));
      return cartCubit;
    },
    // Start from empty state instead of initial
    seed: () => const CartState.empty(),
    act: (cubit) => cubit.addToCart(
      productId: 1,
      productTitle: 'Test Product',
      productImage: 'image_url',
      price: 10.0,
      quantity: 1,
    ),
    expect: () => [
      // First state: optimistic update with the item added
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', true)
          .having((state) => state.cart?.items.length, 'items count', 1),
      // Second state: confirmed by server
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', false)
          .having((state) => state.cart?.items.length, 'items count', 1),
    ],
  );

  blocTest<CartCubit, CartState>(
    'reverts to refresh on failure after optimistic update',
    build: () {
      final emptyCart = Cart(
        id: 'cart_1',
        userId: userId,
        items: [],
        summary: CartSummary.empty(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      when(mockAddToCartUseCase(any)).thenAnswer((_) async =>
          Left(ServerFailure(message: 'Failed to add item', code: '500')));
      when(mockGetCartUseCase(any))
          .thenAnswer((_) async => Right(emptyCart));
      return cartCubit;
    },
    // Start from empty state
    seed: () => const CartState.empty(),
    act: (cubit) => cubit.addToCart(
      productId: 1,
      productTitle: 'Test Product',
      productImage: 'image_url',
      price: 10.0,
      quantity: 1,
    ),
    expect: () => [
        isA<CartState>()
        .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
        .having((state) => state.isOptimistic, 'isOptimistic', true)
        .having((state) => state.cart?.items.length, 'items count', 1),
    isA<CartState>()
        .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
        .having((state) => state.isRefreshing, 'isRefreshing', true)
        .having((state) => state.isOptimistic, 'isOptimistic', false),
      // Loading state during refresh
      const CartState.loading(),
      const CartState.empty(),
    ],
  );
});
group('applyCoupon', () {
  final userId = 'roshdology123';
  final cart = Cart(
    id: 'cart_1',
    userId: userId,
    items: [
      CartItem(
        id: 'item_1',
        productId: 1,
        productTitle: 'Test Product',
        productImage: 'image_url',
        price: 100.0,
        quantity: 1,
        addedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastPriceCheck: DateTime.now(),
        originalPrice: 100.0,
        maxQuantity: 10,
        selectedVariants: {},
        isAvailable: true,
        inStock: true,
      ),
    ],
    summary: CartSummary(
      subtotal: 100.0,
      totalTax: 8.0,
      total: 108.0,
      shippingCost: 0.0,
      totalItems: 1,
      totalQuantity: 1,
      lastCalculated: DateTime.now(),
      totalDiscount: 0.0,
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  blocTest<CartCubit, CartState>(
    'emits optimistic loaded state with estimated discount',
    build: () {
      // Mock should return cart with coupon applied
      final cartWithCoupon = cart.copyWith(
        summary: cart.summary.copyWith(
          appliedCouponCode: 'SAVE10',
          couponDiscount: 10.0,
          total: 98.0, // 108 - 10 discount
        ),
      );
      
      when(mockApplyCouponUseCase(any))
          .thenAnswer((_) async => Right(cartWithCoupon));
      return cartCubit;
    },
    seed: () => CartState.loaded(cart: cart),
    act: (cubit) => cubit.applyCoupon('SAVE10'),
    expect: () => [
      // First state: optimistic update with estimated discount
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', true)
          .having((state) => state.cart?.summary.couponDiscount, 'coupon discount', 10.0)
          .having((state) => state.cart?.summary.total, 'total with discount', 98.0),
      // Second state: confirmed by server
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', false)
          .having((state) => state.cart?.summary.couponDiscount, 'coupon discount', 10.0)
          .having((state) => state.cart?.summary.total, 'total with discount', 98.0),
    ],
  );

  blocTest<CartCubit, CartState>(
    'reverts to refresh on coupon application failure',
    build: () {
      when(mockApplyCouponUseCase(any)).thenAnswer((_) async =>
          Left(ServerFailure(
              message: 'Invalid coupon', code: 'COUPON_NOT_FOUND')));
      when(mockGetCartUseCase(any))
          .thenAnswer((_) async => Right(cart));
      return cartCubit;
    },
    seed: () => CartState.loaded(cart: cart),
    act: (cubit) => cubit.applyCoupon('INVALID'),
    expect: () => [
      // First state: optimistic update with estimated discount
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', true),
      // Second state: refreshing after failure
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isRefreshing, 'isRefreshing', true),
      // Third state: loading during refresh
      const CartState.loading(),
      // Final state: loaded without coupon after refresh
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded after refresh', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', false)
          .having((state) => state.cart?.summary.couponDiscount, 'coupon discount', null),
    ],
  );
});
group('updateQuantity', () {
  final userId = 'roshdology123';
  final cart = Cart(
    id: 'cart_1',
    userId: userId,
    items: [
      CartItem(
        id: 'item_1',
        productId: 1,
        productTitle: 'Test Product',
        productImage: 'image_url',
        price: 10.0,
        quantity: 1,
        addedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastPriceCheck: DateTime.now(),
        originalPrice: 10.0,
        maxQuantity: 10,
        selectedVariants: {},
        isAvailable: true,
        inStock: true,
      ),
    ],
    summary: CartSummary(
      subtotal: 10.0,
      totalTax: 0.8,
      total: 10.8,
      shippingCost: 0.0,
      totalItems: 1,
      totalQuantity: 1,
      lastCalculated: DateTime.now(),
      totalDiscount: 0.0,
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  blocTest<CartCubit, CartState>(
    'emits optimistic loaded state with updated quantity',
    build: () {
      // Mock should return cart with updated quantity
      final updatedCart = cart.copyWith(
        items: [
          cart.items.first.copyWith(quantity: 2),
        ],
        summary: CartSummary(
          subtotal: 20.0, 
          totalTax: 1.6,  
          total: 21.6,    
          shippingCost: 0.0,
          totalItems: 1,
          totalQuantity: 2,
          lastCalculated: DateTime.now(),
          totalDiscount: 0.0,
        ),
      );
      
      when(mockUpdateCartItemUseCase(any))
          .thenAnswer((_) async => Right(updatedCart));
      return cartCubit;
    },
    seed: () => CartState.loaded(cart: cart),
    act: (cubit) => cubit.updateQuantity('item_1', 2),
    wait: const Duration(milliseconds: 400), // Wait for debounce
    expect: () => [
      // First state: optimistic update
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', true)
          .having((state) => state.cart?.items.first.quantity, 'updated quantity', 2)
          .having((state) => state.cart?.summary.total, 'updated total', 21.6),
      // Second state: confirmed by server
      isA<CartState>()
          .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
          .having((state) => state.isOptimistic, 'isOptimistic', false)
          .having((state) => state.cart?.items.first.quantity, 'updated quantity', 2)
          .having((state) => state.cart?.summary.total, 'updated total', 21.6),
    ],
  );
});

group('removeFromCart', () {
  final userId = 'roshdology123';
  final cart = Cart(
    id: 'cart_1',
    userId: userId,
    items: [
      CartItem(
        id: 'item_1',
        productId: 1,
        productTitle: 'Test Product',
        productImage: 'image_url',
        price: 10.0,
        quantity: 1,
        addedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastPriceCheck: DateTime.now(),
        originalPrice: 10.0,
        maxQuantity: 10,
        selectedVariants: {},
        isAvailable: true,
        inStock: true,
      ),
    ],
    summary: CartSummary(
      subtotal: 10.0,
      totalTax: 0.8,
      total: 10.8,
      shippingCost: 0.0,
      totalItems: 1,
      totalQuantity: 1,
      lastCalculated: DateTime.now(),
      totalDiscount: 0.0,
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  blocTest<CartCubit, CartState>(
    'emits optimistic empty state when removing last item',
    build: () {
      // Mock should return empty cart
      final emptyCart = cart.copyWith(
        items: [],
        summary: CartSummary.empty(),
      );
      
      when(mockRemoveFromCartUseCase(any))
          .thenAnswer((_) async => Right(emptyCart));
      return cartCubit;
    },
    seed: () => CartState.loaded(cart: cart),
    act: (cubit) => cubit.removeFromCart('item_1'),
    expect: () => [
      // First state: optimistic empty
      isA<CartState>()
          .having((state) => state.isEmpty, 'isEmpty state', true)
          .having((state) => state.isOptimistic, 'isOptimistic', true),
      // Second state: confirmed empty
      isA<CartState>()
          .having((state) => state.isEmpty, 'isEmpty state', true)
          .having((state) => state.isOptimistic, 'isOptimistic', false),
    ],
  );
});
    group('clearCart', () {
      final userId = 'roshdology123';
      final cart = Cart(
        id: 'cart_1',
        userId: userId,
        items: [
          CartItem(
            id: 'item_1',
            productId: 1,
            productTitle: 'Test Product',
            productImage: 'image_url',
            price: 10.0,
            quantity: 1,
            addedAt: DateTime.now(),
            updatedAt: DateTime.now(),
            lastPriceCheck: DateTime.now(),
            originalPrice: 10.0,
            maxQuantity: 10,
            selectedVariants: {},
            isAvailable: true,
            inStock: true,
          ),
        ],
        summary: CartSummary(
          subtotal: 10.0,
          totalTax: 0.8,
          total: 10.8,
          shippingCost: 0.0,
          totalItems: 1,
          totalQuantity: 1,
          lastCalculated: DateTime.now(),
          totalDiscount: 0.0,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      blocTest<CartCubit, CartState>(
        'emits empty state when clearing cart succeeds',
        build: () {
          when(mockClearCartUseCase(any))
              .thenAnswer((_) async => const Right(null));
          return cartCubit;
        },
        seed: () => CartState.loaded(cart: cart),
        act: (cubit) => cubit.clearCart(showConfirmation: false),
        expect: () => [
          isA<CartState>()
              .having((state) => state.isLoaded, 'isLoaded state', isNotNull)
              .having((state) => state.isLoading, 'isUpdating', true),
          const CartState.empty(),
        ],
      );
    });
  });
}