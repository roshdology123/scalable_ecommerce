import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/storage_service.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../utils/app_logger.dart';

// Import feature modules
// import '../../features/auth/di/auth_injection.dart';
// import '../../features/categories/di/categories_injection.dart';
// import '../../features/products/di/products_injection.dart';
// import '../../features/cart/di/cart_injection.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final logger = AppLogger();

  logger.logBusinessLogic(
    'dependency_injection_started',
    'system_init',
    {
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:39:50',
    },
  );

  try {
    // Initialize storage systems first
    await StorageService.initializeAll();

    // Register core dependencies
    await _registerCoreDependencies();

    // Register feature dependencies in the correct order
    await _registerFeatureDependencies();

    logger.logBusinessLogic(
      'dependency_injection_completed',
      'system_init',
      {
        'registered_services': getIt.allReadySync().toString(),
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:39:50',
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      'DependencyInjection.configure',
      e,
      stackTrace,
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:39:50',
      },
    );
    rethrow;
  }
}

Future<void> _registerCoreDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<Connectivity>(Connectivity());

  // Storage services
  getIt.registerSingleton<LocalStorage>(LocalStorage());
  getIt.registerSingleton<SecureStorage>(SecureStorage());

  // Core services
  getIt.registerSingleton<AppLogger>(AppLogger());

  getIt.registerSingleton<StorageService>(
    StorageService(
      getIt<SharedPreferences>(),
      getIt<SecureStorage>(),
      getIt<LocalStorage>(),
    ),
  );

  getIt.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // HTTP client
  getIt.registerSingleton<Dio>(Dio());

  getIt.registerSingleton<DioClient>(
    DioClient(
      getIt<Dio>(),
      getIt<StorageService>(),
      getIt<AppLogger>(),
    ),
  );
}

Future<void> _registerFeatureDependencies() async {
  // Register features in dependency order
  // Categories first (no dependencies on other features)
  await CategoriesInjection.init();

  // Products (depends on categories)
  await ProductsInjection.init();

  // Cart (depends on products)
  await CartInjection.init();

  // Auth (can be independent)
  await AuthInjection.init();
}