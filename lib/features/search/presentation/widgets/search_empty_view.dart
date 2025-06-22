import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchEmptyView extends StatelessWidget {
  final String query;

  const SearchEmptyView({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              tr('search.no_results'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              tr('search.no_results_description'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (query.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '"$query"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),

            // Suggestions
            Text(
              'Try searching for:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                'electronics',
                'clothing',
                'books',
                'shoes',
                'accessories',
              ].map(
                    (suggestion) => ActionChip(
                  label: Text(suggestion),
                  onPressed: () {
                    // This would need to be handled by the parent widget
                    // to trigger a new search with the suggestion
                  },
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}