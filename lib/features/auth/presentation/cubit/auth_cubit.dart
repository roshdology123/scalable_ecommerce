import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthCubit(
      this._loginUseCase,
      this._registerUseCase,
      this._logoutUseCase,
      this._getCurrentUserUseCase,
      this._forgotPasswordUseCase,
      ) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());

    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold(
          (failure) => emit(const AuthState.unauthenticated()),
          (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> login({
    required String emailOrUsername,
    required String password,
    bool rememberMe = false,
  }) async {
    emit(const AuthState.loading());

    final result = await _loginUseCase(LoginParams(
      emailOrUsername: emailOrUsername,
      password: password,
      rememberMe: rememberMe,
    ));

    result.fold(
          (failure) => emit(AuthState.error(failure.message, failure.code)),
          (user) => emit(AuthState.authenticated(user)),
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
          (failure) => emit(AuthState.error(failure.message, failure.code)),
          (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());

    final result = await _logoutUseCase(const NoParams());
    result.fold(
          (failure) => emit(AuthState.error(failure.message, failure.code)),
          (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(const AuthState.loading());

    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));
    result.fold(
          (failure) => emit(AuthState.error(failure.message, failure.code)),
          (_) => emit(const AuthState.forgotPasswordSent()),
    );
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