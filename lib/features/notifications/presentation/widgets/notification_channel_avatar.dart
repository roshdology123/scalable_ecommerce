import 'package:flutter/material.dart';

class NotificationChannelAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double radius;
  final Color? backgroundColor;

  const NotificationChannelAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.radius = 20,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey[200],
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.blueGrey[200],
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}