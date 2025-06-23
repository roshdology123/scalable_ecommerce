import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_stats_model.freezed.dart';
part 'notification_stats_model.g.dart';

@freezed
class NotificationStatsModel with _$NotificationStatsModel {
  const factory NotificationStatsModel({
    @Default(0) int totalNotifications,
    @Default(0) int unreadCount,
    @Default(0) int readCount,
    @Default(0) int todayCount,
    @Default(0) int weekCount,
    @Default(0) int monthCount,
    @Default({}) Map<String, int> typeBreakdown,
    @Default({}) Map<String, int> priorityBreakdown,
    @Default({}) Map<String, int> dailyStats, // date -> count
    @Default(0.0) double averageReadTime, // in minutes
    @Default(0.0) double engagementRate, // percentage
    DateTime? lastNotificationAt,
    DateTime? lastReadAt,
    @Default('2025-06-23 08:18:38') String generatedAt,
  }) = _NotificationStatsModel;

  factory NotificationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationStatsModelFromJson(json);

  /// Create from API response
  factory NotificationStatsModel.fromApi(Map<String, dynamic> json) {
    return NotificationStatsModel(
      totalNotifications: json['total_notifications'] as int? ?? 0,
      unreadCount: json['unread_count'] as int? ?? 0,
      readCount: json['read_count'] as int? ?? 0,
      todayCount: json['today_count'] as int? ?? 0,
      weekCount: json['week_count'] as int? ?? 0,
      monthCount: json['month_count'] as int? ?? 0,
      typeBreakdown: Map<String, int>.from(json['type_breakdown'] as Map? ?? {}),
      priorityBreakdown: Map<String, int>.from(json['priority_breakdown'] as Map? ?? {}),
      dailyStats: Map<String, int>.from(json['daily_stats'] as Map? ?? {}),
      averageReadTime: (json['average_read_time'] as num?)?.toDouble() ?? 0.0,
      engagementRate: (json['engagement_rate'] as num?)?.toDouble() ?? 0.0,
      lastNotificationAt: json['last_notification_at'] != null
          ? DateTime.parse(json['last_notification_at'] as String)
          : null,
      lastReadAt: json['last_read_at'] != null
          ? DateTime.parse(json['last_read_at'] as String)
          : null,
      generatedAt: json['generated_at'] as String? ?? '2025-06-23 08:18:38',
    );
  }

  /// Create empty stats
  factory NotificationStatsModel.empty() {
    return const NotificationStatsModel();
  }
}

extension NotificationStatsModelExtensions on NotificationStatsModel {
  /// Convert to API format
  Map<String, dynamic> toApi() {
    return {
      'total_notifications': totalNotifications,
      'unread_count': unreadCount,
      'read_count': readCount,
      'today_count': todayCount,
      'week_count': weekCount,
      'month_count': monthCount,
      'type_breakdown': typeBreakdown,
      'priority_breakdown': priorityBreakdown,
      'daily_stats': dailyStats,
      'average_read_time': averageReadTime,
      'engagement_rate': engagementRate,
      'last_notification_at': lastNotificationAt?.toIso8601String(),
      'last_read_at': lastReadAt?.toIso8601String(),
      'generated_at': generatedAt,
    };
  }

  /// Get most common notification type
  String get mostCommonType {
    if (typeBreakdown.isEmpty) return 'general';

    return typeBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get read percentage
  double get readPercentage {
    if (totalNotifications == 0) return 0.0;
    return (readCount / totalNotifications) * 100;
  }

  /// Check if user is highly engaged
  bool get isHighlyEngaged => engagementRate >= 75.0;

  /// Get notification trend (positive, negative, stable)
  String get trend {
    if (dailyStats.length < 2) return 'stable';

    final sortedDates = dailyStats.keys.toList()..sort();
    final recent = dailyStats[sortedDates.last] ?? 0;
    final previous = dailyStats[sortedDates[sortedDates.length - 2]] ?? 0;

    if (recent > previous) return 'increasing';
    if (recent < previous) return 'decreasing';
    return 'stable';
  }
}