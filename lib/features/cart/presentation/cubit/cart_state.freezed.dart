// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CartState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartStateCopyWith<$Res> {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) then) =
      _$CartStateCopyWithImpl<$Res, CartState>;
}

/// @nodoc
class _$CartStateCopyWithImpl<$Res, $Val extends CartState>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'CartState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements CartState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'CartState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements CartState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {Cart cart,
      bool isRefreshing,
      bool isUpdating,
      bool isSyncing,
      String? pendingAction,
      CartItem? pendingItem,
      Map<String, bool>? itemsLoading});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cart = null,
    Object? isRefreshing = null,
    Object? isUpdating = null,
    Object? isSyncing = null,
    Object? pendingAction = freezed,
    Object? pendingItem = freezed,
    Object? itemsLoading = freezed,
  }) {
    return _then(_$LoadedImpl(
      cart: null == cart
          ? _value.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as Cart,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingAction: freezed == pendingAction
          ? _value.pendingAction
          : pendingAction // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingItem: freezed == pendingItem
          ? _value.pendingItem
          : pendingItem // ignore: cast_nullable_to_non_nullable
              as CartItem?,
      itemsLoading: freezed == itemsLoading
          ? _value._itemsLoading
          : itemsLoading // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>?,
    ));
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(
      {required this.cart,
      this.isRefreshing = false,
      this.isUpdating = false,
      this.isSyncing = false,
      this.pendingAction,
      this.pendingItem,
      final Map<String, bool>? itemsLoading})
      : _itemsLoading = itemsLoading;

  @override
  final Cart cart;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  @JsonKey()
  final bool isSyncing;
  @override
  final String? pendingAction;
  @override
  final CartItem? pendingItem;
  final Map<String, bool>? _itemsLoading;
  @override
  Map<String, bool>? get itemsLoading {
    final value = _itemsLoading;
    if (value == null) return null;
    if (_itemsLoading is EqualUnmodifiableMapView) return _itemsLoading;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CartState.loaded(cart: $cart, isRefreshing: $isRefreshing, isUpdating: $isUpdating, isSyncing: $isSyncing, pendingAction: $pendingAction, pendingItem: $pendingItem, itemsLoading: $itemsLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            (identical(other.cart, cart) || other.cart == cart) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.pendingAction, pendingAction) ||
                other.pendingAction == pendingAction) &&
            (identical(other.pendingItem, pendingItem) ||
                other.pendingItem == pendingItem) &&
            const DeepCollectionEquality()
                .equals(other._itemsLoading, _itemsLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cart,
      isRefreshing,
      isUpdating,
      isSyncing,
      pendingAction,
      pendingItem,
      const DeepCollectionEquality().hash(_itemsLoading));

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) {
    return loaded(cart, isRefreshing, isUpdating, isSyncing, pendingAction,
        pendingItem, itemsLoading);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) {
    return loaded?.call(cart, isRefreshing, isUpdating, isSyncing,
        pendingAction, pendingItem, itemsLoading);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(cart, isRefreshing, isUpdating, isSyncing, pendingAction,
          pendingItem, itemsLoading);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements CartState {
  const factory _Loaded(
      {required final Cart cart,
      final bool isRefreshing,
      final bool isUpdating,
      final bool isSyncing,
      final String? pendingAction,
      final CartItem? pendingItem,
      final Map<String, bool>? itemsLoading}) = _$LoadedImpl;

  Cart get cart;
  bool get isRefreshing;
  bool get isUpdating;
  bool get isSyncing;
  String? get pendingAction;
  CartItem? get pendingItem;
  Map<String, bool>? get itemsLoading;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {Failure failure,
      Cart? cart,
      bool canRetry,
      String? failedAction,
      Map<String, dynamic>? actionContext});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
    Object? cart = freezed,
    Object? canRetry = null,
    Object? failedAction = freezed,
    Object? actionContext = freezed,
  }) {
    return _then(_$ErrorImpl(
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
      cart: freezed == cart
          ? _value.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as Cart?,
      canRetry: null == canRetry
          ? _value.canRetry
          : canRetry // ignore: cast_nullable_to_non_nullable
              as bool,
      failedAction: freezed == failedAction
          ? _value.failedAction
          : failedAction // ignore: cast_nullable_to_non_nullable
              as String?,
      actionContext: freezed == actionContext
          ? _value._actionContext
          : actionContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(
      {required this.failure,
      this.cart,
      this.canRetry = false,
      this.failedAction,
      final Map<String, dynamic>? actionContext})
      : _actionContext = actionContext;

  @override
  final Failure failure;
  @override
  final Cart? cart;
  @override
  @JsonKey()
  final bool canRetry;
  @override
  final String? failedAction;
  final Map<String, dynamic>? _actionContext;
  @override
  Map<String, dynamic>? get actionContext {
    final value = _actionContext;
    if (value == null) return null;
    if (_actionContext is EqualUnmodifiableMapView) return _actionContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CartState.error(failure: $failure, cart: $cart, canRetry: $canRetry, failedAction: $failedAction, actionContext: $actionContext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.cart, cart) || other.cart == cart) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry) &&
            (identical(other.failedAction, failedAction) ||
                other.failedAction == failedAction) &&
            const DeepCollectionEquality()
                .equals(other._actionContext, _actionContext));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure, cart, canRetry,
      failedAction, const DeepCollectionEquality().hash(_actionContext));

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) {
    return error(failure, cart, canRetry, failedAction, actionContext);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) {
    return error?.call(failure, cart, canRetry, failedAction, actionContext);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure, cart, canRetry, failedAction, actionContext);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements CartState {
  const factory _Error(
      {required final Failure failure,
      final Cart? cart,
      final bool canRetry,
      final String? failedAction,
      final Map<String, dynamic>? actionContext}) = _$ErrorImpl;

  Failure get failure;
  Cart? get cart;
  bool get canRetry;
  String? get failedAction;
  Map<String, dynamic>? get actionContext;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmptyImplCopyWith<$Res> {
  factory _$$EmptyImplCopyWith(
          _$EmptyImpl value, $Res Function(_$EmptyImpl) then) =
      __$$EmptyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isLoading, String? message});
}

/// @nodoc
class __$$EmptyImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$EmptyImpl>
    implements _$$EmptyImplCopyWith<$Res> {
  __$$EmptyImplCopyWithImpl(
      _$EmptyImpl _value, $Res Function(_$EmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? message = freezed,
  }) {
    return _then(_$EmptyImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$EmptyImpl implements _Empty {
  const _$EmptyImpl({this.isLoading = false, this.message});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? message;

  @override
  String toString() {
    return 'CartState.empty(isLoading: $isLoading, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmptyImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, message);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmptyImplCopyWith<_$EmptyImpl> get copyWith =>
      __$$EmptyImplCopyWithImpl<_$EmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) {
    return empty(isLoading, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) {
    return empty?.call(isLoading, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(isLoading, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _Empty implements CartState {
  const factory _Empty({final bool isLoading, final String? message}) =
      _$EmptyImpl;

  bool get isLoading;
  String? get message;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmptyImplCopyWith<_$EmptyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncingImplCopyWith<$Res> {
  factory _$$SyncingImplCopyWith(
          _$SyncingImpl value, $Res Function(_$SyncingImpl) then) =
      __$$SyncingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Cart cart, String message, double progress});
}

/// @nodoc
class __$$SyncingImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$SyncingImpl>
    implements _$$SyncingImplCopyWith<$Res> {
  __$$SyncingImplCopyWithImpl(
      _$SyncingImpl _value, $Res Function(_$SyncingImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cart = null,
    Object? message = null,
    Object? progress = null,
  }) {
    return _then(_$SyncingImpl(
      cart: null == cart
          ? _value.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as Cart,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$SyncingImpl implements _Syncing {
  const _$SyncingImpl(
      {required this.cart,
      this.message = 'Syncing cart...',
      this.progress = 0.0});

  @override
  final Cart cart;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final double progress;

  @override
  String toString() {
    return 'CartState.syncing(cart: $cart, message: $message, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncingImpl &&
            (identical(other.cart, cart) || other.cart == cart) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cart, message, progress);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncingImplCopyWith<_$SyncingImpl> get copyWith =>
      __$$SyncingImplCopyWithImpl<_$SyncingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) {
    return syncing(cart, message, progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) {
    return syncing?.call(cart, message, progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(cart, message, progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class _Syncing implements CartState {
  const factory _Syncing(
      {required final Cart cart,
      final String message,
      final double progress}) = _$SyncingImpl;

  Cart get cart;
  String get message;
  double get progress;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncingImplCopyWith<_$SyncingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConflictImplCopyWith<$Res> {
  factory _$$ConflictImplCopyWith(
          _$ConflictImpl value, $Res Function(_$ConflictImpl) then) =
      __$$ConflictImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {Cart localCart,
      Cart remoteCart,
      List<String> conflictingFields,
      String message});
}

/// @nodoc
class __$$ConflictImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$ConflictImpl>
    implements _$$ConflictImplCopyWith<$Res> {
  __$$ConflictImplCopyWithImpl(
      _$ConflictImpl _value, $Res Function(_$ConflictImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localCart = null,
    Object? remoteCart = null,
    Object? conflictingFields = null,
    Object? message = null,
  }) {
    return _then(_$ConflictImpl(
      localCart: null == localCart
          ? _value.localCart
          : localCart // ignore: cast_nullable_to_non_nullable
              as Cart,
      remoteCart: null == remoteCart
          ? _value.remoteCart
          : remoteCart // ignore: cast_nullable_to_non_nullable
              as Cart,
      conflictingFields: null == conflictingFields
          ? _value._conflictingFields
          : conflictingFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ConflictImpl implements _Conflict {
  const _$ConflictImpl(
      {required this.localCart,
      required this.remoteCart,
      required final List<String> conflictingFields,
      this.message = 'Cart sync conflict detected'})
      : _conflictingFields = conflictingFields;

  @override
  final Cart localCart;
  @override
  final Cart remoteCart;
  final List<String> _conflictingFields;
  @override
  List<String> get conflictingFields {
    if (_conflictingFields is EqualUnmodifiableListView)
      return _conflictingFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conflictingFields);
  }

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'CartState.conflict(localCart: $localCart, remoteCart: $remoteCart, conflictingFields: $conflictingFields, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConflictImpl &&
            (identical(other.localCart, localCart) ||
                other.localCart == localCart) &&
            (identical(other.remoteCart, remoteCart) ||
                other.remoteCart == remoteCart) &&
            const DeepCollectionEquality()
                .equals(other._conflictingFields, _conflictingFields) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, localCart, remoteCart,
      const DeepCollectionEquality().hash(_conflictingFields), message);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConflictImplCopyWith<_$ConflictImpl> get copyWith =>
      __$$ConflictImplCopyWithImpl<_$ConflictImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)
        loaded,
    required TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)
        error,
    required TResult Function(bool isLoading, String? message) empty,
    required TResult Function(Cart cart, String message, double progress)
        syncing,
    required TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)
        conflict,
  }) {
    return conflict(localCart, remoteCart, conflictingFields, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult? Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult? Function(bool isLoading, String? message)? empty,
    TResult? Function(Cart cart, String message, double progress)? syncing,
    TResult? Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
  }) {
    return conflict?.call(localCart, remoteCart, conflictingFields, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            Cart cart,
            bool isRefreshing,
            bool isUpdating,
            bool isSyncing,
            String? pendingAction,
            CartItem? pendingItem,
            Map<String, bool>? itemsLoading)?
        loaded,
    TResult Function(Failure failure, Cart? cart, bool canRetry,
            String? failedAction, Map<String, dynamic>? actionContext)?
        error,
    TResult Function(bool isLoading, String? message)? empty,
    TResult Function(Cart cart, String message, double progress)? syncing,
    TResult Function(Cart localCart, Cart remoteCart,
            List<String> conflictingFields, String message)?
        conflict,
    required TResult orElse(),
  }) {
    if (conflict != null) {
      return conflict(localCart, remoteCart, conflictingFields, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_Empty value) empty,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Conflict value) conflict,
  }) {
    return conflict(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_Empty value)? empty,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Conflict value)? conflict,
  }) {
    return conflict?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_Empty value)? empty,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Conflict value)? conflict,
    required TResult orElse(),
  }) {
    if (conflict != null) {
      return conflict(this);
    }
    return orElse();
  }
}

abstract class _Conflict implements CartState {
  const factory _Conflict(
      {required final Cart localCart,
      required final Cart remoteCart,
      required final List<String> conflictingFields,
      final String message}) = _$ConflictImpl;

  Cart get localCart;
  Cart get remoteCart;
  List<String> get conflictingFields;
  String get message;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConflictImplCopyWith<_$ConflictImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
