import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';

class EmptyCartPage extends StatelessWidget {
  final String? message;
  final VoidCallback? onContinueShopping;
  final List<Widget>? additionalActions;

  const EmptyCartPage({
    super.key,
    this.message,
    this.onContinueShopping,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    logger.logUserAction('empty_cart_page_viewed', {
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
      'has_continue_shopping': onContinueShopping != null,
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Empty cart illustration
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

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
                message ?? 'Start adding items to your cart to see them here.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Continue shopping button
              if (onContinueShopping != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      logger.logUserAction('continue_shopping_pressed', {
                        'source': 'empty_cart_page',
                        'user': 'roshdology123',
                        'timestamp': '2025-06-18 14:08:39',
                      });
                      onContinueShopping!();
                    },
                    icon: const Icon(Icons.store),
                    label: const Text('Continue Shopping'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Additional actions
              if (additionalActions != null) ...additionalActions!,

              // Popular categories or suggestions could go here
              const SizedBox(height: 32),

              Text(
                'Popular Categories',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _CategoryChip(
                    label: 'Electronics',
                    onTap: () => _navigateToCategory(context, 'electronics', logger),
                  ),
                  _CategoryChip(
                    label: 'Clothing',
                    onTap: () => _navigateToCategory(context, 'clothing', logger),
                  ),
                  _CategoryChip(
                    label: 'Home & Garden',
                    onTap: () => _navigateToCategory(context, 'home', logger),
                  ),
                  _CategoryChip(
                    label: 'Sports',
                    onTap: () => _navigateToCategory(context, 'sports', logger),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String category, AppLogger logger) {
    logger.logUserAction('empty_cart_category_selected', {
      'category': category,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:08:39',
    });

    Navigator.pushNamed(
      context,
      '/products',
      arguments: {'category': category},
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}