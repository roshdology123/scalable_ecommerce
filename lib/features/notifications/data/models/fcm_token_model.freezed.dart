// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FCMTokenModel _$FCMTokenModelFromJson(Map<String, dynamic> json) {
  return _FCMTokenModel.fromJson(json);
}

/// @nodoc
mixin _$FCMTokenModel {
  @HiveField(0)
  String get token => throw _privateConstructorUsedError;
  @HiveField(1)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get deviceId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get platform => throw _privateConstructorUsedError; // 'android', 'ios'
  @HiveField(4)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get appVersion => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get deviceModel => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get osVersion => throw _privateConstructorUsedError;
  @HiveField(10)
  List<String> get subscribedTopics => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get needsSync => throw _privateConstructorUsedError;

  /// Serializes this FCMTokenModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FCMTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FCMTokenModelCopyWith<FCMTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMTokenModelCopyWith<$Res> {
  factory $FCMTokenModelCopyWith(
          FCMTokenModel value, $Res Function(FCMTokenModel) then) =
      _$FCMTokenModelCopyWithImpl<$Res, FCMTokenModel>;
  @useResult
  $Res call(
      {@HiveField(0) String token,
      @HiveField(1) String userId,
      @HiveField(2) String deviceId,
      @HiveField(3) String platform,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime lastUpdated,
      @HiveField(6) bool isActive,
      @HiveField(7) String? appVersion,
      @HiveField(8) String? deviceModel,
      @HiveField(9) String? osVersion,
      @HiveField(10) List<String> subscribedTopics,
      @HiveField(11) DateTime? lastSyncedAt,
      @HiveField(12) bool needsSync});
}

/// @nodoc
class _$FCMTokenModelCopyWithImpl<$Res, $Val extends FCMTokenModel>
    implements $FCMTokenModelCopyWith<$Res> {
  _$FCMTokenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FCMTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? deviceId = null,
    Object? platform = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? isActive = null,
    Object? appVersion = freezed,
    Object? deviceModel = freezed,
    Object? osVersion = freezed,
    Object? subscribedTopics = null,
    Object? lastSyncedAt = freezed,
    Object? needsSync = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      osVersion: freezed == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      subscribedTopics: null == subscribedTopics
          ? _value.subscribedTopics
          : subscribedTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsSync: null == needsSync
          ? _value.needsSync
          : needsSync // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMTokenModelImplCopyWith<$Res>
    implements $FCMTokenModelCopyWith<$Res> {
  factory _$$FCMTokenModelImplCopyWith(
          _$FCMTokenModelImpl value, $Res Function(_$FCMTokenModelImpl) then) =
      __$$FCMTokenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String token,
      @HiveField(1) String userId,
      @HiveField(2) String deviceId,
      @HiveField(3) String platform,
      @HiveField(4) DateTime createdAt,
      @HiveField(5) DateTime lastUpdated,
      @HiveField(6) bool isActive,
      @HiveField(7) String? appVersion,
      @HiveField(8) String? deviceModel,
      @HiveField(9) String? osVersion,
      @HiveField(10) List<String> subscribedTopics,
      @HiveField(11) DateTime? lastSyncedAt,
      @HiveField(12) bool needsSync});
}

/// @nodoc
class __$$FCMTokenModelImplCopyWithImpl<$Res>
    extends _$FCMTokenModelCopyWithImpl<$Res, _$FCMTokenModelImpl>
    implements _$$FCMTokenModelImplCopyWith<$Res> {
  __$$FCMTokenModelImplCopyWithImpl(
      _$FCMTokenModelImpl _value, $Res Function(_$FCMTokenModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FCMTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? deviceId = null,
    Object? platform = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? isActive = null,
    Object? appVersion = freezed,
    Object? deviceModel = freezed,
    Object? osVersion = freezed,
    Object? subscribedTopics = null,
    Object? lastSyncedAt = freezed,
    Object? needsSync = null,
  }) {
    return _then(_$FCMTokenModelImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      osVersion: freezed == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      subscribedTopics: null == subscribedTopics
          ? _value._subscribedTopics
          : subscribedTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsSync: null == needsSync
          ? _value.needsSync
          : needsSync // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMTokenModelImpl implements _FCMTokenModel {
  const _$FCMTokenModelImpl(
      {@HiveField(0) required this.token,
      @HiveField(1) required this.userId,
      @HiveField(2) required this.deviceId,
      @HiveField(3) required this.platform,
      @HiveField(4) required this.createdAt,
      @HiveField(5) required this.lastUpdated,
      @HiveField(6) this.isActive = true,
      @HiveField(7) this.appVersion,
      @HiveField(8) this.deviceModel,
      @HiveField(9) this.osVersion,
      @HiveField(10) final List<String> subscribedTopics = const [],
      @HiveField(11) this.lastSyncedAt,
      @HiveField(12) this.needsSync = false})
      : _subscribedTopics = subscribedTopics;

  factory _$FCMTokenModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMTokenModelImplFromJson(json);

  @override
  @HiveField(0)
  final String token;
  @override
  @HiveField(1)
  final String userId;
  @override
  @HiveField(2)
  final String deviceId;
  @override
  @HiveField(3)
  final String platform;
// 'android', 'ios'
  @override
  @HiveField(4)
  final DateTime createdAt;
  @override
  @HiveField(5)
  final DateTime lastUpdated;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isActive;
  @override
  @HiveField(7)
  final String? appVersion;
  @override
  @HiveField(8)
  final String? deviceModel;
  @override
  @HiveField(9)
  final String? osVersion;
  final List<String> _subscribedTopics;
  @override
  @JsonKey()
  @HiveField(10)
  List<String> get subscribedTopics {
    if (_subscribedTopics is EqualUnmodifiableListView)
      return _subscribedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscribedTopics);
  }

  @override
  @HiveField(11)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(12)
  final bool needsSync;

  @override
  String toString() {
    return 'FCMTokenModel(token: $token, userId: $userId, deviceId: $deviceId, platform: $platform, createdAt: $createdAt, lastUpdated: $lastUpdated, isActive: $isActive, appVersion: $appVersion, deviceModel: $deviceModel, osVersion: $osVersion, subscribedTopics: $subscribedTopics, lastSyncedAt: $lastSyncedAt, needsSync: $needsSync)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMTokenModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.osVersion, osVersion) ||
                other.osVersion == osVersion) &&
            const DeepCollectionEquality()
                .equals(other._subscribedTopics, _subscribedTopics) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.needsSync, needsSync) ||
                other.needsSync == needsSync));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      token,
      userId,
      deviceId,
      platform,
      createdAt,
      lastUpdated,
      isActive,
      appVersion,
      deviceModel,
      osVersion,
      const DeepCollectionEquality().hash(_subscribedTopics),
      lastSyncedAt,
      needsSync);

  /// Create a copy of FCMTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMTokenModelImplCopyWith<_$FCMTokenModelImpl> get copyWith =>
      __$$FCMTokenModelImplCopyWithImpl<_$FCMTokenModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMTokenModelImplToJson(
      this,
    );
  }
}

abstract class _FCMTokenModel implements FCMTokenModel {
  const factory _FCMTokenModel(
      {@HiveField(0) required final String token,
      @HiveField(1) required final String userId,
      @HiveField(2) required final String deviceId,
      @HiveField(3) required final String platform,
      @HiveField(4) required final DateTime createdAt,
      @HiveField(5) required final DateTime lastUpdated,
      @HiveField(6) final bool isActive,
      @HiveField(7) final String? appVersion,
      @HiveField(8) final String? deviceModel,
      @HiveField(9) final String? osVersion,
      @HiveField(10) final List<String> subscribedTopics,
      @HiveField(11) final DateTime? lastSyncedAt,
      @HiveField(12) final bool needsSync}) = _$FCMTokenModelImpl;

  factory _FCMTokenModel.fromJson(Map<String, dynamic> json) =
      _$FCMTokenModelImpl.fromJson;

  @override
  @HiveField(0)
  String get token;
  @override
  @HiveField(1)
  String get userId;
  @override
  @HiveField(2)
  String get deviceId;
  @override
  @HiveField(3)
  String get platform; // 'android', 'ios'
  @override
  @HiveField(4)
  DateTime get createdAt;
  @override
  @HiveField(5)
  DateTime get lastUpdated;
  @override
  @HiveField(6)
  bool get isActive;
  @override
  @HiveField(7)
  String? get appVersion;
  @override
  @HiveField(8)
  String? get deviceModel;
  @override
  @HiveField(9)
  String? get osVersion;
  @override
  @HiveField(10)
  List<String> get subscribedTopics;
  @override
  @HiveField(11)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(12)
  bool get needsSync;

  /// Create a copy of FCMTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FCMTokenModelImplCopyWith<_$FCMTokenModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
