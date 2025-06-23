import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'notification_preferences_model.freezed.dart';
part 'notification_preferences_model.g.dart';

@freezed
@HiveType(typeId: 4)
class NotificationPreferencesModel with _$NotificationPreferencesModel {
  const factory NotificationPreferencesModel({
    @HiveField(0) required String userId,
    @HiveField(1) @Default(true) bool pushNotificationsEnabled,
    @HiveField(2) @Default(true) bool emailNotificationsEnabled,
    @HiveField(3) @Default(false) bool smsNotificationsEnabled,
    @HiveField(4) @Default(true) bool orderUpdatesEnabled,
    @HiveField(5) @Default(true) bool promotionsEnabled,
    @HiveField(6) @Default(true) bool cartAbandonmentEnabled,
    @HiveField(7) @Default(true) bool priceAlertsEnabled,
    @HiveField(8) @Default(true) bool stockAlertsEnabled,
    @HiveField(9) @Default(true) bool newProductsEnabled,
    @HiveField(10) @Default('immediately') String orderUpdatesFrequency,
    @HiveField(11) @Default('daily') String promotionsFrequency,
    @HiveField(12) @Default('weekly') String newsletterFrequency,
    @HiveField(13) @Default(false) bool quietHoursEnabled,
    @HiveField(14) @Default('22:00') String quietHoursStart,
    @HiveField(15) @Default('08:00') String quietHoursEnd,
    @HiveField(16) @Default([]) List<String> subscribedTopics,
    @HiveField(17) @Default([]) List<String> mutedCategories,
    @HiveField(18) @Default('all') String soundPreference, // 'all', 'important', 'none'
    @HiveField(19) @Default('all') String vibrationPreference, // 'all', 'important', 'none'
    @HiveField(20) @Default(true) bool showOnLockScreen,
    @HiveField(21) @Default(true) bool showPreview,
    @HiveField(22) DateTime? lastUpdated,
  }) = _NotificationPreferencesModel;

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);

  /// Create default preferences for user
  factory NotificationPreferencesModel.defaultForUser(String userId) {
    return NotificationPreferencesModel(
      userId: userId,
      lastUpdated: DateTime.parse('2025-06-23 08:18:38'),
      subscribedTopics: [
        'general',
        'user_$userId',
        'electronics',
        'promotions',
      ],
    );
  }

  /// Create from API response
  factory NotificationPreferencesModel.fromApi(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      userId: json['user_id'] as String,
      pushNotificationsEnabled: json['push_notifications_enabled'] as bool? ?? true,
      emailNotificationsEnabled: json['email_notifications_enabled'] as bool? ?? true,
      smsNotificationsEnabled: json['sms_notifications_enabled'] as bool? ?? false,
      orderUpdatesEnabled: json['order_updates_enabled'] as bool? ?? true,
      promotionsEnabled: json['promotions_enabled'] as bool? ?? true,
      cartAbandonmentEnabled: json['cart_abandonment_enabled'] as bool? ?? true,
      priceAlertsEnabled: json['price_alerts_enabled'] as bool? ?? true,
      stockAlertsEnabled: json['stock_alerts_enabled'] as bool? ?? true,
      newProductsEnabled: json['new_products_enabled'] as bool? ?? true,
      orderUpdatesFrequency: json['order_updates_frequency'] as String? ?? 'immediately',
      promotionsFrequency: json['promotions_frequency'] as String? ?? 'daily',
      newsletterFrequency: json['newsletter_frequency'] as String? ?? 'weekly',
      quietHoursEnabled: json['quiet_hours_enabled'] as bool? ?? false,
      quietHoursStart: json['quiet_hours_start'] as String? ?? '22:00',
      quietHoursEnd: json['quiet_hours_end'] as String? ?? '08:00',
      subscribedTopics: (json['subscribed_topics'] as List<dynamic>?)?.cast<String>() ?? [],
      mutedCategories: (json['muted_categories'] as List<dynamic>?)?.cast<String>() ?? [],
      soundPreference: json['sound_preference'] as String? ?? 'all',
      vibrationPreference: json['vibration_preference'] as String? ?? 'all',
      showOnLockScreen: json['show_on_lock_screen'] as bool? ?? true,
      showPreview: json['show_preview'] as bool? ?? true,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : DateTime.parse('2025-06-23 08:18:38'),
    );
  }
}

extension NotificationPreferencesModelExtensions on NotificationPreferencesModel {
  /// Convert to API format
  Map<String, dynamic> toApi() {
    return {
      'user_id': userId,
      'push_notifications_enabled': pushNotificationsEnabled,
      'email_notifications_enabled': emailNotificationsEnabled,
      'sms_notifications_enabled': smsNotificationsEnabled,
      'order_updates_enabled': orderUpdatesEnabled,
      'promotions_enabled': promotionsEnabled,
      'cart_abandonment_enabled': cartAbandonmentEnabled,
      'price_alerts_enabled': priceAlertsEnabled,
      'stock_alerts_enabled': stockAlertsEnabled,
      'new_products_enabled': newProductsEnabled,
      'order_updates_frequency': orderUpdatesFrequency,
      'promotions_frequency': promotionsFrequency,
      'newsletter_frequency': newsletterFrequency,
      'quiet_hours_enabled': quietHoursEnabled,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      'subscribed_topics': subscribedTopics,
      'muted_categories': mutedCategories,
      'sound_preference': soundPreference,
      'vibration_preference': vibrationPreference,
      'show_on_lock_screen': showOnLockScreen,
      'show_preview': showPreview,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Check if notifications are allowed for a specific type
  bool isTypeEnabled(String notificationType) {
    switch (notificationType.toLowerCase()) {
      case 'orderupdate':
        return orderUpdatesEnabled;
      case 'promotion':
        return promotionsEnabled;
      case 'cartabandonment':
        return cartAbandonmentEnabled;
      case 'pricealert':
        return priceAlertsEnabled;
      case 'stockalert':
        return stockAlertsEnabled;
      case 'newproduct':
        return newProductsEnabled;
      default:
        return pushNotificationsEnabled;
    }
  }

  /// Check if currently in quiet hours
  bool get isInQuietHours {
    if (!quietHoursEnabled) return false;

    final now = DateTime.parse('2025-06-23 08:18:38');
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Simple time comparison (can be enhanced for cross-day quiet hours)
    return currentTime.compareTo(quietHoursStart) >= 0 &&
        currentTime.compareTo(quietHoursEnd) <= 0;
  }

  /// Get enabled notification types
  List<String> get enabledNotificationTypes {
    final types = <String>[];
    if (orderUpdatesEnabled) types.add('orderUpdate');
    if (promotionsEnabled) types.add('promotion');
    if (cartAbandonmentEnabled) types.add('cartAbandonment');
    if (priceAlertsEnabled) types.add('priceAlert');
    if (stockAlertsEnabled) types.add('stockAlert');
    if (newProductsEnabled) types.add('newProduct');
    return types;
  }
}