import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/utils/extensions.dart';
import '../cubit/categories_state.dart';
import '../cubit/products_cubit.dart';
import '../cubit/categories_cubit.dart';

class ProductFilterDialog extends HookWidget {
  const ProductFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory = useState<String?>(null);
    final minPrice = useState<double?>(null);
    final maxPrice = useState<double?>(null);
    final minRating = useState<double?>(null);
    final selectedBrands = useState<Set<String>>({});
    final selectedColors = useState<Set<String>>({});
    final selectedSizes = useState<Set<String>>({});
    final inStockOnly = useState(false);
    final onSaleOnly = useState(false);
    final featuredOnly = useState(false);
    final newArrivalsOnly = useState(false);

    final minPriceController = useTextEditingController();
    final maxPriceController = useTextEditingController();

    // Initialize with current filters
    useEffect(() {
      final cubit = context.read<ProductsCubit>();
      final currentFilters = cubit.currentFilters;

      selectedCategory.value = currentFilters['category'];
      minPrice.value = currentFilters['minPrice'];
      maxPrice.value = currentFilters['maxPrice'];
      minRating.value = currentFilters['minRating'];

      if (currentFilters['brands'] != null) {
        selectedBrands.value = Set.from(currentFilters['brands']);
      }
      if (currentFilters['colors'] != null) {
        selectedColors.value = Set.from(currentFilters['colors']);
      }
      if (currentFilters['sizes'] != null) {
        selectedSizes.value = Set.from(currentFilters['sizes']);
      }

      inStockOnly.value = currentFilters['inStockOnly'] ?? false;
      onSaleOnly.value = currentFilters['onSaleOnly'] ?? false;
      featuredOnly.value = currentFilters['featuredOnly'] ?? false;
      newArrivalsOnly.value = currentFilters['newArrivalsOnly'] ?? false;

      if (minPrice.value != null) {
        minPriceController.text = minPrice.value!.toStringAsFixed(0);
      }
      if (maxPrice.value != null) {
        maxPriceController.text = maxPrice.value!.toStringAsFixed(0);
      }

      return null;
    }, []);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'products.filters'.tr(),
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _clearAllFilters(
                      selectedCategory,
                      minPrice,
                      maxPrice,
                      minRating,
                      selectedBrands,
                      selectedColors,
                      selectedSizes,
                      inStockOnly,
                      onSaleOnly,
                      featuredOnly,
                      newArrivalsOnly,
                      minPriceController,
                      maxPriceController,
                    ),
                    child: Text('products.clear_all'.tr()),
                  ),
                ],
              ),
            ),

            // Filter content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category filter
                    _buildCategoryFilter(context, selectedCategory),
                    const SizedBox(height: 24),

                    // Price range filter
                    _buildPriceRangeFilter(
                      context,
                      minPrice,
                      maxPrice,
                      minPriceController,
                      maxPriceController,
                    ),
                    const SizedBox(height: 24),

                    // Rating filter
                    _buildRatingFilter(context, minRating),
                    const SizedBox(height: 24),

                    // Brand filter
                    _buildBrandFilter(context, selectedBrands),
                    const SizedBox(height: 24),

                    // Color filter
                    _buildColorFilter(context, selectedColors),
                    const SizedBox(height: 24),

                    // Size filter
                    _buildSizeFilter(context, selectedSizes),
                    const SizedBox(height: 24),

                    // Toggle filters
                    _buildToggleFilters(
                      context,
                      inStockOnly,
                      onSaleOnly,
                      featuredOnly,
                      newArrivalsOnly,
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('common.cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _applyFilters(
                        context,
                        selectedCategory.value,
                        minPrice.value,
                        maxPrice.value,
                        minRating.value,
                        selectedBrands.value,
                        selectedColors.value,
                        selectedSizes.value,
                        inStockOnly.value,
                        onSaleOnly.value,
                        featuredOnly.value,
                        newArrivalsOnly.value,
                      ),
                      child: Text('products.apply_filters'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, ValueNotifier<String?> selectedCategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'products.category'.tr(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (categories, _) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // All categories option
                  FilterChip(
                    label: Text('products.all_categories'.tr()),
                    selected: selectedCategory.value == null,
                    onSelected: (selected) {
                      selectedCategory.value = selected ? null : selectedCategory.value;
                    },
                  ),
                  // Individual categories
                  ...categories.map((category) => FilterChip(
                    label: Text(category.displayName),
                    selected: selectedCategory.value == category.name,
                    onSelected: (selected) {
                      selectedCategory.value = selected ? category.name : null;
                    },
                  )),
                ],
              ),
              orElse: () => const CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(
      BuildContext context,
      ValueNotifier<double?> minPrice,
      ValueNotifier<double?> maxPrice,
      TextEditingController minPriceController,
      TextEditingController maxPriceController,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'products.price_range'.tr(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minPriceController,
                decoration: InputDecoration(
                  labelText: 'products.min_price'.tr(),
                  prefixText: '\$',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  minPrice.value = double.tryParse(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: maxPriceController,
                decoration: InputDecoration(
                  labelText: 'products.max_price'.tr(),
                  prefixText: '\$',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  maxPrice.value = double.tryParse(value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Quick price options
        Wrap(
          spacing: 8,
          children: [
            _buildPriceQuickOption(context, 'Under \$25', 0, 25, minPrice, maxPrice, minPriceController, maxPriceController),
            _buildPriceQuickOption(context, '\$25-\$50', 25, 50, minPrice, maxPrice, minPriceController, maxPriceController),
            _buildPriceQuickOption(context, '\$50-\$100', 50, 100, minPrice, maxPrice, minPriceController, maxPriceController),
            _buildPriceQuickOption(context, 'Over \$100', 100, null, minPrice, maxPrice, minPriceController, maxPriceController),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceQuickOption(
      BuildContext context,
      String label,
      double min,
      double? max,
      ValueNotifier<double?> minPrice,
      ValueNotifier<double?> maxPrice,
      TextEditingController minPriceController,
      TextEditingController maxPriceController,
      ) {
    final isSelected = minPrice.value == min && maxPrice.value == max;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          minPrice.value = min;
          maxPrice.value = max;
          minPriceController.text = min.toStringAsFixed(0);
          maxPriceController.text = max?.toStringAsFixed(0) ?? '';
        } else {
          minPrice.value = null;
          maxPrice.value = null;
          minPriceController.clear();
          maxPriceController.clear();
        }
      },
    );
  }

  Widget _buildRatingFilter(BuildContext context, ValueNotifier<double?> minRating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'products.minimum_rating'.tr(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [1, 2, 3, 4, 5].map((rating) {
            final isSelected = minRating.value == rating.toDouble();
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$rating'),
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('& up'),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                minRating.value = selected ? rating.toDouble() : null;
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBrandFilter(BuildContext context, ValueNotifier<Set<String>> selectedBrands) {
    // Mock brands - in real app, get from API
    final brands = ['Apple', 'Samsung', 'Nike', 'Adidas', 'Sony', 'Canon'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'products.brands'.tr(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: brands.map((brand) {
            final isSelected = selectedBrands.value.contains(brand);
            return FilterChip(
              label: Text(brand),
              selected: isSelected,
              onSelected: (selected) {
                final newSet = Set<String>.from(selectedBrands.value);
                if (selected) {
                  newSet.add(brand);
                } else {
                  newSet.remove(brand);
                }
                selectedBrands.value = newSet;
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorFilter(BuildContext context, ValueNotifier<Set<String>> selectedColors) {
    final colors = [
      {'name': 'Black', 'color': Colors.black},
      {'name': 'White', 'color': Colors.white},
      {'name': 'Red', 'color': Colors.red},
      {'name': 'Blue', 'color': Colors.blue},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Yellow', 'color': Colors.yellow},
      {'name': 'Purple', 'color': Colors.purple},
      {'name': 'Orange', 'color': Colors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'products.colors'.tr(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((colorData) {
            final colorName = colorData['name'] as String;
            final color = colorData['color'] as Color;
            final isSelected = selectedColors.value.contains(colorName);

            return GestureDetector(
              onTap: () {
                final newSet = Set<String>.from(selectedColors.value);
                if (isSelected) {
                  newSet.remove(colorName);
                } else {
                  newSet.add(colorName);
                }
                selectedColors.value = newSet;
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.outline,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(
                  Icons.check,
                  color: color == Colors.white || color == Colors.yellow
                      ? Colors.black
                      : Colors.white,
                  size: 20,
                )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeFilter(BuildContext context, ValueNotifier<Set<String>> selectedSizes) {
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'products.sizes'.tr(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sizes.map((size) {
            final isSelected = selectedSizes.value.contains(size);
            return FilterChip(
              label: Text(size),
              selected: isSelected,
              onSelected: (selected) {
                final newSet = Set<String>.from(selectedSizes.value);
                if (selected) {
                  newSet.add(size);
                } else {
                  newSet.remove(size);
                }
                selectedSizes.value = newSet;
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleFilters(
      BuildContext context,
      ValueNotifier<bool> inStockOnly,
      ValueNotifier<bool> onSaleOnly,
      ValueNotifier<bool> featuredOnly,
      ValueNotifier<bool> newArrivalsOnly,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'products.availability'.tr(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            SwitchListTile(
              title: Text('products.in_stock_only'.tr()),
              value: inStockOnly.value,
              onChanged: (value) => inStockOnly.value = value,
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text('products.on_sale_only'.tr()),
              value: onSaleOnly.value,
              onChanged: (value) => onSaleOnly.value = value,
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text('products.featured_only'.tr()),
              value: featuredOnly.value,
              onChanged: (value) => featuredOnly.value = value,
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text('products.new_arrivals_only'.tr()),
              value: newArrivalsOnly.value,
              onChanged: (value) => newArrivalsOnly.value = value,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ],
    );
  }

  void _clearAllFilters(
      ValueNotifier<String?> selectedCategory,
      ValueNotifier<double?> minPrice,
      ValueNotifier<double?> maxPrice,
      ValueNotifier<double?> minRating,
      ValueNotifier<Set<String>> selectedBrands,
      ValueNotifier<Set<String>> selectedColors,
      ValueNotifier<Set<String>> selectedSizes,
      ValueNotifier<bool> inStockOnly,
      ValueNotifier<bool> onSaleOnly,
      ValueNotifier<bool> featuredOnly,
      ValueNotifier<bool> newArrivalsOnly,
      TextEditingController minPriceController,
      TextEditingController maxPriceController,
      ) {
    selectedCategory.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    minRating.value = null;
    selectedBrands.value = {};
    selectedColors.value = {};
    selectedSizes.value = {};
    inStockOnly.value = false;
    onSaleOnly.value = false;
    featuredOnly.value = false;
    newArrivalsOnly.value = false;
    minPriceController.clear();
    maxPriceController.clear();
  }

  void _applyFilters(
      BuildContext context,
      String? category,
      double? minPrice,
      double? maxPrice,
      double? minRating,
      Set<String> brands,
      Set<String> colors,
      Set<String> sizes,
      bool inStockOnly,
      bool onSaleOnly,
      bool featuredOnly,
      bool newArrivalsOnly,
      ) {
    context.read<ProductsCubit>().applyFilters(
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      brands: brands.isEmpty ? null : brands.toList(),
      colors: colors.isEmpty ? null : colors.toList(),
      sizes: sizes.isEmpty ? null : sizes.toList(),
      inStockOnly: inStockOnly ? true : null,
      onSaleOnly: onSaleOnly ? true : null,
      featuredOnly: featuredOnly ? true : null,
      newArrivalsOnly: newArrivalsOnly ? true : null,
    );

    Navigator.of(context).pop();
  }
}