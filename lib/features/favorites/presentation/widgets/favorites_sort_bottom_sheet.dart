import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';

class FavoritesSortBottomSheet extends StatefulWidget {
  final String currentSortBy;
  final String currentSortOrder;
  final Function(String sortBy, String sortOrder) onSortChanged;

  const FavoritesSortBottomSheet({
    super.key,
    required this.currentSortBy,
    required this.currentSortOrder,
    required this.onSortChanged,
  });

  @override
  State<FavoritesSortBottomSheet> createState() => _FavoritesSortBottomSheetState();
}

class _FavoritesSortBottomSheetState extends State<FavoritesSortBottomSheet> {
  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:25:19Z';
  final AppLogger _logger = AppLogger();

  late String _selectedSortBy;
  late String _selectedSortOrder;

  final List<Map<String, dynamic>> _sortOptions = [
    {
      'key': 'date_added',
      'label': 'Date Added',
      'icon': Icons.schedule,
      'description': 'Recently added first',
    },
    {
      'key': 'name',
      'label': 'Name',
      'icon': Icons.sort_by_alpha,
      'description': 'Alphabetical order',
    },
    {
      'key': 'price',
      'label': 'Price',
      'icon': Icons.attach_money,
      'description': 'Price low to high',
    },
    {
      'key': 'rating',
      'label': 'Rating',
      'icon': Icons.star,
      'description': 'Highest rated first',
    },
    {
      'key': 'category',
      'label': 'Category',
      'icon': Icons.category,
      'description': 'Group by category',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.currentSortBy;
    _selectedSortOrder = widget.currentSortOrder;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  Icons.sort,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sort Favorites',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Sort options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _sortOptions.length,
              itemBuilder: (context, index) {
                final option = _sortOptions[index];
                final isSelected = _selectedSortBy == option['key'];

                return _buildSortOption(
                  context,
                  option: option,
                  isSelected: isSelected,
                  onTap: () => _selectSortOption(option['key']),
                );
              },
            ),
          ),

          // Sort order toggle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort Order',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSortOrderButton(
                        context,
                        'Ascending',
                        'asc',
                        Icons.arrow_upward,
                        _getSortOrderDescription('asc'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSortOrderButton(
                        context,
                        'Descending',
                        'desc',
                        Icons.arrow_downward,
                        _getSortOrderDescription('desc'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              20 + MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _applySorting,
                child: const Text('Apply Sorting'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
      BuildContext context, {
        required Map<String, dynamic> option,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          option['icon'],
          color: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Text(
        option['label'],
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        option['description'],
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: colorScheme.primary,
      )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSortOrderButton(
      BuildContext context,
      String label,
      String order,
      IconData icon,
      String description,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedSortOrder == order;

    return InkWell(
      onTap: () => _selectSortOrder(order),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer.withOpacity(0.5)
              : colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getSortOrderDescription(String order) {
    switch (_selectedSortBy) {
      case 'date_added':
        return order == 'desc' ? 'Newest first' : 'Oldest first';
      case 'name':
        return order == 'asc' ? 'A to Z' : 'Z to A';
      case 'price':
        return order == 'asc' ? 'Low to High' : 'High to Low';
      case 'rating':
        return order == 'desc' ? 'High to Low' : 'Low to High';
      case 'category':
        return order == 'asc' ? 'A to Z' : 'Z to A';
      default:
        return order == 'asc' ? 'Ascending' : 'Descending';
    }
  }

  void _selectSortOption(String sortBy) {
    setState(() {
      _selectedSortBy = sortBy;
    });

    _logger.logUserAction('sort_option_selected', {
      'user': _userContext,
      'sort_by': sortBy,
      'timestamp': _currentTimestamp,
    });
  }

  void _selectSortOrder(String sortOrder) {
    setState(() {
      _selectedSortOrder = sortOrder;
    });

    _logger.logUserAction('sort_order_selected', {
      'user': _userContext,
      'sort_order': sortOrder,
      'timestamp': _currentTimestamp,
    });
  }

  void _applySorting() {
    widget.onSortChanged(_selectedSortBy, _selectedSortOrder);
    Navigator.of(context).pop();

    _logger.logUserAction('sort_applied', {
      'user': _userContext,
      'sort_by': _selectedSortBy,
      'sort_order': _selectedSortOrder,
      'timestamp': _currentTimestamp,
    });
  }
}