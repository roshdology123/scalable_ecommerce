import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/extensions.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    // Validate input
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(validationResult);
    }

    return await repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
      avatar: params.avatar,
    );
  }

  ValidationFailure? _validateParams(UpdateProfileParams params) {
    final errors = <String, String>{};

    // First name validation
    if (params.firstName != null) {
      if (params.firstName!.isEmpty) {
        errors['firstName'] = 'First name cannot be empty';
      } else if (params.firstName!.length < 2) {
        errors['firstName'] = 'First name must be at least 2 characters';
      }
    }

    // Last name validation
    if (params.lastName != null) {
      if (params.lastName!.isEmpty) {
        errors['lastName'] = 'Last name cannot be empty';
      } else if (params.lastName!.length < 2) {
        errors['lastName'] = 'Last name must be at least 2 characters';
      }
    }

    // Phone validation
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

class UpdateProfileParams extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatar;

  const UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.phone,
    this.avatar,
  });

  @override
  List<Object?> get props => [firstName, lastName, phone, avatar];
}