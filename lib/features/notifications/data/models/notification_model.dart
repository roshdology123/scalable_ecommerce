import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/notification.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
@HiveType(typeId: 3)
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String body,
    @HiveField(3) required String type,
    @HiveField(4) required String priority,
    @HiveField(5) required Map<String, dynamic> data,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) required String userId,
    @HiveField(8) DateTime? readAt,
    @HiveField(9) DateTime? scheduledAt,
    @HiveField(10) @Default(false) bool isRead,
    @HiveField(11) String? imageUrl,
    @HiveField(12) String? actionUrl,
    @HiveField(13) String? category,
    @HiveField(14) @Default([]) List<String> tags,
    @HiveField(15) String? source, // 'firebase', 'simulator', 'local'
    @HiveField(16) @Default(false) bool isExpired,
    @HiveField(17) DateTime? expiresAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Create from Firebase RemoteMessage
  factory NotificationModel.fromFirebaseMessage(Map<String, dynamic> message) {
    final notification = message['notification'] as Map<String, dynamic>?;
    final data = message['data'] as Map<String, dynamic>? ?? {};

    return NotificationModel(
      id: message['messageId'] as String? ?? 'firebase_${DateTime.now().millisecondsSinceEpoch}',
      title: notification?['title'] as String? ?? data['title'] as String? ?? 'Notification',
      body: notification?['body'] as String? ?? data['body'] as String? ?? '',
      type: data['type'] as String? ?? 'general',
      priority: data['priority'] as String? ?? 'normal',
      data: data,
      createdAt: message['sentTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(message['sentTime'] as int)
          : DateTime.parse('2025-06-23 08:18:38'),
      userId: data['user_id'] as String? ?? 'roshdology123',
      imageUrl: data['image_url'] as String? ?? notification?['imageUrl'] as String?,
      actionUrl: data['action_url'] as String?,
      category: data['category'] as String?,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      source: 'firebase',
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
    );
  }

  /// Create from domain entity
  factory NotificationModel.fromNotification(AppNotification notification) {
    return NotificationModel(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      type: notification.type.name,
      priority: notification.priority.name,
      data: notification.data,
      createdAt: notification.createdAt,
      userId: notification.userId,
      readAt: notification.readAt,
      scheduledAt: notification.scheduledAt,
      isRead: notification.isRead,
      imageUrl: notification.imageUrl,
      actionUrl: notification.actionUrl,
      category: notification.category,
      tags: notification.tags,
      source: notification.data['source'] as String? ?? 'local',
      expiresAt: notification.data['expires_at'] != null
          ? DateTime.parse(notification.data['expires_at'] as String)
          : null,
    );
  }

  /// Create from API response
  factory NotificationModel.fromApi(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      priority: json['priority'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      scheduledAt: json['scheduled_at'] != null ? DateTime.parse(json['scheduled_at'] as String) : null,
      isRead: json['is_read'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      source: json['source'] as String? ?? 'api',
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
    );
  }
}

extension NotificationModelExtensions on NotificationModel {
  /// Convert to domain entity
  AppNotification toNotification() {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: NotificationType.values.firstWhere(
            (e) => e.name == type,
        orElse: () => NotificationType.general,
      ),
      priority: NotificationPriority.values.firstWhere(
            (e) => e.name == priority,
        orElse: () => NotificationPriority.normal,
      ),
      data: {
        ...data,
        'source': source,
        if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      },
      createdAt: createdAt,
      userId: userId,
      readAt: readAt,
      scheduledAt: scheduledAt,
      isRead: isRead,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      category: category,
      tags: tags,
    );
  }

  /// Check if notification is expired
  bool get hasExpired {
    if (isExpired) return true;
    if (expiresAt == null) return false;
    return DateTime.parse('2025-06-23 08:18:38').isAfter(expiresAt!);
  }

  /// Convert to API format
  Map<String, dynamic> toApi() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'priority': priority,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'read_at': readAt?.toIso8601String(),
      'scheduled_at': scheduledAt?.toIso8601String(),
      'is_read': isRead,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'category': category,
      'tags': tags,
      'source': source,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}