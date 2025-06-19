import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final AuthRepository _authRepository;

  AuthCubit(
      this._loginUseCase,
      this._registerUseCase,
      this._logoutUseCase,
      this._getCurrentUserUseCase,
      this._forgotPasswordUseCase,
      this._resetPasswordUseCase,
      this._updateProfileUseCase,
      this._authRepository,
      ) : super(const AuthState.initial()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());

    try {
      print('[AuthCubit] Checking auth status...');

      // First, check if user should be automatically logged in (Remember Me)
      final autoLoginResult = await _checkAutoLogin();

      await autoLoginResult.fold(
            (failure) async {
          print('[AuthCubit] Auto-login failed: ${failure.message}');
          // Auto login failed, check for existing session
          final result = await _getCurrentUserUseCase(const NoParams());
          result.fold(
                (failure) {
              print('[AuthCubit] No existing session: ${failure.message}');
              emit(const AuthState.unauthenticated());
            },
                (user) {
              print('[AuthCubit] Found existing session: ${user.email}');
              emit(AuthState.authenticated(user));
            },
          );
        },
            (user) async {
          if (user != null) {
            print('[AuthCubit] Auto-login successful: ${user.email}');
            emit(AuthState.authenticated(user));
          } else {
            print('[AuthCubit] No auto-login, checking existing session...');
            final result = await _getCurrentUserUseCase(const NoParams());
            result.fold(
                  (failure) {
                print('[AuthCubit] No existing session: ${failure.message}');
                emit(const AuthState.unauthenticated());
              },
                  (user) {
                print('[AuthCubit] Found existing session: ${user.email}');
                emit(AuthState.authenticated(user));
              },
            );
          }
        },
      );
    } catch (e) {
      print('[AuthCubit] Auth check error: $e');
      emit(const AuthState.unauthenticated());
    }
  }

  // Fixed auto-login check method
  Future<Either<Failure, User?>> _checkAutoLogin() async {
    try {
      print('[AuthCubit] Starting auto-login check...');

      // Check if remember me is enabled
      final isRememberMeEnabled = await _authRepository.isRememberMeEnabled();
      print('[AuthCubit] Remember me enabled: $isRememberMeEnabled');

      if (!isRememberMeEnabled) {
        print('[AuthCubit] Remember me not enabled');
        return const Right(null);
      }

      // Check if we have valid tokens
      final tokensResult = await _authRepository.getAuthTokens();
      final tokens = tokensResult.fold(
            (failure) {
          print('[AuthCubit] No tokens found: ${failure.message}');
          return null;
        },
            (tokens) {
          print('[AuthCubit] Tokens found, expires at: ${tokens.expiresAt}');
          return tokens;
        },
      );

      if (tokens != null && !tokens.isExpired) {
        print('[AuthCubit] Valid tokens found, trying to get cached user directly');

        // Try to get cached user directly from local storage
        final userResult = await _authRepository.getCachedUserDirectly();
        return userResult.fold(
              (failure) async {
            print('[AuthCubit] No cached user, trying credential login: ${failure.message}');
            // No cached user, try to login with saved credentials
            return await _tryCredentialLogin();
          },
              (user) {
            print('[AuthCubit] Found cached user: ${user.email}');
            // We have a cached user and valid tokens, mark as logged in
            _authRepository.setLoggedInStatus(true);
            return Right(user);
          },
        );
      }

      print('[AuthCubit] No valid tokens, trying credential login');
      // No valid tokens, try to login with saved credentials
      return await _tryCredentialLogin();
    } catch (e) {
      print('[AuthCubit] Auto-login error: $e');
      return Left(CacheFailure(
        message: 'Auto login failed: ${e.toString()}',
        code: 'AUTO_LOGIN_ERROR',
      ));
    }
  }

  Future<Either<Failure, User?>> _tryCredentialLogin() async {
    try {
      print('[AuthCubit] Attempting credential-based auto-login');

      final credentials = await _authRepository.getSavedCredentials();
      return credentials.fold(
            (failure) {
          print('[AuthCubit] No saved credentials: ${failure.message}');
          return const Right(null);
        },
            (creds) async {
          final email = creds['email'];
          final password = creds['password'];

          if (email != null && password != null) {
            print('[AuthCubit] Attempting auto-login with saved credentials for: $email');

            // Use the repository login directly to avoid recursion
            final loginResult = await _authRepository.login(
              email: email,
              password: password,
              rememberMe: true,
            );

            return loginResult.fold(
                  (failure) {
                print('[AuthCubit] Credential auto-login failed: ${failure.message}');
                return Left(failure);
              },
                  (user) {
                print('[AuthCubit] Credential auto-login successful: ${user.email}');
                return Right(user);
              },
            );
          }

          print('[AuthCubit] Incomplete saved credentials');
          return const Right(null);
        },
      );
    } catch (e) {
      print('[AuthCubit] Credential login error: $e');
      return Left(AuthFailure(
        message: 'Credential auto-login failed: ${e.toString()}',
        code: 'CREDENTIAL_LOGIN_ERROR',
      ));
    }
  }

  Future<void> login({
    required String emailOrUsername,
    required String password,
    bool rememberMe = false,
  }) async {
    print('[AuthCubit] Login attempt for: $emailOrUsername, Remember me: $rememberMe');
    emit(const AuthState.loading());

    final result = await _loginUseCase(LoginParams(
      emailOrUsername: emailOrUsername,
      password: password,
      rememberMe: rememberMe,
    ));

    result.fold(
          (failure) {
        print('[AuthCubit] Login failed: ${failure.message}');
        emit(AuthState.error(failure.message, failure.code));
      },
          (user) {
        print('[AuthCubit] Login successful: ${user.email}');
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    print('[AuthCubit] Registration attempt for: $email');
    emit(const AuthState.loading());

    final result = await _registerUseCase(RegisterParams(
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    ));

    result.fold(
          (failure) {
        print('[AuthCubit] Registration failed: ${failure.message}');
        emit(AuthState.error(failure.message, failure.code));
      },
          (user) {
        print('[AuthCubit] Registration successful: ${user.email}');
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> logout() async {
    print('[AuthCubit] Logout request');
    emit(const AuthState.loading());

    final result = await _logoutUseCase(const NoParams());
    result.fold(
          (failure) {
        print('[AuthCubit] Logout failed: ${failure.message}');
        emit(AuthState.error(failure.message, failure.code));
      },
          (_) {
        print('[AuthCubit] Logout successful');
        emit(const AuthState.unauthenticated());
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    print('[AuthCubit] Forgot password request for: $email');
    emit(const AuthState.loading());

    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));
    result.fold(
          (failure) {
        print('[AuthCubit] Forgot password failed: ${failure.message}');
        emit(AuthState.error(failure.message, failure.code));
      },
          (_) {
        print('[AuthCubit] Forgot password email sent');
        emit(const AuthState.forgotPasswordSent());
      },
    );
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    print('[AuthCubit] Reset password request');
    emit(const AuthState.loading());

    final result = await _resetPasswordUseCase(ResetPasswordParams(
      token: token,
      newPassword: newPassword,
    ));

    result.fold(
          (failure) {
        print('[AuthCubit] Reset password failed: ${failure.message}');
        emit(AuthState.error(failure.message, failure.code));
      },
          (_) {
        print('[AuthCubit] Password reset successful');
        emit(const AuthState.passwordResetSuccess());
      },
    );
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
  }) async {
    print('[AuthCubit] Update profile request');
    emit(const AuthState.loading());

    final result = await _updateProfileUseCase(UpdateProfileParams(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      avatar: avatar,
    ));

    result.fold(
          (failure) {
        print('[AuthCubit] Update profile failed: ${failure.message}');
        emit(AuthState.error(failure.message, failure.code));
      },
          (user) {
        print('[AuthCubit] Profile updated successfully');
        emit(AuthState.authenticated(user));
      },
    );
  }

  Future<void> refreshAuthStatus() async {
    await checkAuthStatus();
  }

  Future<bool> isRememberMeEnabled() async {
    try {
      return await _authRepository.isRememberMeEnabled();
    } catch (e) {
      return false;
    }
  }

  Future<void> clearRememberMe() async {
    try {
      await _authRepository.clearRememberMe();
    } catch (e) {
      print('[AuthCubit] Failed to clear remember me: $e');
    }
  }

  void clearError() {
    if (state is AuthError) {
      emit(const AuthState.unauthenticated());
    }
  }

  User? get currentUser {
    return state.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
  }

  bool get isAuthenticated {
    return state.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
  }

  bool get isLoading {
    return state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
  }
}