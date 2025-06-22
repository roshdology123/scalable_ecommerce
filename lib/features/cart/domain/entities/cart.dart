import 'package:equatable/equatable.dart';

import 'cart_item.dart';
import 'cart_summary.dart';

class Cart extends Equatable {
  final String id;
  final String? userId;
  final List<CartItem> items;
  final CartSummary summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final bool isSynced;
  final bool hasPendingChanges;
  final String status;
  final String? sessionId;
  final Map<String, String>? appliedCoupons;
  final String? shippingAddress;
  final String? billingAddress;
  final Map<String, dynamic>? metadata;
  final DateTime? abandonedAt;
  final int version;
  final List<String>? conflictingFields;
  final DateTime? expiresAt;

  const Cart({
    required this.id,
    this.userId,
    required this.items,
    required this.summary,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.isSynced = false,
    this.hasPendingChanges = false,
    this.status = 'active',
    this.sessionId,
    this.appliedCoupons,
    this.shippingAddress,
    this.billingAddress,
    this.metadata,
    this.abandonedAt,
    this.version = 0,
    this.conflictingFields,
    this.expiresAt,
  });

  /// Factory method to create an empty cart
  static Cart empty({
    required String id,
    String? userId,
    String? sessionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now();
    return Cart(
      id: id,
      userId: userId,
      items: const [],
      summary: CartSummary.empty(),
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      lastSyncedAt: null,
      isSynced: false,
      hasPendingChanges: false,
      status: 'active',
      sessionId: sessionId,
      appliedCoupons: null,
      shippingAddress: null,
      billingAddress: null,
      metadata: null,
      abandonedAt: null,
      version: 0,
      conflictingFields: null,
      expiresAt: null,
    );
  }

  /// Business Logic Methods

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get hasItems => items.isNotEmpty;

  /// Check if cart belongs to a guest user
  bool get isGuestCart => userId == null;

  /// Check if cart belongs to an authenticated user
  bool get isUserCart => userId != null;

  /// Check if cart is active
  bool get isActive => status == 'active';

  /// Check if cart is abandoned
  bool get isAbandoned => status == 'abandoned' || abandonedAt != null;

  /// Check if cart is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if cart needs sync
  bool get needsSync => hasPendingChanges || !isSynced;

  /// Check if cart has conflicts
  bool get hasConflicts => conflictingFields?.isNotEmpty == true;

  /// Get cart age in hours
  int get ageInHours => DateTime.now().difference(createdAt).inHours;

  /// Get last activity time
  DateTime get lastActivity => [updatedAt, lastSyncedAt]
      .where((date) => date != null)
      .map((date) => date!)
      .fold(updatedAt, (a, b) => a.isAfter(b) ? a : b);

  /// Get time since last activity in hours
  int get hoursSinceLastActivity => DateTime.now().difference(lastActivity).inHours;

  /// Check if cart is recently active (within last 2 hours)
  bool get isRecentlyActive => hoursSinceLastActivity < 2;

  /// Check if cart should be considered abandoned (no activity for 24+ hours)
  bool get shouldBeAbandoned => hoursSinceLastActivity >= 24 && isActive;

  /// Get items grouped by category
  Map<String, List<CartItem>> get itemsByCategory {
    final grouped = <String, List<CartItem>>{};
    for (final item in items) {
      final category = item.category ?? 'Other';
      grouped.putIfAbsent(category, () => []).add(item);
    }
    return grouped;
  }

  /// Get items grouped by brand
  Map<String, List<CartItem>> get itemsByBrand {
    final grouped = <String, List<CartItem>>{};
    for (final item in items) {
      final brand = item.brand ?? 'Unknown';
      grouped.putIfAbsent(brand, () => []).add(item);
    }
    return grouped;
  }

  /// Get available items only
  List<CartItem> get availableItems => items.where((item) => item.isAvailable).toList();

  /// Get unavailable items
  List<CartItem> get unavailableItems => items.where((item) => !item.isAvailable).toList();

  /// Get in-stock items
  List<CartItem> get inStockItems => items.where((item) => item.inStock).toList();

  /// Get out-of-stock items
  List<CartItem> get outOfStockItems => items.where((item) => !item.inStock).toList();

  /// Get selected items
  List<CartItem> get selectedItems => items.where((item) => item.isSelected).toList();

  /// Get items with price changes
  List<CartItem> get priceChangedItems => items.where((item) => item.priceChanged).toList();

  /// Get items on sale
  List<CartItem> get saleItems => items.where((item) => item.isOnSale).toList();

  /// Get recently added items (within last hour)
  List<CartItem> get recentlyAddedItems => items.where((item) => item.isRecentlyAdded).toList();

  /// Check if all items are available
  bool get allItemsAvailable => items.every((item) => item.isAvailable);

  /// Check if all items are in stock
  bool get allItemsInStock => items.every((item) => item.inStock);

  /// Check if cart is valid for checkout
  bool get isValidForCheckout => hasItems && allItemsAvailable && allItemsInStock;

  /// Get cart validation issues
  List<String> get validationIssues {
    final issues = <String>[];

    if (isEmpty) {
      issues.add('Cart is empty');
    }

    if (unavailableItems.isNotEmpty) {
      issues.add('${unavailableItems.length} item(s) no longer available');
    }

    if (outOfStockItems.isNotEmpty) {
      issues.add('${outOfStockItems.length} item(s) out of stock');
    }

    if (priceChangedItems.isNotEmpty) {
      issues.add('${priceChangedItems.length} item(s) have price changes');
    }

    if (isExpired) {
      issues.add('Cart has expired');
    }

    return issues;
  }

  /// Find item by ID
  CartItem? findItemById(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Find item by product ID and variants
  CartItem? findItemByProductAndVariants(int productId, Map<String, String> variants) {
    for (final item in items) {
      if (item.productId == productId) {
        // Check if variants match
        bool variantsMatch = true;
        for (final entry in variants.entries) {
          if (item.selectedVariants[entry.key] != entry.value) {
            variantsMatch = false;
            break;
          }
        }
        if (variantsMatch && item.selectedVariants.length == variants.length) {
          return item;
        }
      }
    }
    return null;
  }

  /// Check if product with variants exists in cart
  bool containsProduct(int productId, Map<String, String> variants) {
    return findItemByProductAndVariants(productId, variants) != null;
  }

  /// Get cart priority score for sorting multiple carts
  int get priorityScore {
    int score = 0;

    // Recent activity bonus
    if (isRecentlyActive) score += 100;

    // Item count bonus
    score += items.length * 10;

    // Total value bonus
    score += (summary.total / 10).round();

    // User cart bonus
    if (isUserCart) score += 50;

    // Penalties
    if (isAbandoned) score -= 200;
    if (hasConflicts) score -= 100;
    if (!allItemsAvailable) score -= 75;

    return score;
  }

  /// Get cart status message
  String get statusMessage {
    if (isEmpty) return 'Your cart is empty';
    if (isAbandoned) return 'Cart was abandoned';
    if (isExpired) return 'Cart has expired';
    if (!allItemsAvailable) return 'Some items are no longer available';
    if (!allItemsInStock) return 'Some items are out of stock';
    if (hasConflicts) return 'Cart has sync conflicts';
    if (needsSync) return 'Cart needs to be synced';
    return 'Cart is ready for checkout';
  }

  /// Get item count by status
  Map<String, int> get itemStatusCounts => {
    'total': items.length,
    'available': availableItems.length,
    'unavailable': unavailableItems.length,
    'in_stock': inStockItems.length,
    'out_of_stock': outOfStockItems.length,
    'on_sale': saleItems.length,
    'price_changed': priceChangedItems.length,
    'recently_added': recentlyAddedItems.length,
  };

  /// Sort items by different criteria
  List<CartItem> getSortedItems({CartItemSortBy sortBy = CartItemSortBy.addedAt}) {
    final sortedItems = List<CartItem>.from(items);

    switch (sortBy) {
      case CartItemSortBy.addedAt:
        sortedItems.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
      case CartItemSortBy.price:
        sortedItems.sort((a, b) => a.price.compareTo(b.price));
        break;
      case CartItemSortBy.priceDesc:
        sortedItems.sort((a, b) => b.price.compareTo(a.price));
        break;
      case CartItemSortBy.title:
        sortedItems.sort((a, b) => a.productTitle.compareTo(b.productTitle));
        break;
      case CartItemSortBy.brand:
        sortedItems.sort((a, b) => (a.brand ?? '').compareTo(b.brand ?? ''));
        break;
      case CartItemSortBy.category:
        sortedItems.sort((a, b) => (a.category ?? '').compareTo(b.category ?? ''));
        break;
      case CartItemSortBy.quantity:
        sortedItems.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      case CartItemSortBy.priority:
        sortedItems.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
        break;
    }

    return sortedItems;
  }

  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    CartSummary? summary,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    bool? isSynced,
    bool? hasPendingChanges,
    String? status,
    String? sessionId,
    Map<String, String>? appliedCoupons,
    String? shippingAddress,
    String? billingAddress,
    Map<String, dynamic>? metadata,
    DateTime? abandonedAt,
    int? version,
    List<String>? conflictingFields,
    DateTime? expiresAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isSynced: isSynced ?? this.isSynced,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      appliedCoupons: appliedCoupons ?? this.appliedCoupons,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      metadata: metadata ?? this.metadata,
      abandonedAt: abandonedAt ?? this.abandonedAt,
      version: version ?? this.version,
      conflictingFields: conflictingFields ?? this.conflictingFields,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    summary,
    createdAt,
    updatedAt,
    lastSyncedAt,
    isSynced,
    hasPendingChanges,
    status,
    sessionId,
    appliedCoupons,
    shippingAddress,
    billingAddress,
    metadata,
    abandonedAt,
    version,
    conflictingFields,
    expiresAt,
  ];

  @override
  String toString() => 'Cart(id: $id, userId: $userId, items: ${items.length}, '
      'total: ${summary.formattedTotal}, status: $status)';
}

enum CartItemSortBy {
  addedAt,
  price,
  priceDesc,
  title,
  brand,
  category,
  quantity,
  priority,
}