// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationSyncState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)
        syncing,
    required TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)
        completed,
    required TResult Function(String error, DateTime lastSyncAttempt,
            int retryAttempts, bool canRetry)
        failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult? Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult? Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Failed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Failed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSyncStateCopyWith<$Res> {
  factory $NotificationSyncStateCopyWith(NotificationSyncState value,
          $Res Function(NotificationSyncState) then) =
      _$NotificationSyncStateCopyWithImpl<$Res, NotificationSyncState>;
}

/// @nodoc
class _$NotificationSyncStateCopyWithImpl<$Res,
        $Val extends NotificationSyncState>
    implements $NotificationSyncStateCopyWith<$Res> {
  _$NotificationSyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSyncState
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
    extends _$NotificationSyncStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'NotificationSyncState.initial()';
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
    required TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)
        syncing,
    required TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)
        completed,
    required TResult Function(String error, DateTime lastSyncAttempt,
            int retryAttempts, bool canRetry)
        failed,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult? Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult? Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
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
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Failed value) failed,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Failed value)? failed,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements NotificationSyncState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$SyncingImplCopyWith<$Res> {
  factory _$$SyncingImplCopyWith(
          _$SyncingImpl value, $Res Function(_$SyncingImpl) then) =
      __$$SyncingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isAutoSync, DateTime syncStartedAt, int retryAttempts});
}

/// @nodoc
class __$$SyncingImplCopyWithImpl<$Res>
    extends _$NotificationSyncStateCopyWithImpl<$Res, _$SyncingImpl>
    implements _$$SyncingImplCopyWith<$Res> {
  __$$SyncingImplCopyWithImpl(
      _$SyncingImpl _value, $Res Function(_$SyncingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAutoSync = null,
    Object? syncStartedAt = null,
    Object? retryAttempts = null,
  }) {
    return _then(_$SyncingImpl(
      isAutoSync: null == isAutoSync
          ? _value.isAutoSync
          : isAutoSync // ignore: cast_nullable_to_non_nullable
              as bool,
      syncStartedAt: null == syncStartedAt
          ? _value.syncStartedAt
          : syncStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      retryAttempts: null == retryAttempts
          ? _value.retryAttempts
          : retryAttempts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SyncingImpl implements _Syncing {
  const _$SyncingImpl(
      {this.isAutoSync = false,
      required this.syncStartedAt,
      this.retryAttempts = 0});

  @override
  @JsonKey()
  final bool isAutoSync;
  @override
  final DateTime syncStartedAt;
  @override
  @JsonKey()
  final int retryAttempts;

  @override
  String toString() {
    return 'NotificationSyncState.syncing(isAutoSync: $isAutoSync, syncStartedAt: $syncStartedAt, retryAttempts: $retryAttempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncingImpl &&
            (identical(other.isAutoSync, isAutoSync) ||
                other.isAutoSync == isAutoSync) &&
            (identical(other.syncStartedAt, syncStartedAt) ||
                other.syncStartedAt == syncStartedAt) &&
            (identical(other.retryAttempts, retryAttempts) ||
                other.retryAttempts == retryAttempts));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isAutoSync, syncStartedAt, retryAttempts);

  /// Create a copy of NotificationSyncState
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
    required TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)
        syncing,
    required TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)
        completed,
    required TResult Function(String error, DateTime lastSyncAttempt,
            int retryAttempts, bool canRetry)
        failed,
  }) {
    return syncing(isAutoSync, syncStartedAt, retryAttempts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult? Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult? Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
  }) {
    return syncing?.call(isAutoSync, syncStartedAt, retryAttempts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(isAutoSync, syncStartedAt, retryAttempts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Failed value) failed,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Failed value)? failed,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class _Syncing implements NotificationSyncState {
  const factory _Syncing(
      {final bool isAutoSync,
      required final DateTime syncStartedAt,
      final int retryAttempts}) = _$SyncingImpl;

  bool get isAutoSync;
  DateTime get syncStartedAt;
  int get retryAttempts;

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncingImplCopyWith<_$SyncingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompletedImplCopyWith<$Res> {
  factory _$$CompletedImplCopyWith(
          _$CompletedImpl value, $Res Function(_$CompletedImpl) then) =
      __$$CompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<AppNotification> syncedNotifications,
      DateTime lastSyncAt,
      int syncedCount,
      bool wasAutoSync});
}

/// @nodoc
class __$$CompletedImplCopyWithImpl<$Res>
    extends _$NotificationSyncStateCopyWithImpl<$Res, _$CompletedImpl>
    implements _$$CompletedImplCopyWith<$Res> {
  __$$CompletedImplCopyWithImpl(
      _$CompletedImpl _value, $Res Function(_$CompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncedNotifications = null,
    Object? lastSyncAt = null,
    Object? syncedCount = null,
    Object? wasAutoSync = null,
  }) {
    return _then(_$CompletedImpl(
      syncedNotifications: null == syncedNotifications
          ? _value._syncedNotifications
          : syncedNotifications // ignore: cast_nullable_to_non_nullable
              as List<AppNotification>,
      lastSyncAt: null == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncedCount: null == syncedCount
          ? _value.syncedCount
          : syncedCount // ignore: cast_nullable_to_non_nullable
              as int,
      wasAutoSync: null == wasAutoSync
          ? _value.wasAutoSync
          : wasAutoSync // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CompletedImpl implements _Completed {
  const _$CompletedImpl(
      {required final List<AppNotification> syncedNotifications,
      required this.lastSyncAt,
      required this.syncedCount,
      this.wasAutoSync = false})
      : _syncedNotifications = syncedNotifications;

  final List<AppNotification> _syncedNotifications;
  @override
  List<AppNotification> get syncedNotifications {
    if (_syncedNotifications is EqualUnmodifiableListView)
      return _syncedNotifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_syncedNotifications);
  }

  @override
  final DateTime lastSyncAt;
  @override
  final int syncedCount;
  @override
  @JsonKey()
  final bool wasAutoSync;

  @override
  String toString() {
    return 'NotificationSyncState.completed(syncedNotifications: $syncedNotifications, lastSyncAt: $lastSyncAt, syncedCount: $syncedCount, wasAutoSync: $wasAutoSync)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletedImpl &&
            const DeepCollectionEquality()
                .equals(other._syncedNotifications, _syncedNotifications) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.syncedCount, syncedCount) ||
                other.syncedCount == syncedCount) &&
            (identical(other.wasAutoSync, wasAutoSync) ||
                other.wasAutoSync == wasAutoSync));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_syncedNotifications),
      lastSyncAt,
      syncedCount,
      wasAutoSync);

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletedImplCopyWith<_$CompletedImpl> get copyWith =>
      __$$CompletedImplCopyWithImpl<_$CompletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)
        syncing,
    required TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)
        completed,
    required TResult Function(String error, DateTime lastSyncAttempt,
            int retryAttempts, bool canRetry)
        failed,
  }) {
    return completed(syncedNotifications, lastSyncAt, syncedCount, wasAutoSync);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult? Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult? Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
  }) {
    return completed?.call(
        syncedNotifications, lastSyncAt, syncedCount, wasAutoSync);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(
          syncedNotifications, lastSyncAt, syncedCount, wasAutoSync);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Failed value) failed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Failed value)? failed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class _Completed implements NotificationSyncState {
  const factory _Completed(
      {required final List<AppNotification> syncedNotifications,
      required final DateTime lastSyncAt,
      required final int syncedCount,
      final bool wasAutoSync}) = _$CompletedImpl;

  List<AppNotification> get syncedNotifications;
  DateTime get lastSyncAt;
  int get syncedCount;
  bool get wasAutoSync;

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletedImplCopyWith<_$CompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailedImplCopyWith<$Res> {
  factory _$$FailedImplCopyWith(
          _$FailedImpl value, $Res Function(_$FailedImpl) then) =
      __$$FailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String error,
      DateTime lastSyncAttempt,
      int retryAttempts,
      bool canRetry});
}

/// @nodoc
class __$$FailedImplCopyWithImpl<$Res>
    extends _$NotificationSyncStateCopyWithImpl<$Res, _$FailedImpl>
    implements _$$FailedImplCopyWith<$Res> {
  __$$FailedImplCopyWithImpl(
      _$FailedImpl _value, $Res Function(_$FailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? lastSyncAttempt = null,
    Object? retryAttempts = null,
    Object? canRetry = null,
  }) {
    return _then(_$FailedImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncAttempt: null == lastSyncAttempt
          ? _value.lastSyncAttempt
          : lastSyncAttempt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      retryAttempts: null == retryAttempts
          ? _value.retryAttempts
          : retryAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      canRetry: null == canRetry
          ? _value.canRetry
          : canRetry // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FailedImpl implements _Failed {
  const _$FailedImpl(
      {required this.error,
      required this.lastSyncAttempt,
      this.retryAttempts = 0,
      this.canRetry = true});

  @override
  final String error;
  @override
  final DateTime lastSyncAttempt;
  @override
  @JsonKey()
  final int retryAttempts;
  @override
  @JsonKey()
  final bool canRetry;

  @override
  String toString() {
    return 'NotificationSyncState.failed(error: $error, lastSyncAttempt: $lastSyncAttempt, retryAttempts: $retryAttempts, canRetry: $canRetry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailedImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.lastSyncAttempt, lastSyncAttempt) ||
                other.lastSyncAttempt == lastSyncAttempt) &&
            (identical(other.retryAttempts, retryAttempts) ||
                other.retryAttempts == retryAttempts) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, error, lastSyncAttempt, retryAttempts, canRetry);

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      __$$FailedImplCopyWithImpl<_$FailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)
        syncing,
    required TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)
        completed,
    required TResult Function(String error, DateTime lastSyncAttempt,
            int retryAttempts, bool canRetry)
        failed,
  }) {
    return failed(error, lastSyncAttempt, retryAttempts, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult? Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult? Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
  }) {
    return failed?.call(error, lastSyncAttempt, retryAttempts, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            bool isAutoSync, DateTime syncStartedAt, int retryAttempts)?
        syncing,
    TResult Function(List<AppNotification> syncedNotifications,
            DateTime lastSyncAt, int syncedCount, bool wasAutoSync)?
        completed,
    TResult Function(String error, DateTime lastSyncAttempt, int retryAttempts,
            bool canRetry)?
        failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(error, lastSyncAttempt, retryAttempts, canRetry);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_Completed value) completed,
    required TResult Function(_Failed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_Completed value)? completed,
    TResult? Function(_Failed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_Completed value)? completed,
    TResult Function(_Failed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class _Failed implements NotificationSyncState {
  const factory _Failed(
      {required final String error,
      required final DateTime lastSyncAttempt,
      final int retryAttempts,
      final bool canRetry}) = _$FailedImpl;

  String get error;
  DateTime get lastSyncAttempt;
  int get retryAttempts;
  bool get canRetry;

  /// Create a copy of NotificationSyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
