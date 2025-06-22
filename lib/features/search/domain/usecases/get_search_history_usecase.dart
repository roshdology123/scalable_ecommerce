import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_history.dart';
import '../repositories/search_repository.dart';

@injectable
class GetSearchHistoryUseCase extends UseCase<SearchHistory, NoParams> {
  final SearchRepository _repository;

  GetSearchHistoryUseCase(this._repository);

  @override
  Future<Either<Failure, SearchHistory>> call(NoParams params) async {
    return await _repository.getSearchHistory();
  }
}