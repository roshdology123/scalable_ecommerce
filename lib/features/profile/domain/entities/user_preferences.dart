import 'package:equatable/equatable.dart';

enum ThemeMode { light, dark, system }
enum Language { english, arabic }
enum NotificationFrequency { instant, daily, weekly, never }

class UserPreferences extends Equatable {
  final String userId;
  final ThemeMode themeMode;
  final Language language;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final NotificationFrequency orderUpdates;
  final NotificationFrequency promotionalEmails;
  final NotificationFrequency newsletterSubscription;
  final bool biometricAuthEnabled;
  final bool twoFactorAuthEnabled;
  final bool shareDataForAnalytics;
  final bool shareDataForMarketing;
  final String currency;
  final String timeZone;
  final bool autoBackup;
  final DateTime updatedAt;

  const UserPreferences({
    required this.userId,
    this.themeMode = ThemeMode.system,
    this.language = Language.english,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = false,
    this.orderUpdates = NotificationFrequency.instant,
    this.promotionalEmails = NotificationFrequency.weekly,
    this.newsletterSubscription = NotificationFrequency.weekly,
    this.biometricAuthEnabled = false,
    this.twoFactorAuthEnabled = false,
    this.shareDataForAnalytics = true,
    this.shareDataForMarketing = false,
    this.currency = 'USD',
    this.timeZone = 'UTC',
    this.autoBackup = true,
    required this.updatedAt,
  });

  /// Check if any notifications are enabled
  bool get hasNotificationsEnabled {
    return pushNotificationsEnabled ||
        emailNotificationsEnabled ||
        smsNotificationsEnabled;
  }

  /// Check if user has enhanced security enabled
  bool get hasEnhancedSecurity {
    return biometricAuthEnabled || twoFactorAuthEnabled;
  }

  /// Check if user shares any data
  bool get sharesAnyData {
    return shareDataForAnalytics || shareDataForMarketing;
  }

  /// Get notification frequency summary
  Map<String, NotificationFrequency> get notificationFrequencies {
    return {
      'orderUpdates': orderUpdates,
      'promotionalEmails': promotionalEmails,
      'newsletterSubscription': newsletterSubscription,
    };
  }

  /// Get theme mode display name
  String get themeModeDisplayName {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get language display name
  String get languageDisplayName {
    switch (language) {
      case Language.english:
        return 'English';
      case Language.arabic:
        return 'العربية';
    }
  }

  /// Get currency display name with symbol
  String get currencyDisplayName {
    final currencySymbols = {
      'USD': '\$ USD',
      'EUR': '€ EUR',
      'GBP': '£ GBP',
      'EGP': 'ج.م EGP',
      'SAR': 'ر.س SAR',
    };
    return currencySymbols[currency] ?? currency;
  }

  /// Get notification frequency display name
  String getNotificationFrequencyDisplayName(NotificationFrequency frequency) {
    switch (frequency) {
      case NotificationFrequency.instant:
        return 'Instant';
      case NotificationFrequency.daily:
        return 'Daily';
      case NotificationFrequency.weekly:
        return 'Weekly';
      case NotificationFrequency.never:
        return 'Never';
    }
  }

  /// Check if preferences were recently updated (within last 24 hours)
  bool get isRecentlyUpdated {
    final now = DateTime.parse('2025-06-22 08:17:00');
    final hoursSinceUpdate = now.difference(updatedAt).inHours;
    return hoursSinceUpdate <= 24;
  }

  /// Get privacy level score (0-100)
  int get privacyScore {
    int score = 0;
    int maxScore = 6;

    if (twoFactorAuthEnabled) score++;
    if (biometricAuthEnabled) score++;
    if (!shareDataForAnalytics) score++;
    if (!shareDataForMarketing) score++;
    if (!emailNotificationsEnabled) score++;
    if (!smsNotificationsEnabled) score++;

    return ((score / maxScore) * 100).round();
  }

  /// Get security level description
  String get securityLevel {
    if (twoFactorAuthEnabled && biometricAuthEnabled) {
      return 'High';
    } else if (twoFactorAuthEnabled || biometricAuthEnabled) {
      return 'Medium';
    } else {
      return 'Basic';
    }
  }

  /// Create default preferences for a user
  factory UserPreferences.defaultsForUser(String userId) {
    return UserPreferences(
      userId: userId,
      updatedAt: DateTime.parse('2025-06-22 08:17:00'),
    );
  }

  /// Create privacy-focused preferences
  factory UserPreferences.privacyFocused(String userId) {
    return UserPreferences(
      userId: userId,
      shareDataForAnalytics: false,
      shareDataForMarketing: false,
      emailNotificationsEnabled: false,
      smsNotificationsEnabled: false,
      promotionalEmails: NotificationFrequency.never,
      newsletterSubscription: NotificationFrequency.never,
      twoFactorAuthEnabled: true,
      biometricAuthEnabled: true,
      updatedAt: DateTime.parse('2025-06-22 08:17:00'),
    );
  }

  /// Create a copy of preferences with updated fields
  UserPreferences copyWith({
    String? userId,
    ThemeMode? themeMode,
    Language? language,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    NotificationFrequency? orderUpdates,
    NotificationFrequency? promotionalEmails,
    NotificationFrequency? newsletterSubscription,
    bool? biometricAuthEnabled,
    bool? twoFactorAuthEnabled,
    bool? shareDataForAnalytics,
    bool? shareDataForMarketing,
    String? currency,
    String? timeZone,
    bool? autoBackup,
    DateTime? updatedAt,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotionalEmails: promotionalEmails ?? this.promotionalEmails,
      newsletterSubscription: newsletterSubscription ?? this.newsletterSubscription,
      biometricAuthEnabled: biometricAuthEnabled ?? this.biometricAuthEnabled,
      twoFactorAuthEnabled: twoFactorAuthEnabled ?? this.twoFactorAuthEnabled,
      shareDataForAnalytics: shareDataForAnalytics ?? this.shareDataForAnalytics,
      shareDataForMarketing: shareDataForMarketing ?? this.shareDataForMarketing,
      currency: currency ?? this.currency,
      timeZone: timeZone ?? this.timeZone,
      autoBackup: autoBackup ?? this.autoBackup,
      updatedAt: updatedAt ?? DateTime.parse('2025-06-22 08:17:00'),
    );
  }

  @override
  List<Object?> get props => [
    userId,
    themeMode,
    language,
    pushNotificationsEnabled,
    emailNotificationsEnabled,
    smsNotificationsEnabled,
    orderUpdates,
    promotionalEmails,
    newsletterSubscription,
    biometricAuthEnabled,
    twoFactorAuthEnabled,
    shareDataForAnalytics,
    shareDataForMarketing,
    currency,
    timeZone,
    autoBackup,
    updatedAt,
  ];

  @override
  String toString() => 'UserPreferences(userId: $userId, theme: $themeModeDisplayName, security: $securityLevel)';
}