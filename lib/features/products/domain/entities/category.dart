import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String? description;
  final String? image;
  final String? icon;
  final int productCount;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    this.image,
    this.icon,
    this.productCount = 0,
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  /// Get category slug for URLs
  String get slug => name.toLowerCase().replaceAll(' ', '-');

  /// Check if category has products
  bool get hasProducts => productCount > 0;

  /// Check if category is popular (has many products)
  bool get isPopular => productCount >= 50;

  /// Get formatted product count
  String get formattedProductCount {
    if (productCount == 0) return 'No products';
    if (productCount == 1) return '1 product';
    return '$productCount products';
  }

  /// Get category age in days
  int get ageInDays {
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt!).inDays;
  }

  /// Check if category is new (created within last 30 days)
  bool get isNew => ageInDays <= 30;

  @override
  List<Object?> get props => [
    id,
    name,
    displayName,
    description,
    image,
    icon,
    productCount,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => 'Category(id: $id, name: $name, productCount: $productCount)';
}