/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic data;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.data,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.data,
    super.stackTrace,
  });

  factory NetworkException.noConnection() {
    return const NetworkException(
      message: 'No internet connection available',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Request timeout',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverError(int statusCode, [String? message]) {
    return NetworkException(
      message: message ?? 'Server error occurred',
      code: 'SERVER_ERROR_$statusCode',
      data: statusCode,
    );
  }
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.data,
    super.stackTrace,
  });

  factory AuthException.invalidCredentials() {
    return const AuthException(
      message: 'Invalid email or password',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.userNotFound() {
    return const AuthException(
      message: 'User not found',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.emailAlreadyExists() {
    return const AuthException(
      message: 'Email already exists',
      code: 'EMAIL_EXISTS',
    );
  }

  factory AuthException.tokenExpired() {
    return const AuthException(
      message: 'Authentication token expired',
      code: 'TOKEN_EXPIRED',
    );
  }

  factory AuthException.unauthorized() {
    return const AuthException(
      message: 'Unauthorized access',
      code: 'UNAUTHORIZED',
    );
  }
}

/// API-related exceptions
class ApiException extends AppException {
  final int? statusCode;
  final Map<String, dynamic>? responseData;

  const ApiException({
    required super.message,
    super.code,
    this.statusCode,
    this.responseData,
    super.stackTrace,
  }) : super(data: responseData);

  factory ApiException.badRequest([String? message]) {
    return ApiException(
      message: message ?? 'Bad request',
      code: 'BAD_REQUEST',
      statusCode: 400,
    );
  }

  factory ApiException.unauthorized([String? message]) {
    return ApiException(
      message: message ?? 'Unauthorized',
      code: 'UNAUTHORIZED',
      statusCode: 401,
    );
  }

  factory ApiException.forbidden([String? message]) {
    return ApiException(
      message: message ?? 'Forbidden',
      code: 'FORBIDDEN',
      statusCode: 403,
    );
  }

  factory ApiException.notFound([String? message]) {
    return ApiException(
      message: message ?? 'Resource not found',
      code: 'NOT_FOUND',
      statusCode: 404,
    );
  }

  factory ApiException.internalServerError([String? message]) {
    return ApiException(
      message: message ?? 'Internal server error',
      code: 'INTERNAL_SERVER_ERROR',
      statusCode: 500,
    );
  }
  static String extractErrorMessage(dynamic responseData, [String defaultMessage = 'An error occurred']) {
    if (responseData == null) return defaultMessage;

    if (responseData is String) {
      return responseData.isNotEmpty ? responseData : defaultMessage;
    }

    if (responseData is Map<String, dynamic>) {
      // Try different common error message fields
      final message = responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          responseData['msg'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return defaultMessage;
  }

  factory ApiException.fromResponse(int statusCode, dynamic data) {
    String message = extractErrorMessage(data, 'API Error');
    String code = 'API_ERROR';

    switch (statusCode) {
      case 400:
        return ApiException.badRequest(message);
      case 401:
        return ApiException.unauthorized(message);
      case 403:
        return ApiException.forbidden(message);
      case 404:
        return ApiException.notFound(message);
      case 500:
        return ApiException.internalServerError(message);
      default:
        return ApiException(
          message: message,
          code: code,
          statusCode: statusCode,
          responseData: data is Map<String, dynamic> ? data : null,
        );
    }
  }
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.data,
    super.stackTrace,
  });

  factory CacheException.notFound() {
    return const CacheException(
      message: 'Data not found in cache',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheException.expired() {
    return const CacheException(
      message: 'Cached data has expired',
      code: 'CACHE_EXPIRED',
    );
  }

  factory CacheException.writeError() {
    return const CacheException(
      message: 'Failed to write to cache',
      code: 'CACHE_WRITE_ERROR',
    );
  }

  factory CacheException.readError() {
    return const CacheException(
      message: 'Failed to read from cache',
      code: 'CACHE_READ_ERROR',
    );
  }
}

/// Validation-related exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.stackTrace,
  }) : super(data: fieldErrors);

  factory ValidationException.invalidEmail() {
    return const ValidationException(
      message: 'Invalid email format',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationException.weakPassword() {
    return const ValidationException(
      message: 'Password is too weak',
      code: 'WEAK_PASSWORD',
    );
  }

  factory ValidationException.fieldRequired(String fieldName) {
    return ValidationException(
      message: '$fieldName is required',
      code: 'FIELD_REQUIRED',
      fieldErrors: {fieldName: 'This field is required'},
    );
  }

  factory ValidationException.multipleFields(Map<String, String> errors) {
    return ValidationException(
      message: 'Multiple validation errors',
      code: 'MULTIPLE_VALIDATION_ERRORS',
      fieldErrors: errors,
    );
  }
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.data,
    super.stackTrace,
  });

  factory StorageException.readError() {
    return const StorageException(
      message: 'Failed to read from storage',
      code: 'STORAGE_READ_ERROR',
    );
  }

  factory StorageException.writeError() {
    return const StorageException(
      message: 'Failed to write to storage',
      code: 'STORAGE_WRITE_ERROR',
    );
  }

  factory StorageException.notFound() {
    return const StorageException(
      message: 'Data not found in storage',
      code: 'STORAGE_NOT_FOUND',
    );
  }

  factory StorageException.permissionDenied() {
    return const StorageException(
      message: 'Storage permission denied',
      code: 'STORAGE_PERMISSION_DENIED',
    );
  }
}

/// Business logic exceptions
class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.data,
    super.stackTrace,
  });

  factory BusinessException.insufficientStock() {
    return const BusinessException(
      message: 'Insufficient stock available',
      code: 'INSUFFICIENT_STOCK',
    );
  }

  factory BusinessException.invalidQuantity() {
    return const BusinessException(
      message: 'Invalid quantity specified',
      code: 'INVALID_QUANTITY',
    );
  }

  factory BusinessException.productNotAvailable() {
    return const BusinessException(
      message: 'Product is not available',
      code: 'PRODUCT_NOT_AVAILABLE',
    );
  }

  factory BusinessException.cartEmpty() {
    return const BusinessException(
      message: 'Cart is empty',
      code: 'CART_EMPTY',
    );
  }
}

/// Platform-specific exceptions
class PlatformException extends AppException {
  const PlatformException({
    required super.message,
    super.code,
    super.data,
    super.stackTrace,
  });

  factory PlatformException.biometricsNotAvailable() {
    return const PlatformException(
      message: 'Biometric authentication is not available',
      code: 'BIOMETRICS_NOT_AVAILABLE',
    );
  }

  factory PlatformException.cameraNotAvailable() {
    return const PlatformException(
      message: 'Camera is not available',
      code: 'CAMERA_NOT_AVAILABLE',
    );
  }

  factory PlatformException.locationNotAvailable() {
    return const PlatformException(
      message: 'Location services are not available',
      code: 'LOCATION_NOT_AVAILABLE',
    );
  }
}