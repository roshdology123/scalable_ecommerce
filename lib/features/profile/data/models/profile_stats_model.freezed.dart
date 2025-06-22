// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileStatsModel {
  @HiveField(0)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(1)
  int get totalOrders => throw _privateConstructorUsedError;
  @HiveField(2)
  int get completedOrders => throw _privateConstructorUsedError;
  @HiveField(3)
  int get cancelledOrders => throw _privateConstructorUsedError;
  @HiveField(4)
  double get totalSpent => throw _privateConstructorUsedError;
  @HiveField(5)
  int get totalReviews => throw _privateConstructorUsedError;
  @HiveField(6)
  double get averageRating => throw _privateConstructorUsedError;
  @HiveField(7)
  int get favoritesCount => throw _privateConstructorUsedError;
  @HiveField(8)
  int get wishlistItems => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime get memberSince => throw _privateConstructorUsedError;
  @HiveField(10)
  int get loyaltyPoints => throw _privateConstructorUsedError;
  @HiveField(11)
  String get membershipTier => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime get lastOrderDate => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime get lastLoginDate => throw _privateConstructorUsedError;

  /// Create a copy of ProfileStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileStatsModelCopyWith<ProfileStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStatsModelCopyWith<$Res> {
  factory $ProfileStatsModelCopyWith(
          ProfileStatsModel value, $Res Function(ProfileStatsModel) then) =
      _$ProfileStatsModelCopyWithImpl<$Res, ProfileStatsModel>;
  @useResult
  $Res call(
      {@HiveField(0) String userId,
      @HiveField(1) int totalOrders,
      @HiveField(2) int completedOrders,
      @HiveField(3) int cancelledOrders,
      @HiveField(4) double totalSpent,
      @HiveField(5) int totalReviews,
      @HiveField(6) double averageRating,
      @HiveField(7) int favoritesCount,
      @HiveField(8) int wishlistItems,
      @HiveField(9) DateTime memberSince,
      @HiveField(10) int loyaltyPoints,
      @HiveField(11) String membershipTier,
      @HiveField(12) DateTime lastOrderDate,
      @HiveField(13) DateTime lastLoginDate});
}

/// @nodoc
class _$ProfileStatsModelCopyWithImpl<$Res, $Val extends ProfileStatsModel>
    implements $ProfileStatsModelCopyWith<$Res> {
  _$ProfileStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? cancelledOrders = null,
    Object? totalSpent = null,
    Object? totalReviews = null,
    Object? averageRating = null,
    Object? favoritesCount = null,
    Object? wishlistItems = null,
    Object? memberSince = null,
    Object? loyaltyPoints = null,
    Object? membershipTier = null,
    Object? lastOrderDate = null,
    Object? lastLoginDate = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledOrders: null == cancelledOrders
          ? _value.cancelledOrders
          : cancelledOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistItems: null == wishlistItems
          ? _value.wishlistItems
          : wishlistItems // ignore: cast_nullable_to_non_nullable
              as int,
      memberSince: null == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      loyaltyPoints: null == loyaltyPoints
          ? _value.loyaltyPoints
          : loyaltyPoints // ignore: cast_nullable_to_non_nullable
              as int,
      membershipTier: null == membershipTier
          ? _value.membershipTier
          : membershipTier // ignore: cast_nullable_to_non_nullable
              as String,
      lastOrderDate: null == lastOrderDate
          ? _value.lastOrderDate
          : lastOrderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginDate: null == lastLoginDate
          ? _value.lastLoginDate
          : lastLoginDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileStatsModelImplCopyWith<$Res>
    implements $ProfileStatsModelCopyWith<$Res> {
  factory _$$ProfileStatsModelImplCopyWith(_$ProfileStatsModelImpl value,
          $Res Function(_$ProfileStatsModelImpl) then) =
      __$$ProfileStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String userId,
      @HiveField(1) int totalOrders,
      @HiveField(2) int completedOrders,
      @HiveField(3) int cancelledOrders,
      @HiveField(4) double totalSpent,
      @HiveField(5) int totalReviews,
      @HiveField(6) double averageRating,
      @HiveField(7) int favoritesCount,
      @HiveField(8) int wishlistItems,
      @HiveField(9) DateTime memberSince,
      @HiveField(10) int loyaltyPoints,
      @HiveField(11) String membershipTier,
      @HiveField(12) DateTime lastOrderDate,
      @HiveField(13) DateTime lastLoginDate});
}

/// @nodoc
class __$$ProfileStatsModelImplCopyWithImpl<$Res>
    extends _$ProfileStatsModelCopyWithImpl<$Res, _$ProfileStatsModelImpl>
    implements _$$ProfileStatsModelImplCopyWith<$Res> {
  __$$ProfileStatsModelImplCopyWithImpl(_$ProfileStatsModelImpl _value,
      $Res Function(_$ProfileStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? cancelledOrders = null,
    Object? totalSpent = null,
    Object? totalReviews = null,
    Object? averageRating = null,
    Object? favoritesCount = null,
    Object? wishlistItems = null,
    Object? memberSince = null,
    Object? loyaltyPoints = null,
    Object? membershipTier = null,
    Object? lastOrderDate = null,
    Object? lastLoginDate = null,
  }) {
    return _then(_$ProfileStatsModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      completedOrders: null == completedOrders
          ? _value.completedOrders
          : completedOrders // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledOrders: null == cancelledOrders
          ? _value.cancelledOrders
          : cancelledOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      wishlistItems: null == wishlistItems
          ? _value.wishlistItems
          : wishlistItems // ignore: cast_nullable_to_non_nullable
              as int,
      memberSince: null == memberSince
          ? _value.memberSince
          : memberSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      loyaltyPoints: null == loyaltyPoints
          ? _value.loyaltyPoints
          : loyaltyPoints // ignore: cast_nullable_to_non_nullable
              as int,
      membershipTier: null == membershipTier
          ? _value.membershipTier
          : membershipTier // ignore: cast_nullable_to_non_nullable
              as String,
      lastOrderDate: null == lastOrderDate
          ? _value.lastOrderDate
          : lastOrderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginDate: null == lastLoginDate
          ? _value.lastLoginDate
          : lastLoginDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ProfileStatsModelImpl implements _ProfileStatsModel {
  const _$ProfileStatsModelImpl(
      {@HiveField(0) required this.userId,
      @HiveField(1) this.totalOrders = 0,
      @HiveField(2) this.completedOrders = 0,
      @HiveField(3) this.cancelledOrders = 0,
      @HiveField(4) this.totalSpent = 0.0,
      @HiveField(5) this.totalReviews = 0,
      @HiveField(6) this.averageRating = 0.0,
      @HiveField(7) this.favoritesCount = 0,
      @HiveField(8) this.wishlistItems = 0,
      @HiveField(9) required this.memberSince,
      @HiveField(10) this.loyaltyPoints = 0,
      @HiveField(11) this.membershipTier = 'Bronze',
      @HiveField(12) required this.lastOrderDate,
      @HiveField(13) required this.lastLoginDate});

  @override
  @HiveField(0)
  final String userId;
  @override
  @JsonKey()
  @HiveField(1)
  final int totalOrders;
  @override
  @JsonKey()
  @HiveField(2)
  final int completedOrders;
  @override
  @JsonKey()
  @HiveField(3)
  final int cancelledOrders;
  @override
  @JsonKey()
  @HiveField(4)
  final double totalSpent;
  @override
  @JsonKey()
  @HiveField(5)
  final int totalReviews;
  @override
  @JsonKey()
  @HiveField(6)
  final double averageRating;
  @override
  @JsonKey()
  @HiveField(7)
  final int favoritesCount;
  @override
  @JsonKey()
  @HiveField(8)
  final int wishlistItems;
  @override
  @HiveField(9)
  final DateTime memberSince;
  @override
  @JsonKey()
  @HiveField(10)
  final int loyaltyPoints;
  @override
  @JsonKey()
  @HiveField(11)
  final String membershipTier;
  @override
  @HiveField(12)
  final DateTime lastOrderDate;
  @override
  @HiveField(13)
  final DateTime lastLoginDate;

  @override
  String toString() {
    return 'ProfileStatsModel(userId: $userId, totalOrders: $totalOrders, completedOrders: $completedOrders, cancelledOrders: $cancelledOrders, totalSpent: $totalSpent, totalReviews: $totalReviews, averageRating: $averageRating, favoritesCount: $favoritesCount, wishlistItems: $wishlistItems, memberSince: $memberSince, loyaltyPoints: $loyaltyPoints, membershipTier: $membershipTier, lastOrderDate: $lastOrderDate, lastLoginDate: $lastLoginDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStatsModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.cancelledOrders, cancelledOrders) ||
                other.cancelledOrders == cancelledOrders) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.favoritesCount, favoritesCount) ||
                other.favoritesCount == favoritesCount) &&
            (identical(other.wishlistItems, wishlistItems) ||
                other.wishlistItems == wishlistItems) &&
            (identical(other.memberSince, memberSince) ||
                other.memberSince == memberSince) &&
            (identical(other.loyaltyPoints, loyaltyPoints) ||
                other.loyaltyPoints == loyaltyPoints) &&
            (identical(other.membershipTier, membershipTier) ||
                other.membershipTier == membershipTier) &&
            (identical(other.lastOrderDate, lastOrderDate) ||
                other.lastOrderDate == lastOrderDate) &&
            (identical(other.lastLoginDate, lastLoginDate) ||
                other.lastLoginDate == lastLoginDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalOrders,
      completedOrders,
      cancelledOrders,
      totalSpent,
      totalReviews,
      averageRating,
      favoritesCount,
      wishlistItems,
      memberSince,
      loyaltyPoints,
      membershipTier,
      lastOrderDate,
      lastLoginDate);

  /// Create a copy of ProfileStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStatsModelImplCopyWith<_$ProfileStatsModelImpl> get copyWith =>
      __$$ProfileStatsModelImplCopyWithImpl<_$ProfileStatsModelImpl>(
          this, _$identity);
}

abstract class _ProfileStatsModel implements ProfileStatsModel {
  const factory _ProfileStatsModel(
          {@HiveField(0) required final String userId,
          @HiveField(1) final int totalOrders,
          @HiveField(2) final int completedOrders,
          @HiveField(3) final int cancelledOrders,
          @HiveField(4) final double totalSpent,
          @HiveField(5) final int totalReviews,
          @HiveField(6) final double averageRating,
          @HiveField(7) final int favoritesCount,
          @HiveField(8) final int wishlistItems,
          @HiveField(9) required final DateTime memberSince,
          @HiveField(10) final int loyaltyPoints,
          @HiveField(11) final String membershipTier,
          @HiveField(12) required final DateTime lastOrderDate,
          @HiveField(13) required final DateTime lastLoginDate}) =
      _$ProfileStatsModelImpl;

  @override
  @HiveField(0)
  String get userId;
  @override
  @HiveField(1)
  int get totalOrders;
  @override
  @HiveField(2)
  int get completedOrders;
  @override
  @HiveField(3)
  int get cancelledOrders;
  @override
  @HiveField(4)
  double get totalSpent;
  @override
  @HiveField(5)
  int get totalReviews;
  @override
  @HiveField(6)
  double get averageRating;
  @override
  @HiveField(7)
  int get favoritesCount;
  @override
  @HiveField(8)
  int get wishlistItems;
  @override
  @HiveField(9)
  DateTime get memberSince;
  @override
  @HiveField(10)
  int get loyaltyPoints;
  @override
  @HiveField(11)
  String get membershipTier;
  @override
  @HiveField(12)
  DateTime get lastOrderDate;
  @override
  @HiveField(13)
  DateTime get lastLoginDate;

  /// Create a copy of ProfileStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileStatsModelImplCopyWith<_$ProfileStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
