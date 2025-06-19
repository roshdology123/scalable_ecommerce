import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validate input
    if (params.emailOrUsername.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Email or username is required',
        code: 'EMPTY_EMAIL_USERNAME',
      ));
    }

    if (params.password.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Password is required',
        code: 'EMPTY_PASSWORD',
      ));
    }

    if (params.password.length < 6) {
      return const Left(ValidationFailure(
        message: 'Password must be at least 6 characters',
        code: 'PASSWORD_TOO_SHORT',
      ));
    }

    // For Fake Store API, we always use loginWithUsername since it only accepts username
    // The API doesn't support email login, only username
    return await repository.loginWithUsername(
      username: params.emailOrUsername,
      password: params.password,
      rememberMe: params.rememberMe,
    );
  }
}

class LoginParams extends Equatable {
  final String emailOrUsername;
  final String password;
  final bool rememberMe;

  const LoginParams({
    required this.emailOrUsername,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [emailOrUsername, password, rememberMe];
}