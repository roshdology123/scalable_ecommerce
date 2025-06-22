import 'package:equatable/equatable.dart';

class ProfileStats extends Equatable {
  final String userId;
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double totalSpent;
  final int totalReviews;
  final double averageRating;
  final int favoritesCount;
  final int wishlistItems;
  final DateTime memberSince;
  final int loyaltyPoints;
  final String membershipTier;
  final DateTime lastOrderDate;
  final DateTime lastLoginDate;

  const ProfileStats({
    required this.userId,
    this.totalOrders = 0,
    this.completedOrders = 0,
    this.cancelledOrders = 0,
    this.totalSpent = 0.0,
    this.totalReviews = 0,
    this.averageRating = 0.0,
    this.favoritesCount = 0,
    this.wishlistItems = 0,
    required this.memberSince,
    this.loyaltyPoints = 0,
    this.membershipTier = 'Bronze',
    required this.lastOrderDate,
    required this.lastLoginDate,
  });

  /// Get number of pending orders
  int get pendingOrders => totalOrders - completedOrders - cancelledOrders;

  /// Get order completion rate as percentage
  double get completionRate {
    if (totalOrders == 0) return 0.0;
    return (completedOrders / totalOrders) * 100;
  }

  /// Get order cancellation rate as percentage
  double get cancellationRate {
    if (totalOrders == 0) return 0.0;
    return (cancelledOrders / totalOrders) * 100;
  }

  /// Get average order value
  double get averageOrderValue {
    if (completedOrders == 0) return 0.0;
    return totalSpent / completedOrders;
  }

  /// Get membership duration in a human-readable format
  String get membershipDuration {
    final now = DateTime.parse('2025-06-22 08:17:00');
    final difference = now.difference(memberSince);

    if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'}';
    }
  }

  /// Get membership duration in days
  int get membershipDurationInDays {
    final now = DateTime.parse('2025-06-22 08:17:00');
    return now.difference(memberSince).inDays;
  }

  /// Get days since last order
  int get daysSinceLastOrder {
    final now = DateTime.parse('2025-06-22 08:17:00');
    return now.difference(lastOrderDate).inDays;
  }

  /// Get days since last login
  int get daysSinceLastLogin {
    final now = DateTime.parse('2025-06-22 08:17:00');
    return now.difference(lastLoginDate).inDays;
  }

  /// Check if user is an active customer (ordered within last 30 days)
  bool get isActiveCustomer {
    return daysSinceLastOrder <= 30;
  }

  /// Check if user is a recent member (joined within last 90 days)
  bool get isRecentMember {
    return membershipDurationInDays <= 90;
  }

  /// Check if user is a frequent reviewer (has more than 10 reviews)
  bool get isFrequentReviewer {
    return totalReviews > 10;
  }

  /// Check if user is a high-value customer (spent more than $1000)
  bool get isHighValueCustomer {
    return totalSpent > 1000.0;
  }

  /// Get customer segment based on stats
  String get customerSegment {
    if (totalSpent > 5000 && completionRate > 90) {
      return 'VIP Customer';
    } else if (totalSpent > 2000 && completionRate > 80) {
      return 'Premium Customer';
    } else if (totalSpent > 500 && completionRate > 70) {
      return 'Regular Customer';
    } else if (totalOrders > 0) {
      return 'New Customer';
    } else {
      return 'Browser';
    }
  }

  /// Get loyalty tier based on points and spending
  String get loyaltyTier {
    if (loyaltyPoints >= 2000 || totalSpent >= 5000) {
      return 'Platinum';
    } else if (loyaltyPoints >= 1000 || totalSpent >= 2000) {
      return 'Gold';
    } else if (loyaltyPoints >= 300 || totalSpent >= 500) {
      return 'Silver';
    } else {
      return 'Bronze';
    }
  }

  /// Get engagement level based on activity
  String get engagementLevel {
    final activityScore = _calculateActivityScore();

    if (activityScore >= 80) {
      return 'Highly Engaged';
    } else if (activityScore >= 60) {
      return 'Moderately Engaged';
    } else if (activityScore >= 30) {
      return 'Lightly Engaged';
    } else {
      return 'Inactive';
    }
  }

  /// Calculate activity score (0-100)
  int _calculateActivityScore() {
    int score = 0;

    // Points for recent activity
    if (daysSinceLastLogin <= 7) {
      score += 25;
    } else if (daysSinceLastLogin <= 30) {
      score += 15;
    }

    // Points for orders
    if (daysSinceLastOrder <= 7) {
      score += 25;
    } else if (daysSinceLastOrder <= 30) {
      score += 15;
    }

    // Points for reviews
    if (totalReviews > 10) {
      score += 20;
    } else if (totalReviews > 5) {
      score += 15;
    } else if (totalReviews > 0) {
      score += 10;
    }

    // Points for favorites/wishlist activity
    if (favoritesCount > 20 || wishlistItems > 10) {
      score += 15;
    } else if (favoritesCount > 10 || wishlistItems > 5) {
      score += 10;
    } else if (favoritesCount > 0 || wishlistItems > 0) {
      score += 5;
    }

    // Points for completion rate
    if (completionRate > 90) {
      score += 15;
    } else if (completionRate > 80) {
      score += 10;
    } else if (completionRate > 70) {
      score += 5;
    }

    return score.clamp(0, 100);
  }

  /// Get formatted total spent with currency
  String get formattedTotalSpent {
    return '\$${totalSpent.toStringAsFixed(2)}';
  }

  /// Get formatted average order value with currency
  String get formattedAverageOrderValue {
    return '\$${averageOrderValue.toStringAsFixed(2)}';
  }

  /// Get next loyalty tier points needed
  int get pointsToNextTier {
    if (loyaltyPoints < 300) return 300 - loyaltyPoints;
    if (loyaltyPoints < 1000) return 1000 - loyaltyPoints;
    if (loyaltyPoints < 2000) return 2000 - loyaltyPoints;
    return 0; // Already at highest tier
  }

  /// Get next loyalty tier name
  String? get nextTierName {
    if (loyaltyPoints < 300) return 'Silver';
    if (loyaltyPoints < 1000) return 'Gold';
    if (loyaltyPoints < 2000) return 'Platinum';
    return null; // Already at highest tier
  }

  /// Create default stats for a new user
  factory ProfileStats.newUser(String userId) {
    final now = DateTime.parse('2025-06-22 08:17:00');
    return ProfileStats(
      userId: userId,
      memberSince: now,
      lastOrderDate: now,
      lastLoginDate: now,
    );
  }

  /// Create a copy of stats with updated fields
  ProfileStats copyWith({
    String? userId,
    int? totalOrders,
    int? completedOrders,
    int? cancelledOrders,
    double? totalSpent,
    int? totalReviews,
    double? averageRating,
    int? favoritesCount,
    int? wishlistItems,
    DateTime? memberSince,
    int? loyaltyPoints,
    String? membershipTier,
    DateTime? lastOrderDate,
    DateTime? lastLoginDate,
  }) {
    return ProfileStats(
      userId: userId ?? this.userId,
      totalOrders: totalOrders ?? this.totalOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      totalReviews: totalReviews ?? this.totalReviews,
      averageRating: averageRating ?? this.averageRating,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      wishlistItems: wishlistItems ?? this.wishlistItems,
      memberSince: memberSince ?? this.memberSince,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      membershipTier: membershipTier ?? this.membershipTier,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
    );
  }

  @override
  List<Object?> get props => [
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
    lastLoginDate,
  ];

  @override
  String toString() => 'ProfileStats(userId: $userId, tier: $loyaltyTier, totalSpent: $formattedTotalSpent, segment: $customerSegment)';
}