import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/extensions.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // Validate input
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(validationResult);
    }

    return await repository.register(
      email: params.email,
      username: params.username,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
    );
  }

  ValidationFailure? _validateParams(RegisterParams params) {
    final errors = <String, String>{};

    // Email validation
    if (params.email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!params.email.isValidEmail) {
      errors['email'] = 'Please enter a valid email address';
    }

    // Username validation
    if (params.username.isEmpty) {
      errors['username'] = 'Username is required';
    } else if (params.username.length < 3) {
      errors['username'] = 'Username must be at least 3 characters';
    } else if (params.username.length > 20) {
      errors['username'] = 'Username must not exceed 20 characters';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(params.username)) {
      errors['username'] = 'Username can only contain letters, numbers, and underscores';
    }

    // Password validation
    if (params.password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (!params.password.isStrongPassword) {
      errors['password'] = 'Password must be at least 6 characters with uppercase, lowercase, and numbers';
    }

    // Confirm password validation
    if (params.confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Please confirm your password';
    } else if (params.password != params.confirmPassword) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    // First name validation
    if (params.firstName.isEmpty) {
      errors['firstName'] = 'First name is required';
    } else if (params.firstName.length < 2) {
      errors['firstName'] = 'First name must be at least 2 characters';
    }

    // Last name validation
    if (params.lastName.isEmpty) {
      errors['lastName'] = 'Last name is required';
    } else if (params.lastName.length < 2) {
      errors['lastName'] = 'Last name must be at least 2 characters';
    }

    // Phone validation (optional)
    if (params.phone != null && params.phone!.isNotEmpty) {
      if (!params.phone!.isValidPhone) {
        errors['phone'] = 'Please enter a valid phone number';
      }
    }

    if (errors.isNotEmpty) {
      return ValidationFailure.multipleFields(errors);
    }

    return null;
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String? phone;

  const RegisterParams({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    this.phone,
  });

  @override
  List<Object?> get props => [
    email,
    username,
    password,
    confirmPassword,
    firstName,
    lastName,
    phone,
  ];
}