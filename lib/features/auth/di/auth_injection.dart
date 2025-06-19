import 'package:get_it/get_it.dart';
import 'package:scalable_ecommerce/core/storage/secure_storage.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/app_logger.dart';

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

class AuthInjection {
  static Future<void> init() async {
    final GetIt getIt = GetIt.instance;
    final logger = AppLogger();

    logger.logBusinessLogic(
      'auth_injection_started',
      'di_setup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:46:21',
      },
    );

    try {
      // Data Sources
      getIt.registerLazySingleton<AuthRemoteDataSource>(
            () => AuthRemoteDataSourceImpl(
          getIt<DioClient>(),
        ),
      );

      getIt.registerLazySingleton<AuthLocalDataSource>(
            () => AuthLocalDataSourceImpl(
          getIt<SecureStorage>(),
        ),
      );

      // Repository
      getIt.registerLazySingleton<AuthRepository>(
            () => AuthRepositoryImpl(
          getIt<AuthRemoteDataSource>(),
          getIt<AuthLocalDataSource>(),
          getIt<NetworkInfo>(),
        ),
      );

      // Use Cases
      getIt.registerLazySingleton<LoginUseCase>(
            () => LoginUseCase(getIt<AuthRepository>()),
      );

      getIt.registerLazySingleton<RegisterUseCase>(
            () => RegisterUseCase(getIt<AuthRepository>()),
      );

      getIt.registerLazySingleton<LogoutUseCase>(
            () => LogoutUseCase(getIt<AuthRepository>()),
      );

      getIt.registerLazySingleton<GetCurrentUserUseCase>(
            () => GetCurrentUserUseCase(getIt<AuthRepository>()),
      );

      getIt.registerLazySingleton<ForgotPasswordUseCase>(
            () => ForgotPasswordUseCase(getIt<AuthRepository>()),
      );

      getIt.registerLazySingleton<ResetPasswordUseCase>(
            () => ResetPasswordUseCase(getIt<AuthRepository>()),
      );

      getIt.registerLazySingleton<ChangePasswordUseCase>(
            () => ChangePasswordUseCase(getIt<AuthRepository>()),
      );



      getIt.registerLazySingleton<UpdateProfileUseCase>(
            () => UpdateProfileUseCase(getIt<AuthRepository>()),
      );

      // Cubit - Register as factory to avoid singleton issues
      getIt.registerFactory<AuthCubit>(
            () => AuthCubit(
          getIt<LoginUseCase>(),
          getIt<RegisterUseCase>(),
          getIt<LogoutUseCase>(),
          getIt<GetCurrentUserUseCase>(),
          getIt<ForgotPasswordUseCase>(),
          getIt<ResetPasswordUseCase>(),
              getIt<UpdateProfileUseCase>(),
                getIt<AuthRepository>()
        ),
      );

      logger.logBusinessLogic(
        'auth_injection_completed',
        'di_setup',
        {
          'data_sources_registered': 2,
          'use_cases_registered': 11,
          'cubit_registered': true,
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:46:21',
        },
      );

    } catch (e, stackTrace) {
      logger.logErrorWithContext(
        'AuthInjection.init',
        e,
        stackTrace,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-18 14:46:21',
        },
      );
      rethrow;
    }
  }
}