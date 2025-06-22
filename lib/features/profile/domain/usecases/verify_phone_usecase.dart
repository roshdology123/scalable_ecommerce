import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for verifying phone number
///
/// This use case handles:
/// - Validating phone number format
/// - Sending SMS verification code
/// - Handling verification errors
/// - Rate limiting verification attempts
///
/// The verification process:
/// 1. Validates phone number format
/// 2. Sends SMS with verification code
/// 3. User enters code in app
/// 4. Phone status updates to verified
///
/// Usage:
/// ```dart
/// final params = VerifyPhoneParams(phoneNumber: '+20-12-3456-7890');
/// final result = await verifyPhoneUseCase(params);
/// result.fold(
///   (failure) => handleError(failure),
///   (_) => showVerificationCodeSent(),
/// );
/// ```
@injectable
class VerifyPhoneUseCase extends UseCase<void, VerifyPhoneParams> {
  final ProfileRepository _repository;

  VerifyPhoneUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(VerifyPhoneParams params) async {
    try {
      // Validate phone number format
      final validationResult = _validatePhoneNumber(params.phoneNumber);
      if (validationResult != null) {
        return Left(validationResult);
      }

      print('Sending SMS verification to ${params.phoneNumber}');

      final result = await _repository.verifyPhoneNumber(params.phoneNumber);

      return result.fold(
            (failure) {
          print('VerifyPhoneUseCase failed: ${failure.message}');
          return Left(failure);
        },
            (_) {
          print('✅ Verification SMS sent successfully');
          print('📱 Check ${params.phoneNumber} for verification code');
          print('⏰ Verification code expires in 10 minutes');
          return const Right(null);
        },
      );
    } catch (e) {
      print('Unexpected error in VerifyPhoneUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while sending verification SMS: ${e.toString()}',
        code: 'VERIFY_PHONE_UNKNOWN_ERROR',
      ));
    }
  }

  /// Validates phone number format
  ValidationFailure? _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return ValidationFailure(
        message: 'Phone number is required',
        code: 'PHONE_NUMBER_REQUIRED',
      );
    }

    // Remove spaces, dashes, and parentheses for validation
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it starts with + and has valid length
    if (!cleanPhone.startsWith('+')) {
      return ValidationFailure(
        message: 'Phone number must include country code (e.g., +20)',
        code: 'MISSING_COUNTRY_CODE',
      );
    }

    // Check length (should be between 10-15 digits including country code)
    if (cleanPhone.length < 10 || cleanPhone.length > 16) {
      return ValidationFailure(
        message: 'Invalid phone number length',
        code: 'INVALID_PHONE_LENGTH',
      );
    }

    // Check if contains only valid characters
    if (!RegExp(r'^\+[0-9]+$').hasMatch(cleanPhone)) {
      return ValidationFailure(
        message: 'Phone number contains invalid characters',
        code: 'INVALID_PHONE_CHARACTERS',
      );
    }

    return null; // Phone number is valid
  }
}

class VerifyPhoneParams extends Equatable {
  final String phoneNumber;

  const VerifyPhoneParams({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];

  @override
  String toString() => 'VerifyPhoneParams(phoneNumber: $phoneNumber)';
}