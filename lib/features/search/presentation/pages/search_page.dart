import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../cubit/search_cubit/search_cubit.dart';
import '../cubit/search_filter/search_filter_cubit.dart';
import '../cubit/search_history_cubit/search_history_cubit.dart';
import '../cubit/search_suggestion_cubit/search_suggestions_cubit.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_body.dart';
import '../widgets/search_filter_bottom_sheet.dart';
import '../widgets/search_suggestions_overlay.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SearchCubit>()),
        BlocProvider(create: (_) => getIt<SearchSuggestionsCubit>()),
        BlocProvider(create: (_) => getIt<SearchHistoryCubit>()..loadSearchHistory()),
        BlocProvider(create: (_) => getIt<SearchFilterCubit>()..loadFilterOptions()),
      ],
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

@override
State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _searchController.addListener(_onSearchTextChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _searchFocusNode.hasFocus;
    });

    if (_searchFocusNode.hasFocus) {
      // Show suggestions when focused
      context.read<SearchSuggestionsCubit>().getSuggestions(
        _searchController.text,
        immediate: true,
      );
    }
  }

  void _onSearchTextChange() {
    final query = _searchController.text;

    if (query.isNotEmpty) {
      // Get suggestions with debouncing
      context.read<SearchSuggestionsCubit>().getSuggestions(query);
    } else {
      // Show popular suggestions for empty query
      context.read<SearchSuggestionsCubit>().getSuggestions('', immediate: true);
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    // Hide suggestions
    setState(() {
      _showSuggestions = false;
    });

    // Remove focus
    _searchFocusNode.unfocus();

    // Add to history
    context.read<SearchHistoryCubit>().addSearchQuery(query);

    // Perform search
    context.read<SearchCubit>().searchProducts(
      query: query,
      immediate: true,
      refresh: true,
    );
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (innerCTX) => BlocProvider.value(
        value: context.read<SearchFilterCubit>(),
        child: SearchFilterBottomSheet(
          onApplyFilters: (filters) {
            final currentQuery = context.read<SearchCubit>().currentQuery;
            if (currentQuery.isNotEmpty) {
              context.read<SearchCubit>().applyFilters(
                category: filters['category'],
                minPrice: filters['minPrice'],
                maxPrice: filters['maxPrice'],
                minRating: filters['minRating'],
                sortBy: filters['sortBy'],
                sortOrder: filters['sortOrder'],
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SearchAppBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onSearch: _performSearch,
                onFilterTap: _showFilterBottomSheet,
                showBackButton: false, // No back button since this is a main tab
              ),
              Expanded(
                child: SearchBody(
                  onLoadMore: () {
                    context.read<SearchCubit>().loadMoreResults();
                  },
                  onRefresh: () async {
                    await context.read<SearchCubit>().refresh();
                  },
                  onProductTap: (productId) {
                    // Navigate to product details using Go Router
                    context.push('/home/product/$productId');
                  },
                ),
              ),
            ],
          ),

          // Suggestions Overlay
          if (_showSuggestions)
            SearchSuggestionsOverlay(
              onSuggestionTap: _onSuggestionTap,
              onDismiss: () {
                setState(() {
                  _showSuggestions = false;
                });
              },
            ),
        ],
      ),
    );
  }
}