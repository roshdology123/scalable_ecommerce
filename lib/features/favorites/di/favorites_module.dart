import 'package:injectable/injectable.dart';

import '../data/datasources/favorites_local_datastore.dart';
import '../data/datasources/favorites_remote_datastore.dart';
import '../data/repositories/favorites_repository_impl.dart';
import '../domain/repositories/favorites_repository.dart';
import '../domain/usecases/add_to_favorite_usecase.dart';
import '../domain/usecases/clear_favorites_usecase.dart';
import '../domain/usecases/create_favorites_collection_usecase.dart';
import '../domain/usecases/get_favorites_count_usecase.dart';
import '../domain/usecases/get_favorites_usecase.dart';
import '../domain/usecases/get_favorites_collections_usecase.dart';
import '../domain/usecases/is_favorite_usecase.dart';
import '../domain/usecases/organize_favorites_usecase.dart';
import '../domain/usecases/remove_favorite_usecase.dart';
import '../presentation/cubit/favorites_collections/favorites_collection_cubit.dart';
import '../presentation/cubit/favorites_cubit/favorites_cubit.dart';

@module
abstract class FavoritesModule {
  // Data Sources
  @LazySingleton(as: FavoritesLocalDataSource)
  FavoritesLocalDataSourceImpl get favoritesLocalDataSource;

  @LazySingleton(as: FavoritesRemoteDataSource)
  FavoritesRemoteDataSourceImpl get favoritesRemoteDataSource;

  // Repository
  @LazySingleton(as: FavoritesRepository)
  FavoritesRepositoryImpl favoritesRepository(
      FavoritesLocalDataSource localDataSource,
      FavoritesRemoteDataSource remoteDataSource,
      ) {
    return FavoritesRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  }

  // Use Cases
  @LazySingleton()
  AddToFavoritesUseCase addToFavoritesUseCase(FavoritesRepository repository) {
    return AddToFavoritesUseCase(repository);
  }

  @LazySingleton()
  RemoveFromFavoritesUseCase removeFromFavoritesUseCase(FavoritesRepository repository) {
    return RemoveFromFavoritesUseCase(repository);
  }

  @LazySingleton()
  GetFavoritesUseCase getFavoritesUseCase(FavoritesRepository repository) {
    return GetFavoritesUseCase(repository);
  }

  @LazySingleton()
  IsFavoriteUseCase isFavoriteUseCase(FavoritesRepository repository) {
    return IsFavoriteUseCase(repository);
  }

  @LazySingleton()
  GetFavoritesCountUseCase getFavoritesCountUseCase(FavoritesRepository repository) {
    return GetFavoritesCountUseCase(repository);
  }

  @LazySingleton()
  ClearFavoritesUseCase clearFavoritesUseCase(FavoritesRepository repository) {
    return ClearFavoritesUseCase(repository);
  }

  @LazySingleton()
  CreateFavoritesCollectionUseCase createFavoritesCollectionUseCase(FavoritesRepository repository) {
    return CreateFavoritesCollectionUseCase(repository);
  }

  @LazySingleton()
  GetFavoritesCollectionsUseCase getFavoritesCollectionsUseCase(FavoritesRepository repository) {
    return GetFavoritesCollectionsUseCase(repository);
  }

  @LazySingleton()
  OrganizeFavoritesUseCase organizeFavoritesUseCase(FavoritesRepository repository) {
    return OrganizeFavoritesUseCase(repository);
  }

  // Cubits
  @injectable
  FavoritesCubit favoritesCubit(
      GetFavoritesUseCase getFavoritesUseCase,
      AddToFavoritesUseCase addToFavoritesUseCase,
      RemoveFromFavoritesUseCase removeFromFavoritesUseCase,
      IsFavoriteUseCase isFavoriteUseCase,
      GetFavoritesCountUseCase getFavoritesCountUseCase,
      ClearFavoritesUseCase clearFavoritesUseCase,
      OrganizeFavoritesUseCase organizeFavoritesUseCase,
      ) {
    return FavoritesCubit(
      getFavoritesUseCase,
      addToFavoritesUseCase,
      removeFromFavoritesUseCase,
      isFavoriteUseCase,
      getFavoritesCountUseCase,
      clearFavoritesUseCase,
      organizeFavoritesUseCase,
    );
  }

  @injectable
  FavoritesCollectionsCubit favoritesCollectionsCubit(
      GetFavoritesCollectionsUseCase getCollectionsUseCase,
      CreateFavoritesCollectionUseCase createCollectionUseCase,
      OrganizeFavoritesUseCase organizeFavoritesUseCase,
      ) {
    return FavoritesCollectionsCubit(
      getCollectionsUseCase,
      createCollectionUseCase,
      organizeFavoritesUseCase,
    );
  }
}