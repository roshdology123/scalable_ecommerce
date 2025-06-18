import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_summary.dart';

part 'cart_summary_state.freezed.dart';

@freezed
class CartSummaryState with _$CartSummaryState {
  const factory CartSummaryState.initial() = _Initial;

  const factory CartSummaryState.loading() = _Loading;

  const factory CartSummaryState.loaded({
    required CartSummary summary,
    @Default(false) bool isCalculating,
    @Default(false) bool isApplyingCoupon,
    String? selectedShippingMethod,
    String? appliedCouponCode,
    List<String>? availableShippingMethods,
    Map<String, double>? shippingCosts,
  }) = _Loaded;

  const factory CartSummaryState.error({
    required Failure failure,
    CartSummary? summary,
    @Default(false) bool canRetry,
    String? failedAction,
  }) = _Error;

  const factory CartSummaryState.calculating({
    required CartSummary currentSummary,
    @Default('Calculating totals...') String message,
    @Default(0.0) double progress,
  }) = _Calculating;
}

// Helper extensions
extension CartSummaryStateX on CartSummaryState {
  bool get isLoading => maybeWhen(
    loading: () => true,
    calculating: (_, __, ___) => true,
    loaded: (_, isCalculating, __, ___, ____, _____, ______) => isCalculating,
    orElse: () => false,
  );

  CartSummary? get summary => maybeWhen(
    loaded: (summary, _, __, ___, ____, _____, ______) => summary,
    error: (_, summary, __, ___) => summary,
    calculating: (summary, _, __) => summary,
    orElse: () => null,
  );

  bool get hasError => maybeWhen(
    error: (_, __, ___, ____) => true,
    orElse: () => false,
  );

  bool get isEmpty => summary?.isEmpty ?? true;

  double get total => summary?.total ?? 0.0;

  String get formattedTotal => summary?.formattedTotal ?? '\$0.00';
}