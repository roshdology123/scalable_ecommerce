import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notification_stats_cubit.dart';
import '../cubit/notification_stats_state.dart';
import '../widgets/notification_stats_widget.dart';
import '../widgets/notification_error_widget.dart';

class NotificationAnalyticsPage extends StatelessWidget {
  const NotificationAnalyticsPage({super.key});

  void _onPeriodSelected(BuildContext context, StatsPeriod period) {
    context.read<NotificationStatsCubit>().loadStatsForPeriod(period);
  }

  void _onExport(BuildContext context) {
    context.read<NotificationStatsCubit>().exportNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<NotificationStatsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification Analytics'),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              tooltip: 'Export',
              onPressed: () => _onExport(context),
            ),
          ],
        ),
        body: BlocBuilder<NotificationStatsCubit, NotificationStatsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError) {
              return NotificationErrorWidget(
                message: state.errorMessage,
                onRetry: () => context.read<NotificationStatsCubit>().refreshStats(),
              );
            }
            if (!state.hasData || state.stats == null) {
              return const Center(child: Text('No analytics data available.'));
            }
            return Column(
              children: [
                // Period selection tabs
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: StatsPeriod.values.map((period) {
                        final label = switch (period) {
                          StatsPeriod.today => "Today",
                          StatsPeriod.thisWeek => "This Week",
                          StatsPeriod.thisMonth => "This Month",
                          StatsPeriod.last30Days => "Last 30d",
                          StatsPeriod.last3Months => "3mo",
                          StatsPeriod.last6Months => "6mo",
                          StatsPeriod.thisYear => "Year",
                        };
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: state.periodDescription == label,
                            onSelected: (_) => _onPeriodSelected(context, period),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: NotificationStatsWidget(
                    stats: state.stats!,
                    lastUpdated: state.lastUpdated,
                    recommendations: state.getRecommendations(),
                    periodDescription: state.periodDescription,
                    comparison: state.isComparison
                        ? (state.currentPeriodStats, state.previousPeriodStats, state.comparisonChanges)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}