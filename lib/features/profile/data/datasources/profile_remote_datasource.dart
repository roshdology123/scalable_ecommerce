import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/profile_model.dart';
import '../models/user_preferences_model.dart';
import '../models/profile_stats_model.dart';

abstract class ProfileRemoteDataSource {
  /// Get user profile from FakeStoreAPI
  Future<ProfileModel> getProfile();

  /// Update user profile on FakeStoreAPI
  Future<ProfileModel> updateProfile(ProfileModel profile);

  /// Upload profile image (mock - FakeStoreAPI doesn't support this)
  Future<String> uploadProfileImage(XFile imageFile);

  /// Delete profile image (mock)
  Future<void> deleteProfileImage();

  /// Get user preferences (mock - not in FakeStoreAPI)
  Future<UserPreferencesModel> getUserPreferences();

  /// Update user preferences (mock)
  Future<UserPreferencesModel> updateUserPreferences(UserPreferencesModel preferences);

  /// Get profile statistics (mock)
  Future<ProfileStatsModel> getProfileStats();

  /// Delete user account (using FakeStoreAPI)
  Future<void> deleteAccount();

  /// Export user data (mock)
  Future<String> exportUserData();

  /// Change password (mock - not in FakeStoreAPI)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Get all users (for admin purposes)
  Future<List<ProfileModel>> getAllUsers();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ProfileModel> getProfile() async {
    try {
      // For roshdology123, return mock data since they're not in FakeStoreAPI
      await Future.delayed(const Duration(milliseconds: 500));
      return ProfileModel.roshdology123();

      // If this was a real user ID from FakeStore, we'd do:
      // final response = await _dioClient.get('/users/1');
      // if (response.statusCode == 200) {
      //   return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      // }
      // throw ApiException.fromResponse(response.statusCode ?? 500, response.data);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get profile: ${e.toString()}',
        code: 'GET_PROFILE_ERROR',
      );
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      // For demo purposes, simulate API call to FakeStoreAPI
      await Future.delayed(const Duration(milliseconds: 800));

      // In real implementation with existing FakeStore user:
      // final response = await _dioClient.put(
      //   '/users/${profile.id}',
      //   data: profile.toFakeStoreJson(),
      // );
      // if (response.statusCode == 200) {
      //   return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      // }

      // For mock, return updated profile
      return profile.copyWith(
        updatedAt: DateTime.parse('2025-06-22 08:11:58'),
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to update profile: ${e.toString()}',
        code: 'UPDATE_PROFILE_ERROR',
      );
    }
  }

  @override
  Future<String> uploadProfileImage(XFile imageFile) async {
    try {
      // FakeStoreAPI doesn't support image upload, so we simulate it
      await Future.delayed(const Duration(milliseconds: 1500));

      final timestamp = DateTime.parse('2025-06-22 08:11:58').millisecondsSinceEpoch;
      return 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&t=$timestamp';
    } catch (e) {
      throw NetworkException(
        message: 'Failed to upload profile image: ${e.toString()}',
        code: 'UPLOAD_IMAGE_ERROR',
      );
    }
  }

  @override
  Future<void> deleteProfileImage() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Mock implementation
    } catch (e) {
      throw NetworkException(
        message: 'Failed to delete profile image: ${e.toString()}',
        code: 'DELETE_IMAGE_ERROR',
      );
    }
  }

  @override
  Future<UserPreferencesModel> getUserPreferences() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return UserPreferencesModel.defaults('11'); // roshdology123's ID
    } catch (e) {
      throw NetworkException(
        message: 'Failed to get user preferences: ${e.toString()}',
        code: 'GET_PREFERENCES_ERROR',
      );
    }
  }

  @override
  Future<UserPreferencesModel> updateUserPreferences(UserPreferencesModel preferences) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return preferences.copyWith(
        updatedAt: DateTime.parse('2025-06-22 08:11:58'),
      );
    } catch (e) {
      throw NetworkException(
        message: 'Failed to update user preferences: ${e.toString()}',
        code: 'UPDATE_PREFERENCES_ERROR',
      );
    }
  }

  @override
  Future<ProfileStatsModel> getProfileStats() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return ProfileStatsModel.mock('11'); // roshdology123's stats
    } catch (e) {
      throw NetworkException(
        message: 'Failed to get profile stats: ${e.toString()}',
        code: 'GET_STATS_ERROR',
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // Using FakeStoreAPI delete user endpoint
      await Future.delayed(const Duration(milliseconds: 1000));

      // Real implementation would be:
      // final response = await _dioClient.delete('/users/11');
      // if (response.statusCode != 200) {
      //   throw ApiException.fromResponse(response.statusCode ?? 500, response.data);
      // }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to delete account: ${e.toString()}',
        code: 'DELETE_ACCOUNT_ERROR',
      );
    }
  }

  @override
  Future<String> exportUserData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 2000));
      return 'https://api.example.com/exports/roshdology123_data_2025-06-22.zip';
    } catch (e) {
      throw NetworkException(
        message: 'Failed to export user data: ${e.toString()}',
        code: 'EXPORT_DATA_ERROR',
      );
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // FakeStoreAPI doesn't have change password endpoint
      await Future.delayed(const Duration(milliseconds: 800));
      // Mock implementation
    } catch (e) {
      throw NetworkException(
        message: 'Failed to change password: ${e.toString()}',
        code: 'CHANGE_PASSWORD_ERROR',
      );
    }
  }

  @override
  Future<List<ProfileModel>> getAllUsers() async {
    try {
      // This uses the real FakeStoreAPI endpoint
      final response = await _dioClient.get('/users');

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = response.data as List<dynamic>;
        final users = usersJson
            .map((json) => ProfileModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Add roshdology123 to the list
        users.add(ProfileModel.roshdology123());

        return users;
      }

      throw ApiException.fromResponse(
        response.statusCode ?? 500,
        response.data,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(
        message: 'Failed to get all users: ${e.toString()}',
        code: 'GET_ALL_USERS_ERROR',
      );
    }
  }
}