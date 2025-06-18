import 'package:injectable/injectable.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/network_info.dart';
import '../data/datasources/products_local_datasource.dart';
import '../data/datasources/products_remote_datasource.dart';
import '../data/repositories/products_repository_impl.dart';
import '../domain/repositories/products_repository.dart';
import '../domain/usecases/filter_products_usecase.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_product_by_category_usecase.dart';
import '../domain/usecases/get_product_by_id_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/search_products_usecase.dart';
import '../presentation/cubit/categories_cubit.dart';
import '../presentation/cubit/product_detail_cubit.dart';
import '../presentation/cubit/products_cubit.dart';

@module
abstract class ProductsModule {
  // Data Sources
  @LazySingleton(as: ProductsRemoteDataSource)
  ProductsRemoteDataSourceImpl productsRemoteDataSource(DioClient dioClient) =>
      ProductsRemoteDataSourceImpl(dioClient);

  @LazySingleton(as: ProductsLocalDataSource)
  ProductsLocalDataSourceImpl productsLocalDataSource() =>
      ProductsLocalDataSourceImpl();

  // Repository
  @LazySingleton(as: ProductsRepository)
  ProductsRepositoryImpl productsRepository(
      ProductsRemoteDataSource remoteDataSource,
      ProductsLocalDataSource localDataSource,
      NetworkInfo networkInfo,
      ) => ProductsRepositoryImpl(remoteDataSource, localDataSource, networkInfo);

  // Use Cases
  @injectable
  GetProductsUseCase getProductsUseCase(ProductsRepository repository) =>
      GetProductsUseCase(repository);

  @injectable
  GetProductByIdUseCase getProductByIdUseCase(ProductsRepository repository) =>
      GetProductByIdUseCase(repository);

  @injectable
  GetCategoriesUseCase getCategoriesUseCase(ProductsRepository repository) =>
      GetCategoriesUseCase(repository);

  @injectable
  GetProductsByCategoryUseCase getProductsByCategoryUseCase(ProductsRepository repository) =>
      GetProductsByCategoryUseCase(repository);

  @injectable
  SearchProductsUseCase searchProductsUseCase(ProductsRepository repository) =>
      SearchProductsUseCase(repository);

  @injectable
  FilterProductsUseCase filterProductsUseCase() => FilterProductsUseCase();

  // Cubits
  @injectable
  ProductsCubit productsCubit(
      GetProductsUseCase getProductsUseCase,
      GetProductsByCategoryUseCase getProductsByCategoryUseCase,
      SearchProductsUseCase searchProductsUseCase,
      FilterProductsUseCase filterProductsUseCase,
      ) => ProductsCubit(
    getProductsUseCase,
    getProductsByCategoryUseCase,
    searchProductsUseCase,
    filterProductsUseCase,
  );

  @injectable
  ProductDetailCubit productDetailCubit(
      GetProductByIdUseCase getProductByIdUseCase,
      ProductsRepository productsRepository,
      ) => ProductDetailCubit(getProductByIdUseCase, productsRepository);

  @injectable
  CategoriesCubit categoriesCubit(GetCategoriesUseCase getCategoriesUseCase) =>
      CategoriesCubit(getCategoriesUseCase);
}