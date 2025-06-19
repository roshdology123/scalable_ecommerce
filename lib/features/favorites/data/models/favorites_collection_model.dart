import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/favorites_collection.dart';

part 'favorites_collection_model.freezed.dart';
part 'favorites_collection_model.g.dart';

@freezed
@HiveType(typeId: 21)
class FavoritesCollectionModel with _$FavoritesCollectionModel {
  const factory FavoritesCollectionModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) String? description,
    @HiveField(3) String? icon,
    @HiveField(4) String? color,
    @HiveField(5) @Default([]) List<String> productIds,
    @HiveField(6) @Default(false) bool isDefault,
    @HiveField(7) @Default(false) bool isSmartCollection,
    @HiveField(8) Map<String, dynamic>? smartRules,
    @HiveField(9) required DateTime createdAt,
    @HiveField(10) required DateTime updatedAt,
    @HiveField(11) @Default(false) bool isPublic,
    @HiveField(12) String? shareToken,
    @HiveField(13) @Default(0) int sortOrder,
    @HiveField(14) @Default({}) Map<String, String> tags,
    @HiveField(15) @Default({}) Map<String, dynamic> metadata,
  }) = _FavoritesCollectionModel;

  factory FavoritesCollectionModel.fromJson(Map<String, dynamic> json) {
    final safeJson = _ensureStringKeyMap(json);

    return FavoritesCollectionModel(
      id: safeJson['id']?.toString() ?? '',
      name: safeJson['name']?.toString() ?? '',
      description: safeJson['description']?.toString(),
      icon: safeJson['icon']?.toString(),
      color: safeJson['color']?.toString(),
      productIds: _extractStringList(safeJson['productIds'] ?? safeJson['product_ids']) ?? [],
      isDefault: safeJson['isDefault'] as bool? ?? safeJson['is_default'] as bool? ?? false,
      isSmartCollection: safeJson['isSmartCollection'] as bool? ??
          safeJson['is_smart_collection'] as bool? ?? false,
      smartRules: _ensureStringKeyMap(safeJson['smartRules'] ?? safeJson['smart_rules']),
      createdAt: _parseDateTime(safeJson['createdAt'] ?? safeJson['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(safeJson['updatedAt'] ?? safeJson['updated_at']) ?? DateTime.now(),
      isPublic: safeJson['isPublic'] as bool? ?? safeJson['is_public'] as bool? ?? false,
      shareToken: safeJson['shareToken']?.toString() ?? safeJson['share_token']?.toString(),
      sortOrder: safeJson['sortOrder'] as int? ?? safeJson['sort_order'] as int? ?? 0,
      tags: _extractStringStringMap(safeJson['tags']) ?? {},
      metadata: _ensureStringKeyMap(safeJson['metadata']) ?? {},
    );
  }

  factory FavoritesCollectionModel.fromFavoritesCollection(FavoritesCollection collection) {
    return FavoritesCollectionModel(
      id: collection.id,
      name: collection.name,
      description: collection.description,
      icon: collection.icon,
      color: collection.color,
      productIds: collection.productIds,
      isDefault: collection.isDefault,
      isSmartCollection: collection.isSmartCollection,
      smartRules: collection.smartRules,
      createdAt: collection.createdAt,
      updatedAt: collection.updatedAt,
      isPublic: collection.isPublic,
      shareToken: collection.shareToken,
      sortOrder: collection.sortOrder,
      tags: collection.tags,
      metadata: collection.metadata,
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

  static List<String>? _extractStringList(dynamic list) {
    if (list == null) return null;
    if (list is List<String>) return list;
    if (list is List) {
      try {
        return List<String>.from(list);
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

extension FavoritesCollectionModelExtension on FavoritesCollectionModel {
  FavoritesCollection toFavoritesCollection() {
    return FavoritesCollection(
      id: id,
      name: name,
      description: description,
      icon: icon,
      color: color,
      productIds: productIds,
      isDefault: isDefault,
      isSmartCollection: isSmartCollection,
      smartRules: smartRules,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPublic: isPublic,
      shareToken: shareToken,
      sortOrder: sortOrder,
      tags: tags,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'productIds': productIds,
      'isDefault': isDefault,
      'isSmartCollection': isSmartCollection,
      'smartRules': smartRules,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublic': isPublic,
      'shareToken': shareToken,
      'sortOrder': sortOrder,
      'tags': tags,
      'metadata': metadata,
    };
  }
}