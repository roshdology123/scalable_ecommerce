import 'package:equatable/equatable.dart';

class NotificationStats extends Equatable {
  final int totalNotifications;
  final int unreadCount;
  final int readCount;
  final int todayCount;
  final int weekCount;
  final int monthCount;
  final Map<String, int> typeBreakdown;
  final Map<String, int> priorityBreakdown;
  final Map<String, int> dailyStats; // date -> count
  final double averageReadTime; // in minutes
  final double engagementRate; // percentage
  final DateTime? lastNotificationAt;
  final DateTime? lastReadAt;
  final DateTime generatedAt;

  const NotificationStats({
    this.totalNotifications = 0,
    this.unreadCount = 0,
    this.readCount = 0,
    this.todayCount = 0,
    this.weekCount = 0,
    this.monthCount = 0,
    this.typeBreakdown = const {},
    this.priorityBreakdown = const {},
    this.dailyStats = const {},
    this.averageReadTime = 0.0,
    this.engagementRate = 0.0,
    this.lastNotificationAt,
    this.lastReadAt,
    required this.generatedAt,
  });

  NotificationStats copyWith({
    int? totalNotifications,
    int? unreadCount,
    int? readCount,
    int? todayCount,
    int? weekCount,
    int? monthCount,
    Map<String, int>? typeBreakdown,
    Map<String, int>? priorityBreakdown,
    Map<String, int>? dailyStats,
    double? averageReadTime,
    double? engagementRate,
    DateTime? lastNotificationAt,
    DateTime? lastReadAt,
    DateTime? generatedAt,
  }) {
    return NotificationStats(
      totalNotifications: totalNotifications ?? this.totalNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
      readCount: readCount ?? this.readCount,
      todayCount: todayCount ?? this.todayCount,
      weekCount: weekCount ?? this.weekCount,
      monthCount: monthCount ?? this.monthCount,
      typeBreakdown: typeBreakdown ?? this.typeBreakdown,
      priorityBreakdown: priorityBreakdown ?? this.priorityBreakdown,
      dailyStats: dailyStats ?? this.dailyStats,
      averageReadTime: averageReadTime ?? this.averageReadTime,
      engagementRate: engagementRate ?? this.engagementRate,
      lastNotificationAt: lastNotificationAt ?? this.lastNotificationAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  /// Create empty stats
  factory NotificationStats.empty() {
    return NotificationStats(
      generatedAt: DateTime.parse('2025-06-23 08:34:10'),
    );
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

  /// Check if user is highly engaged (reads >75% of notifications)
  bool get isHighlyEngaged => engagementRate >= 75.0;

  /// Get notification trend (increasing, decreasing, stable)
  String get trend {
    if (dailyStats.length < 2) return 'stable';

    final sortedDates = dailyStats.keys.toList()..sort();
    if (sortedDates.length < 2) return 'stable';

    final recent = dailyStats[sortedDates.last] ?? 0;
    final previous = dailyStats[sortedDates[sortedDates.length - 2]] ?? 0;

    if (recent > previous) return 'increasing';
    if (recent < previous) return 'decreasing';
    return 'stable';
  }

  /// Get average notifications per day
  double get averageNotificationsPerDay {
    if (dailyStats.isEmpty) return 0.0;

    final totalDays = dailyStats.length;
    final totalNotificationsInPeriod = dailyStats.values.fold(0, (sum, count) => sum + count);

    return totalNotificationsInPeriod / totalDays;
  }

  /// Get peak notification day
  String? get peakNotificationDay {
    if (dailyStats.isEmpty) return null;

    return dailyStats.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get most active notification type
  String? get mostActiveType {
    if (typeBreakdown.isEmpty) return null;

    return typeBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get least active notification type
  String? get leastActiveType {
    if (typeBreakdown.isEmpty) return null;

    return typeBreakdown.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  /// Check if user receives notifications regularly
  bool get isRegularUser {
    return totalNotifications > 10 && averageNotificationsPerDay > 0.5;
  }

  /// Get engagement level description
  String get engagementLevel {
    if (engagementRate >= 80) return 'Excellent';
    if (engagementRate >= 60) return 'Good';
    if (engagementRate >= 40) return 'Average';
    if (engagementRate >= 20) return 'Low';
    return 'Very Low';
  }

  /// Get time since last notification
  Duration? get timeSinceLastNotification {
    if (lastNotificationAt == null) return null;
    return DateTime.parse('2025-06-23 08:34:10').difference(lastNotificationAt!);
  }

  /// Get time since last read
  Duration? get timeSinceLastRead {
    if (lastReadAt == null) return null;
    return DateTime.parse('2025-06-23 08:34:10').difference(lastReadAt!);
  }

  /// Check if user needs attention (many unread notifications)
  bool get needsAttention => unreadCount > 5;

  /// Get notification summary
  Map<String, dynamic> get summary {
    return {
      'total_notifications': totalNotifications,
      'unread_count': unreadCount,
      'read_percentage': readPercentage.toStringAsFixed(1),
      'engagement_level': engagementLevel,
      'trend': trend,
      'most_common_type': mostCommonType,
      'average_per_day': averageNotificationsPerDay.toStringAsFixed(1),
      'needs_attention': needsAttention,
      'is_regular_user': isRegularUser,
      'generated_at': generatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    totalNotifications,
    unreadCount,
    readCount,
    todayCount,
    weekCount,
    monthCount,
    typeBreakdown,
    priorityBreakdown,
    dailyStats,
    averageReadTime,
    engagementRate,
    lastNotificationAt,
    lastReadAt,
    generatedAt,
  ];
}