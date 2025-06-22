import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failures.dart';
import '../entities/profile.dart';
import '../entities/user_preferences.dart';
import '../entities/profile_stats.dart';

abstract class ProfileRepository {
  /// Get current user profile
  ///
  /// Returns [Profile] on success
  /// Returns [Failure] on error (ServerFailure, CacheFailure, NetworkFailure)
  Future<Either<Failure, Profile>> getProfile();

  /// Update user profile information
  ///
  /// Takes [Profile] with updated information
  /// Returns updated [Profile] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure, ValidationFailure)
  Future<Either<Failure, Profile>> updateProfile(Profile profile);

  /// Upload profile image
  ///
  /// Takes [XFile] image file to upload
  /// Returns image URL [String] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure)
  Future<Either<Failure, String>> uploadProfileImage(XFile imageFile);

  /// Delete profile image
  ///
  /// Returns [void] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure)
  Future<Either<Failure, void>> deleteProfileImage();

  /// Get user preferences and settings
  ///
  /// Returns [UserPreferences] on success
  /// Returns [Failure] on error (ServerFailure, CacheFailure)
  Future<Either<Failure, UserPreferences>> getUserPreferences();

  /// Update user preferences and settings
  ///
  /// Takes [UserPreferences] with updated settings
  /// Returns updated [UserPreferences] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure)
  Future<Either<Failure, UserPreferences>> updateUserPreferences(UserPreferences preferences);

  /// Get profile statistics and activity data
  ///
  /// Returns [ProfileStats] on success
  /// Returns [Failure] on error (ServerFailure, CacheFailure)
  Future<Either<Failure, ProfileStats>> getProfileStats();

  /// Delete user account permanently
  ///
  /// This action is irreversible and will remove all user data
  /// Returns [void] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure)
  Future<Either<Failure, void>> deleteAccount();

  /// Export user data for download
  ///
  /// Returns download URL [String] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure)
  Future<Either<Failure, String>> exportUserData();

  /// Change user password
  ///
  /// Takes [currentPassword] and [newPassword]
  /// Returns [void] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure, ValidationFailure)
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Enable or disable two-factor authentication
  ///
  /// Takes [enabled] boolean flag
  /// Returns [void] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure)
  Future<Either<Failure, void>> toggleTwoFactorAuth(bool enabled);

  /// Send email verification
  ///
  /// Returns [void] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure)
  Future<Either<Failure, void>> verifyEmail();

  /// Send phone number verification
  ///
  /// Takes [phoneNumber] to verify
  /// Returns [void] on success
  /// Returns [Failure] on error (ServerFailure, NetworkFailure, ValidationFailure)
  Future<Either<Failure, void>> verifyPhoneNumber(String phoneNumber);
}