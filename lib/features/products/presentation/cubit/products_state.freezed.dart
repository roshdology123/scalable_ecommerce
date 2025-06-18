// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProductsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductsInitial value) initial,
    required TResult Function(ProductsLoading value) loading,
    required TResult Function(ProductsLoaded value) loaded,
    required TResult Function(ProductsLoadingMore value) loadingMore,
    required TResult Function(ProductsEmpty value) empty,
    required TResult Function(ProductsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductsInitial value)? initial,
    TResult? Function(ProductsLoading value)? loading,
    TResult? Function(ProductsLoaded value)? loaded,
    TResult? Function(ProductsLoadingMore value)? loadingMore,
    TResult? Function(ProductsEmpty value)? empty,
    TResult? Function(ProductsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductsInitial value)? initial,
    TResult Function(ProductsLoading value)? loading,
    TResult Function(ProductsLoaded value)? loaded,
    TResult Function(ProductsLoadingMore value)? loadingMore,
    TResult Function(ProductsEmpty value)? empty,
    TResult Function(ProductsError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsStateCopyWith<$Res> {
  factory $ProductsStateCopyWith(
          ProductsState value, $Res Function(ProductsState) then) =
      _$ProductsStateCopyWithImpl<$Res, ProductsState>;
}

/// @nodoc
class _$ProductsStateCopyWithImpl<$Res, $Val extends ProductsState>
    implements $ProductsStateCopyWith<$Res> {
  _$ProductsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ProductsInitialImplCopyWith<$Res> {
  factory _$$ProductsInitialImplCopyWith(_$ProductsInitialImpl value,
          $Res Function(_$ProductsInitialImpl) then) =
      __$$ProductsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductsInitialImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsInitialImpl>
    implements _$$ProductsInitialImplCopyWith<$Res> {
  __$$ProductsInitialImplCopyWithImpl(
      _$ProductsInitialImpl _value, $Res Function(_$ProductsInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductsInitialImpl implements ProductsInitial {
  const _$ProductsInitialImpl();

  @override
  String toString() {
    return 'ProductsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
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
    required TResult Function(ProductsInitial value) initial,
    required TResult Function(ProductsLoading value) loading,
    required TResult Function(ProductsLoaded value) loaded,
    required TResult Function(ProductsLoadingMore value) loadingMore,
    required TResult Function(ProductsEmpty value) empty,
    required TResult Function(ProductsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductsInitial value)? initial,
    TResult? Function(ProductsLoading value)? loading,
    TResult? Function(ProductsLoaded value)? loaded,
    TResult? Function(ProductsLoadingMore value)? loadingMore,
    TResult? Function(ProductsEmpty value)? empty,
    TResult? Function(ProductsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductsInitial value)? initial,
    TResult Function(ProductsLoading value)? loading,
    TResult Function(ProductsLoaded value)? loaded,
    TResult Function(ProductsLoadingMore value)? loadingMore,
    TResult Function(ProductsEmpty value)? empty,
    TResult Function(ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ProductsInitial implements ProductsState {
  const factory ProductsInitial() = _$ProductsInitialImpl;
}

/// @nodoc
abstract class _$$ProductsLoadingImplCopyWith<$Res> {
  factory _$$ProductsLoadingImplCopyWith(_$ProductsLoadingImpl value,
          $Res Function(_$ProductsLoadingImpl) then) =
      __$$ProductsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductsLoadingImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsLoadingImpl>
    implements _$$ProductsLoadingImplCopyWith<$Res> {
  __$$ProductsLoadingImplCopyWithImpl(
      _$ProductsLoadingImpl _value, $Res Function(_$ProductsLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductsLoadingImpl implements ProductsLoading {
  const _$ProductsLoadingImpl();

  @override
  String toString() {
    return 'ProductsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
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
    required TResult Function(ProductsInitial value) initial,
    required TResult Function(ProductsLoading value) loading,
    required TResult Function(ProductsLoaded value) loaded,
    required TResult Function(ProductsLoadingMore value) loadingMore,
    required TResult Function(ProductsEmpty value) empty,
    required TResult Function(ProductsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductsInitial value)? initial,
    TResult? Function(ProductsLoading value)? loading,
    TResult? Function(ProductsLoaded value)? loaded,
    TResult? Function(ProductsLoadingMore value)? loadingMore,
    TResult? Function(ProductsEmpty value)? empty,
    TResult? Function(ProductsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductsInitial value)? initial,
    TResult Function(ProductsLoading value)? loading,
    TResult Function(ProductsLoaded value)? loaded,
    TResult Function(ProductsLoadingMore value)? loadingMore,
    TResult Function(ProductsEmpty value)? empty,
    TResult Function(ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ProductsLoading implements ProductsState {
  const factory ProductsLoading() = _$ProductsLoadingImpl;
}

/// @nodoc
abstract class _$$ProductsLoadedImplCopyWith<$Res> {
  factory _$$ProductsLoadedImplCopyWith(_$ProductsLoadedImpl value,
          $Res Function(_$ProductsLoadedImpl) then) =
      __$$ProductsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Product> products,
      bool hasReachedMax,
      int currentPage,
      String? category,
      String? sortBy});
}

/// @nodoc
class __$$ProductsLoadedImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsLoadedImpl>
    implements _$$ProductsLoadedImplCopyWith<$Res> {
  __$$ProductsLoadedImplCopyWithImpl(
      _$ProductsLoadedImpl _value, $Res Function(_$ProductsLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? hasReachedMax = null,
    Object? currentPage = null,
    Object? category = freezed,
    Object? sortBy = freezed,
  }) {
    return _then(_$ProductsLoadedImpl(
      null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ProductsLoadedImpl implements ProductsLoaded {
  const _$ProductsLoadedImpl(final List<Product> products,
      {this.hasReachedMax = false,
      this.currentPage = 1,
      this.category,
      this.sortBy})
      : _products = products;

  final List<Product> _products;
  @override
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  @JsonKey()
  final bool hasReachedMax;
  @override
  @JsonKey()
  final int currentPage;
  @override
  final String? category;
  @override
  final String? sortBy;

  @override
  String toString() {
    return 'ProductsState.loaded(products: $products, hasReachedMax: $hasReachedMax, currentPage: $currentPage, category: $category, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsLoadedImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      hasReachedMax,
      currentPage,
      category,
      sortBy);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsLoadedImplCopyWith<_$ProductsLoadedImpl> get copyWith =>
      __$$ProductsLoadedImplCopyWithImpl<_$ProductsLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loaded(products, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loaded?.call(products, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(products, hasReachedMax, currentPage, category, sortBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductsInitial value) initial,
    required TResult Function(ProductsLoading value) loading,
    required TResult Function(ProductsLoaded value) loaded,
    required TResult Function(ProductsLoadingMore value) loadingMore,
    required TResult Function(ProductsEmpty value) empty,
    required TResult Function(ProductsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductsInitial value)? initial,
    TResult? Function(ProductsLoading value)? loading,
    TResult? Function(ProductsLoaded value)? loaded,
    TResult? Function(ProductsLoadingMore value)? loadingMore,
    TResult? Function(ProductsEmpty value)? empty,
    TResult? Function(ProductsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductsInitial value)? initial,
    TResult Function(ProductsLoading value)? loading,
    TResult Function(ProductsLoaded value)? loaded,
    TResult Function(ProductsLoadingMore value)? loadingMore,
    TResult Function(ProductsEmpty value)? empty,
    TResult Function(ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ProductsLoaded implements ProductsState {
  const factory ProductsLoaded(final List<Product> products,
      {final bool hasReachedMax,
      final int currentPage,
      final String? category,
      final String? sortBy}) = _$ProductsLoadedImpl;

  List<Product> get products;
  bool get hasReachedMax;
  int get currentPage;
  String? get category;
  String? get sortBy;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductsLoadedImplCopyWith<_$ProductsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductsLoadingMoreImplCopyWith<$Res> {
  factory _$$ProductsLoadingMoreImplCopyWith(_$ProductsLoadingMoreImpl value,
          $Res Function(_$ProductsLoadingMoreImpl) then) =
      __$$ProductsLoadingMoreImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Product> products,
      bool hasReachedMax,
      int currentPage,
      String? category,
      String? sortBy});
}

/// @nodoc
class __$$ProductsLoadingMoreImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsLoadingMoreImpl>
    implements _$$ProductsLoadingMoreImplCopyWith<$Res> {
  __$$ProductsLoadingMoreImplCopyWithImpl(_$ProductsLoadingMoreImpl _value,
      $Res Function(_$ProductsLoadingMoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? hasReachedMax = null,
    Object? currentPage = null,
    Object? category = freezed,
    Object? sortBy = freezed,
  }) {
    return _then(_$ProductsLoadingMoreImpl(
      null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<Product>,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ProductsLoadingMoreImpl implements ProductsLoadingMore {
  const _$ProductsLoadingMoreImpl(final List<Product> products,
      {this.hasReachedMax = false,
      this.currentPage = 1,
      this.category,
      this.sortBy})
      : _products = products;

  final List<Product> _products;
  @override
  List<Product> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  @JsonKey()
  final bool hasReachedMax;
  @override
  @JsonKey()
  final int currentPage;
  @override
  final String? category;
  @override
  final String? sortBy;

  @override
  String toString() {
    return 'ProductsState.loadingMore(products: $products, hasReachedMax: $hasReachedMax, currentPage: $currentPage, category: $category, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsLoadingMoreImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      hasReachedMax,
      currentPage,
      category,
      sortBy);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsLoadingMoreImplCopyWith<_$ProductsLoadingMoreImpl> get copyWith =>
      __$$ProductsLoadingMoreImplCopyWithImpl<_$ProductsLoadingMoreImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loadingMore(products, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loadingMore?.call(
        products, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(
          products, hasReachedMax, currentPage, category, sortBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductsInitial value) initial,
    required TResult Function(ProductsLoading value) loading,
    required TResult Function(ProductsLoaded value) loaded,
    required TResult Function(ProductsLoadingMore value) loadingMore,
    required TResult Function(ProductsEmpty value) empty,
    required TResult Function(ProductsError value) error,
  }) {
    return loadingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductsInitial value)? initial,
    TResult? Function(ProductsLoading value)? loading,
    TResult? Function(ProductsLoaded value)? loaded,
    TResult? Function(ProductsLoadingMore value)? loadingMore,
    TResult? Function(ProductsEmpty value)? empty,
    TResult? Function(ProductsError value)? error,
  }) {
    return loadingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductsInitial value)? initial,
    TResult Function(ProductsLoading value)? loading,
    TResult Function(ProductsLoaded value)? loaded,
    TResult Function(ProductsLoadingMore value)? loadingMore,
    TResult Function(ProductsEmpty value)? empty,
    TResult Function(ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this);
    }
    return orElse();
  }
}

abstract class ProductsLoadingMore implements ProductsState {
  const factory ProductsLoadingMore(final List<Product> products,
      {final bool hasReachedMax,
      final int currentPage,
      final String? category,
      final String? sortBy}) = _$ProductsLoadingMoreImpl;

  List<Product> get products;
  bool get hasReachedMax;
  int get currentPage;
  String? get category;
  String? get sortBy;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductsLoadingMoreImplCopyWith<_$ProductsLoadingMoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProductsEmptyImplCopyWith<$Res> {
  factory _$$ProductsEmptyImplCopyWith(
          _$ProductsEmptyImpl value, $Res Function(_$ProductsEmptyImpl) then) =
      __$$ProductsEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProductsEmptyImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsEmptyImpl>
    implements _$$ProductsEmptyImplCopyWith<$Res> {
  __$$ProductsEmptyImplCopyWithImpl(
      _$ProductsEmptyImpl _value, $Res Function(_$ProductsEmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProductsEmptyImpl implements ProductsEmpty {
  const _$ProductsEmptyImpl();

  @override
  String toString() {
    return 'ProductsState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProductsEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductsInitial value) initial,
    required TResult Function(ProductsLoading value) loading,
    required TResult Function(ProductsLoaded value) loaded,
    required TResult Function(ProductsLoadingMore value) loadingMore,
    required TResult Function(ProductsEmpty value) empty,
    required TResult Function(ProductsError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductsInitial value)? initial,
    TResult? Function(ProductsLoading value)? loading,
    TResult? Function(ProductsLoaded value)? loaded,
    TResult? Function(ProductsLoadingMore value)? loadingMore,
    TResult? Function(ProductsEmpty value)? empty,
    TResult? Function(ProductsError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductsInitial value)? initial,
    TResult Function(ProductsLoading value)? loading,
    TResult Function(ProductsLoaded value)? loaded,
    TResult Function(ProductsLoadingMore value)? loadingMore,
    TResult Function(ProductsEmpty value)? empty,
    TResult Function(ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class ProductsEmpty implements ProductsState {
  const factory ProductsEmpty() = _$ProductsEmptyImpl;
}

/// @nodoc
abstract class _$$ProductsErrorImplCopyWith<$Res> {
  factory _$$ProductsErrorImplCopyWith(
          _$ProductsErrorImpl value, $Res Function(_$ProductsErrorImpl) then) =
      __$$ProductsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$ProductsErrorImplCopyWithImpl<$Res>
    extends _$ProductsStateCopyWithImpl<$Res, _$ProductsErrorImpl>
    implements _$$ProductsErrorImplCopyWith<$Res> {
  __$$ProductsErrorImplCopyWithImpl(
      _$ProductsErrorImpl _value, $Res Function(_$ProductsErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$ProductsErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ProductsErrorImpl implements ProductsError {
  const _$ProductsErrorImpl(this.message, this.code);

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'ProductsState.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsErrorImplCopyWith<_$ProductsErrorImpl> get copyWith =>
      __$$ProductsErrorImplCopyWithImpl<_$ProductsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) {
    return error(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return error?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(List<Product> products, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ProductsInitial value) initial,
    required TResult Function(ProductsLoading value) loading,
    required TResult Function(ProductsLoaded value) loaded,
    required TResult Function(ProductsLoadingMore value) loadingMore,
    required TResult Function(ProductsEmpty value) empty,
    required TResult Function(ProductsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ProductsInitial value)? initial,
    TResult? Function(ProductsLoading value)? loading,
    TResult? Function(ProductsLoaded value)? loaded,
    TResult? Function(ProductsLoadingMore value)? loadingMore,
    TResult? Function(ProductsEmpty value)? empty,
    TResult? Function(ProductsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ProductsInitial value)? initial,
    TResult Function(ProductsLoading value)? loading,
    TResult Function(ProductsLoaded value)? loaded,
    TResult Function(ProductsLoadingMore value)? loadingMore,
    TResult Function(ProductsEmpty value)? empty,
    TResult Function(ProductsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ProductsError implements ProductsState {
  const factory ProductsError(final String message, final String? code) =
      _$ProductsErrorImpl;

  String get message;
  String? get code;

  /// Create a copy of ProductsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductsErrorImplCopyWith<_$ProductsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
