import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_query.dart';
import '../repositories/search_repository.dart';

@injectable
class SaveSearchQueryUseCase extends UseCase<void, SaveSearchQueryParams> {
  final SearchRepository _repository;

  SaveSearchQueryUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveSearchQueryParams params) async {
    return await _repository.saveSearchQuery(params.searchQuery);
  }
}

class SaveSearchQueryParams extends Equatable {
  final SearchQuery searchQuery;

  const SaveSearchQueryParams({
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [searchQuery];

  @override
  String toString() {
    return 'SaveSearchQueryParams(searchQuery: $searchQuery)';
  }
}