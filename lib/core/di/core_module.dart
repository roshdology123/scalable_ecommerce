import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../network/dio_client.dart';
import '../network/dio_logger_interceptor.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../utils/app_logger.dart';
import 'injection.dart';

@module
abstract class CoreModule {
  // External dependencies
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

  @singleton
  Connectivity get connectivity => Connectivity();

  // Core services
  @singleton
  AppLogger get logger => AppLogger();

  @LazySingleton(as: NetworkInfo)
  NetworkInfoImpl get networkInfo;

  // Storage services - using your actual implementations
  @singleton
  SecureStorage get secureStorage => SecureStorage();

  @preResolve
  @singleton
  Future<LocalStorage> get localStorage async {
    await LocalStorage.init();
    return LocalStorage();
  }

  @singleton
  Dio get dio {
    final dio = Dio();

    // Base options
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    dio.interceptors.addAll([
      // Custom logger interceptor
      DioLoggerInterceptor(),

      // Authentication interceptor
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add start time for duration calculation
          options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;

          // Add auth token if available
          try {
            final secureStorage = getIt<SecureStorage>();
            final token = await secureStorage.getAuthToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            AppLogger().w('Failed to get auth token: $e');
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            AppLogger().logAuth('token_validation', false, 'Token expired or invalid');

            try {
              final secureStorage = getIt<SecureStorage>();
              await secureStorage.clearAuthTokens();
            } catch (e) {
              AppLogger().e('Failed to clear invalid tokens: $e');
            }
          }
          handler.next(error);
        },
      ),
    ]);

    return dio;
  }

  @LazySingleton(as: DioClient)
  DioClient get dioClient;

}