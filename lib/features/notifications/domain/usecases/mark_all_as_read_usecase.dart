import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../repositories/notification_repository.dart';

@injectable
class MarkAllAsReadUseCase implements UseCase<void, MarkAllAsReadParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  MarkAllAsReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(MarkAllAsReadParams params) async {
    _logger.logUserAction('mark_all_as_read_usecase_started', {
      'user_id': params.userId,
      'user': 'roshdology123',
      'timestamp': '2025-06-23 08:39:37',
    });

    final result = await _repository.markAllAsRead(userId: params.userId);

    return result.fold(
          (failure) {
        _logger.logErrorWithContext(
          'MarkAllAsReadUseCase',
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
          (_) {
        _logger.logUserAction('mark_all_as_read_usecase_success', {
          'user_id': params.userId,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        });
        return const Right(null);
      },
    );
  }
}

class MarkAllAsReadParams extends Equatable {
  final String userId;

  const MarkAllAsReadParams({required this.userId});

  @override
  List<Object> get props => [userId];
}