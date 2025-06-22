import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for permanently deleting user account
/// 
/// This use case handles:
/// - Validating deletion request with confirmation
/// - Permanently removing user data from server
/// - Clearing all local cached data
/// - Ensuring GDPR compliance for data deletion
/// 
/// ⚠️ WARNING: This action is irreversible!
/// 
/// The deletion process removes:
/// - User profile and personal information
/// - Order history and transaction data
/// - Preferences and settings
/// - Reviews and ratings
/// - Wishlist and favorites
/// - All cached local data
/// 
/// Usage:
/// ```dart
/// final params = DeleteAccountParams(
///   confirmationText: 'DELETE MY ACCOUNT',
///   currentPassword: userPassword,
/// );
/// final result = await deleteAccountUseCase(params);
/// result.fold(
///   (failure) => handleError(failure),
///   (_) => navigateToWelcomeScreen(),
/// );
/// ```
@injectable
class DeleteAccountUseCase extends UseCase<void, DeleteAccountParams> {
  final ProfileRepository _repository;

  DeleteAccountUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    try {
      // Validate deletion request
      final validationResult = _validateDeletionRequest(params);
      if (validationResult != null) {
        return Left(validationResult);
      }

      debugPrint('Processing account deletion request for roshdology123');
      debugPrint('⚠️ WARNING: This action is irreversible!');

      final result = await _repository.deleteAccount();

      return result.fold(
            (failure) {
          debugPrint('DeleteAccountUseCase failed: ${failure.message}');
          return Left(failure);
        },
            (_) {
          debugPrint('✅ Account deletion completed successfully');
          debugPrint('All user data has been permanently removed');
          return const Right(null);
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in DeleteAccountUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while deleting account: ${e.toString()}',
        code: 'DELETE_ACCOUNT_UNKNOWN_ERROR',
      ));
    }
  }

  /// Validates account deletion request
  ValidationFailure? _validateDeletionRequest(DeleteAccountParams params) {
    // Check confirmation text
    if (params.confirmationText != 'DELETE MY ACCOUNT') {
      return const ValidationFailure(
        message: 'Invalid confirmation text. Please type "DELETE MY ACCOUNT" exactly.',
        code: 'INVALID_CONFIRMATION_TEXT',
      );
    }

    // Check password (if provided)
    if (params.currentPassword != null && params.currentPassword!.length < 6) {
      return const ValidationFailure(
        message: 'Password is required for account deletion',
        code: 'PASSWORD_REQUIRED',
      );
    }

    // Check reason (optional but logged for analytics)
    if (params.reason != null && params.reason!.isNotEmpty) {
      debugPrint('Account deletion reason: ${params.reason}');
    }

    return null; // No validation errors
  }
}

class DeleteAccountParams extends Equatable {
  final String confirmationText;
  final String? currentPassword;
  final String? reason;
  final bool understandsConsequences;

  const DeleteAccountParams({
    required this.confirmationText,
    this.currentPassword,
    this.reason,
    this.understandsConsequences = false,
  });

  @override
  List<Object?> get props => [
    confirmationText,
    currentPassword,
    reason,
    understandsConsequences,
  ];

  @override
  String toString() => 'DeleteAccountParams(confirmed: ${confirmationText == "DELETE MY ACCOUNT"})';
}