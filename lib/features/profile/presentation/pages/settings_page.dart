import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/themes/theme_cubit.dart';
import '../../domain/entities/user_preferences.dart';
import '../cubit/profile_preferences/profile_preferences_cubit.dart';
import '../cubit/profile_preferences/profile_preferences_state.dart';
import '../widgets/preference_selection_tile.dart';
import '../widgets/preference_switch_tile.dart';

/// Settings Page for app configuration
///
/// Features:
/// - Theme selection (Light, Dark, System)
/// - Language preferences
/// - Notification settings
/// - Privacy controls
/// - Data management options
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load preferences when page opens
    context.read<ProfilePreferencesCubit>().loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
          } else if (state is ProfileThemeChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Theme changed to ${state.newTheme.name}'),
                backgroundColor: theme.colorScheme.tertiary,
              ),
            );
          } else if (state is ProfileLanguageChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Language changed to ${state.newLanguage.name}'),
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
            debugPrint('Current State is ${state.runtimeType}');
            // Show a spinner during loading or updating, not an error
            if (state is ProfilePreferencesLoading || state is ProfilePreferencesUpdating || state is ProfileLanguageChanging) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load settings',
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

          return _buildSettingsContent(preferences!);
        },
      ),
    );
  }

  UserPreferences? _getPreferences(ProfilePreferencesState state) {
    if (state is ProfilePreferencesLoaded) return state.preferences;
    if (state is ProfilePreferencesUpdated) return state.preferences;
    if (state is ProfileThemeChanged) return state.preferences;
    if (state is ProfileLanguageChanged) return state.preferences;
    if (state is ProfileNotificationSettingsUpdated) return state.preferences;
    if (state is ProfilePrivacySettingsUpdated) return state.preferences;
    if (state is ProfileSecuritySettingsUpdated) return state.preferences;
    if (state is ProfilePreferencesError) return state.currentPreferences;
    return null;
  }

  Widget _buildSettingsContent(UserPreferences preferences) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          _buildUserInfoCard(),

          const SizedBox(height: 24),

          // Appearance Section
          _buildAppearanceSection(preferences),

          const SizedBox(height: 24),

          // Notifications Section
          _buildNotificationsSection(preferences),

          const SizedBox(height: 24),

          // Privacy Section
          _buildPrivacySection(preferences),

          const SizedBox(height: 24),

          // Security Section
          _buildSecuritySection(preferences),

          const SizedBox(height: 24),

          // Data & Storage Section
          _buildDataSection(),

          const SizedBox(height: 24),

          // About Section
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                'AH',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ahmed Hassan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'roshdology123@example.com',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Gold Member',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.push('/profile/edit'),
              icon: Icon(
                Icons.edit_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(UserPreferences preferences) {
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
                  Icons.palette_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Appearance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return PreferenceSelectionTile(
                  title: 'Theme',
                  subtitle: 'Choose your preferred theme',
                  icon: Icons.brightness_6_outlined,
                  currentValue: themeState.themeMode.name,
                  options: const [
                    {'value': 'system', 'label': 'System'},
                    {'value': 'light', 'label': 'Light'},
                    {'value': 'dark', 'label': 'Dark'},
                  ],
                  onChanged: (value) {
                    final themeCubit = context.read<ThemeCubit>();
                    switch (value) {
                      case 'light':
                        themeCubit.setLightTheme();
                        break;
                      case 'dark':
                        themeCubit.setDarkTheme();
                        break;
                      case 'system':
                        themeCubit.setSystemTheme();
                        break;
                    }

                    // Also update in preferences
                    final newThemeMode = value == 'light'
                        ? ThemeMode.light
                        : value == 'dark'
                        ? ThemeMode.dark
                        : ThemeMode.system;
                    context.read<ProfilePreferencesCubit>().updateTheme(newThemeMode);
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            PreferenceSelectionTile(
              title: 'Language',
              subtitle: 'Choose your preferred language',
              icon: Icons.language_outlined,
              currentValue: preferences.language.name,
              options: const [
                {'value': 'english', 'label': 'English'},
                {'value': 'arabic', 'label': 'العربية'},
              ],
              onChanged: (value) {
                final language = value == 'arabic' ? Language.arabic : Language.english;
                context.read<ProfilePreferencesCubit>().updateLanguage(language);
                context.setLocale(Locale(language.name == 'arabic' ? 'ar' : 'en'));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(UserPreferences preferences) {
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
                  'Notifications',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            PreferenceSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive notifications on your device',
              icon: Icons.notifications_active_outlined,
              value: preferences.pushNotificationsEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  pushNotifications: value,
                );
              },
            ),

            const SizedBox(height: 12),

            PreferenceSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              icon: Icons.email_outlined,
              value: preferences.emailNotificationsEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  emailNotifications: value,
                );
              },
            ),

            const SizedBox(height: 12),

            PreferenceSwitchTile(
              title: 'SMS Notifications',
              subtitle: 'Receive notifications via SMS',
              icon: Icons.sms_outlined,
              value: preferences.smsNotificationsEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateNotificationSettings(
                  smsNotifications: value,
                );
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.tune_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Advanced Notification Settings'),
              subtitle: const Text('Customize notification frequency and types'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/profile/settings/notifications'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(UserPreferences preferences) {
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
                  Icons.privacy_tip_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Privacy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Score: ${preferences.privacyScore}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            PreferenceSwitchTile(
              title: 'Analytics Data Sharing',
              subtitle: 'Help improve the app with usage analytics',
              icon: Icons.analytics_outlined,
              value: preferences.shareDataForAnalytics,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updatePrivacySettings(
                  shareDataForAnalytics: value,
                );
              },
            ),

            const SizedBox(height: 12),

            PreferenceSwitchTile(
              title: 'Marketing Data Sharing',
              subtitle: 'Receive personalized offers and recommendations',
              icon: Icons.campaign_outlined,
              value: preferences.shareDataForMarketing,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updatePrivacySettings(
                  shareDataForMarketing: value,
                );
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.shield_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Manage your privacy preferences'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/profile/settings/privacy'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection(UserPreferences preferences) {
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
                  Icons.security_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Security',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getSecurityLevelColor(theme, preferences.securityLevel),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    preferences.securityLevel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            PreferenceSwitchTile(
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID to unlock',
              icon: Icons.fingerprint_outlined,
              value: preferences.biometricAuthEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateSecuritySettings(
                  biometricAuth: value,
                );
              },
            ),

            const SizedBox(height: 12),

            PreferenceSwitchTile(
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security',
              icon: Icons.verified_user_outlined,
              value: preferences.twoFactorAuthEnabled,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updateSecuritySettings(
                  twoFactorAuth: value,
                );
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.lock_outline,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Change Password'),
              subtitle: const Text('Update your account password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/profile/change-password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection() {
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
                  Icons.storage_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Data & Storage',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.download_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Export Data'),
              subtitle: const Text('Download your account data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _exportData(),
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.clear_all_outlined,
                color: theme.colorScheme.secondary,
              ),
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _clearCache(),
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.refresh_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Reset Settings'),
              subtitle: const Text('Reset all settings to default'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _resetSettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
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
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'About',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.help_outline,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Help & Support'),
              subtitle: const Text('Get help and contact support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/support'),
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Terms & Privacy'),
              subtitle: const Text('Read our terms and privacy policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/legal'),
            ),

            const SizedBox(height: 16),

            Center(
              child: Column(
                children: [
                  Text(
                    'Scalable E-Commerce',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 • Built with Flutter',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last updated: 2025-06-22 09:09:04',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Color _getSecurityLevelColor(ThemeData theme, String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return theme.colorScheme.tertiary;
      case 'medium':
        return theme.colorScheme.secondary;
      default: // Basic
        return theme.colorScheme.error;
    }
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Account Data'),
        content: const Text(
          'This will create a downloadable file containing all your account data. '
              'The download link will be sent to your email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data export started. Check your email for download link.'),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data and free up storage space. '
              'You may need to reload some content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cache cleared successfully'),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'This will reset all your preferences to default values. '
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
              context.read<ProfilePreferencesCubit>().resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings reset to defaults'),
                  backgroundColor: theme.colorScheme.tertiary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}