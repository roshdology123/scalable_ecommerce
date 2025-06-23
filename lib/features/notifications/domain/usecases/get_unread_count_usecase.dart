import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetUnreadCountUseCase implements UseCase<int, GetUnreadCountParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  GetUnreadCountUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(GetUnreadCountParams params) async {
    _logger.logBusinessLogic(
      'get_unread_count_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    final result = await _repository.getUnreadCount(userId: params.userId);

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'GetUnreadCountUseCase',
          failure,
          StackTrace.current,
          {
            'user_id': params.userId,
            'failure_type': failure.runtimeType.toString(),
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Left(failure);
      },
          (count) {
        _logger.logBusinessLogic(
          'get_unread_count_usecase_success',
          'usecase_execution',
          {
            'user_id': params.userId,
            'unread_count': count,
            'user': 'roshdology123',
            'timestamp': '2025-06-23 08:39:37',
          },
        );
        return Right(count);
      },
    );
  }
}

class GetUnreadCountParams extends Equatable {
  final String userId;

  const GetUnreadCountParams({required this.userId});

  @override
  List<Object> get props => [userId];
}