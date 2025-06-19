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
    // Validate input according to API requirements
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

    // Username validation (API requirement)
    if (params.username.isEmpty) {
      errors['username'] = 'Username is required';
    } else if (params.username.length < 3) {
      errors['username'] = 'Username must be at least 3 characters';
    } else if (params.username.length > 20) {
      errors['username'] = 'Username must not exceed 20 characters';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(params.username)) {
      errors['username'] = 'Username can only contain letters, numbers, and underscores';
    }

    // Password validation (API requirement)
    if (params.password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (params.password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    // Confirm password validation
    if (params.confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Please confirm your password';
    } else if (params.password != params.confirmPassword) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    // First name validation (API requirement for name.firstname)
    if (params.firstName.isEmpty) {
      errors['firstName'] = 'First name is required';
    } else if (params.firstName.length < 2) {
      errors['firstName'] = 'First name must be at least 2 characters';
    } else if (params.firstName.length > 50) {
      errors['firstName'] = 'First name must not exceed 50 characters';
    }

    // Last name validation (API requirement for name.lastname)
    if (params.lastName.isEmpty) {
      errors['lastName'] = 'Last name is required';
    } else if (params.lastName.length < 2) {
      errors['lastName'] = 'Last name must be at least 2 characters';
    } else if (params.lastName.length > 50) {
      errors['lastName'] = 'Last name must not exceed 50 characters';
    }

    // Phone validation (optional but must be valid if provided)
    if (params.phone != null && params.phone!.isNotEmpty) {
      if (!_isValidPhoneFormat(params.phone!)) {
        errors['phone'] = 'Please enter a valid phone number (e.g., 1-570-236-7033)';
      }
    }

    if (errors.isNotEmpty) {
      return ValidationFailure.multipleFields(errors);
    }

    return null;
  }

  bool _isValidPhoneFormat(String phone) {
    // API uses format like "1-570-236-7033"
    final phoneRegex = RegExp(r'^\d{1}-\d{3}-\d{3}-\d{4}$');
    return phoneRegex.hasMatch(phone) || phone.isValidPhone;
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

  @override
  String toString() {
    return 'RegisterParams(email: $email, username: $username, firstName: $firstName, lastName: $lastName, phone: $phone)';
  }
}