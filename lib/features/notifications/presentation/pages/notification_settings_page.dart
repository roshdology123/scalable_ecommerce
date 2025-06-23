import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification.dart';
import '../cubit/notification_preferences_cubit.dart';
import '../cubit/notification_preferences_state.dart';
import '../widgets/notification_settings_tile.dart';
import '../widgets/notification_permission_dialog.dart';
import '../widgets/notification_frequency_selector.dart';
import '../widgets/notification_topic_selector.dart';
import '../widgets/notification_error_widget.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const NotificationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<NotificationPreferencesCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification Settings'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Permissions',
              onPressed: () => _showPermissionDialog(context),
            ),
          ],
        ),
        body: BlocConsumer<NotificationPreferencesCubit, NotificationPreferencesState>(
          listener: (context, state) {
            if (state.hasError && state.statusMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.statusMessage)),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError) {
              return NotificationErrorWidget(
                message: state.statusMessage,
                onRetry: () => context.read<NotificationPreferencesCubit>().resetToDefaults(),
              );
            }
            final preferences = state.preferences;
            if (preferences == null) {
              return const Center(child: Text('No preferences found'));
            }
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              children: [
                NotificationSettingsTile(
                  title: 'Push Notifications',
                  value: preferences.pushNotificationsEnabled,
                  onChanged: (val) => context.read<NotificationPreferencesCubit>().togglePushNotifications(val),
                  subtitle: 'Enable push notifications on this device.',
                ),
                NotificationSettingsTile(
                  title: 'Email Notifications',
                  value: preferences.emailNotificationsEnabled,
                  onChanged: (val) => context.read<NotificationPreferencesCubit>().toggleEmailNotifications(val),
                  subtitle: 'Get notifications via email.',
                ),
                NotificationSettingsTile(
                  title: 'SMS Notifications',
                  value: preferences.smsNotificationsEnabled,
                  onChanged: (val) => context.read<NotificationPreferencesCubit>().toggleSMSNotifications(val),
                  subtitle: 'Receive SMS alerts for important events.',
                ),
                const Divider(),
                NotificationFrequencySelector(
                  title: 'Order Updates',
                  value: preferences.orderUpdatesFrequency,
                  onChanged: (freq) => context.read<NotificationPreferencesCubit>().updateFrequency(
                      NotificationType.orderUpdate, freq!),
                ),
                NotificationFrequencySelector(
                  title: 'Promotions',
                  value: preferences.promotionsFrequency,
                  onChanged: (freq) => context.read<NotificationPreferencesCubit>().updateFrequency(
                      NotificationType.promotion, freq!),
                ),
                NotificationFrequencySelector(
                  title: 'Newsletter',
                  value: preferences.newsletterFrequency,
                  onChanged: (freq) => context.read<NotificationPreferencesCubit>().updateFrequency(
                      NotificationType.general, freq!),
                ),
                const Divider(),
                NotificationSettingsTile(
                  title: 'Quiet Hours',
                  value: preferences.quietHoursEnabled,
                  onChanged: (val) => context.read<NotificationPreferencesCubit>().toggleQuietHours(val),
                  subtitle: 'Silence notifications during specific hours.',
                ),
                ListTile(
                  title: const Text('Quiet Hours Time'),
                  subtitle: Text('${preferences.quietHoursStart} - ${preferences.quietHoursEnd}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () {
                    // You can use your custom NotificationTimePicker here
                  },
                ),
                const Divider(),
                NotificationTopicSelector(
                  selectedTopics: preferences.subscribedTopics,
                  onTopicToggled: (topic, enabled) {
                    if (enabled) {
                      context.read<NotificationPreferencesCubit>().subscribeToTopic(topic);
                    } else {
                      context.read<NotificationPreferencesCubit>().unsubscribeFromTopic(topic);
                    }
                  },
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset to Default'),
                  onPressed: () => context.read<NotificationPreferencesCubit>().resetToDefaults(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}