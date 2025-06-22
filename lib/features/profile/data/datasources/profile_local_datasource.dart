import 'dart:convert';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/profile_model.dart';
import '../models/user_preferences_model.dart';
import '../models/profile_stats_model.dart';

abstract class ProfileLocalDataSource {
  /// Cache profile data
  Future<void> cacheProfile(ProfileModel profile);

  /// Get cached profile
  Future<ProfileModel> getCachedProfile();

  /// Clear cached profile
  Future<void> clearCachedProfile();

  /// Cache user preferences
  Future<void> cacheUserPreferences(UserPreferencesModel preferences);

  /// Get cached user preferences
  Future<UserPreferencesModel> getCachedUserPreferences();

  /// Cache profile stats
  Future<void> cacheProfileStats(ProfileStatsModel stats);

  /// Get cached profile stats
  Future<ProfileStatsModel> getCachedProfileStats();

  /// Check if profile is cached
  Future<bool> isProfileCached();

  /// Check if preferences are cached
  Future<bool> arePreferencesCached();

  /// Clear all cached profile data
  Future<void> clearAllProfileCache();
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SecureStorage _secureStorage;

  ProfileLocalDataSourceImpl(this._secureStorage);

  static const String _profileCacheKey = 'cached_profile';
  static const String _preferencesCacheKey = 'cached_user_preferences';
  static const String _statsCacheKey = 'cached_profile_stats';

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    try {
      // Use the manual toJson from the extension until Freezed is generated
      final profileData = {
        'id': profile.id,
        'email': profile.email,
        'username': profile.username,
        'firstName': profile.firstName,
        'lastName': profile.lastName,
        'phone': profile.phone,
        'profileImageUrl': profile.profileImageUrl,
        'bio': profile.bio,
        'dateOfBirth': profile.dateOfBirth?.toIso8601String(),
        'gender': profile.gender,
        'address': profile.address != null ? {
          'street': profile.address!.street,
          'number': profile.address!.number,
          'city': profile.address!.city,
          'zipcode': profile.address!.zipcode,
          'geolocation': profile.address!.geolocation != null ? {
            'lat': profile.address!.geolocation!.lat,
            'long': profile.address!.geolocation!.long,
          } : null,
        } : null,
        'isEmailVerified': profile.isEmailVerified,
        'isPhoneVerified': profile.isPhoneVerified,
        'createdAt': profile.createdAt.toIso8601String(),
        'updatedAt': profile.updatedAt.toIso8601String(),
      };

      final profileJson = jsonEncode(profileData);
      await LocalStorage.saveToCache(
        _profileCacheKey,
        {'profile': profileJson},
        expiry: const Duration(hours: 24), // Cache for 24 hours
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache profile: ${e.toString()}',
        code: 'CACHE_PROFILE_ERROR',
      );
    }
  }

  @override
  Future<ProfileModel> getCachedProfile() async {
    try {
      final cacheData = LocalStorage.getFromCache(_profileCacheKey);
      if (cacheData == null || cacheData['profile'] == null) {
        throw const CacheException(
          message: 'No cached profile found',
          code: 'NO_CACHED_PROFILE',
        );
      }

      final profileJson = jsonDecode(cacheData['profile'] as String) as Map<String, dynamic>;
      return ProfileModel.fromJson(profileJson);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        message: 'Failed to get cached profile: ${e.toString()}',
        code: 'GET_CACHED_PROFILE_ERROR',
      );
    }
  }

  @override
  Future<void> clearCachedProfile() async {
    try {
      await LocalStorage.removeFromCache(_profileCacheKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear cached profile: ${e.toString()}',
        code: 'CLEAR_CACHED_PROFILE_ERROR',
      );
    }
  }

  @override
  Future<void> cacheUserPreferences(UserPreferencesModel preferences) async {
    try {
      // Use manual toJson until Freezed is generated
      final preferencesData = {
        'userId': preferences.userId,
        'themeMode': preferences.themeMode.name,
        'language': preferences.language.name,
        'pushNotificationsEnabled': preferences.pushNotificationsEnabled,
        'emailNotificationsEnabled': preferences.emailNotificationsEnabled,
        'smsNotificationsEnabled': preferences.smsNotificationsEnabled,
        'orderUpdates': preferences.orderUpdates.name,
        'promotionalEmails': preferences.promotionalEmails.name,
        'newsletterSubscription': preferences.newsletterSubscription.name,
        'biometricAuthEnabled': preferences.biometricAuthEnabled,
        'twoFactorAuthEnabled': preferences.twoFactorAuthEnabled,
        'shareDataForAnalytics': preferences.shareDataForAnalytics,
        'shareDataForMarketing': preferences.shareDataForMarketing,
        'currency': preferences.currency,
        'timeZone': preferences.timeZone,
        'autoBackup': preferences.autoBackup,
        'updatedAt': preferences.updatedAt.toIso8601String(),
      };

      final preferencesJson = jsonEncode(preferencesData);
      await LocalStorage.saveToCache(
        _preferencesCacheKey,
        {'preferences': preferencesJson},
        expiry: const Duration(days: 7),
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache preferences: ${e.toString()}',
        code: 'CACHE_PREFERENCES_ERROR',
      );
    }
  }

  @override
  Future<UserPreferencesModel> getCachedUserPreferences() async {
    try {
      final cacheData = LocalStorage.getFromCache(_preferencesCacheKey);
      if (cacheData == null || cacheData['preferences'] == null) {
        throw const CacheException(
          message: 'No cached preferences found',
          code: 'NO_CACHED_PREFERENCES',
        );
      }

      final preferencesJson = jsonDecode(cacheData['preferences'] as String) as Map<String, dynamic>;
      return UserPreferencesModel.fromJson(preferencesJson);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        message: 'Failed to get cached preferences: ${e.toString()}',
        code: 'GET_CACHED_PREFERENCES_ERROR',
      );
    }
  }

  @override
  Future<void> cacheProfileStats(ProfileStatsModel stats) async {
    try {
      // Use manual toJson until Freezed is generated
      final statsData = {
        'userId': stats.userId,
        'totalOrders': stats.totalOrders,
        'completedOrders': stats.completedOrders,
        'cancelledOrders': stats.cancelledOrders,
        'totalSpent': stats.totalSpent,
        'totalReviews': stats.totalReviews,
        'averageRating': stats.averageRating,
        'favoritesCount': stats.favoritesCount,
        'wishlistItems': stats.wishlistItems,
        'memberSince': stats.memberSince.toIso8601String(),
        'loyaltyPoints': stats.loyaltyPoints,
        'membershipTier': stats.membershipTier,
        'lastOrderDate': stats.lastOrderDate.toIso8601String(),
        'lastLoginDate': stats.lastLoginDate.toIso8601String(),
      };

      final statsJson = jsonEncode(statsData);
      await LocalStorage.saveToCache(
        _statsCacheKey,
        {'stats': statsJson},
        expiry: const Duration(hours: 6), // Cache for 6 hours
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache profile stats: ${e.toString()}',
        code: 'CACHE_STATS_ERROR',
      );
    }
  }

  @override
  Future<ProfileStatsModel> getCachedProfileStats() async {
    try {
      final cacheData = LocalStorage.getFromCache(_statsCacheKey);
      if (cacheData == null || cacheData['stats'] == null) {
        throw const CacheException(
          message: 'No cached profile stats found',
          code: 'NO_CACHED_STATS',
        );
      }

      final statsJson = jsonDecode(cacheData['stats'] as String) as Map<String, dynamic>;
      return ProfileStatsModel.fromJson(statsJson);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        message: 'Failed to get cached profile stats: ${e.toString()}',
        code: 'GET_CACHED_STATS_ERROR',
      );
    }
  }

  @override
  Future<bool> isProfileCached() async {
    try {
      final cacheData = LocalStorage.getFromCache(_profileCacheKey);
      return cacheData != null && cacheData['profile'] != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> arePreferencesCached() async {
    try {
      final cacheData = LocalStorage.getFromCache(_preferencesCacheKey);
      return cacheData != null && cacheData['preferences'] != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearAllProfileCache() async {
    try {
      await Future.wait([
        LocalStorage.removeFromCache(_profileCacheKey),
        LocalStorage.removeFromCache(_preferencesCacheKey),
        LocalStorage.removeFromCache(_statsCacheKey),
      ]);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear all profile cache: ${e.toString()}',
        code: 'CLEAR_ALL_PROFILE_CACHE_ERROR',
      );
    }
  }
}