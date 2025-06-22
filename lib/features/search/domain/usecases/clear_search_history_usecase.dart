import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

@injectable
class ClearSearchHistoryUseCase extends UseCase<void, NoParams> {
  final SearchRepository _repository;

  ClearSearchHistoryUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.clearSearchHistory();
  }
}