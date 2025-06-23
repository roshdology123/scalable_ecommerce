import 'package:flutter/material.dart';

/// Example list of notification topics. Replace or extend with your real topics as needed.
const List<String> allNotificationTopics = [
  'Order Updates',
  'Promotions',
  'Newsletter',
  'Recommendations',
  'Feedback',
];

class NotificationTopicSelector extends StatelessWidget {
  final List<String> selectedTopics;
  final void Function(String topic, bool enabled) onTopicToggled;

  const NotificationTopicSelector({
    super.key,
    required this.selectedTopics,
    required this.onTopicToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allNotificationTopics.map((topic) {
        final isSelected = selectedTopics.contains(topic);
        return FilterChip(
          label: Text(topic),
          selected: isSelected,
          onSelected: (enabled) => onTopicToggled(topic, enabled),
        );
      }).toList(),
    );
  }
}