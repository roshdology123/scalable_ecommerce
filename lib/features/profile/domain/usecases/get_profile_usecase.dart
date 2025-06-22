import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Use case for retrieving the current user's profile information
///
/// This use case handles:
/// - Fetching profile from remote server when online
/// - Falling back to cached profile when offline
/// - Returning appropriate failures for different error scenarios
///
/// Usage:
/// ```dart
/// final result = await getProfileUseCase(NoParams());
/// result.fold(
///   (failure) => handleError(failure),
///   (profile) => displayProfile(profile),
/// );
/// ```
@injectable
class GetProfileUseCase extends UseCase<Profile, NoParams> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    try {
      final result = await _repository.getProfile();

      return result.fold(
            (failure) {
          // Log the failure for debugging
          debugPrint('GetProfileUseCase failed: ${failure.message}');
          return Left(failure);
        },
            (profile) {
          // Validate profile data before returning
          if (profile.id.isEmpty) {
            return const Left(ValidationFailure(
              message: 'Invalid profile data received',
              code: 'INVALID_PROFILE_DATA',
            ));
          }

          return Right(profile);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while getting profile: ${e.toString()}',
        code: 'GET_PROFILE_UNKNOWN_ERROR',
      ));
    }
  }
}