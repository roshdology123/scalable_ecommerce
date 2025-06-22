import 'package:dartz/dartz.dart' as dartz;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/entities/profile_stats.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';
import '../models/user_preferences_model.dart';
import '../models/profile_stats_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<dartz.Either<Failure, Profile>> getProfile() async {
    if (await _networkInfo.isConnected) {
      try {
        final profileModel = await _remoteDataSource.getProfile();
        final profile = profileModel.toProfile();

        // Cache the profile locally
        await _localDataSource.cacheProfile(profileModel);

        return dartz.Right(profile);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to get profile: ${e.toString()}',
          code: 'GET_PROFILE_ERROR',
        ));
      }
    } else {
      try {
        final profileModel = await _localDataSource.getCachedProfile();
        final profile = profileModel.toProfile();
        return dartz.Right(profile);
      } catch (e) {
        return const dartz.Left(CacheFailure(
          message: 'No cached profile available and no internet connection',
          code: 'NO_CACHED_PROFILE',
        ));
      }
    }
  }

  @override
  Future<dartz.Either<Failure, Profile>> updateProfile(Profile profile) async {
    if (await _networkInfo.isConnected) {
      try {
        final profileModel = ProfileModel.fromProfile(profile);
        final updatedProfileModel = await _remoteDataSource.updateProfile(profileModel);
        final updatedProfile = updatedProfileModel.toProfile();

        // Cache the updated profile locally
        await _localDataSource.cacheProfile(updatedProfileModel);

        return dartz.Right(updatedProfile);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to update profile: ${e.toString()}',
          code: 'UPDATE_PROFILE_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to update profile',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, String>> uploadProfileImage(XFile imageFile) async {
    if (await _networkInfo.isConnected) {
      try {
        final imageUrl = await _remoteDataSource.uploadProfileImage(imageFile);
        return dartz.Right(imageUrl);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to upload profile image: ${e.toString()}',
          code: 'UPLOAD_IMAGE_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to upload image',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> deleteProfileImage() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteProfileImage();
        return const dartz.Right(null);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to delete profile image: ${e.toString()}',
          code: 'DELETE_IMAGE_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to delete image',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, UserPreferences>> getUserPreferences() async {
    if (await _networkInfo.isConnected) {
      try {
        final preferencesModel = await _remoteDataSource.getUserPreferences();
        final preferences = preferencesModel.toUserPreferences();

        // Cache the preferences locally
        await _localDataSource.cacheUserPreferences(preferencesModel);

        return dartz.Right(preferences);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to get user preferences: ${e.toString()}',
          code: 'GET_PREFERENCES_ERROR',
        ));
      }
    } else {
      try {
        final preferencesModel = await _localDataSource.getCachedUserPreferences();
        final preferences = preferencesModel.toUserPreferences();
        return dartz.Right(preferences);
      } catch (e) {
        // Return default preferences if no cache and no internet
        final defaultPreferences = UserPreferences(
          userId: '11', // roshdology123's ID
          updatedAt: DateTime.parse('2025-06-22 08:17:00'),
        );
        return dartz.Right(defaultPreferences);
      }
    }
  }

  @override
  Future<dartz.Either<Failure, UserPreferences>> updateUserPreferences(UserPreferences preferences) async {
    if (await _networkInfo.isConnected) {
      try {
        final preferencesModel = UserPreferencesModel.fromUserPreferences(preferences);
        final updatedPreferencesModel = await _remoteDataSource.updateUserPreferences(preferencesModel);
        final updatedPreferences = updatedPreferencesModel.toUserPreferences();

        // Cache the updated preferences locally
        await _localDataSource.cacheUserPreferences(updatedPreferencesModel);

        return dartz.Right(updatedPreferences);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to update user preferences: ${e.toString()}',
          code: 'UPDATE_PREFERENCES_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to update preferences',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, ProfileStats>> getProfileStats() async {
    if (await _networkInfo.isConnected) {
      try {
        final statsModel = await _remoteDataSource.getProfileStats();
        final stats = statsModel.toProfileStats();

        // Cache the stats locally
        await _localDataSource.cacheProfileStats(statsModel);

        return dartz.Right(stats);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to get profile stats: ${e.toString()}',
          code: 'GET_STATS_ERROR',
        ));
      }
    } else {
      try {
        final statsModel = await _localDataSource.getCachedProfileStats();
        final stats = statsModel.toProfileStats();
        return dartz.Right(stats);
      } catch (e) {
        return const dartz.Left(CacheFailure(
          message: 'No cached profile stats available and no internet connection',
          code: 'NO_CACHED_STATS',
        ));
      }
    }
  }

  @override
  Future<dartz.Either<Failure, void>> deleteAccount() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteAccount();

        // Clear all local cache after account deletion
        await _localDataSource.clearAllProfileCache();

        return const dartz.Right(null);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to delete account: ${e.toString()}',
          code: 'DELETE_ACCOUNT_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to delete account',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, String>> exportUserData() async {
    if (await _networkInfo.isConnected) {
      try {
        final downloadUrl = await _remoteDataSource.exportUserData();
        return dartz.Right(downloadUrl);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to export user data: ${e.toString()}',
          code: 'EXPORT_DATA_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to export data',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        return const dartz.Right(null);
      } catch (e) {
        if (e is ApiException) {
          return dartz.Left(ServerFailure(message: e.message, code: e.code));
        }
        return dartz.Left(ServerFailure(
          message: 'Failed to change password: ${e.toString()}',
          code: 'CHANGE_PASSWORD_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to change password',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> toggleTwoFactorAuth(bool enabled) async {
    if (await _networkInfo.isConnected) {
      try {
        // For now, just simulate the operation since FakeStoreAPI doesn't support this
        await Future.delayed(const Duration(milliseconds: 500));
        return const dartz.Right(null);
      } catch (e) {
        return dartz.Left(ServerFailure(
          message: 'Failed to toggle two-factor auth: ${e.toString()}',
          code: 'TOGGLE_2FA_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to toggle two-factor auth',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> verifyEmail() async {
    if (await _networkInfo.isConnected) {
      try {
        // For now, just simulate the operation since FakeStoreAPI doesn't support this
        await Future.delayed(const Duration(milliseconds: 500));
        return const dartz.Right(null);
      } catch (e) {
        return dartz.Left(ServerFailure(
          message: 'Failed to verify email: ${e.toString()}',
          code: 'VERIFY_EMAIL_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to verify email',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> verifyPhoneNumber(String phoneNumber) async {
    if (await _networkInfo.isConnected) {
      try {
        // For now, just simulate the operation since FakeStoreAPI doesn't support this
        await Future.delayed(const Duration(milliseconds: 500));
        return const dartz.Right(null);
      } catch (e) {
        return dartz.Left(ServerFailure(
          message: 'Failed to verify phone number: ${e.toString()}',
          code: 'VERIFY_PHONE_ERROR',
        ));
      }
    } else {
      return const dartz.Left(NetworkFailure(
        message: 'No internet connection available to verify phone number',
        code: 'NO_INTERNET_CONNECTION',
      ));
    }
  }
}

// Extension to convert Profile to ProfileModel
extension ProfileToModelExtension on Profile {
  ProfileModel toProfileModel() {
    return ProfileModel(
      id: id,
      email: email,
      username: id,
      firstName: firstName,
      lastName: lastName,
      phone: phoneNumber,
      profileImageUrl: profileImageUrl,
      bio: bio,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address != null ? AddressModel(
        street: address,
        city: city,
        zipcode: postalCode,
      ) : null,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Extension to convert ProfileModel from Profile
extension ProfileModelFromProfileExtension on ProfileModel {
  static ProfileModel fromProfile(Profile profile) {
    return ProfileModel(
      id: profile.id,
      email: profile.email,
      username: 'roshdology123', // Default username for current user
      firstName: profile.firstName,
      lastName: profile.lastName,
      phone: profile.phoneNumber,
      profileImageUrl: profile.profileImageUrl,
      bio: profile.bio,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      address: profile.address != null ? AddressModel(
        street: profile.address,
        city: profile.city,
        zipcode: profile.postalCode,
        geolocation: profile.city?.toLowerCase() == 'cairo'
            ? const GeolocationModel(lat: '30.0444', long: '31.2357')
            : null,
      ) : null,
      isEmailVerified: profile.isEmailVerified,
      isPhoneVerified: profile.isPhoneVerified,
      createdAt: profile.createdAt,
      updatedAt: DateTime.parse('2025-06-22 08:17:00'),
    );
  }
}