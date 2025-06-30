import 'package:flutter/material.dart';

import '../widgets/notification_permission_dialog.dart';
import '../widgets/notification_preview_card.dart';
import '../widgets/notification_topic_selector.dart';

class NotificationOnboardingPage extends StatefulWidget {
  const NotificationOnboardingPage({super.key});

  @override
  State<NotificationOnboardingPage> createState() => _NotificationOnboardingPageState();
}

class _NotificationOnboardingPageState extends State<NotificationOnboardingPage> {
  bool permissionsRequested = false;
  List<String> selectedTopics = [];

  void _requestPermissions() async {
    await showDialog(
      context: context,
      builder: (ctx) => const NotificationPermissionDialog(),
    );
    setState(() {
      permissionsRequested = true;
    });
  }

  void _onTopicsChanged(List<String> topics) {
    setState(() {
      selectedTopics = topics;
    });
  }

  void _finishOnboarding() {
    // Here you could save onboarding completion, selected topics, etc.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Notified!'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              "Don't miss important updates",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const NotificationPreviewCard(
              // Optionally: Show a sample notification preview
              title: "Order Shipped!",
              body: "Your order #123456 has been shipped.",
              timestamp: "2025-06-23 09:14",
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Enable Push Notifications'),
              onPressed: permissionsRequested ? null : _requestPermissions,
            ),
            const SizedBox(height: 32),
            const Text(
              "Choose your interests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            NotificationTopicSelector(
              selectedTopics: selectedTopics,
              onTopicToggled: (topic, enabled) {
                final topics = List<String>.from(selectedTopics);
                if (enabled && !topics.contains(topic)) {
                  topics.add(topic);
                } else if (!enabled && topics.contains(topic)) {
                  topics.remove(topic);
                }
                _onTopicsChanged(topics);
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _finishOnboarding,
              child: const Text('Finish Setup'),
            ),
          ],
        ),
      ),
    );
  }
}