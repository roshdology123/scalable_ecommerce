import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scalable_ecommerce/features/favorites/presentation/cubit/favorites_collections/favorites_collection_cubit.dart';

import '../core/di/injection.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/favorites/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import '../features/products/presentation/cubit/products_cubit.dart';
import 'router/app_router.dart';
import 'themes/theme_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ThemeCubit>()..loadTheme(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider(
          create: (_) => getIt<ProductsCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<CartCubit>()..initializeCart(),
        ),

        BlocProvider(
          create: (_) => getIt<FavoritesCubit>()..loadFavorites(),
        ),
        BlocProvider(
          create: (_) => getIt<FavoritesCollectionsCubit>()..loadCollections(),
        )
        // BlocProvider(
        //   create: (_) => getIt<SearchCubit>(),
        // ),
        // BlocProvider(
        //   create: (_) => getIt<ProfileCubit>(),
        // ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Scalable E-Commerce',
            debugShowCheckedModeBanner: false,

            // Localization
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            // Theming with Google Fonts
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

            // Routing
            routerConfig: AppRouter.router,

            // Performance optimizations
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