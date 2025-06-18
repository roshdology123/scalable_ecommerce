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
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['productId'] as int? ?? json['product_id'] as int? ?? 0,
      productTitle: json['productTitle']?.toString() ?? json['product_title']?.toString() ?? '',
      productImage: json['productImage']?.toString() ?? json['product_image']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ??
          (json['original_price'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
      maxQuantity: json['maxQuantity'] as int? ?? json['max_quantity'] as int? ?? 999,
      selectedColor: json['selectedColor']?.toString() ?? json['selected_color']?.toString(),
      selectedSize: json['selectedSize']?.toString() ?? json['selected_size']?.toString(),
      selectedVariants: Map<String, String>.from(
        json['selectedVariants'] ?? json['selected_variants'] ?? {},
      ),
      isAvailable: json['isAvailable'] as bool? ?? json['is_available'] as bool? ?? true,
      inStock: json['inStock'] as bool? ?? json['in_stock'] as bool? ?? true,
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      sku: json['sku']?.toString(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ??
          (json['discount_percentage'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ??
          (json['discount_amount'] as num?)?.toDouble(),
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : json['added_at'] != null
          ? DateTime.parse(json['added_at'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      lastPriceCheck: json['lastPriceCheck'] != null
          ? DateTime.parse(json['lastPriceCheck'])
          : json['last_price_check'] != null
          ? DateTime.parse(json['last_price_check'])
          : null,
      priceChanged: json['priceChanged'] as bool? ?? json['price_changed'] as bool? ?? false,
      previousPrice: (json['previousPrice'] as num?)?.toDouble() ??
          (json['previous_price'] as num?)?.toDouble(),
      isSelected: json['isSelected'] as bool? ?? json['is_selected'] as bool? ?? false,
      specialOfferId: json['specialOfferId']?.toString() ?? json['special_offer_id']?.toString(),
      metadata: json['metadata'] as Map<String, dynamic>?,
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
}