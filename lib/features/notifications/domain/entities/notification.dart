import 'package:equatable/equatable.dart';

enum NotificationType {
  orderUpdate,
  promotion,
  cartAbandonment,
  general,
  newProduct,
  priceAlert,
  stockAlert,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? scheduledAt;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl;
  final String userId;
  final String? category;
  final List<String> tags;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.priority,
    required this.data,
    required this.createdAt,
    required this.userId,
    this.readAt,
    this.scheduledAt,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
    this.category,
    this.tags = const [],
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    NotificationPriority? priority,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? scheduledAt,
    bool? isRead,
    String? imageUrl,
    String? actionUrl,
    String? userId,
    String? category,
    List<String>? tags,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  /// Get display time for notification
  String get displayTime {
    final now = DateTime.parse('2025-06-23 08:18:38');
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  /// Check if notification is recent (within last 24 hours)
  bool get isRecent {
    final now = DateTime.parse('2025-06-23 08:18:38');
    return now.difference(createdAt).inHours < 24;
  }

  /// Check if notification is urgent
  bool get isUrgent => priority == NotificationPriority.urgent;

  /// Get notification icon based on type
  String get typeIcon {
    switch (type) {
      case NotificationType.orderUpdate:
        return '📦';
      case NotificationType.promotion:
        return '🔥';
      case NotificationType.cartAbandonment:
        return '🛒';
      case NotificationType.priceAlert:
        return '📉';
      case NotificationType.stockAlert:
        return '⚠️';
      case NotificationType.newProduct:
        return '🆕';
      case NotificationType.general:
      default:
        return '🔔';
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    type,
    priority,
    data,
    createdAt,
    readAt,
    scheduledAt,
    isRead,
    imageUrl,
    actionUrl,
    userId,
    category,
    tags,
  ];
}