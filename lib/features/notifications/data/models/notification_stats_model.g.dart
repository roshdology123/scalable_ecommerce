// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationStatsModelImpl _$$NotificationStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationStatsModelImpl(
      totalNotifications: (json['totalNotifications'] as num?)?.toInt() ?? 0,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      readCount: (json['readCount'] as num?)?.toInt() ?? 0,
      todayCount: (json['todayCount'] as num?)?.toInt() ?? 0,
      weekCount: (json['weekCount'] as num?)?.toInt() ?? 0,
      monthCount: (json['monthCount'] as num?)?.toInt() ?? 0,
      typeBreakdown: (json['typeBreakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      priorityBreakdown:
          (json['priorityBreakdown'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      dailyStats: (json['dailyStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      averageReadTime: (json['averageReadTime'] as num?)?.toDouble() ?? 0.0,
      engagementRate: (json['engagementRate'] as num?)?.toDouble() ?? 0.0,
      lastNotificationAt: json['lastNotificationAt'] == null
          ? null
          : DateTime.parse(json['lastNotificationAt'] as String),
      lastReadAt: json['lastReadAt'] == null
          ? null
          : DateTime.parse(json['lastReadAt'] as String),
      generatedAt: json['generatedAt'] as String? ?? '2025-06-23 08:18:38',
    );

Map<String, dynamic> _$$NotificationStatsModelImplToJson(
        _$NotificationStatsModelImpl instance) =>
    <String, dynamic>{
      'totalNotifications': instance.totalNotifications,
      'unreadCount': instance.unreadCount,
      'readCount': instance.readCount,
      'todayCount': instance.todayCount,
      'weekCount': instance.weekCount,
      'monthCount': instance.monthCount,
      'typeBreakdown': instance.typeBreakdown,
      'priorityBreakdown': instance.priorityBreakdown,
      'dailyStats': instance.dailyStats,
      'averageReadTime': instance.averageReadTime,
      'engagementRate': instance.engagementRate,
      'lastNotificationAt': instance.lastNotificationAt?.toIso8601String(),
      'lastReadAt': instance.lastReadAt?.toIso8601String(),
      'generatedAt': instance.generatedAt,
    };
