import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/profile_preferences/profile_preferences_cubit.dart';
import '../cubit/profile_preferences/profile_preferences_state.dart';
import '../widgets/preference_switch_tile.dart';
import '../widgets/preference_selection_tile.dart';
import '../../domain/entities/user_preferences.dart';

/// Notification Settings Page for detailed notification management
///
/// Features:
/// - Granular notification controls
/// - Frequency settings for different notification types
/// - Preview and test notifications
/// - Do Not Disturb scheduling
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  TimeOfDay? _quietHoursStart;
  TimeOfDay? _quietHoursEnd;

  @override
  void initState() {
    super.initState();
    // Initialize with default quiet hours (22:00 - 08:00)
    _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
    _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'test',
                child: Row(
                  children: [
                    Icon(Icons.send_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Test Notification'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Reset to Defaults'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<ProfilePreferencesCubit, ProfilePreferencesState>(
        listener: (context, state) {
          if (state is ProfilePreferencesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state is ProfileNotificationSettingsUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notification settings updated (${state.changedSettings.length} changes)'),
                backgroundColor: theme.colorScheme.tertiary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfilePreferencesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final preferences = _getPreferences(state);
          if (preferences == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load notification settings',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.read<ProfilePreferencesCubit>().loadPreferences(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return _buildNotificationSettings(preferences);
        },
      ),
    );
  }

  UserPreferences? _getPreferences(ProfilePreferencesState state) {
    if (state is ProfilePreferencesLoaded) return state.preferences;
    if (state is ProfilePreferencesUpdated) return state.preferences;
    if (state is ProfileNotificationSettingsUpdated) return state.preferences;
    if (state is ProfilePreferencesError) return state.currentPreferences;
    return null;
  }

  Widget _buildNotificationSettings(UserPreferences preferences) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Overview Card
          _buildStatusCard(preferences),

          const SizedBox(height: 24),

          // General Notification Settings
          _buildGeneralSettings(preferences),

          const SizedBox(height: 24),

          // Frequency Settings
          _buildFrequencySettings(preferences),

          const SizedBox(height: 24),

          // Quiet Hours Settings
          _buildQuietHoursSettings(),

          const SizedBox(height: 24),

          // Advanced Settings
          _buildAdvancedSettings(),
        ],
      ),
    );
  }

  Widget _buildStatusCard(UserPreferences preferences) {
    final theme = Theme.of(context);
    final notificationsEnabled = preferences.hasNotificationsEnabled;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: notificationsEnabled
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  notificationsEnabled ? 'Notifications Active' : 'Notifications Disabled',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: notificationsEnabled
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.error,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              notificationsEnabled
                  ? 'You\'ll receive notifications based on your preferences below.'
                  : 'All notifications are currently disabled. Enable them below to stay updated.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            // Quick stats
            Row(
              children: [
                Expanded(
                  child: _buildQuickStat(
                    'Push',
                    preferences.pushNotificationsEnabled ? 'On' : 'Off',
                    preferences.pushNotificationsEnabled
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickStat(
                    'Email',
                    preferences.emailNotificationsEnabled ? 'On' : 'Off',
                    preferences.emailNotificationsEnabled
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickStat(
                    'SMS',
                    preferences.smsNotificationsEnabled ? 'On' : 'Off',
                    preferences.smsNotificationsEnabled
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(UserPreferences preferences) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'General Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            PreferenceSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive notifications on this device',
              icon: Icons.notifications_active_outlined,
              value: preferences.pushNotificationsEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  pushNotifications: value,
                );
              },
            ),

            const SizedBox(height: 16),

            PreferenceSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive notifications at roshdology123@example.com',
              icon: Icons.email_outlined,
              value: preferences.emailNotificationsEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  emailNotifications: value,
                );
              },
            ),

            const SizedBox(height: 16),

            PreferenceSwitchTile(
              title: 'SMS Notifications',
              subtitle: 'Receive SMS at +20-12-3456-7890',
              icon: Icons.sms_outlined,
              value: preferences.smsNotificationsEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  smsNotifications: value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySettings(UserPreferences preferences) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Frequency Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            PreferenceSelectionTile(
              title: 'Order Updates',
              subtitle: 'Notifications about your orders',
              icon: Icons.shopping_bag_outlined,
              currentValue: preferences.orderUpdates.name,
              options: const [
                {'value': 'instant', 'label': 'Instant'},
                {'value': 'daily', 'label': 'Daily Summary'},
                {'value': 'weekly', 'label': 'Weekly Summary'},
                {'value': 'never', 'label': 'Never'},
              ],
              onChanged: (value) {
                final frequency = NotificationFrequency.values.firstWhere(
                      (f) => f.name == value,
                  orElse: () => NotificationFrequency.instant,
                );
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  orderUpdates: frequency,
                );
              },
            ),

            const SizedBox(height: 16),

            PreferenceSelectionTile(
              title: 'Promotional Emails',
              subtitle: 'Deals, offers, and special promotions',
              icon: Icons.local_offer_outlined,
              currentValue: preferences.promotionalEmails.name,
              options: const [
                {'value': 'instant', 'label': 'As They Come'},
                {'value': 'daily', 'label': 'Daily Digest'},
                {'value': 'weekly', 'label': 'Weekly Digest'},
                {'value': 'never', 'label': 'Never'},
              ],
              onChanged: (value) {
                final frequency = NotificationFrequency.values.firstWhere(
                      (f) => f.name == value,
                  orElse: () => NotificationFrequency.weekly,
                );
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  promotionalEmails: frequency,
                );
              },
            ),

            const SizedBox(height: 16),

            PreferenceSelectionTile(
              title: 'Newsletter',
              subtitle: 'Product updates and company news',
              icon: Icons.newspaper_outlined,
              currentValue: preferences.newsletterSubscription.name,
              options: const [
                {'value': 'weekly', 'label': 'Weekly'},
                {'value': 'never', 'label': 'Never'},
              ],
              onChanged: (value) {
                final frequency = NotificationFrequency.values.firstWhere(
                      (f) => f.name == value,
                  orElse: () => NotificationFrequency.weekly,
                );
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  newsletterSubscription: frequency,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuietHoursSettings() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bedtime_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quiet Hours',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Reduce notifications during your quiet hours. Emergency notifications will still come through.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildTimeSelector(
                    'Start Time',
                    _quietHoursStart,
                        (time) => setState(() => _quietHoursStart = time),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeSelector(
                    'End Time',
                    _quietHoursEnd,
                        (time) => setState(() => _quietHoursEnd = time),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Current: ${_formatTime(_quietHoursStart)} - ${_formatTime(_quietHoursEnd)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(String label, TimeOfDay? time, ValueChanged<TimeOfDay> onChanged) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: time ?? const TimeOfDay(hour: 22, minute: 0),
        );
        if (selectedTime != null) {
          onChanged(selectedTime);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(time),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Advanced Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.vibration_outlined,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
              ),
              title: const Text('Vibration'),
              subtitle: const Text('Configure vibration patterns'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Vibration settings coming soon!'),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.music_note_outlined,
                  size: 20,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              title: const Text('Notification Sounds'),
              subtitle: const Text('Customize notification tones'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Sound settings coming soon!'),
                    backgroundColor: theme.colorScheme.tertiary,
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.history_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              title: const Text('Notification History'),
              subtitle: const Text('View recent notifications'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Notification history coming soon!'),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Not set';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _handleMenuAction(String action) {
    final theme = Theme.of(context);

    switch (action) {
      case 'test':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🔔 Test notification sent to roshdology123!'),
            backgroundColor: theme.colorScheme.tertiary,
            action: SnackBarAction(
              label: 'View',
              onPressed: () {},
            ),
          ),
        );
        break;
      case 'reset':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset Notification Settings'),
            content: const Text(
              'This will reset all notification preferences to their default values. '
                  'This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Reset to default notification settings
                  context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                    pushNotifications: true,
                    emailNotifications: true,
                    smsNotifications: false,
                    orderUpdates: NotificationFrequency.instant,
                    promotionalEmails: NotificationFrequency.weekly,
                    newsletterSubscription: NotificationFrequency.weekly,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Notification settings reset to defaults'),
                      backgroundColor: theme.colorScheme.tertiary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        );
        break;
    }
  }
}