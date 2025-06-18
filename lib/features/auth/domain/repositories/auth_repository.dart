import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// Login with username and password
  Future<Either<Failure, User>> loginWithUsername({
    required String username,
    required String password,
    bool rememberMe = false,
  });

  /// Register new user
  Future<Either<Failure, User>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current user from local storage
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Refresh authentication tokens
  Future<Either<Failure, AuthTokens>> refreshTokens();

  /// Forgot password
  Future<Either<Failure, void>> forgotPassword(String email);

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
  });

  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail(String token);

  /// Resend email verification
  Future<Either<Failure, void>> resendEmailVerification();

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount(String password);

  /// Check if email exists
  Future<Either<Failure, bool>> checkEmailExists(String email);

  /// Check if username exists
  Future<Either<Failure, bool>> checkUsernameExists(String username);

  /// Get authentication tokens
  Future<Either<Failure, AuthTokens>> getAuthTokens();

  /// Save authentication tokens
  Future<Either<Failure, void>> saveAuthTokens(AuthTokens tokens);

  /// Clear authentication tokens
  Future<Either<Failure, void>> clearAuthTokens();

  /// Enable two-factor authentication
  Future<Either<Failure, String>> enableTwoFactor(); // Returns QR code URL

  /// Verify two-factor authentication
  Future<Either<Failure, void>> verifyTwoFactor(String code);

  /// Disable two-factor authentication
  Future<Either<Failure, void>> disableTwoFactor(String code);

  /// Login with biometrics
  Future<Either<Failure, User>> loginWithBiometrics();

  /// Enable biometric login
  Future<Either<Failure, void>> enableBiometrics();

  /// Disable biometric login
  Future<Either<Failure, void>> disableBiometrics();

  /// Check if biometrics are available
  Future<Either<Failure, bool>> isBiometricsAvailable();

  /// Social login (Google, Facebook, etc.)
  Future<Either<Failure, User>> socialLogin({
    required String provider,
    required String token,
  });
}