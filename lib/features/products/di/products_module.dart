import 'package:injectable/injectable.dart';

import '../../../core/network/network_info.dart';
import '../data/datasources/products_local_datasource.dart';
import '../data/datasources/products_remote_datasource.dart';
import '../data/repositories/products_repository_impl.dart';
import '../domain/repositories/products_repository.dart';
import '../domain/usecases/filter_products_usecase.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/get_product_by_category_usecase.dart';
import '../domain/usecases/get_product_by_id_usecase.dart';
import '../domain/usecases/search_products_usecase.dart';

@module
abstract class ProductsModule {

  @LazySingleton(as: ProductsRepository)
  ProductsRepositoryImpl productsRepository(
      ProductsRemoteDataSource remoteDataSource,
      ProductsLocalDataSource localDataSource,
      NetworkInfo networkInfo,
      ) =>
      ProductsRepositoryImpl(remoteDataSource, localDataSource, networkInfo);

  @LazySingleton()
  GetCategoriesUseCase getCategoriesUseCase(ProductsRepository repository) =>
      GetCategoriesUseCase(repository);

  @LazySingleton()
  GetProductsUseCase getProductsUseCase(ProductsRepository repository) =>
      GetProductsUseCase(repository);

  @LazySingleton()
  GetProductsByCategoryUseCase getProductByCategoryUseCase(ProductsRepository repository) =>
      GetProductsByCategoryUseCase(repository);

  @LazySingleton()
  GetProductByIdUseCase getProductByIdUseCase(ProductsRepository repository) =>
      GetProductByIdUseCase(repository);

  @LazySingleton()
  SearchProductsUseCase searchProductsUseCase(ProductsRepository repository) =>
      SearchProductsUseCase(repository);

  @LazySingleton()
  FilterProductsUseCase filterProductsUseCase(ProductsRepository repository) =>
      FilterProductsUseCase();
}