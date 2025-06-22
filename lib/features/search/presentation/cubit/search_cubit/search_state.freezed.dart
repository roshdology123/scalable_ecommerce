// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function(String query)? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchInitial value) initial,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchLoaded value) loaded,
    required TResult Function(SearchLoadingMore value) loadingMore,
    required TResult Function(SearchEmpty value) empty,
    required TResult Function(SearchError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchInitial value)? initial,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchLoaded value)? loaded,
    TResult? Function(SearchLoadingMore value)? loadingMore,
    TResult? Function(SearchEmpty value)? empty,
    TResult? Function(SearchError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchInitial value)? initial,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchLoaded value)? loaded,
    TResult Function(SearchLoadingMore value)? loadingMore,
    TResult Function(SearchEmpty value)? empty,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) then) =
      _$SearchStateCopyWithImpl<$Res, SearchState>;
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SearchInitialImplCopyWith<$Res> {
  factory _$$SearchInitialImplCopyWith(
          _$SearchInitialImpl value, $Res Function(_$SearchInitialImpl) then) =
      __$$SearchInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchInitialImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchInitialImpl>
    implements _$$SearchInitialImplCopyWith<$Res> {
  __$$SearchInitialImplCopyWithImpl(
      _$SearchInitialImpl _value, $Res Function(_$SearchInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchInitialImpl implements SearchInitial {
  const _$SearchInitialImpl();

  @override
  String toString() {
    return 'SearchState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SearchInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function(String query)? empty,
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
    required TResult Function(SearchInitial value) initial,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchLoaded value) loaded,
    required TResult Function(SearchLoadingMore value) loadingMore,
    required TResult Function(SearchEmpty value) empty,
    required TResult Function(SearchError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchInitial value)? initial,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchLoaded value)? loaded,
    TResult? Function(SearchLoadingMore value)? loadingMore,
    TResult? Function(SearchEmpty value)? empty,
    TResult? Function(SearchError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchInitial value)? initial,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchLoaded value)? loaded,
    TResult Function(SearchLoadingMore value)? loadingMore,
    TResult Function(SearchEmpty value)? empty,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SearchInitial implements SearchState {
  const factory SearchInitial() = _$SearchInitialImpl;
}

/// @nodoc
abstract class _$$SearchLoadingImplCopyWith<$Res> {
  factory _$$SearchLoadingImplCopyWith(
          _$SearchLoadingImpl value, $Res Function(_$SearchLoadingImpl) then) =
      __$$SearchLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchLoadingImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchLoadingImpl>
    implements _$$SearchLoadingImplCopyWith<$Res> {
  __$$SearchLoadingImplCopyWithImpl(
      _$SearchLoadingImpl _value, $Res Function(_$SearchLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchLoadingImpl implements SearchLoading {
  const _$SearchLoadingImpl();

  @override
  String toString() {
    return 'SearchState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SearchLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function(String query)? empty,
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
    required TResult Function(SearchInitial value) initial,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchLoaded value) loaded,
    required TResult Function(SearchLoadingMore value) loadingMore,
    required TResult Function(SearchEmpty value) empty,
    required TResult Function(SearchError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchInitial value)? initial,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchLoaded value)? loaded,
    TResult? Function(SearchLoadingMore value)? loadingMore,
    TResult? Function(SearchEmpty value)? empty,
    TResult? Function(SearchError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchInitial value)? initial,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchLoaded value)? loaded,
    TResult Function(SearchLoadingMore value)? loadingMore,
    TResult Function(SearchEmpty value)? empty,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SearchLoading implements SearchState {
  const factory SearchLoading() = _$SearchLoadingImpl;
}

/// @nodoc
abstract class _$$SearchLoadedImplCopyWith<$Res> {
  factory _$$SearchLoadedImplCopyWith(
          _$SearchLoadedImpl value, $Res Function(_$SearchLoadedImpl) then) =
      __$$SearchLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {SearchResult searchResult,
      bool hasReachedMax,
      int currentPage,
      String? category,
      String? sortBy});
}

/// @nodoc
class __$$SearchLoadedImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchLoadedImpl>
    implements _$$SearchLoadedImplCopyWith<$Res> {
  __$$SearchLoadedImplCopyWithImpl(
      _$SearchLoadedImpl _value, $Res Function(_$SearchLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchResult = null,
    Object? hasReachedMax = null,
    Object? currentPage = null,
    Object? category = freezed,
    Object? sortBy = freezed,
  }) {
    return _then(_$SearchLoadedImpl(
      null == searchResult
          ? _value.searchResult
          : searchResult // ignore: cast_nullable_to_non_nullable
              as SearchResult,
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

class _$SearchLoadedImpl implements SearchLoaded {
  const _$SearchLoadedImpl(this.searchResult,
      {this.hasReachedMax = false,
      this.currentPage = 1,
      this.category,
      this.sortBy});

  @override
  final SearchResult searchResult;
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
    return 'SearchState.loaded(searchResult: $searchResult, hasReachedMax: $hasReachedMax, currentPage: $currentPage, category: $category, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchLoadedImpl &&
            (identical(other.searchResult, searchResult) ||
                other.searchResult == searchResult) &&
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
      runtimeType, searchResult, hasReachedMax, currentPage, category, sortBy);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchLoadedImplCopyWith<_$SearchLoadedImpl> get copyWith =>
      __$$SearchLoadedImplCopyWithImpl<_$SearchLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loaded(searchResult, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loaded?.call(
        searchResult, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function(String query)? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(searchResult, hasReachedMax, currentPage, category, sortBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchInitial value) initial,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchLoaded value) loaded,
    required TResult Function(SearchLoadingMore value) loadingMore,
    required TResult Function(SearchEmpty value) empty,
    required TResult Function(SearchError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchInitial value)? initial,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchLoaded value)? loaded,
    TResult? Function(SearchLoadingMore value)? loadingMore,
    TResult? Function(SearchEmpty value)? empty,
    TResult? Function(SearchError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchInitial value)? initial,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchLoaded value)? loaded,
    TResult Function(SearchLoadingMore value)? loadingMore,
    TResult Function(SearchEmpty value)? empty,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SearchLoaded implements SearchState {
  const factory SearchLoaded(final SearchResult searchResult,
      {final bool hasReachedMax,
      final int currentPage,
      final String? category,
      final String? sortBy}) = _$SearchLoadedImpl;

  SearchResult get searchResult;
  bool get hasReachedMax;
  int get currentPage;
  String? get category;
  String? get sortBy;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchLoadedImplCopyWith<_$SearchLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchLoadingMoreImplCopyWith<$Res> {
  factory _$$SearchLoadingMoreImplCopyWith(_$SearchLoadingMoreImpl value,
          $Res Function(_$SearchLoadingMoreImpl) then) =
      __$$SearchLoadingMoreImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {SearchResult searchResult,
      bool hasReachedMax,
      int currentPage,
      String? category,
      String? sortBy});
}

/// @nodoc
class __$$SearchLoadingMoreImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchLoadingMoreImpl>
    implements _$$SearchLoadingMoreImplCopyWith<$Res> {
  __$$SearchLoadingMoreImplCopyWithImpl(_$SearchLoadingMoreImpl _value,
      $Res Function(_$SearchLoadingMoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchResult = null,
    Object? hasReachedMax = null,
    Object? currentPage = null,
    Object? category = freezed,
    Object? sortBy = freezed,
  }) {
    return _then(_$SearchLoadingMoreImpl(
      null == searchResult
          ? _value.searchResult
          : searchResult // ignore: cast_nullable_to_non_nullable
              as SearchResult,
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

class _$SearchLoadingMoreImpl implements SearchLoadingMore {
  const _$SearchLoadingMoreImpl(this.searchResult,
      {this.hasReachedMax = false,
      this.currentPage = 1,
      this.category,
      this.sortBy});

  @override
  final SearchResult searchResult;
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
    return 'SearchState.loadingMore(searchResult: $searchResult, hasReachedMax: $hasReachedMax, currentPage: $currentPage, category: $category, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchLoadingMoreImpl &&
            (identical(other.searchResult, searchResult) ||
                other.searchResult == searchResult) &&
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
      runtimeType, searchResult, hasReachedMax, currentPage, category, sortBy);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchLoadingMoreImplCopyWith<_$SearchLoadingMoreImpl> get copyWith =>
      __$$SearchLoadingMoreImplCopyWithImpl<_$SearchLoadingMoreImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loadingMore(
        searchResult, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loadingMore?.call(
        searchResult, hasReachedMax, currentPage, category, sortBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function(String query)? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(
          searchResult, hasReachedMax, currentPage, category, sortBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchInitial value) initial,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchLoaded value) loaded,
    required TResult Function(SearchLoadingMore value) loadingMore,
    required TResult Function(SearchEmpty value) empty,
    required TResult Function(SearchError value) error,
  }) {
    return loadingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchInitial value)? initial,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchLoaded value)? loaded,
    TResult? Function(SearchLoadingMore value)? loadingMore,
    TResult? Function(SearchEmpty value)? empty,
    TResult? Function(SearchError value)? error,
  }) {
    return loadingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchInitial value)? initial,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchLoaded value)? loaded,
    TResult Function(SearchLoadingMore value)? loadingMore,
    TResult Function(SearchEmpty value)? empty,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this);
    }
    return orElse();
  }
}

abstract class SearchLoadingMore implements SearchState {
  const factory SearchLoadingMore(final SearchResult searchResult,
      {final bool hasReachedMax,
      final int currentPage,
      final String? category,
      final String? sortBy}) = _$SearchLoadingMoreImpl;

  SearchResult get searchResult;
  bool get hasReachedMax;
  int get currentPage;
  String? get category;
  String? get sortBy;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchLoadingMoreImplCopyWith<_$SearchLoadingMoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchEmptyImplCopyWith<$Res> {
  factory _$$SearchEmptyImplCopyWith(
          _$SearchEmptyImpl value, $Res Function(_$SearchEmptyImpl) then) =
      __$$SearchEmptyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchEmptyImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchEmptyImpl>
    implements _$$SearchEmptyImplCopyWith<$Res> {
  __$$SearchEmptyImplCopyWithImpl(
      _$SearchEmptyImpl _value, $Res Function(_$SearchEmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
  }) {
    return _then(_$SearchEmptyImpl(
      null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchEmptyImpl implements SearchEmpty {
  const _$SearchEmptyImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'SearchState.empty(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchEmptyImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchEmptyImplCopyWith<_$SearchEmptyImpl> get copyWith =>
      __$$SearchEmptyImplCopyWithImpl<_$SearchEmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) {
    return empty(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return empty?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function(String query)? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchInitial value) initial,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchLoaded value) loaded,
    required TResult Function(SearchLoadingMore value) loadingMore,
    required TResult Function(SearchEmpty value) empty,
    required TResult Function(SearchError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchInitial value)? initial,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchLoaded value)? loaded,
    TResult? Function(SearchLoadingMore value)? loadingMore,
    TResult? Function(SearchEmpty value)? empty,
    TResult? Function(SearchError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchInitial value)? initial,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchLoaded value)? loaded,
    TResult Function(SearchLoadingMore value)? loadingMore,
    TResult Function(SearchEmpty value)? empty,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class SearchEmpty implements SearchState {
  const factory SearchEmpty(final String query) = _$SearchEmptyImpl;

  String get query;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchEmptyImplCopyWith<_$SearchEmptyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchErrorImplCopyWith<$Res> {
  factory _$$SearchErrorImplCopyWith(
          _$SearchErrorImpl value, $Res Function(_$SearchErrorImpl) then) =
      __$$SearchErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$SearchErrorImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchErrorImpl>
    implements _$$SearchErrorImplCopyWith<$Res> {
  __$$SearchErrorImplCopyWithImpl(
      _$SearchErrorImpl _value, $Res Function(_$SearchErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$SearchErrorImpl(
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

class _$SearchErrorImpl implements SearchError {
  const _$SearchErrorImpl(this.message, this.code);

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'SearchState.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchErrorImplCopyWith<_$SearchErrorImpl> get copyWith =>
      __$$SearchErrorImplCopyWithImpl<_$SearchErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loaded,
    required TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)
        loadingMore,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) {
    return error(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult? Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return error?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loaded,
    TResult Function(SearchResult searchResult, bool hasReachedMax,
            int currentPage, String? category, String? sortBy)?
        loadingMore,
    TResult Function(String query)? empty,
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
    required TResult Function(SearchInitial value) initial,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchLoaded value) loaded,
    required TResult Function(SearchLoadingMore value) loadingMore,
    required TResult Function(SearchEmpty value) empty,
    required TResult Function(SearchError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchInitial value)? initial,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchLoaded value)? loaded,
    TResult? Function(SearchLoadingMore value)? loadingMore,
    TResult? Function(SearchEmpty value)? empty,
    TResult? Function(SearchError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchInitial value)? initial,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchLoaded value)? loaded,
    TResult Function(SearchLoadingMore value)? loadingMore,
    TResult Function(SearchEmpty value)? empty,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SearchError implements SearchState {
  const factory SearchError(final String message, final String? code) =
      _$SearchErrorImpl;

  String get message;
  String? get code;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchErrorImplCopyWith<_$SearchErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
