import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/product.dart';
import 'rating_model.dart';

part 'product_model.freezed.dart';

@freezed
@HiveType(typeId: 0)
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required double price,
    @HiveField(3) required String description,
    @HiveField(4) required String category,
    @HiveField(5) required String image,
    @HiveField(6) required RatingModel rating,
    @HiveField(7) @Default([]) List<String> images,
    @HiveField(8) String? brand,
    @HiveField(9) String? sku,
    @HiveField(10) @Default(0) int stock,
    @HiveField(11) double? originalPrice,
    @HiveField(12) double? discountPercentage,
    @HiveField(13) @Default([]) List<String> tags,
    @HiveField(14) @Default(true) bool isAvailable,
    @HiveField(15) @Default(false) bool isFeatured,
    @HiveField(16) @Default(false) bool isNew,
    @HiveField(17) @Default(false) bool isOnSale,
    @HiveField(18) DateTime? createdAt,
    @HiveField(19) DateTime? updatedAt,
    @HiveField(20) Map<String, dynamic>? specifications,
    @HiveField(21) @Default([]) List<String> colors,
    @HiveField(22) @Default([]) List<String> sizes,
    @HiveField(23) String? weight,
    @HiveField(24) String? dimensions,
    @HiveField(25) String? material,
    @HiveField(26) String? warranty,
    @HiveField(27) @Default(0) int viewCount,
    @HiveField(28) @Default(0) int purchaseCount,
    @HiveField(29) DateTime? lastViewedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle Fake Store API response format
    final rating = json['rating'] as Map<String, dynamic>?;
    final ratingModel = rating != null
        ? RatingModel.fromJson(rating)
        : const RatingModel(rate: 0.0, count: 0);

    // Generate additional images from main image
    final mainImage = json['image']?.toString() ?? '';
    final images = <String>[
      if (mainImage.isNotEmpty) mainImage,
      // Add some mock additional images for demo
      if (mainImage.isNotEmpty) ..._generateAdditionalImages(mainImage),
    ];

    // Extract brand from title or category
    final title = json['title']?.toString() ?? '';
    final brand = _extractBrandFromTitle(title);

    // Calculate stock based on rating count (mock data)
    final stock = (ratingModel.count * 0.1).round().clamp(0, 50);

    // Generate mock discount for some products
    final price = (json['price'] as num?)?.toDouble() ?? 0.0;
    final discountPercentage = _generateDiscountPercentage(json['id'] as int? ?? 0);
    final originalPrice = discountPercentage > 0
        ? price / (1 - discountPercentage / 100)
        : price;

    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: title,
      price: price,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: mainImage,
      rating: ratingModel,
      images: images,
      brand: brand,
      sku: 'SKU-${json['id']?.toString().padLeft(6, '0')}',
      stock: stock,
      originalPrice: originalPrice != price ? originalPrice : null,
      discountPercentage: discountPercentage > 0 ? discountPercentage : null,
      tags: _generateTags(title, json['category']?.toString() ?? ''),
      isAvailable: stock > 0,
      isFeatured: (json['id'] as int? ?? 0) % 7 == 0, // Mock featured products
      isNew: (json['id'] as int? ?? 0) > 15, // Mock new products
      isOnSale: discountPercentage > 0,
      createdAt: DateTime.now().subtract(Duration(days: (json['id'] as int? ?? 0) * 5)),
      updatedAt: DateTime.now(),
      specifications: _generateSpecifications(json['category']?.toString() ?? ''),
      colors: _generateColors(json['category']?.toString() ?? ''),
      sizes: _generateSizes(json['category']?.toString() ?? ''),
      weight: _generateWeight(json['category']?.toString() ?? ''),
      dimensions: _generateDimensions(json['category']?.toString() ?? ''),
      material: _generateMaterial(json['category']?.toString() ?? ''),
      warranty: _generateWarranty(json['category']?.toString() ?? ''),
      viewCount: (ratingModel.count * 2.5).round(),
      purchaseCount: (ratingModel.count * 0.3).round(),
    );
  }

  factory ProductModel.fromProduct(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      image: product.image,
      rating: RatingModel.fromRating(product.rating),
      images: product.images,
      brand: product.brand,
      sku: product.sku,
      stock: product.stock,
      originalPrice: product.originalPrice,
      discountPercentage: product.discountPercentage,
      tags: product.tags,
      isAvailable: product.isAvailable,
      isFeatured: product.isFeatured,
      isNew: product.isNew,
      isOnSale: product.isOnSale,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      specifications: product.specifications,
      colors: product.colors,
      sizes: product.sizes,
      weight: product.weight,
      dimensions: product.dimensions,
      material: product.material,
      warranty: product.warranty,
      viewCount: product.viewCount,
      purchaseCount: product.purchaseCount,
      lastViewedAt: product.lastViewedAt,
    );
  }

  // Helper methods for generating mock data
  static List<String> _generateAdditionalImages(String mainImage) {
    // Generate mock additional images based on main image
    final baseUrl = mainImage.split('?')[0];
    return [
      '$baseUrl?variant=1',
      '$baseUrl?variant=2',
      '$baseUrl?variant=3',
    ];
  }

  static String? _extractBrandFromTitle(String title) {
    // Extract potential brand names from title
    final words = title.split(' ');
    if (words.isNotEmpty) {
      final firstWord = words.first;
      if (firstWord.length > 2 && firstWord[0].toUpperCase() == firstWord[0]) {
        return firstWord;
      }
    }
    return null;
  }

  static double _generateDiscountPercentage(int productId) {
    // Generate discount based on product ID
    if (productId % 3 == 0) return 10.0;
    if (productId % 5 == 0) return 15.0;
    if (productId % 7 == 0) return 20.0;
    return 0.0;
  }

  static List<String> _generateTags(String title, String category) {
    final tags = <String>[];

    // Add category as tag
    tags.add(category.toLowerCase());

    // Extract potential tags from title
    final titleWords = title.toLowerCase().split(' ');
    for (final word in titleWords) {
      if (word.length > 3 && !tags.contains(word)) {
        tags.add(word);
      }
    }

    return tags.take(5).toList();
  }

  static Map<String, dynamic>? _generateSpecifications(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return {
          'Brand': 'TechBrand',
          'Model': 'TB-2024',
          'Power': '220V',
          'Connectivity': 'Wi-Fi, Bluetooth',
          'Operating System': 'Android',
        };
      case 'jewelery':
      case 'jewelry':
        return {
          'Material': 'Sterling Silver',
          'Stone Type': 'Cubic Zirconia',
          'Chain Length': '18 inches',
          'Clasp Type': 'Lobster Clasp',
          'Care Instructions': 'Clean with soft cloth',
        };
      default:
        return {
          'Material': 'High Quality',
          'Origin': 'Premium Collection',
          'Care Instructions': 'Follow care label',
        };
    }
  }

  static List<String> _generateColors(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return ['Black', 'White', 'Silver'];
      case 'jewelery':
      case 'jewelry':
        return ['Gold', 'Silver', 'Rose Gold'];
      case "men's clothing":
      case 'mens clothing':
        return ['Black', 'Navy', 'Gray', 'White'];
      case "women's clothing":
      case 'womens clothing':
        return ['Black', 'White', 'Red', 'Blue', 'Pink'];
      default:
        return ['Black', 'White'];
    }
  }

  static List<String> _generateSizes(String category) {
    switch (category.toLowerCase()) {
      case "men's clothing":
      case 'mens clothing':
        return ['S', 'M', 'L', 'XL', 'XXL'];
      case "women's clothing":
      case 'womens clothing':
        return ['XS', 'S', 'M', 'L', 'XL'];
      case 'jewelery':
      case 'jewelry':
        return ['6', '7', '8', '9', '10'];
      default:
        return [];
    }
  }

  static String? _generateWeight(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return '2.5 kg';
      case 'jewelery':
      case 'jewelry':
        return '15 g';
      case "men's clothing":
      case 'mens clothing':
        return '300 g';
      case "women's clothing":
      case 'womens clothing':
        return '250 g';
      default:
        return null;
    }
  }

  static String? _generateDimensions(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return '25 x 15 x 8 cm';
      case 'jewelery':
      case 'jewelry':
        return '2 x 2 x 0.5 cm';
      case "men's clothing":
      case 'mens clothing':
        return 'Length: 75 cm, Chest: 50 cm';
      case "women's clothing":
      case 'womens clothing':
        return 'Length: 65 cm, Bust: 45 cm';
      default:
        return null;
    }
  }

  static String? _generateMaterial(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return 'Aluminum, Plastic';
      case 'jewelery':
      case 'jewelry':
        return 'Sterling Silver, Cubic Zirconia';
      case "men's clothing":
      case 'mens clothing':
        return '100% Cotton';
      case "women's clothing":
      case 'womens clothing':
        return '95% Cotton, 5% Elastane';
      default:
        return null;
    }
  }

  static String? _generateWarranty(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return '2 Years Manufacturer Warranty';
      case 'jewelery':
      case 'jewelry':
        return '1 Year Against Manufacturing Defects';
      default:
        return '30 Days Return Policy';
    }
  }

}

extension ProductModelExtension on ProductModel {
  Product toProduct() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating.toRating(),
      images: images,
      brand: brand,
      sku: sku,
      stock: stock,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      tags: tags,
      isAvailable: isAvailable,
      isFeatured: isFeatured,
      isNew: isNew,
      isOnSale: isOnSale,
      createdAt: createdAt,
      updatedAt: updatedAt,
      specifications: specifications,
      colors: colors,
      sizes: sizes,
      weight: weight,
      dimensions: dimensions,
      material: material,
      warranty: warranty,
      viewCount: viewCount,
      purchaseCount: purchaseCount,
      lastViewedAt: lastViewedAt,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
      'images': images,
      'brand': brand,
      'sku': sku,
      'stock': stock,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'tags': tags,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'isNew': isNew,
      'isOnSale': isOnSale,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'specifications': specifications,
      'colors': colors,
      'sizes': sizes,
      'weight': weight,
      'dimensions': dimensions,
      'material': material,
      'warranty': warranty,
      'viewCount': viewCount,
      'purchaseCount': purchaseCount,
      'lastViewedAt': lastViewedAt?.toIso8601String(),
    };
  }
}