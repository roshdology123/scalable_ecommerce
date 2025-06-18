import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final int productId;
  final String productTitle;
  final String productImage;
  final double price;
  final double originalPrice;
  final int quantity;
  final int maxQuantity;
  final String? selectedColor;
  final String? selectedSize;
  final Map<String, String> selectedVariants;
  final bool isAvailable;
  final bool inStock;
  final String? brand;
  final String? category;
  final String? sku;
  final double? discountPercentage;
  final double? discountAmount;
  final DateTime addedAt;
  final DateTime? updatedAt;
  final DateTime? lastPriceCheck;
  final bool priceChanged;
  final double? previousPrice;
  final bool isSelected;
  final String? specialOfferId;
  final Map<String, dynamic>? metadata;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.maxQuantity,
    this.selectedColor,
    this.selectedSize,
    required this.selectedVariants,
    required this.isAvailable,
    required this.inStock,
    this.brand,
    this.category,
    this.sku,
    this.discountPercentage,
    this.discountAmount,
    required this.addedAt,
    this.updatedAt,
    this.lastPriceCheck,
    this.priceChanged = false,
    this.previousPrice,
    this.isSelected = false,
    this.specialOfferId,
    this.metadata,
  });

  /// Business Logic Methods

  /// Get total price for this cart item (price × quantity)
  double get totalPrice => price * quantity;

  /// Get total original price for this cart item
  double get totalOriginalPrice => originalPrice * quantity;

  /// Get total discount amount for this cart item
  double get totalDiscountAmount => discountAmount != null
      ? discountAmount! * quantity
      : totalOriginalPrice - totalPrice;

  /// Get discount percentage for this item
  double get effectiveDiscountPercentage {
    if (discountPercentage != null) return discountPercentage!;
    if (originalPrice > price) {
      return ((originalPrice - price) / originalPrice) * 100;
    }
    return 0.0;
  }

  /// Check if item is on sale
  bool get isOnSale => originalPrice > price || discountPercentage != null;

  /// Check if item can be incremented
  bool get canIncrement => quantity < maxQuantity && inStock && isAvailable;

  /// Check if item can be decremented
  bool get canDecrement => quantity > 1;

  /// Check if item needs stock validation
  bool get needsStockValidation {
    final lastCheck = lastPriceCheck ?? addedAt;
    return DateTime.now().difference(lastCheck).inHours > 1;
  }

  /// Check if price needs validation
  bool get needsPriceValidation {
    final lastCheck = lastPriceCheck ?? addedAt;
    return DateTime.now().difference(lastCheck).inHours > 6;
  }

  /// Get variant display string
  String get variantDisplayString {
    if (selectedVariants.isEmpty) return '';

    final variants = <String>[];
    if (selectedColor != null) variants.add(selectedColor!);
    if (selectedSize != null) variants.add(selectedSize!);

    // Add other variants
    for (final entry in selectedVariants.entries) {
      if (entry.key != 'color' && entry.key != 'size') {
        variants.add('${entry.key}: ${entry.value}');
      }
    }

    return variants.join(' • ');
  }

  /// Get short variant display (for compact UI)
  String get shortVariantDisplay {
    final parts = <String>[];
    if (selectedColor != null) parts.add(selectedColor!);
    if (selectedSize != null) parts.add(selectedSize!);
    return parts.join(' / ');
  }

  /// Check if item has variants selected
  bool get hasVariantsSelected => selectedVariants.isNotEmpty;

  /// Check if two cart items represent the same product variant
  bool isSameProductVariant(CartItem other) {
    if (productId != other.productId) return false;
    if (selectedVariants.length != other.selectedVariants.length) return false;

    for (final entry in selectedVariants.entries) {
      if (other.selectedVariants[entry.key] != entry.value) return false;
    }

    return true;
  }

  /// Calculate savings per item
  double get savingsPerItem => originalPrice - price;

  /// Calculate total savings for this cart item
  double get totalSavings => savingsPerItem * quantity;

  /// Get formatted price string
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get formatted original price string
  String get formattedOriginalPrice => '\$${originalPrice.toStringAsFixed(2)}';

  /// Get formatted total price string
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Check if item is valid for checkout
  bool get isValidForCheckout => isAvailable && inStock && quantity > 0 && quantity <= maxQuantity;

  /// Get item age in hours
  int get ageInHours => DateTime.now().difference(addedAt).inHours;

  /// Check if item is recently added (within last hour)
  bool get isRecentlyAdded => ageInHours < 1;

  /// Get priority score for sorting (higher = more important)
  int get priorityScore {
    int score = 0;

    if (isRecentlyAdded) score += 100;
    if (isOnSale) score += 50;
    if (priceChanged) score += 75;
    if (!isAvailable) score -= 200;
    if (!inStock) score -= 150;

    return score;
  }

  CartItem copyWith({
    String? id,
    int? productId,
    String? productTitle,
    String? productImage,
    double? price,
    double? originalPrice,
    int? quantity,
    int? maxQuantity,
    String? selectedColor,
    String? selectedSize,
    Map<String, String>? selectedVariants,
    bool? isAvailable,
    bool? inStock,
    String? brand,
    String? category,
    String? sku,
    double? discountPercentage,
    double? discountAmount,
    DateTime? addedAt,
    DateTime? updatedAt,
    DateTime? lastPriceCheck,
    bool? priceChanged,
    double? previousPrice,
    bool? isSelected,
    String? specialOfferId,
    Map<String, dynamic>? metadata,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      isAvailable: isAvailable ?? this.isAvailable,
      inStock: inStock ?? this.inStock,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastPriceCheck: lastPriceCheck ?? this.lastPriceCheck,
      priceChanged: priceChanged ?? this.priceChanged,
      previousPrice: previousPrice ?? this.previousPrice,
      isSelected: isSelected ?? this.isSelected,
      specialOfferId: specialOfferId ?? this.specialOfferId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    productTitle,
    productImage,
    price,
    originalPrice,
    quantity,
    maxQuantity,
    selectedColor,
    selectedSize,
    selectedVariants,
    isAvailable,
    inStock,
    brand,
    category,
    sku,
    discountPercentage,
    discountAmount,
    addedAt,
    updatedAt,
    lastPriceCheck,
    priceChanged,
    previousPrice,
    isSelected,
    specialOfferId,
    metadata,
  ];

  @override
  String toString() => 'CartItem(id: $id, productId: $productId, title: $productTitle, '
      'quantity: $quantity, price: $price, variants: $selectedVariants)';
}