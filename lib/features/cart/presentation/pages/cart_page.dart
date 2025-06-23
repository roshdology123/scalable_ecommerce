import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/bloc_providers.dart';
import '../../../../core/utils/app_logger.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../cubit/cart_summary_cubit.dart';
import '../widgets/cart_empty_widget.dart';
import '../widgets/cart_error_widget.dart';
import '../widgets/cart_item_list.dart';
import '../widgets/cart_loading_widget.dart';
import '../widgets/cart_summary_widget.dart';
import '../widgets/cart_action_buttons.dart';
import '../widgets/coupon_input_widget.dart';

class CartPage extends StatefulWidget {
  final String? userId;
  final bool showAppBar;
  final VoidCallback? onCheckoutPressed;
  final VoidCallback? onContinueShoppingPressed;

  const CartPage({
    super.key,
    this.userId,
    this.showAppBar = true,
    this.onCheckoutPressed,
    this.onContinueShoppingPressed,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with AutomaticKeepAliveClientMixin {
  final AppLogger _logger = AppLogger();
  late final ScrollController _scrollController;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // 🔥 FORCE AUTHENTICATED CONTEXT for roshdology123
    const authenticatedUserId = 'roshdology123';

    _logger.logUserAction('cart_page_opened', {
      'provided_user_id': widget.userId,
      'forced_user_id': authenticatedUserId,
      'show_app_bar': widget.showAppBar,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 14:00:15',
    });

    // Initialize cart with forced authentication
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartCubit = context.read<CartCubit>();

      // Force authentication state
      cartCubit.setUserAuthentication(authenticatedUserId, true);

      // Force authenticated cart
      cartCubit.forceAuthenticatedCart();

      // Initialize cart
      cartCubit.initializeCart(authenticatedUserId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    _logger.logUserAction('cart_page_closed', {
      'user_id': widget.userId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: widget.showAppBar ? _buildAppBar(context) : null,
      body: BlocConsumer<CartCubit, CartState>(
        listener: _handleCartStateChanges,
        builder: (context, state) {
          return RefreshIndicator(
            key: _refreshKey,
            onRefresh: _handleRefresh,
            child: _buildBody(context, state),
          );
        },
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final itemsCount = state.itemsCount;
          return Text(
            itemsCount > 0
                ? 'Cart ($itemsCount ${itemsCount == 1 ? 'item' : 'items'})'
                : 'Cart',
          );
        },
      ),
      actions: [
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.hasItems && !state.isLoading) {
              return PopupMenuButton<String>(
                onSelected: _handleMenuAction,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'refresh',
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Refresh Cart'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  if (widget.userId != null)
                    const PopupMenuItem(
                      value: 'sync',
                      child: ListTile(
                        leading: Icon(Icons.sync),
                        title: Text('Sync Cart'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      title: Text('Clear Cart', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, CartState state) {
    return state.when(
      initial: () => const CartLoadingWidget(),
      loading: () => const CartLoadingWidget(),
      loaded: (cart, isRefreshing, isUpdating, isSyncing, isOptimistic, pendingAction, pendingItem, itemsLoading) {
        // Update cart summary
        context.read<CartSummaryCubit>().updateFromCart(cart);

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Cart items
            SliverToBoxAdapter(
              child: CartItemList(
                cart: cart,
                isUpdating: isUpdating,
                itemsLoading: itemsLoading ?? {},
                onQuantityChanged: _handleQuantityChanged,
                onVariantChanged: _handleVariantChanged,
                onRemoveItem: _handleRemoveItem,
              ),
            ),

            // Coupon section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CouponInputWidget(
                  appliedCouponCode: cart.summary.appliedCouponCode,
                  onApplyCoupon: _handleApplyCoupon,
                  onRemoveCoupon: _handleRemoveCoupon,
                  isLoading: isUpdating,
                ),
              ),
            ),

            // Cart summary
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CartSummaryWidget(
                  initialSummary: cart.summary,
                  onShippingMethodChanged: _handleShippingMethodChanged,
                  showShippingOptions: true,
                  isOptimistic: isOptimistic,
                ),
              ),
            ),

            // Add some bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        );
      },
      error: (failure, cart, canRetry, failedAction, actionContext) {
        return CartErrorWidget(
          failure: failure,
          canRetry: canRetry,
          onRetry: _handleRetry,
          onContinueShopping: widget.onContinueShoppingPressed,
        );
      },
      empty: (isLoading, isOptimistic, message) {
        return CartEmptyWidget(
          message: message,
          isLoading: isLoading,
          onContinueShopping: widget.onContinueShoppingPressed,
        );
      },
      syncing: (cart, message, progress) {
        // Show cart with sync overlay
        context.read<CartSummaryCubit>().updateFromCart(cart);

        return Stack(
          children: [
            _buildLoadedState(cart, false, false, false, null, null, {}),
            Container(
              color: Colors.black26,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(message),
                        if (progress > 0) ...[
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: progress),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      conflict: (localCart, remoteCart, conflictingFields, message) {
        return _buildConflictResolution(localCart, remoteCart, conflictingFields, message);
      },
    );
  }

  Widget _buildLoadedState(
      cart,
      bool isRefreshing,
      bool isUpdating,
      bool isSyncing,
      String? pendingAction,
      pendingItem,
      Map<String, bool> itemsLoading,
      ) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: CartItemList(
            cart: cart,
            isUpdating: isUpdating,
            itemsLoading: itemsLoading,
            onQuantityChanged: _handleQuantityChanged,
            onVariantChanged: _handleVariantChanged,
            onRemoveItem: _handleRemoveItem,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CouponInputWidget(
              appliedCouponCode: cart.summary.appliedCouponCode,
              onApplyCoupon: _handleApplyCoupon,
              onRemoveCoupon: _handleRemoveCoupon,
              isLoading: isUpdating,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CartSummaryWidget(
              initialSummary: cart.summary,
              onShippingMethodChanged: _handleShippingMethodChanged,
              showShippingOptions: true,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildConflictResolution(
      cart,
      remoteCart,
      List<String> conflictingFields,
      String message,
      ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Cart Sync Conflict',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Conflicting fields: ${conflictingFields.join(', ')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _resolveConflict(cart),
                  child: const Text('Keep Local'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _resolveConflict(remoteCart),
                  child: const Text('Use Server'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (!state.hasItems || state.hasError) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CartActionButtons(
                cart: state.cart!,
                isLoading: state.isLoading,
                onCheckout: _handleCheckout,
                onContinueShopping: widget.onContinueShoppingPressed,
              ),
            ),
          ),
        );
      },
    );
  }

  // Event Handlers

  void _handleCartStateChanges(BuildContext context, CartState state) {
    state.whenOrNull(
      error: (failure, cart, canRetry, failedAction, actionContext) {
        _showErrorSnackBar(context, failure.message, canRetry);
      },
    );
  }

  Future<void> _handleRefresh() async {
    _logger.logUserAction('cart_refresh_triggered', {
      'user_id': widget.userId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    await context.read<CartCubit>().refresh();
  }

  void _handleMenuAction(String action) {
    _logger.logUserAction('cart_menu_action', {
      'action': action,
      'user_id': widget.userId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    switch (action) {
      case 'refresh':
        context.read<CartCubit>().refresh();
        break;
      case 'sync':
        context.read<CartCubit>().syncCart();
        break;
      case 'clear':
        _showClearCartConfirmation();
        break;
    }
  }

  void _handleQuantityChanged(String itemId, int newQuantity) {
    _logger.logUserAction('cart_quantity_changed', {
      'item_id': itemId,
      'new_quantity': newQuantity,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    context.read<CartCubit>().updateQuantity(itemId, newQuantity);
  }

  void _handleVariantChanged(String itemId, {String? color, String? size}) {
    _logger.logUserAction('cart_variant_changed', {
      'item_id': itemId,
      'new_color': color,
      'new_size': size,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    context.read<CartCubit>().updateVariants(
      itemId,
      selectedColor: color,
      selectedSize: size,
    );
  }

  void _handleRemoveItem(String itemId) {
    _logger.logUserAction('cart_remove_item_triggered', {
      'item_id': itemId,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    context.read<CartCubit>().removeFromCart(itemId);
  }

  void _handleApplyCoupon(String couponCode) {
    // 🔥 Validate coupon code before attempting to apply
    if (couponCode.trim().isEmpty) {
      _showErrorSnackBar(context, 'Please enter a coupon code', false);
      return;
    }

    // 🔥 Check if user is authenticated for coupon application
    if (widget.userId == null || widget.userId!.isEmpty) {
      _showErrorSnackBar(
          context,
          'Please log in to apply coupons. Guest users cannot use coupons.',
          false
      );
      return;
    }

    _logger.logUserAction('cart_apply_coupon_triggered', {
      'coupon_code': couponCode,
      'user_id': widget.userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-22 12:55:48',
    });

    context.read<CartCubit>().applyCoupon(couponCode);
  }

// Also update the error display method:
  void _showErrorSnackBar(BuildContext context, String message, bool canRetry) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // 🔥 Clear previous snackbars

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: canRetry
            ? SnackBarAction(
          label: 'Retry',
          onPressed: _handleRetry,
        )
            : null,
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4), // 🔥 Longer duration for better UX
        behavior: SnackBarBehavior.floating, // 🔥 Better visual feedback
      ),
    );
  }

  void _handleRemoveCoupon(String couponCode) {
    _logger.logUserAction('cart_remove_coupon_triggered', {
      'coupon_code': couponCode,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    context.read<CartCubit>().removeCoupon(couponCode);
  }

  void _handleShippingMethodChanged(String shippingMethodId) {
    _logger.logUserAction('cart_shipping_method_changed', {
      'shipping_method_id': shippingMethodId,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    context.read<CartSummaryCubit>().calculateWithShipping(shippingMethodId);
  }

  void _handleCheckout() {
    final cart = context.read<CartCubit>().currentCart;
    if (cart == null) return;

    _logger.logUserAction('cart_checkout_initiated', {
      'cart_id': cart.id,
      'items_count': cart.items.length,
      'total': cart.summary.total,
      'user_id': widget.userId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    if (widget.onCheckoutPressed != null) {
      widget.onCheckoutPressed!();
    } else {
      // Default checkout navigation
      context.push('/cart/checkout');
    }
  }

  void _handleRetry() {
    _logger.logUserAction('cart_retry_action', {
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    context.read<CartCubit>().retryFailedAction();
  }

  void _resolveConflict(cart) {
    _logger.logUserAction('cart_conflict_resolved', {
      'selected_cart': cart.id,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    // For now, just emit loaded state with selected cart
    context.read<CartCubit>().emit(CartState.loaded(cart: cart));
  }

  void _showClearCartConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().clearCart(showConfirmation: false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear Cart'),
          ),
        ],
      ),
    );
  }

}