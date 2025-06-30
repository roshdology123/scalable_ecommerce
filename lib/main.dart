import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scalable_ecommerce/core/services/notification_service.dart';
import 'package:scalable_ecommerce/core/storage/local_storage.dart';
import 'package:scalable_ecommerce/core/storage/secure_storage.dart';

import 'core/di/injection.dart';
import 'core/storage/storage_service.dart';
import 'core/utils/app_logger.dart';
import 'app/router/app_router.dart';
import 'app/themes/theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cart/presentation/cubit/cart_summary_cubit.dart';
import 'features/favorites/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import 'features/favorites/presentation/cubit/favorites_collections/favorites_collection_cubit.dart';
import 'features/products/presentation/cubit/categories_cubit.dart';
import 'features/products/presentation/cubit/product_detail_cubit.dart';
import 'features/products/presentation/cubit/products_cubit.dart';
import 'features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'features/profile/presentation/cubit/profile_preferences/profile_preferences_cubit.dart';
import 'features/profile/presentation/cubit/profile_stats/profile_stats_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  final logger = AppLogger();
  NotificationService().initialize(
    enableSimulation: true,
  );
  await StorageService.initializeAll();
  await LocalStorage.init();
  try {
    logger.logBusinessLogic(
      'app_initialization_started',
      'system_startup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 11:18:18',
        'platform': 'flutter',
        'version': '1.0.0',
      },
    );

    // Configure system UI for roshdology123
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Initialize dependencies FIRST
    logger.logBusinessLogic(
      'dependency_injection_started',
      'system_startup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 11:18:18',
      },
    );

    await configureDependencies();

    logger.logBusinessLogic(
      'dependency_injection_completed',
      'system_startup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 11:18:18',
        'total_services': getIt.allReadySync(),
      },
    );

    // Run the app
    runApp(
      EasyLocalization(
        saveLocale: true,
        startLocale: const Locale('ar',),
        supportedLocales: const [
          Locale('en',),
          Locale('ar',),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar',),
        child: const MyApp(),
      ),
    );

    logger.logBusinessLogic(
      'app_initialization_completed',
      'system_startup',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 11:18:18',
        'status': 'success',
      },
    );

  } catch (e, stackTrace) {
    logger.logErrorWithContext(
      'App.main',
      e,
      stackTrace,
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 11:18:18',
        'error_type': 'initialization_failure',
      },
    );

    // Run error app if initialization fails
    runApp(ErrorApp(
      error: e.toString(),
      user: 'roshdology123',
      timestamp: '2025-06-22 11:18:18',
    ));
  }
}

/// 🎯 SINGLE MyApp class - this is the ONLY one that should exist
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    logger.logBusinessLogic(
      'app_widget_building',
      'ui_lifecycle',
      {
        'user': 'roshdology123',
        'timestamp': '2025-06-22 11:18:18',
      },
    );

    // 🔥 CRITICAL: Provide ALL cubits at the TOP LEVEL
    return MultiBlocProvider(
      providers: [
        // 🎨 Theme Cubit - MUST be first for theme switching
        BlocProvider<ThemeCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'theme_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            final themeCubit = getIt<ThemeCubit>();
            themeCubit.loadTheme();
            return themeCubit;
          },
        ),

        // 🔐 Auth Cubit
        BlocProvider<AuthCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'auth_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<AuthCubit>();
          },
        ),

        // Categories Cubit
        BlocProvider<CategoriesCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'categories_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<CategoriesCubit>()..loadCategories();
          },
        ),

        // 🛍️ Products Cubit
        BlocProvider<ProductsCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'products_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<ProductsCubit>();
          },
        ),

        // 🛒 Cart Cubit
        BlocProvider<CartCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'cart_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<CartCubit>()..initializeCart();
          },
        ),

        // Cart Summary Cubit

        BlocProvider<CartSummaryCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'cart_summary_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<CartSummaryCubit>();
          },
        ),
        // 🛍️ Product Detail Cubit

        BlocProvider<ProductDetailCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'product_detail_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<ProductDetailCubit>();
          },
        ),
        // ❤️ Favorites Cubit
        BlocProvider<FavoritesCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'favorites_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<FavoritesCubit>()..loadFavorites();
          },
        ),

        // 📚 Favorites Collections Cubit
        BlocProvider<FavoritesCollectionsCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'favorites_collections_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<FavoritesCollectionsCubit>()..loadCollections();
          },
        ),

        // 👤 Profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'profile_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<ProfileCubit>();
          },
        ),

        // ⚙️ Profile Preferences Cubit
        BlocProvider<ProfilePreferencesCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'profile_preferences_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<ProfilePreferencesCubit>();
          },
        ),

        // 📊 Profile Stats Cubit
        BlocProvider<ProfileStatsCubit>(
          create: (context) {
            logger.logBusinessLogic(
              'profile_stats_cubit_initialized',
              'ui_lifecycle',
              {
                'user': 'roshdology123',
                'timestamp': '2025-06-22 11:18:18',
              },
            );
            return getIt<ProfileStatsCubit>();
          },
        ),
      ],

      // 🎨 BlocBuilder for ThemeCubit - this WILL work now
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          logger.logBusinessLogic(
            'material_app_building',
            'ui_lifecycle',
            {
              'user': 'roshdology123',
              'timestamp': '2025-06-22 11:18:18',
              'theme_mode': themeState.themeMode.name,
              'locale': context.locale.toString(),
            },
          );
          FlutterNativeSplash.remove();

          return MaterialApp.router(
            title: 'Scalable E-Commerce - roshdology123',
            debugShowCheckedModeBanner: false,

            // 🌐 Localization Support
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            // 🎨 Theming with Google Fonts
            theme: themeState.lightTheme.copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                themeState.lightTheme.textTheme,
              ),
            ),
            darkTheme: themeState.darkTheme.copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                themeState.darkTheme.textTheme,
              ),
            ),
            themeMode: themeState.themeMode,

            // 🧭 Routing Configuration
            routerConfig: AppRouter.router,

            // 🚀 Performance Optimizations
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

/// Error App Widget displayed when initialization fails
class ErrorApp extends StatelessWidget {
  final String error;
  final String user;
  final String timestamp;

  const ErrorApp({
    super.key,
    required this.error,
    required this.user,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scalable E-Commerce - Error',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'App Failed to Start',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error Details:',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'User: $user',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Time: $timestamp',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => SystemNavigator.pop(),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        'Restart App',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'If this problem persists for roshdology123, please contact support.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}