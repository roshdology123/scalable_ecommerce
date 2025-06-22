import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/profile_preferences/profile_preferences_cubit.dart';
import '../cubit/profile_preferences/profile_preferences_state.dart';
import '../widgets/preference_switch_tile.dart';
import '../../domain/entities/user_preferences.dart';

/// Privacy Settings Page for data control and privacy management
///
/// Features:
/// - Data sharing controls
/// - Privacy score tracking
/// - GDPR compliance options
/// - Account data management
class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showPrivacyHelp(context),
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
          } else if (state is ProfilePrivacySettingsUpdated) {
            final scoreChange = state.newPrivacyScore - state.previousPrivacyScore;
            final message = scoreChange > 0
                ? 'Privacy score increased to ${state.newPrivacyScore}%'
                : scoreChange < 0
                ? 'Privacy score decreased to ${state.newPrivacyScore}%'
                : 'Privacy settings updated';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
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
                    Icons.privacy_tip_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load privacy settings',
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

          return _buildPrivacySettings(context, preferences);
        },
      ),
    );
  }

  UserPreferences? _getPreferences(ProfilePreferencesState state) {
    if (state is ProfilePreferencesLoaded) return state.preferences;
    if (state is ProfilePreferencesUpdated) return state.preferences;
    if (state is ProfilePrivacySettingsUpdated) return state.preferences;
    if (state is ProfilePreferencesError) return state.currentPreferences;
    return null;
  }

  Widget _buildPrivacySettings(BuildContext context, UserPreferences preferences) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Privacy Score Card
          _buildPrivacyScoreCard(context, preferences),

          const SizedBox(height: 24),

          // Data Sharing Section
          _buildDataSharingSection(context, preferences),

          const SizedBox(height: 24),

          // Account Data Section
          _buildAccountDataSection(context),

          const SizedBox(height: 24),

          // GDPR Compliance Section
          _buildGDPRSection(context),

          const SizedBox(height: 24),

          // Privacy Resources
          _buildPrivacyResourcesSection(context),
        ],
      ),
    );
  }

  Widget _buildPrivacyScoreCard(BuildContext context, UserPreferences preferences) {
    final theme = Theme.of(context);
    final score = preferences.privacyScore;
    final scoreColor = _getScoreColor(theme, score);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.security_outlined,
                    color: scoreColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Privacy Score',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getScoreDescription(score),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scoreColor),
                  ),
                  child: Text(
                    '$score%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Privacy Score Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Level: ${_getPrivacyLevel(score)}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last updated: 2025-06-22 09:15:58',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSharingSection(BuildContext context, UserPreferences preferences) {
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
                  Icons.share_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Data Sharing Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Control how your data is used to improve our services and provide you with personalized experiences.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            PreferenceSwitchTile(
              title: 'Analytics Data Sharing',
              subtitle: 'Help improve app performance and user experience',
              icon: Icons.analytics_outlined,
              value: preferences.shareDataForAnalytics,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updatePrivacySettings(
                  shareDataForAnalytics: value,
                );
              },
            ),

            const SizedBox(height: 16),

            PreferenceSwitchTile(
              title: 'Marketing Data Sharing',
              subtitle: 'Receive personalized offers and product recommendations',
              icon: Icons.campaign_outlined,
              value: preferences.shareDataForMarketing,
              onChanged: (value) {
                context.read<ProfilePreferencesCubit>().updatePrivacySettings(
                  shareDataForMarketing: value,
                );
              },
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
                      'Your personal information is never sold to third parties. Data sharing only helps improve our services.',
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

  Widget _buildAccountDataSection(BuildContext context) {
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
                  Icons.folder_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Account Data Management',
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
                  color: theme.colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.download_outlined,
                  size: 20,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              title: const Text('Download Your Data'),
              subtitle: const Text('Export all your account data (GDPR compliant)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _exportUserData(context),
            ),

            const SizedBox(height: 8),

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
                  Icons.visibility_outlined,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
              ),
              title: const Text('View Data Usage'),
              subtitle: const Text('See how your data is being used'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showDataUsage(context),
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.delete_forever_outlined,
                  size: 20,
                  color: theme.colorScheme.error,
                ),
              ),
              title: const Text('Delete Account'),
              subtitle: const Text('Permanently delete your account and all data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGDPRSection(BuildContext context) {
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
                  Icons.gavel_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'GDPR Compliance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Your rights under the General Data Protection Regulation (GDPR):',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),

            ..._buildGDPRRights(theme),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGDPRRights(ThemeData theme) {
    final rights = [
      {'title': 'Right to Access', 'description': 'Request access to your personal data'},
      {'title': 'Right to Rectification', 'description': 'Request correction of inaccurate data'},
      {'title': 'Right to Erasure', 'description': 'Request deletion of your personal data'},
      {'title': 'Right to Portability', 'description': 'Request transfer of your data'},
      {'title': 'Right to Object', 'description': 'Object to processing of your data'},
    ];

    return rights.map((right) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  right['title']!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  right['description']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildPrivacyResourcesSection(BuildContext context) {
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
                  Icons.menu_book_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Privacy Resources',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Privacy Policy'),
              subtitle: const Text('Read our complete privacy policy'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => context.push('/legal/privacy'),
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.contact_support_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Data Protection Officer'),
              subtitle: const Text('Contact our DPO for privacy concerns'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => context.push('/contact/dpo'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(ThemeData theme, int score) {
    if (score >= 80) return theme.colorScheme.tertiary;
    if (score >= 60) return theme.colorScheme.secondary;
    return theme.colorScheme.error;
  }

  String _getScoreDescription(int score) {
    if (score >= 80) return 'Excellent privacy protection';
    if (score >= 60) return 'Good privacy protection';
    if (score >= 40) return 'Basic privacy protection';
    return 'Consider improving your privacy settings';
  }

  String _getPrivacyLevel(int score) {
    if (score >= 80) return 'High';
    if (score >= 60) return 'Medium';
    return 'Basic';
  }

  void _showPrivacyHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privacy Score',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your privacy score is calculated based on your data sharing preferences. Higher scores indicate better privacy protection.',
              ),
              SizedBox(height: 16),
              Text(
                'Data Sharing',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You can control how your data is used while still enjoying personalized experiences. All data sharing is optional.',
              ),
              SizedBox(height: 16),
              Text(
                'GDPR Rights',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You have full control over your personal data. You can request access, correction, or deletion at any time.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _exportUserData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Your Data'),
        content: const Text(
          'We\'ll prepare a complete export of your account data. This includes your profile, orders, reviews, and preferences. '
              'The download link will be sent to roshdology123@example.com within 24 hours.',
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
                  content: const Text('Data export request submitted. Check your email for updates.'),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
            child: const Text('Request Export'),
          ),
        ],
      ),
    );
  }

  void _showDataUsage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How Your Data is Used'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Analytics Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• App performance optimization\n• Feature usage analysis\n• Bug detection and fixing'),
              SizedBox(height: 16),
              Text(
                'Marketing Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Personalized product recommendations\n• Targeted promotions\n• Content customization'),
              SizedBox(height: 16),
              Text(
                'Account Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Order processing\n• Customer support\n• Account security'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '⚠️ Delete Account',
          style: TextStyle(color: theme.colorScheme.error),
        ),
        content: const Text(
          'This will permanently delete your account and all associated data. '
              'This action cannot be undone. Are you sure you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/profile/delete-account');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}