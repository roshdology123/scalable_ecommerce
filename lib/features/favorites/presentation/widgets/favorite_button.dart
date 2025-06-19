import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../products/domain/entities/product.dart';
import '../cubit/favorites_cubit/favorites_cubit.dart';

class FavoriteButton extends StatefulWidget {
  final Product product;
  final double size;
  final Color? color;
  final Color? activeColor;
  final VoidCallback? onToggle;
  final bool showAnimation;

  const FavoriteButton({
    super.key,
    required this.product,
    this.size = 24.0,
    this.color,
    this.activeColor,
    this.onToggle,
    this.showAnimation = true,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with TickerProviderStateMixin {

  static const String _userContext = 'roshdology123';
  final AppLogger _logger = AppLogger();

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkFavoriteStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _checkFavoriteStatus() async {
    if (mounted) {
      final isFavorite = await context.read<FavoritesCubit>().isFavorite(widget.product.id);
      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: _isLoading ? null : _handleToggle,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.showAnimation ? _scaleAnimation.value : 1.0,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: widget.size + 16,
                  height: widget.size + 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isFavorite
                        ? (widget.activeColor ?? colorScheme.primary).withOpacity(0.1)
                        : Colors.transparent,
                    border: _pulseController.isAnimating
                        ? Border.all(
                      color: (widget.activeColor ?? colorScheme.primary)
                          .withOpacity(1.0 - _pulseAnimation.value + 0.5),
                      width: 2.0 * _pulseAnimation.value,
                    )
                        : null,
                  ),
                  child: Center(
                    child: _isLoading
                        ? SizedBox(
                      width: widget.size * 0.7,
                      height: widget.size * 0.7,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.color ?? colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                        : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isFavorite),
                        size: widget.size,
                        color: _isFavorite
                            ? (widget.activeColor ?? colorScheme.primary)
                            : (widget.color ?? colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleToggle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Optimistic update
    final wasLiked = _isFavorite;
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Trigger animation
    if (widget.showAnimation) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      if (_isFavorite) {
        _pulseController.forward().then((_) {
          _pulseController.reverse();
        });
      }
    }

    _logger.logUserAction('favorite_button_tapped', {
      'user': _userContext,
      'product_id': widget.product.id,
      'product_title': widget.product.title,
      'action': _isFavorite ? 'added' : 'removed',
      'timestamp': '2025-06-19T13:02:59Z',
    });

    try {
      final success = await context.read<FavoritesCubit>().toggleFavorite(
        widget.product,
      );

      if (mounted) {
        setState(() {
          _isFavorite = success;
          _isLoading = false;
        });

        // Show feedback
        if (!success != wasLiked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? '${widget.product.title} added to favorites'
                    : '${widget.product.title} removed from favorites',
              ),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: _handleToggle,
              ),
            ),
          );
        }

        widget.onToggle?.call();
      }
    } catch (e) {
      // Revert optimistic update
      if (mounted) {
        setState(() {
          _isFavorite = wasLiked;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update favorite. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

      _logger.logErrorWithContext(
        'FavoriteButton._handleToggle',
        e,
        StackTrace.current,
        {
          'user': _userContext,
          'product_id': widget.product.id,
        },
      );
    }
  }
}