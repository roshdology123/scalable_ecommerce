import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorites_collection.dart';
import '../repositories/favorites_repository.dart';

class CreateFavoritesCollectionUseCase implements UseCase<FavoritesCollection, CreateFavoritesCollectionParams> {
  final FavoritesRepository repository;

  const CreateFavoritesCollectionUseCase(this.repository);

  @override
  Future<Either<Failure, FavoritesCollection>> call(CreateFavoritesCollectionParams params) async {
    try {
      // Validate collection name
      if (params.name.trim().isEmpty) {
        return Left(ValidationFailure.fieldRequired('name'));
      }

      // Check if collection with same name exists
      final existingCollections = await repository.getCollections();
      final nameExists = existingCollections.any((c) =>
      c.name.toLowerCase() == params.name.toLowerCase());

      if (nameExists) {
        return Left(ValidationFailure(
          message: 'A collection with this name already exists',
          code: 'DUPLICATE_NAME',
        ));
      }

      final collection = FavoritesCollection(
        id: _generateCollectionId(params.name),
        name: params.name,
        description: params.description,
        icon: params.icon,
        color: params.color,
        isSmartCollection: params.isSmartCollection,
        smartRules: params.smartRules,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: params.tags,
        metadata: params.metadata,
      );

      await repository.createCollection(collection);

      return Right(collection);
    } catch (e) {
      return Left(CacheFailure.writeError());
    }
  }

  String _generateCollectionId(String name) {
    final sanitizedName = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'collection_${sanitizedName}_$timestamp';
  }
}

class CreateFavoritesCollectionParams extends Equatable {
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final bool isSmartCollection;
  final Map<String, dynamic>? smartRules;
  final Map<String, String> tags;
  final Map<String, dynamic> metadata;

  const CreateFavoritesCollectionParams({
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.isSmartCollection = false,
    this.smartRules,
    this.tags = const {},
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    name,
    description,
    icon,
    color,
    isSmartCollection,
    smartRules,
    tags,
    metadata,
  ];
}