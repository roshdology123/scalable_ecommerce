import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_summary.dart';
import '../../domain/usecases/calculate_cart_totals_usecase.dart';
import 'cart_summary_state.dart';

@injectable
class CartSummaryCubit extends Cubit<CartSummaryState> {
  final CalculateCartTotalsUseCase _calculateCartTotalsUseCase;
  final AppLogger _logger = AppLogger();

  String? _currentUserId;
  String? _selectedShippingMethod;
  String? _appliedCouponCode;

  CartSummaryCubit(this._calculateCartTotalsUseCase)
      : super(const CartSummaryState.initial()) {
    _logger.logBusinessLogic(
      'cart_summary_cubit_initialized',
      'success',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:08:39',
      },
    );
  }

  /// Update cart summary from cart data
  void updateFromCart(Cart cart) {
    _currentUserId = cart.userId;
    _appliedCouponCode = cart.summary.appliedCouponCode;
    _selectedShippingMethod = cart.summary.selectedShippingMethod;

    _logger.logBusinessLogic(
      'cart_summary_updated_from_cart',
      'success',
      {
        'cart_id': cart.id,
        'items_count': cart.items.length,
        'subtotal': cart.summary.subtotal,
        'total': cart.summary.total,
        'has_coupon': cart.summary.hasCouponApplied,
        'shipping_method': _selectedShippingMethod,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:08:39',
      },
    );

    emit(CartSummaryState.loaded(
      summary: cart.summary,
      selectedShippingMethod: _selectedShippingMethod,
      appliedCouponCode: _appliedCouponCode,
    ));
  }

  /// Calculate cart totals with specific shipping method
  Future<void> calculateWithShipping(String shippingMethodId) async {
    final startTime = DateTime.now();

    _logger.logUserAction('calculate_with_shipping_started', {
      'shipping_method_id': shippingMethodId,
      'current_total': state.summary?.total,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    final currentSummary = state.summary;
    if (currentSummary == null) {
      _logger.w('Cannot calculate shipping without current summary');
      return;
    }

    _selectedShippingMethod = shippingMethodId;

    emit(CartSummaryState.calculating(
      currentSummary: currentSummary,
      message: 'Calculating shipping costs...',
      progress: 0.5,
    ));

    final result = await _calculateCartTotalsUseCase(CalculateCartTotalsParams(
      shippingMethodId: shippingMethodId,
      couponCode: _appliedCouponCode,
      userId: _currentUserId,
    ));

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'calculate_with_shipping_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'shipping_method_id': shippingMethodId,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        emit(CartSummaryState.error(
          failure: failure,
          summary: currentSummary,
          canRetry: true,
          failedAction: 'calculate_shipping',
        ));
      },
          (summary) {
        _logger.logBusinessLogic(
          'calculate_with_shipping_success',
          'completed',
          {
            'shipping_method_id': shippingMethodId,
            'shipping_cost': summary.shippingCost,
            'new_total': summary.total,
            'is_free_shipping': summary.isFreeShipping,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        emit(CartSummaryState.loaded(
          summary: summary,
          selectedShippingMethod: shippingMethodId,
          appliedCouponCode: _appliedCouponCode,
        ));
      },
    );
  }

  /// Calculate cart totals with coupon
  Future<void> calculateWithCoupon(String couponCode) async {
    final startTime = DateTime.now();

    _logger.logUserAction('calculate_with_coupon_started', {
      'coupon_code': couponCode,
      'current_total': state.summary?.total,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    final currentSummary = state.summary;
    if (currentSummary == null) {
      _logger.w('Cannot calculate coupon without current summary');
      return;
    }

    _appliedCouponCode = couponCode;

    emit(CartSummaryState.calculating(
      currentSummary: currentSummary,
      message: 'Applying coupon...',
      progress: 0.7,
    ));

    final result = await _calculateCartTotalsUseCase(CalculateCartTotalsParams(
      shippingMethodId: _selectedShippingMethod,
      couponCode: couponCode,
      userId: _currentUserId,
    ));

    final duration = DateTime.now().difference(startTime);

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'calculate_with_coupon_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'coupon_code': couponCode,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        // Reset coupon code on failure
        _appliedCouponCode = null;

        emit(CartSummaryState.error(
          failure: failure,
          summary: currentSummary,
          canRetry: true,
          failedAction: 'calculate_coupon',
        ));
      },
          (summary) {
        _logger.logBusinessLogic(
          'calculate_with_coupon_success',
          'completed',
          {
            'coupon_code': couponCode,
            'discount_amount': summary.couponDiscount,
            'new_total': summary.total,
            'total_savings': summary.totalSavings,
            'duration_ms': duration.inMilliseconds,
            'user': 'roshdology123',
          },
        );

        emit(CartSummaryState.loaded(
          summary: summary,
          selectedShippingMethod: _selectedShippingMethod,
          appliedCouponCode: couponCode,
        ));
      },
    );
  }

  /// Remove coupon and recalculate
  Future<void> removeCoupon() async {
    if (_appliedCouponCode == null) return;

    final couponToRemove = _appliedCouponCode!;
    _appliedCouponCode = null;

    _logger.logUserAction('remove_coupon_calculate_started', {
      'removed_coupon': couponToRemove,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    final currentSummary = state.summary;
    if (currentSummary == null) return;

    emit(CartSummaryState.calculating(
      currentSummary: currentSummary,
      message: 'Removing coupon...',
      progress: 0.3,
    ));

    final result = await _calculateCartTotalsUseCase(CalculateCartTotalsParams(
      shippingMethodId: _selectedShippingMethod,
      couponCode: null,
      userId: _currentUserId,
    ));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'remove_coupon_calculate_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'removed_coupon': couponToRemove,
            'user': 'roshdology123',
          },
        );

        // Restore coupon code on failure
        _appliedCouponCode = couponToRemove;

        emit(CartSummaryState.error(
          failure: failure,
          summary: currentSummary,
          canRetry: true,
          failedAction: 'remove_coupon',
        ));
      },
          (summary) {
        _logger.logUserAction('remove_coupon_calculate_success', {
          'removed_coupon': couponToRemove,
          'new_total': summary.total,
          'user': 'roshdology123',
        });

        emit(CartSummaryState.loaded(
          summary: summary,
          selectedShippingMethod: _selectedShippingMethod,
          appliedCouponCode: null,
        ));
      },
    );
  }

  /// Recalculate current totals
  Future<void> recalculate() async {
    _logger.logUserAction('cart_summary_recalculate', {
      'shipping_method': _selectedShippingMethod,
      'coupon_code': _appliedCouponCode,
      'user_id': _currentUserId ?? 'guest',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    final currentSummary = state.summary;
    if (currentSummary == null) return;

    emit(CartSummaryState.calculating(
      currentSummary: currentSummary,
      message: 'Updating totals...',
      progress: 0.0,
    ));

    final result = await _calculateCartTotalsUseCase(CalculateCartTotalsParams(
      shippingMethodId: _selectedShippingMethod,
      couponCode: _appliedCouponCode,
      userId: _currentUserId,
    ));

    result.fold(
          (failure) {
        _logger.logBusinessLogic(
          'cart_summary_recalculate_failed',
          'error',
          {
            'error': failure.message,
            'code': failure.code,
            'user': 'roshdology123',
          },
        );

        emit(CartSummaryState.error(
          failure: failure,
          summary: currentSummary,
          canRetry: true,
          failedAction: 'recalculate',
        ));
      },
          (summary) {
        _logger.logBusinessLogic(
          'cart_summary_recalculate_success',
          'completed',
          {
            'new_total': summary.total,
            'items_count': summary.totalItems,
            'user': 'roshdology123',
          },
        );

        emit(CartSummaryState.loaded(
          summary: summary,
          selectedShippingMethod: _selectedShippingMethod,
          appliedCouponCode: _appliedCouponCode,
        ));
      },
    );
  }

  /// Get promotional messages for current cart
  List<String> getPromotionalMessages() {
    final summary = state.summary;
    if (summary == null) return [];

    final messages = summary.promotionalMessages;

    _logger.logBusinessLogic(
      'promotional_messages_generated',
      'success',
      {
        'messages_count': messages.length,
        'messages': messages,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:08:39',
      },
    );

    return messages;
  }

  /// Check if free shipping threshold is met
  bool get qualifiesForFreeShipping => state.summary?.qualifiesForFreeShipping ?? false;

  /// Get amount needed for free shipping
  double get amountToFreeShipping => state.summary?.amountToFreeShipping ?? 0.0;

  /// Get current shipping method
  String? get selectedShippingMethod => _selectedShippingMethod;

  /// Get applied coupon code
  String? get appliedCouponCode => _appliedCouponCode;

  /// Update user context
  void updateUser(String? userId) {
    _currentUserId = userId;

    _logger.logUserAction('cart_summary_user_changed', {
      'new_user_id': userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });
  }

  @override
  Future<void> close() {
    _logger.logBusinessLogic(
      'cart_summary_cubit_closed',
      'cleanup',
      {
        'user_id': _currentUserId,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:08:39',
      },
    );

    return super.close();
  }
}