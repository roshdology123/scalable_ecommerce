import 'package:equatable/equatable.dart';

import 'favorite_item.dart';

class FavoritesCollection extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final List<String> productIds;
  final bool isDefault;
  final bool isSmartCollection;
  final Map<String, dynamic>? smartRules;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final String? shareToken;
  final int sortOrder;
  final Map<String, String> tags;
  final Map<String, dynamic> metadata;

  const FavoritesCollection({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.productIds = const [],
    this.isDefault = false,
    this.isSmartCollection = false,
    this.smartRules,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = false,
    this.shareToken,
    this.sortOrder = 0,
    this.tags = const {},
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    icon,
    color,
    productIds,
    isDefault,
    isSmartCollection,
    smartRules,
    createdAt,
    updatedAt,
    isPublic,
    shareToken,
    sortOrder,
    tags,
    metadata,
  ];

  FavoritesCollection copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    List<String>? productIds,
    bool? isDefault,
    bool? isSmartCollection,
    Map<String, dynamic>? smartRules,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
    String? shareToken,
    int? sortOrder,
    Map<String, String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return FavoritesCollection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      productIds: productIds ?? this.productIds,
      isDefault: isDefault ?? this.isDefault,
      isSmartCollection: isSmartCollection ?? this.isSmartCollection,
      smartRules: smartRules ?? this.smartRules,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
      shareToken: shareToken ?? this.shareToken,
      sortOrder: sortOrder ?? this.sortOrder,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  // Business Logic Methods
  int get itemCount => productIds.length;

  bool get isEmpty => productIds.isEmpty;

  bool get isNotEmpty => productIds.isNotEmpty;

  bool containsProduct(int productId) {
    return productIds.contains(productId.toString());
  }

  Duration get age => DateTime.now().difference(createdAt);

  bool get isRecent => age.inDays <= 7;

  bool get isStale => age.inDays > 90;

  String get displayName {
    if (isDefault) return 'All Favorites';
    return name;
  }

  String? get displayIcon {
    if (icon != null) return icon;
    if (isDefault) return '❤️';
    if (isSmartCollection) return '✨';
    return '📁';
  }

  // Smart collection logic
  List<FavoriteItem> filterBySmartRules(List<FavoriteItem> allFavorites) {
    if (!isSmartCollection || smartRules == null) {
      return allFavorites.where((item) => productIds.contains(item.productId.toString())).toList();
    }

    return _applySmartRules(allFavorites, smartRules!);
  }

  List<FavoriteItem> _applySmartRules(List<FavoriteItem> favorites, Map<String, dynamic> rules) {
    var filtered = favorites;

    // Filter by category
    if (rules['category'] != null) {
      final category = rules['category'] as String;
      filtered = filtered.where((item) => item.category == category).toList();
    }

    // Filter by price range
    if (rules['minPrice'] != null) {
      final minPrice = (rules['minPrice'] as num).toDouble();
      filtered = filtered.where((item) => item.price >= minPrice).toList();
    }

    if (rules['maxPrice'] != null) {
      final maxPrice = (rules['maxPrice'] as num).toDouble();
      filtered = filtered.where((item) => item.price <= maxPrice).toList();
    }

    // Filter by rating
    if (rules['minRating'] != null) {
      final minRating = (rules['minRating'] as num).toDouble();
      filtered = filtered.where((item) => item.rating >= minRating).toList();
    }

    // Filter by availability
    if (rules['inStockOnly'] == true) {
      filtered = filtered.where((item) => item.inStock).toList();
    }

    // Filter by sale status
    if (rules['onSaleOnly'] == true) {
      filtered = filtered.where((item) => item.isOnSale).toList();
    }

    // Filter by date range
    if (rules['addedAfter'] != null) {
      final addedAfter = DateTime.parse(rules['addedAfter'] as String);
      filtered = filtered.where((item) => item.addedAt.isAfter(addedAfter)).toList();
    }

    // Filter by tags
    if (rules['tags'] != null) {
      final requiredTags = (rules['tags'] as List).cast<String>();
      filtered = filtered.where((item) {
        final itemTags = [...item.tags.values, ...item.getAutoTags()];
        return requiredTags.every((tag) => itemTags.contains(tag));
      }).toList();
    }

    // Limit results
    if (rules['limit'] != null) {
      final limit = rules['limit'] as int;
      if (filtered.length > limit) {
        filtered = filtered.take(limit).toList();
      }
    }

    return filtered;
  }

  // Predefined smart collections
  static FavoritesCollection createRecentCollection() {
    return FavoritesCollection(
      id: 'smart_recent',
      name: 'Recently Added',
      description: 'Items added in the last 7 days',
      icon: '🆕',
      isSmartCollection: true,
      smartRules: {
        'addedAfter': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        'limit': 20,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static FavoritesCollection createSaleCollection() {
    return FavoritesCollection(
      id: 'smart_sale',
      name: 'On Sale',
      description: 'Items currently on sale',
      icon: '🏷️',
      isSmartCollection: true,
      smartRules: {
        'onSaleOnly': true,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static FavoritesCollection createHighlyRatedCollection() {
    return FavoritesCollection(
      id: 'smart_highly_rated',
      name: 'Highly Rated',
      description: 'Items with 4.5+ star rating',
      icon: '⭐',
      isSmartCollection: true,
      smartRules: {
        'minRating': 4.5,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static FavoritesCollection createPriceDropCollection() {
    return FavoritesCollection(
      id: 'smart_price_drop',
      name: 'Price Drops',
      description: 'Items with recent price drops',
      icon: '📉',
      isSmartCollection: true,
      smartRules: {
        'tags': ['price_drop'],
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static FavoritesCollection createCategoryCollection(String category) {
    return FavoritesCollection(
      id: 'smart_category_${category.toLowerCase()}',
      name: category,
      description: 'All $category items',
      icon: _getCategoryIcon(category),
      isSmartCollection: true,
      smartRules: {
        'category': category,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return '📱';
      case 'jewelery':
        return '💍';
      case "men's clothing":
        return '👔';
      case "women's clothing":
        return '👗';
      default:
        return '📦';
    }
  }

  // Analytics
  Map<String, dynamic> toAnalytics() {
    return {
      'collection_id': id,
      'name': name,
      'item_count': itemCount,
      'is_smart': isSmartCollection,
      'is_public': isPublic,
      'age_days': age.inDays,
      'tags': tags.values.toList(),
    };
  }
}