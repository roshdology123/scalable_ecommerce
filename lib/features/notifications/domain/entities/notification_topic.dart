import 'package:equatable/equatable.dart';

enum TopicCategory {
  user,        // User-specific notifications
  product,     // Product-related notifications
  category,    // Category-based notifications (electronics, clothing, etc.)
  promotion,   // Promotional notifications
  system,      // System-wide notifications
  location,    // Location-based notifications
  custom,      // Custom user-defined topics
}

enum TopicPriority {
  low,
  normal,
  high,
  critical,
}

class NotificationTopic extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final TopicCategory category;
  final TopicPriority priority;
  final bool isActive;
  final bool isSubscribedByDefault;
  final int subscriberCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> metadata;
  final List<String> allowedUserTypes; // e.g., ['premium', 'regular', 'guest']
  final String? imageUrl;
  final String? iconUrl;

  const NotificationTopic({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.category,
    this.priority = TopicPriority.normal,
    this.isActive = true,
    this.isSubscribedByDefault = false,
    this.subscriberCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.metadata = const {},
    this.allowedUserTypes = const [],
    this.imageUrl,
    this.iconUrl,
  });

  NotificationTopic copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    TopicCategory? category,
    TopicPriority? priority,
    bool? isActive,
    bool? isSubscribedByDefault,
    int? subscriberCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    List<String>? allowedUserTypes,
    String? imageUrl,
    String? iconUrl,
  }) {
    return NotificationTopic(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      isSubscribedByDefault: isSubscribedByDefault ?? this.isSubscribedByDefault,
      subscriberCount: subscriberCount ?? this.subscriberCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      allowedUserTypes: allowedUserTypes ?? this.allowedUserTypes,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  /// Create predefined system topics
  factory NotificationTopic.general() {
    return NotificationTopic(
      id: 'general',
      name: 'general',
      displayName: 'General Notifications',
      description: 'General app notifications and announcements',
      category: TopicCategory.system,
      priority: TopicPriority.normal,
      isSubscribedByDefault: true,
      createdAt: DateTime.parse('2025-06-23 08:34:10'),
    );
  }

  factory NotificationTopic.promotions() {
    return NotificationTopic(
      id: 'promotions',
      name: 'promotions',
      displayName: 'Promotions & Deals',
      description: 'Special offers, sales, and promotional notifications',
      category: TopicCategory.promotion,
      priority: TopicPriority.high,
      isSubscribedByDefault: true,
      createdAt: DateTime.parse('2025-06-23 08:34:10'),
      iconUrl: 'https://via.placeholder.com/24x24/FF5722/FFFFFF?text=🔥',
    );
  }

  factory NotificationTopic.electronics() {
    return NotificationTopic(
      id: 'electronics',
      name: 'electronics',
      displayName: 'Electronics',
      description: 'New products, deals, and updates in electronics category',
      category: TopicCategory.category,
      priority: TopicPriority.normal,
      isSubscribedByDefault: false,
      createdAt: DateTime.parse('2025-06-23 08:34:10'),
      iconUrl: 'https://via.placeholder.com/24x24/2196F3/FFFFFF?text=📱',
    );
  }

  factory NotificationTopic.clothing() {
    return NotificationTopic(
      id: 'clothing',
      name: 'clothing',
      displayName: 'Clothing & Fashion',
      description: 'Latest fashion trends, new arrivals, and clothing deals',
      category: TopicCategory.category,
      priority: TopicPriority.normal,
      isSubscribedByDefault: false,
      createdAt: DateTime.parse('2025-06-23 08:34:10'),
      iconUrl: 'https://via.placeholder.com/24x24/E91E63/FFFFFF?text=👗',
    );
  }

  factory NotificationTopic.jewelery() {
    return NotificationTopic(
      id: 'jewelery',
      name: 'jewelery',
      displayName: 'Jewelry & Accessories',
      description: 'Premium jewelry collections and exclusive accessories',
      category: TopicCategory.category,
      priority: TopicPriority.normal,
      isSubscribedByDefault: false,
      createdAt: DateTime.parse('2025-06-23 08:34:10'),
      iconUrl: 'https://via.placeholder.com/24x24/9C27B0/FFFFFF?text=💎',
    );
  }

  factory NotificationTopic.forUser(String userId) {
    return NotificationTopic(
      id: 'user_$userId',
      name: 'user_$userId',
      displayName: 'Personal Notifications',
      description: 'Personal notifications specific to your account',
      category: TopicCategory.user,
      priority: TopicPriority.high,
      isSubscribedByDefault: true,
      createdAt: DateTime.parse('2025-06-23 08:34:10'),
      allowedUserTypes: ['authenticated'],
    );
  }

  /// Get predefined system topics
  static List<NotificationTopic> getSystemTopics() {
    return [
      NotificationTopic.general(),
      NotificationTopic.promotions(),
      NotificationTopic.electronics(),
      NotificationTopic.clothing(),
      NotificationTopic.jewelery(),
    ];
  }

  /// Get topics for specific category
  static List<NotificationTopic> getTopicsForCategory(TopicCategory category) {
    return getSystemTopics().where((topic) => topic.category == category).toList();
  }

  /// Check if user can subscribe to this topic
  bool canUserSubscribe(String userType) {
    if (allowedUserTypes.isEmpty) return true;
    return allowedUserTypes.contains(userType);
  }

  /// Get topic display emoji
  String get emoji {
    switch (category) {
      case TopicCategory.user:
        return '👤';
      case TopicCategory.product:
        return '📦';
      case TopicCategory.category:
        switch (name) {
          case 'electronics':
            return '📱';
          case 'clothing':
            return '👗';
          case 'jewelery':
            return '💎';
          default:
            return '📂';
        }
      case TopicCategory.promotion:
        return '🔥';
      case TopicCategory.system:
        return '🔔';
      case TopicCategory.location:
        return '📍';
      case TopicCategory.custom:
        return '⭐';
    }
  }

  /// Get priority color
  String get priorityColor {
    switch (priority) {
      case TopicPriority.low:
        return '#4CAF50'; // Green
      case TopicPriority.normal:
        return '#2196F3'; // Blue
      case TopicPriority.high:
        return '#FF9800'; // Orange
      case TopicPriority.critical:
        return '#F44336'; // Red
    }
  }

  /// Get category color
  String get categoryColor {
    switch (category) {
      case TopicCategory.user:
        return '#9C27B0'; // Purple
      case TopicCategory.product:
        return '#4CAF50'; // Green
      case TopicCategory.category:
        return '#2196F3'; // Blue
      case TopicCategory.promotion:
        return '#FF5722'; // Deep Orange
      case TopicCategory.system:
        return '#607D8B'; // Blue Grey
      case TopicCategory.location:
        return '#795548'; // Brown
      case TopicCategory.custom:
        return '#E91E63'; // Pink
    }
  }

  /// Check if topic is recently created (within last 7 days)
  bool get isNew {
    final now = DateTime.parse('2025-06-23 08:34:10');
    return now.difference(createdAt).inDays <= 7;
  }

  /// Check if topic is popular (high subscriber count)
  bool get isPopular {
    return subscriberCount > 1000;
  }

  /// Get full topic identifier for Firebase
  String get firebaseTopicName {
    // Firebase topic names must match [a-zA-Z0-9-_.~%]+
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9\-_.~%]'), '_');
  }

  @override
  List<Object?> get props => [
    id,
    name,
    displayName,
    description,
    category,
    priority,
    isActive,
    isSubscribedByDefault,
    subscriberCount,
    createdAt,
    updatedAt,
    metadata,
    allowedUserTypes,
    imageUrl,
    iconUrl,
  ];
}