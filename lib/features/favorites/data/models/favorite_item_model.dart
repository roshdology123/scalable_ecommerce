import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/favorite_item.dart';

part 'favorite_item_model.freezed.dart';
part 'favorite_item_model.g.dart';

@freezed
@HiveType(typeId: 20)
class FavoriteItemModel with _$FavoriteItemModel {
  const factory FavoriteItemModel({
    @HiveField(0) required String id,
    @HiveField(1) required int productId,
    @HiveField(2) required String productTitle,
    @HiveField(3) required String productImage,
    @HiveField(4) required double price,
    @HiveField(5) double? originalPrice,
    @HiveField(6) required String category,
    @HiveField(7) String? brand,
    @HiveField(8) required double rating,
    @HiveField(9) required bool isAvailable,
    @HiveField(10) required bool inStock,
    @HiveField(11) required DateTime addedAt,
    @HiveField(12) DateTime? updatedAt,
    @HiveField(13) DateTime? priceUpdatedAt,
    @HiveField(14) double? previousPrice,
    @HiveField(15) @Default(false) bool priceDropped,
    @HiveField(16) String? collectionId,
    @HiveField(17) @Default({}) Map<String, String> tags,
    @HiveField(18) @Default(0) int viewCount,
    @HiveField(19) DateTime? lastViewedAt,
    @HiveField(20) @Default(false) bool isPriceTrackingEnabled,
    @HiveField(21) double? targetPrice,
    @HiveField(22) String? notes,
    @HiveField(23) @Default({}) Map<String, dynamic> metadata,
  }) = _FavoriteItemModel;

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    final safeJson = _ensureStringKeyMap(json);

    return FavoriteItemModel(
      id: safeJson['id']?.toString() ?? '',
      productId: safeJson['productId'] as int? ?? safeJson['product_id'] as int? ?? 0,
      productTitle: safeJson['productTitle']?.toString() ?? safeJson['product_title']?.toString() ?? '',
      productImage: safeJson['productImage']?.toString() ?? safeJson['product_image']?.toString() ?? '',
      price: (safeJson['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (safeJson['originalPrice'] as num?)?.toDouble() ??
          (safeJson['original_price'] as num?)?.toDouble(),
      category: safeJson['category']?.toString() ?? '',
      brand: safeJson['brand']?.toString(),
      rating: (safeJson['rating'] as num?)?.toDouble() ?? 0.0,
      isAvailable: safeJson['isAvailable'] as bool? ?? safeJson['is_available'] as bool? ?? true,
      inStock: safeJson['inStock'] as bool? ?? safeJson['in_stock'] as bool? ?? true,
      addedAt: _parseDateTime(safeJson['addedAt'] ?? safeJson['added_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(safeJson['updatedAt'] ?? safeJson['updated_at']),
      priceUpdatedAt: _parseDateTime(safeJson['priceUpdatedAt'] ?? safeJson['price_updated_at']),
      previousPrice: (safeJson['previousPrice'] as num?)?.toDouble() ??
          (safeJson['previous_price'] as num?)?.toDouble(),
      priceDropped: safeJson['priceDropped'] as bool? ?? safeJson['price_dropped'] as bool? ?? false,
      collectionId: safeJson['collectionId']?.toString() ?? safeJson['collection_id']?.toString(),
      tags: _extractStringStringMap(safeJson['tags']) ?? {},
      viewCount: safeJson['viewCount'] as int? ?? safeJson['view_count'] as int? ?? 0,
      lastViewedAt: _parseDateTime(safeJson['lastViewedAt'] ?? safeJson['last_viewed_at']),
      isPriceTrackingEnabled: safeJson['isPriceTrackingEnabled'] as bool? ??
          safeJson['is_price_tracking_enabled'] as bool? ?? false,
      targetPrice: (safeJson['targetPrice'] as num?)?.toDouble() ??
          (safeJson['target_price'] as num?)?.toDouble(),
      notes: safeJson['notes']?.toString(),
      metadata: _ensureStringKeyMap(safeJson['metadata']) ?? {},
    );
  }

  factory FavoriteItemModel.fromFavoriteItem(FavoriteItem favoriteItem) {
    return FavoriteItemModel(
      id: favoriteItem.id,
      productId: favoriteItem.productId,
      productTitle: favoriteItem.productTitle,
      productImage: favoriteItem.productImage,
      price: favoriteItem.price,
      originalPrice: favoriteItem.originalPrice,
      category: favoriteItem.category,
      brand: favoriteItem.brand,
      rating: favoriteItem.rating,
      isAvailable: favoriteItem.isAvailable,
      inStock: favoriteItem.inStock,
      addedAt: favoriteItem.addedAt,
      updatedAt: favoriteItem.updatedAt,
      priceUpdatedAt: favoriteItem.priceUpdatedAt,
      previousPrice: favoriteItem.previousPrice,
      priceDropped: favoriteItem.priceDropped,
      collectionId: favoriteItem.collectionId,
      tags: favoriteItem.tags,
      viewCount: favoriteItem.viewCount,
      lastViewedAt: favoriteItem.lastViewedAt,
      isPriceTrackingEnabled: favoriteItem.isPriceTrackingEnabled,
      targetPrice: favoriteItem.targetPrice,
      notes: favoriteItem.notes,
      metadata: favoriteItem.metadata,
    );
  }

  static Map<String, dynamic> _ensureStringKeyMap(dynamic map) {
    if (map == null) return {};
    if (map is Map<String, dynamic>) return map;
    if (map is Map) {
      return Map<String, dynamic>.from(map);
    }
    return {};
  }

  static Map<String, String>? _extractStringStringMap(dynamic map) {
    if (map == null) return null;
    if (map is Map<String, String>) return map;
    if (map is Map) {
      try {
        return Map<String, String>.from(map);
      } catch (e) {
        return null;
      }
    }
    return null;
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

extension FavoriteItemModelExtension on FavoriteItemModel {
  FavoriteItem toFavoriteItem() {
    return FavoriteItem(
      id: id,
      productId: productId,
      productTitle: productTitle,
      productImage: productImage,
      price: price,
      originalPrice: originalPrice,
      category: category,
      brand: brand,
      rating: rating,
      isAvailable: isAvailable,
      inStock: inStock,
      addedAt: addedAt,
      updatedAt: updatedAt,
      priceUpdatedAt: priceUpdatedAt,
      previousPrice: previousPrice,
      priceDropped: priceDropped,
      collectionId: collectionId,
      tags: tags,
      viewCount: viewCount,
      lastViewedAt: lastViewedAt,
      isPriceTrackingEnabled: isPriceTrackingEnabled,
      targetPrice: targetPrice,
      notes: notes,
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
      'category': category,
      'brand': brand,
      'rating': rating,
      'isAvailable': isAvailable,
      'inStock': inStock,
      'addedAt': addedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'priceUpdatedAt': priceUpdatedAt?.toIso8601String(),
      'previousPrice': previousPrice,
      'priceDropped': priceDropped,
      'collectionId': collectionId,
      'tags': tags,
      'viewCount': viewCount,
      'lastViewedAt': lastViewedAt?.toIso8601String(),
      'isPriceTrackingEnabled': isPriceTrackingEnabled,
      'targetPrice': targetPrice,
      'notes': notes,
      'metadata': metadata,
    };
  }
}