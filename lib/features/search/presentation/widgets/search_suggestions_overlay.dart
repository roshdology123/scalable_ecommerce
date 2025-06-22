import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/search_history_cubit/search_history_cubit.dart';
import '../cubit/search_history_cubit/search_history_state.dart';
import '../cubit/search_suggestion_cubit/search_suggestions_cubit.dart';
import '../cubit/search_suggestion_cubit/search_suggestions_state.dart';
import '../../domain/entities/search_suggestion.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final Function(String) onSuggestionTap;
  final VoidCallback onDismiss;

  const SearchSuggestionsOverlay({
    super.key,
    required this.onSuggestionTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 80), // Account for search bar height
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
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

                // Content
                Expanded(
                  child: BlocBuilder<SearchSuggestionsCubit, SearchSuggestionsState>(
                    builder: (context, suggestionsState) {
                      return BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
                        builder: (context, historyState) {
                          return _buildContent(context, suggestionsState, historyState);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      SearchSuggestionsState suggestionsState,
      SearchHistoryState historyState,
      ) {
    final isRTL = context.locale.languageCode == 'ar';

    return suggestionsState.when(
      initial: () => _buildInitialContent(context, historyState, isRTL),
      loading: () => _buildLoadingContent(context),
      loaded: (suggestions, query) => _buildSuggestionsContent(
        context,
        suggestions,
        query,
        historyState,
        isRTL,
      ),
      empty: (query) => _buildEmptyContent(context, query, historyState, isRTL),
      error: (message, code) => _buildErrorContent(context, message),
    );
  }

  Widget _buildInitialContent(
      BuildContext context,
      SearchHistoryState historyState,
      bool isRTL,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (historyState.hasData) ...[
            _buildSectionHeader(
              context,
              tr('search.recent_searches'),
              onClear: () {
                context.read<SearchHistoryCubit>().clearSearchHistory();
              },
              isRTL: isRTL,
            ),
            const SizedBox(height: 12),
            ...historyState.getRecentQueries(limit: 5).map(
                  (query) => _buildHistoryItem(context, query.query, isRTL),
            ),
            const SizedBox(height: 24),
          ],

          // Popular Searches
          _buildSectionHeader(context, tr('search.popular_searches'), isRTL: isRTL),
          const SizedBox(height: 12),
          ..._getPopularSearches().map(
                (term) => _buildSuggestionItem(
              context,
              SearchSuggestion(
                id: 'popular_$term',
                text: term,
                type: SuggestionType.popular,
                searchCount: 0,
                lastUsed: DateTime.now(),
              ),
              isRTL,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSuggestionsContent(
      BuildContext context,
      List<SearchSuggestion> suggestions,
      String query,
      SearchHistoryState historyState,
      bool isRTL,
      ) {
    // Group suggestions by type
    final productSuggestions = suggestions.where((s) => s.type == SuggestionType.product).toList();
    final categorySuggestions = suggestions.where((s) => s.type == SuggestionType.category).toList();
    final brandSuggestions = suggestions.where((s) => s.type == SuggestionType.brand).toList();
    final popularSuggestions = suggestions.where((s) => s.type == SuggestionType.popular).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Products Section
          if (productSuggestions.isNotEmpty) ...[
            _buildSectionHeader(context, tr('search.suggestions_types.product'), isRTL: isRTL),
            const SizedBox(height: 12),
            ...productSuggestions.map((suggestion) => _buildSuggestionItem(context, suggestion, isRTL)),
            const SizedBox(height: 20),
          ],

          // Categories Section
          if (categorySuggestions.isNotEmpty) ...[
            _buildSectionHeader(context, tr('search.suggestions_types.category'), isRTL: isRTL),
            const SizedBox(height: 12),
            ...categorySuggestions.map((suggestion) => _buildSuggestionItem(context, suggestion, isRTL)),
            const SizedBox(height: 20),
          ],

          // Brands Section
          if (brandSuggestions.isNotEmpty) ...[
            _buildSectionHeader(context, tr('search.suggestions_types.brand'), isRTL: isRTL),
            const SizedBox(height: 12),
            ...brandSuggestions.map((suggestion) => _buildSuggestionItem(context, suggestion, isRTL)),
            const SizedBox(height: 20),
          ],

          // Popular Searches
          if (popularSuggestions.isNotEmpty) ...[
            _buildSectionHeader(context, tr('search.suggestions_types.popular'), isRTL: isRTL),
            const SizedBox(height: 12),
            ...popularSuggestions.map((suggestion) => _buildSuggestionItem(context, suggestion, isRTL)),
            const SizedBox(height: 20),
          ],

          // Recent searches (if query is empty)
          if (query.isEmpty && historyState.hasData) ...[
            _buildSectionHeader(
              context,
              tr('search.recent_searches'),
              onClear: () {
                context.read<SearchHistoryCubit>().clearSearchHistory();
              },
              isRTL: isRTL,
            ),
            const SizedBox(height: 12),
            ...historyState.getRecentQueries(limit: 3).map(
                  (historyQuery) => _buildHistoryItem(context, historyQuery.query, isRTL),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyContent(
      BuildContext context,
      String query,
      SearchHistoryState historyState,
      bool isRTL,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            tr('search.no_results'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            tr('search.no_results_description'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          // Show recent searches if available
          if (historyState.hasData) ...[
            const SizedBox(height: 32),
            _buildSectionHeader(context, tr('search.recent_searches'), isRTL: isRTL),
            const SizedBox(height: 12),
            ...historyState.getRecentQueries(limit: 3).map(
                  (historyQuery) => _buildHistoryItem(context, historyQuery.query, isRTL),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              tr('search.error'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.read<SearchSuggestionsCubit>().getSuggestions('', immediate: true);
              },
              child: Text(tr('search.try_again')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context,
      String title, {
        VoidCallback? onClear,
        required bool isRTL,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isRTL) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              child: Text(tr('search.clear_history')),
            ),
        ] else ...[
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              child: Text(tr('search.clear_history')),
            ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuggestionItem(
      BuildContext context,
      SearchSuggestion suggestion,
      bool isRTL,
      ) {
    IconData iconData;
    switch (suggestion.type) {
      case SuggestionType.product:
        iconData = Icons.shopping_bag_outlined;
        break;
      case SuggestionType.category:
        iconData = Icons.category_outlined;
        break;
      case SuggestionType.brand:
        iconData = Icons.label_outlined;
        break;
      case SuggestionType.popular:
        iconData = Icons.trending_up;
        break;
      case SuggestionType.recent:
        iconData = Icons.history;
        break;
    }

    return InkWell(
      onTap: () => onSuggestionTap(suggestion.text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            if (!isRTL) ...[
              Icon(
                iconData,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  suggestion.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Icon(
                Icons.arrow_outward,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ] else ...[
              Icon(
                Icons.arrow_outward,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              Expanded(
                child: Text(
                  suggestion.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                iconData,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, String query, bool isRTL) {
    return InkWell(
      onTap: () => onSuggestionTap(query),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            if (!isRTL) ...[
              Icon(
                Icons.history,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  query,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<SearchHistoryCubit>().deleteSearchQuery(query);
                },
                icon: const Icon(Icons.close, size: 16),
                tooltip: tr('search.clear'),
              ),
            ] else ...[
              IconButton(
                onPressed: () {
                  context.read<SearchHistoryCubit>().deleteSearchQuery(query);
                },
                icon: const Icon(Icons.close, size: 16),
                tooltip: tr('search.clear'),
              ),
              Expanded(
                child: Text(
                  query,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.history,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<String> _getPopularSearches() {
    return [
      'iPhone',
      'laptop',
      'headphones',
      'watch',
      'shoes',
    ];
  }
}