import 'package:equatable/equatable.dart';

import 'rating.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;
  final List<String> images;
  final String? brand;
  final String? sku;
  final int stock;
  final double? originalPrice;
  final double? discountPercentage;
  final List<String> tags;
  final bool isAvailable;
  final bool isFeatured;
  final bool isNew;
  final bool isOnSale;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? specifications;
  final List<String> colors;
  final List<String> sizes;
  final String? weight;
  final String? dimensions;
  final String? material;
  final String? warranty;
  final int viewCount;
  final int purchaseCount;
  final DateTime? lastViewedAt;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    this.images = const [],
    this.brand,
    this.sku,
    this.stock = 0,
    this.originalPrice,
    this.discountPercentage,
    this.tags = const [],
    this.isAvailable = true,
    this.isFeatured = false,
    this.isNew = false,
    this.isOnSale = false,
    this.createdAt,
    this.updatedAt,
    this.specifications,
    this.colors = const [],
    this.sizes = const [],
    this.weight,
    this.dimensions,
    this.material,
    this.warranty,
    this.viewCount = 0,
    this.purchaseCount = 0,
    this.lastViewedAt,
  });

  /// Get all product images (main + additional)
  List<String> get allImages {
    final List<String> allImages = [];
    if (image.isNotEmpty) allImages.add(image);
    allImages.addAll(images.where((img) => img != image));
    return allImages;
  }

  /// Get primary image (first available image)
  String get primaryImage => allImages.isNotEmpty ? allImages.first : '';

  /// Check if product is in stock
  bool get inStock => stock > 0;

  /// Check if product is out of stock
  bool get outOfStock => stock == 0;

  /// Check if product is low in stock (< 5 items)
  bool get lowStock => stock > 0 && stock < 5;

  /// Get stock status description
  String get stockStatus {
    if (outOfStock) return 'Out of Stock';
    if (lowStock) return 'Low Stock';
    if (stock < 10) return 'Limited Stock';
    return 'In Stock';
  }

  /// Get discount amount if on sale
  double get discountAmount {
    if (originalPrice != null && discountPercentage != null) {
      return originalPrice! - price;
    }
    return 0.0;
  }

  /// Get savings percentage
  double get savingsPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice!) * 100;
    }
    return discountPercentage ?? 0.0;
  }

  /// Get formatted price with currency
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get formatted original price
  String get formattedOriginalPrice =>
      originalPrice != null ? '\$${originalPrice!.toStringAsFixed(2)}' : '';

  /// Get formatted discount amount
  String get formattedDiscountAmount =>
      discountAmount > 0 ? '\$${discountAmount.toStringAsFixed(2)}' : '';

  /// Get short title (truncated to specified length)
  String getShortTitle([int maxLength = 50]) {
    if (title.length <= maxLength) return title;
    return '${title.substring(0, maxLength)}...';
  }

  /// Get short description
  String getShortDescription([int maxLength = 100]) {
    if (description.length <= maxLength) return description;
    return '${description.substring(0, maxLength)}...';
  }

  /// Check if product has multiple images
  bool get hasMultipleImages => allImages.length > 1;

  /// Check if product has colors
  bool get hasColors => colors.isNotEmpty;

  /// Check if product has sizes
  bool get hasSizes => sizes.isNotEmpty;

  /// Check if product has specifications
  bool get hasSpecifications => specifications != null && specifications!.isNotEmpty;

  /// Check if product is popular (high view count)
  bool get isPopular => viewCount >= 1000;

  /// Check if product is best seller (high purchase count)
  bool get isBestSeller => purchaseCount >= 100;

  /// Get product age in days
  int get ageInDays {
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt!).inDays;
  }

  /// Check if product was recently viewed
  bool get wasRecentlyViewed {
    if (lastViewedAt == null) return false;
    final difference = DateTime.now().difference(lastViewedAt!);
    return difference.inDays <= 7;
  }

  /// Get popularity score (combination of views, purchases, and rating)
  double get popularityScore {
    final viewScore = (viewCount / 100.0).clamp(0.0, 10.0);
    final purchaseScore = (purchaseCount / 10.0).clamp(0.0, 10.0);
    final ratingScore = rating.rate * 2; // Scale rating to 10

    return (viewScore + purchaseScore + ratingScore) / 3;
  }

  /// Get conversion rate (purchases / views)
  double get conversionRate {
    if (viewCount == 0) return 0.0;
    return (purchaseCount / viewCount) * 100;
  }

  /// Check if product matches search query
  bool matchesSearchQuery(String query) {
    if (query.isEmpty) return true;

    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        description.toLowerCase().contains(lowerQuery) ||
        category.toLowerCase().contains(lowerQuery) ||
        (brand?.toLowerCase().contains(lowerQuery) ?? false) ||
        tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  /// Check if product is within price range
  bool isWithinPriceRange(double? minPrice, double? maxPrice) {
    if (minPrice != null && price < minPrice) return false;
    if (maxPrice != null && price > maxPrice) return false;
    return true;
  }

  /// Check if product meets minimum rating
  bool meetsMinimumRating(double? minRating) {
    if (minRating == null) return true;
    return rating.rate >= minRating;
  }

  /// Get product badges (new, sale, featured, etc.)
  List<String> get badges {
    final List<String> badges = [];

    if (isNew) badges.add('New');
    if (isOnSale) badges.add('Sale');
    if (isFeatured) badges.add('Featured');
    if (isBestSeller) badges.add('Best Seller');
    if (isPopular) badges.add('Popular');
    if (lowStock) badges.add('Limited');
    if (outOfStock) badges.add('Out of Stock');

    return badges;
  }

  /// Get primary badge (most important badge)
  String? get primaryBadge {
    if (outOfStock) return 'Out of Stock';
    if (isOnSale) return 'Sale';
    if (isNew) return 'New';
    if (isFeatured) return 'Featured';
    if (isBestSeller) return 'Best Seller';
    if (lowStock) return 'Limited';
    return null;
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
    List<String>? images,
    String? brand,
    String? sku,
    int? stock,
    double? originalPrice,
    double? discountPercentage,
    List<String>? tags,
    bool? isAvailable,
    bool? isFeatured,
    bool? isNew,
    bool? isOnSale,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? specifications,
    List<String>? colors,
    List<String>? sizes,
    String? weight,
    String? dimensions,
    String? material,
    String? warranty,
    int? viewCount,
    int? purchaseCount,
    DateTime? lastViewedAt,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      tags: tags ?? this.tags,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      isNew: isNew ?? this.isNew,
      isOnSale: isOnSale ?? this.isOnSale,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specifications: specifications ?? this.specifications,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      material: material ?? this.material,
      warranty: warranty ?? this.warranty,
      viewCount: viewCount ?? this.viewCount,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    rating,
    images,
    brand,
    sku,
    stock,
    originalPrice,
    discountPercentage,
    tags,
    isAvailable,
    isFeatured,
    isNew,
    isOnSale,
    createdAt,
    updatedAt,
    specifications,
    colors,
    sizes,
    weight,
    dimensions,
    material,
    warranty,
    viewCount,
    purchaseCount,
    lastViewedAt,
  ];

  @override
  String toString() => 'Product(id: $id, title: $title, price: $price)';
}