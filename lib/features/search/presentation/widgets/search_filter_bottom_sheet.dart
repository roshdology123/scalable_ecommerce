import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/search_filter/search_filter_cubit.dart';
import '../cubit/search_filter/search_filter_state.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const SearchFilterBottomSheet({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<SearchFilterBottomSheet> createState() => _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  String? _sortBy;
  String? _sortOrder;

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  void _loadCurrentFilters() {
    final state = context.read<SearchFilterCubit>().state;
    state.maybeWhen(
      loaded: (categories, selectedCategory, minPrice, maxPrice, minRating, sortBy, sortOrder) {
        setState(() {
          _selectedCategory = selectedCategory;
          _minPrice = minPrice;
          _maxPrice = maxPrice;
          _minRating = minRating;
          _sortBy = sortBy;
          _sortOrder = sortOrder;
        });
      },
      orElse: () {},
    );
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'category': _selectedCategory,
      'minPrice': _minPrice,
      'maxPrice': _maxPrice,
      'minRating': _minRating,
      'sortBy': _sortBy,
      'sortOrder': _sortOrder,
    };

    // Update filter cubit
    final filterCubit = context.read<SearchFilterCubit>();
    filterCubit.updateCategory(_selectedCategory);
    filterCubit.updatePriceRange(_minPrice, _maxPrice);
    filterCubit.updateMinRating(_minRating);
    filterCubit.updateSort(_sortBy, _sortOrder);

    widget.onApplyFilters(filters);
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _minPrice = null;
      _maxPrice = null;
      _minRating = null;
      _sortBy = null;
      _sortOrder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isRTL) ...[
                      Text(
                        tr('search.filters.title'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearFilters,
                        child: Text(tr('search.filters.clear')),
                      ),
                    ] else ...[
                      TextButton(
                        onPressed: _clearFilters,
                        child: Text(tr('search.filters.clear')),
                      ),
                      Text(
                        tr('search.filters.title'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Divider(height: 1),

              // Filter Content
              Expanded(
                child: BlocBuilder<SearchFilterCubit, SearchFilterState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const Center(child: Text('Loading filters...')),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      loaded: (categories, selectedCategory, minPrice, maxPrice, minRating, sortBy, sortOrder) {
                        return _buildFilterContent(context, categories, scrollController, isRTL);
                      },
                      error: (message, code) => Center(
                        child: Text(
                          'Error loading filters: $message',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        child: Text(tr('search.filters.apply')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterContent(
      BuildContext context,
      List<String> categories,
      ScrollController scrollController,
      bool isRTL,
      ) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Category Filter
          _buildSectionTitle(context, tr('search.filters.category'), isRTL),
          const SizedBox(height: 12),
          _buildCategoryFilter(context, categories, isRTL),

          const SizedBox(height: 24),

          // Price Range Filter
          _buildSectionTitle(context, tr('search.filters.price_range'), isRTL),
          const SizedBox(height: 12),
          _buildPriceRangeFilter(context, isRTL),

          const SizedBox(height: 24),

          // Rating Filter
          _buildSectionTitle(context, tr('search.filters.rating'), isRTL),
          const SizedBox(height: 12),
          _buildRatingFilter(context, isRTL),

          const SizedBox(height: 24),

          // Sort Options
          _buildSectionTitle(context, tr('search.sort'), isRTL),
          const SizedBox(height: 12),
          _buildSortOptions(context, isRTL),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isRTL) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      textAlign: isRTL ? TextAlign.right : TextAlign.left,
    );
  }

  Widget _buildCategoryFilter(BuildContext context, List<String> categories, bool isRTL) {
    return Column(
      children: [
        // All Categories option
        RadioListTile<String?>(
          title: Text(
            tr('search.filters.all_categories'),
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
          ),
          value: null,
          groupValue: _selectedCategory,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),

        // Individual categories
        ...categories.map(
              (category) => RadioListTile<String>(
            title: Text(
              category,
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
            ),
            value: category,
            groupValue: _selectedCategory,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(BuildContext context, bool isRTL) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: tr('search.filters.min_price'),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                initialValue: _minPrice?.toString() ?? '',
                onChanged: (value) {
                  setState(() {
                    _minPrice = double.tryParse(value);
                  });
                },
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: tr('search.filters.max_price'),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                initialValue: _maxPrice?.toString() ?? '',
                onChanged: (value) {
                  setState(() {
                    _maxPrice = double.tryParse(value);
                  });
                },
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingFilter(BuildContext context, bool isRTL) {
    const ratingOptions = [1.0, 2.0, 3.0, 4.0, 4.5];

    return Column(
      children: ratingOptions.map(
            (rating) => RadioListTile<double>(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                rating.floor(),
                    (index) => Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber[600],
                ),
              ),
              if (rating % 1 != 0)
                Icon(
                  Icons.star_half,
                  size: 16,
                  color: Colors.amber[600],
                ),
              const SizedBox(width: 8),
              Text('${rating.toStringAsFixed(1)}+'),
            ],
          ),
          value: rating,
          groupValue: _minRating,
          onChanged: (value) {
            setState(() {
              _minRating = value;
            });
          },
        ),
      ).toList(),
    );
  }

  Widget _buildSortOptions(BuildContext context, bool isRTL) {
    final sortOptions = [
      {'value': 'relevance', 'label': tr('search.sort_options.relevance')},
      {'value': 'price_low_high', 'label': tr('search.sort_options.price_low_high')},
      {'value': 'price_high_low', 'label': tr('search.sort_options.price_high_low')},
      {'value': 'rating', 'label': tr('search.sort_options.rating')},
      {'value': 'newest', 'label': tr('search.sort_options.newest')},
      {'value': 'popularity', 'label': tr('search.sort_options.popularity')},
    ];

    return Column(
      children: sortOptions.map(
            (option) => RadioListTile<String>(
          title: Text(
            option['label']!,
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
          ),
          value: option['value']!,
          groupValue: _sortBy,
          onChanged: (value) {
            setState(() {
              _sortBy = value;
              // Set sort order based on selection
              if (value == 'price_high_low' || value == 'rating') {
                _sortOrder = 'desc';
              } else {
                _sortOrder = 'asc';
              }
            });
          },
        ),
      ).toList(),
    );
  }
}