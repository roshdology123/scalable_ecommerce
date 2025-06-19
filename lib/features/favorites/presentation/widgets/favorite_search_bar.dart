import 'package:flutter/material.dart';

class FavoritesSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final String? hintText;

  const FavoritesSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.hintText,
  });

  @override
  State<FavoritesSearchBar> createState() => _FavoritesSearchBarState();
}

class _FavoritesSearchBarState extends State<FavoritesSearchBar>
    with TickerProviderStateMixin {

  late AnimationController _focusController;
  late Animation<double> _focusAnimation;
  late FocusNode _focusNode;

  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusNode();
    _hasText = widget.controller.text.isNotEmpty;
  }

  void _initializeAnimations() {
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));
  }

  void _setupFocusNode() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });

      if (_hasFocus) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hasFocus
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.3),
              width: _hasFocus ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: (value) {
              setState(() {
                _hasText = value.isNotEmpty;
              });
              widget.onChanged(value);
            },
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Search favorites...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _hasFocus
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              suffixIcon: _hasText
                  ? IconButton(
                onPressed: () {
                  widget.controller.clear();
                  widget.onClear?.call();
                  setState(() {
                    _hasText = false;
                  });
                },
                icon: Icon(
                  Icons.clear,
                  color: colorScheme.onSurfaceVariant,
                ),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: theme.textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}