import 'package:equatable/equatable.dart';

/// Base failure class for all failures in the app
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic data;

  const Failure({
    required this.message,
    this.code,
    this.data,
  });

  @override
  List<Object?> get props => [message, code, data];

  @override
  String toString() {
    return 'Failure: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'No internet connection. Please check your connection and try again.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Request timeout. Please try again.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkFailure.badRequest() {
    return const NetworkFailure(
      message: 'Bad request. Please check your input.',
      code: 'BAD_REQUEST',
    );
  }

  factory NetworkFailure.serverError() {
    return const NetworkFailure(
      message: 'Server error. Please try again later.',
      code: 'SERVER_ERROR',
    );
  }

  factory NetworkFailure.unauthorized() {
    return const NetworkFailure(
      message: 'Unauthorized access. Please login again.',
      code: 'UNAUTHORIZED',
    );
  }

  factory NetworkFailure.notFound() {
    return const NetworkFailure(
      message: 'The requested resource was not found.',
      code: 'NOT_FOUND',
    );
  }

  factory NetworkFailure.forbidden() {
    return const NetworkFailure(
      message: 'Access forbidden. You don\'t have permission to perform this action.',
      code: 'FORBIDDEN',
    );
  }
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Invalid email or password. Please try again.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthFailure.userNotFound() {
    return const AuthFailure(
      message: 'User not found. Please check your credentials.',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthFailure.emailAlreadyExists() {
    return const AuthFailure(
      message: 'This email is already registered. Please use a different email.',
      code: 'EMAIL_EXISTS',
    );
  }

  factory AuthFailure.tokenExpired() {
    return const AuthFailure(
      message: 'Your session has expired. Please login again.',
      code: 'TOKEN_EXPIRED',
    );
  }

  factory AuthFailure.unauthorized() {
    return const AuthFailure(
      message: 'You are not authorized to perform this action.',
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthFailure.accountDisabled() {
    return const AuthFailure(
      message: 'Your account has been disabled. Please contact support.',
      code: 'ACCOUNT_DISABLED',
    );
  }

  factory AuthFailure.emailNotVerified() {
    return const AuthFailure(
      message: 'Please verify your email address to continue.',
      code: 'EMAIL_NOT_VERIFIED',
    );
  }
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory CacheFailure.notFound() {
    return const CacheFailure(
      message: 'Requested data not found in cache.',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheFailure.expired() {
    return const CacheFailure(
      message: 'Cached data has expired.',
      code: 'CACHE_EXPIRED',
    );
  }

  factory CacheFailure.writeError() {
    return const CacheFailure(
      message: 'Failed to save data to cache.',
      code: 'CACHE_WRITE_ERROR',
    );
  }

  factory CacheFailure.readError() {
    return const CacheFailure(
      message: 'Failed to read data from cache.',
      code: 'CACHE_READ_ERROR',
    );
  }
}

/// Validation-related failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    this.fieldErrors,
  }) : super(data: fieldErrors);

  factory ValidationFailure.invalidEmail() {
    return const ValidationFailure(
      message: 'Please enter a valid email address.',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationFailure.weakPassword() {
    return const ValidationFailure(
      message: 'Password must be at least 6 characters long and contain uppercase, lowercase, and numbers.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory ValidationFailure.passwordMismatch() {
    return const ValidationFailure(
      message: 'Passwords do not match.',
      code: 'PASSWORD_MISMATCH',
    );
  }

  factory ValidationFailure.fieldRequired(String fieldName) {
    return ValidationFailure(
      message: '$fieldName is required.',
      code: 'FIELD_REQUIRED',
      fieldErrors: {fieldName.toLowerCase(): 'This field is required'},
    );
  }

  factory ValidationFailure.multipleFields(Map<String, String> errors) {
    return ValidationFailure(
      message: 'Please fix the errors below.',
      code: 'MULTIPLE_VALIDATION_ERRORS',
      fieldErrors: errors,
    );
  }

  factory ValidationFailure.invalidFormat(String fieldName) {
    return ValidationFailure(
      message: 'Invalid $fieldName format.',
      code: 'INVALID_FORMAT',
      fieldErrors: {fieldName.toLowerCase(): 'Invalid format'},
    );
  }
}

/// Storage-related failures
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory StorageFailure.readError() {
    return const StorageFailure(
      message: 'Failed to read data from storage.',
      code: 'STORAGE_READ_ERROR',
    );
  }

  factory StorageFailure.writeError() {
    return const StorageFailure(
      message: 'Failed to save data to storage.',
      code: 'STORAGE_WRITE_ERROR',
    );
  }

  factory StorageFailure.notFound() {
    return const StorageFailure(
      message: 'Requested data not found in storage.',
      code: 'STORAGE_NOT_FOUND',
    );
  }

  factory StorageFailure.permissionDenied() {
    return const StorageFailure(
      message: 'Storage permission denied. Please grant storage permissions.',
      code: 'STORAGE_PERMISSION_DENIED',
    );
  }

  factory StorageFailure.insufficientSpace() {
    return const StorageFailure(
      message: 'Insufficient storage space.',
      code: 'INSUFFICIENT_SPACE',
    );
  }
}

/// Business logic failures
class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory BusinessFailure.insufficientStock() {
    return const BusinessFailure(
      message: 'Sorry, this item is out of stock.',
      code: 'INSUFFICIENT_STOCK',
    );
  }

  factory BusinessFailure.invalidQuantity() {
    return const BusinessFailure(
      message: 'Please enter a valid quantity.',
      code: 'INVALID_QUANTITY',
    );
  }

  factory BusinessFailure.productNotAvailable() {
    return const BusinessFailure(
      message: 'This product is currently not available.',
      code: 'PRODUCT_NOT_AVAILABLE',
    );
  }

  factory BusinessFailure.cartEmpty() {
    return const BusinessFailure(
      message: 'Your cart is empty. Add some items to continue.',
      code: 'CART_EMPTY',
    );
  }

  factory BusinessFailure.priceChanged() {
    return const BusinessFailure(
      message: 'Product price has changed. Please review your cart.',
      code: 'PRICE_CHANGED',
    );
  }

  factory BusinessFailure.minimumOrderNotMet() {
    return const BusinessFailure(
      message: 'Minimum order amount not met.',
      code: 'MINIMUM_ORDER_NOT_MET',
    );
  }
}

/// Platform-specific failures
class PlatformFailure extends Failure {
  const PlatformFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory PlatformFailure.biometricsNotAvailable() {
    return const PlatformFailure(
      message: 'Biometric authentication is not available on this device.',
      code: 'BIOMETRICS_NOT_AVAILABLE',
    );
  }

  factory PlatformFailure.biometricsNotEnrolled() {
    return const PlatformFailure(
      message: 'No biometric credentials are enrolled. Please set up biometrics in your device settings.',
      code: 'BIOMETRICS_NOT_ENROLLED',
    );
  }

  factory PlatformFailure.cameraNotAvailable() {
    return const PlatformFailure(
      message: 'Camera is not available.',
      code: 'CAMERA_NOT_AVAILABLE',
    );
  }

  factory PlatformFailure.locationNotAvailable() {
    return const PlatformFailure(
      message: 'Location services are not available.',
      code: 'LOCATION_NOT_AVAILABLE',
    );
  }

  factory PlatformFailure.permissionDenied() {
    return const PlatformFailure(
      message: 'Permission denied. Please grant the required permissions.',
      code: 'PERMISSION_DENIED',
    );
  }
}

/// Generic server failure
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.data,
  });

  factory ServerFailure.general() {
    return const ServerFailure(
      message: 'Something went wrong. Please try again later.',
      code: 'SERVER_ERROR',
    );
  }

  factory ServerFailure.maintenance() {
    return const ServerFailure(
      message: 'Server is under maintenance. Please try again later.',
      code: 'SERVER_MAINTENANCE',
    );
  }
}

/// Unknown/Unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNKNOWN_ERROR',
    super.data,
  });
}