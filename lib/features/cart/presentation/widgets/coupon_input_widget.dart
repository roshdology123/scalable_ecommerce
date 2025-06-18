import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/app_logger.dart';

class CouponInputWidget extends StatefulWidget {
  final String? appliedCouponCode;
  final Function(String) onApplyCoupon;
  final Function(String) onRemoveCoupon;
  final bool isLoading;
  final String? errorMessage;
  final bool isExpanded;

  const CouponInputWidget({
    super.key,
    this.appliedCouponCode,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
    this.isLoading = false,
    this.errorMessage,
    this.isExpanded = false,
  });

  @override
  State<CouponInputWidget> createState() => _CouponInputWidgetState();
}

class _CouponInputWidgetState extends State<CouponInputWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AppLogger _logger = AppLogger();

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  bool _isExpanded = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.forward();
    }

    _logger.logBusinessLogic(
      'coupon_input_widget_initialized',
      'ui_component',
      {
        'has_applied_coupon': widget.appliedCouponCode != null,
        'applied_coupon': widget.appliedCouponCode,
        'is_expanded': _isExpanded,
        'user': 'roshdology123',
        'timestamp': '2025-06-18 14:18:15',
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CouponInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Clear local error if loading state changes
    if (widget.isLoading != oldWidget.isLoading) {
      _localError = null;
    }

    // Update expansion state if applied coupon changes
    if (widget.appliedCouponCode != oldWidget.appliedCouponCode) {
      if (widget.appliedCouponCode != null && !_isExpanded) {
        _toggleExpansion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),

            // Applied Coupon Display
            if (widget.appliedCouponCode != null)
              _buildAppliedCoupon(context),

            // Coupon Input Section
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: _buildCouponInput(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.local_offer_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          widget.appliedCouponCode != null ? 'Coupon Applied' : 'Have a coupon?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (widget.appliedCouponCode == null)
          TextButton(
            onPressed: widget.isLoading ? null : _toggleExpansion,
            child: Text(_isExpanded ? 'Hide' : 'Add Coupon'),
          ),
      ],
    );
  }

  Widget _buildAppliedCoupon(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appliedCouponCode!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'Coupon successfully applied',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          if (!widget.isLoading)
            IconButton(
              onPressed: () => _removeCoupon(widget.appliedCouponCode!),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 18,
              ),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  Widget _buildCouponInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Field
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: !widget.isLoading,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-_]')),
              LengthLimitingTextInputFormatter(50),
            ],
            decoration: InputDecoration(
              labelText: 'Coupon Code',
              hintText: 'Enter coupon code',
              prefixIcon: const Icon(Icons.confirmation_number_outlined),
              suffixIcon: _buildApplyButton(context),
              errorText: _localError ?? widget.errorMessage,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Clear error when user starts typing
              if (_localError != null) {
                setState(() {
                  _localError = null;
                });
              }
            },
            onFieldSubmitted: (_) => _applyCoupon(),
          ),

          const SizedBox(height: 8),

          // Popular Coupons
          _buildPopularCoupons(context),

          // Terms and Conditions
          Text(
            'Terms and conditions apply. One coupon per order.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return IconButton(
      onPressed: _controller.text.trim().isEmpty ? null : _applyCoupon,
      icon: const Icon(Icons.send),
      tooltip: 'Apply Coupon',
    );
  }

  Widget _buildPopularCoupons(BuildContext context) {
    // Mock popular coupons - in real app, get from API
    final popularCoupons = [
      {'code': 'SAVE10', 'description': '10% off'},
      {'code': 'FREESHIP', 'description': 'Free shipping'},
      {'code': 'FIRST20', 'description': '20% off first order'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Coupons',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: popularCoupons.map((coupon) {
            return InkWell(
              onTap: widget.isLoading ? null : () => _selectPopularCoupon(coupon['code']!),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      coupon['code']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• ${coupon['description']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    _logger.logUserAction('coupon_input_expansion_toggled', {
      'is_expanded': _isExpanded,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:18:15',
    });

    if (_isExpanded) {
      _animationController.forward();
      // Focus input when expanding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    } else {
      _animationController.reverse();
      _focusNode.unfocus();
    }
  }

  void _applyCoupon() {
    final couponCode = _controller.text.trim().toUpperCase();

    if (couponCode.isEmpty) {
      setState(() {
        _localError = 'Please enter a coupon code';
      });
      return;
    }

    if (couponCode.length < 3) {
      setState(() {
        _localError = 'Coupon code must be at least 3 characters';
      });
      return;
    }

    _logger.logUserAction('coupon_apply_attempted', {
      'coupon_code': couponCode,
      'input_method': 'manual',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:18:15',
    });

    widget.onApplyCoupon(couponCode);
    _controller.clear();
    _focusNode.unfocus();
  }

  void _selectPopularCoupon(String couponCode) {
    _logger.logUserAction('popular_coupon_selected', {
      'coupon_code': couponCode,
      'input_method': 'popular_selection',
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:18:15',
    });

    _controller.text = couponCode;
    _applyCoupon();
  }

  void _removeCoupon(String couponCode) {
    _logger.logUserAction('coupon_remove_attempted', {
      'coupon_code': couponCode,
      'user': 'roshdology123',
      'timestamp': '2025-06-18 14:18:15',
    });

    widget.onRemoveCoupon(couponCode);
  }
}