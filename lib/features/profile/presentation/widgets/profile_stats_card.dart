import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/profile_stats/profile_stats_cubit.dart';
import '../cubit/profile_stats/profile_stats_state.dart';


/// Profile Stats Card Widget displaying user statistics
///
/// Features:
/// - Order statistics and completion rates
/// - Spending analytics and loyalty tier
/// - Member engagement metrics
/// - Interactive elements for detailed stats
class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: BlocBuilder<ProfileStatsCubit, ProfileStatsState>(
        builder: (context, state) {
          if (state is ProfileStatsLoading) {
            return _buildLoadingState(theme);
          }

          if (state is ProfileStatsError) {
            return _buildErrorState(theme, state.message);
          }

          if (state is ProfileStatsLoaded ||
              state is ProfileStatsRefreshed ||
              state is ProfileStatsAnalyzed) {
            final stats = (state is ProfileStatsLoaded)
                ? state.stats
                : (state is ProfileStatsRefreshed)
                ? state.stats
                : (state as ProfileStatsAnalyzed).stats;

            return _buildStatsContent(context, theme, stats);
          }

          return _buildEmptyState(theme);
        },
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Stats',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Loading your statistics...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Stats',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 32,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text(
                  'Unable to load stats',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Stats',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Start shopping to see your stats!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContent(BuildContext context, ThemeData theme, dynamic stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with View Details button
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Stats',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/profile/stats'),
                child: const Text('View Details'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Loyalty Tier Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: _getTierGradient(theme, stats.loyaltyTier),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getTierIcon(stats.loyaltyTier),
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  '${stats.loyaltyTier} Member',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme,
                  icon: Icons.shopping_bag_outlined,
                  label: 'Orders',
                  value: '${stats.totalOrders}',
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  theme,
                  icon: Icons.attach_money,
                  label: 'Spent',
                  value: stats.formattedTotalSpent,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme,
                  icon: Icons.star_outline,
                  label: 'Points',
                  value: '${stats.loyaltyPoints}',
                  color: theme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  theme,
                  icon: Icons.trending_up,
                  label: 'Success Rate',
                  value: '${stats.completionRate.toStringAsFixed(0)}%',
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress to Next Tier (if applicable)
          if (stats.pointsToNextTier > 0) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Next Tier: ${stats.nextTierName}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _getTierProgress(stats),
                    backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.pointsToNextTier} points to go',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Member Since
          Text(
            'Member for ${stats.membershipDuration} • Last order ${stats.daysSinceLastOrder} days ago',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      ThemeData theme, {
        required IconData icon,
        required String label,
        required String value,
        required Color color,
      }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getTierGradient(ThemeData theme, String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return const LinearGradient(
          colors: [Color(0xFFE5E4E2), Color(0xFFC0C0C0)],
        );
      case 'gold':
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        );
      case 'silver':
        return const LinearGradient(
          colors: [Color(0xFFC0C0C0), Color(0xFF999999)],
        );
      default: // Bronze
        return const LinearGradient(
          colors: [Color(0xFFCD7F32), Color(0xFFB87333)],
        );
    }
  }

  IconData _getTierIcon(String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return Icons.diamond;
      case 'gold':
        return Icons.emoji_events;
      case 'silver':
        return Icons.star;
      default: // Bronze
        return Icons.local_fire_department;
    }
  }

  double _getTierProgress(dynamic stats) {
    // Calculate progress based on current points and points to next tier
    final currentPoints = stats.loyaltyPoints;
    final pointsToNext = stats.pointsToNextTier;

    if (pointsToNext == 0) return 1.0; // Already at max tier

    // Estimate tier thresholds
    int currentTierThreshold;
    switch (stats.loyaltyTier.toLowerCase()) {
      case 'bronze':
        currentTierThreshold = 0;
        break;
      case 'silver':
        currentTierThreshold = 300;
        break;
      case 'gold':
        currentTierThreshold = 1000;
        break;
      default:
        currentTierThreshold = 0;
    }

    final nextTierThreshold = currentTierThreshold + pointsToNext;
    final progressInTier = currentPoints - currentTierThreshold;
    final tierRange = nextTierThreshold - currentTierThreshold;

    return (progressInTier / tierRange).clamp(0.0, 1.0);
  }
}