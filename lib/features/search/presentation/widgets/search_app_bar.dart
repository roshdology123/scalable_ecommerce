import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

import '../cubit/search_cubit/search_cubit.dart';
import '../cubit/search_filter/search_filter_cubit.dart';
import '../cubit/search_filter/search_filter_state.dart';


class SearchAppBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSearch;
  final VoidCallback onFilterTap;
  final bool showBackButton;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSearch,
    required this.onFilterTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = context.locale.languageCode == 'ar';

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                // Back Button (only show if needed)
                if (showBackButton) ...[
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      isRTL ? Icons.arrow_forward : Icons.arrow_back,
                    ),
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  ),
                  const SizedBox(width: 8),
                ],

                // Search Field
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textDirection: isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                    decoration: InputDecoration(
                      hintText: tr('search.hint'),
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Clear Button
                          if (controller.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                controller.clear();
                                context.read<SearchCubit>().clearSearch();
                              },
                              icon: const Icon(Icons.clear),
                              tooltip: tr('search.clear'),
                            ),

                          // Voice Search Button
                          IconButton(
                            onPressed: () {
                              // TODO: Implement voice search
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(tr('search.voice_search')),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.mic),
                            tooltip: tr('search.voice_search'),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: onSearch,
                  ),
                ),

                const SizedBox(width: 8),

                // Filter Button
                BlocBuilder<SearchFilterCubit, SearchFilterState>(
                  builder: (context, state) {
                    final hasActiveFilters = context.read<SearchFilterCubit>().hasActiveFilters;

                    return Stack(
                      children: [
                        IconButton(
                          onPressed: onFilterTap,
                          icon: Icon(
                            Icons.tune,
                            color: hasActiveFilters
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          tooltip: tr('search.filter'),
                        ),

                        // Active filters indicator
                        if (hasActiveFilters)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

            // Active Filters Chips
            BlocBuilder<SearchFilterCubit, SearchFilterState>(
              builder: (context, state) {
                final filterCubit = context.read<SearchFilterCubit>();
                if (!filterCubit.hasActiveFilters) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Active filters count chip
                      Chip(
                        label: Text(
                          tr('search.filters.active_filters', namedArgs: {
                            'count': filterCubit.activeFilterCount.toString()
                          }),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          filterCubit.clearFilters();
                          // Refresh search with no filters
                          final searchCubit = context.read<SearchCubit>();
                          if (searchCubit.currentQuery.isNotEmpty) {
                            searchCubit.refresh();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}