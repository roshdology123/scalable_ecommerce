import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/category.dart';

part 'category_model.freezed.dart';

@freezed
@HiveType(typeId: 3)
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String displayName,
    @HiveField(3) String? description,
    @HiveField(4) String? image,
    @HiveField(5) String? icon,
    @HiveField(6) @Default(0) int productCount,
    @HiveField(7) @Default(true) bool isActive,
    @HiveField(8) @Default(0) int sortOrder,
    @HiveField(9) DateTime? createdAt,
    @HiveField(10) DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Handle Fake Store API response (categories are just strings)
    if (json is String) {
      final categoryName = json as String;
      return CategoryModel(
        id: categoryName.toLowerCase().replaceAll(' ', '_'),
        name: categoryName,
        displayName: _formatCategoryName(categoryName),
        description: 'Products in $categoryName category',
        image: _getCategoryImage(categoryName),
        icon: _getCategoryIcon(categoryName),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // Handle full JSON object
    return CategoryModel(
      id: json['id']?.toString() ?? json['name']?.toString().toLowerCase().replaceAll(' ', '_') ?? '',
      name: json['name']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? _formatCategoryName(json['name']?.toString() ?? ''),
      description: json['description']?.toString(),
      image: json['image']?.toString() ?? _getCategoryImage(json['name']?.toString() ?? ''),
      icon: json['icon']?.toString() ?? _getCategoryIcon(json['name']?.toString() ?? ''),
      productCount: json['productCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  factory CategoryModel.fromCategory(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      displayName: category.displayName,
      description: category.description,
      image: category.image,
      icon: category.icon,
      productCount: category.productCount,
      isActive: category.isActive,
      sortOrder: category.sortOrder,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  static String _formatCategoryName(String name) {
    if (name.isEmpty) return name;
    return name.split(' ').map((word) =>
    word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : word
    ).join(' ');
  }

  static String _getCategoryImage(String categoryName) {
    final category = categoryName.toLowerCase();
    switch (category) {
      case 'electronics':
        return 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400';
      case 'jewelery':
      case 'jewelry':
        return 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400';
      case "men's clothing":
      case 'mens clothing':
        return 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400';
      case "women's clothing":
      case 'womens clothing':
        return 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400';
      default:
        return 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400';
    }
  }

  static String _getCategoryIcon(String categoryName) {
    final category = categoryName.toLowerCase();
    switch (category) {
      case 'electronics':
        return 'electronics';
      case 'jewelery':
      case 'jewelry':
        return 'diamond';
      case "men's clothing":
      case 'mens clothing':
        return 'man';
      case "women's clothing":
      case 'womens clothing':
        return 'woman';
      default:
        return 'category';
    }
  }
}

// Extension for CategoryModel
extension CategoryModelExtension on CategoryModel {
  Category toCategory() {
    return Category(
      id: id,
      name: name,
      displayName: displayName,
      description: description,
      image: image,
      icon: icon,
      productCount: productCount,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': name,
        'displayName': displayName,
        'description': description,
        'image': image,
        'icon': icon,
        'productCount': productCount,
        'isActive': isActive,
        'sortOrder': sortOrder,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
    }
}