




import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/profile_stats.dart';
import '../../../domain/usecases/get_profile_stats_usecase.dart';
import 'profile_stats_state.dart';

/// Profile Stats Cubit manages user statistics and analytics
///
/// Handles:
/// - Loading and refreshing profile statistics
/// - Analyzing user behavior patterns
/// - Providing insights and recommendations
/// - Comparing stats across different periods
/// - Calculating engagement metrics
/// - Membership tier tracking
@injectable
class ProfileStatsCubit extends Cubit<ProfileStatsState> {
  final GetProfileStatsUseCase _getProfileStatsUseCase;

  ProfileStats? _currentStats;
  DateTime? _lastUpdated;

  ProfileStatsCubit({
    required GetProfileStatsUseCase getProfileStatsUseCase,
  })  : _getProfileStatsUseCase = getProfileStatsUseCase,
        super(const ProfileStatsInitial()) {
    debugPrint('ProfileStatsCubit initialized for roshdology123 at 2025-06-22 08:54:25');
  }

  /// Get current stats
  ProfileStats? get currentStats => _currentStats;

  /// Get last updated timestamp
  DateTime? get lastUpdated => _lastUpdated;

  /// Load profile statistics
  Future<void> loadStats() async {
    if (state is ProfileStatsLoading) return;

    emit(const ProfileStatsLoading());
    debugPrint('Loading profile stats for roshdology123...');

    final result = await _getProfileStatsUseCase(const NoParams());

    result.fold(
          (failure) {
        debugPrint('Failed to load profile stats: ${failure.message}');

        if (failure.code == 'NO_INTERNET_CONNECTION') {
          emit(ProfileStatsNetworkError(
            message: 'No internet connection. Showing cached stats.',
            cachedStats: _currentStats,
          ));
        } else {
          emit(ProfileStatsError(
            message: failure.message,
            code: failure.code.toString(),
            currentStats: _currentStats,
          ));
        }
      },
          (stats) {
        debugPrint('Profile stats loaded successfully');
        debugPrint('Stats Summary: ${stats.customerSegment}, ${stats.loyaltyTier}, ${stats.formattedTotalSpent}');

        _currentStats = stats;
        _lastUpdated = DateTime.parse('2025-06-22 08:54:25');
        emit(ProfileStatsLoaded(stats: stats));
      },
    );
  }

  /// Refresh profile statistics
  Future<void> refreshStats() async {
    if (_currentStats == null) {
      await loadStats();
      return;
    }

    emit(ProfileStatsRefreshing(currentStats: _currentStats!));
    debugPrint('Refreshing profile stats...');

    final previousStats = _currentStats;
    final result = await _getProfileStatsUseCase(const NoParams());

    result.fold(
          (failure) {
        debugPrint('Failed to refresh profile stats: ${failure.message}');
        emit(ProfileStatsError(
          message: failure.message,
          code: failure.code.toString(),
          currentStats: _currentStats,
        ));
      },
          (stats) {
        debugPrint('Profile stats refreshed successfully');

        _currentStats = stats;
        _lastUpdated = DateTime.parse('2025-06-22 08:54:25');

        // Check for significant changes
        _logStatsChanges(previousStats, stats);

        emit(ProfileStatsRefreshed(
          stats: stats,
          previousStats: previousStats,
        ));
      },
    );
  }

  /// Analyze profile statistics for insights
  Future<void> analyzeStats() async {
    if (_currentStats == null) {
      emit(const ProfileStatsError(
        message: 'No stats loaded. Please refresh and try again.',
        code: 'NO_CURRENT_STATS',
      ));
      return;
    }

    emit(ProfileStatsAnalyzing(currentStats: _currentStats!));
    debugPrint('Analyzing profile stats for insights...');

    // Simulate analysis delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final insights = _generateInsights(_currentStats!);
    final recommendations = _generateRecommendations(_currentStats!);

    debugPrint('Analysis complete: ${insights.length} insights, ${recommendations.length} recommendations');

    emit(ProfileStatsAnalyzed(
      stats: _currentStats!,
      insights: insights,
      recommendations: recommendations,
    ));
  }

  /// Compare stats with different periods
  Future<void> compareStats({String period = 'lastMonth'}) async {
    if (_currentStats == null) {
      emit(const ProfileStatsError(
        message: 'No stats loaded. Please refresh and try again.',
        code: 'NO_CURRENT_STATS',
      ));
      return;
    }

    emit(ProfileStatsComparing(currentStats: _currentStats!));
    debugPrint('Comparing stats for period: $period...');

    // Simulate comparison delay
    await Future.delayed(const Duration(milliseconds: 800));

    final comparison = _generateComparison(_currentStats!, period);
    final trends = _generateTrends(_currentStats!, comparison);

    debugPrint('Comparison complete for $period: ${trends.length} trends identified');

    emit(ProfileStatsCompared(
      currentStats: _currentStats!,
      comparison: comparison,
      trends: trends,
    ));
  }

  /// Clear any error states and return to loaded state
  void clearError() {
    if (_currentStats != null) {
      emit(ProfileStatsLoaded(stats: _currentStats!));
    } else {
      emit(const ProfileStatsInitial());
    }
  }

  /// Generate insights from profile stats
  Map<String, dynamic> _generateInsights(ProfileStats stats) {
    final insights = <String, dynamic>{};

    // Shopping behavior insights
    insights['shopping_frequency'] = _getShoppingFrequency(stats);
    insights['spending_pattern'] = _getSpendingPattern(stats);
    insights['loyalty_trajectory'] = _getLoyaltyTrajectory(stats);
    insights['engagement_score'] = _getEngagementScore(stats);

    // Performance metrics
    insights['completion_rate'] = stats.completionRate;
    insights['average_order_value'] = stats.averageOrderValue;
    insights['customer_lifetime_value'] = _calculateLifetimeValue(stats);

    // Behavioral indicators
    insights['is_power_user'] = stats.totalOrders > 20 && stats.completionRate > 85;
    insights['is_high_value'] = stats.isHighValueCustomer;
    insights['is_active'] = stats.isActiveCustomer;
    insights['review_contributor'] = stats.isFrequentReviewer;

    return insights;
  }

  /// Generate personalized recommendations
  List<String> _generateRecommendations(ProfileStats stats) {
    final recommendations = <String>[];

    // Spending recommendations
    if (stats.totalSpent > 1000 && stats.loyaltyPoints < 500) {
      recommendations.add('You\'re close to Silver tier! Make one more purchase to unlock benefits.');
    }

    // Activity recommendations
    if (stats.daysSinceLastOrder > 30) {
      recommendations.add('We miss you! Check out our new arrivals and special offers.');
    }

    // Review recommendations
    if (stats.totalOrders > 5 && stats.totalReviews < 3) {
      recommendations.add('Help other shoppers by reviewing your recent purchases.');
    }

    // Engagement recommendations
    if (stats.wishlistItems > 10 && stats.daysSinceLastOrder < 7) {
      recommendations.add('You have ${stats.wishlistItems} items in your wishlist. Time to treat yourself!');
    }

    // Tier progression
    if (stats.loyaltyTier == 'Gold' && stats.totalSpent > 1500) {
      recommendations.add('You\'re on track for Platinum status! Keep shopping to unlock premium benefits.');
    }

    // Default recommendation if none apply
    if (recommendations.isEmpty) {
      recommendations.add('Continue exploring our products to discover great deals!');
    }

    return recommendations;
  }

  /// Generate comparison data
  Map<String, dynamic> _generateComparison(ProfileStats stats, String period) {
    // Simulate historical data for comparison
    final comparison = <String, dynamic>{};

    switch (period) {
      case 'lastMonth':
        comparison['orders_change'] = 2; // +2 orders
        comparison['spending_change'] = 145.50; // +$145.50
        comparison['loyalty_points_change'] = 85; // +85 points
        break;
      case 'lastQuarter':
        comparison['orders_change'] = 8; // +8 orders
        comparison['spending_change'] = 567.25; // +$567.25
        comparison['loyalty_points_change'] = 320; // +320 points
        break;
      case 'lastYear':
        comparison['orders_change'] = 24; // +24 orders (all orders for new user)
        comparison['spending_change'] = 1847.50; // +$1,847.50 (total spending)
        comparison['loyalty_points_change'] = 1250; // +1,250 points
        break;
    }

    comparison['period'] = period;
    comparison['completion_rate_change'] = 2.5; // +2.5%
    comparison['avg_order_value_change'] = -12.30; // -$12.30

    return comparison;
  }

  /// Generate trend analysis
  List<String> _generateTrends(ProfileStats stats, Map<String, dynamic> comparison) {
    final trends = <String>[];

    final ordersChange = comparison['orders_change'] as int;
    final spendingChange = comparison['spending_change'] as double;
    final pointsChange = comparison['loyalty_points_change'] as int;

    // Order trends
    if (ordersChange > 0) {
      trends.add('📈 Order frequency increased by $ordersChange orders');
    } else if (ordersChange < 0) {
      trends.add('📉 Order frequency decreased by ${ordersChange.abs()} orders');
    }

    // Spending trends
    if (spendingChange > 0) {
      trends.add('💰 Spending increased by \$${spendingChange.toStringAsFixed(2)}');
    } else if (spendingChange < 0) {
      trends.add('💸 Spending decreased by \$${spendingChange.abs().toStringAsFixed(2)}');
    }

    // Loyalty trends
    if (pointsChange > 0) {
      trends.add('⭐ Earned $pointsChange loyalty points');
    }

    // Engagement trends
    if (stats.isActiveCustomer) {
      trends.add('🔥 High engagement - active customer');
    }

    if (stats.completionRate > 90) {
      trends.add('✅ Excellent completion rate (${stats.completionRate.toStringAsFixed(1)}%)');
    }

    return trends;
  }

  /// Get shopping frequency description
  String _getShoppingFrequency(ProfileStats stats) {
    if (stats.daysSinceLastOrder <= 7) return 'Very Active';
    if (stats.daysSinceLastOrder <= 30) return 'Active';
    if (stats.daysSinceLastOrder <= 90) return 'Moderate';
    return 'Inactive';
  }

  /// Get spending pattern description
  String _getSpendingPattern(ProfileStats stats) {
    if (stats.averageOrderValue > 100) return 'High Value Orders';
    if (stats.averageOrderValue > 50) return 'Medium Value Orders';
    return 'Budget Conscious';
  }

  /// Get loyalty trajectory
  String _getLoyaltyTrajectory(ProfileStats stats) {
    final pointsToNext = stats.pointsToNextTier;
    if (pointsToNext == 0) return 'Peak Tier Achieved';
    if (pointsToNext <= 100) return 'Almost Next Tier';
    if (pointsToNext <= 500) return 'Progressing Well';
    return 'Getting Started';
  }

  /// Calculate engagement score (0-100)
  int _getEngagementScore(ProfileStats stats) {
    int score = 0;

    // Activity score (40 points max)
    if (stats.daysSinceLastOrder <= 7) {
      score += 40;
    } else if (stats.daysSinceLastOrder <= 30) {
      score += 30;
    } else if (stats.daysSinceLastOrder <= 90) {
      score += 20;
    } else {
      score += 10;
    }

    // Order frequency (30 points max)
    if (stats.totalOrders >= 20) {
      score += 30;
    } else if (stats.totalOrders >= 10) {
      score += 20;
    } else if (stats.totalOrders >= 5) {
      score += 15;
    } else {
      score += 10;
    }

    // Reviews contribution (20 points max)
    if (stats.totalReviews >= 10) {
      score += 20;
    } else if (stats.totalReviews >= 5) {
      score += 15;
    } else if (stats.totalReviews >= 1) {
      score += 10;
    } else {
      score += 5;
    }

    // Completion rate (10 points max)
    if (stats.completionRate >= 95) {
      score += 10;
    } else if (stats.completionRate >= 85) {
      score += 8;
    } else if (stats.completionRate >= 75) {
      score += 6;
    } else {
      score += 4;
    }

    return score.clamp(0, 100);
  }

  /// Calculate customer lifetime value
  double _calculateLifetimeValue(ProfileStats stats) {
    // Simple CLV calculation: (Average Order Value) × (Purchase Frequency) × (Customer Lifespan)
    final avgOrderValue = stats.averageOrderValue;
    final purchaseFrequency = stats.totalOrders / (stats.membershipDurationInDays / 365.0);
    const customerLifespan = 2.0; // Assumed 2-year lifespan

    return avgOrderValue * purchaseFrequency * customerLifespan;
  }

  /// Log changes between old and new stats
  void _logStatsChanges(ProfileStats? oldStats, ProfileStats newStats) {
    if (oldStats == null) return;

    debugPrint('Stats Changes Detected:');

    if (oldStats.totalOrders != newStats.totalOrders) {
      debugPrint('  Orders: ${oldStats.totalOrders} → ${newStats.totalOrders}');
    }

    if (oldStats.totalSpent != newStats.totalSpent) {
      debugPrint('  Total Spent: \$${oldStats.totalSpent} → \$${newStats.totalSpent}');
    }

    if (oldStats.loyaltyPoints != newStats.loyaltyPoints) {
      debugPrint('  Loyalty Points: ${oldStats.loyaltyPoints} → ${newStats.loyaltyPoints}');
    }

    if (oldStats.membershipTier != newStats.membershipTier) {
      debugPrint('  🎉 Tier Upgrade: ${oldStats.membershipTier} → ${newStats.membershipTier}');
    }
  }

  /// Get quick stats summary
  Map<String, dynamic> get quickStats {
    if (_currentStats == null) return {};

    return {
      'total_orders': _currentStats!.totalOrders,
      'total_spent': _currentStats!.formattedTotalSpent,
      'loyalty_tier': _currentStats!.loyaltyTier,
      'completion_rate': '${_currentStats!.completionRate.toStringAsFixed(1)}%',
      'engagement_level': _currentStats!.engagementLevel,
      'customer_segment': _currentStats!.customerSegment,
      'member_duration': _currentStats!.membershipDuration,
      'last_updated': _lastUpdated?.toIso8601String(),
    };
  }

  /// Check if stats need refresh (older than 1 hour)
  bool get needsRefresh {
    if (_lastUpdated == null) return true;
    final now = DateTime.parse('2025-06-22 08:54:25');
    return now.difference(_lastUpdated!).inHours >= 1;
  }

  @override
  Future<void> close() {
    debugPrint('ProfileStatsCubit disposed at 2025-06-22 08:54:25');
    return super.close();
  }
}