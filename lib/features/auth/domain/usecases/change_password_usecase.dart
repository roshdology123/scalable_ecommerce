import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/extensions.dart';
import '../repositories/auth_repository.dart';

@injectable
class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    // Validate input
    if (params.currentPassword.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Current password is required',
        code: 'EMPTY_CURRENT_PASSWORD',
      ));
    }

    if (params.newPassword.isEmpty) {
      return const Left(ValidationFailure(
        message: 'New password is required',
        code: 'EMPTY_NEW_PASSWORD',
      ));
    }

    if (!params.newPassword.isStrongPassword) {
      return const Left(ValidationFailure(
        message: 'New password must be at least 6 characters with uppercase, lowercase, and numbers',
        code: 'WEAK_NEW_PASSWORD',
      ));
    }

    if (params.currentPassword == params.newPassword) {
      return const Left(ValidationFailure(
        message: 'New password must be different from current password',
        code: 'SAME_PASSWORD',
      ));
    }

    return await repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}