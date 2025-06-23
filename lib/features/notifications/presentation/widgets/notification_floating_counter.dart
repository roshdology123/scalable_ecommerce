import 'package:flutter/material.dart';

class NotificationFloatingCounter extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const NotificationFloatingCounter({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return Positioned(
      right: 16,
      bottom: 32,
      child: FloatingActionButton(
        heroTag: 'notification_floating_counter',
        onPressed: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.notifications),
            Positioned(
              right: 0,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}