import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

@injectable
class DeleteSearchQueryUseCase extends UseCase<void, DeleteSearchQueryParams> {
  final SearchRepository _repository;

  DeleteSearchQueryUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteSearchQueryParams params) async {
    return await _repository.deleteSearchQuery(params.queryId);
  }
}

class DeleteSearchQueryParams extends Equatable {
  final String queryId;

  const DeleteSearchQueryParams({
    required this.queryId,
  });

  @override
  List<Object?> get props => [queryId];

  @override
  String toString() {
    return 'DeleteSearchQueryParams(queryId: $queryId)';
  }
}