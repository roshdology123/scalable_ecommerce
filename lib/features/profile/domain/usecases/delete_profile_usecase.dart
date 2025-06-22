import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for deleting user profile image
/// 
/// This use case handles:
/// - Removing profile image from server storage
/// - Reverting to default avatar
/// - Updating profile cache
/// - Handling deletion errors gracefully
/// 
/// After deletion, the user's profile will show:
/// - Default avatar based on initials
/// - No custom profile image
/// - Updated profile timestamp
/// 
/// Usage:
/// ```dart
/// final result = await deleteProfileImageUseCase(NoParams());
/// result.fold(
///   (failure) => handleError(failure),
///   (_) => showDefaultAvatar(),
/// );
/// ```
@injectable
class DeleteProfileImageUseCase extends UseCase<void, NoParams> {
  final ProfileRepository _repository;

  DeleteProfileImageUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      debugPrint('Deleting profile image for roshdology123');

      final result = await _repository.deleteProfileImage();

      return result.fold(
            (failure) {
          debugPrint('DeleteProfileImageUseCase failed: ${failure.message}');
          return Left(failure);
        },
            (_) {
          debugPrint('✅ Profile image deleted successfully');
          debugPrint('Profile will now show default avatar');
          return const Right(null);
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in DeleteProfileImageUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while deleting profile image: ${e.toString()}',
        code: 'DELETE_IMAGE_UNKNOWN_ERROR',
      ));
    }
  }
}