import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';

class FavoritesFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FavoritesFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FavoritesFilterBottomSheet> createState() => _FavoritesFilterBottomSheetState();
}

class _FavoritesFilterBottomSheetState extends State<FavoritesFilterBottomSheet> {
  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:25:19Z';
  final AppLogger _logger = AppLogger();

  late Map<String, dynamic> _filters;

  final List<String> _categories = [
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing",
  ];

  final List<String> _quickTags = [
    'sale',
    'new',
    'highly_rated',
    'price_drop',
    'out_of_stock',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Filter Favorites',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: const Text('Clear All'),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Filter content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Category filter
                    _buildCategoryFilter(context),

                    const SizedBox(height: 24),

                    // Price range filter
                    _buildPriceRangeFilter(context),

                    const SizedBox(height: 24),

                    // Rating filter
                    _buildRatingFilter(context),

                    const SizedBox(height: 24),

                    // Quick filters
                    _buildQuickFilters(context),

                    const SizedBox(height: 24),

                    // Tags filter
                    _buildTagsFilter(context),
                  ],
                ),
              ),

              // Apply button
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20 + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters (${_getActiveFilterCount()})'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _filters['category'] == category;
            return FilterChip(
              label: Text(_capitalizeFirst(category)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _filters['category'] = category;
                  } else {
                    _filters.remove('category');
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final minPrice = (_filters['minPrice'] as num?)?.toDouble() ?? 0.0;
    final maxPrice = (_filters['maxPrice'] as num?)?.toDouble() ?? 1000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '\$${minPrice.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: RangeSlider(
                values: RangeValues(minPrice, maxPrice),
                min: 0,
                max: 1000,
                divisions: 20,
                labels: RangeLabels(
                  '\$${minPrice.toStringAsFixed(0)}',
                  '\$${maxPrice.toStringAsFixed(0)}',
                ),
                onChanged: (values) {
                  setState(() {
                    _filters['minPrice'] = values.start;
                    _filters['maxPrice'] = values.end;
                  });
                },
              ),
            ),
            Text(
              '\$${maxPrice.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingFilter(BuildContext context) {
    final theme = Theme.of(context);

    final minRating = (_filters['minRating'] as num?)?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 1; i <= 5; i++)
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (minRating == i.toDouble()) {
                        _filters.remove('minRating');
                      } else {
                        _filters['minRating'] = i.toDouble();
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: minRating >= i
                          ? theme.colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.star,
                          color: minRating >= i
                              ? Colors.amber
                              : theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$i+',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickFilters(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Filters',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('In Stock Only'),
                subtitle: const Text('Hide out of stock items'),
                value: _filters['inStockOnly'] == true,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _filters['inStockOnly'] = true;
                    } else {
                      _filters.remove('inStockOnly');
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('On Sale Only'),
                subtitle: const Text('Items with discounts'),
                value: _filters['onSaleOnly'] == true,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _filters['onSaleOnly'] = true;
                    } else {
                      _filters.remove('onSaleOnly');
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsFilter(BuildContext context) {
    final theme = Theme.of(context);

    final selectedTags = (_filters['tags'] as List<String>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickTags.map((tag) {
            final isSelected = selectedTags.contains(tag);
            return FilterChip(
              label: Text(_formatTagLabel(tag)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final tags = List<String>.from(selectedTags);
                  if (selected) {
                    tags.add(tag);
                  } else {
                    tags.remove(tag);
                  }

                  if (tags.isNotEmpty) {
                    _filters['tags'] = tags;
                  } else {
                    _filters.remove('tags');
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatTagLabel(String tag) {
    switch (tag) {
      case 'price_drop':
        return 'Price Drop';
      case 'highly_rated':
        return 'Highly Rated';
      case 'out_of_stock':
        return 'Out of Stock';
      default:
        return _capitalizeFirst(tag);
    }
  }

  int _getActiveFilterCount() {
    return _filters.length;
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
    });

    _logger.logUserAction('filters_cleared', {
      'user': _userContext,
      'timestamp': _currentTimestamp,
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.of(context).pop();

    _logger.logUserAction('filters_applied', {
      'user': _userContext,
      'filter_count': _filters.length,
      'filters': _filters.keys.toList(),
      'timestamp': _currentTimestamp,
    });
  }
}