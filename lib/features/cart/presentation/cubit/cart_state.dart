import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.initial() = _Initial;

  const factory CartState.loading() = _Loading;

  const factory CartState.loaded({
    required Cart cart,
    @Default(false) bool isRefreshing,
    @Default(false) bool isUpdating,
    @Default(false) bool isSyncing,
    @Default(false) bool isOptimistic,
    String? pendingAction,
    CartItem? pendingItem,
    Map<String, bool>? itemsLoading,
  }) = _Loaded;

  const factory CartState.error({
    required Failure failure,
    Cart? cart,
    @Default(false) bool canRetry,
    String? failedAction,
    Map<String, dynamic>? actionContext,
  }) = _Error;

  const factory CartState.empty({
    @Default(false) bool isLoading,
    @Default(false) bool isOptimistic,
    String? message,
  }) = _Empty;

  const factory CartState.syncing({
    required Cart cart,
    @Default('Syncing cart...') String message,
    @Default(0.0) double progress,
  }) = _Syncing;

  const factory CartState.conflict({
    required Cart localCart,
    required Cart remoteCart,
    required List<String> conflictingFields,
    @Default('Cart sync conflict detected') String message,
  }) = _Conflict;



}

// Helper methods for CartState
extension CartStateX on CartState {
  Object? get isRefreshing => maybeWhen(
    loaded: (_, isRefreshing, __, ___, ____, _____, ______, _______) => isRefreshing,
    empty: (isLoading, isRefreshing, __) => isRefreshing,
    orElse: () => null,
  );


  bool get isLoading => maybeWhen(
    loading: () => true,
    loaded: (_, isRefreshing, isUpdating, __, ___, ____, _____,______,) =>
    isRefreshing || isUpdating,
    syncing: (_, __, ___) => true,
    empty: (isLoading, _,__) => isLoading,
    orElse: () => false,
  );
  Object? get isError => maybeWhen(
    error: (failure, _, __, ___, ____) => failure,
    orElse: () => null,
  );

  Object? get isLoaded => maybeWhen(
    loaded: (cart, _, __, ___, ____, _____, ______, _______) => cart,
    orElse: () => null,
  );
  bool get hasCart => maybeWhen(
    loaded: (cart, _, __, ___, ____, _____, ______,_______) => true,
    error: (_, cart, __, ___, ____) => cart != null,
    syncing: (cart, _, __) => true,
    conflict: (_, __, ___, ____) => true,
    orElse: () => false,
  );

  Cart? get cart => maybeWhen(
    loaded: (cart, _, __, ___, ____, _____, ______,_______) => cart,
    error: (_, cart, __, ___, ____) => cart,
    syncing: (cart, _, __) => cart,
    conflict: (localCart, _, __, ___) => localCart,
    orElse: () => null,
  );

  bool get isEmpty => cart?.isEmpty ?? true;

  bool get hasItems => cart?.hasItems ?? false;

  int get itemsCount => cart?.summary.totalQuantity ?? 0;

  double get total => cart?.summary.total ?? 0.0;

  bool get hasError => maybeWhen(
    error: (_, __, ___, ____, _____) => true,
    orElse: () => false,
  );

  Failure? get error => maybeWhen(
    error: (failure, _, __, ___, ____) => failure,
    orElse: () => null,
  );
  bool get isOptimistic => whenOrNull(
    loaded: (_, __, ___, ____, isOptimistic, _____, ______, _______) => isOptimistic,
    empty: (_, isOptimistic, __) => isOptimistic,
  ) ?? false;

  bool get hasConflicts => maybeWhen(
    conflict: (_, __, ___, ____) => true,
    orElse: () => false,
  );

  bool get canRetry => maybeWhen(
    error: (_, __, canRetry, ___, ____) => canRetry,
    orElse: () => false,
  );
}