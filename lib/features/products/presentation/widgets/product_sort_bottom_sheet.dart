import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../cubit/products_cubit.dart';

class ProductSortBottomSheet extends StatelessWidget {
  const ProductSortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    final currentSortBy = cubit.currentSortBy;
    final currentSortOrder = cubit.currentSortOrder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.sort,
                color: context.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                'products.sort_by'.tr(),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sort options
          ..._buildSortOptions(context, currentSortBy, currentSortOrder),

          const SizedBox(height: 16),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('common.apply'.tr()),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  List<Widget> _buildSortOptions(
      BuildContext context,
      String? currentSortBy,
      String? currentSortOrder
      ) {
    final sortOptions = [
      SortOption(
        title: 'products.sort_popularity'.tr(),
        subtitle: 'products.sort_popularity_desc'.tr(),
        sortBy: 'popularity',
        sortOrder: 'desc',
        icon: Icons.trending_up,
      ),
      SortOption(
        title: 'products.sort_newest'.tr(),
        subtitle: 'products.sort_newest_desc'.tr(),
        sortBy: 'created_at',
        sortOrder: 'desc',
        icon: Icons.new_releases,
      ),
      SortOption(
        title: 'products.sort_price_low_high'.tr(),
        subtitle: 'products.sort_price_low_high_desc'.tr(),
        sortBy: 'price',
        sortOrder: 'asc',
        icon: Icons.arrow_upward,
      ),
      SortOption(
        title: 'products.sort_price_high_low'.tr(),
        subtitle: 'products.sort_price_high_low_desc'.tr(),
        sortBy: 'price',
        sortOrder: 'desc',
        icon: Icons.arrow_downward,
      ),
      SortOption(
        title: 'products.sort_rating'.tr(),
        subtitle: 'products.sort_rating_desc'.tr(),
        sortBy: 'rating',
        sortOrder: 'desc',
        icon: Icons.star,
      ),
      SortOption(
        title: 'products.sort_name_az'.tr(),
        subtitle: 'products.sort_name_az_desc'.tr(),
        sortBy: 'title',
        sortOrder: 'asc',
        icon: Icons.sort_by_alpha,
      ),
      SortOption(
        title: 'products.sort_discount'.tr(),
        subtitle: 'products.sort_discount_desc'.tr(),
        sortBy: 'discount',
        sortOrder: 'desc',
        icon: Icons.percent,
      ),
    ];

    return sortOptions.map((option) {
      final isSelected = currentSortBy == option.sortBy &&
          currentSortOrder == option.sortOrder;

      return _SortOptionTile(
        option: option,
        isSelected: isSelected,
        onTap: () => _applySorting(context, option.sortBy, option.sortOrder),
      );
    }).toList();
  }

  void _applySorting(BuildContext context, String sortBy, String sortOrder) {
    context.read<ProductsCubit>().sortProducts(sortBy, sortOrder);
  }
}

class SortOption {
  final String title;
  final String subtitle;
  final String sortBy;
  final String sortOrder;
  final IconData icon;

  const SortOption({
    required this.title,
    required this.subtitle,
    required this.sortBy,
    required this.sortOrder,
    required this.icon,
  });
}

class _SortOptionTile extends StatelessWidget {
  final SortOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        option.icon,
        color: isSelected
            ? context.colorScheme.primary
            : context.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        option.title,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : null,
          color: isSelected ? context.colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        option.subtitle,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: context.colorScheme.primary,
      )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor: isSelected
          ? context.colorScheme.primaryContainer.withOpacity(0.3)
          : null,
    );
  }
}