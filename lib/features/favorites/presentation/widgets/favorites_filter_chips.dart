import 'package:flutter/material.dart';

class FavoritesFilterChips extends StatelessWidget {
  final String searchQuery;
  final Map<String, dynamic> filters;
  final Function(String) onFilterRemoved;
  final VoidCallback? onClearAll;

  const FavoritesFilterChips({
    super.key,
    required this.searchQuery,
    required this.filters,
    required this.onFilterRemoved,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final chips = <Widget>[];

    // Search query chip
    if (searchQuery.isNotEmpty) {
      chips.add(_buildChip(
        context,
        'Search: "$searchQuery"',
        'search',
        icon: Icons.search,
      ));
    }

    // Filter chips
    filters.forEach((key, value) {
      if (value != null) {
        chips.add(_buildFilterChip(context, key, value));
      }
    });

    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (chips.length > 1)
                TextButton.icon(
                  onPressed: onClearAll,
                  icon: Icon(
                    Icons.clear_all,
                    size: 16,
                    color: colorScheme.error,
                  ),
                  label: Text(
                    'Clear All',
                    style: TextStyle(
                      color: colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
      BuildContext context,
      String label,
      String filterKey, {
        IconData? icon,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Chip(
      avatar: icon != null
          ? Icon(
        icon,
        size: 16,
        color: colorScheme.primary,
      )
          : null,
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      deleteIcon: Icon(
        Icons.close,
        size: 16,
        color: colorScheme.onPrimaryContainer,
      ),
      onDeleted: () => onFilterRemoved(filterKey),
      backgroundColor: colorScheme.primaryContainer,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildFilterChip(BuildContext context, String key, dynamic value) {
    String label;
    IconData? icon;

    switch (key) {
      case 'category':
        label = 'Category: ${_capitalizeFirst(value.toString())}';
        icon = Icons.category;
        break;
      case 'minPrice':
        label = 'Min: \$${value.toStringAsFixed(2)}';
        icon = Icons.attach_money;
        break;
      case 'maxPrice':
        label = 'Max: \$${value.toStringAsFixed(2)}';
        icon = Icons.attach_money;
        break;
      case 'minRating':
        label = 'Rating: ${value.toString()}+ ⭐';
        icon = Icons.star;
        break;
      case 'inStockOnly':
        if (value == true) {
          label = 'In Stock Only';
          icon = Icons.inventory;
        } else {
          return const SizedBox.shrink();
        }
        break;
      case 'onSaleOnly':
        if (value == true) {
          label = 'On Sale Only';
          icon = Icons.local_offer;
        } else {
          return const SizedBox.shrink();
        }
        break;
      case 'tags':
        if (value is List && (value).isNotEmpty) {
          final tags = value as List<String>;
          label = 'Tags: ${tags.join(', ')}';
          icon = Icons.label;
        } else {
          return const SizedBox.shrink();
        }
        break;
      default:
        label = '$key: $value';
        icon = Icons.filter_alt;
    }

    return _buildChip(context, label, key, icon: icon);
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}