// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CategoriesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Category> categories, String? selectedCategoryId)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoriesInitial value) initial,
    required TResult Function(CategoriesLoading value) loading,
    required TResult Function(CategoriesLoaded value) loaded,
    required TResult Function(CategoriesEmpty value) empty,
    required TResult Function(CategoriesError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoriesInitial value)? initial,
    TResult? Function(CategoriesLoading value)? loading,
    TResult? Function(CategoriesLoaded value)? loaded,
    TResult? Function(CategoriesEmpty value)? empty,
    TResult? Function(CategoriesError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoriesInitial value)? initial,
    TResult Function(CategoriesLoading value)? loading,
    TResult Function(CategoriesLoaded value)? loaded,
    TResult Function(CategoriesEmpty value)? empty,
    TResult Function(CategoriesError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoriesStateCopyWith<$Res> {
  factory $CategoriesStateCopyWith(
          CategoriesState value, $Res Function(CategoriesState) then) =
      _$CategoriesStateCopyWithImpl<$Res, CategoriesState>;
}

/// @nodoc
class _$CategoriesStateCopyWithImpl<$Res, $Val extends CategoriesState>
    implements $CategoriesStateCopyWith<$Res> {
  _$CategoriesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CategoriesInitialImplCopyWith<$Res> {
  factory _$$CategoriesInitialImplCopyWith(_$CategoriesInitialImpl value,
          $Res Function(_$CategoriesInitialImpl) then) =
      __$$CategoriesInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CategoriesInitialImplCopyWithImpl<$Res>
    extends _$CategoriesStateCopyWithImpl<$Res, _$CategoriesInitialImpl>
    implements _$$CategoriesInitialImplCopyWith<$Res> {
  __$$CategoriesInitialImplCopyWithImpl(_$CategoriesInitialImpl _value,
      $Res Function(_$CategoriesInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CategoriesInitialImpl implements CategoriesInitial {
  const _$CategoriesInitialImpl();

  @override
  String toString() {
    return 'CategoriesState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CategoriesInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Category> categories, String? selectedCategoryId)
        loaded,
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
    TResult? Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    TResult Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    required TResult Function(CategoriesInitial value) initial,
    required TResult Function(CategoriesLoading value) loading,
    required TResult Function(CategoriesLoaded value) loaded,
    required TResult Function(CategoriesEmpty value) empty,
    required TResult Function(CategoriesError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoriesInitial value)? initial,
    TResult? Function(CategoriesLoading value)? loading,
    TResult? Function(CategoriesLoaded value)? loaded,
    TResult? Function(CategoriesEmpty value)? empty,
    TResult? Function(CategoriesError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoriesInitial value)? initial,
    TResult Function(CategoriesLoading value)? loading,
    TResult Function(CategoriesLoaded value)? loaded,
    TResult Function(CategoriesEmpty value)? empty,
    TResult Function(CategoriesError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CategoriesInitial implements CategoriesState {
  const factory CategoriesInitial() = _$CategoriesInitialImpl;
}

/// @nodoc
abstract class _$$CategoriesLoadingImplCopyWith<$Res> {
  factory _$$CategoriesLoadingImplCopyWith(_$CategoriesLoadingImpl value,
          $Res Function(_$CategoriesLoadingImpl) then) =
      __$$CategoriesLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CategoriesLoadingImplCopyWithImpl<$Res>
    extends _$CategoriesStateCopyWithImpl<$Res, _$CategoriesLoadingImpl>
    implements _$$CategoriesLoadingImplCopyWith<$Res> {
  __$$CategoriesLoadingImplCopyWithImpl(_$CategoriesLoadingImpl _value,
      $Res Function(_$CategoriesLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CategoriesLoadingImpl implements CategoriesLoading {
  const _$CategoriesLoadingImpl();

  @override
  String toString() {
    return 'CategoriesState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CategoriesLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Category> categories, String? selectedCategoryId)
        loaded,
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
    TResult? Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    TResult Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    required TResult Function(CategoriesInitial value) initial,
    required TResult Function(CategoriesLoading value) loading,
    required TResult Function(CategoriesLoaded value) loaded,
    required TResult Function(CategoriesEmpty value) empty,
    required TResult Function(CategoriesError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoriesInitial value)? initial,
    TResult? Function(CategoriesLoading value)? loading,
    TResult? Function(CategoriesLoaded value)? loaded,
    TResult? Function(CategoriesEmpty value)? empty,
    TResult? Function(CategoriesError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoriesInitial value)? initial,
    TResult Function(CategoriesLoading value)? loading,
    TResult Function(CategoriesLoaded value)? loaded,
    TResult Function(CategoriesEmpty value)? empty,
    TResult Function(CategoriesError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CategoriesLoading implements CategoriesState {
  const factory CategoriesLoading() = _$CategoriesLoadingImpl;
}

/// @nodoc
abstract class _$$CategoriesLoadedImplCopyWith<$Res> {
  factory _$$CategoriesLoadedImplCopyWith(_$CategoriesLoadedImpl value,
          $Res Function(_$CategoriesLoadedImpl) then) =
      __$$CategoriesLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Category> categories, String? selectedCategoryId});
}

/// @nodoc
class __$$CategoriesLoadedImplCopyWithImpl<$Res>
    extends _$CategoriesStateCopyWithImpl<$Res, _$CategoriesLoadedImpl>
    implements _$$CategoriesLoadedImplCopyWith<$Res> {
  __$$CategoriesLoadedImplCopyWithImpl(_$CategoriesLoadedImpl _value,
      $Res Function(_$CategoriesLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategoryId = freezed,
  }) {
    return _then(_$CategoriesLoadedImpl(
      null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      freezed == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CategoriesLoadedImpl implements CategoriesLoaded {
  const _$CategoriesLoadedImpl(
      final List<Category> categories, this.selectedCategoryId)
      : _categories = categories;

  final List<Category> _categories;
  @override
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? selectedCategoryId;

  @override
  String toString() {
    return 'CategoriesState.loaded(categories: $categories, selectedCategoryId: $selectedCategoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriesLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_categories), selectedCategoryId);

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriesLoadedImplCopyWith<_$CategoriesLoadedImpl> get copyWith =>
      __$$CategoriesLoadedImplCopyWithImpl<_$CategoriesLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Category> categories, String? selectedCategoryId)
        loaded,
    required TResult Function() empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loaded(categories, selectedCategoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
    TResult? Function()? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loaded?.call(categories, selectedCategoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
    TResult Function()? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(categories, selectedCategoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoriesInitial value) initial,
    required TResult Function(CategoriesLoading value) loading,
    required TResult Function(CategoriesLoaded value) loaded,
    required TResult Function(CategoriesEmpty value) empty,
    required TResult Function(CategoriesError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoriesInitial value)? initial,
    TResult? Function(CategoriesLoading value)? loading,
    TResult? Function(CategoriesLoaded value)? loaded,
    TResult? Function(CategoriesEmpty value)? empty,
    TResult? Function(CategoriesError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoriesInitial value)? initial,
    TResult Function(CategoriesLoading value)? loading,
    TResult Function(CategoriesLoaded value)? loaded,
    TResult Function(CategoriesEmpty value)? empty,
    TResult Function(CategoriesError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CategoriesLoaded implements CategoriesState {
  const factory CategoriesLoaded(
          final List<Category> categories, final String? selectedCategoryId) =
      _$CategoriesLoadedImpl;

  List<Category> get categories;
  String? get selectedCategoryId;

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoriesLoadedImplCopyWith<_$CategoriesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategoriesEmptyImplCopyWith<$Res> {
  factory _$$CategoriesEmptyImplCopyWith(_$CategoriesEmptyImpl value,
          $Res Function(_$CategoriesEmptyImpl) then) =
      __$$CategoriesEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CategoriesEmptyImplCopyWithImpl<$Res>
    extends _$CategoriesStateCopyWithImpl<$Res, _$CategoriesEmptyImpl>
    implements _$$CategoriesEmptyImplCopyWith<$Res> {
  __$$CategoriesEmptyImplCopyWithImpl(
      _$CategoriesEmptyImpl _value, $Res Function(_$CategoriesEmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CategoriesEmptyImpl implements CategoriesEmpty {
  const _$CategoriesEmptyImpl();

  @override
  String toString() {
    return 'CategoriesState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CategoriesEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Category> categories, String? selectedCategoryId)
        loaded,
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
    TResult? Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    TResult Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    required TResult Function(CategoriesInitial value) initial,
    required TResult Function(CategoriesLoading value) loading,
    required TResult Function(CategoriesLoaded value) loaded,
    required TResult Function(CategoriesEmpty value) empty,
    required TResult Function(CategoriesError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoriesInitial value)? initial,
    TResult? Function(CategoriesLoading value)? loading,
    TResult? Function(CategoriesLoaded value)? loaded,
    TResult? Function(CategoriesEmpty value)? empty,
    TResult? Function(CategoriesError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoriesInitial value)? initial,
    TResult Function(CategoriesLoading value)? loading,
    TResult Function(CategoriesLoaded value)? loaded,
    TResult Function(CategoriesEmpty value)? empty,
    TResult Function(CategoriesError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class CategoriesEmpty implements CategoriesState {
  const factory CategoriesEmpty() = _$CategoriesEmptyImpl;
}

/// @nodoc
abstract class _$$CategoriesErrorImplCopyWith<$Res> {
  factory _$$CategoriesErrorImplCopyWith(_$CategoriesErrorImpl value,
          $Res Function(_$CategoriesErrorImpl) then) =
      __$$CategoriesErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$CategoriesErrorImplCopyWithImpl<$Res>
    extends _$CategoriesStateCopyWithImpl<$Res, _$CategoriesErrorImpl>
    implements _$$CategoriesErrorImplCopyWith<$Res> {
  __$$CategoriesErrorImplCopyWithImpl(
      _$CategoriesErrorImpl _value, $Res Function(_$CategoriesErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$CategoriesErrorImpl(
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

class _$CategoriesErrorImpl implements CategoriesError {
  const _$CategoriesErrorImpl(this.message, this.code);

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'CategoriesState.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriesErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriesErrorImplCopyWith<_$CategoriesErrorImpl> get copyWith =>
      __$$CategoriesErrorImplCopyWithImpl<_$CategoriesErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Category> categories, String? selectedCategoryId)
        loaded,
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
    TResult? Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    TResult Function(List<Category> categories, String? selectedCategoryId)?
        loaded,
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
    required TResult Function(CategoriesInitial value) initial,
    required TResult Function(CategoriesLoading value) loading,
    required TResult Function(CategoriesLoaded value) loaded,
    required TResult Function(CategoriesEmpty value) empty,
    required TResult Function(CategoriesError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoriesInitial value)? initial,
    TResult? Function(CategoriesLoading value)? loading,
    TResult? Function(CategoriesLoaded value)? loaded,
    TResult? Function(CategoriesEmpty value)? empty,
    TResult? Function(CategoriesError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoriesInitial value)? initial,
    TResult Function(CategoriesLoading value)? loading,
    TResult Function(CategoriesLoaded value)? loaded,
    TResult Function(CategoriesEmpty value)? empty,
    TResult Function(CategoriesError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CategoriesError implements CategoriesState {
  const factory CategoriesError(final String message, final String? code) =
      _$CategoriesErrorImpl;

  String get message;
  String? get code;

  /// Create a copy of CategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoriesErrorImplCopyWith<_$CategoriesErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
