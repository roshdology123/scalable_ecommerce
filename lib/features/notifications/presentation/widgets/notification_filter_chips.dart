import 'package:flutter/material.dart';
import '../../domain/entities/notification.dart';

class NotificationFilterChips extends StatelessWidget {
  final String? selectedType;
  final bool unreadOnly;
  final ValueChanged<NotificationType?>? onTypeChanged;
  final ValueChanged<bool>? onUnreadChanged;

  const NotificationFilterChips({
    super.key,
    this.selectedType,
    this.unreadOnly = false,
    this.onTypeChanged,
    this.onUnreadChanged,
  });

  @override
  Widget build(BuildContext context) {
    final types = [
      null,
      ...NotificationType.values,
    ]; // null for "All"

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          ...types.map((type) {
            final label = type == null ? 'All' : _typeLabel(type);
            final selected = type == selectedType || (type == null && selectedType == null);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) => onTypeChanged?.call(type),
                visualDensity: VisualDensity.compact,
              ),
            );
          }),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Unread only'),
            selected: unreadOnly,
            onSelected: onUnreadChanged,
            avatar: const Icon(Icons.mark_email_unread_outlined, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _typeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.orderUpdate:
        return "Order";
      case NotificationType.promotion:
        return "Promo";
      case NotificationType.cartAbandonment:
        return "Cart";
      case NotificationType.newProduct:
        return "New";
      case NotificationType.priceAlert:
        return "Price";
      case NotificationType.stockAlert:
        return "Stock";
      case NotificationType.general:
      default:
        return "Other";
    }
  }
}