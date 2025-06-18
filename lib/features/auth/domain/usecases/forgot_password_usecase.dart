import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/extensions.dart';
import '../repositories/auth_repository.dart';

@injectable
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    // Validate email
    if (params.email.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Email is required',
        code: 'EMPTY_EMAIL',
      ));
    }

    if (!params.email.isValidEmail) {
      return const Left(ValidationFailure(
        message: 'Please enter a valid email address',
        code: 'INVALID_EMAIL',
      ));
    }

    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}