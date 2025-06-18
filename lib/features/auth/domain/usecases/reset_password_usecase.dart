import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/extensions.dart';
import '../repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    // Validate input
    if (params.token.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Reset token is required',
        code: 'EMPTY_TOKEN',
      ));
    }

    if (params.newPassword.isEmpty) {
      return const Left(ValidationFailure(
        message: 'New password is required',
        code: 'EMPTY_PASSWORD',
      ));
    }

    if (!params.newPassword.isStrongPassword) {
      return const Left(ValidationFailure(
        message: 'Password must be at least 6 characters with uppercase, lowercase, and numbers',
        code: 'WEAK_PASSWORD',
      ));
    }

    return await repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}