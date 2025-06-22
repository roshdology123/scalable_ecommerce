import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/profile_stats.dart';

part 'profile_stats_model.freezed.dart';
part 'profile_stats_model.g.dart';

@freezed
@HiveType(typeId: 6)
class ProfileStatsModel with _$ProfileStatsModel {
  const factory ProfileStatsModel({
    @HiveField(0) required String userId,
    @HiveField(1) @Default(0) int totalOrders,
    @HiveField(2) @Default(0) int completedOrders,
    @HiveField(3) @Default(0) int cancelledOrders,
    @HiveField(4) @Default(0.0) double totalSpent,
    @HiveField(5) @Default(0) int totalReviews,
    @HiveField(6) @Default(0.0) double averageRating,
    @HiveField(7) @Default(0) int favoritesCount,
    @HiveField(8) @Default(0) int wishlistItems,
    @HiveField(9) required DateTime memberSince,
    @HiveField(10) @Default(0) int loyaltyPoints,
    @HiveField(11) @Default('Bronze') String membershipTier,
    @HiveField(12) required DateTime lastOrderDate,
    @HiveField(13) required DateTime lastLoginDate,
  }) = _ProfileStatsModel;

  factory ProfileStatsModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.parse('2025-06-22 08:11:58');

    return ProfileStatsModel(
      userId: json['userId']?.toString() ?? '',
      totalOrders: json['totalOrders'] as int? ?? 0,
      completedOrders: json['completedOrders'] as int? ?? 0,
      cancelledOrders: json['cancelledOrders'] as int? ?? 0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      favoritesCount: json['favoritesCount'] as int? ?? 0,
      wishlistItems: json['wishlistItems'] as int? ?? 0,
      memberSince: json['memberSince'] != null
          ? DateTime.parse(json['memberSince'].toString())
          : now,
      loyaltyPoints: json['loyaltyPoints'] as int? ?? 0,
      membershipTier: json['membershipTier']?.toString() ?? 'Bronze',
      lastOrderDate: json['lastOrderDate'] != null
          ? DateTime.parse(json['lastOrderDate'].toString())
          : now,
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.parse(json['lastLoginDate'].toString())
          : now,
    );
  }

  factory ProfileStatsModel.fromProfileStats(ProfileStats stats) {
    return ProfileStatsModel(
      userId: stats.userId,
      totalOrders: stats.totalOrders,
      completedOrders: stats.completedOrders,
      cancelledOrders: stats.cancelledOrders,
      totalSpent: stats.totalSpent,
      totalReviews: stats.totalReviews,
      averageRating: stats.averageRating,
      favoritesCount: stats.favoritesCount,
      wishlistItems: stats.wishlistItems,
      memberSince: stats.memberSince,
      loyaltyPoints: stats.loyaltyPoints,
      membershipTier: stats.membershipTier,
      lastOrderDate: stats.lastOrderDate,
      lastLoginDate: stats.lastLoginDate,
    );
  }

  // Mock factory for testing with realistic data for roshdology123
  factory ProfileStatsModel.mock(String userId) {
    final now = DateTime.parse('2025-06-22 08:11:58');
    final memberSince = now.subtract(const Duration(days: 365)); // 1 year member

    return ProfileStatsModel(
      userId: userId,
      totalOrders: 24,
      completedOrders: 22,
      cancelledOrders: 1,
      totalSpent: 1847.50,
      totalReviews: 18,
      averageRating: 4.3,
      favoritesCount: 47,
      wishlistItems: 12,
      memberSince: memberSince,
      loyaltyPoints: 1250,
      membershipTier: 'Gold',
      lastOrderDate: now.subtract(const Duration(days: 5)),
      lastLoginDate: now.subtract(const Duration(hours: 2)),
    );
  }

  // Factory for new users with default stats
  factory ProfileStatsModel.newUser(String userId) {
    final now = DateTime.parse('2025-06-22 08:11:58');

    return ProfileStatsModel(
      userId: userId,
      memberSince: now,
      lastOrderDate: now,
      lastLoginDate: now,
    );
  }

}

// Extension for ProfileStatsModel
extension ProfileStatsModelExtension on ProfileStatsModel {
  ProfileStats toProfileStats() {
    return ProfileStats(
      userId: userId,
      totalOrders: totalOrders,
      completedOrders: completedOrders,
      cancelledOrders: cancelledOrders,
      totalSpent: totalSpent,
      totalReviews: totalReviews,
      averageRating: averageRating,
      favoritesCount: favoritesCount,
      wishlistItems: wishlistItems,
      memberSince: memberSince,
      loyaltyPoints: loyaltyPoints,
      membershipTier: membershipTier,
      lastOrderDate: lastOrderDate,
      lastLoginDate: lastLoginDate,
    );
  }

  int get pendingOrders => totalOrders - completedOrders - cancelledOrders;

  double get completionRate {
    if (totalOrders == 0) return 0.0;
    return (completedOrders / totalOrders) * 100;
  }

  String get membershipDuration {
    final now = DateTime.parse('2025-06-22 08:11:58');
    final difference = now.difference(memberSince);

    if (difference.inDays < 30) {
      return '${difference.inDays} days';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months';
    } else {
      return '${(difference.inDays / 365).floor()} years';
    }
  }

  // Calculate membership tier based on stats
  String calculateMembershipTier() {
    if (totalSpent >= 5000 || loyaltyPoints >= 2000) {
      return 'Platinum';
    } else if (totalSpent >= 2000 || loyaltyPoints >= 1000) {
      return 'Gold';
    } else if (totalSpent >= 500 || loyaltyPoints >= 300) {
      return 'Silver';
    } else {
      return 'Bronze';
    }
  }
}