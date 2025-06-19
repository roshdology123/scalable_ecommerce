import 'package:equatable/equatable.dart';

class FavoriteItem extends Equatable {
  final String id;
  final int productId;
  final String productTitle;
  final String productImage;
  final double price;
  final double? originalPrice;
  final String category;
  final String? brand;
  final double rating;
  final bool isAvailable;
  final bool inStock;
  final DateTime addedAt;
  final DateTime? updatedAt;
  final DateTime? priceUpdatedAt;
  final double? previousPrice;
  final bool priceDropped;
  final String? collectionId;
  final Map<String, String> tags;
  final int viewCount;
  final DateTime? lastViewedAt;
  final bool isPriceTrackingEnabled;
  final double? targetPrice;
  final String? notes;
  final Map<String, dynamic> metadata;

  const FavoriteItem({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.price,
    this.originalPrice,
    required this.category,
    this.brand,
    required this.rating,
    required this.isAvailable,
    required this.inStock,
    required this.addedAt,
    this.updatedAt,
    this.priceUpdatedAt,
    this.previousPrice,
    this.priceDropped = false,
    this.collectionId,
    this.tags = const {},
    this.viewCount = 0,
    this.lastViewedAt,
    this.isPriceTrackingEnabled = false,
    this.targetPrice,
    this.notes,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    productTitle,
    productImage,
    price,
    originalPrice,
    category,
    brand,
    rating,
    isAvailable,
    inStock,
    addedAt,
    updatedAt,
    priceUpdatedAt,
    previousPrice,
    priceDropped,
    collectionId,
    tags,
    viewCount,
    lastViewedAt,
    isPriceTrackingEnabled,
    targetPrice,
    notes,
    metadata,
  ];

  FavoriteItem copyWith({
    String? id,
    int? productId,
    String? productTitle,
    String? productImage,
    double? price,
    double? originalPrice,
    String? category,
    String? brand,
    double? rating,
    bool? isAvailable,
    bool? inStock,
    DateTime? addedAt,
    DateTime? updatedAt,
    DateTime? priceUpdatedAt,
    double? previousPrice,
    bool? priceDropped,
    String? collectionId,
    Map<String, String>? tags,
    int? viewCount,
    DateTime? lastViewedAt,
    bool? isPriceTrackingEnabled,
    double? targetPrice,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      isAvailable: isAvailable ?? this.isAvailable,
      inStock: inStock ?? this.inStock,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      priceUpdatedAt: priceUpdatedAt ?? this.priceUpdatedAt,
      previousPrice: previousPrice ?? this.previousPrice,
      priceDropped: priceDropped ?? this.priceDropped,
      collectionId: collectionId ?? this.collectionId,
      tags: tags ?? this.tags,
      viewCount: viewCount ?? this.viewCount,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      isPriceTrackingEnabled: isPriceTrackingEnabled ?? this.isPriceTrackingEnabled,
      targetPrice: targetPrice ?? this.targetPrice,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }

  // Business Logic Methods
  bool get isOnSale => originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!isOnSale) return 0.0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  double get discountAmount => isOnSale ? originalPrice! - price : 0.0;

  bool get hasRecentPriceDrop {
    if (!priceDropped || priceUpdatedAt == null) return false;
    final daysSincePriceDrop = DateTime.now().difference(priceUpdatedAt!).inDays;
    return daysSincePriceDrop <= 7; // Recent if within last week
  }

  bool get shouldNotifyPriceDrop {
    if (!isPriceTrackingEnabled || targetPrice == null) return false;
    return price <= targetPrice!;
  }

  bool get isRecentlyViewed {
    if (lastViewedAt == null) return false;
    final daysSinceViewed = DateTime.now().difference(lastViewedAt!).inDays;
    return daysSinceViewed <= 3;
  }

  bool get isFrequentlyViewed => viewCount >= 5;

  String get priceChangeIndicator {
    if (previousPrice == null) return '';
    if (price < previousPrice!) return '↓';
    if (price > previousPrice!) return '↑';
    return '→';
  }

  Duration get timeSinceAdded => DateTime.now().difference(addedAt);

  bool get isNewFavorite => timeSinceAdded.inDays <= 1;

  String get availabilityStatus {
    if (!isAvailable) return 'unavailable';
    if (!inStock) return 'out_of_stock';
    return 'available';
  }

  // Helper methods for UI
  String getFormattedPrice({String currencySymbol = '\$'}) {
    return '$currencySymbol${price.toStringAsFixed(2)}';
  }

  String? getFormattedOriginalPrice({String currencySymbol = '\$'}) {
    if (originalPrice == null) return null;
    return '$currencySymbol${originalPrice!.toStringAsFixed(2)}';
  }

  String getFormattedDiscount() {
    if (!isOnSale) return '';
    return '-${discountPercentage.toStringAsFixed(0)}%';
  }

  List<String> getAutoTags() {
    final autoTags = <String>[];

    if (isOnSale) autoTags.add('sale');
    if (isNewFavorite) autoTags.add('new');
    if (isFrequentlyViewed) autoTags.add('popular');
    if (hasRecentPriceDrop) autoTags.add('price_drop');
    if (!inStock) autoTags.add('out_of_stock');
    if (rating >= 4.5) autoTags.add('highly_rated');
    if (isPriceTrackingEnabled) autoTags.add('price_tracking');

    return autoTags;
  }

  Map<String, dynamic> toAnalytics() {
    return {
      'product_id': productId,
      'category': category,
      'brand': brand,
      'price': price,
      'is_on_sale': isOnSale,
      'discount_percentage': discountPercentage,
      'rating': rating,
      'view_count': viewCount,
      'days_since_added': timeSinceAdded.inDays,
      'has_price_tracking': isPriceTrackingEnabled,
      'collection_id': collectionId,
      'tags': [...tags.values, ...getAutoTags()],
    };
  }
}