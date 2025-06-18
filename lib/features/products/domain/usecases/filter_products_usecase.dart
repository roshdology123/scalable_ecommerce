import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';

@injectable
class FilterProductsUseCase implements UseCase<List<Product>, FilterProductsParams> {
  @override
  Future<Either<Failure, List<Product>>> call(FilterProductsParams params) async {
    try {
      List<Product> filteredProducts = List.from(params.products);

      // Apply category filter
      if (params.category != null && params.category!.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) =>
        product.category.toLowerCase() == params.category!.toLowerCase())
            .toList();
      }

      // Apply price range filter
      if (params.minPrice != null || params.maxPrice != null) {
        filteredProducts = filteredProducts
            .where((product) =>
            product.isWithinPriceRange(params.minPrice, params.maxPrice))
            .toList();
      }

      // Apply rating filter
      if (params.minRating != null) {
        filteredProducts = filteredProducts
            .where((product) => product.meetsMinimumRating(params.minRating))
            .toList();
      }

      // Apply brand filter
      if (params.brands != null && params.brands!.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) =>
        product.brand != null &&
            params.brands!.contains(product.brand!.toLowerCase()))
            .toList();
      }

      // Apply availability filter
      if (params.inStockOnly == true) {
        filteredProducts = filteredProducts
            .where((product) => product.inStock)
            .toList();
      }

      // Apply sale filter
      if (params.onSaleOnly == true) {
        filteredProducts = filteredProducts
            .where((product) => product.isOnSale)
            .toList();
      }

      // Apply featured filter
      if (params.featuredOnly == true) {
        filteredProducts = filteredProducts
            .where((product) => product.isFeatured)
            .toList();
      }

      // Apply new arrivals filter
      if (params.newArrivalsOnly == true) {
        filteredProducts = filteredProducts
            .where((product) => product.isNew)
            .toList();
      }

      // Apply color filter
      if (params.colors != null && params.colors!.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) =>
            product.colors.any((color) =>
                params.colors!.contains(color.toLowerCase())))
            .toList();
      }

      // Apply size filter
      if (params.sizes != null && params.sizes!.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) =>
            product.sizes.any((size) =>
                params.sizes!.contains(size.toLowerCase())))
            .toList();
      }

      // Apply sorting
      if (params.sortBy != null) {
        filteredProducts = _sortProducts(filteredProducts, params.sortBy!, params.sortOrder);
      }

      return Right(filteredProducts);
    } catch (e) {
      return Left(ValidationFailure(
        message: 'Failed to filter products: ${e.toString()}',
        code: 'FILTER_ERROR',
      ));
    }
  }

  List<Product> _sortProducts(List<Product> products, String sortBy, String? sortOrder) {
    final isAscending = sortOrder?.toLowerCase() != 'desc';

    switch (sortBy.toLowerCase()) {
      case 'price':
        products.sort((a, b) => isAscending
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price));
        break;

      case 'rating':
        products.sort((a, b) => isAscending
            ? a.rating.rate.compareTo(b.rating.rate)
            : b.rating.rate.compareTo(a.rating.rate));
        break;

      case 'title':
      case 'name':
        products.sort((a, b) => isAscending
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;

      case 'created_at':
      case 'date':
        products.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.now();
          final bDate = b.createdAt ?? DateTime.now();
          return isAscending
              ? aDate.compareTo(bDate)
              : bDate.compareTo(aDate);
        });
        break;

      case 'popularity':
        products.sort((a, b) => isAscending
            ? a.popularityScore.compareTo(b.popularityScore)
            : b.popularityScore.compareTo(a.popularityScore));
        break;

      case 'discount':
        products.sort((a, b) => isAscending
            ? a.discountPercentage!.compareTo(b.discountPercentage!)
            : b.discountPercentage!.compareTo(a.discountPercentage!));
        break;

      default:
      // Default sort by popularity (descending)
        products.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
    }

    return products;
  }
}

class FilterProductsParams extends Equatable {
  final List<Product> products;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final List<String>? brands;
  final List<String>? colors;
  final List<String>? sizes;
  final bool? inStockOnly;
  final bool? onSaleOnly;
  final bool? featuredOnly;
  final bool? newArrivalsOnly;
  final String? sortBy;
  final String? sortOrder;

  const FilterProductsParams({
    required this.products,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.brands,
    this.colors,
    this.sizes,
    this.inStockOnly,
    this.onSaleOnly,
    this.featuredOnly,
    this.newArrivalsOnly,
    this.sortBy,
    this.sortOrder,
  });

  /// Get all active filters as a map
  Map<String, dynamic> get activeFilters {
    final filters = <String, dynamic>{};

    if (category != null) filters['category'] = category;
    if (minPrice != null) filters['minPrice'] = minPrice;
    if (maxPrice != null) filters['maxPrice'] = maxPrice;
    if (minRating != null) filters['minRating'] = minRating;
    if (brands != null && brands!.isNotEmpty) filters['brands'] = brands;
    if (colors != null && colors!.isNotEmpty) filters['colors'] = colors;
    if (sizes != null && sizes!.isNotEmpty) filters['sizes'] = sizes;
    if (inStockOnly == true) filters['inStockOnly'] = true;
    if (onSaleOnly == true) filters['onSaleOnly'] = true;
    if (featuredOnly == true) filters['featuredOnly'] = true;
    if (newArrivalsOnly == true) filters['newArrivalsOnly'] = true;

    return filters;
  }

  /// Check if any filters are active
  bool get hasActiveFilters => activeFilters.isNotEmpty;

  /// Get count of active filters
  int get activeFilterCount => activeFilters.length;

  FilterProductsParams copyWith({
    List<Product>? products,
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? brands,
    List<String>? colors,
    List<String>? sizes,
    bool? inStockOnly,
    bool? onSaleOnly,
    bool? featuredOnly,
    bool? newArrivalsOnly,
    String? sortBy,
    String? sortOrder,
  }) {
    return FilterProductsParams(
      products: products ?? this.products,
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      brands: brands ?? this.brands,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      onSaleOnly: onSaleOnly ?? this.onSaleOnly,
      featuredOnly: featuredOnly ?? this.featuredOnly,
      newArrivalsOnly: newArrivalsOnly ?? this.newArrivalsOnly,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Clear all filters
  FilterProductsParams clearFilters() {
    return FilterProductsParams(products: products);
  }

  @override
  List<Object?> get props => [
    products,
    category,
    minPrice,
    maxPrice,
    minRating,
    brands,
    colors,
    sizes,
    inStockOnly,
    onSaleOnly,
    featuredOnly,
    newArrivalsOnly,
    sortBy,
    sortOrder,
  ];

  @override
  String toString() => 'FilterProductsParams(${products.length} products, $activeFilterCount filters)';
}