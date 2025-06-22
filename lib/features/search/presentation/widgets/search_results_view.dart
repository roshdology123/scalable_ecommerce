import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/search_result.dart';
import 'product_search_item.dart';

class SearchResultsView extends StatefulWidget {
  final SearchResult searchResult;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final Function(int) onProductTap;

  const SearchResultsView({
    super.key,
    required this.searchResult,
    required this.hasReachedMax,
    this.isLoadingMore = false,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onProductTap,
  });

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax && !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  String _getResultsCountText() {
    final count = widget.searchResult.totalResults;
    if (count == 0) {
      return tr('search.results_count.zero');
    } else if (count == 1) {
      return tr('search.results_count.one');
    } else {
      return tr('search.results_count.other', namedArgs: {'count': count.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL =context.locale.languageCode == 'ar';

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Results Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('search.results'),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Text(
                        _getResultsCountText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (widget.searchResult.query.isNotEmpty) ...[
                        Text(
                          isRTL ? ' لـ "${widget.searchResult.query}"' : ' for "${widget.searchResult.query}"',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Products Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return ProductSearchItem(
                    product: widget.searchResult.products[index],
                    onTap: () => widget.onProductTap(widget.searchResult.products[index].id),
                  );
                },
                childCount: widget.searchResult.products.length,
              ),
            ),
          ),

          // Loading More Indicator
          if (widget.isLoadingMore)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // End of Results Message
          if (widget.hasReachedMax && widget.searchResult.products.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tr('search.end_of_results'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}