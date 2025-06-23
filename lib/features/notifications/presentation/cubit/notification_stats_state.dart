import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_stats.dart';
import '../../domain/usecases/export_notifications_usecase.dart';

part 'notification_stats_state.freezed.dart';

@freezed
class NotificationStatsState with _$NotificationStatsState {
  const factory NotificationStatsState.initial() = _Initial;

  const factory NotificationStatsState.loading() = _Loading;

  const factory NotificationStatsState.loaded({
    required NotificationStats stats,
    required DateTime lastUpdated,
    required StatsDateRange dateRange,
    @Default(false) bool isRefreshing,
    @Default(false) bool isExporting,
  }) = _Loaded;

  const factory NotificationStatsState.comparison({
    required NotificationStats currentPeriodStats,
    required NotificationStats previousPeriodStats,
    required DateTime lastUpdated,
    required StatsDateRange currentPeriodRange,
    required StatsDateRange previousPeriodRange,
  }) = _Comparison;

  const factory NotificationStatsState.exported({
    required NotificationStats stats,
    required DateTime lastUpdated,
    required StatsDateRange dateRange,
    required String exportedData,
    required ExportFormat exportFormat,
    required DateTime exportedAt,
  }) = _Exported;

  const factory NotificationStatsState.error({
    required String message,
    NotificationStats? stats,
    DateTime? lastUpdated,
    StatsDateRange? dateRange,
  }) = _Error;
}

@freezed
class StatsDateRange with _$StatsDateRange {
  const factory StatsDateRange({
    required DateTime fromDate,
    required DateTime toDate,
  }) = _StatsDateRange;
}

extension NotificationStatsStateExtensions on NotificationStatsState {
  bool get isLoading => maybeWhen(
    loading: () => true,
    orElse: () => false,
  );

  bool get isRefreshing => maybeWhen(
    loaded: (_, __, ___, isRefreshing, ____) => isRefreshing,
    orElse: () => false,
  );

  bool get isExporting => maybeWhen(
    loaded: (_, __, ___, ____, isExporting) => isExporting,
    orElse: () => false,
  );

  bool get hasError => maybeWhen(
    error: (_, __, ___, ____) => true,
    orElse: () => false,
  );

  bool get hasData => maybeWhen(
    loaded: (_, __, ___, ____, _____) => true,
    comparison: (_, __, ___, ____, _____) => true,
    exported: (_, __, ___, ____, _____, ______) => true,
    orElse: () => false,
  );

  bool get hasExportData => maybeWhen(
    exported: (_, __, ___, ____, _____, ______) => true,
    orElse: () => false,
  );

  bool get isComparison => maybeWhen(
    comparison: (_, __, ___, ____, _____) => true,
    orElse: () => false,
  );

  NotificationStats? get stats => maybeWhen(
    loaded: (stats, _, __, ___, ____) => stats,
    exported: (stats, _, __, ___, ____, _____) => stats,
    error: (_, stats, __, ___) => stats,
    orElse: () => null,
  );

  NotificationStats? get currentPeriodStats => maybeWhen(
    comparison: (currentPeriodStats, _, __, ___, ____) => currentPeriodStats,
    orElse: () => null,
  );

  NotificationStats? get previousPeriodStats => maybeWhen(
    comparison: (_, previousPeriodStats, __, ___, ____) => previousPeriodStats,
    orElse: () => null,
  );

  DateTime? get lastUpdated => maybeWhen(
    loaded: (_, lastUpdated, __, ___, ____) => lastUpdated,
    comparison: (_, __, lastUpdated, ___, ____) => lastUpdated,
    exported: (_, lastUpdated, __, ___, ____, _____) => lastUpdated,
    error: (_, __, lastUpdated, ___) => lastUpdated,
    orElse: () => null,
  );

  StatsDateRange? get dateRange => maybeWhen(
    loaded: (_, __, dateRange, ___, ____) => dateRange,
    exported: (_, __, dateRange, ___, ____, _____) => dateRange,
    error: (_, __, ___, dateRange) => dateRange,
    orElse: () => null,
  );

  String? get exportedData => maybeWhen(
    exported: (_, __, ___, exportedData, ____, _____) => exportedData,
    orElse: () => null,
  );

  ExportFormat? get exportFormat => maybeWhen(
    exported: (_, __, ___, ____, exportFormat, _____) => exportFormat,
    orElse: () => null,
  );

  DateTime? get exportedAt => maybeWhen(
    exported: (_, __, ___, ____, _____, exportedAt) => exportedAt,
    orElse: () => null,
  );

  String get statusMessage => maybeWhen(
    initial: () => 'Ready to load statistics',
    loading: () => 'Loading statistics...',
    loaded: (stats, _, dateRange, isRefreshing, isExporting) {
      if (isExporting) return 'Exporting data...';
      if (isRefreshing) return 'Refreshing statistics...';
      final days = dateRange.toDate.difference(dateRange.fromDate).inDays;
      return 'Statistics loaded (${days} days, ${stats.totalNotifications} notifications)';
    },
    comparison: (currentStats, previousStats, _, __, ___) {
      return 'Comparison loaded (${currentStats.totalNotifications} vs ${previousStats.totalNotifications} notifications)';
    },
    exported: (stats, _, __, ___, exportFormat, ____) {
      return 'Data exported as ${exportFormat.name} (${stats.totalNotifications} notifications)';
    },
    error: (message, _, __, ___) => 'Error: $message',
    orElse: () => 'Unknown state',
  );

  String get errorMessage => maybeWhen(
    error: (message, _, __, ___) => message,
    orElse: () => '',
  );

  /// Get period description for current date range
  String get periodDescription {
    final range = dateRange;
    if (range == null) return 'No date range';

    final days = range.toDate.difference(range.fromDate).inDays;
    final now = DateTime.parse('2025-06-23 08:52:28');

    // Check if it's today
    if (days == 0 && _isSameDay(range.fromDate, now)) {
      return 'Today';
    }

    // Check if it's this week
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    if (_isSameDay(range.fromDate, weekStart) && _isSameDay(range.toDate, now)) {
      return 'This Week';
    }

    // Check if it's this month
    final monthStart = DateTime(now.year, now.month, 1);
    if (_isSameDay(range.fromDate, monthStart) && _isSameDay(range.toDate, now)) {
      return 'This Month';
    }

    // Check common periods
    if (days == 30) return 'Last 30 Days';
    if (days == 90) return 'Last 3 Months';
    if (days == 180) return 'Last 6 Months';

    // Check if it's this year
    final yearStart = DateTime(now.year, 1, 1);
    if (_isSameDay(range.fromDate, yearStart) && _isSameDay(range.toDate, now)) {
      return 'This Year';
    }

    // Custom range
    return 'Custom Range ($days days)';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get comparison percentage change
  Map<String, double> get comparisonChanges {
    if (!isComparison) return {};

    final current = currentPeriodStats!;
    final previous = previousPeriodStats!;

    return {
      'totalNotifications': _calculatePercentageChange(
        previous.totalNotifications.toDouble(),
        current.totalNotifications.toDouble(),
      ),
      'engagementRate': _calculatePercentageChange(
        previous.engagementRate,
        current.engagementRate,
      ),
      'unreadCount': _calculatePercentageChange(
        previous.unreadCount.toDouble(),
        current.unreadCount.toDouble(),
      ),
      'readPercentage': _calculatePercentageChange(
        previous.readPercentage,
        current.readPercentage,
      ),
    };
  }

  double _calculatePercentageChange(double oldValue, double newValue) {
    if (oldValue == 0) return newValue > 0 ? 100.0 : 0.0;
    return ((newValue - oldValue) / oldValue) * 100;
  }

  /// Check if stats show improvement
  bool get showsImprovement {
    if (!isComparison) return false;

    final changes = comparisonChanges;
    final engagementChange = changes['engagementRate'] ?? 0;
    final readPercentageChange = changes['readPercentage'] ?? 0;

    return engagementChange > 0 || readPercentageChange > 0;
  }

  bool get isBusy => isLoading || isRefreshing || isExporting;
}
extension NotificationStatsStateRecommendations on NotificationStatsState {
  List<String> getRecommendations() {
    final stats = this.stats;
    if (stats == null) return ['Load stats to see recommendations'];

    final List<String> recommendations = [];

    // Engagement recommendations
    if (stats.engagementRate < 50) {
      recommendations.add('Improve notification relevance to increase engagement');
    }

    // Frequency recommendations
    if (stats.averageNotificationsPerDay > 10) {
      recommendations.add('Consider reducing notification frequency');
    } else if (stats.averageNotificationsPerDay < 1) {
      recommendations.add('Increase notification frequency for better engagement');
    }

    // Type recommendations
    if (stats.typeBreakdown.isNotEmpty) {
      final leastUsedType = stats.leastActiveType;
      if (leastUsedType != null) {
        recommendations.add('Review $leastUsedType notifications - they seem less effective');
      }
    }

    // Unread recommendations
    if (stats.unreadCount > 10) {
      recommendations.add('Many unread notifications - users may be overwhelmed');
    }

    if (recommendations.isEmpty) {
      recommendations.add('Notification performance looks good!');
    }

    return recommendations;
  }
}