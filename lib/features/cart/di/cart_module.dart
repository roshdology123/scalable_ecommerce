import 'package:injectable/injectable.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/network_info.dart';
import '../../../core/storage/storage_service.dart';
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

@module
abstract class CartModule {
  @singleton
  CartRemoteDataSource cartRemoteDataSource(DioClient dioClient) =>
      CartRemoteDataSourceImpl(dioClient);

  @singleton
  CartLocalDataSource cartLocalDataSource(StorageService storageService) =>
      CartLocalDataSourceImpl();

  @singleton
  CartRepository cartRepository(
      CartRemoteDataSource remoteDataSource,
      CartLocalDataSource localDataSource,
      NetworkInfo networkInfo,
      ) =>
      CartRepositoryImpl(remoteDataSource, localDataSource, networkInfo);

  @singleton
  GetCartUseCase getCartUseCase(CartRepository repository) =>
      GetCartUseCase(repository);

  @singleton
  AddToCartUseCase addToCartUseCase(CartRepository repository) =>
      AddToCartUseCase(repository);

  @singleton
  RemoveFromCartUseCase removeFromCartUseCase(CartRepository repository) =>
      RemoveFromCartUseCase(repository);

  @singleton
  UpdateCartItemUseCase updateCartItemUseCase(CartRepository repository) =>
      UpdateCartItemUseCase(repository);

  @singleton
  ClearCartUseCase clearCartUseCase(CartRepository repository) =>
      ClearCartUseCase(repository);

  @singleton
  ApplyCouponUseCase applyCouponUseCase(CartRepository repository) =>
      ApplyCouponUseCase(repository);

  @singleton
  RemoveCouponUseCase removeCouponUseCase(CartRepository repository) =>
      RemoveCouponUseCase(repository);

  @singleton
  CalculateCartTotalsUseCase calculateCartTotalsUseCase(CartRepository repository) =>
      CalculateCartTotalsUseCase(repository);

  @singleton
  SyncCartUseCase syncCartUseCase(CartRepository repository) =>
      SyncCartUseCase(repository);
}