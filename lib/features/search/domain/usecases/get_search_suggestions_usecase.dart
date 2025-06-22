import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_suggestion.dart';
import '../repositories/search_repository.dart';

@injectable
class GetSearchSuggestionsUseCase extends UseCase<List<SearchSuggestion>, GetSearchSuggestionsParams> {
  final SearchRepository _repository;

  GetSearchSuggestionsUseCase(this._repository);

  @override
  Future<Either<Failure, List<SearchSuggestion>>> call(GetSearchSuggestionsParams params) async {
    return await _repository.getSearchSuggestions(
      query: params.query,
      limit: params.limit,
    );
  }
}

class GetSearchSuggestionsParams extends Equatable {
  final String query;
  final int limit;

  const GetSearchSuggestionsParams({
    required this.query,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [query, limit];
}