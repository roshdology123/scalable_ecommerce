import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/search_history_cubit/search_history_cubit.dart';
import '../cubit/search_history_cubit/search_history_state.dart';


class SearchInitialView extends StatelessWidget {
  const SearchInitialView({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Welcome Section
          const SizedBox(height: 32),
          Icon(
            Icons.search,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            tr('search.empty_query'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 8),
          Text(
            'Discover thousands of products',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
          ),

          const SizedBox(height: 48),

          // Quick Actions
          _buildQuickActions(context, isRTL),

          const SizedBox(height: 32),

          // Recent Searches
          BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
            builder: (context, state) {
              if (state.hasData) {
                return _buildRecentSearches(context, state, isRTL);
              }
              return const SizedBox.shrink();
            },
          ),

          // Popular Categories
          const SizedBox(height: 32),
          _buildPopularCategories(context, isRTL),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isRTL) {
    return Column(
      crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.mic,
                title: tr('search.voice_search'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Voice search coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.camera_alt,
                title: tr('search.camera_search'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Camera search coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(
      BuildContext context,
      SearchHistoryState state,
      bool isRTL,
      ) {
    final recentQueries = state.getRecentQueries(limit: 5);

    return Column(
      crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isRTL) ...[
              Text(
                tr('search.recent_searches'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<SearchHistoryCubit>().clearSearchHistory();
                },
                child: Text(tr('search.clear_history')),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  context.read<SearchHistoryCubit>().clearSearchHistory();
                },
                child: Text(tr('search.clear_history')),
              ),
              Text(
                tr('search.recent_searches'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        ...recentQueries.map(
              (query) => ListTile(
            leading: Icon(
              Icons.history,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(query.query),
            onTap: () {
              // Trigger search for this query
              // This would need to be handled by the parent widget
            },
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.read<SearchHistoryCubit>().deleteSearchQuery(query.query);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularCategories(BuildContext context, bool isRTL) {
    final popularCategories = [
      {'name': 'Electronics', 'icon': Icons.devices},
      {'name': 'Fashion', 'icon': Icons.checkroom},
      {'name': 'Home & Garden', 'icon': Icons.home},
      {'name': 'Sports', 'icon': Icons.sports_basketball},
    ];

    return Column(
      crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: popularCategories.length,
          itemBuilder: (context, index) {
            final category = popularCategories[index];
            return Card(
              child: InkWell(
                onTap: () {
                  // Trigger category search
                  // This would need to be handled by the parent widget
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category['name'] as String,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}