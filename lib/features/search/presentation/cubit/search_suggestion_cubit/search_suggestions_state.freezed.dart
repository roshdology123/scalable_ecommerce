// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_suggestions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchSuggestionsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SearchSuggestion> suggestions, String query)
        loaded,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SearchSuggestion> suggestions, String query)? loaded,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SearchSuggestion> suggestions, String query)? loaded,
    TResult Function(String query)? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchSuggestionsInitial value) initial,
    required TResult Function(SearchSuggestionsLoading value) loading,
    required TResult Function(SearchSuggestionsLoaded value) loaded,
    required TResult Function(SearchSuggestionsEmpty value) empty,
    required TResult Function(SearchSuggestionsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchSuggestionsInitial value)? initial,
    TResult? Function(SearchSuggestionsLoading value)? loading,
    TResult? Function(SearchSuggestionsLoaded value)? loaded,
    TResult? Function(SearchSuggestionsEmpty value)? empty,
    TResult? Function(SearchSuggestionsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchSuggestionsInitial value)? initial,
    TResult Function(SearchSuggestionsLoading value)? loading,
    TResult Function(SearchSuggestionsLoaded value)? loaded,
    TResult Function(SearchSuggestionsEmpty value)? empty,
    TResult Function(SearchSuggestionsError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchSuggestionsStateCopyWith<$Res> {
  factory $SearchSuggestionsStateCopyWith(SearchSuggestionsState value,
          $Res Function(SearchSuggestionsState) then) =
      _$SearchSuggestionsStateCopyWithImpl<$Res, SearchSuggestionsState>;
}

/// @nodoc
class _$SearchSuggestionsStateCopyWithImpl<$Res,
        $Val extends SearchSuggestionsState>
    implements $SearchSuggestionsStateCopyWith<$Res> {
  _$SearchSuggestionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SearchSuggestionsInitialImplCopyWith<$Res> {
  factory _$$SearchSuggestionsInitialImplCopyWith(
          _$SearchSuggestionsInitialImpl value,
          $Res Function(_$SearchSuggestionsInitialImpl) then) =
      __$$SearchSuggestionsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchSuggestionsInitialImplCopyWithImpl<$Res>
    extends _$SearchSuggestionsStateCopyWithImpl<$Res,
        _$SearchSuggestionsInitialImpl>
    implements _$$SearchSuggestionsInitialImplCopyWith<$Res> {
  __$$SearchSuggestionsInitialImplCopyWithImpl(
      _$SearchSuggestionsInitialImpl _value,
      $Res Function(_$SearchSuggestionsInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchSuggestionsInitialImpl implements SearchSuggestionsInitial {
  const _$SearchSuggestionsInitialImpl();

  @override
  String toString() {
    return 'SearchSuggestionsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SearchSuggestion> suggestions, String query)
        loaded,
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
    TResult? Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    TResult Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    required TResult Function(SearchSuggestionsInitial value) initial,
    required TResult Function(SearchSuggestionsLoading value) loading,
    required TResult Function(SearchSuggestionsLoaded value) loaded,
    required TResult Function(SearchSuggestionsEmpty value) empty,
    required TResult Function(SearchSuggestionsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchSuggestionsInitial value)? initial,
    TResult? Function(SearchSuggestionsLoading value)? loading,
    TResult? Function(SearchSuggestionsLoaded value)? loaded,
    TResult? Function(SearchSuggestionsEmpty value)? empty,
    TResult? Function(SearchSuggestionsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchSuggestionsInitial value)? initial,
    TResult Function(SearchSuggestionsLoading value)? loading,
    TResult Function(SearchSuggestionsLoaded value)? loaded,
    TResult Function(SearchSuggestionsEmpty value)? empty,
    TResult Function(SearchSuggestionsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SearchSuggestionsInitial implements SearchSuggestionsState {
  const factory SearchSuggestionsInitial() = _$SearchSuggestionsInitialImpl;
}

/// @nodoc
abstract class _$$SearchSuggestionsLoadingImplCopyWith<$Res> {
  factory _$$SearchSuggestionsLoadingImplCopyWith(
          _$SearchSuggestionsLoadingImpl value,
          $Res Function(_$SearchSuggestionsLoadingImpl) then) =
      __$$SearchSuggestionsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchSuggestionsLoadingImplCopyWithImpl<$Res>
    extends _$SearchSuggestionsStateCopyWithImpl<$Res,
        _$SearchSuggestionsLoadingImpl>
    implements _$$SearchSuggestionsLoadingImplCopyWith<$Res> {
  __$$SearchSuggestionsLoadingImplCopyWithImpl(
      _$SearchSuggestionsLoadingImpl _value,
      $Res Function(_$SearchSuggestionsLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchSuggestionsLoadingImpl implements SearchSuggestionsLoading {
  const _$SearchSuggestionsLoadingImpl();

  @override
  String toString() {
    return 'SearchSuggestionsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SearchSuggestion> suggestions, String query)
        loaded,
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
    TResult? Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    TResult Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    required TResult Function(SearchSuggestionsInitial value) initial,
    required TResult Function(SearchSuggestionsLoading value) loading,
    required TResult Function(SearchSuggestionsLoaded value) loaded,
    required TResult Function(SearchSuggestionsEmpty value) empty,
    required TResult Function(SearchSuggestionsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchSuggestionsInitial value)? initial,
    TResult? Function(SearchSuggestionsLoading value)? loading,
    TResult? Function(SearchSuggestionsLoaded value)? loaded,
    TResult? Function(SearchSuggestionsEmpty value)? empty,
    TResult? Function(SearchSuggestionsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchSuggestionsInitial value)? initial,
    TResult Function(SearchSuggestionsLoading value)? loading,
    TResult Function(SearchSuggestionsLoaded value)? loaded,
    TResult Function(SearchSuggestionsEmpty value)? empty,
    TResult Function(SearchSuggestionsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SearchSuggestionsLoading implements SearchSuggestionsState {
  const factory SearchSuggestionsLoading() = _$SearchSuggestionsLoadingImpl;
}

/// @nodoc
abstract class _$$SearchSuggestionsLoadedImplCopyWith<$Res> {
  factory _$$SearchSuggestionsLoadedImplCopyWith(
          _$SearchSuggestionsLoadedImpl value,
          $Res Function(_$SearchSuggestionsLoadedImpl) then) =
      __$$SearchSuggestionsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SearchSuggestion> suggestions, String query});
}

/// @nodoc
class __$$SearchSuggestionsLoadedImplCopyWithImpl<$Res>
    extends _$SearchSuggestionsStateCopyWithImpl<$Res,
        _$SearchSuggestionsLoadedImpl>
    implements _$$SearchSuggestionsLoadedImplCopyWith<$Res> {
  __$$SearchSuggestionsLoadedImplCopyWithImpl(
      _$SearchSuggestionsLoadedImpl _value,
      $Res Function(_$SearchSuggestionsLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestions = null,
    Object? query = null,
  }) {
    return _then(_$SearchSuggestionsLoadedImpl(
      null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<SearchSuggestion>,
      null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchSuggestionsLoadedImpl implements SearchSuggestionsLoaded {
  const _$SearchSuggestionsLoadedImpl(
      final List<SearchSuggestion> suggestions, this.query)
      : _suggestions = suggestions;

  final List<SearchSuggestion> _suggestions;
  @override
  List<SearchSuggestion> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  final String query;

  @override
  String toString() {
    return 'SearchSuggestionsState.loaded(suggestions: $suggestions, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionsLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_suggestions), query);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionsLoadedImplCopyWith<_$SearchSuggestionsLoadedImpl>
      get copyWith => __$$SearchSuggestionsLoadedImplCopyWithImpl<
          _$SearchSuggestionsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SearchSuggestion> suggestions, String query)
        loaded,
    required TResult Function(String query) empty,
    required TResult Function(String message, String? code) error,
  }) {
    return loaded(suggestions, query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SearchSuggestion> suggestions, String query)? loaded,
    TResult? Function(String query)? empty,
    TResult? Function(String message, String? code)? error,
  }) {
    return loaded?.call(suggestions, query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SearchSuggestion> suggestions, String query)? loaded,
    TResult Function(String query)? empty,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(suggestions, query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchSuggestionsInitial value) initial,
    required TResult Function(SearchSuggestionsLoading value) loading,
    required TResult Function(SearchSuggestionsLoaded value) loaded,
    required TResult Function(SearchSuggestionsEmpty value) empty,
    required TResult Function(SearchSuggestionsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchSuggestionsInitial value)? initial,
    TResult? Function(SearchSuggestionsLoading value)? loading,
    TResult? Function(SearchSuggestionsLoaded value)? loaded,
    TResult? Function(SearchSuggestionsEmpty value)? empty,
    TResult? Function(SearchSuggestionsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchSuggestionsInitial value)? initial,
    TResult Function(SearchSuggestionsLoading value)? loading,
    TResult Function(SearchSuggestionsLoaded value)? loaded,
    TResult Function(SearchSuggestionsEmpty value)? empty,
    TResult Function(SearchSuggestionsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SearchSuggestionsLoaded implements SearchSuggestionsState {
  const factory SearchSuggestionsLoaded(
          final List<SearchSuggestion> suggestions, final String query) =
      _$SearchSuggestionsLoadedImpl;

  List<SearchSuggestion> get suggestions;
  String get query;

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionsLoadedImplCopyWith<_$SearchSuggestionsLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchSuggestionsEmptyImplCopyWith<$Res> {
  factory _$$SearchSuggestionsEmptyImplCopyWith(
          _$SearchSuggestionsEmptyImpl value,
          $Res Function(_$SearchSuggestionsEmptyImpl) then) =
      __$$SearchSuggestionsEmptyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchSuggestionsEmptyImplCopyWithImpl<$Res>
    extends _$SearchSuggestionsStateCopyWithImpl<$Res,
        _$SearchSuggestionsEmptyImpl>
    implements _$$SearchSuggestionsEmptyImplCopyWith<$Res> {
  __$$SearchSuggestionsEmptyImplCopyWithImpl(
      _$SearchSuggestionsEmptyImpl _value,
      $Res Function(_$SearchSuggestionsEmptyImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
  }) {
    return _then(_$SearchSuggestionsEmptyImpl(
      null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchSuggestionsEmptyImpl implements SearchSuggestionsEmpty {
  const _$SearchSuggestionsEmptyImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'SearchSuggestionsState.empty(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionsEmptyImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionsEmptyImplCopyWith<_$SearchSuggestionsEmptyImpl>
      get copyWith => __$$SearchSuggestionsEmptyImplCopyWithImpl<
          _$SearchSuggestionsEmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SearchSuggestion> suggestions, String query)
        loaded,
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
    TResult? Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    TResult Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    required TResult Function(SearchSuggestionsInitial value) initial,
    required TResult Function(SearchSuggestionsLoading value) loading,
    required TResult Function(SearchSuggestionsLoaded value) loaded,
    required TResult Function(SearchSuggestionsEmpty value) empty,
    required TResult Function(SearchSuggestionsError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchSuggestionsInitial value)? initial,
    TResult? Function(SearchSuggestionsLoading value)? loading,
    TResult? Function(SearchSuggestionsLoaded value)? loaded,
    TResult? Function(SearchSuggestionsEmpty value)? empty,
    TResult? Function(SearchSuggestionsError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchSuggestionsInitial value)? initial,
    TResult Function(SearchSuggestionsLoading value)? loading,
    TResult Function(SearchSuggestionsLoaded value)? loaded,
    TResult Function(SearchSuggestionsEmpty value)? empty,
    TResult Function(SearchSuggestionsError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class SearchSuggestionsEmpty implements SearchSuggestionsState {
  const factory SearchSuggestionsEmpty(final String query) =
      _$SearchSuggestionsEmptyImpl;

  String get query;

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionsEmptyImplCopyWith<_$SearchSuggestionsEmptyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchSuggestionsErrorImplCopyWith<$Res> {
  factory _$$SearchSuggestionsErrorImplCopyWith(
          _$SearchSuggestionsErrorImpl value,
          $Res Function(_$SearchSuggestionsErrorImpl) then) =
      __$$SearchSuggestionsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$SearchSuggestionsErrorImplCopyWithImpl<$Res>
    extends _$SearchSuggestionsStateCopyWithImpl<$Res,
        _$SearchSuggestionsErrorImpl>
    implements _$$SearchSuggestionsErrorImplCopyWith<$Res> {
  __$$SearchSuggestionsErrorImplCopyWithImpl(
      _$SearchSuggestionsErrorImpl _value,
      $Res Function(_$SearchSuggestionsErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$SearchSuggestionsErrorImpl(
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

class _$SearchSuggestionsErrorImpl implements SearchSuggestionsError {
  const _$SearchSuggestionsErrorImpl(this.message, this.code);

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'SearchSuggestionsState.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionsErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionsErrorImplCopyWith<_$SearchSuggestionsErrorImpl>
      get copyWith => __$$SearchSuggestionsErrorImplCopyWithImpl<
          _$SearchSuggestionsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SearchSuggestion> suggestions, String query)
        loaded,
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
    TResult? Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    TResult Function(List<SearchSuggestion> suggestions, String query)? loaded,
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
    required TResult Function(SearchSuggestionsInitial value) initial,
    required TResult Function(SearchSuggestionsLoading value) loading,
    required TResult Function(SearchSuggestionsLoaded value) loaded,
    required TResult Function(SearchSuggestionsEmpty value) empty,
    required TResult Function(SearchSuggestionsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchSuggestionsInitial value)? initial,
    TResult? Function(SearchSuggestionsLoading value)? loading,
    TResult? Function(SearchSuggestionsLoaded value)? loaded,
    TResult? Function(SearchSuggestionsEmpty value)? empty,
    TResult? Function(SearchSuggestionsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchSuggestionsInitial value)? initial,
    TResult Function(SearchSuggestionsLoading value)? loading,
    TResult Function(SearchSuggestionsLoaded value)? loaded,
    TResult Function(SearchSuggestionsEmpty value)? empty,
    TResult Function(SearchSuggestionsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SearchSuggestionsError implements SearchSuggestionsState {
  const factory SearchSuggestionsError(
      final String message, final String? code) = _$SearchSuggestionsErrorImpl;

  String get message;
  String? get code;

  /// Create a copy of SearchSuggestionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionsErrorImplCopyWith<_$SearchSuggestionsErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}
