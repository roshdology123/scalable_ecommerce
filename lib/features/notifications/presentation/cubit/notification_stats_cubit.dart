import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/get_notification_stats_usecase.dart';
import '../../domain/usecases/export_notifications_usecase.dart';
import 'notification_stats_state.dart';

@injectable
class NotificationStatsCubit extends Cubit<NotificationStatsState> {
  final GetNotificationStatsUseCase _getNotificationStatsUseCase;
  final ExportNotificationsUseCase _exportNotificationsUseCase;
  final AppLogger _logger = AppLogger();

  Timer? _refreshTimer;

  // Current user ID
  static const String _currentUserId = 'roshdology123';

  // Default time ranges
  static final DateTime _defaultFromDate = DateTime.parse('2025-06-23 09:00:38').subtract(const Duration(days: 30));
  static final DateTime _defaultToDate = DateTime.parse('2025-06-23 09:00:38');

  NotificationStatsCubit(
      this._getNotificationStatsUseCase,
      this._exportNotificationsUseCase,
      ) : super(const NotificationStatsState.initial()) {
    _logger.logBusinessLogic(
      'notification_stats_cubit_initialized',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 09:00:38',
      },
    );

    // Load initial stats
    loadStats();

    // Start periodic refresh every 10 minutes
    _startPeriodicRefresh();
  }

  /// Load notification statistics
  Future<void> loadStats({
    DateTime? fromDate,
    DateTime? toDate,
    bool isRefresh = false,
  }) async {
    final effectiveFromDate = fromDate ?? _defaultFromDate;
    final effectiveToDate = toDate ?? _defaultToDate;

    _logger.logBusinessLogic(
      'load_notification_stats_started',
      'cubit_action',
      {
        'from_date': effectiveFromDate.toIso8601String(),
        'to_date': effectiveToDate.toIso8601String(),
        'is_refresh': isRefresh,
        'user': _currentUserId,
        'timestamp': '2025-06-23 09:00:38',
      },
    );

    if (isRefresh) {
      // Handle refresh state for loaded state
      state.maybeWhen(
        loaded: (stats, lastUpdated, dateRange, _, __) {
          emit(NotificationStatsState.loaded(
            stats: stats,
            lastUpdated: lastUpdated,
            dateRange: dateRange,
            isRefreshing: true,
            isExporting: false,
          ));
        },
        exported: (stats, lastUpdated, dateRange, _, __, ___) {
          emit(NotificationStatsState.loaded(
            stats: stats,
            lastUpdated: lastUpdated,
            dateRange: dateRange,
            isRefreshing: true,
            isExporting: false,
          ));
        },
        orElse: () {
          emit(const NotificationStatsState.loading());
        },
      );
    } else {
      emit(const NotificationStatsState.loading());
    }

    final result = await _getNotificationStatsUseCase(
      GetNotificationStatsParams(
        userId: _currentUserId,
        fromDate: effectiveFromDate,
        toDate: effectiveToDate,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationStatsCubit.loadStats',
          failure,
          StackTrace.current,
          {
            'from_date': effectiveFromDate.toIso8601String(),
            'to_date': effectiveToDate.toIso8601String(),
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 09:00:38',
          },
        );

        emit(NotificationStatsState.error(
          message: failure.message,
          stats: state.stats,
          lastUpdated: state.lastUpdated,
          dateRange: state.dateRange,
        ));
      },
          (stats) {
        _logger.logBusinessLogic(
          'load_notification_stats_success',
          'cubit_action',
          {
            'total_notifications': stats.totalNotifications,
            'unread_count': stats.unreadCount,
            'engagement_rate': stats.engagementRate,
            'most_common_type': stats.mostCommonType,
            'user': _currentUserId,
            'timestamp': '2025-06-23 09:00:38',
          },
        );

        emit(NotificationStatsState.loaded(
          stats: stats,
          lastUpdated: DateTime.parse('2025-06-23 09:00:38'),
          dateRange: StatsDateRange(
            fromDate: effectiveFromDate,
            toDate: effectiveToDate,
          ),
        ));
      },
    );
  }

  /// Refresh stats with current date range
  Future<void> refreshStats() async {
    final currentRange = state.dateRange;
    await loadStats(
      fromDate: currentRange?.fromDate ?? _defaultFromDate,
      toDate: currentRange?.toDate ?? _defaultToDate,
      isRefresh: true,
    );
  }

  /// Load stats for specific time period
  Future<void> loadStatsForPeriod(StatsPeriod period) async {
    final now = DateTime.parse('2025-06-23 09:00:38');
    late DateTime fromDate;
    late DateTime toDate;

    switch (period) {
      case StatsPeriod.today:
        fromDate = DateTime(now.year, now.month, now.day);
        toDate = now;
        break;
      case StatsPeriod.thisWeek:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        fromDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
        toDate = now;
        break;
      case StatsPeriod.thisMonth:
        fromDate = DateTime(now.year, now.month, 1);
        toDate = now;
        break;
      case StatsPeriod.last30Days:
        fromDate = now.subtract(const Duration(days: 30));
        toDate = now;
        break;
      case StatsPeriod.last3Months:
        fromDate = now.subtract(const Duration(days: 90));
        toDate = now;
        break;
      case StatsPeriod.last6Months:
        fromDate = now.subtract(const Duration(days: 180));
        toDate = now;
        break;
      case StatsPeriod.thisYear:
        fromDate = DateTime(now.year, 1, 1);
        toDate = now;
        break;
    }

    _logger.logUserAction('load_stats_for_period', {
      'period': period.name,
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'user': _currentUserId,
      'timestamp': '2025-06-23 09:00:38',
    });

    await loadStats(fromDate: fromDate, toDate: toDate);
  }

  /// Load stats for custom date range
  Future<void> loadStatsForDateRange(DateTime fromDate, DateTime toDate) async {
    if (fromDate.isAfter(toDate)) {
      _logger.logBusinessLogic(
        'load_stats_invalid_date_range',
        'cubit_action',
        {
          'from_date': fromDate.toIso8601String(),
          'to_date': toDate.toIso8601String(),
          'error': 'From date is after to date',
          'user': _currentUserId,
          'timestamp': '2025-06-23 09:00:38',
        },
      );

      emit(NotificationStatsState.error(
        message: 'From date cannot be after to date',
        stats: state.stats,
        lastUpdated: state.lastUpdated,
        dateRange: state.dateRange,
      ));
      return;
    }

    _logger.logUserAction('load_stats_for_custom_range', {
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'range_days': toDate.difference(fromDate).inDays,
      'user': _currentUserId,
      'timestamp': '2025-06-23 09:00:38',
    });

    await loadStats(fromDate: fromDate, toDate: toDate);
  }

  /// Export notifications data
  Future<void> exportNotifications({
    ExportFormat format = ExportFormat.json,
    bool includeRead = true,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final currentRange = state.dateRange;
    final effectiveFromDate = fromDate ?? currentRange?.fromDate ?? _defaultFromDate;
    final effectiveToDate = toDate ?? currentRange?.toDate ?? _defaultToDate;

    _logger.logUserAction('export_notifications_started', {
      'format': format.name,
      'include_read': includeRead,
      'from_date': effectiveFromDate.toIso8601String(),
      'to_date': effectiveToDate.toIso8601String(),
      'user': _currentUserId,
      'timestamp': '2025-06-23 09:00:38',
    });

    // Handle export state for loaded state
    state.maybeWhen(
      loaded: (stats, lastUpdated, dateRange, _, __) {
        emit(NotificationStatsState.loaded(
          stats: stats,
          lastUpdated: lastUpdated,
          dateRange: dateRange,
          isRefreshing: false,
          isExporting: true,
        ));
      },
      orElse: () {
        emit(const NotificationStatsState.loading());
      },
    );

    final result = await _exportNotificationsUseCase(
      ExportNotificationsParams(
        userId: _currentUserId,
        format: format,
        includeRead: includeRead,
        fromDate: effectiveFromDate,
        toDate: effectiveToDate,
      ),
    );

    result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'NotificationStatsCubit.exportNotifications',
          failure,
          StackTrace.current,
          {
            'format': format.name,
            'include_read': includeRead,
            'failure_message': failure.message,
            'user': _currentUserId,
            'timestamp': '2025-06-23 09:00:38',
          },
        );

        emit(NotificationStatsState.error(
          message: failure.message,
          stats: state.stats,
          lastUpdated: state.lastUpdated,
          dateRange: state.dateRange,
        ));
      },
          (exportedData) {
        _logger.logUserAction('export_notifications_success', {
          'format': format.name,
          'export_size_bytes': exportedData.length,
          'user': _currentUserId,
          'timestamp': '2025-06-23 09:00:38',
        });

        emit(NotificationStatsState.exported(
          stats: state.stats!,
          lastUpdated: state.lastUpdated!,
          dateRange: state.dateRange!,
          exportedData: exportedData,
          exportFormat: format,
          exportedAt: DateTime.parse('2025-06-23 09:00:38'),
        ));
      },
    );
  }

  /// Get comparison stats between two periods
  Future<void> loadComparisonStats(
      DateTime period1Start,
      DateTime period1End,
      DateTime period2Start,
      DateTime period2End,
      ) async {
    _logger.logBusinessLogic(
      'load_comparison_stats_started',
      'cubit_action',
      {
        'period1_start': period1Start.toIso8601String(),
        'period1_end': period1End.toIso8601String(),
        'period2_start': period2Start.toIso8601String(),
        'period2_end': period2End.toIso8601String(),
        'user': _currentUserId,
        'timestamp': '2025-06-23 09:00:38',
      },
    );

    emit(const NotificationStatsState.loading());

    // Load stats for both periods
    final period1Result = await _getNotificationStatsUseCase(
      GetNotificationStatsParams(
        userId: _currentUserId,
        fromDate: period1Start,
        toDate: period1End,
      ),
    );

    final period2Result = await _getNotificationStatsUseCase(
      GetNotificationStatsParams(
        userId: _currentUserId,
        fromDate: period2Start,
        toDate: period2End,
      ),
    );

    if (period1Result.isLeft() || period2Result.isLeft()) {
      final error = period1Result.isLeft()
          ? period1Result.fold((l) => l.message, (r) => '')
          : period2Result.fold((l) => l.message, (r) => '');

      emit(NotificationStatsState.error(
        message: 'Failed to load comparison stats: $error',
        stats: state.stats,
        lastUpdated: state.lastUpdated,
        dateRange: state.dateRange,
      ));
      return;
    }

    final period1Stats = period1Result.fold((l) => null, (r) => r)!;
    final period2Stats = period2Result.fold((l) => null, (r) => r)!;

    _logger.logBusinessLogic(
      'load_comparison_stats_success',
      'cubit_action',
      {
        'period1_total': period1Stats.totalNotifications,
        'period2_total': period2Stats.totalNotifications,
        'period1_engagement': period1Stats.engagementRate,
        'period2_engagement': period2Stats.engagementRate,
        'user': _currentUserId,
        'timestamp': '2025-06-23 09:00:38',
      },
    );

    emit(NotificationStatsState.comparison(
      currentPeriodStats: period1Stats,
      previousPeriodStats: period2Stats,
      lastUpdated: DateTime.parse('2025-06-23 09:00:38'),
      currentPeriodRange: StatsDateRange(
        fromDate: period1Start,
        toDate: period1End,
      ),
      previousPeriodRange: StatsDateRange(
        fromDate: period2Start,
        toDate: period2End,
      ),
    ));
  }

  /// Start periodic refresh
  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      if (!state.isLoading && !state.isRefreshing && !state.isExporting) {
        refreshStats();
      }
    });

    _logger.logBusinessLogic(
      'periodic_stats_refresh_started',
      'cubit_lifecycle',
      {
        'interval_minutes': 10,
        'user': _currentUserId,
        'timestamp': '2025-06-23 09:00:38',
      },
    );
  }

  /// Stop periodic refresh
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;

    _logger.logBusinessLogic(
      'periodic_stats_refresh_stopped',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 09:00:38',
      },
    );
  }

  /// Clear error state
  void clearError() {
    if (state.hasError) {
      final stats = state.stats;
      if (stats != null) {
        emit(NotificationStatsState.loaded(
          stats: stats,
          lastUpdated: state.lastUpdated!,
          dateRange: state.dateRange!,
        ));
      } else {
        emit(const NotificationStatsState.initial());
      }
    }
  }

  /// Clear export state
  void clearExport() {
    if (state.hasExportData) {
      emit(NotificationStatsState.loaded(
        stats: state.stats!,
        lastUpdated: state.lastUpdated!,
        dateRange: state.dateRange!,
      ));
    }
  }

  /// Get engagement trend description
  String getEngagementTrend() {
    final stats = state.stats;
    if (stats == null) return 'No data';

    if (stats.engagementRate >= 80) {
      return 'Excellent engagement - users actively read notifications';
    } else if (stats.engagementRate >= 60) {
      return 'Good engagement - most notifications are being read';
    } else if (stats.engagementRate >= 40) {
      return 'Average engagement - consider improving notification relevance';
    } else if (stats.engagementRate >= 20) {
      return 'Low engagement - notifications may not be relevant';
    } else {
      return 'Very low engagement - review notification strategy';
    }
  }

  /// Get notification frequency insight
  String getFrequencyInsight() {
    final stats = state.stats;
    if (stats == null) return 'No data';

    final avgPerDay = stats.averageNotificationsPerDay;

    if (avgPerDay > 10) {
      return 'High frequency - consider reducing notification volume';
    } else if (avgPerDay > 5) {
      return 'Moderate frequency - good balance of engagement';
    } else if (avgPerDay > 1) {
      return 'Low frequency - users may want more updates';
    } else {
      return 'Very low frequency - ensure notifications are working';
    }
  }

  /// Get recommendations based on stats
  List<String> getRecommendations() {
    final stats = state.stats;
    if (stats == null) return ['Load stats to see recommendations'];

    final recommendations = <String>[];

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

  @override
  Future<void> close() {
    _refreshTimer?.cancel();

    _logger.logBusinessLogic(
      'notification_stats_cubit_closed',
      'cubit_lifecycle',
      {
        'user': _currentUserId,
        'timestamp': '2025-06-23 09:00:38',
      },
    );

    return super.close();
  }
}

enum StatsPeriod {
  today,
  thisWeek,
  thisMonth,
  last30Days,
  last3Months,
  last6Months,
  thisYear,
}