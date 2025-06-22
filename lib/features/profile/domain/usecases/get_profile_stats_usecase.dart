import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_stats.dart';
import '../repositories/profile_repository.dart';

/// Use case for retrieving user profile statistics and activity data
///
/// This use case handles:
/// - Fetching stats from remote server when online
/// - Falling back to cached stats when offline
/// - Calculating derived metrics and analytics
/// - Providing insights into user behavior
///
/// The stats include:
/// - Order history and completion rates
/// - Spending patterns and total amounts
/// - Review activity and ratings
/// - Membership duration and loyalty points
/// - Engagement metrics and activity scores
///
/// Usage:
/// ```dart
/// final result = await getProfileStatsUseCase(NoParams());
/// result.fold(
///   (failure) => handleError(failure),
///   (stats) => displayUserStats(stats),
/// );
/// ```
@injectable
class GetProfileStatsUseCase extends UseCase<ProfileStats, NoParams> {
  final ProfileRepository _repository;

  GetProfileStatsUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileStats>> call(NoParams params) async {
    try {
      debugPrint('Fetching profile stats for roshdology123');

      final result = await _repository.getProfileStats();

      return result.fold(
            (failure) {
          debugPrint('GetProfileStatsUseCase failed: ${failure.message}');

          // If it's a cache failure, return default stats for new user
          if (failure is CacheFailure) {
            debugPrint('No cached stats found, returning default stats');
            final defaultStats = ProfileStats.newUser('11'); // roshdology123's ID
            return Right(defaultStats);
          }

          return Left(failure);
        },
            (stats) {
          debugPrint('Profile stats retrieved successfully');

          // Validate stats data
          if (stats.userId.isEmpty) {
            debugPrint('Invalid stats data: empty user ID');
            return const Left(ValidationFailure(
              message: 'Invalid profile stats data received',
              code: 'INVALID_STATS_DATA',
            ));
          }

          // Log stats summary for debugging
          _logStatsSummary(stats);

          return Right(stats);
        },
      );
    } catch (e) {
      debugPrint('Unexpected error in GetProfileStatsUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while getting profile stats: ${e.toString()}',
        code: 'GET_STATS_UNKNOWN_ERROR',
      ));
    }
  }

  /// Logs a summary of user stats for debugging
  void _logStatsSummary(ProfileStats stats) {
    debugPrint('Profile Stats Summary:');
    debugPrint('  Total Orders: ${stats.totalOrders}');
    debugPrint('  Completed Orders: ${stats.completedOrders}');
    debugPrint('  Total Spent: ${stats.formattedTotalSpent}');
    debugPrint('  Loyalty Tier: ${stats.loyaltyTier}');
    debugPrint('  Member Since: ${stats.membershipDuration}');
    debugPrint('  Customer Segment: ${stats.customerSegment}');
    debugPrint('  Engagement Level: ${stats.engagementLevel}');
    debugPrint('  Completion Rate: ${stats.completionRate.toStringAsFixed(1)}%');
  }
}