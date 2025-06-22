import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/user_preferences.dart';

part 'user_preferences_model.freezed.dart';
part 'user_preferences_model.g.dart';

@freezed
@HiveType(typeId: 5)
class UserPreferencesModel with _$UserPreferencesModel {
  const factory UserPreferencesModel({
    @HiveField(0) required String userId,
    @HiveField(1) @Default(ThemeMode.system) ThemeMode themeMode,
    @HiveField(2) @Default(Language.english) Language language,
    @HiveField(3) @Default(true) bool pushNotificationsEnabled,
    @HiveField(4) @Default(true) bool emailNotificationsEnabled,
    @HiveField(5) @Default(false) bool smsNotificationsEnabled,
    @HiveField(6) @Default(NotificationFrequency.instant) NotificationFrequency orderUpdates,
    @HiveField(7) @Default(NotificationFrequency.weekly) NotificationFrequency promotionalEmails,
    @HiveField(8) @Default(NotificationFrequency.weekly) NotificationFrequency newsletterSubscription,
    @HiveField(9) @Default(false) bool biometricAuthEnabled,
    @HiveField(10) @Default(false) bool twoFactorAuthEnabled,
    @HiveField(11) @Default(true) bool shareDataForAnalytics,
    @HiveField(12) @Default(false) bool shareDataForMarketing,
    @HiveField(13) @Default('USD') String currency,
    @HiveField(14) @Default('UTC') String timeZone,
    @HiveField(15) @Default(true) bool autoBackup,
    @HiveField(16) required DateTime updatedAt,
  }) = _UserPreferencesModel;

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      userId: json['userId']?.toString() ?? '',
      themeMode: _parseThemeMode(json['themeMode']?.toString()),
      language: _parseLanguage(json['language']?.toString()),
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool? ?? true,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] as bool? ?? false,
      orderUpdates: _parseNotificationFrequency(json['orderUpdates']?.toString()),
      promotionalEmails: _parseNotificationFrequency(json['promotionalEmails']?.toString()),
      newsletterSubscription: _parseNotificationFrequency(json['newsletterSubscription']?.toString()),
      biometricAuthEnabled: json['biometricAuthEnabled'] as bool? ?? false,
      twoFactorAuthEnabled: json['twoFactorAuthEnabled'] as bool? ?? false,
      shareDataForAnalytics: json['shareDataForAnalytics'] as bool? ?? true,
      shareDataForMarketing: json['shareDataForMarketing'] as bool? ?? false,
      currency: json['currency']?.toString() ?? 'USD',
      timeZone: json['timeZone']?.toString() ?? 'UTC',
      autoBackup: json['autoBackup'] as bool? ?? true,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.parse('2025-06-22 08:11:58'),
    );
  }

  factory UserPreferencesModel.fromUserPreferences(UserPreferences preferences) {
    return UserPreferencesModel(
      userId: preferences.userId,
      themeMode: preferences.themeMode,
      language: preferences.language,
      pushNotificationsEnabled: preferences.pushNotificationsEnabled,
      emailNotificationsEnabled: preferences.emailNotificationsEnabled,
      smsNotificationsEnabled: preferences.smsNotificationsEnabled,
      orderUpdates: preferences.orderUpdates,
      promotionalEmails: preferences.promotionalEmails,
      newsletterSubscription: preferences.newsletterSubscription,
      biometricAuthEnabled: preferences.biometricAuthEnabled,
      twoFactorAuthEnabled: preferences.twoFactorAuthEnabled,
      shareDataForAnalytics: preferences.shareDataForAnalytics,
      shareDataForMarketing: preferences.shareDataForMarketing,
      currency: preferences.currency,
      timeZone: preferences.timeZone,
      autoBackup: preferences.autoBackup,
      updatedAt: preferences.updatedAt,
    );
  }

  // Default preferences for roshdology123
  factory UserPreferencesModel.defaults(String userId) {
    return UserPreferencesModel(
      userId: userId,
      updatedAt: DateTime.parse('2025-06-22 08:11:58'),
    );
  }

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      case 'system':
      default: return ThemeMode.system;
    }
  }

  static Language _parseLanguage(String? value) {
    switch (value) {
      case 'arabic': return Language.arabic;
      case 'english':
      default: return Language.english;
    }
  }

  static NotificationFrequency _parseNotificationFrequency(String? value) {
    switch (value) {
      case 'instant': return NotificationFrequency.instant;
      case 'daily': return NotificationFrequency.daily;
      case 'weekly': return NotificationFrequency.weekly;
      case 'never': return NotificationFrequency.never;
      default: return NotificationFrequency.instant;
    }
  }


}

// Extension for UserPreferencesModel
extension UserPreferencesModelExtension on UserPreferencesModel {
  UserPreferences toUserPreferences() {
    return UserPreferences(
      userId: userId,
      themeMode: themeMode,
      language: language,
      pushNotificationsEnabled: pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled,
      orderUpdates: orderUpdates,
      promotionalEmails: promotionalEmails,
      newsletterSubscription: newsletterSubscription,
      biometricAuthEnabled: biometricAuthEnabled,
      twoFactorAuthEnabled: twoFactorAuthEnabled,
      shareDataForAnalytics: shareDataForAnalytics,
      shareDataForMarketing: shareDataForMarketing,
      currency: currency,
      timeZone: timeZone,
      autoBackup: autoBackup,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'themeMode': themeMode.name,
      'language': language.name,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'orderUpdates': orderUpdates.name,
      'promotionalEmails': promotionalEmails.name,
      'newsletterSubscription': newsletterSubscription.name,
      'biometricAuthEnabled': biometricAuthEnabled,
      'twoFactorAuthEnabled': twoFactorAuthEnabled,
      'shareDataForAnalytics': shareDataForAnalytics,
      'shareDataForMarketing': shareDataForMarketing,
      'currency': currency,
      'timeZone': timeZone,
      'autoBackup': autoBackup,
      'updatedAt': DateTime.parse('2025-06-22 08:11:58').toIso8601String(),
    };
  }
}