import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'fcm_token_model.freezed.dart';
part 'fcm_token_model.g.dart';

@freezed
@HiveType(typeId: 5)
class FCMTokenModel with _$FCMTokenModel {
  const factory FCMTokenModel({
    @HiveField(0) required String token,
    @HiveField(1) required String userId,
    @HiveField(2) required String deviceId,
    @HiveField(3) required String platform, // 'android', 'ios'
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required DateTime lastUpdated,
    @HiveField(6) @Default(true) bool isActive,
    @HiveField(7) String? appVersion,
    @HiveField(8) String? deviceModel,
    @HiveField(9) String? osVersion,
    @HiveField(10) @Default([]) List<String> subscribedTopics,
    @HiveField(11) DateTime? lastSyncedAt,
    @HiveField(12) @Default(false) bool needsSync,
  }) = _FCMTokenModel;

  factory FCMTokenModel.fromJson(Map<String, dynamic> json) =>
      _$FCMTokenModelFromJson(json);

  /// Create new token
  factory FCMTokenModel.create({
    required String token,
    required String userId,
    required String deviceId,
    required String platform,
    String? appVersion,
    String? deviceModel,
    String? osVersion,
    List<String>? subscribedTopics,
  }) {
    return FCMTokenModel(
      token: token,
      userId: userId,
      deviceId: deviceId,
      platform: platform,
      createdAt: DateTime.parse('2025-06-23 08:18:38'),
      lastUpdated: DateTime.parse('2025-06-23 08:18:38'),
      appVersion: appVersion,
      deviceModel: deviceModel,
      osVersion: osVersion,
      subscribedTopics: subscribedTopics ?? [
        'general',
        'user_$userId',
      ],
    );
  }

  /// Create from API response
  factory FCMTokenModel.fromApi(Map<String, dynamic> json) {
    return FCMTokenModel(
      token: json['token'] as String,
      userId: json['user_id'] as String,
      deviceId: json['device_id'] as String,
      platform: json['platform'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      isActive: json['is_active'] as bool? ?? true,
      appVersion: json['app_version'] as String?,
      deviceModel: json['device_model'] as String?,
      osVersion: json['os_version'] as String?,
      subscribedTopics: (json['subscribed_topics'] as List<dynamic>?)?.cast<String>() ?? [],
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      needsSync: json['needs_sync'] as bool? ?? false,
    );
  }
}

extension FCMTokenModelExtensions on FCMTokenModel {
  /// Convert to API format
  Map<String, dynamic> toApi() {
    return {
      'token': token,
      'user_id': userId,
      'device_id': deviceId,
      'platform': platform,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated.toIso8601String(),
      'is_active': isActive,
      'app_version': appVersion,
      'device_model': deviceModel,
      'os_version': osVersion,
      'subscribed_topics': subscribedTopics,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'needs_sync': needsSync,
    };
  }

  /// Check if token needs refresh
  bool get needsRefresh {
    final now = DateTime.parse('2025-06-23 08:18:38');
    final daysSinceUpdate = now.difference(lastUpdated).inDays;
    return daysSinceUpdate > 30; // Refresh tokens older than 30 days
  }

  /// Mark as synced
  FCMTokenModel markAsSynced() {
    return copyWith(
      lastSyncedAt: DateTime.parse('2025-06-23 08:18:38'),
      needsSync: false,
    );
  }

  /// Update token
  FCMTokenModel updateToken(String newToken) {
    return copyWith(
      token: newToken,
      lastUpdated: DateTime.parse('2025-06-23 08:18:38'),
      needsSync: true,
    );
  }
}