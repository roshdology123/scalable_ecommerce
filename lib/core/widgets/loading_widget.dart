import 'package:flutter/material.dart';

/// Reusable Loading Widget with customizable appearance
///
/// Features:
/// - Material 3 design compliance
/// - Customizable message and size
/// - Animation support
/// - Theme-aware colors
/// - Multiple loading states
class LoadingWidget extends StatefulWidget {
  final String? message;
  final double size;
  final Color? color;
  final LoadingType type;
  final bool showMessage;
  final EdgeInsets padding;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 32.0,
    this.color,
    this.type = LoadingType.circular,
    this.showMessage = true,
    this.padding = const EdgeInsets.all(16.0),
  });

  /// Named constructor for minimal loading indicator
  const LoadingWidget.minimal({
    super.key,
    this.size = 20.0,
    this.color,
    this.type = LoadingType.circular,
  })  : message = null,
        showMessage = false,
        padding = EdgeInsets.zero;

  /// Named constructor for full screen loading
  const LoadingWidget.fullScreen({
    super.key,
    this.message = 'Loading...',
    this.size = 48.0,
    this.color,
    this.type = LoadingType.circular,
  })  : showMessage = true,
        padding = const EdgeInsets.all(32.0);

  /// Named constructor for inline loading
  const LoadingWidget.inline({
    super.key,
    this.message,
    this.size = 16.0,
    this.color,
    this.type = LoadingType.circular,
  })  : showMessage = false,
        padding = const EdgeInsets.all(8.0);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();

    if (widget.type == LoadingType.pulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.color ?? theme.colorScheme.primary;

    return Padding(
      padding: widget.padding,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoadingIndicator(effectiveColor),

            if (widget.showMessage && widget.message != null) ...[
              const SizedBox(height: 16),
              _buildLoadingMessage(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    switch (widget.type) {
      case LoadingType.circular:
        return _buildCircularIndicator(color);
      case LoadingType.linear:
        return _buildLinearIndicator(color);
      case LoadingType.pulse:
        return _buildPulseIndicator(color);
      case LoadingType.dots:
        return _buildDotsIndicator(color);
      case LoadingType.spinner:
        return _buildSpinnerIndicator(color);
    }
  }

  Widget _buildCircularIndicator(Color color) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        strokeWidth: widget.size * 0.08,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildLinearIndicator(Color color) {
    return SizedBox(
      width: widget.size * 2,
      child: LinearProgressIndicator(
        minHeight: 4,
        backgroundColor: color.withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildPulseIndicator(Color color) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDotsIndicator(Color color) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final delay = index * 0.2;
              final animationValue = (_pulseController.value + delay) % 1.0;
              final scale = 0.5 + (0.5 * (1 - (animationValue - 0.5).abs() * 2));

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size * 0.2,
                  height: widget.size * 0.2,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildSpinnerIndicator(Color color) {
    return RotationTransition(
      turns: _pulseController,
      child: Icon(
        Icons.refresh,
        size: widget.size,
        color: color,
      ),
    );
  }

  Widget _buildLoadingMessage(ThemeData theme) {
    return Text(
      widget.message!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Types of loading animations available
enum LoadingType {
  circular,
  linear,
  pulse,
  dots,
  spinner,
}

/// Loading overlay that can be shown over content
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? backgroundColor;
  final LoadingType type;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.backgroundColor,
    this.type = LoadingType.circular,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ??
                theme.colorScheme.surface.withOpacity(0.8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: LoadingWidget(
                  message: message,
                  type: type,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Loading state widget for list items
class LoadingListItem extends StatelessWidget {
  final double height;
  final EdgeInsets margin;

  const LoadingListItem({
    super.key,
    this.height = 80.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      margin: margin,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildShimmerBox(48, 48, theme),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerBox(double.infinity, 16, theme),
                    const SizedBox(height: 8),
                    _buildShimmerBox(120, 12, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, ThemeData theme) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}