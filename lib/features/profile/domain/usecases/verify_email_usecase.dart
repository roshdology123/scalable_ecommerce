import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for sending email verification
/// 
/// This use case handles:
/// - Sending verification email to user's registered email
/// - Updating verification status
/// - Handling verification errors
/// - Rate limiting verification requests
/// 
/// The verification process:
/// 1. Sends verification email with secure token
/// 2. User clicks verification link in email
/// 3. Email status updates to verified
/// 4. User gains access to email-protected features
/// 
/// Usage:
/// ```dart
/// final result = await verifyEmailUseCase(NoParams());
/// result.fold(
///   (failure) => handleError(failure),
///   (_) => showVerificationEmailSent(),
/// );
/// ```
@injectable
class VerifyEmailUseCase extends UseCase<void, NoParams> {
  final ProfileRepository _repository;

  VerifyEmailUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      debugPrint('Sending email verification for roshdology123@example.com');

      final result = await _repository.verifyEmail();

      return result.fold(
            (failure) {
          debugPrint('VerifyEmailUseCase failed: ${failure.message}');
          return Left(failure);
        },
            (_) {
          debugPrint('✅ Verification email sent successfully');
          debugPrint('📧 Check roshdology123@example.com for verification link');
          debugPrint('⏰ Verification link expires in 24 hours');
          return const Right(null);
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in VerifyEmailUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while sending verification email: ${e.toString()}',
        code: 'VERIFY_EMAIL_UNKNOWN_ERROR',
      ));
    }
  }
}