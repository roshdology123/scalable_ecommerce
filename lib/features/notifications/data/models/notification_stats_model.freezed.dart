// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationStatsModel _$NotificationStatsModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationStatsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationStatsModel {
  int get totalNotifications => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  int get readCount => throw _privateConstructorUsedError;
  int get todayCount => throw _privateConstructorUsedError;
  int get weekCount => throw _privateConstructorUsedError;
  int get monthCount => throw _privateConstructorUsedError;
  Map<String, int> get typeBreakdown => throw _privateConstructorUsedError;
  Map<String, int> get priorityBreakdown => throw _privateConstructorUsedError;
  Map<String, int> get dailyStats =>
      throw _privateConstructorUsedError; // date -> count
  double get averageReadTime =>
      throw _privateConstructorUsedError; // in minutes
  double get engagementRate => throw _privateConstructorUsedError; // percentage
  DateTime? get lastNotificationAt => throw _privateConstructorUsedError;
  DateTime? get lastReadAt => throw _privateConstructorUsedError;
  String get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationStatsModelCopyWith<NotificationStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStatsModelCopyWith<$Res> {
  factory $NotificationStatsModelCopyWith(NotificationStatsModel value,
          $Res Function(NotificationStatsModel) then) =
      _$NotificationStatsModelCopyWithImpl<$Res, NotificationStatsModel>;
  @useResult
  $Res call(
      {int totalNotifications,
      int unreadCount,
      int readCount,
      int todayCount,
      int weekCount,
      int monthCount,
      Map<String, int> typeBreakdown,
      Map<String, int> priorityBreakdown,
      Map<String, int> dailyStats,
      double averageReadTime,
      double engagementRate,
      DateTime? lastNotificationAt,
      DateTime? lastReadAt,
      String generatedAt});
}

/// @nodoc
class _$NotificationStatsModelCopyWithImpl<$Res,
        $Val extends NotificationStatsModel>
    implements $NotificationStatsModelCopyWith<$Res> {
  _$NotificationStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNotifications = null,
    Object? unreadCount = null,
    Object? readCount = null,
    Object? todayCount = null,
    Object? weekCount = null,
    Object? monthCount = null,
    Object? typeBreakdown = null,
    Object? priorityBreakdown = null,
    Object? dailyStats = null,
    Object? averageReadTime = null,
    Object? engagementRate = null,
    Object? lastNotificationAt = freezed,
    Object? lastReadAt = freezed,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      totalNotifications: null == totalNotifications
          ? _value.totalNotifications
          : totalNotifications // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      readCount: null == readCount
          ? _value.readCount
          : readCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayCount: null == todayCount
          ? _value.todayCount
          : todayCount // ignore: cast_nullable_to_non_nullable
              as int,
      weekCount: null == weekCount
          ? _value.weekCount
          : weekCount // ignore: cast_nullable_to_non_nullable
              as int,
      monthCount: null == monthCount
          ? _value.monthCount
          : monthCount // ignore: cast_nullable_to_non_nullable
              as int,
      typeBreakdown: null == typeBreakdown
          ? _value.typeBreakdown
          : typeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      priorityBreakdown: null == priorityBreakdown
          ? _value.priorityBreakdown
          : priorityBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      dailyStats: null == dailyStats
          ? _value.dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageReadTime: null == averageReadTime
          ? _value.averageReadTime
          : averageReadTime // ignore: cast_nullable_to_non_nullable
              as double,
      engagementRate: null == engagementRate
          ? _value.engagementRate
          : engagementRate // ignore: cast_nullable_to_non_nullable
              as double,
      lastNotificationAt: freezed == lastNotificationAt
          ? _value.lastNotificationAt
          : lastNotificationAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReadAt: freezed == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationStatsModelImplCopyWith<$Res>
    implements $NotificationStatsModelCopyWith<$Res> {
  factory _$$NotificationStatsModelImplCopyWith(
          _$NotificationStatsModelImpl value,
          $Res Function(_$NotificationStatsModelImpl) then) =
      __$$NotificationStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalNotifications,
      int unreadCount,
      int readCount,
      int todayCount,
      int weekCount,
      int monthCount,
      Map<String, int> typeBreakdown,
      Map<String, int> priorityBreakdown,
      Map<String, int> dailyStats,
      double averageReadTime,
      double engagementRate,
      DateTime? lastNotificationAt,
      DateTime? lastReadAt,
      String generatedAt});
}

/// @nodoc
class __$$NotificationStatsModelImplCopyWithImpl<$Res>
    extends _$NotificationStatsModelCopyWithImpl<$Res,
        _$NotificationStatsModelImpl>
    implements _$$NotificationStatsModelImplCopyWith<$Res> {
  __$$NotificationStatsModelImplCopyWithImpl(
      _$NotificationStatsModelImpl _value,
      $Res Function(_$NotificationStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalNotifications = null,
    Object? unreadCount = null,
    Object? readCount = null,
    Object? todayCount = null,
    Object? weekCount = null,
    Object? monthCount = null,
    Object? typeBreakdown = null,
    Object? priorityBreakdown = null,
    Object? dailyStats = null,
    Object? averageReadTime = null,
    Object? engagementRate = null,
    Object? lastNotificationAt = freezed,
    Object? lastReadAt = freezed,
    Object? generatedAt = null,
  }) {
    return _then(_$NotificationStatsModelImpl(
      totalNotifications: null == totalNotifications
          ? _value.totalNotifications
          : totalNotifications // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      readCount: null == readCount
          ? _value.readCount
          : readCount // ignore: cast_nullable_to_non_nullable
              as int,
      todayCount: null == todayCount
          ? _value.todayCount
          : todayCount // ignore: cast_nullable_to_non_nullable
              as int,
      weekCount: null == weekCount
          ? _value.weekCount
          : weekCount // ignore: cast_nullable_to_non_nullable
              as int,
      monthCount: null == monthCount
          ? _value.monthCount
          : monthCount // ignore: cast_nullable_to_non_nullable
              as int,
      typeBreakdown: null == typeBreakdown
          ? _value._typeBreakdown
          : typeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      priorityBreakdown: null == priorityBreakdown
          ? _value._priorityBreakdown
          : priorityBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      dailyStats: null == dailyStats
          ? _value._dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageReadTime: null == averageReadTime
          ? _value.averageReadTime
          : averageReadTime // ignore: cast_nullable_to_non_nullable
              as double,
      engagementRate: null == engagementRate
          ? _value.engagementRate
          : engagementRate // ignore: cast_nullable_to_non_nullable
              as double,
      lastNotificationAt: freezed == lastNotificationAt
          ? _value.lastNotificationAt
          : lastNotificationAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReadAt: freezed == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationStatsModelImpl implements _NotificationStatsModel {
  const _$NotificationStatsModelImpl(
      {this.totalNotifications = 0,
      this.unreadCount = 0,
      this.readCount = 0,
      this.todayCount = 0,
      this.weekCount = 0,
      this.monthCount = 0,
      final Map<String, int> typeBreakdown = const {},
      final Map<String, int> priorityBreakdown = const {},
      final Map<String, int> dailyStats = const {},
      this.averageReadTime = 0.0,
      this.engagementRate = 0.0,
      this.lastNotificationAt,
      this.lastReadAt,
      this.generatedAt = '2025-06-23 08:18:38'})
      : _typeBreakdown = typeBreakdown,
        _priorityBreakdown = priorityBreakdown,
        _dailyStats = dailyStats;

  factory _$NotificationStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final int totalNotifications;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  @JsonKey()
  final int readCount;
  @override
  @JsonKey()
  final int todayCount;
  @override
  @JsonKey()
  final int weekCount;
  @override
  @JsonKey()
  final int monthCount;
  final Map<String, int> _typeBreakdown;
  @override
  @JsonKey()
  Map<String, int> get typeBreakdown {
    if (_typeBreakdown is EqualUnmodifiableMapView) return _typeBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_typeBreakdown);
  }

  final Map<String, int> _priorityBreakdown;
  @override
  @JsonKey()
  Map<String, int> get priorityBreakdown {
    if (_priorityBreakdown is EqualUnmodifiableMapView)
      return _priorityBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_priorityBreakdown);
  }

  final Map<String, int> _dailyStats;
  @override
  @JsonKey()
  Map<String, int> get dailyStats {
    if (_dailyStats is EqualUnmodifiableMapView) return _dailyStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyStats);
  }

// date -> count
  @override
  @JsonKey()
  final double averageReadTime;
// in minutes
  @override
  @JsonKey()
  final double engagementRate;
// percentage
  @override
  final DateTime? lastNotificationAt;
  @override
  final DateTime? lastReadAt;
  @override
  @JsonKey()
  final String generatedAt;

  @override
  String toString() {
    return 'NotificationStatsModel(totalNotifications: $totalNotifications, unreadCount: $unreadCount, readCount: $readCount, todayCount: $todayCount, weekCount: $weekCount, monthCount: $monthCount, typeBreakdown: $typeBreakdown, priorityBreakdown: $priorityBreakdown, dailyStats: $dailyStats, averageReadTime: $averageReadTime, engagementRate: $engagementRate, lastNotificationAt: $lastNotificationAt, lastReadAt: $lastReadAt, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationStatsModelImpl &&
            (identical(other.totalNotifications, totalNotifications) ||
                other.totalNotifications == totalNotifications) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.readCount, readCount) ||
                other.readCount == readCount) &&
            (identical(other.todayCount, todayCount) ||
                other.todayCount == todayCount) &&
            (identical(other.weekCount, weekCount) ||
                other.weekCount == weekCount) &&
            (identical(other.monthCount, monthCount) ||
                other.monthCount == monthCount) &&
            const DeepCollectionEquality()
                .equals(other._typeBreakdown, _typeBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._priorityBreakdown, _priorityBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._dailyStats, _dailyStats) &&
            (identical(other.averageReadTime, averageReadTime) ||
                other.averageReadTime == averageReadTime) &&
            (identical(other.engagementRate, engagementRate) ||
                other.engagementRate == engagementRate) &&
            (identical(other.lastNotificationAt, lastNotificationAt) ||
                other.lastNotificationAt == lastNotificationAt) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalNotifications,
      unreadCount,
      readCount,
      todayCount,
      weekCount,
      monthCount,
      const DeepCollectionEquality().hash(_typeBreakdown),
      const DeepCollectionEquality().hash(_priorityBreakdown),
      const DeepCollectionEquality().hash(_dailyStats),
      averageReadTime,
      engagementRate,
      lastNotificationAt,
      lastReadAt,
      generatedAt);

  /// Create a copy of NotificationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationStatsModelImplCopyWith<_$NotificationStatsModelImpl>
      get copyWith => __$$NotificationStatsModelImplCopyWithImpl<
          _$NotificationStatsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationStatsModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationStatsModel implements NotificationStatsModel {
  const factory _NotificationStatsModel(
      {final int totalNotifications,
      final int unreadCount,
      final int readCount,
      final int todayCount,
      final int weekCount,
      final int monthCount,
      final Map<String, int> typeBreakdown,
      final Map<String, int> priorityBreakdown,
      final Map<String, int> dailyStats,
      final double averageReadTime,
      final double engagementRate,
      final DateTime? lastNotificationAt,
      final DateTime? lastReadAt,
      final String generatedAt}) = _$NotificationStatsModelImpl;

  factory _NotificationStatsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationStatsModelImpl.fromJson;

  @override
  int get totalNotifications;
  @override
  int get unreadCount;
  @override
  int get readCount;
  @override
  int get todayCount;
  @override
  int get weekCount;
  @override
  int get monthCount;
  @override
  Map<String, int> get typeBreakdown;
  @override
  Map<String, int> get priorityBreakdown;
  @override
  Map<String, int> get dailyStats; // date -> count
  @override
  double get averageReadTime; // in minutes
  @override
  double get engagementRate; // percentage
  @override
  DateTime? get lastNotificationAt;
  @override
  DateTime? get lastReadAt;
  @override
  String get generatedAt;

  /// Create a copy of NotificationStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationStatsModelImplCopyWith<_$NotificationStatsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
