import 'package:flutter/material.dart';

import '../../../profile/domain/entities/user_preferences.dart';



class NotificationFrequencySelector extends StatelessWidget {
  final String title;
  final NotificationFrequency value;
  final ValueChanged<NotificationFrequency?> onChanged;

  const NotificationFrequencySelector({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Frequency: ${value.name}'),
      trailing: DropdownButton<NotificationFrequency>(
        value: value,
        onChanged: onChanged,
        items: NotificationFrequency.values
            .map((freq) => DropdownMenuItem(
          value: freq,
          child: Text(freq.name),
        ))
            .toList(),
      ),
    );
  }
}