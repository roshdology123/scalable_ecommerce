import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:scalable_ecommerce/core/usecases/usecase.dart';

import '../../../../../core/utils/debouncer.dart';
import '../../../../products/domain/entities/product.dart';
import '../../../../products/domain/entities/category.dart';
import '../../../../products/domain/usecases/get_products_usecase.dart';
import '../../../../products/domain/usecases/get_categories_usecase.dart';
import '../../../domain/entities/search_suggestion.dart';
import 'search_suggestions_state.dart';

@injectable
class SearchSuggestionsCubit extends Cubit<SearchSuggestionsState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  SearchSuggestionsCubit(
      this._getProductsUseCase,
      this._getCategoriesUseCase,
      ) : super(const SearchSuggestionsState.initial());

  /// Get search suggestions with debouncing
  void getSuggestions(String query, {bool immediate = false}) {
    if (immediate) {
      _performGetSuggestions(query);
    } else {
      _debouncer.call(() => _performGetSuggestions(query));
    }
  }

  /// Perform the actual suggestions fetch
  Future<void> _performGetSuggestions(String query) async {
    if (query.trim().isEmpty) {
      // For empty query, show popular/recent suggestions
      await _getPopularSuggestions();
      return;
    }

    emit(const SearchSuggestionsState.loading());

    try {
      final suggestions = <SearchSuggestion>[];

      // Get products and categories separately to avoid type casting issues
      final productsResult = await _getProductsUseCase(const GetProductsParams(limit: 100));
      final categoriesResult = await _getCategoriesUseCase(const NoParams());

      // Process products
      productsResult.fold(
            (failure) {
          // Continue with other suggestions even if products fail
        },
            (products) {
          final matchingProducts = products.where((product) {
            final queryLower = query.toLowerCase();
            return product.title.toLowerCase().contains(queryLower) ||
                product.description.toLowerCase().contains(queryLower) ||
                product.category.toLowerCase().contains(queryLower) ||
                (product.brand?.toLowerCase().contains(queryLower) ?? false);
          }).toList();

          // Add product suggestions (limit to 5)
          final productSuggestions = matchingProducts
              .take(5)
              .map((product) => SearchSuggestion(
            id: 'product_${product.id}',
            text: product.title,
            type: SuggestionType.product,
            searchCount: product.viewCount,
            lastUsed: product.lastViewedAt ?? DateTime.now(),
            category: product.category,
            imageUrl: product.image,
          ))
              .toList();

          suggestions.addAll(productSuggestions);

          // Add brand suggestions
          final brands = matchingProducts
              .where((product) => product.brand != null)
              .map((product) => product.brand!)
              .toSet()
              .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
              .take(2);

          final brandSuggestions = brands
              .map((brand) => SearchSuggestion(
            id: 'brand_$brand',
            text: brand,
            type: SuggestionType.brand,
            searchCount: 0,
            lastUsed: DateTime.now(),
          ))
              .toList();

          suggestions.addAll(brandSuggestions);
        },
      );

      // Process categories
      categoriesResult.fold(
            (failure) {
          // Continue even if categories fail
        },
            (categories) {
          final matchingCategories = categories.where((category) {
            final queryLower = query.toLowerCase();
            return category.name.toLowerCase().contains(queryLower) ||
                category.displayName.toLowerCase().contains(queryLower) ||
                (category.description?.toLowerCase().contains(queryLower) ?? false);
          }).take(3);

          final categorySuggestions = matchingCategories
              .map((category) => SearchSuggestion(
            id: 'category_${category.id}',
            text: category.displayName, // Using displayName for better UX
            type: SuggestionType.category,
            searchCount: category.productCount, // Use product count as search indicator
            lastUsed: category.updatedAt ?? DateTime.now(),
            category: category.name,
            imageUrl: category.image,
          ))
              .toList();

          suggestions.addAll(categorySuggestions);
        },
      );

      if (suggestions.isEmpty) {
        emit(SearchSuggestionsState.empty(query));
      } else {
        // Sort suggestions by relevance (search count, type priority)
        suggestions.sort((a, b) {
          // Prioritize exact matches
          final aExact = a.text.toLowerCase() == query.toLowerCase() ? 1 : 0;
          final bExact = b.text.toLowerCase() == query.toLowerCase() ? 1 : 0;
          if (aExact != bExact) return bExact.compareTo(aExact);

          // Then by type priority
          final typePriority = {
            SuggestionType.product: 4,
            SuggestionType.category: 3,
            SuggestionType.brand: 2,
            SuggestionType.recent: 1,
            SuggestionType.popular: 0,
          };

          final aPriority = typePriority[a.type] ?? 0;
          final bPriority = typePriority[b.type] ?? 0;
          if (aPriority != bPriority) return bPriority.compareTo(aPriority);

          // Then by search count (for categories, this will be product count)
          return b.searchCount.compareTo(a.searchCount);
        });

        emit(SearchSuggestionsState.loaded(
          suggestions.take(10).toList(),
          query,
        ));
      }
    } catch (e) {
      emit(SearchSuggestionsState.error(
        'Failed to get search suggestions: ${e.toString()}',
        'GET_SUGGESTIONS_ERROR',
      ));
    }
  }

  /// Get popular suggestions for empty query
  Future<void> _getPopularSuggestions() async {
    try {
      final suggestions = <SearchSuggestion>[];

      // Get categories to show as popular suggestions
      final categoriesResult = await _getCategoriesUseCase(const NoParams());

      categoriesResult.fold(
            (failure) {
          // Fall back to hardcoded popular terms
          _addHardcodedPopularSuggestions(suggestions);
        },
            (categories) {
          // Add popular categories (sorted by product count)
          final popularCategories = categories
              .where((category) => category.isActive && category.hasProducts)
              .toList()
            ..sort((a, b) => b.productCount.compareTo(a.productCount));

          final categorySuggestions = popularCategories
              .take(5)
              .map((category) => SearchSuggestion(
            id: 'popular_category_${category.id}',
            text: category.displayName,
            type: SuggestionType.popular,
            searchCount: category.productCount,
            lastUsed: DateTime.now(),
            category: category.name,
            imageUrl: category.image,
          ))
              .toList();

          suggestions.addAll(categorySuggestions);

          // Add some popular search terms
          _addHardcodedPopularSuggestions(suggestions);
        },
      );

      emit(SearchSuggestionsState.loaded(suggestions, ''));
    } catch (e) {
      // Fall back to hardcoded suggestions
      final suggestions = <SearchSuggestion>[];
      _addHardcodedPopularSuggestions(suggestions);
      emit(SearchSuggestionsState.loaded(suggestions, ''));
    }
  }

  /// Add hardcoded popular search terms
  void _addHardcodedPopularSuggestions(List<SearchSuggestion> suggestions) {
    final popularTerms = [
      'iPhone',
      'laptop',
      'headphones',
      'watch',
      'shoes',
      'bag',
      'dress',
      'jeans',
      'tablet',
      'camera',
    ];

    final popularSuggestions = popularTerms
        .map((term) => SearchSuggestion(
      id: 'popular_term_$term',
      text: term,
      type: SuggestionType.popular,
      searchCount: 0,
      lastUsed: DateTime.now(),
    ))
        .toList();

    suggestions.addAll(popularSuggestions);
  }

  /// Get suggestions for a specific category
  Future<void> getCategorySuggestions(String categoryId) async {
    emit(const SearchSuggestionsState.loading());

    try {
      // Get products from specific category
      final productsResult = await _getProductsUseCase(
        GetProductsParams(category: categoryId, limit: 20),
      );

      productsResult.fold(
            (failure) => emit(SearchSuggestionsState.error(
          'Failed to get category suggestions: ${failure.message}',
          failure.code,
        )),
            (products) {
          final suggestions = products
              .map((product) => SearchSuggestion(
            id: 'category_product_${product.id}',
            text: product.title,
            type: SuggestionType.product,
            searchCount: product.viewCount,
            lastUsed: product.lastViewedAt ?? DateTime.now(),
            category: product.category,
            imageUrl: product.image,
          ))
              .toList();

          emit(SearchSuggestionsState.loaded(suggestions, ''));
        },
      );
    } catch (e) {
      emit(SearchSuggestionsState.error(
        'Failed to get category suggestions: ${e.toString()}',
        'GET_CATEGORY_SUGGESTIONS_ERROR',
      ));
    }
  }

  /// Clear suggestions
  void clearSuggestions() {
    _debouncer.cancel();
    emit(const SearchSuggestionsState.initial());
  }

  /// Update suggestion usage (for analytics)
  void updateSuggestionUsage(SearchSuggestion suggestion) {
    // This could be implemented to track suggestion usage
    // For now, we'll just emit the current state
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}