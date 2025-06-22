import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../auth/domain/usecases/change_password_usecase.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/usecases/delete_account_usecase.dart';
import '../../../domain/usecases/delete_profile_usecase.dart';
import '../../../domain/usecases/export_user_data_usecase.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_profile_image_usecase.dart';
import '../../../domain/usecases/update_profile_info_usecase.dart'; // Updated import
import '../../../domain/usecases/verify_email_usecase.dart';
import '../../../domain/usecases/verify_phone_usecase.dart';
import 'profile_state.dart';

/// Profile Cubit manages all profile-related state and operations for roshdology123
/// 
/// Handles:
/// - Loading and updating profile information
/// - Profile image upload/delete operations
/// - Password changes and security operations
/// - Email and phone verification
/// - Account deletion and data export
/// - Error handling and offline support
@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileInfoUseCase _updateProfileInfoUseCase; // Updated type
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final DeleteProfileImageUseCase _deleteProfileImageUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final VerifyPhoneUseCase _verifyPhoneUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final ExportUserDataUseCase _exportUserDataUseCase;

  Profile? _currentProfile;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileInfoUseCase updateProfileInfoUseCase, // Updated parameter name
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required DeleteProfileImageUseCase deleteProfileImageUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required VerifyPhoneUseCase verifyPhoneUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required ExportUserDataUseCase exportUserDataUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileInfoUseCase = updateProfileInfoUseCase, // Updated assignment
        _uploadProfileImageUseCase = uploadProfileImageUseCase,
        _deleteProfileImageUseCase = deleteProfileImageUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        _verifyPhoneUseCase = verifyPhoneUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _exportUserDataUseCase = exportUserDataUseCase,
        super(const ProfileInitial()) {
    debugPrint('ProfileCubit initialized for roshdology123 at 2025-06-22 09:45:42');
  }

  /// Get current profile from cache or server
  Profile? get currentProfile => _currentProfile;

  /// Load user profile
  Future<void> loadProfile() async {
    if (state is ProfileLoading) return; // Prevent multiple simultaneous loads

    emit(const ProfileLoading());
    debugPrint('Loading profile for roshdology123 at 2025-06-22 09:45:42...');

    final result = await _getProfileUseCase(NoParams());

    result.fold(
          (failure) {
        debugPrint('Failed to load profile for roshdology123: ${failure.message}');

        if (failure.code.toString() == 'NO_INTERNET_CONNECTION') {
          emit(ProfileNetworkError(
            message: 'No internet connection. Showing cached profile.',
            cachedProfile: _currentProfile,
          ));
        } else {
          emit(ProfileError(
            message: failure.message,
            code: failure.code.toString(),
            currentProfile: _currentProfile,
          ));
        }
      },
          (profile) {
        debugPrint('Profile loaded successfully for roshdology123: ${profile.fullName}');
        _currentProfile = profile;
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  /// Update user profile information
  Future<void> updateProfile(Profile updatedProfile) async {
    if (_currentProfile == null) {
      emit(const ProfileError(
        message: 'No profile loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PROFILE',
      ));
      return;
    }

    emit(ProfileUpdating(currentProfile: _currentProfile!));
    debugPrint('Updating profile for roshdology123: ${updatedProfile.fullName} at 2025-06-22 09:45:42...');

    final params = UpdateProfileInfoParams(profile: updatedProfile); // Updated params type
    final result = await _updateProfileInfoUseCase(params); // Updated use case call

    result.fold(
          (failure) {
        debugPrint('Failed to update profile for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (profile) {
        debugPrint('Profile updated successfully for roshdology123: ${profile.fullName}');
        _currentProfile = profile;
        emit(ProfileUpdated(
          profile: profile,
          message: 'Profile updated successfully at 2025-06-22 09:45:42',
        ));
      },
    );
  }

  /// Upload profile image
  Future<void> uploadProfileImage(XFile imageFile) async {
    if (_currentProfile == null) {
      emit(const ProfileError(
        message: 'No profile loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PROFILE',
      ));
      return;
    }

    emit(ProfileImageUploading(currentProfile: _currentProfile!));
    debugPrint('Uploading profile image for roshdology123: ${imageFile.name} at 2025-06-22 09:45:42');

    // Simulate upload progress
    for (double progress = 0.1; progress <= 0.9; progress += 0.1) {
      await Future.delayed(const Duration(milliseconds: 200));
      emit(ProfileImageUploading(
        currentProfile: _currentProfile!,
        uploadProgress: progress,
      ));
    }

    final params = UploadProfileImageParams(imageFile: imageFile);
    final result = await _uploadProfileImageUseCase(params);

    result.fold(
          (failure) {
        debugPrint('Failed to upload profile image for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (imageUrl) {
        debugPrint('Profile image uploaded successfully for roshdology123: $imageUrl');

        // Update profile with new image URL
        final updatedProfile = _currentProfile!.copyWith(
          profileImageUrl: imageUrl,
          updatedAt: DateTime.parse('2025-06-22 09:45:42'),
        );

        _currentProfile = updatedProfile;
        emit(ProfileImageUploaded(
          profile: updatedProfile,
          imageUrl: imageUrl,
        ));
      },
    );
  }

  /// Delete profile image
  Future<void> deleteProfileImage() async {
    if (_currentProfile == null) {
      emit(const ProfileError(
        message: 'No profile loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PROFILE',
      ));
      return;
    }

    emit(ProfileImageDeleting(currentProfile: _currentProfile!));
    debugPrint('Deleting profile image for roshdology123 at 2025-06-22 09:45:42...');

    final result = await _deleteProfileImageUseCase(NoParams());

    result.fold(
          (failure) {
        debugPrint('Failed to delete profile image for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (_) {
        debugPrint('Profile image deleted successfully for roshdology123');

        // Update profile with no image URL
        final updatedProfile = _currentProfile!.copyWith(
          profileImageUrl: null,
          updatedAt: DateTime.parse('2025-06-22 09:45:42'),
        );

        _currentProfile = updatedProfile;
        emit(ProfileImageDeleted(profile: updatedProfile));
      },
    );
  }

  /// Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(const ProfilePasswordChanging());
    debugPrint('Changing password for roshdology123 at 2025-06-22 09:45:42...');

    final params = ChangePasswordParams(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    final result = await _changePasswordUseCase(params);

    result.fold(
          (failure) {
        debugPrint('Failed to change password for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (_) {
        debugPrint('Password changed successfully for roshdology123');
        emit(const ProfilePasswordChanged());
      },
    );
  }

  /// Send email verification
  Future<void> verifyEmail() async {
    if (_currentProfile == null) {
      emit(const ProfileError(
        message: 'No profile loaded. Please refresh and try again.',
        code: 'NO_CURRENT_PROFILE',
      ));
      return;
    }

    emit(const ProfileEmailVerifying());
    debugPrint('Sending email verification to ${_currentProfile!.email} for roshdology123 at 2025-06-22 09:45:42...');

    final result = await _verifyEmailUseCase(NoParams());

    result.fold(
          (failure) {
        debugPrint('Failed to send email verification for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (_) {
        debugPrint('Email verification sent successfully for roshdology123');
        emit(ProfileEmailVerificationSent(email: _currentProfile!.email));
      },
    );
  }

  /// Send phone verification
  Future<void> verifyPhone(String phoneNumber) async {
    emit(const ProfilePhoneVerifying());
    debugPrint('Sending phone verification to $phoneNumber for roshdology123 at 2025-06-22 09:45:42...');

    final params = VerifyPhoneParams(phoneNumber: phoneNumber);
    final result = await _verifyPhoneUseCase(params);

    result.fold(
          (failure) {
        debugPrint('Failed to send phone verification for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (_) {
        debugPrint('Phone verification sent successfully for roshdology123');
        emit(ProfilePhoneVerificationSent(phoneNumber: phoneNumber));
      },
    );
  }

  /// Delete user account permanently
  Future<void> deleteAccount({
    required String confirmationText,
    String? currentPassword,
    String? reason,
  }) async {
    emit(const ProfileAccountDeleting());
    debugPrint('⚠️ Processing account deletion request for roshdology123 at 2025-06-22 09:45:42...');

    final params = DeleteAccountParams(
      confirmationText: confirmationText,
      currentPassword: currentPassword,
      reason: reason,
      understandsConsequences: true,
    );

    final result = await _deleteAccountUseCase(params);

    result.fold(
          (failure) {
        debugPrint('Failed to delete account for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (_) {
        debugPrint('✅ Account deleted successfully for roshdology123 at 2025-06-22 09:45:42');
        _currentProfile = null;
        emit(const ProfileAccountDeleted());
      },
    );
  }

  /// Export user data
  Future<void> exportUserData({
    ExportFormat format = ExportFormat.json,
    bool includeOrderHistory = true,
    bool includeActivityLogs = false,
    String? reason,
  }) async {
    emit(const ProfileDataExporting());
    debugPrint('Exporting user data for roshdology123 in ${format.name} format at 2025-06-22 09:45:42...');

    // Simulate export progress
    for (double progress = 0.2; progress <= 0.8; progress += 0.2) {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(ProfileDataExporting(exportProgress: progress));
    }

    final params = ExportUserDataParams(
      format: format,
      includeOrderHistory: includeOrderHistory,
      includeActivityLogs: includeActivityLogs,
      reason: reason,
    );

    final result = await _exportUserDataUseCase(params);

    result.fold(
          (failure) {
        debugPrint('Failed to export user data for roshdology123: ${failure.message}');
        emit(ProfileError(
          message: failure.message,
          code: failure.code.toString(),
          currentProfile: _currentProfile,
        ));
      },
          (downloadUrl) {
        debugPrint('✅ User data exported successfully for roshdology123');
        final fileName = 'roshdology123_data_2025-06-22.${format.name}';
        emit(ProfileDataExported(
          downloadUrl: downloadUrl,
          fileName: fileName,
        ));
      },
    );
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    debugPrint('Refreshing profile data for roshdology123 at 2025-06-22 09:45:42...');
    await loadProfile();
  }

  /// Clear any error states and return to loaded state
  void clearError() {
    if (_currentProfile != null) {
      emit(ProfileLoaded(profile: _currentProfile!));
    } else {
      emit(const ProfileInitial());
    }
  }

  /// Check if profile is complete
  bool get isProfileComplete => _currentProfile?.hasCompleteProfile ?? false;

  /// Get profile completion percentage
  double get profileCompletionPercentage => _currentProfile?.profileCompletionPercentage ?? 0.0;

  @override
  Future<void> close() {
    debugPrint('ProfileCubit disposed for roshdology123 at 2025-06-22 09:45:42');
    return super.close();
  }
}