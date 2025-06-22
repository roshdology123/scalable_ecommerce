import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

@injectable
class GetPopularSearchesUseCase extends UseCase<List<String>, GetPopularSearchesParams> {
  final SearchRepository _repository;

  GetPopularSearchesUseCase(this._repository);

  @override
  Future<Either<Failure, List<String>>> call(GetPopularSearchesParams params) async {
    return await _repository.getPopularSearches(limit: params.limit);
  }
}

class GetPopularSearchesParams extends Equatable {
  final int limit;

  const GetPopularSearchesParams({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}