import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:scalable_ecommerce/features/favorites/di/favorites_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/themes/theme_cubit.dart';
import '../../features/favorites/data/datasources/favorites_local_datastore.dart';
import '../../features/favorites/data/datasources/favorites_remote_datastore.dart';
import '../../features/favorites/domain/usecases/add_to_favorite_usecase.dart';
import '../../features/favorites/domain/usecases/clear_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/remove_favorite_usecase.dart';
import '../../features/favorites/presentation/cubit/favorites_collections/favorites_collection_cubit.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/profile/data/datasources/profile_local_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/delete_account_usecase.dart';
import '../../features/profile/domain/usecases/delete_profile_usecase.dart';
import '../../features/profile/domain/usecases/export_user_data_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_stats_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/get_user_preference_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_image_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_info_usecase.dart';
import '../../features/profile/domain/usecases/update_user_preference_usecase.dart';
import '../../features/profile/domain/usecases/verify_email_usecase.dart';
import '../../features/profile/domain/usecases/verify_phone_usecase.dart';
import '../../features/profile/presentation/cubit/profile/profile_cubit.dart';
import '../../features/profile/presentation/cubit/profile_preferences/profile_preferences_cubit.dart';
import '../../features/profile/presentation/cubit/profile_stats/profile_stats_cubit.dart';
import '../../features/search/data/datasources/search_local_datastore.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/clear_search_history_usecase.dart';
import '../../features/search/domain/usecases/get_popular_searches_usecase.dart';
import '../../features/search/domain/usecases/get_search_history_usecase.dart';
import '../../features/search/domain/usecases/get_search_suggestions_usecase.dart';
import '../../features/search/domain/usecases/save_search_query_usecase.dart';
import '../../features/search/presentation/cubit/search_cubit/search_cubit.dart';
import '../../features/search/presentation/cubit/search_filter/search_filter_cubit.dart';
import '../../features/search/presentation/cubit/search_history_cubit/search_history_cubit.dart';
import '../../features/search/presentation/cubit/search_suggestion_cubit/search_suggestions_cubit.dart';
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

// Favorites
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/create_favorites_collection_usecase.dart';
import '../../features/favorites/domain/usecases/get_favorites_count_usecase.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/get_favorites_collections_usecase.dart';
import '../../features/favorites/domain/usecases/is_favorite_usecase.dart';
import '../../features/favorites/domain/usecases/organize_favorites_usecase.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final logger = AppLogger();

  logger.logBusinessLogic(
    'manual_dependency_injection_started',
    'system_init',
    {
      'user': 'roshdology123',
      'timestamp': '2025-06-19 14:14:14',
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
        'timestamp': '2025-06-19 14:14:14',
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
        'timestamp': '2025-06-19 14:14:14',
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
        'total_registered': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
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
        getIt<AuthRepository>(),
      ),
    );

    logger.logBusinessLogic(
      'auth_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 8,
        'total_registered': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
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
          () => ProductDetailCubit(getIt<GetProductByIdUseCase>(), getIt<ProductsRepository>()),
    );

    logger.logBusinessLogic(
      'products_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 6,
        'cubits': 3,
        'total_registered': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
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
        'total_registered': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );

    // =====================================================================
    // STEP 6: REGISTER FAVORITES FEATURE
    // =====================================================================

    logger.logBusinessLogic(
      'favorites_feature_registration_started',
      'system_init',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );

    // Data Sources
    getIt.registerSingleton<FavoritesLocalDataSource>(
      FavoritesLocalDataSourceImpl(),
    );
    getIt.registerSingleton<FavoritesRemoteDataSource>(
      FavoritesRemoteDataSourceImpl(),
    );

    // Repository
    getIt.registerSingleton<FavoritesRepository>(
      FavoritesRepositoryImpl(
        localDataSource: getIt<FavoritesLocalDataSource>(),
        remoteDataSource: getIt<FavoritesRemoteDataSource>(),
      ),
    );

    // Use Cases
    getIt.registerSingleton<AddToFavoritesUseCase>(
      AddToFavoritesUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<RemoveFromFavoritesUseCase>(
      RemoveFromFavoritesUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<GetFavoritesUseCase>(
      GetFavoritesUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<IsFavoriteUseCase>(
      IsFavoriteUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<GetFavoritesCountUseCase>(
      GetFavoritesCountUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<ClearFavoritesUseCase>(
      ClearFavoritesUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<CreateFavoritesCollectionUseCase>(
      CreateFavoritesCollectionUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<GetFavoritesCollectionsUseCase>(
      GetFavoritesCollectionsUseCase(getIt<FavoritesRepository>()),
    );
    getIt.registerSingleton<OrganizeFavoritesUseCase>(
      OrganizeFavoritesUseCase(getIt<FavoritesRepository>()),
    );

    // Cubits (as factories)
    getIt.registerFactory<FavoritesCubit>(
          () => FavoritesCubit(
        getIt<GetFavoritesUseCase>(),
        getIt<AddToFavoritesUseCase>(),
        getIt<RemoveFromFavoritesUseCase>(),
        getIt<IsFavoriteUseCase>(),
        getIt<GetFavoritesCountUseCase>(),
        getIt<ClearFavoritesUseCase>(),
        getIt<OrganizeFavoritesUseCase>(),
      ),
    );
    getIt.registerFactory<FavoritesCollectionsCubit>(
          () => FavoritesCollectionsCubit(
        getIt<GetFavoritesCollectionsUseCase>(),
        getIt<CreateFavoritesCollectionUseCase>(),
        getIt<OrganizeFavoritesUseCase>(),
      ),
    );

    // Verify favorites feature initialization
    await _verifyFavoritesFeature();

    logger.logBusinessLogic(
      'favorites_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 9,
        'cubits': 2,
        'total_registered': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );


    // =====================================================================
    // STEP 7: REGISTER SEARCH FEATURE
    // =====================================================================

    logger.logBusinessLogic(
      'search_feature_registration_started',
      'system_init',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 07:08:38',
      },
    );

    // Data Sources
    getIt.registerSingleton<SearchLocalDataSource>(
      SearchLocalDataSourceImpl(),
    );
    getIt.registerSingleton<SearchRemoteDataSource>(
      SearchRemoteDataSourceImpl(getIt<DioClient>()),
    );

    // Repository
    getIt.registerSingleton<SearchRepository>(
      SearchRepositoryImpl(
        getIt<SearchRemoteDataSource>(),
         getIt<SearchLocalDataSource>(),
         getIt<NetworkInfo>(),
      ),
    );

    getIt.registerSingleton<GetSearchSuggestionsUseCase>(
      GetSearchSuggestionsUseCase(getIt<SearchRepository>()),
    );
    getIt.registerSingleton<SaveSearchQueryUseCase>(
      SaveSearchQueryUseCase(getIt<SearchRepository>()),
    );
    getIt.registerSingleton<GetSearchHistoryUseCase>(
      GetSearchHistoryUseCase(getIt<SearchRepository>()),
    );
    getIt.registerSingleton<ClearSearchHistoryUseCase>(
      ClearSearchHistoryUseCase(getIt<SearchRepository>()),
    );
    getIt.registerSingleton<GetPopularSearchesUseCase>(
      GetPopularSearchesUseCase(getIt<SearchRepository>()),
    );

    // Cubits (as factories)
    getIt.registerFactory<SearchCubit>(
          () => SearchCubit(

         getIt<SearchProductsUseCase>(),
      ),
    );
    getIt.registerFactory<SearchSuggestionsCubit>(
          () => SearchSuggestionsCubit(
        getIt<GetProductsUseCase>(),
        getIt<GetCategoriesUseCase>(),
      ),
    );
    getIt.registerFactory<SearchHistoryCubit>(
          () => SearchHistoryCubit(),
    );
    getIt.registerFactory<SearchFilterCubit>(
          () => SearchFilterCubit(getIt<GetCategoriesUseCase>()),
    );

    // Verify search feature initialization
    await _verifySearchFeature();

    logger.logBusinessLogic(
      'search_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 6,
        'cubits': 4,
        'total_registered': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-22 07:08:38',
      },
    );


    // =====================================================================
    // STEP 8: REGISTER PROFILE FEATURE
    // =====================================================================

    logger.logBusinessLogic(
      'profile_feature_registration_started',
      'system_init',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 09:41:12',
      },
    );

    // Data Sources
    getIt.registerSingleton<ProfileLocalDataSource>(
      ProfileLocalDataSourceImpl(getIt<SecureStorage>()),
    );
    getIt.registerSingleton<ProfileRemoteDataSource>(
      ProfileRemoteDataSourceImpl(getIt<DioClient>()),
    );

    // Repository
    getIt.registerSingleton<ProfileRepository>(
      ProfileRepositoryImpl(
      remoteDataSource:    getIt<ProfileRemoteDataSource>(),
       localDataSource:  getIt<ProfileLocalDataSource>(),
       networkInfo:  getIt<NetworkInfo>(),
      ),
    );
    getIt.registerSingleton<UpdateProfileInfoUseCase>(
      UpdateProfileInfoUseCase(getIt<ProfileRepository>()),
    );
    // Use Cases
    getIt.registerSingleton<GetProfileUseCase>(
      GetProfileUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<UploadProfileImageUseCase>(
      UploadProfileImageUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<DeleteProfileImageUseCase>(
      DeleteProfileImageUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<ChangePasswordUseCase>(
      ChangePasswordUseCase(getIt<AuthRepository>()),
    );
    getIt.registerSingleton<VerifyEmailUseCase>(
      VerifyEmailUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<VerifyPhoneUseCase>(
      VerifyPhoneUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<DeleteAccountUseCase>(
      DeleteAccountUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<ExportUserDataUseCase>(
      ExportUserDataUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<GetUserPreferencesUseCase>(
      GetUserPreferencesUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<UpdateUserPreferencesUseCase>(
      UpdateUserPreferencesUseCase(getIt<ProfileRepository>()),
    );
    getIt.registerSingleton<GetProfileStatsUseCase>(
      GetProfileStatsUseCase(getIt<ProfileRepository>()),
    );

    // Theme Cubit (Singleton for app-wide theme state)
    getIt.registerSingleton<ThemeCubit>(
      ThemeCubit(),
    );

    // Profile Cubits (as factories)
    getIt.registerFactory<ProfileCubit>(
          () => ProfileCubit(
        getProfileUseCase: getIt<GetProfileUseCase>(),
        updateProfileInfoUseCase: getIt<UpdateProfileInfoUseCase>(),
        uploadProfileImageUseCase: getIt<UploadProfileImageUseCase>(),
        deleteProfileImageUseCase: getIt<DeleteProfileImageUseCase>(),
        changePasswordUseCase: getIt<ChangePasswordUseCase>(),
        verifyEmailUseCase: getIt<VerifyEmailUseCase>(),
        verifyPhoneUseCase: getIt<VerifyPhoneUseCase>(),
        deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
        exportUserDataUseCase: getIt<ExportUserDataUseCase>(),
      ),
    );
    getIt.registerFactory<ProfilePreferencesCubit>(
          () => ProfilePreferencesCubit(
        getUserPreferencesUseCase: getIt<GetUserPreferencesUseCase>(),
        updateUserPreferencesUseCase: getIt<UpdateUserPreferencesUseCase>(),
      ),
    );
    getIt.registerFactory<ProfileStatsCubit>(
          () => ProfileStatsCubit(
        getProfileStatsUseCase: getIt<GetProfileStatsUseCase>(),
      ),
    );

    // Verify profile feature initialization
    await _verifyProfileFeature();

    logger.logBusinessLogic(
      'profile_feature_registered',
      'system_init',
      {
        'data_sources': 2,
        'use_cases': 12,
        'cubits': 4, // Including ThemeCubit
        'total_registered': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-22 09:41:12',
      },
    );

    // =====================================================================
    // STEP 7: FINAL VERIFICATION AND SUCCESS LOG
    // =====================================================================

    await _performFinalVerification();
    logger.logBusinessLogic(
      'manual_dependency_injection_completed',
      'system_init',
      {
        'total_services': getIt.allReadySync(),
        'features_registered': ['auth', 'products', 'cart', 'favorites', 'search', 'profile'], // Add profile here
        'user': 'roshdology123',
        'timestamp': '2025-06-22 09:41:12',
        'initialization_successful': true,
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      'ManualDependencyInjection.configure',
      e,
      stackTrace,
      {
        'registered_so_far': getIt.allReadySync(),
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );
    rethrow;
  }
}

// Helper function to verify profile feature
Future<void> _verifyProfileFeature() async {
  final logger = AppLogger();

  try {
    // Test that all critical profile services are available
    final profileRepo = getIt<ProfileRepository>();
    final profileCubit = getIt<ProfileCubit>();
    final preferencesCubit = getIt<ProfilePreferencesCubit>();
    final statsCubit = getIt<ProfileStatsCubit>();
    final themeCubit = getIt<ThemeCubit>();

    if (profileRepo == null ||
        profileCubit == null ||
        preferencesCubit == null ||
        statsCubit == null ||
        themeCubit == null) {
      throw Exception('Critical profile dependencies missing');
    }

    // Test profile use cases
    final getProfileUseCase = getIt<GetProfileUseCase>();
    final updateProfileUseCase = getIt<UpdateProfileUseCase>();
    final getStatsUseCase = getIt<GetProfileStatsUseCase>();

    logger.logBusinessLogic(
      'profile_feature_verified',
      'system_init',
      {
        'repository_ready': true,
        'cubits_ready': true,
        'use_cases_ready': true,
        'theme_cubit_ready': true,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 09:41:12',
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      '_verifyProfileFeature',
      e,
      stackTrace,
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 09:41:12',
      },
    );
    rethrow;
  }
}

// Helper function to verify search feature
Future<void> _verifySearchFeature() async {
  final logger = AppLogger();

  try {
    // Test that all critical search services are available
    final searchRepo = getIt<SearchRepository>();
    final searchCubit = getIt<SearchCubit>();
    final suggestionsCubit = getIt<SearchSuggestionsCubit>();
    final historyCubit = getIt<SearchHistoryCubit>();
    final filterCubit = getIt<SearchFilterCubit>();

    if (searchRepo == null ||
        searchCubit == null ||
        suggestionsCubit == null ||
        historyCubit == null ||
        filterCubit == null) {
      throw Exception('Critical search dependencies missing');
    }

    // Test local storage for search history
    final localDataSource = getIt<SearchLocalDataSource>();
    final testHistory = await localDataSource.getSearchHistory();

    logger.logBusinessLogic(
      'search_feature_verified',
      'system_init',
      {
        'repository_ready': true,
        'cubits_ready': true,
        'local_storage_ready': true,
        'current_search_history_count': testHistory.queries.length,
        'user': 'roshdology123',
        'timestamp': '2025-06-22 07:08:38',
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      '_verifySearchFeature',
      e,
      stackTrace,
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 07:08:38',
      },
    );
    rethrow;
  }
}
// Helper function to verify favorites feature
Future<void> _verifyFavoritesFeature() async {
  final logger = AppLogger();

  try {
    // Test that all critical favorites services are available
    final favoritesRepo = getIt<FavoritesRepository>();
    final favoritesCubit = getIt<FavoritesCubit>();
    final collectionsCubit = getIt<FavoritesCollectionsCubit>();

    if (favoritesRepo == null || favoritesCubit == null || collectionsCubit == null) {
      throw Exception('Critical favorites dependencies missing');
    }

    // Test local storage for favorites
    final localDataSource = getIt<FavoritesLocalDataSource>();
    final testCount = await localDataSource.getFavoritesCount();

    logger.logBusinessLogic(
      'favorites_feature_verified',
      'system_init',
      {
        'repository_ready': true,
        'cubits_ready': true,
        'local_storage_ready': true,
        'current_favorites_count': testCount,
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      '_verifyFavoritesFeature',
      e,
      stackTrace,
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );
    rethrow;
  }
}

// Helper function for final verification of all features
Future<void> _performFinalVerification() async {
  final logger = AppLogger();

  try {
    // Verify all critical services are available
    final criticalServices = [
      'AuthRepository',
      'ProductsRepository',
      'CartRepository',
      'FavoritesRepository',
      'SearchRepository',
      'AuthCubit',
      'ProductsCubit',
      'CartCubit',
      'FavoritesCubit',
      'SearchCubit',
    ];

    for (final serviceName in criticalServices) {
      switch (serviceName) {
        case 'AuthRepository':
          getIt<AuthRepository>();
          break;
        case 'ProductsRepository':
          getIt<ProductsRepository>();
          break;
        case 'CartRepository':
          getIt<CartRepository>();
          break;
        case 'FavoritesRepository':
          getIt<FavoritesRepository>();
          break;
        case 'AuthCubit':
          getIt<AuthCubit>();
          break;
        case 'ProductsCubit':
          getIt<ProductsCubit>();
          break;
        case 'CartCubit':
          getIt<CartCubit>();
          break;
        case 'FavoritesCubit':
          getIt<FavoritesCubit>();
        case 'SearchRepository':
          getIt<SearchRepository>();
          break;
        case 'SearchCubit':
          getIt<SearchCubit>();
          break;
      }
    }

    logger.logBusinessLogic(
      'final_verification_completed',
      'system_init',
      {
        'critical_services_verified': criticalServices,
        'all_services_ready': true,
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      '_performFinalVerification',
      e,
      stackTrace,
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-19 14:14:14',
      },
    );
    rethrow;
  }
}

extension FavoritesGetItExtensions on GetIt {
  // Existing favorites extensions
  FavoritesCubit get favoritesCubit => get<FavoritesCubit>();
  FavoritesCollectionsCubit get favoritesCollectionsCubit => get<FavoritesCollectionsCubit>();
  FavoritesRepository get favoritesRepository => get<FavoritesRepository>();

  // Search extensions
  SearchCubit get searchCubit => get<SearchCubit>();
  SearchSuggestionsCubit get searchSuggestionsCubit => get<SearchSuggestionsCubit>();
  SearchHistoryCubit get searchHistoryCubit => get<SearchHistoryCubit>();
  SearchFilterCubit get searchFilterCubit => get<SearchFilterCubit>();
  SearchRepository get searchRepository => get<SearchRepository>();

  // Profile extensions
  ProfileCubit get profileCubit => get<ProfileCubit>();
  ProfilePreferencesCubit get profilePreferencesCubit => get<ProfilePreferencesCubit>();
  ProfileStatsCubit get profileStatsCubit => get<ProfileStatsCubit>();
  ProfileRepository get profileRepository => get<ProfileRepository>();
  ThemeCubit get themeCubit => get<ThemeCubit>();

  // Quick check for favorites feature availability
  bool get isFavoritesReady {
    try {
      get<FavoritesRepository>();
      get<FavoritesCubit>();
      get<FavoritesCollectionsCubit>();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Quick check for search feature availability
  bool get isSearchReady {
    try {
      get<SearchRepository>();
      get<SearchCubit>();
      get<SearchSuggestionsCubit>();
      get<SearchHistoryCubit>();
      get<SearchFilterCubit>();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Quick check for profile feature availability
  bool get isProfileReady {
    try {
      get<ProfileRepository>();
      get<ProfileCubit>();
      get<ProfilePreferencesCubit>();
      get<ProfileStatsCubit>();
      get<ThemeCubit>();
      return true;
    } catch (e) {
      return false;
    }
  }
}