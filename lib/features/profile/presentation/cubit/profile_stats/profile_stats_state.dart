import 'package:equatable/equatable.dart';

import '../../../domain/entities/profile_stats.dart';

abstract class ProfileStatsState extends Equatable {
  const ProfileStatsState();

  @override
  List<Object?> get props => [];
}

/// Initial state when stats cubit is first created
class ProfileStatsInitial extends ProfileStatsState {
  const ProfileStatsInitial();

  @override
  String toString() => 'ProfileStatsInitial';
}

/// State when stats are being loaded from server or cache
class ProfileStatsLoading extends ProfileStatsState {
  const ProfileStatsLoading();

  @override
  String toString() => 'ProfileStatsLoading';
}

/// State when stats have been successfully loaded
class ProfileStatsLoaded extends ProfileStatsState {
  final ProfileStats stats;

  const ProfileStatsLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];

  @override
  String toString() => 'ProfileStatsLoaded(tier: ${stats.loyaltyTier}, totalSpent: ${stats.formattedTotalSpent})';
}

/// State when stats are being refreshed
class ProfileStatsRefreshing extends ProfileStatsState {
  final ProfileStats currentStats;

  const ProfileStatsRefreshing({required this.currentStats});

  @override
  List<Object?> get props => [currentStats];

  @override
  String toString() => 'ProfileStatsRefreshing';
}

/// State when stats have been successfully refreshed
class ProfileStatsRefreshed extends ProfileStatsState {
  final ProfileStats stats;
  final ProfileStats? previousStats;

  const ProfileStatsRefreshed({
    required this.stats,
    this.previousStats,
  });

  @override
  List<Object?> get props => [stats, previousStats];

  @override
  String toString() => 'ProfileStatsRefreshed(tier: ${stats.loyaltyTier})';
}

/// State when analyzing stats for insights
class ProfileStatsAnalyzing extends ProfileStatsState {
  final ProfileStats currentStats;

  const ProfileStatsAnalyzing({required this.currentStats});

  @override
  List<Object?> get props => [currentStats];

  @override
  String toString() => 'ProfileStatsAnalyzing';
}

/// State when stats analysis is complete with insights
class ProfileStatsAnalyzed extends ProfileStatsState {
  final ProfileStats stats;
  final Map<String, dynamic> insights;
  final List<String> recommendations;

  const ProfileStatsAnalyzed({
    required this.stats,
    required this.insights,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [stats, insights, recommendations];

  @override
  String toString() => 'ProfileStatsAnalyzed(insights: ${insights.length}, recommendations: ${recommendations.length})';
}

/// State when comparing stats periods
class ProfileStatsComparing extends ProfileStatsState {
  final ProfileStats currentStats;

  const ProfileStatsComparing({required this.currentStats});

  @override
  List<Object?> get props => [currentStats];

  @override
  String toString() => 'ProfileStatsComparing';
}

/// State when stats comparison is complete
class ProfileStatsCompared extends ProfileStatsState {
  final ProfileStats currentStats;
  final Map<String, dynamic> comparison;
  final List<String> trends;

  const ProfileStatsCompared({
    required this.currentStats,
    required this.comparison,
    required this.trends,
  });

  @override
  List<Object?> get props => [currentStats, comparison, trends];

  @override
  String toString() => 'ProfileStatsCompared(trends: ${trends.length})';
}

/// State when an error has occurred with stats
class ProfileStatsError extends ProfileStatsState {
  final String message;
  final String code;
  final ProfileStats? currentStats;

  const ProfileStatsError({
    required this.message,
    required this.code,
    this.currentStats,
  });

  @override
  List<Object?> get props => [message, code, currentStats];

  @override
  String toString() => 'ProfileStatsError(code: $code, message: $message)';
}

/// State when a network error has occurred with stats
class ProfileStatsNetworkError extends ProfileStatsState {
  final String message;
  final ProfileStats? cachedStats;

  const ProfileStatsNetworkError({
    required this.message,
    this.cachedStats,
  });

  @override
  List<Object?> get props => [message, cachedStats];

  @override
  String toString() => 'ProfileStatsNetworkError(message: $message, hasCachedStats: ${cachedStats != null})';
}




