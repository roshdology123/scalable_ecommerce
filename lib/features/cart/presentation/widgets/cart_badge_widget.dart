import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartBadgeWidget extends StatelessWidget {
  final Widget child;
  final bool showZero;
  final Color? badgeColor;
  final Color? textColor;
  final double? badgeSize;
  final VoidCallback? onTap;

  const CartBadgeWidget({
    super.key,
    required this.child,
    this.showZero = false,
    this.badgeColor,
    this.textColor,
    this.badgeSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final itemCount = state.itemsCount;

        // Log badge display
        logger.logBusinessLogic(
          'cart_badge_displayed',
          'ui_component',
          {
            'item_count': itemCount,
            'show_zero': showZero,
            'show_badge': itemCount > 0 || showZero,
            'user': 'roshdology123',
            'timestamp': '2025-06-18 14:20:50',
          },
        );

        return GestureDetector(
          onTap: onTap != null ? () {
            logger.logUserAction('cart_badge_tapped', {
              'item_count': itemCount,
              'user': 'roshdology123',
              'timestamp': '2025-06-18 14:20:50',
            });
            onTap!();
          } : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,

              // Badge
              if (itemCount > 0 || showZero)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: badgeColor ?? Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    constraints: BoxConstraints(
                      minWidth: badgeSize ?? 20,
                      minHeight: badgeSize ?? 20,
                    ),
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor ?? Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}