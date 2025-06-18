import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
      this._remoteDataSource,
      this._localDataSource,
      this._networkInfo,
      );

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final user = await _remoteDataSource.login(
          email: email,
          password: password,
        );

        // Cache user and credentials
        await _localDataSource.cacheUser(user);
        await _localDataSource.setLoggedIn(true);

        if (rememberMe) {
          await _localDataSource.saveUserCredentials(email, password);
          await _localDataSource.setRememberMeEnabled(true);
        }

        return Right(user);
      } else {
        // Try offline login with cached credentials
        if (rememberMe) {
          final credentials = await _localDataSource.getUserCredentials();
          if (credentials['email'] == email &&
              credentials['password'] == password) {
            final cachedUser = await _localDataSource.getCachedUser();
            if (cachedUser != null) {
              return Right(cachedUser);
            }
          }
        }
        return Left(NetworkFailure.noConnection());
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithUsername({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final user = await _remoteDataSource.loginWithUsername(
          username: username,
          password: password,
        );

        await _localDataSource.cacheUser(user);
        await _localDataSource.setLoggedIn(true);

        if (rememberMe) {
          await _localDataSource.saveUserCredentials(username, password);
          await _localDataSource.setRememberMeEnabled(true);
        }

        return Right(user);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final user = await _remoteDataSource.register(
          email: email,
          username: username,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );

        await _localDataSource.cacheUser(user);
        await _localDataSource.setLoggedIn(true);

        return Right(user);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
        code: 'UNKNOWN_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.logout();
      }

      // Always clear local data
      await _localDataSource.clearAllAuthData();

      return const Right(null);
    } on NetworkException catch (e) {
      // Still clear local data even if network call fails
      await _localDataSource.clearAllAuthData();
      return const Right(null);
    } catch (e) {
      await _localDataSource.clearAllAuthData();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      return Left(CacheFailure.notFound());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get current user: ${e.toString()}',
        code: 'GET_USER_ERROR',
      ));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _localDataSource.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshTokens() async {
    try {
      if (await _networkInfo.isConnected) {
        final currentTokens = await _localDataSource.getAuthTokens();
        if (currentTokens?.refreshToken != null) {
          final newTokens = await _remoteDataSource.refreshTokens(
            currentTokens!.refreshToken!,
          );

          await _localDataSource.saveAuthTokens(newTokens);
          return Right(newTokens);
        }
        return Left(AuthFailure.tokenExpired());
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Token refresh failed: ${e.toString()}',
        code: 'TOKEN_REFRESH_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.forgotPassword(email);
        return const Right(null);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Forgot password failed: ${e.toString()}',
        code: 'FORGOT_PASSWORD_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.resetPassword(
          token: token,
          newPassword: newPassword,
        );
        return const Right(null);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Reset password failed: ${e.toString()}',
        code: 'RESET_PASSWORD_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        return const Right(null);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Change password failed: ${e.toString()}',
        code: 'CHANGE_PASSWORD_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        final updatedUser = await _remoteDataSource.updateProfile(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          avatar: avatar,
        );

        await _localDataSource.cacheUser(updatedUser);
        return Right(updatedUser);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Update profile failed: ${e.toString()}',
        code: 'UPDATE_PROFILE_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.verifyEmail(token);
        return const Right(null);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Email verification failed: ${e.toString()}',
        code: 'EMAIL_VERIFICATION_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resendEmailVerification() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.resendEmailVerification();
        return const Right(null);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Resend verification failed: ${e.toString()}',
        code: 'RESEND_VERIFICATION_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.deleteAccount(password);
        await _localDataSource.clearAllAuthData();
        return const Right(null);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Delete account failed: ${e.toString()}',
        code: 'DELETE_ACCOUNT_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailExists(String email) async {
    try {
      if (await _networkInfo.isConnected) {
        final exists = await _remoteDataSource.checkEmailExists(email);
        return Right(exists);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Check email failed: ${e.toString()}',
        code: 'CHECK_EMAIL_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameExists(String username) async {
    try {
      if (await _networkInfo.isConnected) {
        final exists = await _remoteDataSource.checkUsernameExists(username);
        return Right(exists);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Check username failed: ${e.toString()}',
        code: 'CHECK_USERNAME_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> getAuthTokens() async {
    try {
      final tokens = await _localDataSource.getAuthTokens();
      if (tokens != null) {
        return Right(tokens);
      }
      return Left(CacheFailure.notFound());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get auth tokens: ${e.toString()}',
        code: 'GET_TOKENS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveAuthTokens(AuthTokens tokens) async {
    try {
      final tokensModel = AuthTokensModel.fromAuthTokens(tokens);
      await _localDataSource.saveAuthTokens(tokensModel);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to save auth tokens: ${e.toString()}',
        code: 'SAVE_TOKENS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearAuthTokens() async {
    try {
      await _localDataSource.clearAuthTokens();
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to clear auth tokens: ${e.toString()}',
        code: 'CLEAR_TOKENS_ERROR',
      ));
    }
  }

  // Placeholder implementations for advanced features
  @override
  Future<Either<Failure, String>> enableTwoFactor() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return const Right('https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example');
  }

  @override
  Future<Either<Failure, void>> verifyTwoFactor(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> disableTwoFactor(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> loginWithBiometrics() async {
    try {
      final isEnabled = await _localDataSource.isBiometricsEnabled();
      if (!isEnabled) {
        return Left(PlatformFailure.biometricsNotAvailable());
      }

      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      return Left(CacheFailure.notFound());
    } catch (e) {
      return Left(PlatformFailure(
        message: 'Biometric login failed: ${e.toString()}',
        code: 'BIOMETRIC_LOGIN_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometrics() async {
    try {
      await _localDataSource.setBiometricsEnabled(true);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to enable biometrics: ${e.toString()}',
        code: 'ENABLE_BIOMETRICS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> disableBiometrics() async {
    try {
      await _localDataSource.setBiometricsEnabled(false);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(
        message: 'Failed to disable biometrics: ${e.toString()}',
        code: 'DISABLE_BIOMETRICS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isBiometricsAvailable() async {
    try {
      // Mock implementation - in real app, check device capabilities
      return const Right(true);
    } catch (e) {
      return Left(PlatformFailure(
        message: 'Failed to check biometrics availability: ${e.toString()}',
        code: 'CHECK_BIOMETRICS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, User>> socialLogin({
    required String provider,
    required String token,
  }) async {
    try {
      if (await _networkInfo.isConnected) {
        // Mock implementation for social login
        await Future.delayed(const Duration(seconds: 2));

        // Create mock user for social login
        final user = UserModel(
          id: DateTime.now().millisecondsSinceEpoch,
          email: '$provider@example.com',
          username: '${provider}_user',
          firstName: provider.capitalize(),
          lastName: 'User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        await _localDataSource.cacheUser(user);
        await _localDataSource.setLoggedIn(true);

        return Right(user);
      } else {
        return Left(NetworkFailure.noConnection());
      }
    } catch (e) {
      return Left(ServerFailure(
        message: 'Social login failed: ${e.toString()}',
        code: 'SOCIAL_LOGIN_ERROR',
      ));
    }
  }
}

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}