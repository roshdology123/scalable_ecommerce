import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/cart.dart';
import 'cart_item_model.dart';
import 'cart_summary_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
@HiveType(typeId: 12)
class CartModel with _$CartModel {
  const factory CartModel({
    @HiveField(0) required String id,
    @HiveField(1) String? userId,
    @HiveField(2) required List<CartItemModel> items,
    @HiveField(3) required CartSummaryModel summary,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required DateTime updatedAt,
    @HiveField(6) DateTime? lastSyncedAt,
    @HiveField(7) @Default(false) bool isSynced,
    @HiveField(8) @Default(false) bool hasPendingChanges,
    @HiveField(9) @Default('active') String status,
    @HiveField(10) String? sessionId,
    @HiveField(11) Map<String, String>? appliedCoupons,
    @HiveField(12) String? shippingAddress,
    @HiveField(13) String? billingAddress,
    @HiveField(14) Map<String, dynamic>? metadata,
    @HiveField(15) DateTime? abandonedAt,
    @HiveField(16) @Default(0) int version,
    @HiveField(17) List<String>? conflictingFields,
    @HiveField(18) DateTime? expiresAt,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    // Handle Fake Store API response format
    if (json.containsKey('products')) {
      return CartModel._fromFakeStoreApiFormat(json);
    }

    // Handle our internal format
    return CartModel._fromInternalFormat(json);
  }

  /// Create CartModel from Fake Store API format
  /// API Response: { id: 1, userId: 1, date: "2020-03-02T00:00:02.000Z", products: [{ productId: 1, quantity: 4 }] }
  static CartModel _fromFakeStoreApiFormat(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>? ?? [];
    final items = productsJson
        .map((item) => CartItemModel.fromFakeStoreApiProduct(item as Map<String, dynamic>))
        .toList();

    final summary = CartSummaryModel.calculateFromItems(items);

    return CartModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString(),
      items: items,
      summary: summary,
      createdAt: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      updatedAt: DateTime.now(),
      lastSyncedAt: DateTime.now(),
      isSynced: true,
    );
  }

  /// Create CartModel from our internal format
  static CartModel _fromInternalFormat(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final items = itemsJson
        .map((item) => CartItemModel.fromJson(_ensureStringKeyMap(item)))
        .toList();

    // FIX: Don't cast - use the helper method directly
    final summaryData = json['summary']; // Get the raw data
    final summary = CartSummaryModel.fromJson(_ensureStringKeyMap(summaryData));

    return CartModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['user_id']?.toString(),
      items: items,
      summary: summary,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'])
          : json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'])
          : null,
      isSynced: json['isSynced'] as bool? ?? json['is_synced'] as bool? ?? false,
      hasPendingChanges: json['hasPendingChanges'] as bool? ??
          json['has_pending_changes'] as bool? ?? false,
      status: json['status']?.toString() ?? 'active',
      sessionId: json['sessionId']?.toString() ?? json['session_id']?.toString(),
      appliedCoupons: _extractStringStringMap(json['appliedCoupons'] ?? json['applied_coupons']),
      shippingAddress: json['shippingAddress']?.toString() ??
          json['shipping_address']?.toString(),
      billingAddress: json['billingAddress']?.toString() ??
          json['billing_address']?.toString(),
      metadata: json['metadata'] != null
          ? _ensureStringKeyMap(json['metadata'])
          : null,
      abandonedAt: json['abandonedAt'] != null
          ? DateTime.parse(json['abandonedAt'])
          : json['abandoned_at'] != null
          ? DateTime.parse(json['abandoned_at'])
          : null,
      version: json['version'] as int? ?? 0,
      conflictingFields: _extractStringList(json['conflictingFields'] ?? json['conflicting_fields']),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
    );
  }

  /// Helper method to ensure Map<String, dynamic> from Map<dynamic, dynamic>
  static Map<String, dynamic> _ensureStringKeyMap(dynamic map) {
    if (map == null) return {};
    if (map is Map<String, dynamic>) return map;
    if (map is Map) {
      return Map<String, dynamic>.from(map);
    }
    return {};
  }

  /// Helper method to safely extract Map<String, String>
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

  /// Helper method to safely extract List<String>
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

  factory CartModel.fromCart(Cart cart) {
    return CartModel(
      id: cart.id,
      userId: cart.userId,
      items: cart.items.map((item) => CartItemModel.fromCartItem(item)).toList(),
      summary: CartSummaryModel.fromCartSummary(cart.summary),
      createdAt: cart.createdAt,
      updatedAt: cart.updatedAt,
      lastSyncedAt: cart.lastSyncedAt,
      isSynced: cart.isSynced,
      hasPendingChanges: cart.hasPendingChanges,
      status: cart.status,
      sessionId: cart.sessionId,
      appliedCoupons: cart.appliedCoupons,
      shippingAddress: cart.shippingAddress,
      billingAddress: cart.billingAddress,
      metadata: cart.metadata,
      abandonedAt: cart.abandonedAt,
      version: cart.version,
      conflictingFields: cart.conflictingFields,
      expiresAt: cart.expiresAt,
    );
  }

  factory CartModel.empty({String? userId, String? sessionId}) {
    final now = DateTime.now();
    String generateCartId(String? userId, String? sessionId) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final identifier = userId ?? sessionId ?? 'guest';
      return 'cart_${identifier}_$timestamp';
    }
    return CartModel(
      id: generateCartId(userId, sessionId),
      userId: userId,
      items: [],
      summary: const CartSummaryModel(
        subtotal: 0.0,
        totalDiscount: 0.0,
        totalTax: 0.0,
        shippingCost: 0.0,
        total: 0.0,
        totalItems: 0,
        totalQuantity: 0,
      ),
      createdAt: now,
      updatedAt: now,
      sessionId: sessionId,
    );

  }



}

// Extension for CartModel
extension CartModelExtension on CartModel {

  /// Static helper to create an empty cart with optional userId and sessionId
   CartModel empty({String? userId, String? sessionId}) {
     String generateCartId(String? userId, String? sessionId) {
       final timestamp = DateTime.now().millisecondsSinceEpoch;
       final identifier = userId ?? sessionId ?? 'guest';
       return 'cart_${identifier}_$timestamp';
     }
    final now = DateTime.now();
    return CartModel(
      id: generateCartId(userId, sessionId),
      userId: userId,
      items: [],
      summary: const CartSummaryModel(
        subtotal: 0.0,
        totalDiscount: 0.0,
        totalTax: 0.0,
        shippingCost: 0.0,
        total: 0.0,
        totalItems: 0,
        totalQuantity: 0,
      ),
      createdAt: now,
      updatedAt: now,
      sessionId: sessionId,
    );
  }


  Cart toCart() {
    return Cart(
      id: id,
      userId: userId,
      items: items.map((item) => item.toCartItem()).toList(),
      summary: summary.toCartSummary(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastSyncedAt: lastSyncedAt,
      isSynced: isSynced,
      hasPendingChanges: hasPendingChanges,
      status: status,
      sessionId: sessionId,
      appliedCoupons: appliedCoupons,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      metadata: metadata,
      abandonedAt: abandonedAt,
      version: version,
      conflictingFields: conflictingFields,
      expiresAt: expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'summary': summary.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'isSynced': isSynced,
      'hasPendingChanges': hasPendingChanges,
      'status': status,
      'sessionId': sessionId,
      'appliedCoupons': appliedCoupons,
      'shippingAddress': shippingAddress,
      'billingAddress': billingAddress,
      'metadata': metadata,
      'abandonedAt': abandonedAt?.toIso8601String(),
      'version': version,
      'conflictingFields': conflictingFields,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  /// Convert to Fake Store API format for API calls
  Map<String, dynamic> toFakeStoreApiFormat() {
    return {
      'userId': int.tryParse(userId ?? '0') ?? 0,
      'date': updatedAt.toIso8601String(),
      'products': items.map((item) => item.toFakeStoreApiFormat()).toList(),
    };
  }
}