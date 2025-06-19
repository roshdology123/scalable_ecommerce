import 'package:flutter/material.dart';

class FavoritesEmptyState extends StatelessWidget {
  final bool hasSearch;
  final bool hasFilters;
  final VoidCallback? onClearFilters;
  final VoidCallback? onExploreProducts;

  const FavoritesEmptyState({
    super.key,
    this.hasSearch = false,
    this.hasFilters = false,
    this.onClearFilters,
    this.onExploreProducts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primaryContainer.withOpacity(0.1),
                    border: Border.all(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    hasSearch ? Icons.search_off : Icons.favorite_border,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            _getTitle(),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            _getDescription(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Action Buttons
          if (hasSearch || hasFilters) ...[
            FilledButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.clear),
              label: Text(hasSearch ? 'Clear Search' : 'Clear Filters'),
            ),
            const SizedBox(height: 12),
          ],

          OutlinedButton.icon(
            onPressed: onExploreProducts,
            icon: const Icon(Icons.explore),
            label: const Text('Browse Products'),
          ),

          const SizedBox(height: 24),

          // Helpful Tips
          if (!hasSearch && !hasFilters) _buildHelpfulTips(context),
        ],
      ),
    );
  }

  Widget _buildHelpfulTips(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'How to add favorites:',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            context,
            '1. Browse products and tap the ❤️ icon',
          ),
          const SizedBox(height: 8),
          _buildTipItem(
            context,
            '2. Long press products for quick actions',
          ),
          const SizedBox(height: 8),
          _buildTipItem(
            context,
            '3. Organize favorites into collections',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 8, right: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _getTitle() {
    if (hasSearch) {
      return 'No favorites found';
    } else if (hasFilters) {
      return 'No favorites match your filters';
    } else {
      return 'No favorites yet';
    }
  }

  String _getDescription() {
    if (hasSearch) {
      return 'Try searching for something else or browse all your favorites.';
    } else if (hasFilters) {
      return 'Try adjusting your filters or browse all favorites.';
    } else {
      return 'Start building your favorites list by liking products you love. They\'ll appear here for easy access.';
    }
  }
}