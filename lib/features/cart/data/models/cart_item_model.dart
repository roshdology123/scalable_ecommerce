import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/cart_item.dart';
import '../../../products/data/models/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
@HiveType(typeId: 10)
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    @HiveField(0) required String id,
    @HiveField(1) required int productId,
    @HiveField(2) required String productTitle,
    @HiveField(3) required String productImage,
    @HiveField(4) required double price,
    @HiveField(5) required double originalPrice,
    @HiveField(6) required int quantity,
    @HiveField(7) required int maxQuantity,
    @HiveField(8) String? selectedColor,
    @HiveField(9) String? selectedSize,
    @HiveField(10) required Map<String, String> selectedVariants,
    @HiveField(11) required bool isAvailable,
    @HiveField(12) required bool inStock,
    @HiveField(13) String? brand,
    @HiveField(14) String? category,
    @HiveField(15) String? sku,
    @HiveField(16) double? discountPercentage,
    @HiveField(17) double? discountAmount,
    @HiveField(18) required DateTime addedAt,
    @HiveField(19) DateTime? updatedAt,
    @HiveField(20) DateTime? lastPriceCheck,
    @HiveField(21) @Default(false) bool priceChanged,
    @HiveField(22) double? previousPrice,
    @HiveField(23) @Default(false) bool isSelected,
    @HiveField(24) String? specialOfferId,
    @HiveField(25) Map<String, dynamic>? metadata,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Ensure we have a proper Map<String, dynamic>
    final safeJson = _ensureStringKeyMap(json);

    return CartItemModel(
      id: safeJson['id']?.toString() ?? '',
      productId: safeJson['productId'] as int? ?? safeJson['product_id'] as int? ?? 0,
      productTitle: safeJson['productTitle']?.toString() ?? safeJson['product_title']?.toString() ?? '',
      productImage: safeJson['productImage']?.toString() ?? safeJson['product_image']?.toString() ?? '',
      price: (safeJson['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (safeJson['originalPrice'] as num?)?.toDouble() ??
          (safeJson['original_price'] as num?)?.toDouble() ??
          (safeJson['price'] as num?)?.toDouble() ?? 0.0,
      quantity: safeJson['quantity'] as int? ?? 1,
      maxQuantity: safeJson['maxQuantity'] as int? ?? safeJson['max_quantity'] as int? ?? 999,
      selectedColor: safeJson['selectedColor']?.toString() ?? safeJson['selected_color']?.toString(),
      selectedSize: safeJson['selectedSize']?.toString() ?? safeJson['selected_size']?.toString(),
      selectedVariants: _extractVariants(safeJson),
      isAvailable: safeJson['isAvailable'] as bool? ?? safeJson['is_available'] as bool? ?? true,
      inStock: safeJson['inStock'] as bool? ?? safeJson['in_stock'] as bool? ?? true,
      brand: safeJson['brand']?.toString(),
      category: safeJson['category']?.toString(),
      sku: safeJson['sku']?.toString(),
      discountPercentage: (safeJson['discountPercentage'] as num?)?.toDouble() ??
          (safeJson['discount_percentage'] as num?)?.toDouble(),
      discountAmount: (safeJson['discountAmount'] as num?)?.toDouble() ??
          (safeJson['discount_amount'] as num?)?.toDouble(),
      addedAt: _parseDateTime(safeJson['addedAt'] ?? safeJson['added_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(safeJson['updatedAt'] ?? safeJson['updated_at']),
      lastPriceCheck: _parseDateTime(safeJson['lastPriceCheck'] ?? safeJson['last_price_check']),
      priceChanged: safeJson['priceChanged'] as bool? ?? safeJson['price_changed'] as bool? ?? false,
      previousPrice: (safeJson['previousPrice'] as num?)?.toDouble() ??
          (safeJson['previous_price'] as num?)?.toDouble(),
      isSelected: safeJson['isSelected'] as bool? ?? safeJson['is_selected'] as bool? ?? false,
      specialOfferId: safeJson['specialOfferId']?.toString() ?? safeJson['special_offer_id']?.toString(),
      metadata: safeJson['metadata'] != null ? _ensureStringKeyMap(safeJson['metadata']) : null,
    );
  }

  /// Create CartItemModel from Fake Store API product format
  /// API format: { productId: 1, quantity: 4 }
  factory CartItemModel.fromFakeStoreApiProduct(Map<String, dynamic> json) {
    final productId = json['productId'] as int? ?? json['id'] as int? ?? 0;
    final quantity = json['quantity'] as int? ?? 1;

    return CartItemModel(
      id: _generateCartItemId(productId, {}),
      productId: productId,
      productTitle: 'Product $productId', // Will be updated when product details are fetched
      productImage: '',
      price: 0.0, // Will be updated when product details are fetched
      originalPrice: 0.0,
      quantity: quantity,
      maxQuantity: 999,
      selectedVariants: {},
      isAvailable: true,
      inStock: true,
      addedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory CartItemModel.fromProduct({
    required ProductModel product,
    required int quantity,
    String? selectedColor,
    String? selectedSize,
    Map<String, String>? additionalVariants,
  }) {
    final variants = <String, String>{};
    if (selectedColor != null) variants['color'] = selectedColor;
    if (selectedSize != null) variants['size'] = selectedSize;
    if (additionalVariants != null) variants.addAll(additionalVariants);

    return CartItemModel(
      id: _generateCartItemId(product.id, variants),
      productId: product.id,
      productTitle: product.title,
      productImage: product.image,
      price: product.price,
      originalPrice: product.originalPrice ?? product.price,
      quantity: quantity,
      maxQuantity: product.stock,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      selectedVariants: variants,
      isAvailable: product.isAvailable,
      inStock: product.stock > 0,
      brand: product.brand,
      category: product.category,
      sku: product.sku,
      discountPercentage: product.discountPercentage,
      discountAmount: product.toProduct().discountAmount,
      addedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastPriceCheck: DateTime.now(),
    );
  }

  factory CartItemModel.fromCartItem(CartItem cartItem) {
    return CartItemModel(
      id: cartItem.id,
      productId: cartItem.productId,
      productTitle: cartItem.productTitle,
      productImage: cartItem.productImage,
      price: cartItem.price,
      originalPrice: cartItem.originalPrice,
      quantity: cartItem.quantity,
      maxQuantity: cartItem.maxQuantity,
      selectedColor: cartItem.selectedColor,
      selectedSize: cartItem.selectedSize,
      selectedVariants: cartItem.selectedVariants,
      isAvailable: cartItem.isAvailable,
      inStock: cartItem.inStock,
      brand: cartItem.brand,
      category: cartItem.category,
      sku: cartItem.sku,
      discountPercentage: cartItem.discountPercentage,
      discountAmount: cartItem.discountAmount,
      addedAt: cartItem.addedAt,
      updatedAt: cartItem.updatedAt,
      lastPriceCheck: cartItem.lastPriceCheck,
      priceChanged: cartItem.priceChanged,
      previousPrice: cartItem.previousPrice,
      isSelected: cartItem.isSelected,
      specialOfferId: cartItem.specialOfferId,
      metadata: cartItem.metadata,
    );
  }

  static String _generateCartItemId(int productId, Map<String, String> variants) {
    final variantString = variants.entries
        .map((e) => '${e.key}:${e.value}')
        .join('|');
    return '${productId}_${variantString.hashCode}';
  }

  /// Helper methods
  static Map<String, dynamic> _ensureStringKeyMap(dynamic map) {
    if (map == null) return {};
    if (map is Map<String, dynamic>) return map;
    if (map is Map) {
      return Map<String, dynamic>.from(map);
    }
    return {};
  }

  static Map<String, String> _extractVariants(Map<String, dynamic> json) {
    final variants = <String, String>{};

    // Try to get variants from selectedVariants field
    final selectedVariants = json['selectedVariants'] ?? json['selected_variants'];
    if (selectedVariants != null) {
      if (selectedVariants is Map) {
        variants.addAll(Map<String, String>.from(selectedVariants));
      }
    }

    return variants;
  }

  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

// Extension for CartItemModel
extension CartItemModelExtension on CartItemModel {
  CartItem toCartItem() {
    return CartItem(
      id: id,
      productId: productId,
      productTitle: productTitle,
      productImage: productImage,
      price: price,
      originalPrice: originalPrice,
      quantity: quantity,
      maxQuantity: maxQuantity,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
      selectedVariants: selectedVariants,
      isAvailable: isAvailable,
      inStock: inStock,
      brand: brand,
      category: category,
      sku: sku,
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      addedAt: addedAt,
      updatedAt: updatedAt,
      lastPriceCheck: lastPriceCheck,
      priceChanged: priceChanged,
      previousPrice: previousPrice,
      isSelected: isSelected,
      specialOfferId: specialOfferId,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'price': price,
      'originalPrice': originalPrice,
      'quantity': quantity,
      'maxQuantity': maxQuantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'selectedVariants': selectedVariants,
      'isAvailable': isAvailable,
      'inStock': inStock,
      'brand': brand,
      'category': category,
      'sku': sku,
      'discountPercentage': discountPercentage,
      'discountAmount': discountAmount,
      'addedAt': addedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastPriceCheck': lastPriceCheck?.toIso8601String(),
      'priceChanged': priceChanged,
      'previousPrice': previousPrice,
      'isSelected': isSelected,
      'specialOfferId': specialOfferId,
      'metadata': metadata,
    };
  }

  /// Convert to Fake Store API format
  Map<String, dynamic> toFakeStoreApiFormat() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}