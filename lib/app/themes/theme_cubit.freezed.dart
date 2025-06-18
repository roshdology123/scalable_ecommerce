// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ThemeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ThemeInitial value) initial,
    required TResult Function(ThemeLoaded value) loaded,
    required TResult Function(ThemeError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ThemeInitial value)? initial,
    TResult? Function(ThemeLoaded value)? loaded,
    TResult? Function(ThemeError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ThemeInitial value)? initial,
    TResult Function(ThemeLoaded value)? loaded,
    TResult Function(ThemeError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeStateCopyWith<$Res> {
  factory $ThemeStateCopyWith(
          ThemeState value, $Res Function(ThemeState) then) =
      _$ThemeStateCopyWithImpl<$Res, ThemeState>;
}

/// @nodoc
class _$ThemeStateCopyWithImpl<$Res, $Val extends ThemeState>
    implements $ThemeStateCopyWith<$Res> {
  _$ThemeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ThemeInitialImplCopyWith<$Res> {
  factory _$$ThemeInitialImplCopyWith(
          _$ThemeInitialImpl value, $Res Function(_$ThemeInitialImpl) then) =
      __$$ThemeInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ThemeInitialImplCopyWithImpl<$Res>
    extends _$ThemeStateCopyWithImpl<$Res, _$ThemeInitialImpl>
    implements _$$ThemeInitialImplCopyWith<$Res> {
  __$$ThemeInitialImplCopyWithImpl(
      _$ThemeInitialImpl _value, $Res Function(_$ThemeInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ThemeInitialImpl implements ThemeInitial {
  const _$ThemeInitialImpl();

  @override
  String toString() {
    return 'ThemeState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ThemeInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)
        loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult Function(String message)? error,
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
    required TResult Function(ThemeInitial value) initial,
    required TResult Function(ThemeLoaded value) loaded,
    required TResult Function(ThemeError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ThemeInitial value)? initial,
    TResult? Function(ThemeLoaded value)? loaded,
    TResult? Function(ThemeError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ThemeInitial value)? initial,
    TResult Function(ThemeLoaded value)? loaded,
    TResult Function(ThemeError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ThemeInitial implements ThemeState {
  const factory ThemeInitial() = _$ThemeInitialImpl;
}

/// @nodoc
abstract class _$$ThemeLoadedImplCopyWith<$Res> {
  factory _$$ThemeLoadedImplCopyWith(
          _$ThemeLoadedImpl value, $Res Function(_$ThemeLoadedImpl) then) =
      __$$ThemeLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme});
}

/// @nodoc
class __$$ThemeLoadedImplCopyWithImpl<$Res>
    extends _$ThemeStateCopyWithImpl<$Res, _$ThemeLoadedImpl>
    implements _$$ThemeLoadedImplCopyWith<$Res> {
  __$$ThemeLoadedImplCopyWithImpl(
      _$ThemeLoadedImpl _value, $Res Function(_$ThemeLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? lightTheme = null,
    Object? darkTheme = null,
  }) {
    return _then(_$ThemeLoadedImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      lightTheme: null == lightTheme
          ? _value.lightTheme
          : lightTheme // ignore: cast_nullable_to_non_nullable
              as ThemeData,
      darkTheme: null == darkTheme
          ? _value.darkTheme
          : darkTheme // ignore: cast_nullable_to_non_nullable
              as ThemeData,
    ));
  }
}

/// @nodoc

class _$ThemeLoadedImpl implements ThemeLoaded {
  const _$ThemeLoadedImpl(
      {required this.themeMode,
      required this.lightTheme,
      required this.darkTheme});

  @override
  final ThemeMode themeMode;
  @override
  final ThemeData lightTheme;
  @override
  final ThemeData darkTheme;

  @override
  String toString() {
    return 'ThemeState.loaded(themeMode: $themeMode, lightTheme: $lightTheme, darkTheme: $darkTheme)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeLoadedImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.lightTheme, lightTheme) ||
                other.lightTheme == lightTheme) &&
            (identical(other.darkTheme, darkTheme) ||
                other.darkTheme == darkTheme));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, themeMode, lightTheme, darkTheme);

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeLoadedImplCopyWith<_$ThemeLoadedImpl> get copyWith =>
      __$$ThemeLoadedImplCopyWithImpl<_$ThemeLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(themeMode, lightTheme, darkTheme);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(themeMode, lightTheme, darkTheme);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(themeMode, lightTheme, darkTheme);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ThemeInitial value) initial,
    required TResult Function(ThemeLoaded value) loaded,
    required TResult Function(ThemeError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ThemeInitial value)? initial,
    TResult? Function(ThemeLoaded value)? loaded,
    TResult? Function(ThemeError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ThemeInitial value)? initial,
    TResult Function(ThemeLoaded value)? loaded,
    TResult Function(ThemeError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ThemeLoaded implements ThemeState {
  const factory ThemeLoaded(
      {required final ThemeMode themeMode,
      required final ThemeData lightTheme,
      required final ThemeData darkTheme}) = _$ThemeLoadedImpl;

  ThemeMode get themeMode;
  ThemeData get lightTheme;
  ThemeData get darkTheme;

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThemeLoadedImplCopyWith<_$ThemeLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ThemeErrorImplCopyWith<$Res> {
  factory _$$ThemeErrorImplCopyWith(
          _$ThemeErrorImpl value, $Res Function(_$ThemeErrorImpl) then) =
      __$$ThemeErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ThemeErrorImplCopyWithImpl<$Res>
    extends _$ThemeStateCopyWithImpl<$Res, _$ThemeErrorImpl>
    implements _$$ThemeErrorImplCopyWith<$Res> {
  __$$ThemeErrorImplCopyWithImpl(
      _$ThemeErrorImpl _value, $Res Function(_$ThemeErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ThemeErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ThemeErrorImpl implements ThemeError {
  const _$ThemeErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ThemeState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeErrorImplCopyWith<_$ThemeErrorImpl> get copyWith =>
      __$$ThemeErrorImplCopyWithImpl<_$ThemeErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            ThemeMode themeMode, ThemeData lightTheme, ThemeData darkTheme)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ThemeInitial value) initial,
    required TResult Function(ThemeLoaded value) loaded,
    required TResult Function(ThemeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ThemeInitial value)? initial,
    TResult? Function(ThemeLoaded value)? loaded,
    TResult? Function(ThemeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ThemeInitial value)? initial,
    TResult Function(ThemeLoaded value)? loaded,
    TResult Function(ThemeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ThemeError implements ThemeState {
  const factory ThemeError(final String message) = _$ThemeErrorImpl;

  String get message;

  /// Create a copy of ThemeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThemeErrorImplCopyWith<_$ThemeErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
