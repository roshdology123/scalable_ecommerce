import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user profile information in the profile feature
///
/// This use case handles:
/// - Profile data validation and sanitization
/// - Updating profile information on the server
/// - Caching updated profile data locally
/// - Handling update conflicts and errors
///
/// The update process includes:
/// - Personal information (name, email, phone)
/// - Profile settings and preferences
/// - Bio and additional details
/// - Profile completion tracking
///
/// Usage:
/// ```dart
/// final params = UpdateProfileInfoParams(profile: updatedProfile);
/// final result = await updateProfileInfoUseCase(params);
/// result.fold(
///   (failure) => handleError(failure),
///   (profile) => displayUpdatedProfile(profile),
/// );
/// ```
@injectable
class UpdateProfileInfoUseCase extends UseCase<Profile, UpdateProfileInfoParams> {
  final ProfileRepository _repository;

  UpdateProfileInfoUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileInfoParams params) async {
    try {
      print('Updating profile for roshdology123: ${params.profile.fullName}...');
      print('Timestamp: 2025-06-22 09:45:42');

      // Validate profile data
      final validationResult = _validateProfile(params.profile);
      if (validationResult != null) {
        return Left(validationResult);
      }

      final result = await _repository.updateProfile(params.profile);

      return result.fold(
            (failure) {
          print('UpdateProfileInfoUseCase failed for roshdology123: ${failure.message}');
          return Left(failure);
        },
            (profile) {
          print('Profile updated successfully for roshdology123: ${profile.fullName}');
          print('Profile completion: ${profile.profileCompletionPercentage.toStringAsFixed(1)}%');
          print('Updated at: 2025-06-22 09:45:42');

          return Right(profile);
        },
      );
    } catch (e) {
      print('Unexpected error in UpdateProfileInfoUseCase for roshdology123: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while updating profile: ${e.toString()}',
        code: 'UPDATE_PROFILE_INFO_UNKNOWN_ERROR',
      ));
    }
  }

  /// Validates profile data before update
  ValidationFailure? _validateProfile(Profile profile) {
    // Check required fields
    if (profile.firstName.trim().isEmpty) {
      return ValidationFailure(
        message: 'First name is required',
        code: 'FIRST_NAME_REQUIRED',
      );
    }

    if (profile.lastName.trim().isEmpty) {
      return ValidationFailure(
        message: 'Last name is required',
        code: 'LAST_NAME_REQUIRED',
      );
    }

    if (profile.email.trim().isEmpty) {
      return ValidationFailure(
        message: 'Email is required',
        code: 'EMAIL_REQUIRED',
      );
    }

    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(profile.email)) {
      return ValidationFailure(
        message: 'Please enter a valid email address',
        code: 'INVALID_EMAIL_FORMAT',
      );
    }

    // Validate phone number if provided
    if (profile.phoneNumber != null && profile.phoneNumber!.isNotEmpty) {
      if (!RegExp(r'^[\+]?[0-9\s\-\(\)]{10,15}$').hasMatch(profile.phoneNumber!)) {
        return ValidationFailure(
          message: 'Please enter a valid phone number',
          code: 'INVALID_PHONE_FORMAT',
        );
      }
    }

    // Validate bio length
    if (profile.bio != null && profile.bio!.length > 500) {
      return ValidationFailure(
        message: 'Bio must be less than 500 characters',
        code: 'BIO_TOO_LONG',
      );
    }

    // Validate name lengths
    if (profile.firstName.length > 50) {
      return ValidationFailure(
        message: 'First name must be less than 50 characters',
        code: 'FIRST_NAME_TOO_LONG',
      );
    }

    if (profile.lastName.length > 50) {
      return ValidationFailure(
        message: 'Last name must be less than 50 characters',
        code: 'LAST_NAME_TOO_LONG',
      );
    }

    return null; // No validation errors
  }
}

class UpdateProfileInfoParams extends Equatable {
  final Profile profile;

  const UpdateProfileInfoParams({required this.profile});

  @override
  List<Object?> get props => [profile];

  @override
  String toString() => 'UpdateProfileInfoParams(profile: ${profile.fullName}, user: roshdology123)';
}