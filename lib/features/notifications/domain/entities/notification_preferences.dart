import 'package:equatable/equatable.dart';

import '../../../profile/domain/entities/user_preferences.dart';
import 'notification.dart';

class NotificationPreferences extends Equatable {
  final String userId;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final bool orderUpdatesEnabled;
  final bool promotionsEnabled;
  final bool cartAbandonmentEnabled;
  final bool priceAlertsEnabled;
  final bool stockAlertsEnabled;
  final bool newProductsEnabled;
  final NotificationFrequency orderUpdatesFrequency;
  final NotificationFrequency promotionsFrequency;
  final NotificationFrequency newsletterFrequency;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final List<String> subscribedTopics;
  final List<String> mutedCategories;
  final String soundPreference; // 'all', 'important', 'none'
  final String vibrationPreference; // 'all', 'important', 'none'
  final bool showOnLockScreen;
  final bool showPreview;
  final DateTime? lastUpdated;

  const NotificationPreferences({
    required this.userId,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = false,
    this.orderUpdatesEnabled = true,
    this.promotionsEnabled = true,
    this.cartAbandonmentEnabled = true,
    this.priceAlertsEnabled = true,
    this.stockAlertsEnabled = true,
    this.newProductsEnabled = true,
    this.orderUpdatesFrequency = NotificationFrequency.instant,
    this.promotionsFrequency = NotificationFrequency.daily,
    this.newsletterFrequency = NotificationFrequency.weekly,
    this.quietHoursEnabled = false,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '08:00',
    this.subscribedTopics = const [],
    this.mutedCategories = const [],
    this.soundPreference = 'all',
    this.vibrationPreference = 'all',
    this.showOnLockScreen = true,
    this.showPreview = true,
    this.lastUpdated,
  });

  NotificationPreferences copyWith({
    String? userId,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    bool? orderUpdatesEnabled,
    bool? promotionsEnabled,
    bool? cartAbandonmentEnabled,
    bool? priceAlertsEnabled,
    bool? stockAlertsEnabled,
    bool? newProductsEnabled,
    NotificationFrequency? orderUpdatesFrequency,
    NotificationFrequency? promotionsFrequency,
    NotificationFrequency? newsletterFrequency,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    List<String>? subscribedTopics,
    List<String>? mutedCategories,
    String? soundPreference,
    String? vibrationPreference,
    bool? showOnLockScreen,
    bool? showPreview,
    DateTime? lastUpdated,
  }) {
    return NotificationPreferences(
      userId: userId ?? this.userId,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      orderUpdatesEnabled: orderUpdatesEnabled ?? this.orderUpdatesEnabled,
      promotionsEnabled: promotionsEnabled ?? this.promotionsEnabled,
      cartAbandonmentEnabled: cartAbandonmentEnabled ?? this.cartAbandonmentEnabled,
      priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
      stockAlertsEnabled: stockAlertsEnabled ?? this.stockAlertsEnabled,
      newProductsEnabled: newProductsEnabled ?? this.newProductsEnabled,
      orderUpdatesFrequency: orderUpdatesFrequency ?? this.orderUpdatesFrequency,
      promotionsFrequency: promotionsFrequency ?? this.promotionsFrequency,
      newsletterFrequency: newsletterFrequency ?? this.newsletterFrequency,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      mutedCategories: mutedCategories ?? this.mutedCategories,
      soundPreference: soundPreference ?? this.soundPreference,
      vibrationPreference: vibrationPreference ?? this.vibrationPreference,
      showOnLockScreen: showOnLockScreen ?? this.showOnLockScreen,
      showPreview: showPreview ?? this.showPreview,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Create default preferences for user
  factory NotificationPreferences.defaultForUser(String userId) {
    return NotificationPreferences(
      userId: userId,
      subscribedTopics: [
        'general',
        'user_$userId',
        'promotions',
      ],
      lastUpdated: DateTime.parse('2025-06-23 08:34:10'),
    );
  }

  /// Check if notifications are allowed for a specific type
  bool isTypeEnabled(NotificationType notificationType) {
    switch (notificationType) {
      case NotificationType.orderUpdate:
        return orderUpdatesEnabled;
      case NotificationType.promotion:
        return promotionsEnabled;
      case NotificationType.cartAbandonment:
        return cartAbandonmentEnabled;
      case NotificationType.priceAlert:
        return priceAlertsEnabled;
      case NotificationType.stockAlert:
        return stockAlertsEnabled;
      case NotificationType.newProduct:
        return newProductsEnabled;
      case NotificationType.general:
      default:
        return pushNotificationsEnabled;
    }
  }

  /// Check if currently in quiet hours
  bool get isInQuietHours {
    if (!quietHoursEnabled) return false;

    final now = DateTime.parse('2025-06-23 08:34:10');
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Handle cross-day quiet hours (e.g., 22:00 to 08:00)
    if (quietHoursStart.compareTo(quietHoursEnd) > 0) {
      return currentTime.compareTo(quietHoursStart) >= 0 ||
          currentTime.compareTo(quietHoursEnd) <= 0;
    } else {
      // Same day quiet hours (e.g., 13:00 to 14:00)
      return currentTime.compareTo(quietHoursStart) >= 0 &&
          currentTime.compareTo(quietHoursEnd) <= 0;
    }
  }

  /// Get enabled notification types
  List<NotificationType> get enabledNotificationTypes {
    final types = <NotificationType>[];
    if (orderUpdatesEnabled) types.add(NotificationType.orderUpdate);
    if (promotionsEnabled) types.add(NotificationType.promotion);
    if (cartAbandonmentEnabled) types.add(NotificationType.cartAbandonment);
    if (priceAlertsEnabled) types.add(NotificationType.priceAlert);
    if (stockAlertsEnabled) types.add(NotificationType.stockAlert);
    if (newProductsEnabled) types.add(NotificationType.newProduct);
    return types;
  }

  /// Check if any notifications are enabled
  bool get hasAnyNotificationsEnabled {
    return pushNotificationsEnabled || emailNotificationsEnabled || smsNotificationsEnabled;
  }

  /// Get notification method preference for type
  List<String> getNotificationMethods(NotificationType type) {
    final methods = <String>[];

    if (isTypeEnabled(type)) {
      if (pushNotificationsEnabled) methods.add('push');
      if (emailNotificationsEnabled) methods.add('email');
      if (smsNotificationsEnabled) methods.add('sms');
    }

    return methods;
  }

  @override
  List<Object?> get props => [
    userId,
    pushNotificationsEnabled,
    emailNotificationsEnabled,
    smsNotificationsEnabled,
    orderUpdatesEnabled,
    promotionsEnabled,
    cartAbandonmentEnabled,
    priceAlertsEnabled,
    stockAlertsEnabled,
    newProductsEnabled,
    orderUpdatesFrequency,
    promotionsFrequency,
    newsletterFrequency,
    quietHoursEnabled,
    quietHoursStart,
    quietHoursEnd,
    subscribedTopics,
    mutedCategories,
    soundPreference,
    vibrationPreference,
    showOnLockScreen,
    showPreview,
    lastUpdated,
  ];
}