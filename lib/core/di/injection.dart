import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_service.dart';
import '../utils/app_logger.dart';

// Auth
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/change_password_usecase.dart';
import '../../features/auth/domain/usecases/update_profile_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Products  
import '../../features/products/data/datasources/products_local_datasource.dart';
import '../../features/products/data/datasources/products_remote_datasource.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';
import '../../features/products/domain/usecases/get_categories_usecase.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/get_product_by_id_usecase.dart';
import '../../features/products/domain/usecases/get_product_by_category_usecase.dart';
import '../../features/products/domain/usecases/search_products_usecase.dart';
import '../../features/products/domain/usecases/filter_products_usecase.dart';
import '../../features/products/presentation/cubit/categories_cubit.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';
import '../../features/products/presentation/cubit/product_detail_cubit.dart';

// Cart
import '../../features/cart/data/datasources/cart_local_datasource.dart';
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_item_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/domain/usecases/apply_coupon_usecase.dart';
import '../../features/cart/domain/usecases/remove_coupon_usecase.dart';
import '../../features/cart/domain/usecases/calculate_cart_totals_usecase.dart';
import '../../features/cart/domain/usecases/sync_cart_usecase.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/cubit/cart_summary_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final logger = AppLogger();

  logger.logBusinessLogic(
    'manual_dependency_injection_started',
    'system_init',
    {
      'user': 'roshdology123',
      'timestamp': '2025-06-19 05:59:17',
    },
  );

  try {
    // Clear any existing registrations
    await getIt.reset();

    // Initialize storage first
    await StorageService.initializeAll();

    logger.logBusinessLogic(
      'storage_initialized',
      'system_init',
      {
        'local_storage_ready': LocalStorage.isInitialized,
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );
    getIt.registerFactory<OnboardingCubit>(
          () => OnboardingCubit(getIt<StorageService>()),
    );
    // =====================================================================
    // STEP 1: REGISTER EXTERNAL DEPENDENCIES
    // =====================================================================

    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    getIt.registerSingleton<Connectivity>(Connectivity());
    getIt.registerSingleton<Dio>(Dio());

    logger.logBusinessLogic(
      'external_dependencies_registered',
      'system_init',
      {
        'count': 3,
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );

    // =====================================================================
    // STEP 2: REGISTER CORE SERVICES  
    // =====================================================================

    getIt.registerSingleton<AppLogger>(AppLogger());
    getIt.registerSingleton<LocalStorage>(LocalStorage());
    getIt.registerSingleton<SecureStorage>(SecureStorage());

    getIt.registerSingleton<NetworkInfo>(
      NetworkInfoImpl(getIt<Connectivity>()),
    );

    getIt.registerSingleton<DioClient>(
      DioClient(getIt<NetworkInfo>(), getIt<SecureStorage>()),
    );

    getIt.registerSingleton<StorageService>(
      StorageService(
        getIt<SharedPreferences>(),
        getIt<SecureStorage>(),
        getIt<LocalStorage>(),
      ),
    );

    logger.logBusinessLogic(
      'core_services_registered',
      'system_init',
      {
        'count': 6,
        'total_registered': getIt.allReadySync().toString(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );

    // =====================================================================
    // STEP 3: REGISTER AUTH FEATURE
    // =====================================================================

    // Data Sources
    getIt.registerSingleton<AuthLocalDataSource>(
      AuthLocalDataSourceImpl(getIt<SecureStorage>()),
    );
    getIt.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(getIt<DioClient>()),
    );

    // Repository
    getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        getIt<AuthRemoteDataSource>(),
        getIt<AuthLocalDataSource>(),
        getIt<NetworkInfo>(),
      ),
    );

    // Use Cases
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<RegisterUseCase>(
      RegisterUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<LogoutUseCase>(
      LogoutUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<GetCurrentUserUseCase>(
      GetCurrentUserUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<ForgotPasswordUseCase>(
      ForgotPasswordUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<ResetPasswordUseCase>(
      ResetPasswordUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<ChangePasswordUseCase>(
      ChangePasswordUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<UpdateProfileUseCase>(
      UpdateProfileUseCase(getIt<AuthRepository>()),
    );

    // Cubit (as factory)
    getIt.registerFactory<AuthCubit>(
          () => AuthCubit(
        getIt<LoginUseCase>(),
        getIt<RegisterUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<GetCurrentUserUseCase>(),
        getIt<ForgotPasswordUseCase>(),
        getIt<ResetPasswordUseCase>(),
        getIt<UpdateProfileUseCase>(),
      ),
    );

    logger.logBusinessLogic(
      'auth_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 8,
        'total_registered': getIt.allReadySync().toString(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );

    // =====================================================================
    // STEP 4: REGISTER PRODUCTS FEATURE
    // =====================================================================

    // Data Sources
    getIt.registerSingleton<ProductsLocalDataSource>(
      ProductsLocalDataSourceImpl(),
    );
    getIt.registerSingleton<ProductsRemoteDataSource>(
      ProductsRemoteDataSourceImpl(getIt<DioClient>()),
    );

    // Repository
    getIt.registerSingleton<ProductsRepository>(
      ProductsRepositoryImpl(
        getIt<ProductsRemoteDataSource>(),
        getIt<ProductsLocalDataSource>(),
        getIt<NetworkInfo>(),
      ),
    );

    // Use Cases
    getIt.registerSingleton<GetCategoriesUseCase>(
      GetCategoriesUseCase(getIt<ProductsRepository>()),
    );
    getIt.registerSingleton<GetProductsUseCase>(
      GetProductsUseCase(getIt<ProductsRepository>()),
    );
    getIt.registerSingleton<GetProductByIdUseCase>(
      GetProductByIdUseCase(getIt<ProductsRepository>()),
    );
    getIt.registerSingleton<GetProductsByCategoryUseCase>(
      GetProductsByCategoryUseCase(getIt<ProductsRepository>()),
    );
    getIt.registerSingleton<SearchProductsUseCase>(
      SearchProductsUseCase(getIt<ProductsRepository>()),
    );
    getIt.registerSingleton<FilterProductsUseCase>(
      FilterProductsUseCase(),
    );

    // Cubits
    getIt.registerFactory<CategoriesCubit>(
          () => CategoriesCubit(getIt<GetCategoriesUseCase>()),
    );
    getIt.registerFactory<ProductsCubit>(
          () => ProductsCubit(
        getIt<GetProductsUseCase>(),
        getIt<GetProductsByCategoryUseCase>(),
        getIt<SearchProductsUseCase>(),
        getIt<FilterProductsUseCase>(),
      ),
    );
    getIt.registerFactory<ProductDetailCubit>(
          () => ProductDetailCubit(getIt<GetProductByIdUseCase>(),getIt<ProductsRepository>()),
    );

    logger.logBusinessLogic(
      'products_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 6,
        'cubits': 3,
        'total_registered': getIt.allReadySync().toString(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );

    // =====================================================================
    // STEP 5: REGISTER CART FEATURE
    // =====================================================================

    // Data Sources
    getIt.registerSingleton<CartLocalDataSource>(
      CartLocalDataSourceImpl(),
    );
    getIt.registerSingleton<CartRemoteDataSource>(
      CartRemoteDataSourceImpl(getIt<DioClient>()),
    );

    // Repository
    getIt.registerSingleton<CartRepository>(
      CartRepositoryImpl(
        getIt<CartRemoteDataSource>(),
        getIt<CartLocalDataSource>(),
        getIt<NetworkInfo>(),
      ),
    );

    // Use Cases
    getIt.registerSingleton<GetCartUseCase>(
      GetCartUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<AddToCartUseCase>(
      AddToCartUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<RemoveFromCartUseCase>(
      RemoveFromCartUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<UpdateCartItemUseCase>(
      UpdateCartItemUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<ClearCartUseCase>(
      ClearCartUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<ApplyCouponUseCase>(
      ApplyCouponUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<RemoveCouponUseCase>(
      RemoveCouponUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<CalculateCartTotalsUseCase>(
      CalculateCartTotalsUseCase(getIt<CartRepository>()),
    );
    getIt.registerSingleton<SyncCartUseCase>(
      SyncCartUseCase(getIt<CartRepository>()),
    );

    // Cubits
    getIt.registerFactory<CartCubit>(
          () => CartCubit(
        getIt<GetCartUseCase>(),
        getIt<AddToCartUseCase>(),
        getIt<RemoveFromCartUseCase>(),
        getIt<UpdateCartItemUseCase>(),
        getIt<ClearCartUseCase>(),
        getIt<ApplyCouponUseCase>(),
        getIt<RemoveCouponUseCase>(),
        getIt<CalculateCartTotalsUseCase>(),
        getIt<SyncCartUseCase>(),
      ),
    );
    getIt.registerFactory<CartSummaryCubit>(
          () => CartSummaryCubit(getIt<CalculateCartTotalsUseCase>()),
    );

    logger.logBusinessLogic(
      'cart_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 9,
        'cubits': 2,
        'total_registered': getIt.allReadySync().toString(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );

    // =====================================================================
    // FINAL SUCCESS LOG
    // =====================================================================

    logger.logBusinessLogic(
      'manual_dependency_injection_completed',
      'system_init',
      {
        'total_services': getIt.allReadySync().toString(),
        'features_registered': ['auth', 'products', 'cart'],
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      'ManualDependencyInjection.configure',
      e,
      stackTrace,
      {
        'registered_so_far': getIt.allReadySync().toString(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 05:59:17',
      },
    );
    rethrow;
  }
}