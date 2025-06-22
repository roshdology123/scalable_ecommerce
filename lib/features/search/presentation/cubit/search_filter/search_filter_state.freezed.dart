// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchFilterState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)
        loaded,
    required TResult Function(String message, String? code) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
    TResult? Function(String message, String? code)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchFilterInitial value) initial,
    required TResult Function(SearchFilterLoading value) loading,
    required TResult Function(SearchFilterLoaded value) loaded,
    required TResult Function(SearchFilterError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchFilterInitial value)? initial,
    TResult? Function(SearchFilterLoading value)? loading,
    TResult? Function(SearchFilterLoaded value)? loaded,
    TResult? Function(SearchFilterError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchFilterInitial value)? initial,
    TResult Function(SearchFilterLoading value)? loading,
    TResult Function(SearchFilterLoaded value)? loaded,
    TResult Function(SearchFilterError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFilterStateCopyWith<$Res> {
  factory $SearchFilterStateCopyWith(
          SearchFilterState value, $Res Function(SearchFilterState) then) =
      _$SearchFilterStateCopyWithImpl<$Res, SearchFilterState>;
}

/// @nodoc
class _$SearchFilterStateCopyWithImpl<$Res, $Val extends SearchFilterState>
    implements $SearchFilterStateCopyWith<$Res> {
  _$SearchFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SearchFilterInitialImplCopyWith<$Res> {
  factory _$$SearchFilterInitialImplCopyWith(_$SearchFilterInitialImpl value,
          $Res Function(_$SearchFilterInitialImpl) then) =
      __$$SearchFilterInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchFilterInitialImplCopyWithImpl<$Res>
    extends _$SearchFilterStateCopyWithImpl<$Res, _$SearchFilterInitialImpl>
    implements _$$SearchFilterInitialImplCopyWith<$Res> {
  __$$SearchFilterInitialImplCopyWithImpl(_$SearchFilterInitialImpl _value,
      $Res Function(_$SearchFilterInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchFilterInitialImpl implements SearchFilterInitial {
  const _$SearchFilterInitialImpl();

  @override
  String toString() {
    return 'SearchFilterState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)
        loaded,
    required TResult Function(String message, String? code) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
    TResult? Function(String message, String? code)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
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
    required TResult Function(SearchFilterInitial value) initial,
    required TResult Function(SearchFilterLoading value) loading,
    required TResult Function(SearchFilterLoaded value) loaded,
    required TResult Function(SearchFilterError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchFilterInitial value)? initial,
    TResult? Function(SearchFilterLoading value)? loading,
    TResult? Function(SearchFilterLoaded value)? loaded,
    TResult? Function(SearchFilterError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchFilterInitial value)? initial,
    TResult Function(SearchFilterLoading value)? loading,
    TResult Function(SearchFilterLoaded value)? loaded,
    TResult Function(SearchFilterError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SearchFilterInitial implements SearchFilterState {
  const factory SearchFilterInitial() = _$SearchFilterInitialImpl;
}

/// @nodoc
abstract class _$$SearchFilterLoadingImplCopyWith<$Res> {
  factory _$$SearchFilterLoadingImplCopyWith(_$SearchFilterLoadingImpl value,
          $Res Function(_$SearchFilterLoadingImpl) then) =
      __$$SearchFilterLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchFilterLoadingImplCopyWithImpl<$Res>
    extends _$SearchFilterStateCopyWithImpl<$Res, _$SearchFilterLoadingImpl>
    implements _$$SearchFilterLoadingImplCopyWith<$Res> {
  __$$SearchFilterLoadingImplCopyWithImpl(_$SearchFilterLoadingImpl _value,
      $Res Function(_$SearchFilterLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchFilterLoadingImpl implements SearchFilterLoading {
  const _$SearchFilterLoadingImpl();

  @override
  String toString() {
    return 'SearchFilterState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)
        loaded,
    required TResult Function(String message, String? code) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
    TResult? Function(String message, String? code)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
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
    required TResult Function(SearchFilterInitial value) initial,
    required TResult Function(SearchFilterLoading value) loading,
    required TResult Function(SearchFilterLoaded value) loaded,
    required TResult Function(SearchFilterError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchFilterInitial value)? initial,
    TResult? Function(SearchFilterLoading value)? loading,
    TResult? Function(SearchFilterLoaded value)? loaded,
    TResult? Function(SearchFilterError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchFilterInitial value)? initial,
    TResult Function(SearchFilterLoading value)? loading,
    TResult Function(SearchFilterLoaded value)? loaded,
    TResult Function(SearchFilterError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SearchFilterLoading implements SearchFilterState {
  const factory SearchFilterLoading() = _$SearchFilterLoadingImpl;
}

/// @nodoc
abstract class _$$SearchFilterLoadedImplCopyWith<$Res> {
  factory _$$SearchFilterLoadedImplCopyWith(_$SearchFilterLoadedImpl value,
          $Res Function(_$SearchFilterLoadedImpl) then) =
      __$$SearchFilterLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<String> categories,
      String? selectedCategory,
      double? minPrice,
      double? maxPrice,
      double? minRating,
      String? sortBy,
      String sortOrder});
}

/// @nodoc
class __$$SearchFilterLoadedImplCopyWithImpl<$Res>
    extends _$SearchFilterStateCopyWithImpl<$Res, _$SearchFilterLoadedImpl>
    implements _$$SearchFilterLoadedImplCopyWith<$Res> {
  __$$SearchFilterLoadedImplCopyWithImpl(_$SearchFilterLoadedImpl _value,
      $Res Function(_$SearchFilterLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategory = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minRating = freezed,
    Object? sortBy = freezed,
    Object? sortOrder = null,
  }) {
    return _then(_$SearchFilterLoadedImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      sortBy: freezed == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchFilterLoadedImpl implements SearchFilterLoaded {
  const _$SearchFilterLoadedImpl(
      {required final List<String> categories,
      this.selectedCategory,
      this.minPrice,
      this.maxPrice,
      this.minRating,
      this.sortBy,
      this.sortOrder = 'asc'})
      : _categories = categories;

  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? selectedCategory;
  @override
  final double? minPrice;
  @override
  final double? maxPrice;
  @override
  final double? minRating;
  @override
  final String? sortBy;
  @override
  @JsonKey()
  final String sortOrder;

  @override
  String toString() {
    return 'SearchFilterState.loaded(categories: $categories, selectedCategory: $selectedCategory, minPrice: $minPrice, maxPrice: $maxPrice, minRating: $minRating, sortBy: $sortBy, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      selectedCategory,
      minPrice,
      maxPrice,
      minRating,
      sortBy,
      sortOrder);

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterLoadedImplCopyWith<_$SearchFilterLoadedImpl> get copyWith =>
      __$$SearchFilterLoadedImplCopyWithImpl<_$SearchFilterLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)
        loaded,
    required TResult Function(String message, String? code) error,
  }) {
    return loaded(categories, selectedCategory, minPrice, maxPrice, minRating,
        sortBy, sortOrder);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
    TResult? Function(String message, String? code)? error,
  }) {
    return loaded?.call(categories, selectedCategory, minPrice, maxPrice,
        minRating, sortBy, sortOrder);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(categories, selectedCategory, minPrice, maxPrice, minRating,
          sortBy, sortOrder);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchFilterInitial value) initial,
    required TResult Function(SearchFilterLoading value) loading,
    required TResult Function(SearchFilterLoaded value) loaded,
    required TResult Function(SearchFilterError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchFilterInitial value)? initial,
    TResult? Function(SearchFilterLoading value)? loading,
    TResult? Function(SearchFilterLoaded value)? loaded,
    TResult? Function(SearchFilterError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchFilterInitial value)? initial,
    TResult Function(SearchFilterLoading value)? loading,
    TResult Function(SearchFilterLoaded value)? loaded,
    TResult Function(SearchFilterError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SearchFilterLoaded implements SearchFilterState {
  const factory SearchFilterLoaded(
      {required final List<String> categories,
      final String? selectedCategory,
      final double? minPrice,
      final double? maxPrice,
      final double? minRating,
      final String? sortBy,
      final String sortOrder}) = _$SearchFilterLoadedImpl;

  List<String> get categories;
  String? get selectedCategory;
  double? get minPrice;
  double? get maxPrice;
  double? get minRating;
  String? get sortBy;
  String get sortOrder;

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterLoadedImplCopyWith<_$SearchFilterLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchFilterErrorImplCopyWith<$Res> {
  factory _$$SearchFilterErrorImplCopyWith(_$SearchFilterErrorImpl value,
          $Res Function(_$SearchFilterErrorImpl) then) =
      __$$SearchFilterErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$SearchFilterErrorImplCopyWithImpl<$Res>
    extends _$SearchFilterStateCopyWithImpl<$Res, _$SearchFilterErrorImpl>
    implements _$$SearchFilterErrorImplCopyWith<$Res> {
  __$$SearchFilterErrorImplCopyWithImpl(_$SearchFilterErrorImpl _value,
      $Res Function(_$SearchFilterErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$SearchFilterErrorImpl(
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

class _$SearchFilterErrorImpl implements SearchFilterError {
  const _$SearchFilterErrorImpl(this.message, this.code);

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'SearchFilterState.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterErrorImplCopyWith<_$SearchFilterErrorImpl> get copyWith =>
      __$$SearchFilterErrorImplCopyWithImpl<_$SearchFilterErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)
        loaded,
    required TResult Function(String message, String? code) error,
  }) {
    return error(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
    TResult? Function(String message, String? code)? error,
  }) {
    return error?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<String> categories,
            String? selectedCategory,
            double? minPrice,
            double? maxPrice,
            double? minRating,
            String? sortBy,
            String sortOrder)?
        loaded,
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
    required TResult Function(SearchFilterInitial value) initial,
    required TResult Function(SearchFilterLoading value) loading,
    required TResult Function(SearchFilterLoaded value) loaded,
    required TResult Function(SearchFilterError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchFilterInitial value)? initial,
    TResult? Function(SearchFilterLoading value)? loading,
    TResult? Function(SearchFilterLoaded value)? loaded,
    TResult? Function(SearchFilterError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchFilterInitial value)? initial,
    TResult Function(SearchFilterLoading value)? loading,
    TResult Function(SearchFilterLoaded value)? loaded,
    TResult Function(SearchFilterError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SearchFilterError implements SearchFilterState {
  const factory SearchFilterError(final String message, final String? code) =
      _$SearchFilterErrorImpl;

  String get message;
  String? get code;

  /// Create a copy of SearchFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterErrorImplCopyWith<_$SearchFilterErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
