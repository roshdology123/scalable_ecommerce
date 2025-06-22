import 'package:flutter/material.dart';

class FavoritesAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;
  final VoidCallback? onViewModeToggle;
  final VoidCallback? onCollectionsTap;

  const FavoritesAppBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    this.onFilterTap,
    this.onSortTap,
    this.onViewModeToggle,
    this.onCollectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.only(top: 126),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'My Favorites',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: onCollectionsTap,
                icon: const Icon(
                  Icons.folder_outlined,
                  color: Colors.white,
                ),
                tooltip: 'Collections',
              ),
              IconButton(
                onPressed: onViewModeToggle,
                icon: const Icon(
                  Icons.view_module,
                  color: Colors.white,
                ),
                tooltip: 'Change view',
              ),
              IconButton(
                onPressed: onSortTap,
                icon: const Icon(
                  Icons.sort,
                  color: Colors.white,
                ),
                tooltip: 'Sort',
              ),
              IconButton(
                onPressed: onFilterTap,
                icon: const Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ),
                tooltip: 'Filter',
              ),
            ],
          ),
        ],
      ),
    );
  }
}