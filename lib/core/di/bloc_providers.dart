import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scalable_ecommerce/features/favorites/presentation/cubit/favorites_cubit/favorites_cubit.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/cubit/cart_summary_cubit.dart';
import '../../features/products/presentation/cubit/categories_cubit.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';
import '../../features/products/presentation/cubit/product_detail_cubit.dart';
import 'injection.dart';

class BlocProviders {
  static List<BlocProvider> get providers => [
    // Auth
    BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
    ),

    // Products
    BlocProvider<CategoriesCubit>(
      create: (_) => getIt<CategoriesCubit>(),
    ),

    BlocProvider<ProductsCubit>(
      create: (_) => getIt<ProductsCubit>(),
    ),

    BlocProvider<ProductDetailCubit>(
      create: (_) => getIt<ProductDetailCubit>(),
    ),

    // Cart
    BlocProvider<CartCubit>(
      create: (_) => getIt<CartCubit>(),
    ),

    BlocProvider<CartSummaryCubit>(
      create: (_) => getIt<CartSummaryCubit>(),
    ),

    BlocProvider<FavoritesCubit>(create: (_) => getIt<FavoritesCubit>()),
  ];

  static Widget wrapWithProviders(Widget child) {
    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}