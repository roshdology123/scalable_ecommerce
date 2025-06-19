import 'package:flutter/material.dart';

import '../../../../core/utils/app_logger.dart';

class FavoritesBatchActions extends StatefulWidget {
  final int selectedCount;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToCollection;
  final VoidCallback? onShare;
  final VoidCallback? onExport;

  const FavoritesBatchActions({
    super.key,
    required this.selectedCount,
    this.onDelete,
    this.onAddToCollection,
    this.onShare,
    this.onExport,
  });

  @override
  State<FavoritesBatchActions> createState() => _FavoritesBatchActionsState();
}

class _FavoritesBatchActionsState extends State<FavoritesBatchActions>
    with TickerProviderStateMixin {

  static const String _userContext = 'roshdology123';
  static const String _currentTimestamp = '2025-06-19T13:25:19Z';
  final AppLogger _logger = AppLogger();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _slideController.forward();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              '${widget.selectedCount} ${widget.selectedCount == 1 ? 'item' : 'items'} selected',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                // Add to Collection
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.folder_outlined,
                    label: 'Collection',
                    onPressed: widget.onAddToCollection,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 12),

                // Share
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onPressed: widget.onShare,
                    color: colorScheme.tertiary,
                  ),
                ),

                const SizedBox(width: 12),

                // Export
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.download_outlined,
                    label: 'Export',
                    onPressed: widget.onExport,
                    color: colorScheme.secondary,
                  ),
                ),

                const SizedBox(width: 12),

                // Delete
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.delete_outlined,
                    label: 'Delete',
                    onPressed: widget.onDelete,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback? onPressed,
        required Color color,
      }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        _logger.logUserAction('batch_action_tapped', {
          'user': _userContext,
          'action': label.toLowerCase(),
          'selected_count': widget.selectedCount,
          'timestamp': _currentTimestamp,
        });
        onPressed?.call();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}