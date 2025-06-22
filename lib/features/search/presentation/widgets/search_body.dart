import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scalable_ecommerce/features/search/presentation/widgets/search_empty_view.dart';
import 'package:scalable_ecommerce/features/search/presentation/widgets/search_error_view.dart';
import 'package:scalable_ecommerce/features/search/presentation/widgets/search_initial_view.dart';
import 'package:scalable_ecommerce/features/search/presentation/widgets/search_loading_view.dart';

import '../cubit/search_cubit/search_cubit.dart';
import '../cubit/search_cubit/search_state.dart';
import 'search_results_view.dart';

class SearchBody extends StatelessWidget {
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final Function(int) onProductTap;

  const SearchBody({
    super.key,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SearchInitialView(),

          loading: () => const SearchLoadingView(),

          loaded: (searchResult, hasReachedMax, currentPage, category, sortBy) {
            return SearchResultsView(
              searchResult: searchResult,
              hasReachedMax: hasReachedMax,
              onLoadMore: onLoadMore,
              onRefresh: onRefresh,
              onProductTap: onProductTap,
            );
          },

          loadingMore: (searchResult, hasReachedMax, currentPage, category, sortBy) {
            return SearchResultsView(
              searchResult: searchResult,
              hasReachedMax: hasReachedMax,
              isLoadingMore: true,
              onLoadMore: onLoadMore,
              onRefresh: onRefresh,
              onProductTap: onProductTap,
            );
          },

          empty: (query) => SearchEmptyView(query: query),

          error: (message, code) => SearchErrorView(
            message: message,
            onRetry: () async {
              final searchCubit = context.read<SearchCubit>();
              if (searchCubit.currentQuery.isNotEmpty) {
                await onRefresh();
              }
            },
          ),
        );
      },
    );
  }
}