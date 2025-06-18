import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/products/presentation/cubit/categories_cubit.dart';
import '../../features/products/presentation/cubit/product_detail_cubit.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';
import 'injection.dart';

/// Helper class to provide BLoC instances
class BlocProviders {
  static List<BlocProvider> get globalProviders => [
    // Global state that persists throughout the app
    BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
    ),
    BlocProvider<CategoriesCubit>(
      create: (context) => getIt<CategoriesCubit>(),
    ),
  ];

  /// Provide ProductsCubit for products pages
  static BlocProvider<ProductsCubit> productsProvider() {
    return BlocProvider<ProductsCubit>(
      create: (context) => getIt<ProductsCubit>(),
    );
  }

  /// Provide ProductDetailCubit for product detail pages
  static BlocProvider<ProductDetailCubit> productDetailProvider() {
    return BlocProvider<ProductDetailCubit>(
      create: (context) => getIt<ProductDetailCubit>(),
    );
  }

  /// Helper method to wrap widgets with specific providers
  static Widget withProductsProvider({required Widget child}) {
    return BlocProvider<ProductsCubit>(
      create: (context) => getIt<ProductsCubit>(),
      child: child,
    );
  }

  static Widget withProductDetailProvider({required Widget child}) {
    return BlocProvider<ProductDetailCubit>(
      create: (context) => getIt<ProductDetailCubit>(),
      child: child,
    );
  }
}