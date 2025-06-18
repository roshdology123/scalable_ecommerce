import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartFloatingSummary extends StatefulWidget {
  final VoidCallback? onTap;
  final bool showItemCount;
  final bool showTotal;
  final double? elevation;

  const CartFloatingSummary({
    super.key,
    this.onTap,
    this.showItemCount = true,
    this.showTotal = true,
    this.elevation,
  });

  @override
  State<CartFloatingSummary> createState() => _CartFloatingSummaryState();
}

class _CartFloatingSummaryState extends State<CartFloatingSummary>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logger = AppLogger();

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state.hasItems && !_animationController.isCompleted) {
          _animationController.forward();
        } else if (!state.hasItems && _animationController.isCompleted) {
          _animationController.reverse();
        }
      },
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (!state.hasItems) {
            return const SizedBox.shrink();
          }

          final cart = state.cart!;

          logger.logBusinessLogic(
            'cart_floating_summary_displayed',
            'ui_component',
            {
              'items_count': cart.items.length,
              'total': cart.summary.total,
              'is_animating': _animationController.isAnimating,
              'user': 'roshdology123',
              'timestamp': '2025-06-18 14:20:50',
            },
          );

          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Material(
                      elevation: widget.elevation ?? 8,
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: InkWell(
                        onTap: widget.onTap != null ? () {
                          logger.logUserAction('cart_floating_summary_tapped', {
                            'items_count': cart.items.length,
                            'total': cart.summary.total,
                            'user': 'roshdology123',
                            'timestamp': '2025-06-18 14:20:50',
                          });
                          widget.onTap!();
                        } : null,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Cart Icon with Badge
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(
                                    Icons.shopping_cart,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                  if (widget.showItemCount)
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.error,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          cart.summary.totalQuantity.toString(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onError,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(width: 12),

                              // Summary Text
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.showItemCount)
                                    Text(
                                      '${cart.summary.totalQuantity} item${cart.summary.totalQuantity == 1 ? '' : 's'}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  if (widget.showTotal)
                                    Text(
                                      cart.summary.formattedTotal,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(width: 8),

                              // Arrow Icon
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}