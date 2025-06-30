import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? imageUrl;
  final IconData? icon;
  final bool showCount;

  const CategoryChip({
    super.key,
    required this.label,
    this.count,
    this.isSelected = false,
    this.onTap,
    this.imageUrl,
    this.icon,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or image
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ] else if (imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl!,
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.category,
                    size: 16,
                    color: isSelected
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],

            // Label
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),

            // Count
            if (showCount && count != null && count! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colorScheme.onPrimary.withOpacity(0.2)
                      : context.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count!.toString(),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  final List<CategoryItem> categories;
  final Function(CategoryItem)? onCategoryTap;
  final int crossAxisCount;
  final double childAspectRatio;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryGridItem(
          category: category,
          onTap: () => onCategoryTap?.call(category),
        );
      },
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback? onTap;

  const _CategoryGridItem({
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: category.gradientColors ?? [
                context.colorScheme.primary.withOpacity(0.1),
                context.colorScheme.primary.withOpacity(0.2),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background image
              if (category.imageUrl != null)
                Positioned.fill(
                  child: Image.network(
                    category.imageUrl!,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.3),
                  ),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    if (category.icon != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          category.icon,
                          color: context.colorScheme.primary,
                          size: 24,
                        ),
                      ),

                    const Spacer(),

                    // Category name
                    Text(
                      category.name,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Product count
                    if (category.productCount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${category.productCount} products',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final String? imageUrl;
  final IconData? icon;
  final int? productCount;
  final List<Color>? gradientColors;

  const CategoryItem({
    required this.id,
    required this.name,
    this.imageUrl,
    this.icon,
    this.productCount,
    this.gradientColors,
  });
}