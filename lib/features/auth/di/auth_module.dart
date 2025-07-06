import 'package:injectable/injectable.dart';

import '../../../core/network/network_info.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/google_auth_data_source.dart';
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

@module
abstract class AuthModule {

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl authRepository(
      AuthRemoteDataSource remoteDataSource,
      AuthLocalDataSource localDataSource,
      NetworkInfo networkInfo,
      GoogleAuthDataSource googleAuthDataSource,
      ) =>
      AuthRepositoryImpl(remoteDataSource, localDataSource, networkInfo,
          googleAuthDataSource);

  @LazySingleton()
  LoginUseCase loginUseCase(AuthRepository repository) =>
      LoginUseCase(repository);

  @LazySingleton()
  RegisterUseCase registerUseCase(AuthRepository repository) =>
      RegisterUseCase(repository);

  @LazySingleton()
  LogoutUseCase logoutUseCase(AuthRepository repository) =>
      LogoutUseCase(repository);

  @LazySingleton()
  GetCurrentUserUseCase getCurrentUserUseCase(AuthRepository repository) =>
      GetCurrentUserUseCase(repository);

  @LazySingleton()
  ForgotPasswordUseCase forgotPasswordUseCase(AuthRepository repository) =>
      ForgotPasswordUseCase(repository);

  @LazySingleton()
  ResetPasswordUseCase resetPasswordUseCase(AuthRepository repository) =>
      ResetPasswordUseCase(repository);

  @LazySingleton()
  ChangePasswordUseCase changePasswordUseCase(AuthRepository repository) =>
      ChangePasswordUseCase(repository);

  @LazySingleton()
  UpdateProfileUseCase updateProfileUseCase(AuthRepository repository) =>
      UpdateProfileUseCase(repository);
}