import 'package:get_it/get_it.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/network_info.dart';

import '../data/datasources/cart_local_datasource.dart';
import '../data/datasources/cart_remote_datasource.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/usecases/add_to_cart_usecase.dart';
import '../domain/usecases/apply_coupon_usecase.dart';
import '../domain/usecases/calculate_cart_totals_usecase.dart';
import '../domain/usecases/clear_cart_usecase.dart';
import '../domain/usecases/get_cart_usecase.dart';
import '../domain/usecases/remove_coupon_usecase.dart';
import '../domain/usecases/remove_from_cart_usecase.dart';
import '../domain/usecases/sync_cart_usecase.dart';
import '../domain/usecases/update_cart_item_usecase.dart';
import '../presentation/cubit/cart_cubit.dart';
import '../presentation/cubit/cart_summary_cubit.dart';

class CartInjection {
  static Future<void> init() async {
    final GetIt getIt = GetIt.instance;

    // Data sources
    getIt.registerLazySingleton<CartRemoteDataSource>(
          () => CartRemoteDataSourceImpl(
        getIt<DioClient>(),
      ),
    );

    getIt.registerLazySingleton<CartLocalDataSource>(
          () => CartLocalDataSourceImpl(
      ),
    );

    // Repository
    getIt.registerLazySingleton<CartRepository>(
          () => CartRepositoryImpl(
        getIt<CartRemoteDataSource>(),
        getIt<CartLocalDataSource>(),
        getIt<NetworkInfo>(),
      ),
    );

    // Use cases
    getIt.registerLazySingleton<GetCartUseCase>(
          () => GetCartUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<AddToCartUseCase>(
          () => AddToCartUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<RemoveFromCartUseCase>(
          () => RemoveFromCartUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<UpdateCartItemUseCase>(
          () => UpdateCartItemUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<ClearCartUseCase>(
          () => ClearCartUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<ApplyCouponUseCase>(
          () => ApplyCouponUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<RemoveCouponUseCase>(
          () => RemoveCouponUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<CalculateCartTotalsUseCase>(
          () => CalculateCartTotalsUseCase(getIt<CartRepository>()),
    );

    getIt.registerLazySingleton<SyncCartUseCase>(
          () => SyncCartUseCase(getIt<CartRepository>()),
    );

    // Cubits - Register as factory
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
          () => CartSummaryCubit(
        getIt<CalculateCartTotalsUseCase>(),
      ),
    );
  }
}