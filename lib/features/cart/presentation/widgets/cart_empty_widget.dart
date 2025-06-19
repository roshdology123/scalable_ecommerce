import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';

class CartEmptyWidget extends StatelessWidget {
  final String? message;
  final bool isLoading;
  final VoidCallback? onContinueShopping;
  final List<String>? suggestedCategories;
  final bool showRecommendations;

  const CartEmptyWidget({
    super.key,
    this.message,
    this.isLoading = false,
    this.onContinueShopping,
    this.suggestedCategories,
    this.showRecommendations = true,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    logger.logUserAction('cart_empty_widget_displayed', {
      'has_continue_shopping': onContinueShopping != null,
      'show_recommendations': showRecommendations,
      'is_loading': isLoading,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:18:15',
    });

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Empty Cart Illustration
              _buildEmptyCartIllustration(context),

              const SizedBox(height: 24),

              // Title
              Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Message
              Text(
                message ?? 'Looks like you haven\'t added anything to your cart yet.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Continue Shopping Button
              if (onContinueShopping != null)
                _buildContinueShoppingButton(context, logger),

              // Suggested Categories
              if (showRecommendations) ...[
                const SizedBox(height: 32),
                _buildSuggestedCategories(context, logger),
              ],

              // Benefits Section
              const SizedBox(height: 32),
              _buildBenefitsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCartIllustration(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          Positioned(
            right: 30,
            top: 25,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueShoppingButton(BuildContext context, AppLogger logger) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          logger.logUserAction('continue_shopping_from_empty_cart', {
            'source': 'empty_cart_widget',
            'user': 'roshdology123',
            'timestamp': '2025-06-18 14:18:15',
          });
          onContinueShopping?.call();
        },
        icon: const Icon(Icons.store),
        label: const Text('Start Shopping'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedCategories(BuildContext context, AppLogger logger) {
    final categories = suggestedCategories ?? [
      'Electronics',
      'Clothing',
      'Home & Garden',
      'Sports & Outdoors',
      'Books',
      'Beauty',
    ];

    return Column(
      children: [
        Text(
          'Browse Popular Categories',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            return ActionChip(
              label: Text(category),
              onPressed: () {
                logger.logUserAction('category_chip_pressed_from_empty_cart', {
                  'category': category,
                  'user': 'roshdology123',
                  'timestamp': '2025-06-18 14:18:15',
                });

                // Navigate to category
                Navigator.pushNamed(
                  context,
                  '/products',
                  arguments: {'category': category.toLowerCase()},
                );
              },
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    final benefits = [
      {
        'icon': Icons.local_shipping,
        'title': 'Free Shipping',
        'subtitle': 'On orders over \$50',
      },
      {
        'icon': Icons.security,
        'title': 'Secure Payment',
        'subtitle': 'Your data is protected',
      },
      {
        'icon': Icons.replay,
        'title': 'Easy Returns',
        'subtitle': '30-day return policy',
      },
    ];

    return Column(
      children: [
        Text(
          'Why Shop With Us?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ...benefits.map((benefit) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  benefit['icon'] as IconData,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit['title'] as String,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      benefit['subtitle'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}