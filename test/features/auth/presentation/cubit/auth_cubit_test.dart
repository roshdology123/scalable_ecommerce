import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:scalable_ecommerce/core/errors/failures.dart';
import 'package:scalable_ecommerce/core/storage/secure_storage.dart';
import 'package:scalable_ecommerce/features/auth/domain/entities/user.dart';
import 'package:scalable_ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/logout_usecase.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:scalable_ecommerce/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:scalable_ecommerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'auth_cubit_test.mocks.dart';

@GenerateMocks([
  LoginUseCase,
  RegisterUseCase,
  LogoutUseCase,
  GetCurrentUserUseCase,
  ForgotPasswordUseCase,
  ResetPasswordUseCase,
  UpdateProfileUseCase,
  AuthRepository,
  SecureStorage,
  GoogleSignInUseCase,
])
void main() {
  late AuthCubit cubit;
  late MockLoginUseCase loginUseCase;
  late MockRegisterUseCase registerUseCase;
  late MockLogoutUseCase logoutUseCase;
  late MockGetCurrentUserUseCase getCurrentUserUseCase;
  late MockForgotPasswordUseCase forgotPasswordUseCase;
  late MockResetPasswordUseCase resetPasswordUseCase;
  late MockUpdateProfileUseCase updateProfileUseCase;
  late MockAuthRepository authRepository;
  late MockSecureStorage mockStorage;
  late MockGoogleSignInUseCase googleSignInUseCase;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    registerUseCase = MockRegisterUseCase();
    logoutUseCase = MockLogoutUseCase();
    getCurrentUserUseCase = MockGetCurrentUserUseCase();
    forgotPasswordUseCase = MockForgotPasswordUseCase();
    resetPasswordUseCase = MockResetPasswordUseCase();
    updateProfileUseCase = MockUpdateProfileUseCase();
    authRepository = MockAuthRepository();
    mockStorage = MockSecureStorage();
    googleSignInUseCase = MockGoogleSignInUseCase();
    cubit = AuthCubit(
      loginUseCase,
      registerUseCase,
      logoutUseCase,
      getCurrentUserUseCase,
      forgotPasswordUseCase,
      resetPasswordUseCase,
      updateProfileUseCase,
      authRepository,
      googleSignInUseCase,
    );
  });

  final tUser = User(
    id: 1,
    email: 'test@example.com',
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    phone: '1234567890',
    avatar: null,
  );

  group('login', () {
    final tLoginParams = LoginParams(
      emailOrUsername: 'test',
      password: 'pass',
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, authenticated] when login succeeds',
      build: () {
        when(loginUseCase.call(any))
            .thenAnswer((_) async => Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.login(emailOrUsername: 'test', password: 'pass'),
      expect: () => [
        const AuthState.loading(),
        AuthState.authenticated(tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, error] when login fails',
      build: () {
        when(loginUseCase.call(any))
            .thenAnswer((_) async => Left(AuthFailure(message: 'fail', code: '401')));
        return cubit;
      },
      act: (cubit) => cubit.login(emailOrUsername: 'test', password: 'pass'),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('fail', '401'),
      ],
    );
  });

  group('register', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, authenticated] when register succeeds',
      build: () {
        when(registerUseCase.call(any))
            .thenAnswer((_) async => Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        username: 'testuser',
        password: 'pass',
        confirmPassword: 'pass',
        firstName: 'Test',
        lastName: 'User',
      ),
      expect: () => [
        const AuthState.loading(),
        AuthState.authenticated(tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, error] when register fails',
      build: () {
        when(registerUseCase.call(any))
            .thenAnswer((_) async => Left(AuthFailure(message: 'fail', code: '409')));
        return cubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        username: 'testuser',
        password: 'pass',
        confirmPassword: 'pass',
        firstName: 'Test',
        lastName: 'User',
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('fail', '409'),
      ],
    );
  });

group('logout', () {
  blocTest<AuthCubit, AuthState>(
    'emits [loading, unauthenticated] when logout succeeds',
    build: () {
      when(logoutUseCase.call(any))
          .thenAnswer((_) async => const Right(unit));
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      const AuthState.loading(),
      const AuthState.unauthenticated(),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [loading, error] when logout fails',
    build: () {
      when(logoutUseCase.call(any))
          .thenAnswer((_) async => Left(AuthFailure(message: 'fail', code: '500')));
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      const AuthState.loading(),
      const AuthState.error('fail', '500'),
    ],
  );
});
 group('forgotPassword', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, forgotPasswordSent] when forgot password succeeds',
      build: () {
        when(forgotPasswordUseCase.call(any))
            .thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.forgotPassword('test@example.com'),
      expect: () => [
        const AuthState.loading(),
        const AuthState.forgotPasswordSent(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, error] when forgot password fails',
      build: () {
        when(forgotPasswordUseCase.call(any))
            .thenAnswer((_) async => Left(AuthFailure(message: 'fail', code: '404')));
        return cubit;
      },
      act: (cubit) => cubit.forgotPassword('test@example.com'),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('fail', '404'),
      ],
    );
  });

  group('resetPassword', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, passwordResetSuccess] when reset password succeeds',
      build: () {
        when(resetPasswordUseCase.call(any))
            .thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.resetPassword(token: 'token', newPassword: 'newpass'),
      expect: () => [
        const AuthState.loading(),
        const AuthState.passwordResetSuccess(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, error] when reset password fails',
      build: () {
        when(resetPasswordUseCase.call(any))
            .thenAnswer((_) async => Left(AuthFailure(message: 'fail', code: '400')));
        return cubit;
      },
      act: (cubit) => cubit.resetPassword(token: 'token', newPassword: 'newpass'),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('fail', '400'),
      ],
    );
  });

  group('updateProfile', () {
    blocTest<AuthCubit, AuthState>(
      'emits [loading, authenticated] when update profile succeeds',
      build: () {
        when(updateProfileUseCase.call(any))
            .thenAnswer((_) async => Right(tUser));
        return cubit;
      },
      act: (cubit) => cubit.updateProfile(firstName: 'Test'),
      expect: () => [
        const AuthState.loading(),
        AuthState.authenticated(tUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, error] when update profile fails',
      build: () {
        when(updateProfileUseCase.call(any))
            .thenAnswer((_) async => Left(AuthFailure(message: 'fail', code: '422')));
        return cubit;
      },
      act: (cubit) => cubit.updateProfile(firstName: 'Test'),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('fail', '422'),
      ],
    );
  });
}