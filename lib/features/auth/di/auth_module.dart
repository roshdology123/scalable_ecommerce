import 'package:injectable/injectable.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/network_info.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/change_password_usecase.dart';
import '../domain/usecases/forgot_password_usecase.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/reset_password_usecase.dart';
import '../domain/usecases/update_profile_usecase.dart';
import '../presentation/cubit/auth_cubit.dart';

@module
abstract class AuthModule {
  // Data Sources
  @LazySingleton(as: AuthRemoteDataSource)
  AuthRemoteDataSourceImpl authRemoteDataSource(DioClient dioClient) =>
      AuthRemoteDataSourceImpl(dioClient);

  @LazySingleton(as: AuthLocalDataSource)
  AuthLocalDataSourceImpl authLocalDataSource(SecureStorage secureStorage) =>
      AuthLocalDataSourceImpl(secureStorage);

  // Repository
  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl authRepository(
      AuthRemoteDataSource remoteDataSource,
      AuthLocalDataSource localDataSource,
      NetworkInfo networkInfo,
      ) => AuthRepositoryImpl(remoteDataSource, localDataSource, networkInfo);

  // Use Cases
  @injectable
  LoginUseCase loginUseCase(AuthRepository repository) => LoginUseCase(repository);

  @injectable
  RegisterUseCase registerUseCase(AuthRepository repository) => RegisterUseCase(repository);

  @injectable
  LogoutUseCase logoutUseCase(AuthRepository repository) => LogoutUseCase(repository);

  @injectable
  GetCurrentUserUseCase getCurrentUserUseCase(AuthRepository repository) =>
      GetCurrentUserUseCase(repository);

  @injectable
  ForgotPasswordUseCase forgotPasswordUseCase(AuthRepository repository) =>
      ForgotPasswordUseCase(repository);

  @injectable
  ChangePasswordUseCase changePasswordUseCase(AuthRepository repository) =>
      ChangePasswordUseCase(repository);

  @injectable
  ResetPasswordUseCase resetPasswordUseCase(AuthRepository repository) =>
      ResetPasswordUseCase(repository);

  @injectable
  UpdateProfileUseCase updateProfileUseCase(AuthRepository repository) =>
      UpdateProfileUseCase(repository);

  // Cubit
  @injectable
  AuthCubit authCubit(
      LoginUseCase loginUseCase,
      RegisterUseCase registerUseCase,
      LogoutUseCase logoutUseCase,
      GetCurrentUserUseCase getCurrentUserUseCase,
      ForgotPasswordUseCase forgotPasswordUseCase,
      ) => AuthCubit(
    loginUseCase,
    registerUseCase,
    logoutUseCase,
    getCurrentUserUseCase,
    forgotPasswordUseCase,
  );
}